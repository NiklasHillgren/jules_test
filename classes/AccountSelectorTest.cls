/**
 * 
 * @author 
 * @since 
 */
@IsTest
private class AccountSelectorTest {
    private static final String CVR = '12345678';

    /**
     * Test whether getByCvr returns an account when given a valid CVR
     */
    @IsTest
    private static void getbyCvr_validCvr_returnsAccount() {
        //ARRANGE
        NorlysTestScenarios.newBuilder()
            .withCvr(CVR)
            .withoutCaseAndActivations()
            .build();

        //ACT
        Test.startTest();
        Account acc = AccountSelector.getByCVR(CVR);
        Test.stopTest();
        
        //ASSERT
        Assert.isNotNull(acc, 'The account should be found');
    }

    /**
     * getAccountsByIds_validAccountIds_returnsSingleAccountWithCorrectCvr
     */
    @IsTest
    private static void getAccountsByIds_validAccountIds_returnsSingleAccountWithCorrectCvr() {
        //ARRANGE
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr(CVR)
            .withoutCaseAndActivations()
            .build();

        //ACT
        Test.startTest();
        List<Account> accounts = AccountSelector.getAccountsByIds(new List<Id>{scenario.account.Id});
        Test.stopTest();

        //ASSERT
        Assert.areEqual(1, accounts.size(), 'Returned List should contain a sinlge Account');
        Assert.areEqual(CVR, accounts[0].CVR__c, 'The returned Accounts CVR should match');
    }

    @IsTest
    private static void getAccountByCaseId_validCaseId_returnsCorrectAccount() {
        //ARRANGE
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr(CVR)
            .build();

        //ACT
        Test.startTest();
        Account returnedAccount = AccountSelector.getAccountByCaseId(scenario.caseRecord.Id);
        Test.stopTest();

        //ASSERT
        Assert.areEqual(scenario.account.Id, returnedAccount.Id);
    }

    @IsTest
    private static void testGetAccountByCaseIdNoCase() {
        //ARRANGE
        // Create a case that is immediately deleted to simulate a non-existent record
        Case testCase = new Case(Subject = 'Test Case');
        insert testCase;
        Id validCaseId = testCase.Id;
        delete testCase;
    
        //ACT
        Test.startTest();
        Id accountId = AccountSelector.getAccountByCaseId(validCaseId)?.Id;
        Test.stopTest();
    
        //ASSERT
        Assert.isNull(accountId, 'No account.Id should be returned for a non-existent Case ID');
    }
    
    @IsTest
    private static void testGetAccountByCaseIdNoAccountLinked() {
        //ARRANGE
        // Create a Case without an Account
        Case caseWithoutAccount = new Case(
            Subject = 'Unlinked Case',
            Status = 'New'
        );
        insert caseWithoutAccount;

        //ACT
        Test.startTest();
        Account retrievedAccount = AccountSelector.getAccountByCaseId(caseWithoutAccount.Id);
        Test.stopTest();

        //ASSERT
        Assert.isNull(retrievedAccount, 'No account should be returned for a case not linked to an account');
    }
}