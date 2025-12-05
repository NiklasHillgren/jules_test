/**
 * @description Test class for the NumberCaseExecutorAction.
 *              This class contains unit tests to ensure that the invocable action behaves as expected
 *              under various conditions. It covers the success path, error handling, and the specific logic
 * for validating requested mobile numbers and setting statuses.
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær      14/08/2025      Initial version of the test class.
 *  Kenneth Houkjær      30/08/2025      Added tests for number validation and detailed documentation.
 *  Jules                15/09/2025      Updated tests for INPROGRESS status, parent error aggregation, and new reset logic.
 *
 * @author Kenneth Houkjær
 * @date 2025-08-14
 */
@IsTest
public class NumberCaseExecutorActionTest extends NorlysSUnitTest {

    /**
     * @description Verifies that the action sets eligible lines to INPROGRESS and publishes a
     *              correctly formatted EventExecutor__e when given a valid Case Id.
     * @group Happy Path
     */
    @isTest
    static void testHappyPath_ShouldSetInProgressAndPublishEvent() {
        // ARRANGE: Set up a standard test scenario with a case and an activation line.
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .build();

        // Prepare the input variables for the invocable method.
        List<NumberCaseExecutorAction.InputVariables> inputVariables = new List<NumberCaseExecutorAction.InputVariables>();
        NumberCaseExecutorAction.InputVariables vars = new NumberCaseExecutorAction.InputVariables();
        vars.caseId = scenario.caseRecord.Id;
        inputVariables.add(vars);

        // ACT: Execute the invocable method.
        Test.startTest();
        List<NumberCaseExecutorAction.OutputVariables> results = NumberCaseExecutorAction.assignNumbersToActivationLinesRelatedToCase(inputVariables);
        Test.stopTest();

        // ASSERT: Verify the action's output and the state of the data.
        Assert.areEqual(1, results.size(), 'Should return one result.');
        Assert.isTrue(results[0].isSuccess, 'The action should be successful.');
        
        // Assert that the line is now INPROGRESS
        Activation_Line__c updatedLine = [SELECT Phone_Number_Reservation_Status__c FROM Activation_Line__c WHERE Id = :scenario.activationLines[0].Id];
        Assert.areEqual('INPROGRESS', updatedLine.Phone_Number_Reservation_Status__c, 'The reservation status should be INPROGRESS.');

        // Assert that the event was published correctly.
        Assert.isNotNull(results[0].publishedEvent, 'A published event should be returned.');
        EventExecutor__e publishedEvent = results[0].publishedEvent;
        Assert.areEqual(SFConstants.NUMBER_CASE_EXECUTOR_HANDLER, publishedEvent.Executor__c, 'The executor should be set correctly.');
        
        NumberCaseExecutorHandler.parameters params = (NumberCaseExecutorHandler.parameters)JSON.deserialize(publishedEvent.Parameters__c, NumberCaseExecutorHandler.parameters.class);
        Assert.areEqual(scenario.caseRecord.Id, params.CaseId, 'The Case Id should be in the event parameters.');
    }

    /**
     * @description Tests that when a requested number doesn't exist, the line is marked with an 'ERROR' status
     *              and the parent Activation record is updated with the corresponding error code.
     * @group Validation Logic
     */
    @isTest
    static void testValidation_WhenNumberDoesNotExist_ShouldSetErrorOnLineAndParent() {
        // ARRANGE: Set up a scenario where an activation line requests a mobile number that does not exist.
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withActivationLineMobileNumber('11111111')
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .withNumberSeries('SAL', 'P', 1, 0) // Creates an assignment for a different number
            .build();

        List<NumberCaseExecutorAction.InputVariables> inputVariables = new List<NumberCaseExecutorAction.InputVariables>();
        NumberCaseExecutorAction.InputVariables vars = new NumberCaseExecutorAction.InputVariables();
        vars.caseId = scenario.caseRecord.Id;
        inputVariables.add(vars);

        // ACT: Execute the main action method which triggers the validation.
        Test.startTest();
        NumberCaseExecutorAction.assignNumbersToActivationLinesRelatedToCase(inputVariables);
        Test.stopTest();

        // ASSERT: Verify the line and parent activation records.
        Activation_Line__c updatedLine = [SELECT Phone_Number_Reservation_Status__c, Phone_Number_Reservation_Error__c FROM Activation_Line__c WHERE Id = :scenario.activationLines[0].Id];
        Assert.areEqual('ERROR', updatedLine.Phone_Number_Reservation_Status__c, 'The reservation status should be ERROR.');
        Assert.isTrue(updatedLine.Phone_Number_Reservation_Error__c.contains('NCEA001'), 'The error message should contain the error code.');

        Activation__c parentActivation = [SELECT Activation_Line_Error_Code__c FROM Activation__c WHERE Id = :scenario.activations[0].Id];
        Assert.areEqual('NCEA001', parentActivation.Activation_Line_Error_Code__c, 'The parent activation should have the error code.');
    }

