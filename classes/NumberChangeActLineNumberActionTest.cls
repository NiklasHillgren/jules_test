/**
 * @description Test class for the NumberChangeActLineNumberAction class.
 * It verifies that the action correctly changes the activation line number and updates the related records.
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær         2025-08-19      Initial version.
 *
 * @author Kenneth Houkjær
 * @date 2025-08-19
 */
@isTest
private class NumberChangeActLineNumberActionTest extends NorlysSUnitTest {

    /**
     * @description Tests that the changeNumber method correctly updates the activation line's mobile number
     * and the junction record when given a valid request.
     */
    @isTest
    static void testAction_WithValidRequest_ShouldUpdateRecords() {
        // ARRANGE
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withPhoneNumberAssignments(2)
            .build();

        Account_Phone_Number_Assignment__c fromAssignment = scenario.phoneNumberAssignments[0];
        Account_Phone_Number_Assignment__c toAssignment = scenario.phoneNumberAssignments[1];

        Activation_line__c activationLine = scenario.activationLines[0];
        activationLine.Mobile_No__c = fromAssignment.Phone_Number__c;
        update activationLine;

        Activation_Assignment_Junction__c junction = (Activation_Assignment_Junction__c) NorlysSUnit.newFactory()
            .create('Activation_Assignment_Junction__c')
            .set('Account_Phone_Number_Assignment__c', fromAssignment.Id)
            .set('Activation_line__c', activationLine.Id)
            .insertRecord();

        Mock numberClientMock = Mock.forType(NumberClient.class);
        NumberClientResponseDTO.NumberDetail numberDetail = new NumberClientResponseDTO.NumberDetail();
        numberDetail.data = new NumberClientResponseDTO.NumberData();
        numberDetail.data.id = '45' + fromAssignment.Phone_Number__c;
        numberClientMock.spyOn('unreserveNumberDetailByMsisdn').whenCalledWith(Argument.any()).thenReturn(numberDetail);
        numberClientMock.spyOn('reserveNumberDetailByMsisdnAndCVR').whenCalledWith(Argument.any(), Argument.any(), Argument.any()).thenReturn(numberDetail);
        NumberChangeActLineNumberAction.numberClient = (NumberClient) numberClientMock.stub;

        NumberChangeActLineNumberAction.NumberChangeRequest request = new NumberChangeActLineNumberAction.NumberChangeRequest();
        request.fromAccountPhoneNumberAssignmentId = fromAssignment.Id;
        request.toAccountPhoneNumberAssignmentId = toAssignment.Id;
        request.fromActivationLineId = activationLine.Id;
        request.changeType = 'CHANGE';

        // ACT
        Test.startTest();
        NumberChangeActLineNumberAction.changeNumber(new List<NumberChangeActLineNumberAction.NumberChangeRequest>{ request });
        Test.stopTest();

        // ASSERT
        Activation_line__c updatedActivationLine = [SELECT Mobile_No__c, Phone_Number_Reservation_Status__c, Phone_Number_Reservation_Error__c FROM Activation_line__c WHERE Id = :activationLine.Id];
        Assert.areEqual(toAssignment.Phone_Number__c, updatedActivationLine.Mobile_No__c, 'The mobile number on the activation line should be updated.');
        Assert.areEqual('SUCCESS', updatedActivationLine.Phone_Number_Reservation_Status__c, 'The status should be Success.');
        Assert.areEqual(null, updatedActivationLine.Phone_Number_Reservation_Error__c, 'The error message should be null.');

        Activation_Assignment_Junction__c updatedJunction = [SELECT Account_Phone_Number_Assignment__c FROM Activation_Assignment_Junction__c WHERE Id = :junction.Id];
        Assert.areEqual(toAssignment.Id, updatedJunction.Account_Phone_Number_Assignment__c, 'The junction should be updated to the new assignment.');
    }

