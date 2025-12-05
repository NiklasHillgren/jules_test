@isTest
private class AccountPhoneNumberAssignmentCntrTest {

    @isTest
    static void testGetPhoneNumberAssignments() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withCvr('11223344')
            .withPhoneNumberAssignments(200)
            .withoutCaseAndActivations()
            .build();

        // Act
        Test.startTest();
        List<Account_Phone_Number_Assignment__c> result = AccountPhoneNumberAssignmentController.getPhoneNumberAssignments(scenario.account.Id);
        Test.stopTest();

        // Assert
        System.assertEquals(200, result.size(), 'Should retrieve all 200 records');
    }

    @isTest
    static void testGetPhoneNumberAssignments_NoRecords() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withCvr('11223344')
            .withPhoneNumberAssignments(0)
            .withoutCaseAndActivations()
            .build();

        // Act
        Test.startTest();
        List<Account_Phone_Number_Assignment__c> result = AccountPhoneNumberAssignmentController.getPhoneNumberAssignments(scenario.account.Id);
        Test.stopTest();

        // Assert
        System.assertEquals(0, result.size(), 'Should return an empty list when no assignments exist');
    }
}