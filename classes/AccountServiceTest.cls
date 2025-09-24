@isTest
private class AccountServiceTest {
    private static final String TEST_CVR = '12345678';

    @isTest
    static void testCompanyAPIDataFetch() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr(TEST_CVR)
            .withoutCaseAndActivations()
            .build();
        AccountService accountService = new AccountService();

        // Act
        Test.startTest();
        Set<Id> result = accountService.CompanyAPIDataFetch(new List<Account>{ scenario.account });
        Test.stopTest();

        // Assert
        Assert.isTrue(result.contains(scenario.account.Id), 'Account Id should be sent to Company API update');
    }
    
    @isTest
    static void testContractAPIDataFetch() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr(TEST_CVR)
            .withoutCaseAndActivations()
            .build();
        
        scenario.account.Send_Update_to_Contract_API__c = true;
        update scenario.account;
        
        AccountService accountService = new AccountService();

        // Act
        Test.startTest();
        List<Id> result = accountService.ContractAPIDataFetch(new List<Account>{ scenario.account });
        Test.stopTest();

        // Assert
        Assert.isTrue(result.contains(scenario.account.Id), 'Account Id should be sent to Contract API update');
    }
}