    @isTest
    static void testAction_WithSwapRequest_ShouldSwapNumbersAndJunctions() {
        // ARRANGE
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(2)
            .withPhoneNumberAssignments(2)
            .build();

        Account_Phone_Number_Assignment__c fromAssignment = scenario.phoneNumberAssignments[0];
        Account_Phone_Number_Assignment__c toAssignment = scenario.phoneNumberAssignments[1];

        Activation_line__c fromActivationLine = scenario.activationLines[0];
        fromActivationLine.Mobile_No__c = fromAssignment.Phone_Number__c;
        
        Activation_line__c toActivationLine = scenario.activationLines[1];
        toActivationLine.Mobile_No__c = toAssignment.Phone_Number__c;
        update new List<Activation_line__c>{ fromActivationLine, toActivationLine };

        Activation_Assignment_Junction__c fromJunction = (Activation_Assignment_Junction__c) NorlysSUnit.newFactory()
            .create('Activation_Assignment_Junction__c')
            .set('Account_Phone_Number_Assignment__c', fromAssignment.Id)
            .set('Activation_line__c', fromActivationLine.Id)
            .insertRecord();
            
        Activation_Assignment_Junction__c toJunction = (Activation_Assignment_Junction__c) NorlysSUnit.newFactory()
            .create('Activation_Assignment_Junction__c')
            .set('Account_Phone_Number_Assignment__c', toAssignment.Id)
            .set('Activation_line__c', toActivationLine.Id)
            .insertRecord();

        NumberChangeActLineNumberAction.NumberChangeRequest request = new NumberChangeActLineNumberAction.NumberChangeRequest();
        request.fromAccountPhoneNumberAssignmentId = fromAssignment.Id;
        request.toAccountPhoneNumberAssignmentId = toAssignment.Id;
        request.fromActivationLineId = fromActivationLine.Id;
        request.toActivationLineId = toActivationLine.Id;
        request.changeType = 'ISSWAP';

        // ACT
        Test.startTest();
        NumberChangeActLineNumberAction.changeNumber(new List<NumberChangeActLineNumberAction.NumberChangeRequest>{ request });
        Test.stopTest();

        // ASSERT
        Activation_line__c updatedFromActivationLine = [SELECT Mobile_No__c, Phone_Number_Reservation_Status__c, Phone_Number_Reservation_Error__c FROM Activation_line__c WHERE Id = :fromActivationLine.Id];
        Assert.areEqual(toAssignment.Phone_Number__c, updatedFromActivationLine.Mobile_No__c, 'The from activation line should have the to-number.');
        Assert.areEqual('SUCCESS', updatedFromActivationLine.Phone_Number_Reservation_Status__c, 'The status should be Success.');
        Assert.areEqual(null, updatedFromActivationLine.Phone_Number_Reservation_Error__c, 'The error message should be null.');

        Activation_line__c updatedToActivationLine = [SELECT Mobile_No__c, Phone_Number_Reservation_Status__c, Phone_Number_Reservation_Error__c FROM Activation_line__c WHERE Id = :toActivationLine.Id];
        Assert.areEqual(fromAssignment.Phone_Number__c, updatedToActivationLine.Mobile_No__c, 'The to activation line should have the from-number.');
        Assert.areEqual('SUCCESS', updatedToActivationLine.Phone_Number_Reservation_Status__c, 'The status should be Success.');
        Assert.areEqual(null, updatedToActivationLine.Phone_Number_Reservation_Error__c, 'The error message should be null.');

        Activation_Assignment_Junction__c updatedFromJunction = [SELECT Account_Phone_Number_Assignment__c FROM Activation_Assignment_Junction__c WHERE Id = :fromJunction.Id];
        Assert.areEqual(toAssignment.Id, updatedFromJunction.Account_Phone_Number_Assignment__c, 'The from junction should be updated to the to-assignment.');

        Activation_Assignment_Junction__c updatedToJunction = [SELECT Account_Phone_Number_Assignment__c FROM Activation_Assignment_Junction__c WHERE Id = :toJunction.Id];
        Assert.areEqual(fromAssignment.Id, updatedToJunction.Account_Phone_Number_Assignment__c, 'The to junction should be updated to the from-assignment.');
    }

