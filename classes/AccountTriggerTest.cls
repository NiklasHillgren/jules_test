@IsTest
private with sharing class AccountTriggerTest {

    private static final String TEST_CVR = '11223344';

    @IsTest
    private static void companyApiUpdateSuccess() {
        // Arrange
        Test.startTest();
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr(TEST_CVR)
            .withoutCaseAndActivations()
            .build();
        Test.stopTest();
        
        // Assert
        List<Account> insertedAccounts = [SELECT Id, CVR__c FROM Account WHERE Id = :scenario.account.Id];
        Assert.isTrue(!insertedAccounts.isEmpty(), 'Account should be sent to Company API update');
    }   

    @IsTest
    private static void contractApiUpdateSuccess() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr(TEST_CVR)
            .withoutCaseAndActivations()
            .build();
        
        // Act
        Test.startTest();
        scenario.account.Send_Update_to_Contract_API__c = true;
        update scenario.account;
        Test.stopTest();
        
        // Assert
        List<Account> updatedAccounts = [SELECT Id, CVR__c FROM Account WHERE Id = :scenario.account.Id];
        Assert.isTrue(!updatedAccounts.isEmpty(), 'Account should be sent to Contract API update');
    }
}