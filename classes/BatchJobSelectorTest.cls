@isTest
private class BatchJobSelectorTest {
    @isTest
    static void testGetActiveBatchJobSettings() {
        
        BatchJobSelector b = new BatchJobSelector();
        Test.startTest();
        List<Batch_Job_Settings__mdt> settings = b.getActiveBatchJobSettingsImpl();
        Test.stopTest();

        System.assert(settings != null, 'Settings list should not be null');

        // Verify that all returned settings are active.
        // This validates the WHERE clause of the query.
        for (Batch_Job_Settings__mdt setting : settings) {
            System.assertEquals(true, setting.Is_Active__c, 'Only active job settings should be returned.');
        }
        
    }


    @isTest
    static void testGetCronTriggersByJobName() {
        BatchJobSelector b = new BatchJobSelector();

        Test.startTest();
        BatchTestJob testJob = new BatchTestJob();
        testJob.schedule();
        Test.stopTest();

        List<CronTrigger> triggers = b.getCronTriggersByJobNameImpl('BatchTestJob');

        System.assert(triggers != null, 'Triggers list should not be null');
        System.assertEquals(1, triggers.size(), 'Should find one trigger for the test job');
    }
}