    @isTest
    static void testChangeNumber_ToExistingNumber_ShouldFreeUpOldNumber() {
        // ARRANGE
        NumberChangeActLineNumberAction.numberClient = NorlysTestMocks.forNumberClient()
            .withSuccessOnUnreserve()
            .build();

        Account acc = (Account) NorlysSUnit.newFactory().create('Account').set('Name', 'Test Account').set('CVR__c', '12345678').insertRecord();
        Account_Phone_Number_Series__c fixedSeries = (Account_Phone_Number_Series__c) NorlysSUnit.newFactory()
            .create('Account_Phone_Number_Series__c')
            .set('Number_Group__c', 'P')
            .set('Number_Location__c', 'SAL')
            .set('Account__c', acc.Id)
            .set('Product_Type__c', 'GSM')
            .insertRecord();
        
        List<Account_Phone_Number_Assignment__c> assignments = new List<Account_Phone_Number_Assignment__c>();
        for (Integer i = 0; i < 15; i++) {
            assignments.add((Account_Phone_Number_Assignment__c) NorlysSUnit.newFactory()
                .create('Account_Phone_Number_Assignment__c')
                .set('Account__c', acc.Id)
                .set('Account_Phone_Number_Series__c', fixedSeries.Id)
                .set('Phone_Number__c', String.valueOf(20000000 + i))
                .insertRecord());
        }

        Case testCase = (Case) NorlysSUnit.newFactory()
            .create('Case')
            .set('AccountId', acc.Id)
            .insertRecord();

        Activation__c activation = (Activation__c) NorlysSUnit.newFactory()
            .create('Activation__c')
            .set('Case__c', testCase.Id)
            .insertRecord();

        List<Activation_line__c> activationLines = new List<Activation_line__c>();
        for (Integer i = 0; i < 5; i++) {
            activationLines.add((Activation_line__c) NorlysSUnit.newFactory()
                .create('Activation_line__c')
                .set('Activation__c', activation.Id)
                .set('Mobile_No__c', assignments[i].Phone_Number__c)
                .insertRecord());
        }
        
        List<Activation_Assignment_Junction__c> junctions = new List<Activation_Assignment_Junction__c>();
        for (Integer i = 0; i < 5; i++) {
            junctions.add((Activation_Assignment_Junction__c) NorlysSUnit.newFactory()
                .create('Activation_Assignment_Junction__c')
                .set('Account_Phone_Number_Assignment__c', assignments[i].Id)
                .set('Activation_line__c', activationLines[i].Id)
                .insertRecord());
        }

        Account_Phone_Number_Assignment__c fromAssignment = assignments[1]; // from activation line 2
        Account_Phone_Number_Assignment__c toAssignment = assignments[0];   // to number from activation line 1
        Activation_line__c fromActivationLine = activationLines[1];

        NumberChangeActLineNumberAction.NumberChangeRequest request = new NumberChangeActLineNumberAction.NumberChangeRequest();
        request.fromAccountPhoneNumberAssignmentId = fromAssignment.Id;
        request.toAccountPhoneNumberAssignmentId = toAssignment.Id;
        request.fromActivationLineId = fromActivationLine.Id;
        request.changeType = 'CHANGE';

        // ACT
        Test.startTest();
        NumberChangeActLineNumberAction.changeNumber(new List<NumberChangeActLineNumberAction.NumberChangeRequest>{ request });
        Test.stopTest();

        // ASSERT
        Activation_line__c updatedActivationLine = [SELECT Mobile_No__c FROM Activation_line__c WHERE Id = :fromActivationLine.Id];
        Assert.areEqual(toAssignment.Phone_Number__c, updatedActivationLine.Mobile_No__c, 'The mobile number on the activation line should be updated.');

        // There were 5 used assignments. One was moved to an existing one, so now there are 4.
        List<Account_Phone_Number_Assignment__c> usedAssignments = [
            SELECT Id FROM Account_Phone_Number_Assignment__c WHERE Id IN (SELECT Account_Phone_Number_Assignment__c FROM Activation_Assignment_Junction__c)
        ];
        Assert.areEqual(4, usedAssignments.size(), 'There should be 4 used assignments now.');

        List<Activation_Assignment_Junction__c> fromAssignmentJunctions = [SELECT Id FROM Activation_Assignment_Junction__c WHERE Account_Phone_Number_Assignment__c = :fromAssignment.Id];
        Assert.isTrue(fromAssignmentJunctions.isEmpty(), 'The from-assignment should not be linked to any junction anymore.');

        Activation_line__c activationLine1 = [SELECT Mobile_No__c FROM Activation_line__c WHERE Id = :activationLines[0].Id];
        Assert.areEqual(assignments[0].Phone_Number__c, activationLine1.Mobile_No__c, 'The number on activation line 1 should not have changed.');
    }

