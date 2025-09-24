@IsTest
public class Activation_CreateTest {

    @IsTest
    static void testAmendmentQuotes() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withContractAndSubscription()
            .build();

        List<Activation_Create.RequestDAO> requestDaoList = new List<Activation_Create.RequestDAO>();
        Activation_Create.RequestDAO requestDAO = new Activation_Create.RequestDAO();
        requestDAO.recordId = scenario.quote.Id;
        requestDAO.cases = new List<Case>{ scenario.caseRecord };
        requestDaoList.add(requestDAO);
        
        // Act
        Test.startTest();
        Activation_Create.Activation_Create(requestDaoList);
        Test.stopTest();

        // Assert
        List<Activation__c> createdActivations = [SELECT Id FROM Activation__c WHERE Case__c = :scenario.caseRecord.Id];
        Assert.isFalse(createdActivations.isEmpty(), 'Activations should have been created.');
    }

    @IsTest
    static void testRenewalQuotes() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withContractAndSubscription()
            .build();
        
        scenario.opportunity.SBQQ__Renewal__c = true;
        scenario.opportunity.SBQQ__AmendedContract__c = null;
        update scenario.opportunity;

        List<Activation_Create.RequestDAO> requestDaoList = new List<Activation_Create.RequestDAO>();
        Activation_Create.RequestDAO requestDAO = new Activation_Create.RequestDAO();
        requestDAO.recordId = scenario.quote.Id;
        requestDAO.cases = new List<Case>{ scenario.caseRecord };
        requestDaoList.add(requestDAO);
        
        // Act
        Test.startTest();
        Activation_Create.Activation_Create(requestDaoList);
        Test.stopTest();

        // Assert
        List<Activation__c> createdActivations = [SELECT Id FROM Activation__c WHERE Case__c = :scenario.caseRecord.Id];
        Assert.isFalse(createdActivations.isEmpty(), 'Activations should have been created for the renewal quote.');
    }
    
    @IsTest
    static void testStandardQuotes() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withContractAndSubscription()
            .build();

        scenario.opportunity.SBQQ__Renewal__c = false;
        scenario.opportunity.SBQQ__AmendedContract__c = null;
        update scenario.opportunity;

        List<Activation_Create.RequestDAO> requestDaoList = new List<Activation_Create.RequestDAO>();
        Activation_Create.RequestDAO requestDAO = new Activation_Create.RequestDAO();
        requestDAO.recordId = scenario.quote.Id;
        requestDAO.cases = new List<Case>{ scenario.caseRecord };
        requestDaoList.add(requestDAO);

        // Act
        Test.startTest();
        Activation_Create.Activation_Create(requestDaoList);
        Test.stopTest();

        // Assert
        List<Activation__c> createdActivations = [SELECT Id FROM Activation__c WHERE Case__c = :scenario.caseRecord.Id];
        Assert.isFalse(createdActivations.isEmpty(), 'Activations should have been created for the standard quote.');
    }

    @IsTest
    static void testExceptionHandling() {
        // Arrange
        // We need a scenario with a case, but without any pre-existing activations.
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withoutCaseAndActivations() // Start with a scenario that has no fulfillment records.
            .build();

        // Manually add the Case record needed for the method call.
        Case testCase = (Case) NorlysSUnit.newFactory().create('Case')
            .set('AccountId', scenario.account.Id)
            .set('Opportunity__c', scenario.opportunity.Id)
            .set('Subject', 'Order_Fulfilment_Case')
            .set('RecordTypeId', Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName().get('Order_Fulfilment_Case').getRecordTypeId())
            .insertRecord();

        List<Activation_Create.RequestDAO> requestDaoList = new List<Activation_Create.RequestDAO>();
        Activation_Create.RequestDAO requestDAO = new Activation_Create.RequestDAO();
        requestDAO.recordId = null; // Invalid record Id to cause an exception
        requestDAO.cases = new List<Case>{ testCase };
        requestDaoList.add(requestDAO);
        
        // Act
        Test.startTest();
        Activation_Create.Activation_Create(requestDaoList);
        Test.stopTest();

        // Assert
        List<Activation__c> createdActivations = [SELECT Id FROM Activation__c];
        Assert.isTrue(createdActivations.isEmpty(), 'No activations should be created when an error occurs.');
    }
}