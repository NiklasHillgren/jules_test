/**
 * @description This abstract class is the base for all batch jobs in the framework. It provides a robust
 *              structure for creating stateful, chainable, and observable batch jobs. It handles the core
 *              logic for connected logging, metadata-driven job chaining, scheduling, and execution,
 *              and now includes guaranteed log emission via try-catch-finally blocks.
 *              -----------------------------------------------------------------------------
 *              Developer            Date            Description
 *              -----------------------------------------------------------------------------
 *              Kenneth Houkjær      06/10/2025      Initial version.
 *              Jules                07/10/2025      Refactored to use BatchJobManagementService and restored documentation.
 *
 * @author Kenneth Houkjær
 * @date 06/10/2025
 */
public abstract class BatchJob implements IBatchJob, Database.Batchable<SObject>, Database.Stateful, Schedulable, Database.AllowsCallouts {
    private static final String DEFAULT_CRON_EXPRESSION = '0 0 0 * * ? *';
    private static final Integer DEFAULT_BATCH_SIZE = 200;

    @TestVisible
    private String correlationId;

    /**
     * @description The method that must be implemented by subclasses to define the start of the batch job.
     * @param bc The batchable context, provided by the system.
     * @return A Database.QueryLocator that retrieves the records to be processed.
     */
    public abstract Database.QueryLocator startBatch(Database.BatchableContext bc);

    /**
     * @description The method that must be implemented by subclasses to define the logic for each batch chunk.
     * @param bc The batchable context, provided by the system.
     * @param scope The list of records to process for this chunk.
     */
    public abstract void executeBatchChunk(Database.BatchableContext bc, List<SObject> scope);

    /**
     * @description The method that must be implemented by subclasses to define the finish logic of the batch job.
     * @param bc The batchable context, provided by the system.
     */
    public abstract void finishBatch(Database.BatchableContext bc);

    /**
     * @description The framework's `start` method. This is the entry point for the batch job execution.
     *              It sets up the correlation ID for logging and calls the subclass's `startBatch` method.
     *              This method should not be overridden by subclasses.
     * @param bc The batchable context.
     * @return A Database.QueryLocator.
     */
    public virtual Database.QueryLocator start(Database.BatchableContext bc) {
        try {
            if (String.isBlank(this.correlationId)) {
                this.correlationId = Logger.getTraceId();
            } else {
                Logger.setTraceId(this.correlationId);
            }
            Logger.logInfo('Starting batchjob ' + getJobName());
            return this.startBatch(bc);
        } catch (Exception ex) {
            Logger.logError(this.getJobName(), 'An unhandled exception occurred in start(): ' + ex.getMessage() + ' Stacktrace: ' + ex.getStackTraceString());
            throw ex;
        } finally {
            Logger.emit();
        }
    }

    /**
     * @description The framework's `execute` method. It ensures the logger's trace ID is set
     *              and then calls the subclass's `executeBatchChunk` method.
     * @param bc The batchable context.
     * @param scope The list of records to process.
     */
    public virtual void execute(Database.BatchableContext bc, List<SObject> scope){
        try {
            Logger.setTraceId(this.correlationId);
            Logger.logInfo('Executing chunk for ' + getJobName());
            this.executeBatchChunk(bc, scope);
        } catch (Exception ex) {
            Logger.logError(this.getJobName(), 'An unhandled exception occurred in execute(): ' + ex.getMessage() + ' Stacktrace: ' + ex.getStackTraceString());
            throw ex;
        } finally {
            Logger.emit();
        }
    }
 
