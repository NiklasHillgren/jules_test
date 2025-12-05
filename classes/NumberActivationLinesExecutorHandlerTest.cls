/**
 * The NumberActivationLinesExecutorHandlerTest class is responsible for testing the NumberActivationLinesExecutorHandler class.
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær         28/07/2025      Initial version
 *
 * @author Kenneth Houkjær
 * @date 27/07/2025
 */
@isTest
public class NumberActivationLinesExecutorHandlerTest {
  
    // /**
    //  * @description Tests that the execute method sets the status to success and
    //  * that the activationLine gets a phonenumber and that the assignment gets a relation to the activationline.
    //  * For and Open Series Assignment
    //  * 
    //  */
    // @IsTest
    // public static void execute_openSeriesNumber_assignsNumberToActivationLineAndRelationOnAssignment() {
        
    //     Mock numberClientMock = Mock.forType(NumberClient.class);
    //     MethodSpy reserveNumberDetailByMsisdnAndCVR = numberClientMock.spyOn('reserveNumberDetailByMsisdnAndCVR');
    //     NumberClientResponseDTO.NumberDetail responseWithNumber = new NumberClientResponseDTO.NumberDetail();
    //     responseWithNumber.data = new NumberClientResponseDTO.NumberData();
    //     responseWithNumber.data.id = '12345678';
    //     reserveNumberDetailByMsisdnAndCvr.whenCalledWith(Argument.any(), Argument.any(), Argument.any()).thenReturn(responseWithNumber);

    //     NumberClient numberClient = (NumberClient) numberClientMock.stub;
    //     DatabaseService dbMock = new DatabaseService().mockDMLs();

    //     NumberActivationLinesExecutorHandler handler = new NumberActivationLinesExecutorHandler(numberClient, dbMock);

    //     List<NumberActivationLinesExecutorAction.InputVariables> inputVariables = new List<NumberActivationLinesExecutorAction.InputVariables>();
    //     NumberActivationLinesExecutorAction.InputVariables vars = new NumberActivationLinesExecutorAction.InputVariables();
    //     vars.chunkSize = 3;
    //     vars.activationLineIdToAssignementId = new List<IdToString>();
       
    //     // Create mock data
    //     Account acc = new Account(Name = 'Test Account', CVR__c = '12345678');
    //     insert acc;

    //     Case c = new Case(AccountId = acc.Id);
    //     insert c;

    //     Activation__c activation = new Activation__c(Case__c = c.Id);
    //     insert activation;

    //     Account_Phone_Number_Series__c series = new Account_Phone_Number_Series__c(
    //         Account__c = acc.Id,
    //         Number_Group__c = 'P',
    //         Number_Location__c = 'EKC',
    //         Product_Type__c = 'GSM'
    //     );
    //     insert series;

    //     List<Account_Phone_Number_Assignment__c> phoneAssignments = new List<Account_Phone_Number_Assignment__c>();
    //     for (Integer i = 0; i < 10; i++) {
    //         phoneAssignments.add(
    //             new Account_Phone_Number_Assignment__c(
    //                 Account__c = acc.Id, 
    //                 Account_Phone_Number_Series__c = series.Id,             
    //                 CTN_Number_Status__c = 'AR',
    //                 Phone_Number_Reservation_Status__c = '',
    //                 Phone_Number_Reservation_Error__c = null,
    //                 Activation_line__c = null,
    //                 Phone_Number__c = '4522222221' + i
    //                 ));
    //     }
    //     insert phoneAssignments;

    //     List<Activation_line__c> activationLines = new List<Activation_line__c>();
    //     for (Integer i = 0; i < 10; i++) {
    //         activationLines.add(
    //             new Activation_line__c(
    //                 Case__c = c.Id, 
    //                 Activation__c = activation.Id,
    //                 Phone_Number_Reservation_Status__c = '',
    //                 Phone_Number_Reservation_Error__c = null,
    //                 First_Name__c = 'Peter',
    //                 Last_Name__c = 'Griffin' + i,
    //                 Email__c = 'pg' + i + '@test.com',
    //                 Mobile_No__c = null                    
    //                 ));
    //     }
    //     insert activationLines;

    //     Map<Id, String> tmpMap = new  Map<Id, String>();
    //     tmpMap.put(activationLines.get(0).Id, phoneAssignments.get(0).Id);

