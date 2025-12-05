/**
 * @description A minimal, concrete implementation of the BatchJob abstract class.
 *              This class does nothing and is used solely for testing the BatchJobManagementService.
 *              -----------------------------------------------------------------------------
 *              Developer            Date            Description
 *              -----------------------------------------------------------------------------
 *              Kenneth Houkjær      06/10/2025      Initial version.
 *              Kenneth Houkjær      06/10/2025      Updated to conform to new BatchJob abstract methods.
 *
 * @author Kenneth Houkjær
 * @date 06/10/2025
 */
public class BatchTestJob extends BatchJob {
    
    /**
     * @description Provides a fixed job name for test identification.
     * @return The string 'BatchTestJob'.
     */
    public override String getJobName() {
        return 'BatchTestJob';
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
    
    /**
     * @description Provides a fixed cron expression for test scheduling.
     * @return A cron string.
     */
    public override String getCronExpression() {
        return '0 0 0 * * ?';
    }
}