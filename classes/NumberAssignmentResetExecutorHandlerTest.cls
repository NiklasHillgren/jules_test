/**
 * @description Test class for the NumberAssignmentResetExecutorHandler.
 * It verifies that the handler correctly resets assignments based on the number of junctions and series type.
 * @group SUnit
 */
@isTest
private class NumberAssignmentResetExecutorHandlerTest {

    /**
     * @description Given a non-openseries number with a single junction,
     * when the handler is executed, then the number is unreserved and the junction is deleted.
     */
    @isTest
    static void givenSingleJunctionNonOpenSeries_whenExecute_thenUnreservesAndDeletesJunction() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withNumberSeries('SAL', 'P', 1, 1)
            .withPhoneNumberStatus('AR')
            .build();

        NumberClient numberClient = NorlysTestMocks.forNumberClient()
            .withSuccessOnUnreserve()
            .build();
        
        DatabaseService dbMock = new DatabaseService().mockDMLs();
        NumberAssignmentResetExecutorHandler handler = new NumberAssignmentResetExecutorHandler(numberClient, dbMock);

        EventExecutor__e event = NorlysTestMocks.createEventExecutor('NumberAssignmentResetExecutorHandler', 
            new Map<String, Object>{
                'activationLineIdToNumber' => new Map<Id, String>{
                    scenario.activationLines[0].Id => scenario.activationLines[0].Mobile_No__c
                }
            }
        );

        // Act
        Test.startTest();
        handler.execute(event);
        Test.stopTest();

        // Assert
        System.assertEquals(1, dbMock.register.updated.size(), 'Should update one assignment');
        System.assertEquals(1, dbMock.register.deleted.size(), 'Should delete one junction');
        Account_Phone_Number_Assignment__c updatedAssignment = (Account_Phone_Number_Assignment__c) dbMock.register.updated.get(0);
        System.assertEquals('AA', updatedAssignment.CTN_Number_Status__c, 'Assignment status should be unreserved');
    }

    /**
     * @description Given an openseries number with a single junction,
     * when the handler is executed, then only the junction is deleted and the number is not unreserved.
     */
    @isTest
    static void givenSingleJunctionOpenSeries_whenExecute_thenDeletesJunctionOnly() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withNumberSeries('EKC', 'P', 1, 1)
            .withPhoneNumberStatus('AR')
            .build();

        NumberClient numberClient = NorlysTestMocks.forNumberClient().build();
        DatabaseService dbMock = new DatabaseService().mockDMLs();
        NumberAssignmentResetExecutorHandler handler = new NumberAssignmentResetExecutorHandler(numberClient, dbMock);

        EventExecutor__e event = NorlysTestMocks.createEventExecutor('NumberAssignmentResetExecutorHandler', 
            new Map<String, Object>{
                'activationLineIdToNumber' => new Map<Id, String>{
                    scenario.activationLines[0].Id => scenario.activationLines[0].Mobile_No__c
                }
            }
        );

        // Act
        Test.startTest();
        handler.execute(event);
        Test.stopTest();

        // Assert
        System.assertEquals(1, dbMock.register.updated.size(), 'Should update one assignment');
        System.assertEquals(1, dbMock.register.deleted.size(), 'Should delete one junction');
        Account_Phone_Number_Assignment__c updatedAssignment = (Account_Phone_Number_Assignment__c) dbMock.register.updated.get(0);
        System.assertEquals('AR', updatedAssignment.CTN_Number_Status__c, 'Assignment status should be unchanged');
    }

    /**
     * @description Given an assignment with multiple junctions,
     * when the handler is executed for one activation line, then only the corresponding junction is deleted.
     */
    @isTest
    static void givenMultipleJunctions_whenExecute_thenDeletesJunctionOnly() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withNumberSeries('SAL', 'P', 1, 1)
            .withPhoneNumberStatus('AR')
            .build();
        
        // Manually create a second activation line and junction to the same assignment
        Activation_Line__c secondActivationLine = (Activation_Line__c) NorlysSUnit.newFactory()
            .create('Activation_Line__c')
            .set('Case__c', scenario.caseRecord.Id)
            .set('Activation__c', scenario.activations[0].Id)
            .insertRecord();

        insert new Activation_Assignment_Junction__c(
            Activation_line__c = secondActivationLine.Id,
            Account_Phone_Number_Assignment__c = scenario.phoneNumberAssignments[0].Id
        );

        NumberClient numberClient = NorlysTestMocks.forNumberClient().build();
        DatabaseService dbMock = new DatabaseService().mockDMLs();
        NumberAssignmentResetExecutorHandler handler = new NumberAssignmentResetExecutorHandler(numberClient, dbMock);

        EventExecutor__e event = NorlysTestMocks.createEventExecutor('NumberAssignmentResetExecutorHandler', 
            new Map<String, Object>{
                'activationLineIdToNumber' => new Map<Id, String>{
                    scenario.activationLines[0].Id => scenario.activationLines[0].Mobile_No__c
                }
            }
        );

        // Act
        Test.startTest();
        handler.execute(event);
        Test.stopTest();

        // Assert
        System.assertEquals(0, dbMock.register.updated.size(), 'Should not update any assignment');
        System.assertEquals(1, dbMock.register.deleted.size(), 'Should delete one junction');
    }
}