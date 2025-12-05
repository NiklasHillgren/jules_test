/** 
 * Testing NumberFindChangeNumbersAction class
 * 
 * @author  Kirstine Nielsen
 * @since   25-08-2025
 * @see     https://jira-ks.norlys.dk/browse/DKT-45146
 */
@IsTest
private with sharing class NumberFindChangeNumbersActionTest {

    /**
     * Only one Activation.
     * Under this Activation we have Activation Lines that each are linked to different Assignments.
     * The amount of Activation Lines equals the amount of Assignments.
     * 
     * Expect: receive one joined Assignment, but not joined to the Activation Line in question
     * 
     * NB. We don't need to assert that the the joined assignment returned belongs to the same Activation as the 
     * Activation Line in question, since the test data we set up only creates 1 Activation.
     */
    @IsTest
    private static void activationLinesAndAssignmentsCountEqual() {

        // ARRANGE
        Integer expectedCountAssignmentsJoined = 1;
        Integer expectedCountAssignmentsNonJoined = 0;
        Integer expectedCountAssignmentsTotal = expectedCountAssignmentsJoined + expectedCountAssignmentsNonJoined;

        String cvr = '88888888';
        Integer activationLineCount = 2;
        Integer assignmentCount = 2;
        Integer junctionCount = 2;
        String location = 'SAL';
        String numberGroup = 'P';

        // Prep 2 Activation Lines, 2 Assignments, 2 Junctions
        NorlysTestScenarios.ScenarioResult scenario = getScenarioResultSimple(
            cvr, 
            activationLineCount, 
            location, 
            numberGroup, 
            assignmentCount, 
            junctionCount
        );

        updateUnlinkedAssignmentsStatus(scenario);
        
        Activation_line__c activationLineInQuestion = scenario.activationLines[0];

        // prep input vars list
        List<NumberFindChangeNumbersAction.InputVariables> listOfInputVars = prepInputVarsList(activationLineInQuestion);

        // ACT
        Test.startTest();
        List<NumberFindChangeNumbersAction.OutputVariables> outputVariablesList = 
            NumberFindChangeNumbersAction.getDifferentAccountPhoneNumberAssignments(listOfInputVars);
        Test.stopTest();

        // ASSERT
        NumberFindChangeNumbersAction.OutputVariables singleOutputVars = outputVariablesList[0];

        Assert.areNotEqual(null, singleOutputVars, 'The outputVariablesList should not be null.');
        Assert.areEqual(expectedCountAssignmentsTotal, singleOutputVars.bothJoinedAndNonJoinedAssignments.size(), 'We expect a total of 1 Assignment');
        Assert.areEqual(expectedCountAssignmentsJoined, singleOutputVars.joinedAssignments.size(), 'We expect 1 joined Assignment');
        Assert.areEqual(expectedCountAssignmentsNonJoined, singleOutputVars.nonJoinedAssignments.size(), 'We expect no non-joined Assignment');
        
        // confirm that the assignments returned are not linked to the Activation Line in question
        confirmNoAssignmentsReturnedAreLinkedToActivationLineInQuestion(scenario, singleOutputVars.joinedAssignments, activationLineInQuestion.Id);
    }

    /**
     * Only one Activation.
     * (Total of 2 Assignments)
     * Under this Activation we have 2 Activation Lines that each are linked to the same Assignment.
     * The amount of Activation Lines equals the amount of Assignments (meaning only one Assignment is linked).
     * 
     * Expect: receive one non-joined Assignment
     */
    @IsTest
    private static void activationLinesAndAssignmentsCountEqualJoinedToSame() {

        // ARRANGE
        Integer expectedCountAssignmentsJoined = 0;
        Integer expectedCountAssignmentsNonJoined = 1;
        Integer expectedCountAssignmentsTotal = expectedCountAssignmentsJoined + expectedCountAssignmentsNonJoined;

        String cvr = '88888888';
        Integer activationLineCount = 2;
        Integer assignmentCount = 2;
        Integer junctionCount = 2;
        String location = 'SAL';
        String numberGroup = 'P';

        // Prep 2 Activation Lines, 2 Assignments, 2 Junctions
        NorlysTestScenarios.ScenarioResult scenario = getScenarioResultSimple(
            cvr, 
            activationLineCount, 
            location, 
            numberGroup, 
            assignmentCount, 
            junctionCount
        );

        // Since we want the Activation Lines to be joined with the same Assignment we update 
        Id assignmentIdAllActivationLinesShouldBeJunctionedWith = scenario.activationAssignmentJunctions[0].Account_Phone_Number_Assignment__c;

        for (Activation_Assignment_Junction__c junction : scenario.activationAssignmentJunctions) {
            junction.Account_Phone_Number_Assignment__c = assignmentIdAllActivationLinesShouldBeJunctionedWith;
        }
        update scenario.activationAssignmentJunctions;

        updateUnlinkedAssignmentsStatus(scenario);
        
        // we have 2 Activation Lines and both are linked to the same Assignment
        Activation_line__c activationLineInQuestion = scenario.activationLines[0];

        // prep input vars list
        List<NumberFindChangeNumbersAction.InputVariables> listOfInputVars = prepInputVarsList(activationLineInQuestion);

        // ACT
        Test.startTest();
        List<NumberFindChangeNumbersAction.OutputVariables> outputVariablesList =
            NumberFindChangeNumbersAction.getDifferentAccountPhoneNumberAssignments(listOfInputVars);
        Test.stopTest();

        // ASSERT
        NumberFindChangeNumbersAction.OutputVariables singleOutputVars = outputVariablesList[0];

        Assert.areNotEqual(null, singleOutputVars, 'The outputVariablesList should not be null.');
        Assert.areEqual(expectedCountAssignmentsTotal, singleOutputVars.bothJoinedAndNonJoinedAssignments.size(), 'We expect a total of 1 Assignment');
        Assert.areEqual(expectedCountAssignmentsJoined, singleOutputVars.joinedAssignments.size(), 'We expect 0 joined Assignment');
        Assert.areEqual(expectedCountAssignmentsNonJoined, singleOutputVars.nonJoinedAssignments.size(), 'We expect 1 no non-joined Assignment');
    }

    /**
     * Only one Activation.
     * (total of 3 Assignments)
     * Under the Activation we have Activation Lines that each are linked to different Assignments.
     * Under the Account there are additionally 1 non-joined Assignment.
     * 
     * Expect: receive two Assignments. 
     *         1 joined Assignment, but not joined to the Activation Line in question
     *         1 non-joined Assignment
     * 
     * NB. We don't need to assert that the the joined assignment returned belongs to the same Activation as the 
     * Activation Line in question, since the test data we set up only creates 1 Activation.
     */
    @IsTest
    private static void unlinkedAssignment() {

        // ARRANGE
        Integer expectedCountAssignmentsJoined = 1;
        Integer expectedCountAssignmentsNonJoined = 1;
        Integer expectedCountAssignmentsTotal = expectedCountAssignmentsJoined + expectedCountAssignmentsNonJoined;

        String cvr = '88888888';
        Integer activationLineCount = 2;
        Integer assignmentCount = 3;
        Integer junctionCount = 2;
        String location = 'SAL';
        String numberGroup = 'P';

        // Prep 2 Activation Lines, 3 Assignments, 2 Junctions
        NorlysTestScenarios.ScenarioResult scenario = getScenarioResultSimple(
            cvr, 
            activationLineCount, 
            location, 
            numberGroup, 
            assignmentCount, 
            junctionCount
        );

        updateUnlinkedAssignmentsStatus(scenario);
        
        Activation_line__c activationLineInQuestion = scenario.activationLines[0];

        // prep input vars list
        List<NumberFindChangeNumbersAction.InputVariables> listOfInputVars = prepInputVarsList(activationLineInQuestion);

        // ACT
        Test.startTest();
        List<NumberFindChangeNumbersAction.OutputVariables> outputVariablesList = 
            NumberFindChangeNumbersAction.getDifferentAccountPhoneNumberAssignments(listOfInputVars);
        Test.stopTest();

        // ASSERT
        NumberFindChangeNumbersAction.OutputVariables singleOutputVars = outputVariablesList[0];

        Assert.areNotEqual(null, singleOutputVars, 'The outputVariablesList should not be null.');
        Assert.areEqual(expectedCountAssignmentsTotal, singleOutputVars.bothJoinedAndNonJoinedAssignments.size(), 'We expect a total of 2 Assignment');
        Assert.areEqual(expectedCountAssignmentsJoined, singleOutputVars.joinedAssignments.size(), 'We expect 1 joined Assignment');
        Assert.areEqual(expectedCountAssignmentsNonJoined, singleOutputVars.nonJoinedAssignments.size(), 'We expect 1 non-joined Assignment');
        
        // confirm that the assignments returned are not linked to the Activation Line in question
        confirmNoAssignmentsReturnedAreLinkedToActivationLineInQuestion(scenario, singleOutputVars.joinedAssignments, activationLineInQuestion.Id);
    }

    /**
     * 2 Accounts (Account1 and Account2). Each has one Activation.
     * 
     * Account1: (total of 3 Assignments)
     *      - 2 Activation Lines joined to different Assignments.
     *      - 1 Assignment not linked to any Activation Line.
     * 
     * Account2: (total of 1 Assignment)
     *      - 1 Assignment not linked to any Activation Line.
     * 
     * Expect: receive:
     *      - 1 joined Assignment, but not joined to the Activation Line in question.
     *      - 1 non-joined Assignment that belongs to the same Account that the Activation Line in question belongs to
     *        (which is Account1).    
     */
    @IsTest
    private static void doNotReturnUnlinkedAssignmentsUnderIrrelevantAccount() {

        // ARRANGE
        Integer expectedCountAssignmentsJoined = 1;
        Integer expectedCountAssignmentsNonJoined = 1;
        Integer expectedCountAssignmentsTotal = expectedCountAssignmentsJoined + expectedCountAssignmentsNonJoined;

        String cvrAccount1 = '88888888';
        Integer activationLineCountAccount1 = 2;
        Integer assignmentCountAccount1 = 3;
        Integer junctionCountAccount1 = 2;
        
        String cvrAccount2 = '11111111';
        Integer activationLineCountAccount2 = 0;
        Integer assignmentCountAccount2 = 1;
        Integer junctionCountAccount2 = 0;

        String location = 'SAL';
        String numberGroup = 'P';

        // Prep 2 Activation Lines, 2 Assignments, 2 Junctions
        NorlysTestScenarios.ScenarioResult scenarioAccount1 = getScenarioResultSimple(
            cvrAccount1, 
            activationLineCountAccount1, 
            location, 
            numberGroup, 
            assignmentCountAccount1, 
            junctionCountAccount1
        );
        Account account1 = scenarioAccount1.account;

        updateUnlinkedAssignmentsStatus(scenarioAccount1);

        // create account2
        Account account2 = new Account(Name = 'Account2', CVR__c = cvrAccount2);
        insert account2;

        // create series for account2
        Account_Phone_Number_Series__c seriesForAccount2 = new Account_Phone_Number_Series__c(
            Account__c = account2.Id,
            Number_Group__c = numberGroup,
            Number_Location__c = location,
            Product_Type__c = 'GSM'
        );
        insert seriesForAccount2;

        // create non-joined assignment for account2 (this should never be returned because it doesn't belong to account1)
        Account_Phone_Number_Assignment__c assignmentForAccount2 = new Account_Phone_Number_Assignment__c(
            Account_Phone_Number_Series__c = seriesForAccount2.Id
        );
        insert assignmentForAccount2;

        Activation_line__c activationLineInQuestion = scenarioAccount1.activationLines[0];

        // prep input vars list
        List<NumberFindChangeNumbersAction.InputVariables> listOfInputVars = prepInputVarsList(activationLineInQuestion);

        // ACT
        Test.startTest();
        List<NumberFindChangeNumbersAction.OutputVariables> outputVariablesList = 
            NumberFindChangeNumbersAction.getDifferentAccountPhoneNumberAssignments(listOfInputVars);
        Test.stopTest();

        // ASSERT
        NumberFindChangeNumbersAction.OutputVariables singleOutputVars = outputVariablesList[0];

        Assert.areNotEqual(null, singleOutputVars, 'The outputVariablesList should not be null.');
        Assert.areEqual(expectedCountAssignmentsTotal, singleOutputVars.bothJoinedAndNonJoinedAssignments.size(), 'We expect a total of 2 Assignment');
        Assert.areEqual(expectedCountAssignmentsJoined, singleOutputVars.joinedAssignments.size(), 'We expect 1 joined Assignment');
        Assert.areEqual(expectedCountAssignmentsNonJoined, singleOutputVars.nonJoinedAssignments.size(), 'We expect 1 non-joined Assignment');
        
        // confirm that the non-joined Assignments are linked to the same Account as the Activation Line in question
        Account_Phone_Number_Assignment__c assignmentRequeried = [
            SELECT Id, Account_Phone_Number_Series__r.Account__c 
            FROM Account_Phone_Number_Assignment__c
            WHERE Id = :singleOutputVars.nonJoinedAssignments[0].Id  // we know in this test case there is only 1
        ]; 
        Assert.areEqual(account1.Id, assignmentRequeried.Account_Phone_Number_Series__r.Account__c, 'The Account Id on the Assignment is wrong');

        // confirm that the assignments returned are not linked to the Activation Line in question
        confirmNoAssignmentsReturnedAreLinkedToActivationLineInQuestion(scenarioAccount1, singleOutputVars.joinedAssignments, activationLineInQuestion.Id);
    }

    /**
     * Two Activations under same Account.
     * (Total of 4 Assignments -> 2 for each Activation)
     * Each Activation has 2 Activation Lines linked to different Assignments.
     * 
     * Expect: receive two Assignments. 
     *         1 joined Assignment that are joined to an Activation Line that has same parent Activation as the 
     *         Activation Line in question, AND the Assignment is not joined to the Activation Line in question.
     */
    @IsTest
    private static void doNotIncludeLinkedAssignmentsFromOtherActivation() {

        // ARRANGE
        Integer expectedCountAssignmentsJoined = 1;
        Integer expectedCountAssignmentsNonJoined = 0;
        Integer expectedCountAssignmentsTotal = expectedCountAssignmentsJoined + expectedCountAssignmentsNonJoined;

        String cvr = '88888888';
        Integer activationLineCount = 2;  // 2 for each Activations
        Integer assignmentCount = 4;
        Integer junctionCount = 4;
        String location = 'SAL';
        String numberGroup = 'P';

        // Prep 4 Activation Lines, 4 Assignments, 4 Junctions
        NorlysTestScenarios.ScenarioResult scenario = getScenarioResultTwoActivationsOneAccount(
            cvr, 
            activationLineCount, 
            location, 
            numberGroup, 
            assignmentCount, 
            junctionCount
        );

        Activation_line__c activationLineInQuestion = scenario.activationLines[0];
        
        Id parentActivationId = activationLineInQuestion.Activation__c;

        // prep input vars list
        List<NumberFindChangeNumbersAction.InputVariables> listOfInputVars = prepInputVarsList(activationLineInQuestion);

        // ACT
        Test.startTest();
        List<NumberFindChangeNumbersAction.OutputVariables> outputVariablesList = 
            NumberFindChangeNumbersAction.getDifferentAccountPhoneNumberAssignments(listOfInputVars);
        Test.stopTest();

        // ASSERT
        NumberFindChangeNumbersAction.OutputVariables singleOutputVars = outputVariablesList[0];

        Assert.areNotEqual(null, singleOutputVars, 'The outputVariablesList should not be null.');
        Assert.areEqual(expectedCountAssignmentsTotal, singleOutputVars.bothJoinedAndNonJoinedAssignments.size(), 'We expect a total of 1 Assignment');
        Assert.areEqual(expectedCountAssignmentsJoined, singleOutputVars.joinedAssignments.size(), 'We expect 1 joined Assignment');
        Assert.areEqual(expectedCountAssignmentsNonJoined, singleOutputVars.nonJoinedAssignments.size(), 'We expect no non-joined Assignment');

        // confirm that the joined Assignments are linked to the same Activation as the Activation Line in question
        confirmAssignmentsReturnedBelongToCorrectParentActivation(
            scenario,
            parentActivationId, 
            singleOutputVars.joinedAssignments, 
            activationLineInQuestion.Id
        );

        // confirm that the assignments returned are not linked to the Activation Line in question
        confirmNoAssignmentsReturnedAreLinkedToActivationLineInQuestion(scenario, singleOutputVars.joinedAssignments, activationLineInQuestion.Id);
    }
    
    /**
     * @descripton helper method to get the ScenarioResult for a simple scenario
     * @param cvr 
     * @param activationLineCount 
     * @param location
     * @param numberGroup
     * @param assignmentCount
     * @param junctionCount
     * @return NorlysTestScenarios.ScenarioResult
     */
    private static NorlysTestScenarios.ScenarioResult getScenarioResultSimple(
        String cvr,
        Integer activationLineCount, 
        String location, 
        String numberGroup, 
        Integer assignmentCount, 
        Integer junctionCount) { 
        
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr(cvr)
            .forNumberCaseHandling()
            .withActivationLines(activationLineCount)
            .withNumberSeries(location, numberGroup, assignmentCount, junctionCount)
            .build();
        return scenario;
    }
    
    /**
     * @descripton helper method to get the ScenarioResult for a scenario where we need 2 Activations under one Account
     * @param cvr 
     * @param activationLineCount 
     * @param location
     * @param numberGroup
     * @param assignmentCount
     * @param junctionCount
     * @return NorlysTestScenarios.ScenarioResult
     */
    private static NorlysTestScenarios.ScenarioResult getScenarioResultTwoActivationsOneAccount(
        String cvr,
        Integer activationLineCount, 
        String location, 
        String numberGroup, 
        Integer assignmentCount, 
        Integer junctionCount) { 
        
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr(cvr)
            .forNumberCaseHandling()
            .withActivations(2)
            .withActivationLines(activationLineCount)
            .withNumberSeries(location, numberGroup, assignmentCount, junctionCount)
            .build();
        return scenario;
    }

    /**
     * @description Utility to prepare an input vars list
     * @param activationLineInQuestion The Activation Line of interest
     * @return List<NumberFindChangeNumbersAction.InputVariables> listOfInputVars
     */
    private static List<NumberFindChangeNumbersAction.InputVariables> prepInputVarsList(Activation_line__c activationLineInQuestion) {
        // prep input vars list
        List<NumberFindChangeNumbersAction.InputVariables> listOfInputVars = new List<NumberFindChangeNumbersAction.InputVariables>();
        
        // prep single input vars and add to the list
        NumberFindChangeNumbersAction.InputVariables inputVars = new NumberFindChangeNumbersAction.InputVariables();
        inputVars.activationLine = activationLineInQuestion;
        listOfInputVars.add(inputVars);
        return listOfInputVars;
    }

    /**
     * @description Asserts that none of the Assignments are linked to the Activation Line in question.
     * @param scenario The ScenarioResult
     * @param bothJoinedAndNonJoinedAssignments The Assignments to be checked
     * @param activationLineIdInQuestion The Id of the Activation Line in question
     * @return void
     */
    private static void confirmNoAssignmentsReturnedAreLinkedToActivationLineInQuestion(
        NorlysTestScenarios.ScenarioResult scenario,
        List<Account_Phone_Number_Assignment__c> joinedAssignments,
        Id activationLineIdInQuestion) {
        
        Boolean atLeastOneJunctionToMatchOnFound = false;
        // confirm that the joinedAssignments returned are not linked to the Activation Line in question
        for (Account_Phone_Number_Assignment__c assignment : joinedAssignments) {

            // find the junctions that are linked to the Activation Line in question
            for (Activation_Assignment_Junction__c junction : scenario.activationAssignmentJunctions) {

                // assert that the assignment on the junction is not matching the assignments returned
                if (junction.Activation_line__c == activationLineIdInQuestion) {    
                    atLeastOneJunctionToMatchOnFound = true;             
                    Assert.areNotEqual(
                        assignment.Id, 
                        junction.Account_Phone_Number_Assignment__c, 
                        'The Assignment returned should not be linked to the Activation Line in question.'
                    );
                }
            }            
        }
        if (joinedAssignments.size() > 0) {
            Assert.isTrue(atLeastOneJunctionToMatchOnFound, 'At least one junction to match on should be found');
        }
    }

    /**
     * @description Asserts that the Assignments returned are linked to the correct parent Activation
     * @param scenario The ScenarioResult
     * @param parentActivationId The Id of the parent Activation
     * @param outputJoinedAssignments The Assignments returned
     * @param activationLineInQuestionId The Id of the Activation Line in question
     * @return void
     */
    private static void confirmAssignmentsReturnedBelongToCorrectParentActivation(
        NorlysTestScenarios.ScenarioResult scenario,
        Id parentActivationId, 
        List<Account_Phone_Number_Assignment__c> outputJoinedAssignments,
        Id activationLineInQuestionId) {

        // get list of Junction Ids because we need to requery the Junctions to get more fields available
        List<Id> junctionIdList = new List<Id>();
        // these are junctions that are for activation lines for both Activations
        for (Activation_Assignment_Junction__c junction : scenario.activationAssignmentJunctions) {
            junctionIdList.add(junction.Id);
        }

        // requery junctions because we need more fields (junctions can be for AL's below different Activations)
        List<Activation_Assignment_Junction__c> junctionsRequeried = [
            SELECT
                Id,
                Account_Phone_Number_Assignment__c,
                Activation_line__c,
                Activation_line__r.Activation__c
            FROM Activation_Assignment_Junction__c
            WHERE Id IN :junctionIdList
        ];

        // check the assignments belong to the same activation as the Activation Line in question
        for (Account_Phone_Number_Assignment__c assignment : outputJoinedAssignments) {
            Boolean assignmentBelongsToTheActivation = assignmentBelongsToActivation(
                parentActivationId, 
                assignment, 
                junctionsRequeried
            );
            Assert.isTrue(assignmentBelongsToTheActivation, 'The assignment returned should be linked to the same Activation as the Activation Line in question');
        }
    }

    /**
     * @description Confirms that the assignment belongs to the Activation
     * @param parentActivationId The Id of the parent Activation
     * @param assignment The assignment to check
     * @param junctions The list of junctions to check
     * @return Boolean True if it belongs to the activation, false otherwise
     */
    private static Boolean assignmentBelongsToActivation(
        Id parentActivationId, 
        Account_Phone_Number_Assignment__c assignment, 
        List<Activation_Assignment_Junction__c> junctions) {

        Boolean assignmentBelongsToActivation = false;
        for (Activation_Assignment_Junction__c junction : junctions) {
            if (junction.Activation_Line__r.Activation__c == parentActivationId && junction.Account_Phone_Number_Assignment__c == assignment.Id) {
                assignmentBelongsToActivation = true;
            }
        }
        return assignmentBelongsToActivation;
    }

    private static void updateUnlinkedAssignmentsStatus(NorlysTestScenarios.ScenarioResult scenario) {
        List<Account_Phone_Number_Assignment__c> allAssignments = [
            SELECT Id, CTN_Number_Status__c, Account_Phone_Number_Series__r.Open_Number_Series__c
            FROM Account_Phone_Number_Assignment__c
            WHERE Account_Phone_Number_Series__r.Account__c = :scenario.account.Id
        ];
        Set<Id> linkedAssignmentIds = new Set<Id>();
        for (Activation_Assignment_Junction__c junction : scenario.activationAssignmentJunctions) {
            linkedAssignmentIds.add(junction.Account_Phone_Number_Assignment__c);
        }
        List<Account_Phone_Number_Assignment__c> assignmentsToUpdate = new List<Account_Phone_Number_Assignment__c>();
        for (Account_Phone_Number_Assignment__c assignment : allAssignments) {
            if (!linkedAssignmentIds.contains(assignment.Id)) {
                if (assignment.Account_Phone_Number_Series__r.Open_Number_Series__c) {
                    assignment.CTN_Number_Status__c = 'AR';
                } else {
                    assignment.CTN_Number_Status__c = 'AA';
                }
                assignmentsToUpdate.add(assignment);
            }
        }
        if (!assignmentsToUpdate.isEmpty()) {
            update assignmentsToUpdate;
        }
    }
}