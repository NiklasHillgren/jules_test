/**
 * @description This batch job is used to update the phone number reservations for all accounts.
 * It iterates through all Account_Phone_Number_Series__c records and calls the NumberSyncService to synchronize the assignments.
 * @author Kenneth Houkjaer
 * 
 */
public class BatchUpdateNumberSyncService extends BatchJob {
    @TestVisible
    private NumberSyncService numberSyncService;

    /**
     * @description The constructor for the BatchUpdateNumberSyncService class.
     * It initializes the numberSyncService.
     * @author Kenneth Houkjaer
     */
    public BatchUpdateNumberSyncService() {
        this.numberSyncService = new NumberSyncService();
    }

    /**
     * @description This method is called at the beginning of the batch job.
     * It returns a Database.QueryLocator that retrieves the records to be processed.
     * @param bc The batchable context.
     * @return A Database.QueryLocator.
     * @author Kenneth Houkjaer
     */
    public override Database.QueryLocator start(Database.BatchableContext bc) {
        Logger.logInfo(this.getJobName() + ' started. Job ID: ' + bc.getJobId());
        String query = 'select id from Account where id in (select Account__c from account_phone_number_series__c)'; 

        return Database.getQueryLocator(query);
    }
    

    /**
     * @description This method is called for each batch of records.
     * It iterates through the records and calls the NumberSyncService to synchronize the assignments.
     * @param bc The batchable context.
     * @param scope The list of records to process.
     * @author Kenneth Houkjaer
     */
    public override void execute(Database.BatchableContext bc, List<SObject> scope) {

        for(SObject obj : scope) {
            try {
                this.numberSyncService.synchronizeAssignmentsForAccount((Account)obj);
            } catch (Exception e) {
                Logger.logError(this.getJobName(), 'Error processing Account ' + ((Account)obj).Id + ': ' + e.getMessage());
            }
        }
    }

    /**
     * @description This method is called at the end of the batch job.
     * It logs a message and emits the logs.
     * @param bc The batchable context.
     * @author Kenneth Houkjaer
     */
    public override void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :bc.getJobId()];
        Logger.logInfo(this.getJobName() + ' finished. Job ID: ' + bc.getJobId() + ', Status: ' + job.Status + ', Errors: ' + job.NumberOfErrors);
        Logger.emit();
    }
}