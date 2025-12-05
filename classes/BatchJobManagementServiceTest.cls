/**
 * @description Test class for the BatchJobManagementService.
 *              This class verifies all public methods of the BatchJobManagementService.
 *              -----------------------------------------------------------------------------
 *              Developer            Date            Description
 *              -----------------------------------------------------------------------------
 *              Kenneth Houkjær      06/10/2025      Initial version.
 *              Jules                07/10/2025      Refactored to test the service-oriented architecture and fix test failures.
 *
 * @author Jules
 * @date 07/10/2025
 */
@isTest
private class BatchJobManagementServiceTest {


    /**
     * @description A mock implementation of IBatchJobFactory for controlling job creation in tests.
     */
    private class BatchJobFactoryMock implements IBatchJobFactory {
        private final Map<String, IBatchJob> jobs = new Map<String, IBatchJob>();

        public IBatchJob create(String jobName) {
            if (jobs.containsKey(jobName)) {
                return jobs.get(jobName);
            }
            BatchJobMock mockJob = new BatchJobMock();
            mockJob.jobName = jobName;
            return mockJob;
        }

        public void addJob(String name, IBatchJob job) {
            jobs.put(name, job);
        }
    }
    /**
     * @description A mock implementation of BatchJobSelector for providing controlled test data.
     */
    private class BatchJobSelectorMock extends BatchJobSelector {
        public List<Batch_Job_Settings__mdt> rootJobs = new List<Batch_Job_Settings__mdt>();
        public Map<String, List<Batch_Job_Settings__mdt>> childJobs = new Map<String, List<Batch_Job_Settings__mdt>>();

        public override List<Batch_Job_Settings__mdt> getActiveBatchJobSettingsImpl() {
            return rootJobs;
        }

        public override List<Batch_Job_Settings__mdt> getChildJobSettingsImpl(String parentJobName) {
            if (childJobs.containsKey(parentJobName)) {
                return childJobs.get(parentJobName);
            }
            return new List<Batch_Job_Settings__mdt>();
        }
        
        public override List<CronTrigger> getCronTriggersByJobNameImpl(String jobName) {
            return [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = :jobName];
        }

        public override List<AsyncApexJob> getRunningJobsByJobNameImpl(String jobName) {
            return [SELECT Id, Status FROM AsyncApexJob WHERE ApexClass.Name = :jobName AND Status IN ('Processing', 'Preparing', 'Queued')];
        }
    }

    /**
     * @description Verifies that startAllJobs schedules all active, root-level jobs.
     */
    @isTest
    static void testStartAllJobs() {
        // Given
        SingletonFactory factory = SingletonFactory.getFactory();
        
        BatchJobSelectorMock selectorMock = new BatchJobSelectorMock();
        selectorMock.rootJobs.add(new Batch_Job_Settings__mdt(Job_Name__c = 'BatchTestJob'));
        factory.registerSingleton( BatchJobSelector.class, selectorMock);


        BatchJobFactoryMock factoryMock = new BatchJobFactoryMock();
        factoryMock.addJob('BatchTestJob', new BatchTestJob());
        factory.registerSingleton( BatchJobFactory.class, factoryMock);
        
        BatchJobManagementService service = new BatchJobManagementService();

        // When
        Test.startTest();
        service.startAllJobs();
        Test.stopTest();

        // Then
        System.assertEquals(1, [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.Name = 'BatchTestJob'], 'One job should have been scheduled.');
    }

