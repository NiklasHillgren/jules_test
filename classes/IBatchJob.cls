/**
 * @description Defines the contract for all batch jobs that can be managed by the BatchJobManagementService.
 *              It includes methods for identification, configuration, scheduling, and execution.
 *              -----------------------------------------------------------------------------
 *              Developer            Date            Description
 *              -----------------------------------------------------------------------------
 *              Kenneth Houkjær      06/10/2025      Initial version.
 *              Jules                07/10/2025      Added setCorrelationId for connected logging.
 *
 * @author Kenneth Houkjær
 * @date 06/10/2025
 */
public interface IBatchJob {
    
    /**
     * @description Returns the unique name of the job, typically the class name.
     * @return String The name of the job.
     */
    String getJobName();

    /**
     * @description Returns the cron expression used for scheduling the job. Child jobs should return null.
     * @return String The cron expression for the job, or null if it's a child job.
     */
    String getCronExpression();

    /**
     * @description Returns the number of records to process in each batch chunk.
     * @return Integer The batch size for the job.
     */
    Integer getBatchSize();

    /**
     * @description Schedules the batch job to run based on its cron expression.
     */
    void schedule();

    /**
     * @description Executes the batch job immediately.
     */
    void execute();

    /**
     * @description Sets the correlation ID for the job execution to ensure connected logging.
     * @param correlationId The correlation ID to use for the job's logging trace.
     */
    void setCorrelationId(String correlationId);
}