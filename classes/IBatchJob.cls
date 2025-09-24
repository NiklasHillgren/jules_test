/**
 * @description This interface is implemented by all batch jobs that can be managed by the BatchJobManager.
 * @author Kenneth Houkjær
 */
public interface IBatchJob {
    
    /**
     * @description This method returns the name of the job.
     * @return The name of the job.
     */
    String getJobName();

    /**
     * @description This method returns the cron expression for the job.
     * @return The cron expression for the job.
     */
    String getCronExpression();

    /**
     * @description This method returns the batch size for the job.
     * @return The batch size for the job.
     */
    Integer getBatchSize();

    /**
     * @description This method is used to schedule the batch job.
     */
    void schedule();

    /**
     * @description This method is used to execute the batch job immediately.
     */
    void execute();
}