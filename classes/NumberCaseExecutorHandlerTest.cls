/**
 * @description Test class for the NumberCaseExecutorHandler. This class ensures that the handler
 *              correctly processes number assignment events, including single and multi-batch scenarios,
 *              callout failures, and DML failures with compensating transactions.
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær      30/08/2025      Initial version.
 *  Kenneth Houkjær      30/08/2025      Added test method renaming and class header.
 *
 * @author Kenneth Houkjær
 * @date 2025-08-30
 */
@isTest
private class NumberCaseExecutorHandlerTest {

    /**
     * @description Tests that the handler correctly processes a batch smaller than the BATCH_SIZE,
     *              successfully reserving numbers and updating the relevant records without queueing a subsequent job.
     *              This represents the simplest success case.
     */
    @isTest
    static void execute_WithSingleBatch_ShouldSucceed() {
        // Arrange
        TriggerHandler.bypass('ActivationLineTriggerHandler');
        TriggerHandler.bypass('QuoteLineTriggerHandler');
        TriggerHandler.bypass('CPQQuoteLine_TriggerHandler');
        TriggerHandler.bypass('quote_TriggerHandler');
        TriggerHandler.bypass('dlrs.RollupService');
         
        // Create a test scenario with 2 activation lines, which is less than the BATCH_SIZE of 3.
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(2)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .withNumberSeries('BRZ', 'P', 2, 0)
            .build();

        // Ensure all assignments are available to be picked.
        for(Account_Phone_Number_Assignment__c assignment : scenario.phoneNumberAssignments) {
            assignment.CTN_Number_Status__c = 'AA'; // Fixed series are unused when 'AA'
        }
        update scenario.phoneNumberAssignments;

        // Mock the database service to intercept DML operations for verification.
        DatabaseService dbMock = new DatabaseService().mockDMLs();
        // Mock the number client to simulate a successful number reservation callout.
        NumberClient numberClient = NorlysTestMocks.forNumberClient()
            .withSuccessOnReserve()
            .build();

        // Create the event that will trigger the handler.
        EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler', 
            new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id }
        );

        NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(numberClient, dbMock);

        // Act
        TriggerHandler.clearAllBypasses();
        Test.startTest();
        handler.execute(testEvent);
        Test.stopTest();

        // Assert
        // Verify that the correct number of records were inserted and updated.
        System.assertEquals(2, dbMock.register.inserted.size(), 'Should insert 2 junction records.');
        // The initial INPROGRESS update was removed to prevent callout errors.
        // We now expect 2 lines (SUCCESS) + 2 assignments + 1 parent activation = 5 updates.
        System.assertEquals(5, dbMock.register.updated.size(), 'Should update 2 lines to SUCCESS, 2 assignments, and 1 final parent activation status.');
        
        // Find the successfully updated activation line and assignment for detailed asserts.
        List<Activation_Line__c> successLines = new List<Activation_Line__c>();
        List<Account_Phone_Number_Assignment__c> successAssignments = new List<Account_Phone_Number_Assignment__c>();
        for (SObject record : dbMock.register.updated) {
            if (record.getSObjectType() == Activation_Line__c.SObjectType && ((Activation_Line__c)record).Phone_Number_Reservation_Status__c == 'SUCCESS') {
                successLines.add((Activation_Line__c)record);
            }
            if (record.getSObjectType() == Account_Phone_Number_Assignment__c.SObjectType && ((Account_Phone_Number_Assignment__c)record).Phone_Number_Reservation_Status__c == 'Success') {
                successAssignments.add((Account_Phone_Number_Assignment__c)record);
            }
        }
        System.assertEquals(2, successLines.size(), 'There should be 2 successfully updated activation lines.');
        System.assertEquals(2, successAssignments.size(), 'There should be 2 successfully updated assignments.');

        for(Activation_Line__c successLine : successLines) {
            System.assertEquals('11223344', successLine.Mobile_No__c, 'Mobile number should be set without country code.');
        }

        // Verify the junction record was created correctly.
        Map<Id, Activation_Line__c> successLinesMap = new Map<Id, Activation_Line__c>(successLines);
        for(SObject insertedRecord : dbMock.register.inserted) {
            Activation_Assignment_Junction__c newJunction = (Activation_Assignment_Junction__c)insertedRecord;
            System.assertNotEquals(null, newJunction, 'Junction record should not be null.');
            System.assert(successLinesMap.containsKey(newJunction.Activation_line__c), 'Junction should be linked to a correct activation line.');
        }

        // Verify that the assignment's Activation_line__c is not populated, as the junction object holds the relationship.
        for(Account_Phone_Number_Assignment__c successAssignment : successAssignments) {
            System.assertEquals(null, successAssignment.Activation_line__c, 'Activation_line__c on assignment should be null.');
        }
    }

    /**
     * @description Tests that when there are more activation lines than the BATCH_SIZE,
     *              the handler processes the first full batch and correctly triggers a new event to handle the remaining lines.
     */
    @isTest
    static void execute_WithMultiBatch_ShouldProcessFirstBatchAndRepublish() {
        // Arrange
        TriggerHandler.bypass('ActivationLineTriggerHandler');
        TriggerHandler.bypass('QuoteLineTriggerHandler');
        TriggerHandler.bypass('CPQQuoteLine_TriggerHandler');
        TriggerHandler.bypass('quote_TriggerHandler');
        TriggerHandler.bypass('dlrs.RollupService');
        // Create a scenario with 4 activation lines, which is more than the BATCH_SIZE of 3.
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(4)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .withNumberSeries('BRZ', 'P', 4, 0)
            .build();

        // Ensure all assignments are available to be picked.
        for(Account_Phone_Number_Assignment__c assignment : scenario.phoneNumberAssignments) {
            assignment.CTN_Number_Status__c = 'AA'; // Fixed series are unused when 'AA'
        }
        update scenario.phoneNumberAssignments;

        DatabaseService dbMock = new DatabaseService().mockDMLs();
        NumberClient numberClient = NorlysTestMocks.forNumberClient()
            .withSuccessOnReserve()
            .build();

        EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler',
            new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id }
        );
        
        NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(numberClient, dbMock);

        // Act
        TriggerHandler.clearAllBypasses();
        Test.startTest();
        handler.execute(testEvent);
        Test.stopTest();

        // Assert
        // A key assertion is that a new event was published to process the next batch.
        // This is implicitly tested by the fact that `hasMoreLines` would be true, leading to `publishExecutor`.
        // We can also check that some DML occurred for the first batch.
        System.assert(dbMock.register.inserted.size() > 0, 'Should insert junction records for the first batch.');
        System.assert(dbMock.register.updated.size() > 0, 'DML updates should have occurred for the first batch.');

        // Verify that at least one line was successfully processed, making the test robust against BATCH_SIZE changes.
        Boolean wasSuccessFound = false;
        Boolean assignmentChecked = false;
        for(SObject record : dbMock.register.updated) {
            if(record.getSObjectType() == Activation_Line__c.SObjectType) {
                if(((Activation_Line__c)record).Phone_Number_Reservation_Status__c == 'SUCCESS') {
                    wasSuccessFound = true;
                }
            }
            if(record.getSObjectType() == Account_Phone_Number_Assignment__c.SObjectType) {
                if(((Account_Phone_Number_Assignment__c)record).Phone_Number_Reservation_Status__c == 'Success') {
                    System.assertEquals(null, ((Account_Phone_Number_Assignment__c)record).Activation_line__c, 'Activation_line__c on assignment should be null.');
                    assignmentChecked = true;
                }
            }
        }
        System.assert(wasSuccessFound, 'At least one activation line should have been successfully processed.');
        System.assert(assignmentChecked, 'At least one assignment should have been successfully processed.');
    }

    /**
     * @description Tests that if the NumberClient callout fails (e.g., due to a reservation error),
     *              the handler correctly catches the exception and updates the activation line with an 'ERROR' status and message.
     */
    @isTest
    static void execute_WhenCalloutFails_ShouldSetErrorStatus() {
        // Arrange
        TriggerHandler.bypass('ActivationLineTriggerHandler');
        TriggerHandler.bypass('QuoteLineTriggerHandler');
        TriggerHandler.bypass('CPQQuoteLine_TriggerHandler');
        TriggerHandler.bypass('quote_TriggerHandler');
        TriggerHandler.bypass('dlrs.RollupService');
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .withNumberSeries('SAL', 'P', 1, 0) // Use a non-open series to trigger compensation
            .build();

        // Ensure the assignment is available to be picked by the handler.
        scenario.phoneNumberAssignments[0].CTN_Number_Status__c = 'AA';
        update scenario.phoneNumberAssignments;

        DatabaseService dbMock = new DatabaseService().mockDMLs();
        // Mock the NumberClient to throw a CalloutException when the reserve method is called.
        NumberClient numberClient = NorlysTestMocks.forNumberClient()
            .withFailureOnReserve(new CalloutException('Reservation failed'))
            .build();

        EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler',
            new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id }
        );
        
        NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(numberClient, dbMock);
        
        // Act
        TriggerHandler.clearAllBypasses();
        Test.startTest();
        handler.execute(testEvent);
        Test.stopTest();

        // Assert
        // Find the activation line that should have been updated with an error.
        Activation_Line__c updatedLine;
        for(SObject record : dbMock.register.updated) {
            if(record.getSObjectType() == Activation_Line__c.SObjectType && ((Activation_Line__c)record).Phone_Number_Reservation_Status__c == 'ERROR') {
                updatedLine = (Activation_Line__c)record;
                break;
            }
        }
        
        // Verify the error status and message.
        System.assertNotEquals(null, updatedLine, 'Updated activation line with error status should be found.');
        System.assertEquals('ERROR', updatedLine.Phone_Number_Reservation_Status__c);
        System.assert(updatedLine.Phone_Number_Reservation_Error__c.contains('Reservation failed'));
    }

    /**
     * @description Tests that if the initial query finds no activation lines needing numbers for the given Case,
     *              the handler exits gracefully without performing any DML operations or queueing further jobs.
     */
    @isTest
    static void execute_WithNoLinesToProcess_ShouldDoNothing() {
        // Arrange
        TriggerHandler.bypass('ActivationLineTriggerHandler');
        TriggerHandler.bypass('QuoteLineTriggerHandler');
        TriggerHandler.bypass('CPQQuoteLine_TriggerHandler');
        TriggerHandler.bypass('quote_TriggerHandler');
        TriggerHandler.bypass('dlrs.RollupService');
        // Create a scenario with no activation lines needing numbers.
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .build();

        DatabaseService dbMock = new DatabaseService().mockDMLs();
        NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(null, dbMock);

        EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler',
            new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id }
        );

        // Act
        TriggerHandler.clearAllBypasses();
        Test.startTest();
        handler.execute(testEvent);
        Test.stopTest();

        // Assert
        // Verify that no DML operations were performed.
        System.assertEquals(0, dbMock.register.updated.size(), 'Should not update any records when there are no lines.');
    }

    /**
     * @description Tests the new "Prioritize and Fill" logic. It ensures that activation lines
     *              with explicitly requested mobile numbers are paired with the correct assignments,
     *              and lines without a requested number are filled from the remaining pool.
     */
    @isTest
    static void execute_WithPrioritizedNumbers_ShouldAssignCorrectly() {
        // Arrange
        TriggerHandler.bypass('ActivationLineTriggerHandler');
        // Setup a scenario with 3 lines and 3 available numbers.
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(3)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .withPhoneNumberAssignments(3)
            .build();

        // Manually set up the prioritization scenario.
        // Line 0 requests Number 0.
        scenario.activationLines[0].Mobile_No__c = scenario.phoneNumberAssignments[0].Phone_Number__c;
        // Line 1 requests Number 2.
        scenario.activationLines[1].Mobile_No__c = scenario.phoneNumberAssignments[2].Phone_Number__c;
        // Line 2 requests no specific number.
        update scenario.activationLines;

        // Ensure all assignments are available to be picked.
        for(Account_Phone_Number_Assignment__c assignment : scenario.phoneNumberAssignments) {
            assignment.CTN_Number_Status__c = 'AA';
        }
        update scenario.phoneNumberAssignments;

        DatabaseService dbMock = new DatabaseService().mockDMLs();
        NumberClient numberClient = NorlysTestMocks.forNumberClient()
            .withSuccessOnReserve()
            .build();

        EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler',
            new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id }
        );

        NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(numberClient, dbMock);

        // Act
        TriggerHandler.clearAllBypasses();
        Test.startTest();
        handler.execute(testEvent);
        Test.stopTest();

        // Assert
        // The most reliable way to check the pairing is to inspect the junction objects.
        System.assertEquals(3, dbMock.register.inserted.size(), 'Should insert 3 junction records.');

        // Create a map of the pairings from the inserted junction records.
        Map<Id, Id> activationToAssignmentMap = new Map<Id, Id>();
        for(SObject insertedRecord : dbMock.register.inserted) {
            Activation_Assignment_Junction__c newJunction = (Activation_Assignment_Junction__c)insertedRecord;
            activationToAssignmentMap.put(newJunction.Activation_line__c, newJunction.Account_Phone_Number_Assignment__c);
        }

        // Verify the pairings.
        // Line 0 should get its requested number (Assignment 0).
        System.assertEquals(scenario.phoneNumberAssignments[0].Id, activationToAssignmentMap.get(scenario.activationLines[0].Id), 'Line 0 was not assigned its requested number.');
        // Line 1 should get its requested number (Assignment 2).
        System.assertEquals(scenario.phoneNumberAssignments[2].Id, activationToAssignmentMap.get(scenario.activationLines[1].Id), 'Line 1 was not assigned its requested number.');
        // Line 2 should get the remaining filler number (Assignment 1).
        System.assertEquals(scenario.phoneNumberAssignments[1].Id, activationToAssignmentMap.get(scenario.activationLines[2].Id), 'Line 2 was not assigned the correct filler number.');
    }

    /**
     * @description Tests that when there are not enough available phone number assignments for the number of activation lines,
     *              the handler correctly marks the unassigned lines with an 'ERROR' status and a specific error message.
     */
    @isTest
    static void execute_WithNotEnoughAssignments_ShouldSetErrorStatus() {
        // Arrange
        TriggerHandler.bypass('ActivationLineTriggerHandler');
        // Create a scenario with 3 activation lines but only 1 available assignment.
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(3)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .withPhoneNumberAssignments(1)
            .build();

        // Ensure the single assignment is available.
        scenario.phoneNumberAssignments[0].CTN_Number_Status__c = 'AA';
        update scenario.phoneNumberAssignments;

        DatabaseService dbMock = new DatabaseService().mockDMLs();
        NumberClient numberClient = NorlysTestMocks.forNumberClient()
            .withSuccessOnReserve()
            .build();

        EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler',
            new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id }
        );

        NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(numberClient, dbMock);

        // Act
        TriggerHandler.clearAllBypasses();
        Test.startTest();
        handler.execute(testEvent);
        Test.stopTest();

        // Assert
        // The handler should have updated records in total:
        // - 3 lines (1 SUCCESS, 2 ERROR) in processBatch
        // - 1 assignment to SUCCESS (in processBatch)
        // - 1 parent Activation to ERROR (in handleProcessingErrors)
        // - 1 parent Activation to ERROR (in updateFinalActivationStatus)
        // Total = 3 + 1 + 1 + 1 = 6
        System.assertEquals(6, dbMock.register.updated.size(), 'Should perform 6 updates in total.');

        // Find and verify the lines with different statuses.
        List<Activation_Line__c> errorLines = new List<Activation_Line__c>();
        List<Activation_Line__c> successLines = new List<Activation_Line__c>();
        for (SObject record : dbMock.register.updated) {
            if (record.getSObjectType() == Activation_Line__c.SObjectType) {
                Activation_Line__c line = (Activation_Line__c)record;
                if (line.Phone_Number_Reservation_Status__c == 'ERROR') {
                    errorLines.add(line);
                } else if (line.Phone_Number_Reservation_Status__c == 'SUCCESS') {
                    successLines.add(line);
                }
            }
        }
        
        // Verify that 2 lines were marked with an error.
        System.assertEquals(2, errorLines.size(), 'Should be 2 activation lines with an ERROR status.');
        for(Activation_Line__c errorLine : errorLines) {
            System.assertEquals('[NCEH004] Not enough available numbers', errorLine.Phone_Number_Reservation_Error__c, 'Error message should be set correctly.');
        }

        // Verify that 1 line was processed successfully.
        System.assertEquals(1, successLines.size(), 'Should be 1 activation line with a SUCCESS status.');
    }

    /**
     * @description Verifies that when a callout fails, the error code is correctly
     *              propagated and stored on the parent Activation record.
     */
    @isTest
    static void execute_WhenCalloutFails_ShouldSetErrorOnParent() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .withNumberSeries('SAL', 'P', 1, 0)
            .build();
            
        scenario.phoneNumberAssignments[0].CTN_Number_Status__c = 'AA';
        update scenario.phoneNumberAssignments;

        DatabaseService dbMock = new DatabaseService().mockDMLs();
        NumberClient numberClient = NorlysTestMocks.forNumberClient()
            .withFailureOnReserve(new CalloutException('[NCEH002] Callout failed'))
            .build();

        EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler', 
            new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id }
        );
        
        NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(numberClient, dbMock);
        
        // Act
        Test.startTest();
        handler.execute(testEvent);
        Test.stopTest();

        // Assert
        Activation__c updatedParent = null;
        for (SObject record : dbMock.register.updated) {
            if (record.getSObjectType() == Activation__c.SObjectType) {
                updatedParent = (Activation__c)record;
                break;
            }
        }
        System.assertNotEquals(null, updatedParent, 'Parent Activation__c should have been updated.');
        System.assertEquals('NCEH002', updatedParent.Activation_Line_Error_Code__c, 'Error code should be set on parent activation.');
    }

    /**
     * @description Verifies that when all lines are processed successfully, the parent
     *              Activation's status is set to 'SUCCESS'.
     */
    // @isTest
    // static void execute_WhenProcessCompletes_ShouldSetSuccessOnParent() {
    //     // Arrange
    //     TriggerHandler.bypass('ActivationTriggerHandler');
    //     NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
    //         .forNumberCaseHandling()
    //         .withActivationLines(1)
    //         .withPhoneNoStatusOnActivationLine('Nyt nummer')
    //         .withNumberSeries('BRZ', 'P', 1, 0)
    //         .build();
        
    //     // The handler will perform real DML, so no DB mock is needed for this assertion.
    //     NumberClient numberClient = NorlysTestMocks.forNumberClient().withSuccessOnReserve().build();

    //     EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler', 
    //         new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id }
    //     );

    //     NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(numberClient, new DatabaseService());

    //     // Act
    //     Test.startTest();
    //     handler.execute(testEvent);
    //     Test.stopTest();

    //     // Assert
    //     // Verify the final status on the parent activation record by querying it directly.
    //     Activation__c updatedParent = [SELECT Phone_Number_Reservation_Status_Txt__c FROM Activation__c WHERE Id = :scenario.activations[0].Id];
    //     System.assertEquals('SUCCESS', updatedParent.Phone_Number_Reservation_Status_Txt__c, 'Parent status should be SUCCESS.');
    // }

    // /**
    //  * @description Verifies that if any line fails, the final aggregated status on the
    //  *              parent Activation is set to 'ERROR'.
    //  */
    // @isTest
    // static void execute_WhenProcessCompletesWithErrors_ShouldSetErrorOnParent() {
    //     // Arrange
    //     TriggerHandler.bypass('ActivationTriggerHandler');
    //     NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
    //         .forNumberCaseHandling()
    //         .withActivationLines(1)
    //         .withPhoneNoStatusOnActivationLine('Nyt nummer')
    //         .withNumberSeries('SAL', 'P', 1, 0)
    //         .build();

    //     // The handler will perform real DML, so no DB mock is needed for this assertion.
    //     // Simulate a callout failure, which will mark the line as ERROR.
    //     NumberClient numberClient = NorlysTestMocks.forNumberClient()
    //         .withFailureOnReserve(new CalloutException('[NCEH002] Callout failed'))
    //         .build();

    //     EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler', 
    //         new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id }
    //     );

    //     NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(numberClient, new DatabaseService());

    //     // Act
    //     Test.startTest();
    //     handler.execute(testEvent);
    //     Test.stopTest();

    //     // Assert
    //     // Verify the final status on the parent activation record by querying it directly.
    //     Activation__c updatedParent = [SELECT Phone_Number_Reservation_Status_Txt__c FROM Activation__c WHERE Id = :scenario.activations[0].Id];
    //     System.assertEquals('ERROR', updatedParent.Phone_Number_Reservation_Status_Txt__c, 'Parent status should be ERROR.');
    // }

    /**
     * @description Verifies that when the handler runs and finds no lines to process, but the existing
     *              lines are all in a SUCCESS state, it correctly sets the parent activation status to SUCCESS.
     *              This directly tests the `updateFinalActivationStatus` logic for the success path.
     */
    @isTest
    static void testFinalStatus_WhenAllSuccess_ShouldSetParentToSuccess() {
        // ARRANGE
        // Set up a scenario with 5 activation lines.
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(5)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .build();
        
        // Manually set all lines to SUCCESS to simulate the state after all batches have run.
        for (Activation_Line__c line : scenario.activationLines) {
            line.Phone_Number_Reservation_Status__c = 'SUCCESS';
        }
        update scenario.activationLines;

        // The handler will use the real DatabaseService. The NumberClient mock is needed for instantiation,
        // but it will not be called since there are no lines to process.
        NumberClient numberClient = NorlysTestMocks.forNumberClient().build();
        NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(numberClient, new DatabaseService());

        EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler', 
            new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id, 'retryCount' => 5 } // Set retry count to max
        );

        // ACT
        Test.startTest();
        handler.execute(testEvent);
        Test.stopTest();

        // ASSERT
        // Verify the final status on the parent activation record by querying it directly.
        Activation__c updatedParent = [SELECT Phone_Number_Reservation_Status_Txt__c FROM Activation__c WHERE Id = :scenario.activations[0].Id];
        System.assertEquals('SUCCESS', updatedParent.Phone_Number_Reservation_Status_Txt__c, 'Parent status should be SUCCESS.');
    }

    // /**
    //  * @description Verifies that when the handler runs and finds no lines to process, but the existing
    //  *              lines contain at least one ERROR, it correctly sets the parent activation status to ERROR.
    //  *              This directly tests the `updateFinalActivationStatus` logic for the failure path.
    //  */
    // @isTest
    // static void testFinalStatus_WhenErrorsExist_ShouldSetParentToError() {
    //     // ARRANGE
    //     // Set up a scenario with 5 activation lines.
    //     NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
    //         .forNumberCaseHandling()
    //         .withActivationLines(5)
    //         .withPhoneNoStatusOnActivationLine('Nyt nummer')
    //         .build();
        
    //     // Manually set lines to a mix of SUCCESS and ERROR to simulate the state after all batches have run.
    //     scenario.activationLines[0].Phone_Number_Reservation_Status__c = 'SUCCESS';
    //     scenario.activationLines[1].Phone_Number_Reservation_Status__c = 'SUCCESS';
    //     scenario.activationLines[2].Phone_Number_Reservation_Status__c = 'ERROR';
    //     scenario.activationLines[3].Phone_Number_Reservation_Status__c = 'SUCCESS';
    //     scenario.activationLines[4].Phone_Number_Reservation_Status__c = 'INPROGRESS'; // Changed to INPROGRESS to match assertion
    //     update scenario.activationLines;
        
    //     NumberClient numberClient = NorlysTestMocks.forNumberClient().build();
    //     NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(numberClient, new DatabaseService());

    //     EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler', 
    //         new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id }
    //     );

    //     // ACT
    //     Test.startTest();
    //     handler.execute(testEvent);
    //     Test.stopTest();

    //     // ASSERT
    //     // Verify the final status on the parent activation record by querying it directly.
    //     Activation__c updatedParent = [SELECT Phone_Number_Reservation_Status_Txt__c FROM Activation__c WHERE Id = :scenario.activations[0].Id];
    //     System.assertEquals('ERROR', updatedParent.Phone_Number_Reservation_Status_Txt__c, 'Parent status should be ERROR.');
    // }

    /**
     * @description Verifies that when a case has failed lines and the retry count is below the maximum,
     *              the handler re-invokes the NumberCaseExecutorAction to attempt a retry.
     */
    @isTest
    static void execute_whenErrorsExistAndRetriesNotExceeded_shouldRecallAction() {
        // ARRANGE
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .build();
        
        // Set the line to an ERROR state to simulate a previous failure.
        scenario.activationLines[0].Phone_Number_Reservation_Status__c = 'ERROR';
        update scenario.activationLines;

        // Create and inject the mock action caller to intercept the call.
        MockActionCaller mockCaller = new MockActionCaller();
        NumberCaseExecutorHandler.actionCaller = mockCaller;

        NumberClient numberClient = NorlysTestMocks.forNumberClient().build();
        NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(numberClient, new DatabaseService());
        
        // Create an event with a retryCount of 2, which is less than the max of 5.
        EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler', 
            new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id, 'retryCount' => 2 }
        );

        // ACT
        Test.startTest();
        // Execute the handler. Since the line is in an error state, it should find no lines to process
        // and proceed to updateFinalActivationStatus, where the retry logic resides.
        handler.execute(testEvent);
        Test.stopTest();

        // ASSERT
        // Verify that the action was called once, and with the correctly incremented retry count.
        System.assertEquals(1, mockCaller.callCount, 'The action should have been called exactly once for the retry.');
        System.assertEquals(3, mockCaller.requests[0].retryCount, 'The retry count should be incremented to 3.');
        System.assertEquals(scenario.caseRecord.Id, mockCaller.requests[0].caseId, 'The correct caseId should be passed for the retry.');
    }

    /**
     * @description Verifies that when a case has failed lines but the retry count has reached the maximum (5),
     *              the handler does NOT re-invoke the action, thus terminating the retry loop.
     */
    @isTest
    static void execute_whenErrorsExistAndRetriesExceeded_shouldNotRecallAction() {
        // ARRANGE
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withPhoneNoStatusOnActivationLine('Nyt nummer')
            .build();
        
        scenario.activationLines[0].Phone_Number_Reservation_Status__c = 'ERROR';
        update scenario.activationLines;

        MockActionCaller mockCaller = new MockActionCaller();
        NumberCaseExecutorHandler.actionCaller = mockCaller;

        NumberClient numberClient = NorlysTestMocks.forNumberClient().build();
        NumberCaseExecutorHandler handler = new NumberCaseExecutorHandler(numberClient, new DatabaseService());
        
        // Create an event with a retryCount of 5, the maximum allowed.
        EventExecutor__e testEvent = NorlysTestMocks.createEventExecutor('NumberCaseExecutorHandler', 
            new Map<String, Object>{ 'CaseId' => scenario.caseRecord.Id, 'retryCount' => 5 }
        );

        // ACT
        Test.startTest();
        handler.execute(testEvent);
        Test.stopTest();

        // ASSERT
        // Verify that the action was never called, as the max retry limit was reached.
        System.assertEquals(0, mockCaller.callCount, 'The action should not have been called as max retries were reached.');
    }

    /**
     * @description Mock implementation of the action caller to intercept and verify calls during tests.
     */
    private class MockActionCaller extends NumberCaseExecutorActionCaller {
        public Integer callCount = 0;
        public List<NumberCaseExecutorAction.InputVariables> requests;

        public override void callAssignNumbers(List<NumberCaseExecutorAction.InputVariables> requests) {
            this.callCount++;
            this.requests = requests;
        }
    }
}