    //     String parameters = JSON.serialize(new Map<String, Object>{'activationLineIdToAssignementId' => tmpMap});

    //     EventExecutor__e event = new EventExecutor__e(Parameters__c = parameters, RetryCount__c = 5);

    //     //ACT
    //     handler.execute(event);

    //     //ASSERT
    //     Account_Phone_Number_Assignment__c  updatedAssignment = (Account_Phone_Number_Assignment__c) dbMock.register.updated.get(1);
    //     Activation_Line__c updatedActivationLine = (Activation_Line__c) dbMock.register.updated.get(0);

    //     Assert.areEqual(2, dbMock.register.updated.size(), 'We update both activationline and assignment');
    //     Assert.areEqual(updatedAssignment.Activation_Line__c, updatedActivationLine.Id, 'Assignment and ActivationLine got related');
    //     Assert.areEqual(updatedAssignment.Phone_Number__c, updatedActivationLine.Mobile_No__c, 'ActivationLine got the number from the assignment');
    //     Assert.areEqual(
    //         updatedAssignment.Phone_Number_User__c, updatedActivationLine.First_Name__c + ' ' + updatedActivationLine.last_Name__c + ', ' + updatedActivationLine.email__c, 
    //         'Assignment phonenumberuser is correctly set');
    
        
    // }

    // /**
    //  * @description Tests that the execute method sets the status to success and
    //  * that the activationLine gets a phonenumber and that the assignment gets a relation to the activationline.
    //  * For and Open Series Assignment
    //  */
    // @IsTest
    // public static void execute_fixedSeriesNumber_assignsNumberToActivationLineAndRelationOnAssignment() {
        
    //     Mock numberClientMock = Mock.forType(NumberClient.class);
    //     MethodSpy reserveNumberDetailByMsisdnAndCVR = numberClientMock.spyOn('reserveNumberDetailByMsisdnAndCVR');
    //     NumberClientResponseDTO.NumberDetail responseWithNumber = new NumberClientResponseDTO.NumberDetail();
    //     responseWithNumber.data = new NumberClientResponseDTO.NumberData();
    //     responseWithNumber.data.id = '4522222222';
    //     reserveNumberDetailByMsisdnAndCvr.whenCalledWith(Argument.any(), Argument.any(), Argument.any()).thenReturn(responseWithNumber);

    //     NumberClient numberClient = (NumberClient) numberClientMock.stub;
    //     DatabaseService dbMock = new DatabaseService().mockDMLs();

    //     NumberActivationLinesExecutorHandler handler = new NumberActivationLinesExecutorHandler(numberClient, dbMock);

    //     List<NumberActivationLinesExecutorAction.InputVariables> inputVariables = new List<NumberActivationLinesExecutorAction.InputVariables>();
    //     NumberActivationLinesExecutorAction.InputVariables vars = new NumberActivationLinesExecutorAction.InputVariables();
    //     vars.chunkSize = 3;
    //     vars.activationLineIdToAssignementId = new List<IdToString>();
       
    //     // Create mock data
    //     Account acc = new Account(Name = 'Test Account', CVR__c = '12345678');
    //     insert acc;

    //     Case c = new Case(AccountId = acc.Id);
    //     insert c;

    //     Activation__c activation = new Activation__c(Case__c = c.Id);
    //     insert activation;

    //     Account_Phone_Number_Series__c series = new Account_Phone_Number_Series__c(
    //         Account__c = acc.Id,
    //         Number_Group__c = 'P',
    //         Number_Location__c = 'EKC',
    //         Product_Type__c = 'GSM'
    //     );
    //     insert series;

    //     List<Account_Phone_Number_Assignment__c> phoneAssignments = new List<Account_Phone_Number_Assignment__c>();
    //     for (Integer i = 0; i < 10; i++) {
    //         phoneAssignments.add(
    //             new Account_Phone_Number_Assignment__c(
    //                 Account__c = acc.Id, 
    //                 Account_Phone_Number_Series__c = series.Id,             
    //                 CTN_Number_Status__c = 'AA',
    //                 Phone_Number_Reservation_Status__c = '',
    //                 Phone_Number_Reservation_Error__c = null,
    //                 Activation_line__c = null,
    //                 Phone_Number__c = '4522222221' + i
    //                 ));
    //     }
    //     insert phoneAssignments;

