/**
 * @description This class centralizes all SOQL queries related to the BatchJob framework.
 *              It provides a layer of abstraction for retrieving batch job settings,
 *              scheduled jobs (CronTrigger), and running jobs (AsyncApexJob).
 *              -----------------------------------------------------------------------------
 *              Developer            Date            Description
 *              -----------------------------------------------------------------------------
 *              Kenneth Houkjær      06/10/2025      Initial version.
 *              Jules                07/10/2025      Added full documentation.
 *
 * @author Kenneth Houkjær
 * @date 06/10/2025
 */
public virtual with sharing class BatchJobSelector {
    /**
     * @description The implementation for getting the NumberSyncServiceBatch query.
     * @return The SOQL query string.
     */
    public virtual String getNumberSyncServiceBatchQueryImpl() {
        Query subQuery = new Query('account_phone_number_series__c').selectField('Account__c');
        return 'SELECT Id FROM Account WHERE Id IN (' + subQuery.toQueryString() + ')';
    }

    /**
     * @description The implementation for retrieving active, root-level batch job settings.
     * @return A list of active, root-level batch job settings.
     */
    public virtual List<Batch_Job_Settings__mdt> getActiveBatchJobSettingsImpl() {
        return (List<Batch_Job_Settings__mdt>) new Query('Batch_Job_Settings__mdt')
            .selectFields(new List<String>{ 'Job_Name__c', 'Is_Active__c' })
            .addConditionEq('Is_Active__c', true)
            .addConditionEq('Parent_Job__c', null) // Only return root-level jobs
            .run();
    }

    /**
     * @description The implementation for retrieving cron triggers by job name.
     * @param jobName The name of the job to find cron triggers for.
     * @return A list of cron triggers.
     */
    public virtual List<CronTrigger> getCronTriggersByJobNameImpl(String jobName) {
        return (List<CronTrigger>) new Query('CronTrigger')
            .selectFields(new List<String>{ 'Id' })
            .addConditionEq('CronJobDetail.Name', jobName)
            .run();
    }

    /**
     * @description The implementation for retrieving running or queued jobs by job name.
     * @param jobName The name of the job (Apex class name) to find running instances of.
     * @return A list of AsyncApexJob records.
     */
    public virtual List<AsyncApexJob> getRunningJobsByJobNameImpl(String jobName) {
        return (List<AsyncApexJob>) new Query('AsyncApexJob')
            .selectFields(new List<String>{ 'Id' })
            .addConditionEq('ApexClass.Name', jobName)
            .addConditionIn('Status', new List<String>{ 'Processing', 'Preparing', 'Queued' })
            .run();
    }

    /**
     * @description The implementation for retrieving active child job settings.
     * @param parentJobName The name of the parent job.
     * @return A list of active child batch job settings.
     */
    public virtual List<Batch_Job_Settings__mdt> getChildJobSettingsImpl(String parentJobName) {
        return (List<Batch_Job_Settings__mdt>) new Query('Batch_Job_Settings__mdt')
            .selectFields(new List<String>{ 'Job_Name__c' })
            .addConditionEq('Is_Active__c', true)
            .addConditionEq('Parent_Job__c', parentJobName)
            .run();
    }
}