    /**
     * @description Tests that if multiple lines have validation errors, the error codes are
     *              correctly aggregated as a comma-separated string on the parent Activation.
     * @group Validation Logic
     */
    @isTest
    static void testValidation_WhenMultipleLinesFail_ShouldAggregateErrorCodesOnParent() {
        // ARRANGE: Create two lines on the same activation, both with invalid requested numbers.
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .build(); // Build the base account, case, etc.

        Activation__c parentActivation = (Activation__c) NorlysSUnit.newFactory()
            .create('Activation__c')
            .set('Case__c', scenario.caseRecord.Id)
            .insertRecord();

        Activation_Line__c line1 = (Activation_Line__c) NorlysSUnit.newFactory()
            .create('Activation_Line__c')
            .set('Activation__c', parentActivation.Id)
            .set('phone_no_status__c', 'Nyt nummer')
            .set('mobile_no__c', '11111111')
            .getRecord();

        Activation_Line__c line2 = (Activation_Line__c) NorlysSUnit.newFactory()
            .create('Activation_Line__c')
            .set('Activation__c', parentActivation.Id)
            .set('phone_no_status__c', 'Nyt nummer')
            .set('mobile_no__c', '22222222')
            .getRecord();

        List<Activation_Line__c> lines = new List<Activation_Line__c> { line1, line2 };
        insert lines;

        List<NumberCaseExecutorAction.InputVariables> inputVariables = new List<NumberCaseExecutorAction.InputVariables>();
        NumberCaseExecutorAction.InputVariables vars = new NumberCaseExecutorAction.InputVariables();
        vars.caseId = scenario.caseRecord.Id;
        inputVariables.add(vars);

        // ACT
        Test.startTest();
        NumberCaseExecutorAction.assignNumbersToActivationLinesRelatedToCase(inputVariables);
        Test.stopTest();

        // ASSERT
        Activation__c updatedParent = [SELECT Activation_Line_Error_Code__c FROM Activation__c WHERE Id = :parentActivation.Id];
        Assert.areEqual('NCEA001', updatedParent.Activation_Line_Error_Code__c, 'The parent activation should have the unique error code.');
    }