    /**
     * @description Verifies that stopJob aborts a scheduled job.
     */
    @isTest
    static void testStopScheduledJob() {
        //given
        SingletonFactory factory = SingletonFactory.getFactory();
        
        BatchJobSelectorMock selectorMock = new BatchJobSelectorMock();
        selectorMock.rootJobs.add(new Batch_Job_Settings__mdt(Job_Name__c = 'BatchTestJob'));
        factory.registerSingleton( BatchJobSelector.class, selectorMock);

        BatchJobManagementService service = new BatchJobManagementService();
        
        // When
        Test.startTest();
        service.startJob('BatchTestJob');
        service.stopJob('BatchTestJob');
        Test.stopTest();

        // Then
        List<CronTrigger> triggers = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'BatchTestJob'];
        System.assert(triggers.isEmpty(), 'Job was not aborted');
    }

    /**
     * @description Verifies that stopJob aborts a running/queued job.
     */
    @isTest
    static void testStopRunningJob() {
        // Given
        SingletonFactory factory = SingletonFactory.getFactory();
        
        BatchJobSelectorMock selectorMock = new BatchJobSelectorMock();
        selectorMock.rootJobs.add(new Batch_Job_Settings__mdt(Job_Name__c = 'BatchTestJob'));
        factory.registerSingleton( BatchJobSelector.class, selectorMock);

        BatchJobManagementService service = new BatchJobManagementService();

        // When
        Test.startTest();
        Database.executeBatch(new BatchTestJob());
        service.stopJob('BatchTestJob');
        Test.stopTest();

        // Then
        List<AsyncApexJob> jobs = [SELECT Status FROM AsyncApexJob WHERE ApexClass.Name = 'BatchTestJob'];
        System.assertEquals(1, jobs.size(), 'There should be one job');
        System.assertEquals('Aborted', jobs[0].Status, 'Job should have been aborted');
    }

    /**
     * @description Verifies that startJobNow executes a job immediately.
     */
    @isTest
    static void testStartJobNow() {
        SingletonFactory factory = SingletonFactory.getFactory();

        BatchJobFactoryMock factoryMock = new BatchJobFactoryMock();
        factoryMock.addJob('BatchTestJob', new BatchTestJob());
        factory.registerSingleton( BatchJobFactory.class, factoryMock);

        //call test method they will hit the mock
    

        // Given
        //BatchJobSelector.setMock(new BatchJobSelectorMock());
       // BatchJobManagementService service = new BatchJobManagementService(factoryMock);
        BatchJobManagementService service = new BatchJobManagementService();
        
        // When
        Test.startTest();
        service.startJobNow('BatchTestJob');
        Test.stopTest();

        // Then
        System.assertEquals(1, [SELECT COUNT() FROM AsyncApexJob WHERE ApexClass.Name = 'BatchTestJob' AND JobType = 'BatchApex'], 'There should be one job started.');
    }

    /**
     * @description Verifies that the framework correctly executes child jobs defined in metadata.
     */
    @isTest
    static void testMetadataChaining() {
        // Given
        SingletonFactory factory = SingletonFactory.getFactory();

        BatchJobFactoryMock factoryMock = new BatchJobFactoryMock();
        factoryMock.addJob('BatchTestJob', new BatchTestJob());
        factoryMock.addJob('ChildTestJob', new ChildTestJob());
        factory.registerSingleton( BatchJobFactory.class, factoryMock);
        
        BatchJobSelectorMock selectorMock = new BatchJobSelectorMock();
        selectorMock.childJobs.put('BatchTestJob', new List<Batch_Job_Settings__mdt>{
            new Batch_Job_Settings__mdt(Job_Name__c = 'ChildTestJob')
        });
        factory.registerSingleton( BatchJobSelector.class, selectorMock);

        
        BatchJobManagementService service = new BatchJobManagementService();

        // When
        Test.startTest();
        service.startJobNow('BatchTestJob');
        Test.stopTest();

        // Then
        List<AsyncApexJob> jobs = [SELECT ApexClass.Name FROM AsyncApexJob WHERE JobType = 'BatchApex' ORDER BY CreatedDate];
        System.assertEquals(2, jobs.size(), 'Expected parent and child jobs to run.');
        System.assertEquals('BatchTestJob', jobs[0].ApexClass.Name, 'Parent job should be the first one.');
        System.assertEquals('ChildTestJob', jobs[1].ApexClass.Name, 'Child job should be the second one.');
    }
}