/**
 * @description Test the BatchJobManager 
 * @author Kenneth Houkjær
 */
@isTest
private class BatchJobManagerTest {
    
    private class BatchJobSelectorMock extends BatchJobSelector {
        public override List<Batch_Job_Settings__mdt> getActiveBatchJobSettingsImpl() {
            return new List<Batch_Job_Settings__mdt>{
                new Batch_Job_Settings__mdt(Job_Name__c = 'BatchTestJob')
            };
        }
    }

    

    @isTest
    static void testStartAllJobs() {
        BatchJobSelector.setMock(new BatchJobSelectorMock());

        Test.startTest();
        BatchJobManager.startAllJobs();
        Test.stopTest();

        List<CronTrigger> triggers = [SELECT Id FROM CronTrigger];
        System.assert(!triggers.isEmpty(), 'No jobs were scheduled');
    }

    @isTest
    static void testStopAllJobs() {
        BatchJobSelector.setMock(new BatchJobSelectorMock());

        Test.startTest();
        BatchTestJob testJob = new BatchTestJob();
        testJob.schedule();

        BatchJobManager.stopAllJobs();
        Test.stopTest();

        List<CronTrigger> triggers = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'BatchTestJob'];
        System.assert(triggers.isEmpty(), 'Jobs were not aborted');
    }

    @isTest
    static void testStartJob() {
        Test.startTest();
        BatchJobManager.startJob('BatchTestJob');
        Test.stopTest();

        List<CronTrigger> triggers = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'BatchTestJob'];
        System.assert(!triggers.isEmpty(), 'Job was not scheduled');
    }

    @isTest
    static void testStopJob() {
        Test.startTest();
        BatchJobManager.startJob('BatchTestJob');
        BatchJobManager.stopJob('BatchTestJob');
        Test.stopTest();

        List<CronTrigger> triggers = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'BatchTestJob'];
        System.assert(triggers.isEmpty(), 'Job was not aborted');
    }
}