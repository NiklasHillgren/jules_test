/**
 * @description A mock implementation of the BatchJob class for testing the framework itself.
 *              It uses static maps to track method calls (`start`, `execute`, `finish`) and the
 *              correlation ID, because batch jobs run in separate transactions from the test
 *              method that invokes them. Static variables persist across these transactions within a test run.
 *              -----------------------------------------------------------------------------
 *              Developer            Date            Description
 *              -----------------------------------------------------------------------------
 *              Kenneth Houkjær      06/10/2025      Initial version.
 *
 * @author Kenneth Houkjær
 * @date 06/10/2025
 */
@isTest
public class BatchJobMock extends BatchJob {
    public String jobName;
    
    // Static maps to track calls for each job by name.
    public static Map<String, Integer> startCounts = new Map<String, Integer>();
    public static Map<String, Integer> executeCounts = new Map<String, Integer>();
    public static Map<String, Integer> finishCounts = new Map<String, Integer>();
    public static Map<String, String> correlationIds = new Map<String, String>();

    /**
     * @description Overrides the default job name to be dynamically set per instance.
     * @return The assigned job name.
     */
    public override String getJobName() {
        return this.jobName;
    }

    /**
     * @description Resets all static counters and maps. This must be called in the @testSetup
     *              or at the beginning of each test method to ensure test isolation.
     */
    public static void reset() {
        startCounts.clear();
        executeCounts.clear();
        finishCounts.clear();
        correlationIds.clear();
    }

    /**
     * @description Mock implementation of startBatch. Increments the start counter and captures the correlationId.
     * @param bc The batchable context.
     * @return A simple query locator to ensure the execute method is called.
     */
    public override Database.QueryLocator startBatch(Database.BatchableContext bc) {
        Integer count = startCounts.get(this.jobName);
        if (count == null) {
            count = 0;
        }
        startCounts.put(this.jobName, count + 1);
        correlationIds.put(this.jobName, this.correlationId);
        return Database.getQueryLocator('SELECT Id FROM Account LIMIT 1');
    }

    /**
     * @description Mock implementation of executeBatchChunk. Increments the execute counter.
     * @param bc The batchable context.
     * @param scope The list of records to process.
     */
    public override void executeBatchChunk(Database.BatchableContext bc, List<SObject> scope) {
        Integer count = executeCounts.get(this.jobName);
        if (count == null) {
            count = 0;
        }
        executeCounts.put(this.jobName, count + 1);
    }

    /**
     * @description Mock implementation of finishBatch. Increments the finish counter.
     * @param bc The batchable context.
     */
    public override void finishBatch(Database.BatchableContext bc) {
        Integer count = finishCounts.get(this.jobName);
        if (count == null) {
            count = 0;
        }
        finishCounts.put(this.jobName, count + 1);
    }

    /**
     * @description Sets the correlation ID for the mock job.
     * @param correlationId The correlation ID to use.
     */
    public override void setCorrelationId(String correlationId) {
        super.correlationId = correlationId;
    }
}