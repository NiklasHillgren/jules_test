/**
 * @description Test class for the NumberReservationExecutorAction.
 * It verifies that the invocable action correctly chunks assignments
 * and prepares the appropriate events for the NumberReservationExecutorHandler.
 * @group SUnit
 */
@isTest
private class NumberReservationExecutorActionTest {
   
    /**
     * @description Given a list of assignments larger than the chunk size,
     * when the action is executed, then it prepares multiple chunked events.
     */
    @isTest
    static void givenAssignmentsExceedingChunkSize_whenReserveAssignments_thenPreparesChunkedEvents() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withPhoneNumberAssignments(3)
            .build();
        
        List<String> assignmentIds = new List<String>();
        for(Account_Phone_Number_Assignment__c a : scenario.phoneNumberAssignments) {
            assignmentIds.add(a.Id);
        }

        List<NumberReservationExecutorAction.InputVariables> inputVariables = new List<NumberReservationExecutorAction.InputVariables>();
        NumberReservationExecutorAction.InputVariables vars = new NumberReservationExecutorAction.InputVariables();
        vars.chunkSize = 2;
        vars.phoneNumberAssignments = assignmentIds;
        inputVariables.add(vars);

        // Act
        List<NumberReservationExecutorAction.OutputVariables> results = NumberReservationExecutorAction.reservePhoneNumberAssignments(inputVariables);

        // Assert
        Assert.areEqual(1, results.size(), 'Should return one result object.');
        Assert.isNotNull(results[0].publishedEvents, 'A list of prepared events should be returned.');
        Assert.areEqual(2, results[0].publishedEvents.size(), 'Should prepare 2 events for 3 assignments chunked by 2.');
        
        EventExecutor__e firstEvent = results[0].publishedEvents[0];
        Assert.areEqual(SFConstants.NUMBER_RESERVATION_EXECUTOR_HANDLER, firstEvent.Executor__c, 'The executor should be set correctly on the first event.');
        NumberReservationExecutorHandler.parameters firstParams = (NumberReservationExecutorHandler.parameters)JSON.deserialize(firstEvent.Parameters__c, NumberReservationExecutorHandler.parameters.class);
        Assert.areEqual(2, firstParams.assignmentIds.size(), 'The first event should contain 2 assignment Ids.');

        EventExecutor__e secondEvent = results[0].publishedEvents[1];
        Assert.areEqual(SFConstants.NUMBER_RESERVATION_EXECUTOR_HANDLER, secondEvent.Executor__c, 'The executor should be set correctly on the second event.');
        NumberReservationExecutorHandler.parameters secondParams = (NumberReservationExecutorHandler.parameters)JSON.deserialize(secondEvent.Parameters__c, NumberReservationExecutorHandler.parameters.class);
        Assert.areEqual(1, secondParams.assignmentIds.size(), 'The second event should contain 1 assignment Id.');
    }

    /**
     * @description Given an empty list of input variables,
     * when the action is executed, then it throws a ListException.
     */
    @isTest
    static void givenEmptyInput_whenReserveAssignments_thenThrowsException() {
        // Arrange
        List<NumberReservationExecutorAction.InputVariables> inputVariables = new List<NumberReservationExecutorAction.InputVariables>();

        // Act & Assert
        Test.startTest();
        try {
            NumberReservationExecutorAction.reservePhoneNumberAssignments(inputVariables);
            Assert.isTrue(false, 'Expected a ListException to be thrown.');
        } catch (ListException e) {
            Assert.isTrue(e.getMessage().contains('List index out of bounds: 0'), 'The error message should indicate an out-of-bounds error.');
        } catch (Exception e) {
            Assert.isTrue(false, 'Expected a ListException, but got: ' + e.getTypeName());
        }
        Test.stopTest();
    }
}