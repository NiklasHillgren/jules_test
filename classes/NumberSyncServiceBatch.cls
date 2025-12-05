/**
 * @description This batch job is used to update the phone number reservations for all accounts.
 *              It serves as an example of how to implement the abstract BatchJob class.
 *              It iterates through all Account_Phone_Number_Series__c records and calls the NumberSyncService to synchronize the assignments.
 *              -----------------------------------------------------------------------------
 *              Developer            Date            Description
 *              -----------------------------------------------------------------------------
 *              Kenneth Houkjær      06/10/2025      Initial version.
 *              Kenneth Houkjær      06/10/2025      Refactored to use the new BatchJob framework.
 *
 * @author Kenneth Houkjær
 * @date 06/10/2025
 */
public class NumberSyncServiceBatch extends BatchJob {
    private final BatchJobSelector batchJobSel;

    @TestVisible
    private NumberSyncService numberSyncService;

    /**
     * @description The default constructor, which retrieves dependencies from the SingletonFactory.
     */
    public NumberSyncServiceBatch() {
        this(SingletonFactory.getFactory());
    }

    /**
     * @description The private constructor for dependency injection.
     * @param singletonFactory The factory to get dependencies from.
     */
    private NumberSyncServiceBatch(SingletonFactory singletonFactory) {
        this.numberSyncService = (NumberSyncService) singletonFactory.getOrRegisterSingleton(NumberSyncService.class);
        this.batchJobSel = (BatchJobSelector) singletonFactory.getOrRegisterSingleton(BatchJobSelector.class);
    }

    /**
     * @description This method is called at the beginning of the batch job by the framework.
     * @param bc The batchable context, provided by the system.
     * @return A Database.QueryLocator for the records to process.
     */
    public override Database.QueryLocator startBatch(Database.BatchableContext bc) {
        String query = batchJobSel.getNumberSyncServiceBatchQueryImpl();
        return Database.getQueryLocator(query);
    }
    
    /**
     * @description This method is called for each batch of records by the framework.
     * @param bc The batchable context, provided by the system.
     * @param scope The list of SObjects to process for this chunk.
     */
    public override void executeBatchChunk(Database.BatchableContext bc, List<SObject> scope) {
        for(SObject obj : scope) {
            try {
                this.numberSyncService.synchronizeAssignmentsForAccount((Account)obj);
            } catch (Exception e) {
                Logger.logError(this.getJobName(), 'Error processing Account ' + ((Account)obj).Id + ': ' + e.getMessage());
            }
        }
    }

    /**
     * @description This method is called at the end of the batch job by the framework.
     * @param bc The batchable context, provided by the system.
     */
    public override void finishBatch(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :bc.getJobId()];
        Logger.logInfo(this.getJobName() + ' finished. Job ID: ' + bc.getJobId() + ', Status: ' + job.Status + ', Errors: ' + job.NumberOfErrors);
    }
}