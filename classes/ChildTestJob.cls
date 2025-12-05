/**
 * @description A minimal, concrete implementation of the BatchJob abstract class,
 *              representing a child job for testing metadata-driven chaining.
 *              -----------------------------------------------------------------------------
 *              Developer            Date            Description
 *              -----------------------------------------------------------------------------
 *              Kenneth Houkjær      06/10/2025      Initial version.
 *
 * @author Kenneth Houkjær
 * @date 06/10/2025
 */
@isTest
public class ChildTestJob extends BatchJob {
    
    /**
     * @description Provides a fixed job name for test identification.
     * @return The string 'ChildTestJob'.
     */
    public override String getJobName() {
        return 'ChildTestJob';
    }

    /**
     * @description Provides a query for the test job.
     * @param bc The batchable context.
     * @return A query locator for a single Account record.
     */
    public override Database.QueryLocator startBatch(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Account LIMIT 1');
    }

    /**
     * @description A do-nothing implementation for the test job.
     * @param bc The batchable context.
     * @param scope The list of records to process.
     */
    public override void executeBatchChunk(Database.BatchableContext bc, List<SObject> scope) {
        // do nothing
    }

    /**
     * @description A do-nothing implementation for the test job.
     * @param bc The batchable context.
     */
    public override void finishBatch(Database.BatchableContext bc) {
        // do nothing
    }
}