    //     List<Activation_line__c> activationLines = new List<Activation_line__c>();
    //     for (Integer i = 0; i < 10; i++) {
    //         activationLines.add(
    //             new Activation_line__c(
    //                 Case__c = c.Id, 
    //                 Activation__c = activation.Id,
    //                 Phone_Number_Reservation_Status__c = '',
    //                 Phone_Number_Reservation_Error__c = null,
    //                 First_Name__c = 'Peter',
    //                 Last_Name__c = 'Griffin' + i,
    //                 Email__c = 'pg' + i + '@test.com',
    //                 Mobile_No__c = null                    
    //                 ));
    //     }
    //     insert activationLines;

    //     Map<Id, String> tmpMap = new  Map<Id, String>();
    //     tmpMap.put(activationLines.get(0).Id, phoneAssignments.get(0).Id);

    //     String parameters = JSON.serialize(new Map<String, Object>{'activationLineIdToAssignementId' => tmpMap});

    //     EventExecutor__e event = new EventExecutor__e(Parameters__c = parameters, RetryCount__c = 5);

    //     //ACT
    //     handler.execute(event);

    //     //ASSERT
    //     Assert.areEqual(2, dbMock.register.updated.size(), 'We update both activationline and assignment');

    //     Account_Phone_Number_Assignment__c  updatedAssignment = (Account_Phone_Number_Assignment__c) dbMock.register.updated.get(1);
    //     Activation_Line__c updatedActivationLine = (Activation_Line__c) dbMock.register.updated.get(0);

    //     Assert.areEqual(2, dbMock.register.updated.size(), 'We update both activationline and assignment');
    //     Assert.areEqual(updatedAssignment.Activation_Line__c, updatedActivationLine.Id, 'Assignment and ActivationLine got related');
    //      Assert.areEqual(
    //         updatedAssignment.Phone_Number_User__c, updatedActivationLine.First_Name__c + ' ' + updatedActivationLine.last_Name__c + ', ' + updatedActivationLine.email__c, 
    //         'Assignment phonenumberuser is correctly set');
    // } 

    // @IsTest
    // public static void execute_mixedSeriesLargeAmount_assignsNumberToActivationLineAndRelationOnAssignment() {
        
    //     String cvr = '12345678';
    //     Integer aaNumberOfAssignments = 100; //will need reserving thru the numberclient
    //     Integer arNumberAssignments = 100; //are already reserved, no reserving
    //     Integer totalNumberAssignments = aaNumberOfAssignments + arNumberAssignments;
    //     Integer chunkSize = 20;
    //     String productType = 'GSM';

    //     Mock numberClientMock = Mock.forType(NumberClient.class);
    //     MethodSpy reserveNumberDetailByMsisdnAndCVR = numberClientMock.spyOn('reserveNumberDetailByMsisdnAndCVR');    

    //     List<NumberActivationLinesExecutorAction.InputVariables> inputVariables = new List<NumberActivationLinesExecutorAction.InputVariables>();
    //     NumberActivationLinesExecutorAction.InputVariables vars = new NumberActivationLinesExecutorAction.InputVariables();
    //     vars.chunkSize = chunkSize;
    //     vars.activationLineIdToAssignementId = new List<IdToString>();
       
    //     // Create mock data
    //     Account acc = new Account(Name = 'Test Account', CVR__c = cvr);
    //     insert acc;

    //     Case c = new Case(AccountId = acc.Id);
    //     insert c;

    //     Activation__c activation = new Activation__c(Case__c = c.Id);
    //     insert activation;

    //     Account_Phone_Number_Series__c series = new Account_Phone_Number_Series__c(
    //         Account__c = acc.Id,
    //         Number_Group__c = 'P',
    //         Number_Location__c = 'EKC',
    //         Product_Type__c = productType
    //     );
    //     insert series;

    //     List<Account_Phone_Number_Assignment__c> phoneAssignments = new List<Account_Phone_Number_Assignment__c>();
    //     for (Integer i = 0; i < aaNumberOfAssignments; i++) {
    //         phoneAssignments.add(
    //             new Account_Phone_Number_Assignment__c(
    //                 Account__c = acc.Id, 
    //                 Account_Phone_Number_Series__c = series.Id,             
    //                 CTN_Number_Status__c = 'AA',
    //                 Phone_Number_Reservation_Status__c = '',
    //                 Phone_Number_Reservation_Error__c = null,
    //                 Activation_line__c = null,
    //                 Phone_Number__c = '452222222' + i
    //                 ));
    //     }

