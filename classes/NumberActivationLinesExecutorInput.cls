/** TODO DELETE ME **/
/**
 * The NumberActivationLinesExecutorInput class is an invocable action that creates a mapping between activation lines and phone number assignments.
 * It is used in a flow to prepare the input for the NumberActivationLinesExecutorHandler.
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær         27/07/2025      Initial version
 *
 * @author Kenneth Houkjær
 * @date 27/07/2025
 */
 public with sharing class NumberActivationLinesExecutorInput {
//     private static String PHONE_NUMBER_RESERVATION_STATUS_INPROGRESS = 'INPROGRESS';

//     /**
//      * @description This method is called from a flow to create a mapping between activation lines and phone number assignments.
//      * @param inputVariables A list of input variables from the flow.
//      * @return A list of output variables containing the mapping.
//      */
//     @InvocableMethod(category='Number' label='Create ActivationLineExecutor Input' description='Creates a List<IdToString> collection mapping activationLines and assignments.')
//     public static List<OutputVariables> createActivationLineToAssignmentMappings(List<InputVariables> inputVariables) {        
//         OutputVariables output = new OutputVariables();
//         output.activationLineIdToAssignementId = new List<IdToString>();
        
//         try {
//             // keep SOQL here instead of using selector class, advised by Kenneth
//             Activation__c activation = [
//                 SELECT Id, Case__r.Id, Case__r.AccountId 
//                 FROM Activation__c 
//                 WHERE Id = :inputVariables.get(0).activation.Id
//             ];

//             Account acc = AccountSelector.getAccountByCaseId(activation.case__r.id);

//             // we only want Account_Phone_Number_Assignment__c records where the Lookup field to Activation Line is null
//             List<Account_Phone_Number_Assignment__c> listOfPhoneNumberAssignments = 
//                 AccountPhoneNumberAssignmentSelector.getAssignmentsUnlinkedToActivationLine(acc);

//             List<Account_Phone_Number_Assignment__c> listOfPhoneNumberAssignmentsSorted = 
//                 getListOfPhoneNumberAssignmentsSorted(listOfPhoneNumberAssignments);

//             //TODO: khp we should filter the activationlines to those who need phone numbers
//             // List<Activation_line__c> listOfActivationLines = ActivationLineSelector.getActivationLinesByCaseId(activation.Case__c);

//             // we only want Activation_line__c records where Mobile_no__c is blank
//             // keep SOQL here instead of using selector class, advised by Kenneth
//             List<Activation_line__c> listOfActivationLines = [
//                 SELECT Id
//                 FROM Activation_line__c
//                 WHERE Activation__r.Case__c = :activation.Case__c AND Not_to_Activation__c = FALSE AND Mobile_no__c = ''
//             ];

//             Logger.logInfo('listOfActivationLines: ' + listOfActivationLines);
//             Logger.logInfo('listOfActivationLines.size(): ' + listOfActivationLines.size());
//             Logger.logInfo('listOfPhoneNumberAssignments: ' + listOfPhoneNumberAssignments);
//             Logger.logInfo('listOfPhoneNumberAssignments.size(): ' + listOfPhoneNumberAssignments.size());
//             Logger.logInfo('listOfPhoneNumberAssignmentsSorted: ' + listOfPhoneNumberAssignmentsSorted);
//             Logger.logInfo('listOfPhoneNumberAssignmentsSorted.size(): ' + listOfPhoneNumberAssignmentsSorted.size());

//             for (integer i = 0; i < listOfActivationLines.size(); i++) {                
//                 Activation_line__c activationLine = listOfActivationLines.get(i);
//                 activationLine.Phone_Number_Reservation_Status__c = PHONE_NUMBER_RESERVATION_STATUS_INPROGRESS;
//             }
//             update listOfActivationLines;

//             /* TODO at some point we need to implement a check to ensure that there are enough 
//             Account_Phone_Number_Assignment__c records. Meaning the number of Account_Phone_Number_Assignment__c records
//             must be equal to or greater than the number of Activation_Line__c records
//             Could it be checked in the flow? And how would we show in a nice way to the user if there is not enough
//             Account_Phone_Number_Assignment__c records and hence the user needs to reserve some more??? */
//             for (integer i = 0; i < listOfActivationLines.size(); i++) {                
//                 Activation_line__c activationLine = listOfActivationLines.get(i);
//                 Account_Phone_Number_Assignment__c assignment = listOfPhoneNumberAssignmentsSorted.get(i);

//                 IdToString idToString = new IdToString();
//                 idToString.key = activationLine.Id;
//                 idToString.value = assignment.Id;
//                 output.activationLineIdToAssignementId.add(idToString);
//             }
//             Logger.emit();
//         } catch (HTTPException ex) {
//             Logger.logError(ex);
//             Logger.emit();
//             throw ex;
//         }
        
//         return new List<OutputVariables>{output};
//     }

//     /**
//      * @description This method goes through all the Account_Phone_Number_Assignment__c records and puts them in a 
//      * another list, in a way that the records belonging to a Fixed phone number series are added first and then the 
//      * records belonging to an Open phone number series are added last.
//      * @param listOfPhoneNumberAssignments A list of Account_Phone_Number_Assignment__c records.
//      * @return A list of Account_Phone_Number_Assignment__c records sorted.
//      */
//     private static List<Account_Phone_Number_Assignment__c> getListOfPhoneNumberAssignmentsSorted(
//         List<Account_Phone_Number_Assignment__c> listOfPhoneNumberAssignments) {
        
//         List<Account_Phone_Number_Assignment__c> listOfPhoneNumberAssignmentsSorted = new List<Account_Phone_Number_Assignment__c>();
//         List<Account_Phone_Number_Assignment__c> listOfPhoneNumberAssignmentsFixed = new List<Account_Phone_Number_Assignment__c>();
//         List<Account_Phone_Number_Assignment__c> listOfPhoneNumberAssignmentsOpen = new List<Account_Phone_Number_Assignment__c>();

//         // we need a list of the open phone number series to use represented by composite keys
//         List<String> groupAndLocationCompositeKeyOpenPhoneNumberSeriesList = getGroupAndLocationCompositeKeyOpenPhoneNumberSeriesList();

//         // go through listOfPhoneNumberAssignments and put Fixed in one bucket and Open in another bucket
//         // then add to a final list where the Fixed are added first and then the Open are added last
//         for (Account_Phone_Number_Assignment__c accountPhoneNumberAssignment : listOfPhoneNumberAssignments) {
//             if (isOpen(groupAndLocationCompositeKeyOpenPhoneNumberSeriesList, accountPhoneNumberAssignment)) {
//                 listOfPhoneNumberAssignmentsOpen.add(accountPhoneNumberAssignment);
//             } else {
//                 listOfPhoneNumberAssignmentsFixed.add(accountPhoneNumberAssignment);
//             }
//         }

//         /* we want to ensure that FIRST we use from the Fixed Phone Number Series, THEN we use from the Open Phone
//         Number Series. */
//         listOfPhoneNumberAssignmentsSorted.addAll(listOfPhoneNumberAssignmentsFixed);
//         listOfPhoneNumberAssignmentsSorted.addAll(listOfPhoneNumberAssignmentsOpen);
//         return listOfPhoneNumberAssignmentsSorted;
//     }

//     /**
//      * @description This method goes through all OpenPhoneNumberSeries__mdt records and for each record it takes the 
//      * Number_Group__c and Number_Location__c and concatenate them, separated by '_' and puts the string in the list
//      * that we return.
//      * @return List<String> List of composite key of the Open Phone Number Series records
//      */
//     private static List<String> getGroupAndLocationCompositeKeyOpenPhoneNumberSeriesList() {
//         // we need all records for OpenPhoneNumberSeries__mdt 
//         List<OpenPhoneNumberSeries__mdt> openPhoneNumberSeries = MetadataSelector.getOpenPhoneNumberSeries();

//         // we make the composite key up of the Number Group and Number Location from the Open Phone Number Series record
//         List<String> groupAndLocationCompositeKeyOpenPhoneNumberSeriesList = new List<String>();

//         // add to groupAndLocationCompositeKeyOpenPhoneNumberSeriesList
//         for (OpenPhoneNumberSeries__mdt openPhoneNumberSeriesRecord : openPhoneNumberSeries) {
//             String compositeKey = getGroupAndLocationCompositeKey(
//                 openPhoneNumberSeriesRecord.Number_Group__c, 
//                 openPhoneNumberSeriesRecord.Number_Location__c
//             );
//             groupAndLocationCompositeKeyOpenPhoneNumberSeriesList.add(compositeKey);
//         }
//         Logger.logInfo('getGroupAndLocationCompositeKeyOpenPhoneNumberSeriesList groupAndLocationCompositeKeyOpenPhoneNumberSeriesList: ' + groupAndLocationCompositeKeyOpenPhoneNumberSeriesList);
//         return groupAndLocationCompositeKeyOpenPhoneNumberSeriesList;
//     }

//     /**
//      * @description This method is used to get the composite key, by combining numberGroup and numberLocation, 
//      * separated by a separator.
//      * @param group The Number Group
//      * @param location The Number Location
//      * @return String The composite key
//      */
//     private static String getGroupAndLocationCompositeKey(String numberGroup, String numberLocation) {
//         String compositeKeySeparator = '_';
//         String compositeKey = numberGroup + compositeKeySeparator + numberLocation;
//         return compositeKey;
//     }

//     /**
//      * @description This method checks whether the combination of:
//      *      Account_Phone_Number_Assignment__c.Account_Phone_Number_Series__r.Number_Group__c and
//      *      Account_Phone_Number_Assignment__c.Account_Phone_Number_Series__r.Number_Location__c
//      * is found in the list passed in.
//      * @param groupAndLocationCompositeKeyOpenPhoneNumberSeriesList A list of strings.
//      * @param accountPhoneNumberAssignment An Account_Phone_Number_Assignment__c record we need to check.
//      * @return A boolean value indicating if the Account_Phone_Number_Assignment__c record is open or not.
//      */
//     private static Boolean isOpen(
//         List<String> groupAndLocationCompositeKeyOpenPhoneNumberSeriesList, 
//         Account_Phone_Number_Assignment__c accountPhoneNumberAssignment) {
            
//         Logger.logInfo('accountPhoneNumberAssignment.Account_Phone_Number_Series__r.Number_Group__c: ' + accountPhoneNumberAssignment.Account_Phone_Number_Series__r.Number_Group__c);
//         Logger.logInfo('accountPhoneNumberAssignment.Account_Phone_Number_Series__r.Number_Location__c: ' + accountPhoneNumberAssignment.Account_Phone_Number_Series__r.Number_Location__c);

//         String compositeKeyViaAccountPhoneNumberAssignment = getGroupAndLocationCompositeKey(
//             accountPhoneNumberAssignment.Account_Phone_Number_Series__r.Number_Group__c, 
//             accountPhoneNumberAssignment.Account_Phone_Number_Series__r.Number_Location__c
//         );
//         Boolean isNumberOpen = groupAndLocationCompositeKeyOpenPhoneNumberSeriesList.contains(compositeKeyViaAccountPhoneNumberAssignment);
//         return isNumberOpen;
//     }

//     public class InputVariables {
//         @InvocableVariable
//         public Activation__c activation;
//     }

//     public class OutputVariables {
//         @InvocableVariable
//         public List<IdToString> activationLineIdToAssignementId;
//     }
 }