/**
 * @description This class is an invocable action that changes the activation line number from one account phone number assignment to another.
 * It is used in flows and processes to automate the number change process.
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær         2025-08-19      Initial version.
 *
 * @author Kenneth Houkjær
 * @date 2025-08-19
 */
public with sharing class NumberChangeActLineNumberAction {

    @TestVisible
    private static NumberClient numberClient;

    /**
     * @description This method is the entry point for the invocable action. It takes a list of number change requests and processes them.
     * @param requests A list of NumberChangeRequest objects, each containing the Ids for the from/to assignments and the activation line.
     */
    @InvocableMethod(label='Change activation line number' description='Changes the activation line number from one account phone number assignment to another.')
    public static void changeNumber(List<NumberChangeRequest> requests) {
        if (requests == null || requests.isEmpty()) {
            return;
        }

        if (numberClient == null) {
            numberClient = new NumberClient();
        }

        Set<Id> fromAssignmentIds = new Set<Id>();
        Set<Id> toAssignmentIds = new Set<Id>();
        Set<Id> activationLineIds = new Set<Id>();

        for (NumberChangeRequest request : requests) {
            fromAssignmentIds.add(request.fromAccountPhoneNumberAssignmentId);
            toAssignmentIds.add(request.toAccountPhoneNumberAssignmentId);
            activationLineIds.add(request.fromActivationLineId);
            if (request.toActivationLineId != null) {
                activationLineIds.add(request.toActivationLineId);
            }
        }

        Map<Id, Account_Phone_Number_Assignment__c> fromAssignments = AccountPhoneNumberAssignmentSelector.getMapOfAssignmentsByAssignmentIds(new List<Id>(fromAssignmentIds));
        Map<Id, Account_Phone_Number_Assignment__c> toAssignments = AccountPhoneNumberAssignmentSelector.getMapOfAssignmentsByAssignmentIds(new List<Id>(toAssignmentIds));
        Map<Id, Activation_line__c> activationLines = ActivationLineSelector.getMapOfActivationLinesByIds(activationLineIds);
        
        Set<Id> allAssignmentIds = new Set<Id>();
        allAssignmentIds.addAll(fromAssignmentIds);
        allAssignmentIds.addAll(toAssignmentIds);
        Map<String, Activation_Assignment_Junction__c> junctionMap = ActivationAssignmentJunctionSelector.getJunctionsMap(allAssignmentIds, activationLineIds);

        Set<String> fromPhoneNumbersForChange = new Set<String>();
        for (NumberChangeRequest request : requests) {
            if (request.changeType == 'CHANGE') {
                Account_Phone_Number_Assignment__c fromAssignment = fromAssignments.get(request.fromAccountPhoneNumberAssignmentId);
                if (fromAssignment != null && fromAssignment.Phone_Number__c != null) {
                    fromPhoneNumbersForChange.add(fromAssignment.Phone_Number__c);
                }
            }
        }

        Map<String, List<Id>> phoneNumberToActivationLineIds = new Map<String, List<Id>>();
        if (!fromPhoneNumbersForChange.isEmpty()) {
            for (Activation_line__c al : [SELECT Id, Mobile_No__c FROM Activation_line__c WHERE Mobile_No__c IN :fromPhoneNumbersForChange]) {
                if (!phoneNumberToActivationLineIds.containsKey(al.Mobile_No__c)) {
                    phoneNumberToActivationLineIds.put(al.Mobile_No__c, new List<Id>());
                }
                phoneNumberToActivationLineIds.get(al.Mobile_No__c).add(al.Id);
            }
        }

        List<Activation_Assignment_Junction__c> junctionsToUpdate = new List<Activation_Assignment_Junction__c>();
        List<Activation_Assignment_Junction__c> junctionsToInsert = new List<Activation_Assignment_Junction__c>();
        List<Activation_line__c> activationLinesToUpdate = new List<Activation_line__c>();

        for (NumberChangeRequest request : requests) {
            try {
                Account_Phone_Number_Assignment__c fromAssignment = fromAssignments.get(request.fromAccountPhoneNumberAssignmentId);
                Account_Phone_Number_Assignment__c toAssignment = toAssignments.get(request.toAccountPhoneNumberAssignmentId);
                Activation_line__c fromActivationLine = activationLines.get(request.fromActivationLineId);

                if (request.changeType == 'ISSWAP') {
                    Activation_line__c toActivationLine = activationLines.get(request.toActivationLineId);
                    if (fromAssignment != null && toAssignment != null && fromActivationLine != null && toActivationLine != null) {
                       
                        fromActivationLine.Mobile_No__c = NumberChangeActLineNumberAction.stripCountryCodeFromPhoneNumber(toAssignment.Phone_Number__c);
                        toActivationLine.Mobile_No__c =  NumberChangeActLineNumberAction.stripCountryCodeFromPhoneNumber(fromAssignment.Phone_Number__c);
                        fromActivationLine.Phone_Number_Reservation_Status__c = 'SUCCESS';
                        fromActivationLine.Phone_Number_Reservation_Error__c = null;
                        toActivationLine.Phone_Number_Reservation_Status__c = 'SUCCESS';
                        toActivationLine.Phone_Number_Reservation_Error__c = null;
                        activationLinesToUpdate.add(fromActivationLine);
                        activationLinesToUpdate.add(toActivationLine);

                        Logger.logInfo('NumberChangeActLineNumberAction fromActivationLine ' + fromActivationLine);
                        Logger.logInfo('NumberChangeActLineNumberAction toActivationLine ' + toActivationLine);

                        String fromJunctionKey = fromAssignment.Id + '-' + fromActivationLine.Id;
                        String toJunctionKey = toAssignment.Id + '-' + toActivationLine.Id;

                        if (junctionMap.containsKey(fromJunctionKey) && junctionMap.containsKey(toJunctionKey)) {
                            Activation_Assignment_Junction__c fromJunction = junctionMap.get(fromJunctionKey);
                            Activation_Assignment_Junction__c toJunction = junctionMap.get(toJunctionKey);

                            fromJunction.Account_Phone_Number_Assignment__c = toAssignment.Id;
                            toJunction.Account_Phone_Number_Assignment__c = fromAssignment.Id;

                            Logger.logInfo('NumberChangeActLineNumberAction fromJunction ' + fromJunction);
                            Logger.logInfo('NumberChangeActLineNumberAction toJunction ' + toJunction);

                            junctionsToUpdate.add(fromJunction);
                            junctionsToUpdate.add(toJunction);
                        }
                    }
                } else if (request.changeType == 'CHANGE') {
                    if (fromAssignment != null && toAssignment != null && fromActivationLine != null) {
                        // Un-reserve "from" number if it's a fixed number and not used elsewhere
                        if (fromAssignment.Account_Phone_Number_Series__r != null &&
                            fromAssignment.Account_Phone_Number_Series__r.Number_Group__c != 'P' &&
                            fromAssignment.Account_Phone_Number_Series__r.Number_Location__c != 'EKC') {

                            List<Id> usersOfFromNumber = phoneNumberToActivationLineIds.get(fromAssignment.Phone_Number__c);
                            // If the number is used by only one activation line, and that line is the current one, it's safe to un-reserve.
                            if (usersOfFromNumber == null || (usersOfFromNumber.size() == 1 && usersOfFromNumber[0] == fromActivationLine.Id)) {
                                numberClient.unreserveNumberDetailByMsisdn(fromAssignment.Phone_Number__c);
                            }
                        }

                        // Reserve "to" number if it's a fixed number and status is 'AA'
                        if (toAssignment.Account_Phone_Number_Series__r != null &&
                            toAssignment.CTN_Number_Status__c == 'AA' &&
                            toAssignment.Account_Phone_Number_Series__r.Number_Group__c != 'P' &&
                            toAssignment.Account_Phone_Number_Series__r.Number_Location__c != 'EKC') {
                            
                            String productType = toAssignment.Account_Phone_Number_Series__r.Product_Type__c;
                            numberClient.reserveNumberDetailByMsisdnAndCVR(toAssignment.Phone_Number__c, toAssignment.Account__r.CVR__c, productType);
                        }

                        fromActivationLine.Mobile_No__c =  NumberChangeActLineNumberAction.stripCountryCodeFromPhoneNumber(toAssignment.Phone_Number__c);
                        fromActivationLine.Phone_Number_Reservation_Status__c = 'SUCCESS';
                        fromActivationLine.Phone_Number_Reservation_Error__c = null;
                        activationLinesToUpdate.add(fromActivationLine);

                        String junctionKey = fromAssignment.Id + '-' + fromActivationLine.Id;
                        if (junctionMap.containsKey(junctionKey)) {
                            Activation_Assignment_Junction__c junction = junctionMap.get(junctionKey);
                            junction.Account_Phone_Number_Assignment__c = toAssignment.Id;
                            junctionsToUpdate.add(junction);
                        }
                    }
                } else if (request.changeType == 'NOASSIGNMENTNUMBER') {
                    if (toAssignment != null && fromActivationLine != null) {
                        fromActivationLine.Mobile_No__c = NumberChangeActLineNumberAction.stripCountryCodeFromPhoneNumber(toAssignment.Phone_Number__c);
                        activationLinesToUpdate.add(fromActivationLine);

                        junctionsToInsert.add(new Activation_Assignment_Junction__c(
                            Account_Phone_Number_Assignment__c = toAssignment.Id,
                            Activation_line__c = fromActivationLine.Id
                        ));
                    }
                } else if (request.changeType == 'PORTINGSWAP') {
                    // For porting swap, we must operate on two specific lines.
                    // Query them directly to ensure data integrity and avoid stale data from the initial query.
                    Map<Id, Activation_line__c> linesToSwap = new Map<Id, Activation_line__c>([
                        SELECT Id, Mobile_No__c, Phone_no_Status__c
                        FROM Activation_line__c
                        WHERE Id IN (:request.fromActivationLineId, :request.toActivationLineId)
                    ]);
                    
                    Activation_line__c fromAl = linesToSwap.get(request.fromActivationLineId);
                    Activation_line__c toAl = linesToSwap.get(request.toActivationLineId);

                    if (fromAl != null && toAl != null &&
                        fromAl.Phone_no_Status__c == 'Nummer skal porteres' &&
                        toAl.Phone_no_Status__c == 'Nummer skal porteres') {
                        
                        String fromMobileNo = fromAl.Mobile_No__c;
                        fromAl.Mobile_No__c = toAl.Mobile_No__c;
                        toAl.Mobile_No__c = fromMobileNo;
                        
                        // TODO: Add logic to change Power of Attorney
                        
                        activationLinesToUpdate.add(fromAl);
                        activationLinesToUpdate.add(toAl);
                    }
                }
            } catch (Exception ex) {
                Activation_line__c activationLineToUpdate = activationLines.get(request.fromActivationLineId);
                if (activationLineToUpdate != null) {
                    activationLineToUpdate.Phone_Number_Reservation_Status__c = 'ERROR';
                    activationLineToUpdate.Phone_Number_Reservation_Error__c = ex.getMessage();
                    activationLinesToUpdate.add(activationLineToUpdate);
                }
                if (request.changeType == 'ISSWAP' && request.toActivationLineId != null) {
                    Activation_line__c toActivationLineToUpdate = activationLines.get(request.toActivationLineId);
                    if (toActivationLineToUpdate != null) {
                        toActivationLineToUpdate.Phone_Number_Reservation_Status__c = 'ERROR';
                        toActivationLineToUpdate.Phone_Number_Reservation_Error__c = ex.getMessage();
                        activationLinesToUpdate.add(toActivationLineToUpdate);
                    }
                }
                Logger.logError(ex);
            }
        }

        if (!activationLinesToUpdate.isEmpty()) {
            update activationLinesToUpdate;
        }
        if (!junctionsToUpdate.isEmpty()) {
            update junctionsToUpdate;
        }
        if (!junctionsToInsert.isEmpty()) {
            insert junctionsToInsert;
        }
        
        Logger.emit();
    }

    public static String stripCountryCodeFromPhoneNumber(string phoneNumber){
        if(phoneNumber != null && phoneNumber.length() == 10){
            return phoneNumber.substring(2, phoneNumber.length());
        }
        return phoneNumber;  
    } 

    /**
     * @description This class represents the request for a number change. It is used as the input for the invocable action.
     */
    public class NumberChangeRequest {
        /**
         * @description The Id of the Account_Phone_Number_Assignment__c record to change from.
         */
        @InvocableVariable(label='From Account Phone Number Assignment Id')
        public Id fromAccountPhoneNumberAssignmentId;

        /**
         * @description The Id of the Account_Phone_Number_Assignment__c record to change to.
         */
        @InvocableVariable(label='To Account Phone Number Assignment Id')
        public Id toAccountPhoneNumberAssignmentId;

        /**
         * @description The Id of the Activation_line__c record to update.
         */
        @InvocableVariable(label='From Activation Line Id')
        public Id fromActivationLineId;

        /**
         * @description The Id of the second Activation_line__c record to update, used for swaps.
         */
        @InvocableVariable(label='To Activation Line Id')
        public Id toActivationLineId;

        /**
         * @description A string to indicate the type of change.
         */
        @InvocableVariable(label='Change Type')
        public String changeType = '';
    }
}