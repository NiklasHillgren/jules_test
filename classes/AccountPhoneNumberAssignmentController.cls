public with sharing class AccountPhoneNumberAssignmentController {
    @AuraEnabled(cacheable=true)
    public static List<Account_Phone_Number_Assignment__c> getPhoneNumberAssignments(Id accountId) {
        return [
            SELECT 
                Id, 
                Name, 
                Phone_Number__c, 
                Phone_Number_Reservation_Status__c, 
                //Phone_Number_User__c,
                Account_Phone_Number_Series__r.Name 
            FROM Account_Phone_Number_Assignment__c
            WHERE Account__c = :accountId
            ORDER BY CreatedDate DESC
        ];
    }
}