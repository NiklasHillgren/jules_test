public class BatchTestJob extends BatchJob {
    
    public override String getJobName() {
        return 'BatchTestJob';
    }

    public override Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Account LIMIT 1');
    }

    public override void execute(Database.BatchableContext bc, List<SObject> scope) {
        // do nothing
    }

    public override void finish(Database.BatchableContext bc) {
        // do nothing
    }
    

    public override String getCronExpression() {
        return '0 0 0 * * ?';
    }
}