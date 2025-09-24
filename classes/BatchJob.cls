/**
 * @description This abstract class is the base class for all batch jobs.
 * It provides a basic structure for batch jobs, including logging and error handling.
 * It also provides default implementations for the schedule and execute methods.
 * @author Kenneth Houkjaer
 */
public abstract class BatchJob implements IBatchJob, Database.Batchable<SObject>, Database.Stateful, Schedulable, Database.AllowsCallouts {
    private static final String DEFAULT_CRON_EXPRESSION = '0 0 0 * * ? *';
    private static final Integer DEFAULT_BATCH_SIZE = 200;

    
    /**
     * @description This method is called at the beginning of the batch job.
     * It should return a Database.QueryLocator that retrieves the records to be processed.
     * @param bc The batchable context.
     * @return A Database.QueryLocator.
     * @author Kenneth Houkjaer
     */
    public abstract Database.QueryLocator start(Database.BatchableContext bc);

    /**
     * @description This method is called for each batch of records.
     * It should contain the logic to be executed for each record.
     * @param bc The batchable context.
     * @param scope The list of records to process.
     * @author Kenneth Houkjaer
     */
    public abstract void execute(Database.BatchableContext bc, List<SObject> scope);

    /**
     * @description This method is called at the end of the batch job.
     * It can be used to send a summary email or perform other cleanup tasks.
     * @param bc The batchable context.
     * @author Kenneth Houkjaer
     */
    public abstract void finish(Database.BatchableContext bc);

    /**
     * @description This method is used to schedule the batch job.
     * It uses the cron expression returned by the getCronExpression method.
     * @author Kenneth Houkjaer
     */
    public virtual void schedule() {
        String jobName = this.getJobName();
        String cronExpression = this.getCronExpression();
        System.schedule(jobName, cronExpression, this);
        Logger.logInfo('Successfully scheduled job ' + jobName + ' with cron expression: ' + cronExpression);
    }

    /**
     * @description This method is used to execute the batch job immediately.
     * It uses the batch size returned by the getBatchSize method.
     * @author Kenneth Houkjaer
     */
    public virtual void execute() {
        Database.executeBatch(this, this.getBatchSize());
        Logger.emit();
    }
    

    /**
     * @description This method is called by the scheduler.
     * It executes the batch job.
     * @param sc The schedulable context.
     * @author Kenneth Houkjaer
     */
    public void execute(SchedulableContext sc) {
        this.execute();
    }

    /**
     * @description This method returns the name of the job.
     * By default, it returns the name of the class.
     * @return The name of the job.
     * @author Kenneth Houkjaer
     */
    public virtual String getJobName() {
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }

    /**
     * @description This method returns the cron expression for the job.
     * It retrieves the cron expression from the Batch_Job_Settings__mdt custom metadata type.
     * If no cron expression is found for the job, it returns a default cron expression.
     * @return The cron expression for the job.
     * @author Kenneth Houkjaer
     */
    private Batch_Job_Settings__mdt settings;

    private Batch_Job_Settings__mdt getSettings() {
        if (settings == null) {
            String jobName = this.getJobName();
            List<Batch_Job_Settings__mdt> settingsList = [SELECT Cron_Expression__c, Batch_Size__c FROM Batch_Job_Settings__mdt WHERE Job_Name__c = :jobName LIMIT 1];
            if (!settingsList.isEmpty()) {
                settings = settingsList[0];
            }
        }
        return settings;
    }

    public virtual String getCronExpression() {
        Batch_Job_Settings__mdt jobSettings = getSettings();
        if (jobSettings != null && String.isNotBlank(jobSettings.Cron_Expression__c)) {
            return jobSettings.Cron_Expression__c;
        }
        return DEFAULT_CRON_EXPRESSION;
    }

    /**
     * @description This method returns the batch size for the job.
     * By default, it returns a batch size of 200.
     * @return The batch size for the job.
     * @author Kenneth Houkjaer
     */
    public virtual Integer getBatchSize() {
        Batch_Job_Settings__mdt jobSettings = getSettings();
        if (jobSettings != null && jobSettings.Batch_Size__c != null) {
            return Integer.valueOf(jobSettings.Batch_Size__c);
        }
        return DEFAULT_BATCH_SIZE;
    }
}