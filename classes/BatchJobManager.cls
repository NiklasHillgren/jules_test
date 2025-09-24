/**
 * @description This class is used to manage all batch jobs that implement the IBatchJob interface.
 * It provides methods to start and stop all batch jobs, as well as individual batch jobs.
 * @author Kenneth Houkjaer
 */
public class BatchJobManager {
    /**
     * @description Starts all batch jobs that implement the IBatchJob interface.
     * @author Kenneth Houkjaer
     */
    public static void startAllJobs() {
        List<IBatchJob> jobs = getAllBatchJobs();
        for (IBatchJob job : jobs) {
            startJob(job.getJobName());
        }
    }

    
    
    /**
     * @description Stops all batch jobs that implement the IBatchJob interface.
     * @author Kenneth Houkjaer
     */
    public static void stopAllJobs() {
        List<IBatchJob> jobs = getAllBatchJobs();
        for (IBatchJob job : jobs) {
            stopJob(job.getJobName());
        }
    }

    /**
     * @description Starts a specific batch job by its name.
     * @param jobName The name of the job to start.
     * @author Kenneth Houkjaer
     */
    public static void startJob(String jobName) {
        String userInfo = 'User: ' + UserInfo.getUserName() + ' (' + UserInfo.getUserId() + ')';
        Logger.logInfo('Attempting to start job: ' + jobName + '. Requested by ' + userInfo);
        IBatchJob job = getBatchJob(jobName);
        if (job != null) {
            job.schedule();
        }
    }

    /**
     * @description Stops a specific batch job by its name.
     * @param jobName The name of the job to stop.
     * @author Kenneth Houkjaer
     */
    public static void stopJob(String jobName) {
        String userInfo = 'User: ' + UserInfo.getUserName() + ' (' + UserInfo.getUserId() + ')';
        Logger.logInfo('Attempting to stop job: ' + jobName + '. Requested by ' + userInfo);
        List<CronTrigger> cronTriggers = BatchJobSelector.getCronTriggersByJobName(jobName);
        for (CronTrigger cronTrigger : cronTriggers) {
            System.abortJob(cronTrigger.Id);
            Logger.logInfo('Successfully aborted job ' + jobName + ' with trigger ID: ' + cronTrigger.Id);
        }
    }

    private static IBatchJobFactory factory = new BatchJobFactory();

    @TestVisible
    private static void setFactory(IBatchJobFactory mockFactory) {
        factory = mockFactory;
    }

    /**
     * @description This method returns a list of all batch jobs that are active.
     * @return A list of all active batch jobs.
     * @author Kenneth Houkjaer
     */
    public static List<IBatchJob> getAllBatchJobs() {
        List<IBatchJob> jobs = new List<IBatchJob>();
        List<Batch_Job_Settings__mdt> settings = BatchJobSelector.getActiveBatchJobSettings();
        for (Batch_Job_Settings__mdt setting : settings) {
            IBatchJob job = getBatchJob(setting.Job_Name__c);
            if (job != null) {
                jobs.add(job);
            }
        }
        return jobs;
    }

    /**
     * @description This method returns a batch job by its name.
     * @param jobName The name of the job to return.
     * @return A batch job.
     * @author Kenneth Houkjaer
     */
    public static IBatchJob getBatchJob(String jobName) {
        try {
            return factory.create(jobName);
        } catch (Exception e) {
            Logger.logError('BatchJobManager', 'Error creating instance of ' + jobName + ': ' + e.getMessage());
        }
        return null;
    }
}