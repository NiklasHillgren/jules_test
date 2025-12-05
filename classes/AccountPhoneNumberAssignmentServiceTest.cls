/**
 * @description
 *  Test class for AccountPhoneNumberAssignmentService, using the SUnit framework.
 *  This class tests the business logic for retrieving account phone number assignments.
 * @group SUnit
 */
@isTest
private class AccountPhoneNumberAssignmentServiceTest extends NorlysSUnitTest {

    /**
     * @description Tests the getAssignmentsForActivation method to ensure it returns a flat list of assignments.
     */
    @isTest
    static void testGetAssignmentsForActivation() {
        // Arrange
        NorlysTestScenarios.ScenarioBuilder builder = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withNumberSeries('EKC', 'P', 5, 0) // 5 Open series, 0 used
            .withNumberSeries('BRZ', 'P', 5, 0); // 5 Fixed series, 0 used
        
        NorlysTestScenarios.ScenarioResult scenario = builder.build();

        // Set status for 3 open series to be unused ('AR')
        for(Integer i=0; i<3; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AR';
        }
        // Set status for 3 fixed series to be unused ('AA')
        for(Integer i=5; i<8; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AA';
        }
        update scenario.phoneNumberAssignments;

        // Act
        Test.startTest();
        // Get 5 unused numbers. Should get the 3 fixed 'AA' and 2 of the open 'AR'
        List<AccountPhoneNumberAssignmentService.AssignmentWrapper> results = AccountPhoneNumberAssignmentService.getAssignmentsForActivation(
            new List<Id>{ scenario.activations[0].Id }, 5, false, new Map<Id, Id>(), 'NotAlreadyInUse'
        );
        Test.stopTest();

        // Assert
        Assert.isNotNull(results, 'The result should not be null.');
        Assert.areEqual(5, results.size(), 'Expected to retrieve 5 assignments.');
    }

    /**
     * @description Tests the getAssignmentsForActivationMapped method to ensure it returns a map of assignments.
     */
    @isTest
    static void testGetAssignmentsForActivationMapped() {
        // Arrange
        NorlysTestScenarios.ScenarioBuilder builder = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withNumberSeries('EKC', 'P', 5, 0) // 5 Open series, 0 used
            .withNumberSeries('BRZ', 'P', 5, 0); // 5 Fixed series, 0 used
        
        NorlysTestScenarios.ScenarioResult scenario = builder.build();

        // Set status for 3 open series to be unused ('AR')
        for(Integer i=0; i<3; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AR';
        }
        // Set status for 3 fixed series to be unused ('AA')
        for(Integer i=5; i<8; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AA';
        }
        update scenario.phoneNumberAssignments;

        // Act
        Test.startTest();
        Map<Id, List<AccountPhoneNumberAssignmentService.AssignmentWrapper>> results = AccountPhoneNumberAssignmentService.getAssignmentsForActivationMapped(
            new List<Id>{ scenario.activations[0].Id }, 5, false, null, 'NotAlreadyInUse'
        );
        Test.stopTest();

        // Assert
        Assert.isNotNull(results, 'The result map should not be null.');
        Assert.isTrue(results.containsKey(scenario.activations[0].Id), 'The map should contain the activation Id.');
        Assert.areEqual(5, results.get(scenario.activations[0].Id).size(), 'Expected to retrieve 5 assignments for the activation.');
    }

    /**
     * @description Tests that getAssignmentsForActivationMapped correctly excludes assignments based on the exclusion map.
     */
    @isTest
    static void testGetAssignmentsForActivationMappedWithExclusion() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(10)
            .withPhoneNumberAssignments(10)
            .build();

        for(Account_Phone_Number_Assignment__c assignment : scenario.phoneNumberAssignments){
            assignment.Phone_Number_Reservation_Status__c = 'SUCCESS';
        }
        update scenario.phoneNumberAssignments;

        Id activationId = scenario.activations[0].Id;
        Id assignmentToExclude = scenario.phoneNumberAssignments[0].Id;

        Map<Id, Id> exclusionMap = new Map<Id, Id>{
            activationId => assignmentToExclude
        };

        // Act
        Test.startTest();
        Map<Id, List<AccountPhoneNumberAssignmentService.AssignmentWrapper>> results = AccountPhoneNumberAssignmentService.getAssignmentsForActivationMapped(
            new List<Id>{ activationId }, 10, false, exclusionMap, null
        );
        Test.stopTest();

        // Assert
        Assert.isNotNull(results, 'The result map should not be null.');
        List<AccountPhoneNumberAssignmentService.AssignmentWrapper> assignmentWrappers = results.get(activationId);
        Assert.isNotNull(assignmentWrappers, 'Assignments list should not be null.');

        for (AccountPhoneNumberAssignmentService.AssignmentWrapper wrapper : assignmentWrappers) {
            Assert.areNotEqual(assignmentToExclude, wrapper.assignment.Id, 'The excluded assignment should not be in the results.');
        }
    }

    /**
     * @description Tests the getUnusedAssignmentsForActivation method to ensure it returns only unused assignments.
     */
    @isTest
    static void testGetUnusedAssignmentsForActivation() {
        // Arrange
        NorlysTestScenarios.ScenarioBuilder builder = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withNumberSeries('EKC', 'P', 5, 0) // 5 Open series, 0 used
            .withNumberSeries('BRZ', 'P', 5, 0); // 5 Fixed series, 0 used
        
        NorlysTestScenarios.ScenarioResult scenario = builder.build();

        // Set status for 3 open series to be unused ('AR')
        for(Integer i=0; i<3; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AR';
        }
        // Set status for 3 fixed series to be unused ('AA')
        for(Integer i=5; i<8; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AA';
        }
        update scenario.phoneNumberAssignments;

        // Act
        Test.startTest();
        List<Account_Phone_Number_Assignment__c> results = AccountPhoneNumberAssignmentService.getUnusedAssignmentsForActivation(
            scenario.activations[0].Id, 5
        );
        Test.stopTest();

        // Assert
        Assert.isNotNull(results, 'The result should not be null.');
        Assert.areEqual(5, results.size(), 'Expected to retrieve 5 unused assignments.');
    }

    /**
     * @description Tests the overloaded getAssignmentsForActivation method with a map of exclusions.
     */
    @isTest
    static void testGetAssignmentsForActivationWithExclusionMap() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(10)
            .withPhoneNumberAssignments(10)
            .build();

        for(Account_Phone_Number_Assignment__c assignment : scenario.phoneNumberAssignments){
            assignment.Phone_Number_Reservation_Status__c = 'SUCCESS';
        }
        update scenario.phoneNumberAssignments;

        Id activationId = scenario.activations[0].Id;
        Id assignmentToExclude = scenario.phoneNumberAssignments[0].Id;

        Map<Id, Id> exclusionMap = new Map<Id, Id>{
            activationId => assignmentToExclude
        };

        // Act
        Test.startTest();
        List<AccountPhoneNumberAssignmentService.AssignmentWrapper> results = AccountPhoneNumberAssignmentService.getAssignmentsForActivation(
            new List<Id>{ activationId }, 10, false, exclusionMap, null
        );
        Test.stopTest();

        // Assert
        Assert.isNotNull(results, 'The result list should not be null.');
        for (AccountPhoneNumberAssignmentService.AssignmentWrapper wrapper : results) {
            Assert.areNotEqual(assignmentToExclude, wrapper.assignment.Id, 'The excluded assignment should not be in the results.');
        }
    }
}