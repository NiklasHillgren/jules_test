/**
 * The AccountPhoneNumberSeriesSelector class is responsible for selects related to Account Phone Number Series
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær         22/06/2025      Initial version 
 * 
 * @author Kenneth Houkjær
 * @date 22/06/2025
 * 
 */
public virtual class AccountPhoneNumberSeriesSelector {

    private static AccountPhoneNumberSeriesSelector instance = new AccountPhoneNumberSeriesSelector();

    @TestVisible
    public static void setMock(AccountPhoneNumberSeriesSelector mock) {
        instance = mock;
    }

    public static List<Account_Phone_Number_Series__c> getAllAccountPhoneNumberSeries(Account acc) {
        return instance.getAllAccountPhoneNumberSeriesImpl(acc);
    }

    public static List<Account_Phone_Number_Series__c> getAllAccountPhoneNumberSeries(List<Account> accounts) {
        return instance.getAllAccountPhoneNumberSeriesImpl(accounts);
    }

    public virtual List<Account_Phone_Number_Series__c> getAllAccountPhoneNumberSeriesImpl(Account acc) {
        List<Account_Phone_Number_Series__c> series;
        List<String> fieldsToQuery = new List<String>{
            'Id', 'Name', 'Number_Group__c', 'Number_Location__c', 'CVR__c', 'Account__r.CVR__c', 'Number_Pattern__c', 'Product_type__c'
        };
        
        if(acc != null){
            series = new Query('Account_Phone_Number_Series__c').
            selectFields(fieldsToQuery).
            addConditionEq('Account__c', acc.Id).
            run();
        }
        else{
            series = new Query('Account_Phone_Number_Series__c').
            selectFields(fieldsToQuery).
            run();
        }

        return series;
    }

    public virtual List<Account_Phone_Number_Series__c> getAllAccountPhoneNumberSeriesImpl(List<Account> accounts) {
        Set<Id> accountIds = new Set<Id>();
        if (accounts != null) {
            for (Account acc : accounts) {
                accountIds.add(acc.Id);
            }
        }

        if (accountIds.isEmpty()) {
            return new List<Account_Phone_Number_Series__c>();
        }

        List<String> fieldsToQuery = new List<String>{
            'Id', 'Name', 'Number_Group__c', 'Number_Location__c', 'CVR__c', 'Account__r.CVR__c', 'Number_Pattern__c', 'Product_type__c'
        };

        return new Query('Account_Phone_Number_Series__c').
            selectFields(fieldsToQuery).
            addConditionIn('Account__c', accountIds).
            run();
    }
}