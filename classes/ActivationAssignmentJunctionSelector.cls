/**
 * @description This class is a selector for the Activation_Assignment_Junction__c object.
 * It provides methods to query for junction records based on different criteria.
 *  -----------------------------------------------------------------------------
 *  Developer               Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær         2025-08-19      Initial version.
 *  Kirstine Nielsen        2025-08-22      Add getActivationAssignmentJunctionsByAcativationLineIds(Set<Id> activationLineIds)
 *
 * @author Kenneth Houkjær
 * @date 2025-08-19
 */
public with sharing class ActivationAssignmentJunctionSelector {

    /**
     * @description Retrieves a map of activation assignment junctions based on assignment and activation line Ids.
     * The map is keyed by a concatenation of the assignment Id and the activation line Id.
     * @param fromAssignmentIds A set of Account_Phone_Number_Assignment__c Ids.
     * @param activationLineIds A set of Activation_line__c Ids.
     * @return A map of Activation_Assignment_Junction__c records.
     */
    public static Map<String, Activation_Assignment_Junction__c> getJunctionsMap(Set<Id> fromAssignmentIds, Set<Id> activationLineIds) {
        if (fromAssignmentIds == null || fromAssignmentIds.isEmpty() || activationLineIds == null || activationLineIds.isEmpty()) {
            return new Map<String, Activation_Assignment_Junction__c>();
        }

        List<String> fieldsToQuery = new List<String>{
            'Id', 'Account_Phone_Number_Assignment__c', 'Activation_line__c'
        };

        List<Activation_Assignment_Junction__c> junctions = new Query('Activation_Assignment_Junction__c')
            .selectFields(fieldsToQuery)
            .addConditionIn('Account_Phone_Number_Assignment__c', fromAssignmentIds)
            .addConditionIn('Activation_line__c', activationLineIds)
            .run();

        Map<String, Activation_Assignment_Junction__c> junctionMap = new Map<String, Activation_Assignment_Junction__c>();
        for (Activation_Assignment_Junction__c j : junctions) {
            junctionMap.put(j.Account_Phone_Number_Assignment__c + '-' + j.Activation_line__c, j);
        }
        return junctionMap;
    }

    /**
     * @description Retrieves a list of activation assignment junctions that matches the Activation Line Ids.
     * The matching is done via: junction -> activation line.
     * @param activationLineIds A set of Activation Line Ids to match against.
     * @return A list of Activation_Assignment_Junction__c records.
     */
    public static List<Activation_Assignment_Junction__c> getActivationAssignmentJunctionsByAcativationLineIds(Set<Id> activationLineIds) {   
        List<Activation_Assignment_Junction__c> junctions;
        List<String> fieldsToQuery = new List<String>{
            'Id', 'Name', 'Account_Phone_Number_Assignment__c', 'Activation_line__c', +
            'Activation_line__r.Activation__c', +
            'Activation_line__r.Activation__r.Case_Account_ID__c', +
            'Phone_Number_User__c'
        };
        
        Query query = new Query('Activation_Assignment_Junction__c')
            .selectFields(fieldsToQuery)
            .addConditionIn('Activation_line__c', activationLineIds);
        
        junctions = query.run();

        return junctions;
    }

     /**
     * @description Retrieves a list of activation assignment junctions based on assignment Ids.
     * @param assignmentIds A set of Account_Phone_Number_Assignment__c Ids.
     * @return A list of Activation_Assignment_Junction__c records.
     */
    public static List<Activation_Assignment_Junction__c> getByAssignmentIds(Set<Id> assignmentIds) {
        if (assignmentIds == null || assignmentIds.isEmpty()) {
            return new List<Activation_Assignment_Junction__c>();
        }

        List<String> fieldsToQuery = new List<String>{
            'Id', 'Account_Phone_Number_Assignment__c'
        };

        List<Activation_Assignment_Junction__c> junctions = new Query('Activation_Assignment_Junction__c')
            .selectFields(fieldsToQuery)
            .addConditionIn('Account_Phone_Number_Assignment__c', assignmentIds)
            .run();

        return junctions;
    }
}