/**
 * @description The AccountPhoneNumberAssignmentService class is responsible for handling business logic
 * related to Account Phone Number Assignments.
 * @see AccountPhoneNumberAssignmentSelector
 * @see AccountPhoneNumberAssignmentController
 * @see AccountPhoneNumberAssignmentCntrTest
 * @see AccountPhoneNumberAssignmentControllerTest
 * @see AccountPhoneNumberAssignmentSelectorTest
 * 
 *  -----------------------------------------------------------------------------
 *  Developer               Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær           22/08/2025      Initial version, logic moved from selector
 * 
 */
public with sharing class AccountPhoneNumberAssignmentService {

    /**
     * @description Retrieves phone number assignments for one or more activations, returning a flattened list.
     * This is a wrapper for getAssignmentsForActivationMapped.
     * @param activationIds A list of Activation Ids to retrieve assignments for.
     * @param amountToRetrieve The number of assignments to retrieve for each activation. If -1, all available assignments are retrieved.
     * @param isSwapNumber If true, only returns assignments already in use on activation lines. If false, returns unused assignments as well.
     * @param assignmentIdToExclude The Id of an assignment to exclude from the results, to prevent re-assigning the same number. Can be null.
     * @param queryType An optional string to trigger different query behaviors. Use 'NotAlreadyInUse' to get only unused assignments.
     * @return A single list containing all retrieved phone number assignments.
     */
    public static List<AssignmentWrapper> getAssignmentsForActivation(List<Id> activationIds, Integer amountToRetrieve, Boolean isSwapNumber, Map<Id, Id> activationToAssignmentToExclude, String queryType) {
        // Call the mapped version to get the detailed results
        Map<Id, List<AssignmentWrapper>> resultMap = getAssignmentsForActivationMapped(activationIds, amountToRetrieve, isSwapNumber, activationToAssignmentToExclude, queryType);
        
        // Flatten the map of lists into a single list
        List<AssignmentWrapper> flatList = new List<AssignmentWrapper>();
        for (List<AssignmentWrapper> assignments : resultMap.values()) {
            flatList.addAll(assignments);
        }
        
        return flatList;
    }

    /**
     * @description Retrieves phone number assignments for one or more activations, returning a map of activation Ids to their assignments.
     * @param activationIds A list of Activation Ids to retrieve assignments for.
     * @param amountToRetrieve The number of assignments to retrieve for each activation. If -1, all available assignments are retrieved.
     * @param isSwapNumber If true, only returns assignments already in use on activation lines (for swapping). If false, returns unused assignments as well (for new assignments).
     * @param activationToAssignmentToExclude A map of activation Ids to assignment Ids to exclude. Can be null.
     * @param queryType An optional string to trigger different query behaviors. Use 'NotAlreadyInUse' to get only unused assignments.
     * @return A map where each key is an Activation Id and the value is a list of its retrieved phone number assignments.
     */
    public static Map<Id, List<AssignmentWrapper>> getAssignmentsForActivationMapped(List<Id> activationIds, Integer amountToRetrieve, Boolean isSwapNumber, Map<Id, Id> activationToAssignmentToExclude, String queryType) {
        Map<Id, List<AssignmentWrapper>> resultMap = new Map<Id, List<AssignmentWrapper>>();
        if (activationIds == null || activationIds.isEmpty()) {
            return resultMap;
        }

        // Initialize result map with empty lists for each activation
        for(Id activationId : activationIds) {
            resultMap.put(activationId, new List<AssignmentWrapper>());
        }

        if(queryType == 'NotAlreadyInUse') {
            // Special mode: Get only unused assignments, ordered by series type
            
            // Find all accounts related to the activations
            List<Activation__c> activations = AccountPhoneNumberAssignmentSelector.getActivationsWithCaseAccounts(new Set<Id>(activationIds));

            Set<Id> accountIds = new Set<Id>();
            Map<Id, Id> activationToAccountIdMap = new Map<Id, Id>();
            for(Activation__c act : activations) {
                if(act.Case__r.AccountId != null) {
                    accountIds.add(act.Case__r.AccountId);
                    activationToAccountIdMap.put(act.Id, act.Case__r.AccountId);
                }
            }

            // Find all unused assignments for the relevant accounts, ordered by fixed then open series
            List<Account_Phone_Number_Assignment__c> unusedAssignments = AccountPhoneNumberAssignmentSelector.getUnusedAssignmentsByAccountIds(accountIds);

            // Group unused assignments by account
            Map<Id, List<Account_Phone_Number_Assignment__c>> unusedAssignmentsByAccount = new Map<Id, List<Account_Phone_Number_Assignment__c>>();
            for(Account_Phone_Number_Assignment__c unused : unusedAssignments) {
                if(!unusedAssignmentsByAccount.containsKey(unused.Account__c)) {
                    unusedAssignmentsByAccount.put(unused.Account__c, new List<Account_Phone_Number_Assignment__c>());
                }
                unusedAssignmentsByAccount.get(unused.Account__c).add(unused);
            }

            // Distribute the unused assignments
            Map<Id, Integer> unusedIndexByAccount = new Map<Id, Integer>();
            for(Id activationId : activationIds) {
                Id accountId = activationToAccountIdMap.get(activationId);
                if(accountId != null && unusedAssignmentsByAccount.containsKey(accountId)) {
                    List<Account_Phone_Number_Assignment__c> availableUnused = unusedAssignmentsByAccount.get(accountId);
                    Integer startIndex = unusedIndexByAccount.get(accountId) == null ? 0 : unusedIndexByAccount.get(accountId);
                    Integer addedCount = 0;

                    for(Integer i = startIndex; i < availableUnused.size(); i++) {
                        if(amountToRetrieve != -1 && addedCount >= amountToRetrieve) {
                            break; 
                        }
                        resultMap.get(activationId).add(new AssignmentWrapper(availableUnused[i], false));
                        addedCount++;
                    }
                    unusedIndexByAccount.put(accountId, startIndex + addedCount);
                }
            }
            return resultMap;
        }

        // Default logic
        // Step 1: Get all "in-use" assignments for the given activations
        Map<Id, List<Account_Phone_Number_Assignment__c>> inUseAssignmentsByActivation = new Map<Id, List<Account_Phone_Number_Assignment__c>>();
        List<Id> inUseAssignmentIds = new List<Id>();

        List<Activation_Assignment_Junction__c> junctions = AccountPhoneNumberAssignmentSelector.getJunctionsByActivationIds(new Set<Id>(activationIds));

        for(Activation_Assignment_Junction__c junction : junctions) {
            Id activationId = junction.Activation_Line__r.Activation__c;
            Id assignmentId = junction.Account_Phone_Number_Assignment__c;

            // Exclude assignments based on the map
            if (activationToAssignmentToExclude != null && activationToAssignmentToExclude.containsKey(activationId) && assignmentId == activationToAssignmentToExclude.get(activationId)) {
                continue;
            }

            if(!inUseAssignmentsByActivation.containsKey(activationId)) {
                inUseAssignmentsByActivation.put(activationId, new List<Account_Phone_Number_Assignment__c>());
            }
            // We will query the actual assignment records later
            inUseAssignmentsByActivation.get(activationId).add(new Account_Phone_Number_Assignment__c(Id = assignmentId));
            inUseAssignmentIds.add(assignmentId);
        }

        // Query all in-use assignment records in one go
        Map<Id, Account_Phone_Number_Assignment__c> inUseAssignmentMap = AccountPhoneNumberAssignmentSelector.getAssignmentsByIds(new Set<Id>(inUseAssignmentIds));

        // Populate the result map with "in-use" assignments, respecting the limit
        for(Id activationId : activationIds) {
            List<AssignmentWrapper> wrappers = new List<AssignmentWrapper>();
            if(inUseAssignmentsByActivation.containsKey(activationId)) {
                Integer count = 0;
                for(Account_Phone_Number_Assignment__c tempAssignment : inUseAssignmentsByActivation.get(activationId)) {
                    if(amountToRetrieve == -1 || count < amountToRetrieve) {
                        Account_Phone_Number_Assignment__c fullAssignment = inUseAssignmentMap.get(tempAssignment.Id);
                        if(fullAssignment != null){
                            wrappers.add(new AssignmentWrapper(fullAssignment, true));
                            count++;
                        }
                    } else {
                        break;
                    }
                }
            }
            resultMap.get(activationId).addAll(wrappers);
        }

        // If isSwapNumber is true, we are done.
        if(isSwapNumber) {
            return resultMap;
        }

        // Step 2: Get all "unused" assignments for the relevant accounts
        List<Activation__c> activations = AccountPhoneNumberAssignmentSelector.getActivationsWithCaseAccounts(new Set<Id>(activationIds));

        Set<Id> accountIds = new Set<Id>();
        Map<Id, Id> activationToAccountIdMap = new Map<Id, Id>();
        for(Activation__c act : activations) {
            if(act.Case__r.AccountId != null) {
                accountIds.add(act.Case__r.AccountId);
                activationToAccountIdMap.put(act.Id, act.Case__r.AccountId);
            }
        }
        
        // Now find all assignments on the relevant accounts that are NOT used
        Set<Id> assignmentsToExclude = new Set<Id>();
        if (activationToAssignmentToExclude != null) {
            assignmentsToExclude.addAll(activationToAssignmentToExclude.values());
        }
        assignmentsToExclude.addAll(inUseAssignmentIds);
        List<Account_Phone_Number_Assignment__c> unusedAssignments = AccountPhoneNumberAssignmentSelector.getUnusedAssignments(accountIds, assignmentsToExclude);

        // Step 3: Distribute unused assignments to activations that still need them
        
        // Group unused assignments by account
        Map<Id, List<Account_Phone_Number_Assignment__c>> unusedAssignmentsByAccount = new Map<Id, List<Account_Phone_Number_Assignment__c>>();
        for(Account_Phone_Number_Assignment__c unused : unusedAssignments) {
            if(!unusedAssignmentsByAccount.containsKey(unused.Account__c)) {
                unusedAssignmentsByAccount.put(unused.Account__c, new List<Account_Phone_Number_Assignment__c>());
            }
            unusedAssignmentsByAccount.get(unused.Account__c).add(unused);
        }

        // Keep track of the index of the next unused assignment for each account
        Map<Id, Integer> unusedIndexByAccount = new Map<Id, Integer>();

        for(Id activationId : activationIds) {
            Integer amountStillNeeded = (amountToRetrieve == -1) ? -1 : amountToRetrieve - resultMap.get(activationId).size();
            
            if(amountToRetrieve == -1 || amountStillNeeded > 0) {
                Id accountId = activationToAccountIdMap.get(activationId);
                if(accountId != null && unusedAssignmentsByAccount.containsKey(accountId)) {
                    
                    List<Account_Phone_Number_Assignment__c> availableUnused = unusedAssignmentsByAccount.get(accountId);
                    Integer startIndex = unusedIndexByAccount.get(accountId) == null ? 0 : unusedIndexByAccount.get(accountId);
                    Integer addedCount = 0;

                    for(Integer i = startIndex; i < availableUnused.size(); i++) {
                        resultMap.get(activationId).add(new AssignmentWrapper(availableUnused[i], false));
                        addedCount++;
                        if(amountToRetrieve != -1 && addedCount >= amountStillNeeded) {
                            break; 
                        }
                    }
                    // Update the index for the next activation on the same account
                    unusedIndexByAccount.put(accountId, startIndex + addedCount);
                }
            }
        }

        return resultMap;
    }

     public class AssignmentWrapper {
        @AuraEnabled
        public Account_Phone_Number_Assignment__c assignment { get; set; }
        @AuraEnabled
        public Boolean isInUse { get; set; }

        public AssignmentWrapper(Account_Phone_Number_Assignment__c assignment, Boolean isInUse) {
            this.assignment = assignment;
            this.isInUse = isInUse;
        }
    }

    /**
     * @description Retrieves a specified number of unused phone number assignments for a single activation.
     * @param activationId The Id of the Activation to retrieve assignments for.
     * @param amountToRetrieve The number of unused assignments to retrieve.
     * @return A list of Account_Phone_Number_Assignment__c records.
     */
    public static List<Account_Phone_Number_Assignment__c> getUnusedAssignmentsForActivation(Id activationId, Integer amountToRetrieve) {
        if (activationId == null || amountToRetrieve == null || amountToRetrieve <= 0) {
            return new List<Account_Phone_Number_Assignment__c>();
        }

        List<AssignmentWrapper> wrapperList = getAssignmentsForActivation(
            new List<Id>{activationId},
            amountToRetrieve,
            false, // isSwapNumber = false, we want unused numbers
            new Map<Id, Id>(),  // activationToAssignmentToExclude
            'NotAlreadyInUse' // queryType = 'NotAlreadyInUse'
        );

        List<Account_Phone_Number_Assignment__c> assignments = new List<Account_Phone_Number_Assignment__c>();
        for (AssignmentWrapper wrapper : wrapperList) {
            assignments.add(wrapper.assignment);
        }
        return assignments;
    }

    /**
     * @description Retrieves a specified number of unused phone number assignments for a single activation,
     *              prioritizing a given list of requested numbers.
     * @param activationId The Id of the Activation to retrieve assignments for.
     * @param amountToRetrieve The total number of unused assignments to retrieve.
     * @param requestedNumbers A list of specific phone numbers to prioritize.
     * @return A list of Account_Phone_Number_Assignment__c records.
     */
    public static Map<String, Account_Phone_Number_Assignment__c> getUnusedAssignmentsForActivation(Id activationId, Integer amountToRetrieve, List<String> requestedNumbers) {
        Map<String, Account_Phone_Number_Assignment__c> resultMap = new Map<String, Account_Phone_Number_Assignment__c>();
        
        if (activationId == null || amountToRetrieve == null || amountToRetrieve <= 0) {
            return resultMap;
        }

        // 1. Get the AccountId from the Activation
        List<Activation__c> activations = AccountPhoneNumberAssignmentSelector.getActivationsWithCaseAccounts(new Set<Id>{activationId});
        if (activations.isEmpty() || activations[0].Case__r.AccountId == null) {
            return resultMap;
        }
        Id accountId = activations[0].Case__r.AccountId;

        // 2. Find specific requested assignments that are unused and have SUCCESS status
        if (requestedNumbers != null && !requestedNumbers.isEmpty()) {
            List<Account_Phone_Number_Assignment__c> specificAssignments = AccountPhoneNumberAssignmentSelector.getSpecificUnusedAssignmentsByNumber(accountId, requestedNumbers);
            for(Account_Phone_Number_Assignment__c assignment : specificAssignments){
                if(!resultMap.containsKey(assignment.Phone_Number__c)){
                    resultMap.put(assignment.Phone_Number__c, assignment);
                }
            }
        }

        // 3. Find remaining unused assignments if needed
        Integer remainingAmount = amountToRetrieve - resultMap.size();
        if (remainingAmount <= 0) {
            return resultMap;
        }

        Set<Id> idsToExclude = new Set<Id>();
        for(Account_Phone_Number_Assignment__c a : resultMap.values()) {
            idsToExclude.add(a.Id);
        }
        
        // Get other unused assignments, excluding the ones we already found
        List<Account_Phone_Number_Assignment__c> otherUnusedAssignments = AccountPhoneNumberAssignmentSelector.getUnusedAssignments(new Set<Id>{accountId}, idsToExclude);

        // 4. Add remaining assignments to the map
        for(Account_Phone_Number_Assignment__c other : otherUnusedAssignments) {
            if(resultMap.size() < amountToRetrieve) {
                if(!resultMap.containsKey(other.Phone_Number__c)){
                    resultMap.put(other.Phone_Number__c, other);
                }
            } else {
                break;
            }
        }

        return resultMap;
    }
}