/**
 * The AccountPhoneNumberAssignmentSelector class is responsible for selects related to Account Phone Number Assignments
 *  -----------------------------------------------------------------------------
 *  Developer               Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær           22/06/2025      Initial version 
 *  Kenneth Houkjær           13/08/2025      getAssignmentsNotlinkedToActivationLines returning assignment sorted 
 *  Kenneth Houkjær/Kirstine  22/08/2025      cleanup and added methods for getting change/swap/unused assignments
 *  Kenneth Houkjær           22/08/2025      Refactored and moved business logic to service
 * 
 * @author Kenneth Houkjær
 * @date 22/06/2025
 */
public virtual with sharing class AccountPhoneNumberAssignmentSelector {

    private static AccountPhoneNumberAssignmentSelector mock;

    private static List<String> basicFields = new List<String>{
                    'Id',
                    'Name',
                    'Phone_Number__c',
                    'CTN_Number_Status__c',
                    'Account_Phone_Number_Series__c', // Master-Detail Relationship ID
                    'Account_Phone_Number_Series__r.Name', // Name of the parent series
                    'Account_Phone_Number_Series__r.Number_Group__c',
                    'Account_Phone_Number_Series__r.Number_Location__c',
                    'Phone_Number_Reservation_Error__c',
                    'Phone_Number_Reservation_Status__c',
                    'Phone_Number_user__c',
                    'Account__c', // Lookup to Account
                    'Account_Phone_Number_Series__r.Product_Type__c',
                    'Open_Number_Series__c',
                    'account__r.CVR__c'
        };

    @TestVisible
    private static void setMock(AccountPhoneNumberAssignmentSelector mockInstance) {
        mock = mockInstance;
    }

    /**
     * Used in NumberSyncService
     * Used in NumberCaseExecutorHandler
     * @param acc An Account owning the assignments, if null all assignemnts for all 
     *            Accounts are returned.
     * @return List<Account_Phone_Number_Assignment__c> 
     */
    public virtual List<Account_Phone_Number_Assignment__c> getAssignmentsImpl(Account acc){
       
        List<Account_Phone_Number_Assignment__c> assignments;
        List<String> fieldsToQuery = new List<String>{
                    'Id', + 
                    'Name', +
                    'Phone_Number__c', + 
                    'CTN_Number_Status__c', +
                    'Account_Phone_Number_Series__c', + // Master-Detail Relationship ID
                    'Account_Phone_Number_Series__r.Name', + // Name of the parent series
                    'Account_Phone_Number_Series__r.Number_Group__c', +
                    'Account_Phone_Number_Series__r.Number_Location__c', +
                    'Phone_Number_Reservation_Error__c', +
                    'Phone_Number_Reservation_Status__c', +
                    'Phone_Number_user__c', +
                    'Account__c', + // Lookup to Account
                    'Account_Phone_Number_Series__r.Product_Type__c', +
                    'account__r.CVR__c'
        };
        
        if(acc != null){
            assignments = new Query('Account_Phone_Number_Assignment__c').
            selectFields(fieldsToQuery).
            addConditionEq('Account__c', acc.Id).
            run();
        }
        else{
            assignments = new Query('Account_Phone_Number_Assignment__c').
            selectFields(fieldsToQuery).
            run();
        }

        return assignments;
    }

    public static List<Account_Phone_Number_Assignment__c> getAssignments(Account acc){
        if (mock != null) {
            return mock.getAssignmentsImpl(acc);
        }
        return new AccountPhoneNumberAssignmentSelector().getAssignmentsImpl(acc);
    }

    /**
     * Returns a list of account phone number assignments matching the list of assignment Ids.
     * Used in NumberChangeActLIneNUmberAction
     * @param assignmentIds 
     * @return List<Account_Phone_Number_Assignment__c>
     */
    public static List<Account_Phone_Number_Assignment__c> getListOfAssignmentsByAssignmentIds(List<Id> assignmentIds) {
        List<Account_Phone_Number_Assignment__c> assignments;
        
        assignments = new Query('Account_Phone_Number_Assignment__c').
        selectFields(basicFields).
        addConditionIn('Id', assignmentIds).
        run();

        return assignments;
    }

    /**
     * Returns a map of account phone number assignments matching the list of assignment Ids.
     * Used in NumberChangeActLIneNUmberAction
     * @param assignmentIds 
     * @return Map<Id, Account_Phone_Number_Assignment__c>
     */
    public static Map<Id, Account_Phone_Number_Assignment__c> getMapOfAssignmentsByAssignmentIds(List<Id> assignmentIdIds) {
        Map<Id, Account_Phone_Number_Assignment__c> mapAssignmentsByActivationLineId = new Map<Id, Account_Phone_Number_Assignment__c>();
        mapAssignmentsByActivationLineId.putAll(getListOfAssignmentsByAssignmentIds(assignmentIdIds));
        return mapAssignmentsByActivationLineId;
    }

    /**
     * @description Retrieves a list of Activations including their related Case's AccountId.
     * @param activationIds A set of Activation Ids to query for.
     * @return A list of Activation__c records.
     */
    public static List<Activation__c> getActivationsWithCaseAccounts(Set<Id> activationIds) {
        if (activationIds == null || activationIds.isEmpty()) {
            return new List<Activation__c>();
        }
        return (List<Activation__c>) new Query('Activation__c')
            .selectFields(new List<String>{'Id', 'Case__r.AccountId'})
            .addConditionIn('Id', activationIds)
            .run();
    }

    /**
     * @description Retrieves all Account Phone Number Assignments that are currently in use (linked via Activation_Assignment_Junction__c).
     * @return A Map of the Ids of the used Account_Phone_Number_Assignment__c records to the records themselves
     */
    public static Map<Id, Account_Phone_Number_Assignment__c> getInUseAssignments() {
        Query usedAssignmentsQuery = new Query('Activation_Assignment_Junction__c')
            .selectField('Account_Phone_Number_Assignment__c')
            .addConditionNotNull('Account_Phone_Number_Assignment__c');
        
        List<Account_Phone_Number_Assignment__c> assignments = (List<Account_Phone_Number_Assignment__c>) new Query('Account_Phone_Number_Assignment__c')
            .selectFields(new List<String>{'Id', 'Name', 'Phone_Number__c'})
            .addConditionIn('Id', usedAssignmentsQuery)
            .run();
        
        return new Map<Id, Account_Phone_Number_Assignment__c>(assignments);
    }

    /**
     * @description Retrieves unused Account Phone Number Assignments for a given set of account Ids, ordered by series type and name.
     * @param accountIds A set of Account Ids to find assignments for.
     * @return A list of unused Account_Phone_Number_Assignment__c records.
     */
    public static List<Account_Phone_Number_Assignment__c> getUnusedAssignmentsByAccountIds(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return new List<Account_Phone_Number_Assignment__c>();
        }

        Query allUsedAssignmentsQuery = new Query('Activation_Assignment_Junction__c')
            .selectField('Account_Phone_Number_Assignment__c')
            .addConditionNotNull('Account_Phone_Number_Assignment__c');

        Query.Condition openSeriesCondition = Query.doAnd(
            Query.conditionEq('Open_Number_Series__c', true),
            Query.conditionEq('CTN_Number_Status__c', 'AR')
        );

        Query.Condition fixedSeriesCondition = Query.doAnd(
            Query.conditionEq('Open_Number_Series__c', false),
            Query.conditionEq('CTN_Number_Status__c', 'AA')
        );

        Query.Condition unusedCondition = Query.doOr(openSeriesCondition, fixedSeriesCondition);

        return (List<Account_Phone_Number_Assignment__c>) new Query('Account_Phone_Number_Assignment__c')
            .selectFields(basicFields)
            .addConditionIn('Account__c', accountIds)
            .addConditionNotIn('Id', allUsedAssignmentsQuery)
            .addCondition(unusedCondition)
            .orderBy('Account_Phone_Number_Series__r.open_number_series__c', 'ASC') // false (fixed) comes before true (open)
            .orderBy('Name', 'ASC')
            .run();
    }

    /**
     * @description Retrieves Activation Assignment Junction records for a given set of activation Ids.
     * @param activationIds A set of Activation Ids.
     * @return A list of Activation_Assignment_Junction__c records.
     */
    public static List<Activation_Assignment_Junction__c> getJunctionsByActivationIds(Set<Id> activationIds) {
        if (activationIds == null || activationIds.isEmpty()) {
            return new List<Activation_Assignment_Junction__c>();
        }

        Query junctionQuery = new Query('Activation_Assignment_Junction__c')
            .selectFields(new List<String>{'Account_Phone_Number_Assignment__c', 'Activation_Line__r.Activation__c'})
            .addConditionIn('Activation_Line__r.Activation__c', activationIds);

        return (List<Activation_Assignment_Junction__c>) junctionQuery.run();
    }

    /**
     * @description Retrieves Account Phone Number Assignments based on a set of Ids.
     * @param assignmentIds A set of Ids for the assignments to retrieve.
     * @return A map of Id to Account_Phone_Number_Assignment__c.
     */
    public static Map<Id, Account_Phone_Number_Assignment__c> getAssignmentsByIds(Set<Id> assignmentIds) {
        if (assignmentIds == null || assignmentIds.isEmpty()) {
            return new Map<Id, Account_Phone_Number_Assignment__c>();
        }
        return new Map<Id, Account_Phone_Number_Assignment__c>(
            (List<Account_Phone_Number_Assignment__c>) new Query('Account_Phone_Number_Assignment__c')
                .selectFields(basicFields)
                .byId(assignmentIds)
                .run()
        );
    }

    /**
     * @description Retrieves unused Account Phone Number Assignments for a given set of Account Ids.
     * @param accountIds A set of Account Ids.
     * @param assignmentIdsToExclude An optional Set of Ids of assignments to exclude from the results.
     * @return A list of unused Account_Phone_Number_Assignment__c records.
     */
    public static List<Account_Phone_Number_Assignment__c> getUnusedAssignments(Set<Id> accountIds, Set<Id> assignmentIdsToExclude) {
        if (accountIds == null || accountIds.isEmpty()) {
            return new List<Account_Phone_Number_Assignment__c>();
        }

        Query allUsedAssignmentsQuery = new Query('Activation_Assignment_Junction__c')
            .selectField('Account_Phone_Number_Assignment__c')
            .addConditionNotNull('Account_Phone_Number_Assignment__c');

        Query.Condition openSeriesCondition = Query.doAnd(
            Query.conditionEq('Open_Number_Series__c', true),
            Query.conditionEq('CTN_Number_Status__c', 'AR')
        );

        Query.Condition fixedSeriesCondition = Query.doAnd(
            Query.conditionEq('Open_Number_Series__c', false),
            Query.conditionEq('CTN_Number_Status__c', 'AA')
        );

        Query.Condition unusedCondition = Query.doOr(openSeriesCondition, fixedSeriesCondition);

        Query unusedQuery = new Query('Account_Phone_Number_Assignment__c')
            .selectFields(basicFields)
            .addConditionIn('Account__c', accountIds)
            .addConditionNotIn('Id', allUsedAssignmentsQuery)
            .addCondition(unusedCondition)
            .addConditionEq('Account_Phone_Number_Series__r.Product_Type__c', 'GSM')
            .orderBy('Account_Phone_Number_Series__r.open_number_series__c', 'ASC')
            .orderBy('Name'); // for consistent ordering

        if (assignmentIdsToExclude != null && !assignmentIdsToExclude.isEmpty()) {
            unusedQuery.addConditionNotIn('Id', assignmentIdsToExclude);
        }

        return (List<Account_Phone_Number_Assignment__c>) unusedQuery.run();
    }

    /**
     * @description Retrieves specific unused Account Phone Number Assignments for a given account and list of phone numbers.
     * @param accountId The Id of the Account.
     * @param phoneNumbers A list of phone numbers to search for.
     * @return A list of matching, unused Account_Phone_Number_Assignment__c records.
     */
    public static List<Account_Phone_Number_Assignment__c> getSpecificUnusedAssignmentsByNumber(Id accountId, List<String> phoneNumbers) {
        if (accountId == null || phoneNumbers == null || phoneNumbers.isEmpty()) {
            return new List<Account_Phone_Number_Assignment__c>();
        }

        Query allUsedAssignmentsQuery = new Query('Activation_Assignment_Junction__c')
            .selectField('Account_Phone_Number_Assignment__c')
            .addConditionNotNull('Account_Phone_Number_Assignment__c');

        Query.Condition openSeriesCondition = Query.doAnd(
            Query.conditionEq('Open_Number_Series__c', true),
            Query.conditionEq('CTN_Number_Status__c', 'AR')
        );

        Query.Condition fixedSeriesCondition = Query.doAnd(
            Query.conditionEq('Open_Number_Series__c', false),
            Query.conditionEq('CTN_Number_Status__c', 'AA')
        );

        Query.Condition unusedCondition = Query.doOr(openSeriesCondition, fixedSeriesCondition);

        return (List<Account_Phone_Number_Assignment__c>) new Query('Account_Phone_Number_Assignment__c')
            .selectFields(basicFields)
            .addConditionEq('Account__c', accountId)
            .addConditionIn('Phone_Number__c', phoneNumbers)
            .addConditionNotIn('Id', allUsedAssignmentsQuery)
            .addCondition(unusedCondition)
            .addConditionEq('Account_Phone_Number_Series__r.Product_Type__c', 'GSM')
            .orderBy('Account_Phone_Number_Series__r.open_number_series__c', 'ASC')
            .orderBy('Name', 'ASC')
            .run();
    }

      public virtual List<Account_Phone_Number_Assignment__c> getInUseAssignmentsImpl(Account acc) {
        Query usedAssignmentsQuery = new Query('Activation_Assignment_Junction__c')
            .selectField('Account_Phone_Number_Assignment__c')
            .addConditionNotNull('Account_Phone_Number_Assignment__c');

        Query q = new Query('Account_Phone_Number_Assignment__c')
            .selectFields(basicFields)
            .addConditionIn('Id', usedAssignmentsQuery);

        if (acc != null) {
            q.addConditionEq('Account__c', acc.Id);
        }
        
        return q.run();
    }

    public static List<Account_Phone_Number_Assignment__c> getInUseAssignments(Account acc) {
        if (mock != null) {
            return mock.getInUseAssignmentsImpl(acc);
        }
        return new AccountPhoneNumberAssignmentSelector().getInUseAssignmentsImpl(acc);
    }
}