    @isTest
    static void testChangeNumber_FromFixedToUnused_ShouldUnreserveAndReserve() {
        // ARRANGE
        NumberChangeActLineNumberAction.numberClient = NorlysTestMocks.forNumberClient()
            .withSuccessOnUnreserve()
            .withSuccessOnReserve()
            .build();

        Account acc = (Account) NorlysSUnit.newFactory().create('Account').set('Name', 'Test Account').set('CVR__c', '12345678').insertRecord();
        Account_Phone_Number_Series__c fixedSeries = (Account_Phone_Number_Series__c) NorlysSUnit.newFactory()
            .create('Account_Phone_Number_Series__c')
            .set('Number_Group__c', 'P')
            .set('Number_Location__c', 'SAL')
            .set('Account__c', acc.Id)
            .set('Product_Type__c', 'GSM')
            .insertRecord();

        List<Account_Phone_Number_Assignment__c> assignments = new List<Account_Phone_Number_Assignment__c>();
        for (Integer i = 0; i < 15; i++) {
            assignments.add((Account_Phone_Number_Assignment__c) NorlysSUnit.newFactory()
                .create('Account_Phone_Number_Assignment__c')
                .set('Account__c', acc.Id)
                .set('Account_Phone_Number_Series__c', fixedSeries.Id)
                .set('Phone_Number__c', String.valueOf(20000000 + i))
                .set('CTN_Number_Status__c', 'AA')
                .insertRecord());
        }

        Case testCase = (Case) NorlysSUnit.newFactory()
            .create('Case')
            .set('AccountId', acc.Id)
            .insertRecord();

        Activation__c activation = (Activation__c) NorlysSUnit.newFactory()
            .create('Activation__c')
            .set('Case__c', testCase.Id)
            .insertRecord();

        List<Activation_line__c> activationLines = new List<Activation_line__c>();
        for (Integer i = 0; i < 5; i++) {
            activationLines.add((Activation_line__c) NorlysSUnit.newFactory()
                .create('Activation_line__c')
                .set('Activation__c', activation.Id)
                .set('Mobile_No__c', assignments[i].Phone_Number__c)
                .insertRecord());
        }
        
        List<Activation_Assignment_Junction__c> junctions = new List<Activation_Assignment_Junction__c>();
        for (Integer i = 0; i < 5; i++) {
            junctions.add((Activation_Assignment_Junction__c) NorlysSUnit.newFactory()
                .create('Activation_Assignment_Junction__c')
                .set('Account_Phone_Number_Assignment__c', assignments[i].Id)
                .set('Activation_line__c', activationLines[i].Id)
                .insertRecord());
        }

        Account_Phone_Number_Assignment__c fromAssignment = assignments[4]; // from activation line 5
        Account_Phone_Number_Assignment__c toAssignment = assignments[5];   // an unused number
        Activation_line__c fromActivationLine = activationLines[4];

        NumberChangeActLineNumberAction.NumberChangeRequest request = new NumberChangeActLineNumberAction.NumberChangeRequest();
        request.fromAccountPhoneNumberAssignmentId = fromAssignment.Id;
        request.toAccountPhoneNumberAssignmentId = toAssignment.Id;
        request.fromActivationLineId = fromActivationLine.Id;
        request.changeType = 'CHANGE';

        // ACT
        Test.startTest();
        NumberChangeActLineNumberAction.changeNumber(new List<NumberChangeActLineNumberAction.NumberChangeRequest>{ request });
        Test.stopTest();

        // ASSERT 
        Activation_line__c updatedActivationLine = [SELECT Mobile_No__c FROM Activation_line__c WHERE Id = :fromActivationLine.Id];
        Assert.areEqual(toAssignment.Phone_Number__c, updatedActivationLine.Mobile_No__c, 'The mobile number on the activation line should be updated.');
    }

    @isTest
    static void testPortingSwap_Success() {
        // ARRANGE
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(2)
            .withPhoneNumberAssignments(2)
            .build();

        Activation_line__c fromActivationLine = scenario.activationLines[0];
        fromActivationLine.Mobile_No__c = '11111111';
        fromActivationLine.Phone_no_Status__c = 'Nummer skal porteres';
        
        Activation_line__c toActivationLine = scenario.activationLines[1];
        toActivationLine.Mobile_No__c = '22222222';
        toActivationLine.Phone_no_Status__c = 'Nummer skal porteres';
        update new List<Activation_line__c>{ fromActivationLine, toActivationLine };
        
        Account_Phone_Number_Assignment__c fromAssignment = scenario.phoneNumberAssignments[0];
        Account_Phone_Number_Assignment__c toAssignment = scenario.phoneNumberAssignments[1];

        NumberChangeActLineNumberAction.NumberChangeRequest request = new NumberChangeActLineNumberAction.NumberChangeRequest();
        request.fromAccountPhoneNumberAssignmentId = fromAssignment.Id;
        request.toAccountPhoneNumberAssignmentId = toAssignment.Id;
        request.fromActivationLineId = fromActivationLine.Id;
        request.toActivationLineId = toActivationLine.Id;
        request.changeType = 'PORTINGSWAP';

        // ACT
        Test.startTest();
        NumberChangeActLineNumberAction.changeNumber(new List<NumberChangeActLineNumberAction.NumberChangeRequest>{ request });
        Test.stopTest();

        // ASSERT
        Activation_line__c updatedFromActivationLine = [SELECT Mobile_No__c FROM Activation_line__c WHERE Id = :fromActivationLine.Id];
        Assert.areEqual('22222222', updatedFromActivationLine.Mobile_No__c, 'The from activation line should have the to-number.');

        Activation_line__c updatedToActivationLine = [SELECT Mobile_No__c FROM Activation_line__c WHERE Id = :toActivationLine.Id];
        Assert.areEqual('11111111', updatedToActivationLine.Mobile_No__c, 'The to activation line should have the from-number.');
    }

