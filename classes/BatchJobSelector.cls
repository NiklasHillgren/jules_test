/**
 * @description This class is used to hold all batch job queries.
 * @author Kenneth Houkjaer
 * 
 */
public virtual with sharing class BatchJobSelector {
    private static BatchJobSelector instance = new BatchJobSelector();

    @TestVisible
    private static void setMock(BatchJobSelector mockInstance) {
        instance = mockInstance;
    }

    /**
     * @description This method returns the query for the BatchUpdateNumberSyncService batch job.
     * @return The query for the BatchUpdateNumberSyncService batch job.
     */
    public static String getBatchUpdateNumberSyncServiceQuery() {
        return instance.getBatchUpdateNumberSyncServiceQueryImpl();
    }
    

    /**
     * @description This method returns the query for the BatchUpdateNumberSyncService batch job.
     * @return The query for the BatchUpdateNumberSyncService batch job.
     */
    public virtual String getBatchUpdateNumberSyncServiceQueryImpl() {
        return new Query('Account_Phone_Number_Series__c')
            .selectFields(new List<String>{ 'Id', 'Account__c',  'Name', 'Number_Group__c', 'Number_Location__c', 'CVR__c', 'account__r.CVR__c', 'Number_Pattern__c', 'Product_type__c' })
            .toQueryString();
    }

    /**
     * @description This method returns a list of active batch job settings.
     * @return A list of active batch job settings.
     * @author Kenneth Houkjaer
     */
    public static List<Batch_Job_Settings__mdt> getActiveBatchJobSettings() {
        return instance.getActiveBatchJobSettingsImpl();
    }

    /**
     * @description This method returns a list of active batch job settings.
     * @return A list of active batch job settings.
     * @author Kenneth Houkjaer
     */
    public virtual List<Batch_Job_Settings__mdt> getActiveBatchJobSettingsImpl() {
        return (List<Batch_Job_Settings__mdt>) new Query('Batch_Job_Settings__mdt')
            .selectFields(new List<String>{ 'Job_Name__c', 'Is_Active__c' })
            .addConditionEq('Is_Active__c', true)
            .run();
    }

    /**
     * @description This method returns a list of cron triggers by job name.
     * @param jobName The name of the job to return the cron triggers for.
     * @return A list of cron triggers.
     * @author Kenneth Houkjaer
     */
    public static List<CronTrigger> getCronTriggersByJobName(String jobName) {
        return instance.getCronTriggersByJobNameImpl(jobName);
    }

    /**
     * @description This method returns a list of cron triggers by job name.
     * @param jobName The name of the job to return the cron triggers for.
     * @return A list of cron triggers.
     * @author Kenneth Houkjaer
     */
    public virtual List<CronTrigger> getCronTriggersByJobNameImpl(String jobName) {
        return (List<CronTrigger>) new Query('CronTrigger')
            .selectFields(new List<String>{ 'Id' })
            .addConditionEq('CronJobDetail.Name', jobName)
            .run();
    }
}