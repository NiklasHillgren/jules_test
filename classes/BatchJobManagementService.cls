/**
 * @description This service class manages batch jobs that implement the IBatchJob interface.
 *              It provides centralized methods to start, stop, and retrieve batch jobs.
 *              -----------------------------------------------------------------------------
 *              Developer            Date            Description
 *              -----------------------------------------------------------------------------
 *              Jules                07/10/2025      Refactored from BatchJobManager to a service class.
 *              Jules                08/10/2025      Added Logger.emit() to ensure logs are sent.
 *
 * @author Jules
 * @date 07/10/2025
 */
public virtual with sharing class BatchJobManagementService {
    private final IBatchJobFactory batchJobFactory;
    private final BatchJobSelector batchJobSel;

    /**
     * @description The default constructor, which retrieves dependencies from the SingletonFactory.
     */
    public BatchJobManagementService() {
        this(SingletonFactory.getFactory());
    }

    /**
     * @description The private constructor for dependency injection.
     * @param singletonFactory The factory to get dependencies from.
     */
    private BatchJobManagementService(SingletonFactory singletonFactory) {
        //this.batchJobFactory = singletonFactory.getBatchJobFactory();
        this.batchJobFactory = (IBatchJobFactory) singletonFactory.getOrRegisterSingleton(BatchJobFactory.class);
        this.batchJobSel = (BatchJobSelector) singletonFactory.getOrRegisterSingleton(BatchJobSelector.class);
    }

    /**
     * @description Schedules all active, root-level batch jobs.
     */
    public virtual void startAllJobs() {
        List<IBatchJob> jobs = getAllBatchJobs();
        for (IBatchJob job : jobs) {
            startJob(job.getJobName());
        }
    }
    
    /**
     * @description Aborts all scheduled and running batch jobs.
     */
    public virtual void stopAllJobs() {
        List<IBatchJob> jobs = getAllBatchJobs();
        for (IBatchJob job : jobs) {
            stopJob(job.getJobName());
        }
    }

    /**
     * @description Schedules a specific batch job by its name.
     * @param jobName The name of the job to start.
     */
    public virtual void startJob(String jobName) {
        String correlationId = Logger.getTraceId();
        Logger.setTraceId(correlationId);
        try {
            String userInfo = 'User: ' + UserInfo.getUserName() + ' (' + UserInfo.getUserId() + ')';
            Logger.logInfo('Attempting to schedule job: ' + jobName + '. Requested by ' + userInfo);
            IBatchJob job = getBatchJob(jobName);
            if (job != null) {
                job.setCorrelationId(correlationId);
                job.schedule();
            }
        } finally {
            Logger.emit();
        }
    }

    /**
     * @description Executes a specific batch job by its name immediately.
     * @param jobName The name of the job to start.
     */
    public virtual void startJobNow(String jobName) {
        String correlationId = Logger.getTraceId();
        Logger.setTraceId(correlationId);
        try {
            String userInfo = 'User: ' + UserInfo.getUserName() + ' (' + UserInfo.getUserId() + ')';
            Logger.logInfo('Attempting to start job immediately: ' + jobName + '. Requested by ' + userInfo);
            IBatchJob job = getBatchJob(jobName);
            if (job != null) {
                job.setCorrelationId(correlationId);
                job.execute();
            }
        } finally {
            Logger.emit();
        }
    }

    /**
     * @description Stops a specific batch job by its name.
     * @param jobName The name of the job to stop.
     */
    public virtual void stopJob(String jobName) {
        try {
            String userInfo = 'User: ' + UserInfo.getUserName() + ' (' + UserInfo.getUserId() + ')';
            Logger.logInfo('Attempting to stop job: ' + jobName + '. Requested by ' + userInfo);
            
            List<CronTrigger> cronTriggers = batchJobSel.getCronTriggersByJobNameImpl(jobName);
            for (CronTrigger cronTrigger : cronTriggers) {
                System.abortJob(cronTrigger.Id);
                Logger.logInfo('Successfully aborted scheduled job ' + jobName + ' with trigger ID: ' + cronTrigger.Id);
            }

            List<AsyncApexJob> runningJobs = batchJobSel.getRunningJobsByJobNameImpl(jobName);
            for (AsyncApexJob runningJob : runningJobs) {
                System.abortJob(runningJob.Id);
                Logger.logInfo('Successfully aborted running job ' + jobName + ' with job ID: ' + runningJob.Id);
            }
        } finally {
            Logger.emit();
        }
    }

    /**
     * @description This method returns a list of all root-level batch jobs.
     * @return A list of all active IBatchJob instances.
     */
    public virtual List<IBatchJob> getAllBatchJobs() {
        List<IBatchJob> jobs = new List<IBatchJob>();
        List<Batch_Job_Settings__mdt> settings = batchJobSel.getActiveBatchJobSettingsImpl();
        for (Batch_Job_Settings__mdt setting : settings) {
            IBatchJob job = getBatchJob(setting.Job_Name__c);
            if (job != null) {
                jobs.add(job);
            }
        }
        return jobs;
    }

    /**
     * @description This method returns a batch job instance by its name.
     * @param jobName The name of the job to return.
     * @return An IBatchJob instance, or null if an error occurs.
     */
    public virtual IBatchJob getBatchJob(String jobName) {
        IBatchJob job = null;
        try {
            job = batchJobFactory.create(jobName);
        } catch (Exception e) {
            Logger.logError('BatchJobManagementService', 'Error creating instance of ' + jobName + ': ' + e.getMessage());
        } finally {
            Logger.emit();
        }
        return job;
    }

    /**
     * @description This method returns a list of all child jobs for a given parent job.
     * @param parentJobName The name of the parent job.
     * @return A list of Batch_Job_Settings__mdt for the child jobs.
     */
    public virtual List<Batch_Job_Settings__mdt> getChildJobSettings(String parentJobName) {
        return batchJobSel.getChildJobSettingsImpl(parentJobName);
    }
}