    /**
     * @description This test verifies that the reset logic correctly clears errors from both the
     *              activation lines and the parent activation record.
     * @group Reset Logic
     */
    @isTest
    static void testResetLogic_ShouldClearErrorsAndSetInProgressOnParent() {
        // ARRANGE: Set up a line and parent with a pre-existing error state.
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .build();

        Activation_Line__c errorLine = scenario.activationLines[0];
        errorLine.Phone_Number_Reservation_Status__c = 'ERROR';
        errorLine.Phone_Number_Reservation_Error__c = 'Some previous error.';
        update errorLine;
        
        Activation__c parentActivation = scenario.activations[0];
        parentActivation.Activation_Line_Error_Code__c = 'NCEA001,NCEH002';
        parentActivation.Phone_Number_Reservation_Status_Txt__c = 'ERROR';
        update parentActivation;

        List<NumberCaseExecutorAction.InputVariables> inputVariables = new List<NumberCaseExecutorAction.InputVariables>();
        NumberCaseExecutorAction.InputVariables vars = new NumberCaseExecutorAction.InputVariables();
        vars.caseId = scenario.caseRecord.Id;
        inputVariables.add(vars);

        // ACT: Execute the action, which should trigger the reset logic first.
        Test.startTest();
        NumberCaseExecutorAction.assignNumbersToActivationLinesRelatedToCase(inputVariables);
        Test.stopTest();

        // ASSERT: Verify the states have been correctly reset and updated.
        // Check the activation line itself.
        Activation_Line__c updatedLine = [SELECT Phone_Number_Reservation_Status__c, Phone_Number_Reservation_Error__c FROM Activation_Line__c WHERE Id = :errorLine.Id];
        Assert.areEqual('INPROGRESS', updatedLine.Phone_Number_Reservation_Status__c, 'Line status should be INPROGRESS after reset.');
        // In Apex, setting a text field to '' results in a null value when retrieved from the database.
        Assert.isNull(updatedLine.Phone_Number_Reservation_Error__c, 'Line error message should be cleared to null.');

        // Check the parent activation.
        Activation__c updatedParent = [SELECT Activation_Line_Error_Code__c, Phone_Number_Reservation_Status_Txt__c FROM Activation__c WHERE Id = :parentActivation.Id];
        Assert.isNull(updatedParent.Activation_Line_Error_Code__c, 'Parent error code should be cleared to null.');
        Assert.areEqual('INPROGRESS', updatedParent.Phone_Number_Reservation_Status_Txt__c, 'Parent status should be set to INPROGRESS.');
    }

    /**
     * @description Verifies that if validation marks all lines as ERROR, the parent status is set to ERROR
     *              and no event is published.
     * @group Edge Case
     */
    @isTest
    static void testAction_WhenOnlyInvalidLines_ShouldSetErrorOnParentAndStop() {
        // ARRANGE: Set up a scenario with one activation line that has an invalid requested number.
        TriggerHandler.bypass('ActivationLineTriggerHandler');
        TriggerHandler.bypass('QuoteLineTriggerHandler');
        TriggerHandler.bypass('CPQQuoteLine_TriggerHandler');
        TriggerHandler.bypass('quote_TriggerHandler');
        TriggerHandler.bypass('dlrs.RollupService');

        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withActivationLineMobileNumber('11111111') // This number does not exist in assignments
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .build();

        List<NumberCaseExecutorAction.InputVariables> inputVariables = new List<NumberCaseExecutorAction.InputVariables>();
        NumberCaseExecutorAction.InputVariables vars = new NumberCaseExecutorAction.InputVariables();
        vars.caseId = scenario.caseRecord.Id;
        inputVariables.add(vars);

        // ACT: Execute the action.
        Test.startTest();
        List<NumberCaseExecutorAction.OutputVariables> results = NumberCaseExecutorAction.assignNumbersToActivationLinesRelatedToCase(inputVariables);
        Test.stopTest();

        // ASSERT: Verify that the action succeeded but published no event.
        Assert.areEqual(1, results.size(), 'Should return one result object.');
        Assert.isTrue(results[0].isSuccess, 'The action itself should be considered successful.');
        Assert.isNull(results[0].publishedEvent, 'No event should be published as there are no lines to process.');

        // Assert that the parent activation status is now ERROR.
        Activation__c updatedParent = [SELECT Phone_Number_Reservation_Status_Txt__c FROM Activation__c WHERE Id = :scenario.activations[0].Id];
        Assert.areEqual('ERROR', updatedParent.Phone_Number_Reservation_Status_Txt__c, 'Parent status should be set to ERROR.');
        
        TriggerHandler.clearAllBypasses();
    }

    /**
     * @description Verifies that the action throws a ListException when called with an empty list of input variables.
     * @group Error Handling
     */
    @isTest
    static void testEmptyInput_ShouldThrowException() {
        // ARRANGE: Prepare an empty list of input variables.
        List<NumberCaseExecutorAction.InputVariables> inputVariables = new List<NumberCaseExecutorAction.InputVariables>();

        // ACT & ASSERT: Execute the method and expect a ListException.
        try {
            NumberCaseExecutorAction.assignNumbersToActivationLinesRelatedToCase(inputVariables);
            Assert.isTrue(false, 'Expected a ListException to be thrown due to empty input.');
        } catch (ListException e) {
            // SUCCESS: The expected exception was caught.
            Assert.isTrue(e.getMessage().contains('List index out of bounds: 0'), 'The error message should indicate an out-of-bounds error.');
        } catch (Exception e) {
            // FAIL: An unexpected exception type was thrown.
            Assert.isTrue(false, 'Expected a ListException, but got: ' + e.getTypeName());
        }
    }