    //     for (Integer i = aaNumberOfAssignments; i < totalNumberAssignments; i++) {
    //         phoneAssignments.add(
    //             new Account_Phone_Number_Assignment__c(
    //                 Account__c = acc.Id, 
    //                 Account_Phone_Number_Series__c = series.Id,             
    //                 CTN_Number_Status__c = 'AR',
    //                 Phone_Number_Reservation_Status__c = '',
    //                 Phone_Number_Reservation_Error__c = null,
    //                 Activation_line__c = null,
    //                 Phone_Number__c = '452222222' + i
    //                 ));
    //     }
    //     insert phoneAssignments;

    //     List<Activation_line__c> activationLines = new List<Activation_line__c>();
    //     for (Integer i = 0; i < totalNumberAssignments; i++) {
    //         activationLines.add(
    //             new Activation_line__c(
    //                 Case__c = c.Id, 
    //                 Activation__c = activation.Id,
    //                 Phone_Number_Reservation_Status__c = '',
    //                 Phone_Number_Reservation_Error__c = null,
    //                 First_Name__c = 'Peter',
    //                 Last_Name__c = 'Griffin' + i,
    //                 Email__c = 'pg' + i + '@test.com',
    //                 Mobile_No__c = null                    
    //                 ));
    //     }
    //     insert activationLines;

    //     for (Integer i = 0; i < totalNumberAssignments; i++) {
    //         Activation_line__c actLine = activationLines.get(i);
    //         Account_Phone_Number_Assignment__c assignment = phoneAssignments.get(i);
            
    //         AddMockedResponse(reserveNumberDetailByMsisdnAndCVR, cvr, productType, actLine, assignment);
    //     }

    //     NumberClient numberClient = (NumberClient) numberClientMock.stub;
    //     DatabaseService dbMock = new DatabaseService().mockDMLs();
    //     NumberActivationLinesExecutorHandler handler = new NumberActivationLinesExecutorHandler(numberClient, dbMock);

    //     Map<Id, String> tmpMap = new  Map<Id, String>();
    //     tmpMap.put(activationLines.get(0).Id, phoneAssignments.get(0).Id);

    //     String parameters = JSON.serialize(new Map<String, Object>{'activationLineIdToAssignementId' => tmpMap});

    //     EventExecutor__e event = new EventExecutor__e(Parameters__c = parameters, RetryCount__c = 5);

    //     //ACT
    //     handler.execute(event);

    //     //ASSERT
    //     Account_Phone_Number_Assignment__c  updatedAssignment = (Account_Phone_Number_Assignment__c) dbMock.register.updated.get(1);
    //     Activation_Line__c updatedActivationLine = (Activation_Line__c) dbMock.register.updated.get(0);

    //     Assert.areEqual(2, dbMock.register.updated.size(), 'We update both activationline and assignment');
    //     Assert.areEqual(updatedAssignment.Activation_Line__c, updatedActivationLine.Id, 'Assignment and ActivationLine got related');
    //     Assert.areEqual(stripCountryCodeFromPhoneNumber(updatedAssignment.Phone_Number__c), updatedActivationLine.Mobile_No__c, 'ActivationLine got the number from the assignment');
    //     Assert.areEqual(
    //         updatedAssignment.Phone_Number_User__c, updatedActivationLine.First_Name__c + ' ' + updatedActivationLine.last_Name__c + ', ' + updatedActivationLine.email__c, 
    //         'Assignment phonenumberuser is correctly set');
    
        
    // }

    // private static void AddMockedResponse(MethodSpy methodToMock, String cvr, String productType, Activation_Line__c actLine, Account_Phone_Number_Assignment__c assignment) {

    //     NumberClientResponseDTO.NumberDetail responseWithNumber = new NumberClientResponseDTO.NumberDetail();
    //         responseWithNumber.data = new NumberClientResponseDTO.NumberData();
    //         responseWithNumber.data.id = assignment.Phone_Number__c;
    //         methodToMock.whenCalledWith(assignment.Phone_Number__c, cvr, productType).thenReturn(responseWithNumber);
    // }

    //  private static String stripCountryCodeFromPhoneNumber(string phoneNumber){
    //     if(phoneNumber.length() == 10){
    //         return phoneNumber.substring(2, phoneNumber.length());
    //     }
    //     return phoneNumber;  
    // } 
}