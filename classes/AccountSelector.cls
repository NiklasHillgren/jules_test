/**
 * Selector class for Account
 */
public with sharing class AccountSelector {
    public Account getAccountByCaseId(String caseId) {
        Query rhs = new Query(Case.SObjectType)
            .selectFields(Case.Fields.AccountId)
            .addConditionEq(Case.Fields.Id, caseId);

        List<Account> accounts = new Query(Account.SObjectType)
            .selectFields(
                new List<Schema.SObjectField>{
                    Account.Fields.Id,
                    Account.Fields.Name,
                    Account.Fields.BillingPostalCode,
                    Account.Fields.Billing_Street_Name__c,
                    Account.Fields.Billing_Street_Number__c,
                    Account.Fields.Billing_Floor_Number__c,
                    Account.Fields.Billing_Door_Number__c,
                    Account.Fields.Billing_Street_Number_Suffix__c,
                    Account.Fields.BillingCity,
                    Account.Fields.BillingCountry,
                    Account.Fields.CVR__c,
                    Account.Fields.OwnerId,
                    Account.Fields.Phone,
                    Account.Fields.Sales_Play_Vesting_Reason__c
                })
            .addConditionIn('Id', rhs)
            .fetchAll();

        if (!accounts.isEmpty()) {
            return accounts[0];
        }

        return null;
    }


    public static Account getByCVR(String cvr) {
        return (Account) new Query(Account.SObjectType)
            .selectFields(
                new List<Schema.SObjectField>{
                    Account.Fields.Id,
                    Account.Fields.Name,
                    Account.Fields.BillingPostalCode,
                    Account.Fields.Billing_Street_Name__c,
                    Account.Fields.Billing_Street_Number__c,
                    Account.Fields.Billing_Floor_Number__c,
                    Account.Fields.Billing_Door_Number__c,
                    Account.Fields.Billing_Street_Number_Suffix__c,
                    Account.Fields.BillingCity,
                    Account.Fields.BillingCountry,
                    Account.Fields.CVR__c,
                    Account.Fields.Phone,
                    Account.Fields.OwnerId,
                    Account.Fields.Sales_Play_Vesting_Reason__c
                }
            )
            .addConditionEq(Account.Fields.CVR__c, cvr)
            .setLimit(1)
            .fetch();
    }

    public static List<Account> getAccountsByIds(List<Id> accountIds) {
        return new Query(Account.SObjectType)
            .selectFields(new List<Schema.SObjectField>{ Account.Fields.Id, Account.Fields.CVR__c })
            .addConditionIn(Account.Fields.Id, accountIds)
            .fetchAll();
    }

    @AuraEnabled(cacheable=true)
    public static Account getAccountByCaseId(String caseId) {
        Query rhs = new Query(Case.SObjectType)
            .selectFields(Case.Fields.AccountId)
            .addConditionEq(Case.Fields.Id, caseId);

        List<Account> accounts = new Query(Account.SObjectType)
            .selectFields(
                new List<Schema.SObjectField>{
                    Account.Fields.Id,
                    Account.Fields.Name,
                    Account.Fields.BillingPostalCode,
                    Account.Fields.Billing_Street_Name__c,
                    Account.Fields.Billing_Street_Number__c,
                    Account.Fields.Billing_Floor_Number__c,
                    Account.Fields.Billing_Door_Number__c,
                    Account.Fields.Billing_Street_Number_Suffix__c,
                    Account.Fields.BillingCity,
                    Account.Fields.BillingCountry,
                    Account.Fields.CVR__c,
                    Account.Fields.OwnerId,
                    Account.Fields.Phone,
                    Account.Fields.Sales_Play_Vesting_Reason__c
                })
            .addConditionIn('Id', rhs)
            .fetchAll();

        if (!accounts.isEmpty()) {
            return accounts[0];
        }

        return null;
    }

}