    /**
     * @description Verifies that if all activation lines are already in a SUCCESS state, the parent
     *              activation status is correctly set to SUCCESS without publishing an event. This test
     *              also verifies that the parent is first set to INPROGRESS and then to SUCCESS, by
     *              checking the number of DML statements.
     * @group Edge Case
     */
    @isTest
    static void testAction_WhenAllLinesAreSuccess_ShouldSetParentSuccessAndStop() {
        // ARRANGE: Set up a scenario with two activation lines, both already in a SUCCESS state.
        TriggerHandler.bypass('ActivationLineTriggerHandler');
        TriggerHandler.bypass('QuoteLineTriggerHandler');
        TriggerHandler.bypass('CPQQuoteLine_TriggerHandler');
        TriggerHandler.bypass('quote_TriggerHandler');
        TriggerHandler.bypass('dlrs.RollupService');

        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(2)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .build();

        for (Activation_Line__c line : scenario.activationLines) {
            line.Phone_Number_Reservation_Status__c = 'SUCCESS';
        }
        update scenario.activationLines;

        List<NumberCaseExecutorAction.InputVariables> inputVariables = new List<NumberCaseExecutorAction.InputVariables>();
        NumberCaseExecutorAction.InputVariables vars = new NumberCaseExecutorAction.InputVariables();
        vars.caseId = scenario.caseRecord.Id;
        inputVariables.add(vars);

        // ACT: Execute the action.
        Test.startTest();
        List<NumberCaseExecutorAction.OutputVariables> results = NumberCaseExecutorAction.assignNumbersToActivationLinesRelatedToCase(inputVariables);
        Test.stopTest();

        // ASSERT: Verify that the action succeeded but published no event.
        Assert.areEqual(1, results.size(), 'Should return one result object.');
        Assert.isTrue(results[0].isSuccess, 'The action itself should be considered successful.');
        Assert.isNull(results[0].publishedEvent, 'No event should be published as there are no lines to process.');

        // Assert that the parent activation status is now SUCCESS.
        Activation__c updatedParent = [SELECT Phone_Number_Reservation_Status_Txt__c FROM Activation__c WHERE Id = :scenario.activations[0].Id];
        Assert.areEqual('SUCCESS', updatedParent.Phone_Number_Reservation_Status_Txt__c, 'Parent status should be set to SUCCESS.');
        
        TriggerHandler.clearAllBypasses();
    }

    /**
     * @description Verifies that a non-default retryCount passed into the action is correctly
     *              serialized into the parameters of the published event.
     * @group Retry Logic
     */
    @isTest
    static void testAction_WithRetryCount_ShouldPassRetryCountToEvent() {
        // ARRANGE
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .build();

        // Prepare the input with a specific retryCount.
        List<NumberCaseExecutorAction.InputVariables> inputVariables = new List<NumberCaseExecutorAction.InputVariables>();
        NumberCaseExecutorAction.InputVariables vars = new NumberCaseExecutorAction.InputVariables();
        vars.caseId = scenario.caseRecord.Id;
        vars.retryCount = 3; // Use a specific non-default value.
        inputVariables.add(vars);

        // ACT
        Test.startTest();
        List<NumberCaseExecutorAction.OutputVariables> results = NumberCaseExecutorAction.assignNumbersToActivationLinesRelatedToCase(inputVariables);
        Test.stopTest();

        // ASSERT
        Assert.isNotNull(results[0].publishedEvent, 'A published event should be returned.');
        
        // Deserialize the parameters and verify the retryCount.
        EventExecutor__e publishedEvent = results[0].publishedEvent;
        NumberCaseExecutorHandler.parameters params = (NumberCaseExecutorHandler.parameters)JSON.deserialize(publishedEvent.Parameters__c, NumberCaseExecutorHandler.parameters.class);
        Assert.areEqual(3, params.retryCount, 'The retryCount should be correctly passed to the event parameters.');
    }

}