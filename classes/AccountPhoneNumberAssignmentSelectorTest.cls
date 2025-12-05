/**
 * @description
 *  Test class for the AccountPhoneNumberAssignmentSelector, using the SUnit framework.
 *  It verifies that the selector correctly retrieves phone number assignments.
 * @group SUnit
 */
@isTest
private class AccountPhoneNumberAssignmentSelectorTest extends NorlysSUnitTest {

    /**
     * @description Tests the getActivationsWithCaseAccounts method.
     */
    @isTest
    static void testGetActivationsWithCaseAccounts() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withNumberSeries('BRZ', 'P', 1, 1)
            .build();

        // Act
        Test.startTest();
        List<Activation__c> results = AccountPhoneNumberAssignmentSelector.getActivationsWithCaseAccounts(
            new Set<Id>{ scenario.activations[0].Id }
        );
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, results, 'The result should not be null.');
        System.assertEquals(1, results.size(), 'Expected to retrieve 1 activation.');
        System.assertNotEquals(null, results[0].Case__r.AccountId, 'The activation should have a related account.');
    }

    /**
     * @description Tests the getInUseAssignments method.
     */
    @isTest
    static void testGetInUseAssignments() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withNumberSeries('BRZ', 'P', 1, 1)
            .build();

        // Act
        Test.startTest();
        Map<Id, Account_Phone_Number_Assignment__c> results = AccountPhoneNumberAssignmentSelector.getInUseAssignments();
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, results, 'The result should not be null.');
        System.assertEquals(1, results.size(), 'Expected to retrieve 1 in-use assignment.');
    }

    /**
     * @description Tests the getUnusedAssignmentsByAccountIds method.
     */
    @isTest
    static void testGetUnusedAssignmentsByAccountIds() {
        // Arrange
        // Open series with 5 assignments, 2 of which are AR (unused)
        NorlysTestScenarios.ScenarioBuilder builder = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withNumberSeries('EKC', 'P', 5, 0);
        
        // Fixed series with 5 assignments, 3 of which are AA (unused)
        builder.withNumberSeries('BRZ', 'P', 5, 0);

        NorlysTestScenarios.ScenarioResult scenario = builder.build();
        
        // Set statuses for open series
        for(Integer i=0; i<2; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AR';
        }
        for(Integer i=2; i<5; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'anything else';
        }
        
        // Set statuses for fixed series
        for(Integer i=5; i<8; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AA';
        }
        for(Integer i=8; i<10; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'anything else';
        }
        update scenario.phoneNumberAssignments;
        
        Set<Id> accountIds = new Set<Id>{ scenario.account.Id };

        // Act
        Test.startTest();
        List<Account_Phone_Number_Assignment__c> results = AccountPhoneNumberAssignmentSelector.getUnusedAssignmentsByAccountIds(accountIds);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, results, 'The result should not be null.');
        System.assertEquals(5, results.size(), 'Expected to retrieve 5 unused assignments (2 open AR + 3 fixed AA).');

        // Verify the sort order: fixed series (Open_Number_Series__c = false) should come first.
        Boolean foundOpenSeries = false;
        for (Account_Phone_Number_Assignment__c assignment : results) {
            if (assignment.Open_Number_Series__c) {
                foundOpenSeries = true;
            } else {
                // If we find a fixed series number after already finding an open series, the sort is wrong.
                System.assert(!foundOpenSeries, 'Incorrect sort order: found a fixed series assignment after an open series assignment.');
            }
        }
    }

    /**
     * @description Tests the getJunctionsByActivationIds method.
     */
    @isTest
    static void testGetJunctionsByActivationIds() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withNumberSeries('BRZ', 'P', 1, 1)
            .build();

        // Act
        Test.startTest();
        List<Activation_Assignment_Junction__c> results = AccountPhoneNumberAssignmentSelector.getJunctionsByActivationIds(
            new Set<Id>{ scenario.activations[0].Id }
        );
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, results, 'The result should not be null.');
        System.assertEquals(1, results.size(), 'Expected to retrieve 1 junction record.');
    }

    /**
     * @description Tests the getAssignmentsByIds method.
     */
    @isTest
    static void testGetAssignmentsByIds() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withPhoneNumberAssignments(1)
            .withoutCaseAndActivations()
            .build();

        // Act
        Test.startTest();
        Map<Id, Account_Phone_Number_Assignment__c> results = AccountPhoneNumberAssignmentSelector.getAssignmentsByIds(
            new Set<Id>{ scenario.phoneNumberAssignments[0].Id }
        );
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, results, 'The result should not be null.');
        System.assertEquals(1, results.size(), 'Expected to retrieve 1 assignment.');
    }

    /**
     * @description Tests the getUnusedAssignments method.
     */
    @isTest
    static void testGetUnusedAssignments() {
        // Arrange
        // Open series with 5 assignments, 2 of which are AR (unused)
        NorlysTestScenarios.ScenarioBuilder builder = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withNumberSeries('EKC', 'P', 5, 0);
        
        // Fixed series with 5 assignments, 3 of which are AA (unused)
        builder.withNumberSeries('BRZ', 'P', 5, 0);

        NorlysTestScenarios.ScenarioResult scenario = builder.build();
        
        // Set statuses for open series
        for(Integer i=0; i<2; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AR';
        }
        for(Integer i=2; i<5; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'anything else';
        }
        
        // Set statuses for fixed series
        for(Integer i=5; i<8; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AA';
        }
        for(Integer i=8; i<10; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'anything else';
        }
        update scenario.phoneNumberAssignments;
        
        Set<Id> accountIds = new Set<Id>{ scenario.account.Id };

        // Act
        Test.startTest();
        List<Account_Phone_Number_Assignment__c> results = AccountPhoneNumberAssignmentSelector.getUnusedAssignments(accountIds, new Set<Id>());
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, results, 'The result should not be null.');
        System.assertEquals(5, results.size(), 'Expected to retrieve 5 unused assignments (2 open AR + 3 fixed AA).');

        // Verify the sort order: fixed series (Open_Number_Series__c = false) should come first.
        Boolean foundOpenSeries = false;
        for (Account_Phone_Number_Assignment__c assignment : results) {
            if (assignment.Open_Number_Series__c) {
                foundOpenSeries = true;
            } else {
                // If we find a fixed series number after already finding an open series, the sort is wrong.
                System.assert(!foundOpenSeries, 'Incorrect sort order: found a fixed series assignment after an open series assignment.');
            }
        }
    }

    /**
     * @description Tests the getUnusedAssignments method with an exclusion set.
     */
    @isTest
    static void testGetUnusedAssignmentsWithExclusion() {
        // Arrange
        // Open series with 5 assignments, 2 of which are AR (unused)
        NorlysTestScenarios.ScenarioBuilder builder = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withNumberSeries('EKC', 'P', 5, 0);
        
        // Fixed series with 5 assignments, 3 of which are AA (unused)
        builder.withNumberSeries('BRZ', 'P', 5, 0);

        NorlysTestScenarios.ScenarioResult scenario = builder.build();
        
        // Set statuses for open series
        for(Integer i=0; i<2; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AR';
        }
        for(Integer i=2; i<5; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'anything else';
        }
        
        // Set statuses for fixed series
        for(Integer i=5; i<8; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AA';
        }
        for(Integer i=8; i<10; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'anything else';
        }
        update scenario.phoneNumberAssignments;
        
        Set<Id> accountIds = new Set<Id>{ scenario.account.Id };
        Set<Id> exclusionSet = new Set<Id>{ scenario.phoneNumberAssignments[0].Id }; // Exclude one of the 'AR' assignments

        // Act
        Test.startTest();
        List<Account_Phone_Number_Assignment__c> results = AccountPhoneNumberAssignmentSelector.getUnusedAssignments(accountIds, exclusionSet);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, results, 'The result should not be null.');
        System.assertEquals(4, results.size(), 'Expected to retrieve 4 unused assignments.');
        for (Account_Phone_Number_Assignment__c assignment : results) {
            System.assert(!exclusionSet.contains(assignment.Id), 'The excluded assignment should not be in the results.');
        }

        // Verify the sort order: fixed series (Open_Number_Series__c = false) should come first.
        Boolean foundOpenSeries = false;
        for (Account_Phone_Number_Assignment__c assignment : results) {
            if (assignment.Open_Number_Series__c) {
                foundOpenSeries = true;
            } else {
                // If we find a fixed series number after already finding an open series, the sort is wrong.
                System.assert(!foundOpenSeries, 'Incorrect sort order: found a fixed series assignment after an open series assignment.');
            }
        }
    }
    /**
     * @description Tests the getSpecificUnusedAssignmentsByNumber method.
     */
    @isTest
    static void testGetSpecificUnusedAssignmentsByNumber() {
        // Arrange
        // Open series with 5 assignments, 2 of which are AR (unused)
        NorlysTestScenarios.ScenarioBuilder builder = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withNumberSeries('EKC', 'P', 5, 0);
        
        // Fixed series with 5 assignments, 3 of which are AA (unused)
        builder.withNumberSeries('BRZ', 'P', 5, 0);

        NorlysTestScenarios.ScenarioResult scenario = builder.build();
        
        // Set statuses for open series
        for(Integer i=0; i<2; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AR';
        }
        for(Integer i=2; i<5; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'anything else';
        }
        
        // Set statuses for fixed series
        for(Integer i=5; i<8; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'AA';
        }
        for(Integer i=8; i<10; i++) {
            scenario.phoneNumberAssignments[i].CTN_Number_Status__c = 'anything else';
        }
        update scenario.phoneNumberAssignments;
        
        Id accountId = scenario.account.Id;
        List<String> requestedNumbers = new List<String>{
            scenario.phoneNumberAssignments[0].Phone_Number__c, // open series, AR
            scenario.phoneNumberAssignments[5].Phone_Number__c, // fixed series, AA
            scenario.phoneNumberAssignments[2].Phone_Number__c  // open series, not unused
        };

        // Act
        Test.startTest();
        List<Account_Phone_Number_Assignment__c> results = AccountPhoneNumberAssignmentSelector.getSpecificUnusedAssignmentsByNumber(accountId, requestedNumbers);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, results, 'The result should not be null.');
        System.assertEquals(2, results.size(), 'Expected to retrieve 2 specific unused assignments.');

        // Verify the sort order: fixed series (Open_Number_Series__c = false) should come first.
        Boolean foundOpenSeries = false;
        for (Account_Phone_Number_Assignment__c assignment : results) {
            if (assignment.Open_Number_Series__c) {
                foundOpenSeries = true;
            } else {
                // If we find a fixed series number after already finding an open series, the sort is wrong.
                System.assert(!foundOpenSeries, 'Incorrect sort order: found a fixed series assignment after an open series assignment.');
            }
        }
    }
}