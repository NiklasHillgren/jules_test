/**
 * @author Kenneth Houkjær
 * @date 25/07/2024
 * @description A service class for the Document Management API
 */
public with sharing class DocumentManagementService {
    private final DocumentManagementClient documentManagementClient;
    private final DocumentManagementSelector documentManagementSelector;
    private final DatabaseService databaseService;

    public DocumentManagementService() {
        this(SingletonFactory.getFactory());
    }

    private DocumentManagementService(SingletonFactory singletonFactory) {
        this.documentManagementClient = (DocumentManagementClient) singletonFactory.getOrRegisterSingleton(
            DocumentManagementClient.class
        );

        this.databaseService = (DatabaseService) singletonFactory.getOrRegisterSingleton(DatabaseService.class);

        this.documentManagementSelector =  (DocumentManagementSelector) singletonFactory.getOrRegisterSingleton(DocumentManagementSelector.class);
    }

    /**
     * Prepares documents for storage.
     * 
     * The function takes in a list of contentversion and filter out those that shoudln't be stored.
     * 
     * If the contentversion should be stored it set the following fields:
     * 
     * DocumentManagementIsStored__c = true
     * DocumentManagementInitDate__c = System.now()
     * 
     * @param contentVersions List of ContentVersion objects to check for storage
     * @return List of new ContentVersion records marked for storage
     */
    public List<ContentVersion> prepareDocumentsForStorage(List<ContentVersion> contentVersions) {
        Logger.logInfo(String.format('prepareDocumentsForStorage( {0} )', new List<Object>{ contentVersions }));

        List<ContentVersion> storedDocuments = new List<ContentVersion>();

        for (ContentVersion contentVersion : contentVersions) {
            ContentVersion newVersion = new ContentVersion(Id = contentVersion.Id,
                                                           DocumentManagementStoreId__c = null);
            
            if (isStoredInDocumentStore(contentVersion)) {
                newVersion.DocumentManagementIsStored__c = true;
                newVersion.DocumentManagementInitDate__c = System.now();
            }

            //Update the document if it's stored OR if we have an inhereted value of DocumentManagementStoreId__c (then set that that null)
            if( newVersion.DocumentManagementIsStored__c || contentVersion.DocumentManagementStoreId__c != null ){
                storedDocuments.add(newVersion);
            }
        }

        return storedDocuments;
    }


    /**
     * Checks if a ContentVersion is stored in the document store.
     * This method assumes the provided content version is the latest version.
     * 
     * For version 1 documents, checks FirstPublishLocationId against specific types.
     * For subsequent versions, relies on inherited DocumentManagementIsStored__c flag.
     * 
     * @param contentVersion The ContentVersion record to check
     * @return True if the document is stored, false otherwise
     */
    private Boolean isStoredInDocumentStore(ContentVersion contentVersion) {
        Logger.logInfo(String.format('isStoredInDocumentStore( {0} )', new List<Object>{ contentVersion }));

        if (contentVersion.VersionNumber == '1') {
            if (contentVersion.FirstPublishLocationId != null) {
                SObjectType sobjType = contentVersion.FirstPublishLocationId.getSObjectType();

                switch on sobjType.newSobject() {
                    when porting__c powerOfAttorney {
                        return true;
                    }
                    when else {
                        Logger.logWarning(String.format('sobjectType: {0} not supported for the file {1} ', new List<Object>{ sobjType, contentVersion }));
                    }
                }
            }
        }

        // Important: Salesforce core persistence of new content version inherits DocumentManagementIsStored__c
        // from previous version if not explicitly set
        return contentVersion.DocumentManagementIsStored__c;
    }

    /**
     * Creates event executors for document upload processing based on changes on the contentversion.
     * 
     * When DocumentManagementIsStored__c is true and DocumentManagementInitDate__c has been it create an executor.
     * 
     * 
     * @param newMap Map containing new ContentVersion records
     * @param oldMap Map containing previous ContentVersion records
     * @return List of EventExecutor__e objects configured for upload file through the document api
     */
    public List<EventExecutor__e> getUploadExecutorHandlers(
        Map<Id, ContentVersion> newMap,
        Map<Id, ContentVersion> oldMap
    ) {
        Logger.logInfo(String.format('getUploadExecutorHandlers( {0}, {1} )', new List<Object>{ newMap, oldMap }));

        List<EventExecutor__e> executors = new List<EventExecutor__e>();

        for (ContentVersion newVersion : newMap.values()) {
            ContentVersion oldVersion = oldMap.get(newVersion.Id);

            if (newVersion.DocumentManagementIsStored__c && newVersion.DocumentManagementInitDate__c != null) {
                if (newVersion.DocumentManagementInitDate__c != oldVersion.DocumentManagementInitDate__c) {
                    if()
                    EventExecutor__e executor = new EventExecutor__e(
                        Executor__c = 'DocumentManagementUploadExecutorHandler',
                        Parameters__c = '{"contentVersionId":"' + newVersion.Id + '"}'
                    );

                    executors.add(executor);
                }
            }
        }

        return executors;
    }

    public Id getParentEntityId( List<ContentDocumentLink> contentDocumentLinks ){
        Logger.logInfo(String.format('getParentEntityId( {0} )', new List<Object>{ contentDocumentLinks }));

        Id parentId = null;

        for(ContentDocumentLink documentLink : contentDocumentLinks){
            SobjectType parentSobjectType = documentLink.LinkedEntityId.getSObjectType();

            switch on parentSobjectType.newSobject() {
                when User userEntity {
                    continue;
                }
                when else {
                    parentId = documentLink.LinkedEntityId;
                }
            }

            if(parentId != null){
                return parentId;
            }
        }

        //Should only reach this point if parentId is null
        return parentId;
    }

    /**
     * Takes a file as input and determine what account is considering it's owner
     */
    public Account getParentAccount(ContentVersion contentVersion, Id parentEntityId){
        Logger.logInfo(String.format('getParentAccount( {0}‚ {1} )', new List<Object>{ contentVersion, parentEntityId }));

        Account relatedAccount = null;

        SobjectType parentSobjectType = parentEntityId.getSObjectType();

        switch on parentSobjectType.newSobject() {
            when porting__c powerOfAttorney {
                relatedAccount = documentManagementSelector.getAccountByPortingId(parentEntityId).Account__r;
            }
            when else {
                Logger.logWarning(String.format('parentSobjectType not supported fallback to contentVersion.DocumentManagementParentAccount__c )', new List<Object>{ contentVersion }));
            }
        }

        return relatedAccount;
    }

    public String getBase64EncodedVersionData(ContentVersion contentVersion){
        Logger.logInfo(String.format('getBase64EncodedVersionData( {0} )', new List<Object>{ contentVersion }));

        String base64EncodedFileContent = null;

        //VersionData is a blob
        if(contentVersion.VersionData != null){
            base64EncodedFileContent = EncodingUtil.base64Encode(contentVersion.VersionData);
        }

        return base64EncodedFileContent;
    }

        public DocumentManagementClientRequestDTO.Document createDocumentRequest(ContentVersion version){
        DocumentManagementClientRequestDTO.Document documentRequest;

        return documentRequest;
    }

    /*** FUNCTIONS BELOW THIS LINE JUST CALL THE DocumentManagementClient ENDPOINT ***/
    public DocumentManagementClientRequestDTO.Document createDocumentManagementClientRequestDTO(Account parentAccount, Id parentEntityId, ContentVersion contentVersion){
        DocumentManagementClientRequestDTO.Document doc = new DocumentManagementClientRequestDTO.Document();
        doc.type = parentEntityId.getSObjectType().getDescribe().getLabel();
        doc.name = contentVersion.Title;

        DocumentManagementClientRequestDTO.DocumentCharacteristic dc = new DocumentManagementClientRequestDTO.DocumentCharacteristic();
        dc.name = 'brand';
        dc.value = 'teliadk';

        DocumentManagementClientRequestDTO.DocumentCharacteristic dc2 = new DocumentManagementClientRequestDTO.DocumentCharacteristic();
        dc2.name = 'customerId';

        if(parentAccount != null ){
            dc2.value = parentAccount.Id; //Should be specified by customer API (customerId)
        } else {
            //If we want we can set this manually!
            dc2.value = 'contentVersion.DocumentManagementCustomerId';
        }
        doc.documentCharacteristic = new List<DocumentManagementClientRequestDTO.DocumentCharacteristic>{ dc, dc2 };

        DocumentManagementClientRequestDTO.Attachment att = new DocumentManagementClientRequestDTO.Attachment();
        att.id = contentVersion.Id;
        att.name = contentVersion.PathOnClient;
        att.mimeType = 'application/pdf';
        att.type = doc.type; //TODO setting this to the label of the parentEntityType
        att.url = 'data:application/pdf;base64,'+getBase64EncodedVersionData(contentVersion);

        doc.attachment = new List<DocumentManagementClientRequestDTO.Attachment>{ att };

        return doc;
    }

    /**
     * @description Finds documents based on the given search criteria
     * @param searchCriteria A map of search criteria
     * @return A list of documents
     */
    public List<DocumentManagementClientResponseDTO.Document> findDocuments(Map<Object, Object> searchCriteria) {
        return documentManagementClient.findDocuments(searchCriteria);
    }

    public DocumentManagementClientResponseDTO.Document createDocument(DocumentManagementClientRequestDTO.Document doc) {
        return documentManagementClient.createDocument(doc);
    }

    public List<ContentDocumentLink> getContentDocumentLinks( Set<Id> contentDocumentIds ){
        return documentManagementSelector.getContentDocumentLinks(contentDocumentIds);

    }

    public ContentVersion getContentVersion(Id contentVersionId){
        return documentManagementSelector.getContentVersion(contentVersionId);
    }

    // /**
    //  * @description Creates a new document
    //  * @param doc The document to create
    //  * @return The created document
    //  */
    // public DocumentManagementClient.Document createDocument(DocumentManagementClient.Document doc) {
    //     return DocumentManagementClient.createDocument(doc);
    // }

    // /**
    //  * @description Gets a document by its ID
    //  * @param documentId The ID of the document to get
    //  * @return The document
    //  */
    // public DocumentManagementClient.Document getDocument(String documentId) {
    //     return DocumentManagementClient.getDocument(documentId);
    // }

    // /**
    //  * @description Deletes a document by its ID
    //  * @param documentId The ID of the document to delete
    //  * @return True if the document was deleted successfully, false otherwise
    //  */
    // public Boolean deleteDocument(String documentId) {
    //     return DocumentManagementClient.deleteDocument(documentId);
    // }
}
