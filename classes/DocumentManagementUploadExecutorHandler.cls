public with sharing class DocumentManagementUploadExecutorHandler implements IEventExecutableHandler {
    private final DocumentManagementService documentManagementService;
    private final DatabaseService dataBaseService;

    public DocumentManagementUploadExecutorHandler() {
        this(SingletonFactory.getFactory());
    }

    private DocumentManagementUploadExecutorHandler(SingletonFactory singletonFactory) {
        this.dataBaseService = (DatabaseService) singletonFactory.getOrRegisterSingleton(DatabaseService.class);
        this.documentManagementService = (DocumentManagementService) singletonFactory.getOrRegisterSingleton(
            DocumentManagementService.class
        );
    }

    /**
     * @description Parses the provided JSON Parameters into EventExecutorExampleImpl.parameter
     */
    public Parameters parseParameters(String parameters) {
        Logger.logInfo(String.format('parseParameters( {0} )', new List<Object>{ parameters }));

        if (parameters == null) {
            return null;
        }

        return (Parameters) System.JSON.deserialize(parameters, Parameters.class);
    }

    public void execute(EventExecutor__e event) {
        Logger.logInfo(String.format('execute( {0} )', new List<Object>{ event }));

        ContentVersion toBeUpdated = new ContentVersion();

        Exception exThrown = null;

        try {
            Parameters params = parseParameters(event.Parameters__c);

            //File information
            ContentVersion existingContentVersion = documentManagementService.getContentVersion(
                params.contentVersionId
            );

            toBeUpdated.Id = existingContentVersion.Id;

            Id parentEntityId = getParentEntityId(existingContentVersion);

            Account parentAccount = documentManagementService.getParentAccount(existingContentVersion, parentEntityId);

            DocumentManagementClientRequestDTO.Document docRequest = documentManagementService.createDocumentManagementClientRequestDTO(
                parentAccount,
                parentEntityId,
                existingContentVersion
            );

            DocumentManagementClientResponseDTO.Document respDoc = documentManagementService.createDocument(docRequest);

            if (respDoc.Id != null) {
                toBeUpdated.DocumentManagementStoreId__c = respDoc.Id;
                toBeUpdated.DocumentManagementCompletedDate__c = System.now();
                toBeUpdated.DocumentManagementError__c = null;
            }else{
                throw new DocumentManagmentException('A document Id was expected to be returned from the documentManagementService.createDocument.');
            }
        } catch (Exception ex) {
            Logger.logError(ex);
            exThrown = ex;

            //Reset the fields
            toBeUpdated.DocumentManagementCompletedDate__c = null;
            toBeUpdated.DocumentManagementError__c = ex.getMessage();
        } finally {
            try{
                dataBaseService.updateRecord(toBeUpdated);            
            }catch(Exception ex){
                //We can end up here if we get a DML exception - it's not funny....
                exThrown = ex;
            }
        }

        //If we havn't set DocumentManagementStoreId__c something has gone wrong...
        if (toBeUpdated.DocumentManagementStoreId__c == null) {
            throw new EventExecutorRetryException(exThrown);
        }
    }

    private Id getParentEntityId(ContentVersion contentVersion) {
        List<ContentDocumentLink> contentDocumentLinks = documentManagementService.getContentDocumentLinks(
            new Set<Id>{ contentVersion.ContentDocumentId }
        );

        return documentManagementService.getParentEntityId(contentDocumentLinks);
    }

    public class Parameters {
        public String contentVersionId;
    }
}