    /**
     * @description The framework's `finish` method. It calls the subclass's `finishBatch` method and then
     *              handles the execution of any child jobs defined in metadata.
     * @param bc The batchable context.
     */
    public virtual void finish(Database.BatchableContext bc) {
        try {
            Logger.setTraceId(this.correlationId);
            Logger.logInfo('Finishing batchjob ' + getJobName());
            this.finishBatch(bc);
            
            BatchJobManagementService batchjobService = new BatchJobManagementService();
            
            
            List<Batch_Job_Settings__mdt> childJobSettings = batchjobService.getChildJobSettings(this.getJobName());
            if (childJobSettings != null && !childJobSettings.isEmpty()) {
                Logger.logInfo('Chaining to ' + childJobSettings.size() + ' child job(s) defined in metadata.');
                for (Batch_Job_Settings__mdt setting : childJobSettings) {
                    IBatchJob nextJob = batchjobService.getBatchJob(setting.Job_Name__c);
                    if (nextJob != null) {
                        if (nextJob instanceof BatchJob) {
                            ((BatchJob)nextJob).correlationId = this.correlationId;
                        }
                        Database.executeBatch((Database.Batchable<SObject>)nextJob, nextJob.getBatchSize());
                    }
                }
            }
        } catch (Exception ex) {
            Logger.logError(this.getJobName(), 'An unhandled exception occurred in finish(): ' + ex.getMessage() + ' Stacktrace: ' + ex.getStackTraceString());
            throw ex;
        } finally {
            Logger.emit();
        }
    }

    /**
     * @description This method is used to schedule the batch job based on its cron expression.
     */
    public virtual void schedule() {
        String jobName = this.getJobName();
        String cronExpression = this.getCronExpression();
        if(String.isNotBlank(cronExpression)) {
            System.schedule(jobName, cronExpression, this);
            Logger.logInfo('Successfully scheduled job ' + jobName + ' with cron expression: ' + cronExpression);
        } else {
            Logger.logWarning('Job ' + jobName + ' cannot be scheduled as it has no cron expression (it may be a child job).');
        }
    }

    /**
     * @description This method is used to execute the batch job immediately.
     */
    public virtual void execute() {
        Database.executeBatch(this, this.getBatchSize());
    }
    
    /**
     * @description This method is called by the Salesforce scheduler. It executes the batch job.
     * @param sc The schedulable context.
     */
    public void execute(SchedulableContext sc) {
        this.execute();
    }

    /**
     * @description Sets the correlation ID for the job execution to ensure connected logging.
     * @param correlationId The correlation ID to use for the job's logging trace.
     */
    public virtual void setCorrelationId(String correlationId) {
        this.correlationId = correlationId;
    }

    /**
     * @description This method returns the name of the job. By default, it returns the name of the class.
     * @return The name of the job.
     */
    public virtual String getJobName() {
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }

    private Batch_Job_Settings__mdt settings;

    /**
     * @description Retrieves the custom metadata settings for this specific job.
     * @return The Batch_Job_Settings__mdt record for this job.
     */
    private Batch_Job_Settings__mdt getSettings() {
        if (settings == null) {
            String jobName = this.getJobName();
            List<Batch_Job_Settings__mdt> settingsList = [SELECT Cron_Expression__c, Batch_Size__c, Parent_Job__c FROM Batch_Job_Settings__mdt WHERE Job_Name__c = :jobName LIMIT 1];
            if (!settingsList.isEmpty()) {
                settings = settingsList[0];
            }
        }
        return settings;
    }

    /**
     * @description Returns the cron expression for the job. Returns null if the job is a child job.
     * @return The cron expression string, or null.
     */
    public virtual String getCronExpression() {
        Batch_Job_Settings__mdt jobSettings = getSettings();
        if (jobSettings != null && String.isNotBlank(jobSettings.Parent_Job__c)) {
            return null;
        }
        if (jobSettings != null && String.isNotBlank(jobSettings.Cron_Expression__c)) {
            return jobSettings.Cron_Expression__c;
        }
        return DEFAULT_CRON_EXPRESSION;
    }

    /**
     * @description Returns the batch size for the job.
     * @return The batch size integer.
     */
    public virtual Integer getBatchSize() {
        Batch_Job_Settings__mdt jobSettings = getSettings();
        if (jobSettings != null && jobSettings.Batch_Size__c != null) {
            return Integer.valueOf(jobSettings.Batch_Size__c);
        }
        return DEFAULT_BATCH_SIZE;
    }
}