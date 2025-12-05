/** 
 * NB. This Apex Action Class will NOT handle bulk.
 * 
 * Action class to assist in finding 'Account_Phone_Number_Assignment__c' records that can be used for the  
 * functionality where an Activation Line in question needs a different number than what it currently is (not a swap).
 * (The Swap functionality is handled directly in Flow and does not need help from Apex action)
 * 
 * The Assignments that will be returned are Assignments that meet one of these clauses: 
 *      -   an assignment that is NOT currently joined with any Activation Line AND this assignment belongs to the same 
 *          Account as the Activation Line in question.
 * 
 *          OR
 * 
 *      -   an assignment that is joined with an Activation Line AND this Activation Line is associated with the same 
 *          Activation as the Activation Line in question.
 * 
 * @author  Kirstine Nielsen
 * @since   2025-08-22
 * @see     https://jira-ks.norlys.dk/browse/DKT-45146
 */
public with sharing class NumberFindChangeNumbersAction {

    final Static Integer AMOUNT_TO_RETRIEVE = -1;
    final Static String QUERY_TYPE = '';  // is left blank, then we ensure to fetch assignments that meet either of the clauses in the class doc

    /**
     * NB. This method will NOT handle bulk.
     * 
     * @description for each inputVariables (we only look at the first item in the list), build and return the 
     * outputVars and return in a list.
     * Each inputVariables holds an activation line in question and through this record we know the Activation and 
     * Account it belongs to. This is used to find out which Account Phone Number Assignments (numbers) to return in the 
     * outputVariables.
     * 
     * @param inputVariables List of inputVariables to be used to build the outputVars.
     * @return List of OutputVariables.
     */
    @InvocableMethod(
        label='Find Account Phone Number Assignments for Change (Non Swap)' 
        description='Find Account Phone Number Assignments for Change (Non Swap)')
    public static List<OutputVariables> getDifferentAccountPhoneNumberAssignments(List<InputVariables> inputVariables) {

        // We will ONLY look at the first in the list (not bulkified)
        InputVariables inputVars = inputVariables[0];
        

        // List of OutputVariables to be returned to the flow
        List<OutputVariables> outputVariablesListToReturn = new List<OutputVariables>();       

        // Activation Lines, get the activation lines from inputVariables, represented in a map with access to more fields
        Map<Id, Activation_line__c> activationLineMap = getActivationLineMap(inputVariables);
        Logger.logInfo('NumberFindChangeNumbersAction activationLine.Id: ' + activationLineMap.get(inputVars.activationLine.Id).Id);
        Logger.logInfo('NumberFindChangeNumbersAction activationLine.Name: ' + activationLineMap.get(inputVars.activationLine.Id).Name);

        Map<Id, List<AccountPhoneNumberAssignmentService.AssignmentWrapper>> activationIdToAssignmentWrapperMap = new Map<Id, List<AccountPhoneNumberAssignmentService.AssignmentWrapper>>();
        activationIdToAssignmentWrapperMap = getActivationIdToAssignmentWrapperMap(inputVars, activationLineMap);

        outputVariablesListToReturn = buildOutputVariablesList(inputVariables, activationIdToAssignmentWrapperMap, activationLineMap);

        Logger.logInfo('NumberFindChangeNumbersAction outputVariablesListToReturn[0]: ' + outputVariablesListToReturn[0]);
        
        Logger.emit();
        return outputVariablesListToReturn;
    }

    /**
     * @description Returns a map of Activation Ids to a list of AssignmentWrapper records.
     * 
     * @param inputVars a single inputVariables.
     * @param activationLineMap Map of Activation Line Ids to Activation Line records.
     * @return Map of Activation Ids to a list of AssignmentWrapper records.
     */
    private static Map<Id, List<AccountPhoneNumberAssignmentService.AssignmentWrapper>> getActivationIdToAssignmentWrapperMap(
        InputVariables inputVars, Map<Id, Activation_line__c> activationLineMap) {

        // Map to return
        Map<Id, List<AccountPhoneNumberAssignmentService.AssignmentWrapper>> activationIdToAssignmentWrapperMap = 
            new Map<Id, List<AccountPhoneNumberAssignmentService.AssignmentWrapper>>();
        
        Activation_line__c activationLineInQuestion = activationLineMap.get(inputVars.activationLine.Id);

        // Prepare List of Activation Ids (since we don't handle bulk, the list will always only one item)
        List<Id> activationIds = new List<Id>();
        activationIds.add(activationLineMap.get(activationLineInQuestion.Id).Activation__c);

        /* we have many to many (activation line <- junction -> assignment), but we have agreed to only look at the first the best 
         * (worst case is that the assignment being returned in outputVars is just an assignment the activation line is 
         * already linked to. And the user will simply get the choice to change number to the same number) */
        Map<Id, Id> activationIdToAssignmentIdToExcludeMap = new Map<Id, Id>(); 
        Id assignmentToExcludeId;
        Map<Id, List<Activation_Assignment_Junction__c>> activationLineIdToJunctionsMap = getMapOfActivationLineIdToJunctions(activationLineMap);
        Logger.logInfo('NumberFindChangeNumbersAction activationLineIdToJunctionsMap.size() zero or max 1: ' + activationLineIdToJunctionsMap.size());  // since we don't bulkify we should always only have zero or one entry in the map

        List<Activation_Assignment_Junction__c> junctionsList = activationLineIdToJunctionsMap.get(inputVars.activationLine.Id);

        // we agreed to just take first the best
        if (junctionsList != null && junctionsList.size() > 0) {
            // so we just want the first the best
            assignmentToExcludeId = junctionsList[0].Account_Phone_Number_Assignment__c;
            Logger.logInfo('NumberFindChangeNumbersAction assignmentToExcludeId: ' + assignmentToExcludeId);
            activationIdToAssignmentIdToExcludeMap.put(activationLineMap.get(activationLineInQuestion.Id).Activation__c, assignmentToExcludeId);
        }

        // Call service to get the Activation Id mapped to list of relevant Assignments
        activationIdToAssignmentWrapperMap = AccountPhoneNumberAssignmentService.getAssignmentsForActivationMapped(
                activationIds, 
                AMOUNT_TO_RETRIEVE,
                false, 
                activationIdToAssignmentIdToExcludeMap,
                QUERY_TYPE
            );
        
        return activationIdToAssignmentWrapperMap;
    }

    /**
     * @description Returns a map of Activation Lines.
     * 
     * @param inputVariables List of InputVariables.
     * @return Map of Activation Line Id to Activation Line.
     */
    private static Map<Id, Activation_line__c> getActivationLineMap(List<InputVariables> inputVariables) {
        Set<Id> activationLineIdsToRequery = new Set<Id>();  
        
        for (InputVariables inputVars : inputVariables) {
            activationLineIdsToRequery.add(inputVars.activationLine.Id);
        }

        List<Activation_line__c> activationLines = ActivationLineSelector.getActivationLinesByIds(activationLineIdsToRequery);
        Map<Id, Activation_line__c> activationLineMap = new Map<Id, Activation_line__c>(activationLines);

        return activationLineMap;
    }

    /**
     * @description Builds and returns a list of outputVars.
     * 
     * @param inputVariables List of inputVariables to be used to build the outputVars.
     * @param activationIdToAssignmentWrapperMap Map of Activation Ids to a list of AssignmentWrapper records.
     * @param activationLineMap Map of Activation Line Ids to Activation Line records.
     * @return List of OutputVariables.
     */
    private static List<OutputVariables> buildOutputVariablesList(
        List<InputVariables> inputVariables,
        Map<Id, List<AccountPhoneNumberAssignmentService.AssignmentWrapper>> activationIdToAssignmentWrapperMap,
        Map<Id, Activation_line__c> activationLineMap) {

        List<OutputVariables> outputVariablesList = new List<OutputVariables>();

        // build an outputVars for each inputVars
        for (InputVariables inputVars : inputVariables) {
            Id parentActivationId = activationLineMap.get(inputVars.activationLine.Id).Activation__c;
            List<AccountPhoneNumberAssignmentService.AssignmentWrapper> assignmentWrappers = 
                activationIdToAssignmentWrapperMap.get(parentActivationId);

            // build the single OutputVariables for specific inputVars and add it to the list to return
            OutputVariables outputVars = buildOutputVariables(inputVars, assignmentWrappers);
            outputVariablesList.add(outputVars);
        }

        return outputVariablesList;
    }

    /**
     * @description Builds and returns an outputVars for specific Activation. The outputVars will hold 3 lists of  
     * Account_Phone_Number_Assignment__c records. 
     *  1. bothJoinedAndNonJoinedAssignments holds the linked and unlinked assignments.
     *  2. joinedAssignments holds the linked assignments.
     *  3. nonJoinedAssignments holds the unlinked assignments.
     * 
     * @param inputVars 
     * @param unsortedAssignmentsWrappersForSpecificActivation assignments to sort through.
     * @param activationLineIdToJunctionsMap Map of Activation Line Ids to a list of Assignment_Junction__c records.
     * @return OutputVariables containing the 3 lists of Account_Phone_Number_Assignment__c records. 
     */
    private static OutputVariables buildOutputVariables(
        InputVariables inputVars,
        List<AccountPhoneNumberAssignmentService.AssignmentWrapper> unsortedAssignmentsWrappersForSpecificActivation) {

        OutputVariables outputVars = new OutputVariables();

        List<Account_Phone_Number_Assignment__c> bothLinkedAndUnlinkedAssignments = new List<Account_Phone_Number_Assignment__c>();
        List<Account_Phone_Number_Assignment__c> linkedAssignments = new List<Account_Phone_Number_Assignment__c>();
        List<Account_Phone_Number_Assignment__c> unlinkedAssignments = new List<Account_Phone_Number_Assignment__c>();

        // check for null
        if (unsortedAssignmentsWrappersForSpecificActivation != null) {
            // loop through the unsorted assignments for specific Activation and add to correct lists
            for (AccountPhoneNumberAssignmentService.AssignmentWrapper assignmentWrap : unsortedAssignmentsWrappersForSpecificActivation) {
                bothLinkedAndUnlinkedAssignments.add(assignmentWrap.assignment);
                // check if assignment is linked to another Activation Line (isInUse)
                if (assignmentWrap.isInUse) {
                    linkedAssignments.add(assignmentWrap.assignment);
                } else {
                    unlinkedAssignments.add(assignmentWrap.assignment);
                }
            }
        }

        // fill in the properties on outputVars
        outputVars.bothJoinedAndNonJoinedAssignments = bothLinkedAndUnlinkedAssignments;
        outputVars.joinedAssignments = linkedAssignments;
        outputVars.nonJoinedAssignments = unlinkedAssignments;
        
        Logger.logInfo('NumberFindChangeNumbersAction bothJoinedAndNonJoinedAssignments.size(): ' + outputVars.bothJoinedAndNonJoinedAssignments.size());
        Logger.logInfo('NumberFindChangeNumbersAction joinedAssignments.size(): ' + outputVars.joinedAssignments.size());
        Logger.logInfo('NumberFindChangeNumbersAction nonJoinedAssignments.size(): ' + outputVars.nonJoinedAssignments.size());

        return outputVars;
    }

    /**
     * @description Returns a map of Activation Line Ids to a list of Assignment_Junction__c records.
     * 
     * @param activationLineMap Map of Activation Line Ids to Activation Line records.
     * @return Map of Activation Line Ids to a list of Assignment_Junction__c records.
     */
    private static Map<Id, List<Activation_Assignment_Junction__c>> getMapOfActivationLineIdToJunctions(
        Map<Id, Activation_line__c> activationLineMap) {

        // Map to return
        Map<Id, List<Activation_Assignment_Junction__c>> activationLineIdToJunctionsMap = new Map<Id, List<Activation_Assignment_Junction__c>>();

        List<Activation_Assignment_Junction__c> junctionList = 
            ActivationAssignmentJunctionSelector.getActivationAssignmentJunctionsByAcativationLineIds(activationLineMap.keySet());

        // Create the Map of Activation Line Ids to a list of Juntions
        for (Activation_Assignment_Junction__c junction : junctionList) {
            if (activationLineIdToJunctionsMap.containsKey(junction.Activation_line__c)) {
                activationLineIdToJunctionsMap.get(junction.Activation_line__c).add(junction);
            } else {
                List<Activation_Assignment_Junction__c> junctionsForParticularActivationLine = new List<Activation_Assignment_Junction__c>();
                junctionsForParticularActivationLine.add(junction);
                activationLineIdToJunctionsMap.put(junction.Activation_line__c, junctionsForParticularActivationLine);
            }
        }
        return activationLineIdToJunctionsMap;
    }

    public class InputVariables {
        @InvocableVariable
        public Activation_line__c activationLine;
    }

    public class OutputVariables {
        @InvocableVariable
        public List<Account_Phone_Number_Assignment__c> bothJoinedAndNonJoinedAssignments;  // mix of joined and non-joined assignments

        // assignments joined to activation lines under same activation as incoming activation line
        @InvocableVariable
        public List<Account_Phone_Number_Assignment__c> joinedAssignments;  

        // assignments that are NOT joined to activation lines but the assignments belongs to same account as the incoming activation line
        @InvocableVariable
        public List<Account_Phone_Number_Assignment__c> nonJoinedAssignments;
    }

}