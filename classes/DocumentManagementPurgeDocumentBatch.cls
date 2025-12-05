/**
 * A batch job implementation responsible for purging documents older than five years 
 * from the system. This class handles both Salesforce Content Documents and their 
 * associated Document Management Store entries.
 *
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Niklas Hillgren      21/10/2025      Initial version
 * 
 * @author Niklas Hillgren
 * @version 1.0
 * @since 21/10/2025
 */
public with sharing class DocumentManagementPurgeDocumentBatch extends BatchJob {
    private static final Integer NUMBER_OF_DAYS_BEFORE_PURGE = Integer.valueOf(OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'DocumentManagementPurgeAfter'
    ));

    /**
     * Constant representing the cutoff date for document retention.
     * Used to determine which documents qualify for deletion.
     */
    private final Datetime PURGE_DAY = System.now().addDays(NUMBER_OF_DAYS_BEFORE_PURGE);

    /**
     * Client instance for interacting with the document management system.
     */
    private final DocumentManagementClient documentClient;

    /**
     * Service layer for database operations.
     */
    private final DatabaseService dbService;

    /**
     * Query selector
     */
    private final DocumentManagementSelector documentSelector;

    public DocumentManagementPurgeDocumentBatch() {
        this(SingletonFactory.getFactory());
    }

    private DocumentManagementPurgeDocumentBatch(SingletonFactory singletonFactory) {
        this.documentClient = (DocumentManagementClient) singletonFactory.getOrRegisterSingleton(
            DocumentManagementClient.class
        );

        this.dbService = (DatabaseService) singletonFactory.getOrRegisterSingleton(DatabaseService.class);

        this.documentSelector = (DocumentManagementSelector) singletonFactory.getOrRegisterSingleton(DocumentManagementSelector.class);
    }

    public override String getJobName() {
        return 'DocumentManagementPurgeDocumentBatch';
    }

    /**
     * Implements the start method of Batchable interface.
     * Queries ContentDocuments that meet purge criteria:
     * - Created more than 5 years ago
     * - Have related ContentVersions with DocumentManagementStoreId__c
     * 
     * @param bc BatchableContext object
     * @return QueryLocator for batch processing
     */
    public override Database.QueryLocator startBatch(Database.BatchableContext bc) {
        return documentSelector.getContentDocumentAndContentVersionUploadedToStore(PURGE_DAY);
    }

    /**
     * Executes the actual deletion logic for a chunk of documents
     *
     * @param bc   BatchableContext containing batch job parameters
     * @param scope List of ContentDocument objects to process
     */
    public override void executeBatchChunk(Database.BatchableContext bc, List<SObject> scope) {
        Logger.logInfo(String.format('execute( {0}, {1} )', new List<Object>{ bc, scope }));

        if(scope == null || scope.isEmpty()){
            return;
        }

        List<ContentDocument> contentDocumentToDelete = new List<ContentDocument>();

        try {
            Map<Id, ContentDocument> batchScope = new Map<Id, ContentDocument>((List<ContentDocument>) scope);

            for (Id contentDocumentId : batchScope.keySet()) {
                ContentDocument doc = batchScope.get(contentDocumentId);

                //We can only delete the contentDocument if all the related document
                //in document store has been deleted
                Boolean isAllContentVersionInDocumentStoreDeleted = true;

                for(ContentVersion contVersion : doc.ContentVersions){
                    if (contVersion.DocumentManagementStoreId__c != null) {
                        try {
                            //This call delete the document on document storage side utilizing the document API
                            documentClient.deleteDocument(contVersion.DocumentManagementStoreId__c);
                            Logger.logInfo(
                                String.format(
                                    'DocumentId: {0} is deleted and can not be found in document store.',
                                    new List<Object>{ contVersion.DocumentManagementStoreId__c }
                                )
                            );
                        } catch (HTTPException ex) {
                            if (ex.getStatusCode() != 404) {
                                //404 is expected when we try to delete a document that does not exist
                                isAllContentVersionInDocumentStoreDeleted = false;
                                Logger.logInfo(
                                    String.format(
                                        'DocumentId: {0} has unknown state in document store.',
                                        new List<Object>{ contVersion.DocumentManagementStoreId__c }
                                    )
                                );

                                Logger.logError(ex);
                            }
                        }
                    }
                }

                if(isAllContentVersionInDocumentStoreDeleted ){
                    contentDocumentToDelete.add(new ContentDocument(Id = contentDocumentId));
                }
            }

            TriggerHandler.byPass('ContentDocumentTriggerHandler');
            dbService.deleteRecords(contentDocumentToDelete);
        } catch (Exception ex) {
            logger.logError(ex);
        }
    }

    /**
     * Called after all batches are processed
     *
     * @param bc BatchableContext containing batch job parameters
     */
    public override void finishBatch(Database.BatchableContext bc) {
        Logger.logInfo(String.format('finishBatch( {0} )', new List<Object>{ bc }));
    }
}