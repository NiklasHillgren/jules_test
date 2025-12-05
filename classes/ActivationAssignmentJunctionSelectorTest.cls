/**
 * @description Test class for the ActivationAssignmentJunctionSelector class.
 * It verifies that the selector methods return the correct data.
 *  -----------------------------------------------------------------------------
 *  Developer               Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær         2025-08-19      Initial version.
 *  Kirstine Nielsen        2025-08-28      Add getJunctionsList_validIds_returnsList method
 *
 * @author Kenneth Houkjær
 * @date 2025-08-19
 */
@isTest
private class ActivationAssignmentJunctionSelectorTest {

    /**
     * @description Tests that the getJunctionsMap method returns a map of junction records when given valid assignment and activation line Ids.
     */
    @isTest
    static void getJunctionsMap_validIds_returnsMap() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withProducts(2)
            .withNumberSeries('EKC', 'P', 2, 2)
            .build();

        Set<Id> assignmentIds = new Set<Id>();
        for (Account_Phone_Number_Assignment__c assignment : scenario.phoneNumberAssignments) {
            assignmentIds.add(assignment.Id);
        }

        Set<Id> activationLineIds = new Set<Id>();
        for (Activation_Line__c activationLine : scenario.activationLines) {
            activationLineIds.add(activationLine.Id);
        }

        // Act
        Test.startTest();
        Map<String, Activation_Assignment_Junction__c> result = ActivationAssignmentJunctionSelector.getJunctionsMap(assignmentIds, activationLineIds);
        Test.stopTest();

        // Assert
        Assert.areEqual(2, result.size(), 'Should return two junctions.');
        Assert.isTrue(result.containsKey(scenario.phoneNumberAssignments[0].Id + '-' + scenario.activationLines[0].Id), 'Should contain junction 1.');
        Assert.isTrue(result.containsKey(scenario.phoneNumberAssignments[1].Id + '-' + scenario.activationLines[1].Id), 'Should contain junction 2.');
    }
    
    /**
     * @description Tests that the getActivationAssignmentJunctionsByAcativationLineIds method returns a list of 
     * Activation_Assignment_Junction__c records that are associated with the Activation_line__c record Ids passed in.
     */
    @isTest
    private static void getJunctionsList_validIds_returnsList() {
        // ARRANGE
        Integer activationLineCount = 2;
        Integer assignmentCount = 2;
        Integer junctionCount = 2;
        String location = 'SAL';
        String numberGroup = 'P';

        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(activationLineCount)
            .withNumberSeries(location, numberGroup, assignmentCount, junctionCount)
            .build();

        Set<Id> activationLineIds = new Set<Id>();
        for (Activation_Line__c activationLine : scenario.activationLines) {
            activationLineIds.add(activationLine.Id);
        }

        // ACT
        Test.startTest();

        List<Activation_Assignment_Junction__c> result = ActivationAssignmentJunctionSelector.getActivationAssignmentJunctionsByAcativationLineIds(activationLineIds);
        
        Test.stopTest();

        // ASSERT
        Assert.areEqual(junctionCount, result.size(), 'Should return two junctions.');
        // loop through the junctions and confirm that they are associated with the correct Activation Line
        for (Activation_Assignment_Junction__c junction : result) {
            Assert.isTrue(activationLineIds.contains(junction.Activation_line__c), 'Junction is not associated with the correct Activation Line.');
        }
    }
}