    @isTest
    static void testPortingSwap_Failure_IncorrectStatus() {
        // ARRANGE
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(2)
            .build();

        Activation_line__c fromActivationLine = scenario.activationLines[0];
        fromActivationLine.Mobile_No__c = '11111111';
        fromActivationLine.Phone_no_Status__c = 'Nyt nummer';
        
        Activation_line__c toActivationLine = scenario.activationLines[1];
        toActivationLine.Mobile_No__c = '22222222';
        toActivationLine.Phone_no_Status__c = 'Nummer skal porteres';
        update new List<Activation_line__c>{ fromActivationLine, toActivationLine };

        NumberChangeActLineNumberAction.NumberChangeRequest request = new NumberChangeActLineNumberAction.NumberChangeRequest();
        request.fromActivationLineId = fromActivationLine.Id;
        request.toActivationLineId = toActivationLine.Id;
        request.changeType = 'PORTINGSWAP';

        // ACT
        Test.startTest();
        NumberChangeActLineNumberAction.changeNumber(new List<NumberChangeActLineNumberAction.NumberChangeRequest>{ request });
        Test.stopTest();

        // ASSERT
        Activation_line__c updatedFromActivationLine = [SELECT Mobile_No__c FROM Activation_line__c WHERE Id = :fromActivationLine.Id];
        Assert.areEqual('11111111', updatedFromActivationLine.Mobile_No__c, 'The from activation line should not have changed.');

        Activation_line__c updatedToActivationLine = [SELECT Mobile_No__c FROM Activation_line__c WHERE Id = :toActivationLine.Id];
        Assert.areEqual('22222222', updatedToActivationLine.Mobile_No__c, 'The to activation line should not have changed.');
    }

    @isTest
    static void testChangeNumber_NoAssignmentNumber_ShouldUpdateMobileNoAndCreateJunction() {
        // ARRANGE
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivationLines(1)
            .withPhoneNumberAssignments(1)
            .build();

        Account_Phone_Number_Assignment__c toAssignment = scenario.phoneNumberAssignments[0];
        Activation_line__c activationLine = scenario.activationLines[0];

        NumberChangeActLineNumberAction.NumberChangeRequest request = new NumberChangeActLineNumberAction.NumberChangeRequest();
        request.toAccountPhoneNumberAssignmentId = toAssignment.Id;
        request.fromActivationLineId = activationLine.Id;
        request.changeType = 'NOASSIGNMENTNUMBER';

        // ACT
        Test.startTest();
        NumberChangeActLineNumberAction.changeNumber(new List<NumberChangeActLineNumberAction.NumberChangeRequest>{ request });
        Test.stopTest();

        // ASSERT
        Activation_line__c updatedActivationLine = [SELECT Mobile_No__c FROM Activation_line__c WHERE Id = :activationLine.Id];
        Assert.areEqual(NumberChangeActLineNumberAction.stripCountryCodeFromPhoneNumber(toAssignment.Phone_Number__c), updatedActivationLine.Mobile_No__c, 'The mobile number on the activation line should be updated.');

        List<Activation_Assignment_Junction__c> createdJunctions = [
            SELECT Account_Phone_Number_Assignment__c, Activation_line__c
            FROM Activation_Assignment_Junction__c
            WHERE Activation_line__c = :activationLine.Id
        ];
        Assert.areEqual(1, createdJunctions.size(), 'A new junction should have been created.');
        Assert.areEqual(toAssignment.Id, createdJunctions[0].Account_Phone_Number_Assignment__c, 'The junction should link to the correct assignment.');
    }
}