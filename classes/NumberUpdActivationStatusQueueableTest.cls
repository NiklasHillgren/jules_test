@isTest
private class NumberUpdActivationStatusQueueableTest {

    @isTest
    static void testQueueable_ShouldUpdateStatusToSuccess() {
        // ARRANGE
        // Create prerequisite records
        Account testAccount = TDF_AccountUtils.creatActiveAccountWithCVRAndOwner();
        insert testAccount;

        Case testCase = new Case(AccountId = testAccount.Id, Status = 'New', Origin = 'Phone');
        insert testCase;

        Activation__c activation = new Activation__c(
            Case__c = testCase.Id,
            Phone_Number_Reservation_Status_Txt__c = 'INPROGRESS'
        );
        insert activation;

        // ACT
        Test.startTest();
        // Enqueue the job
        System.enqueueJob(new NumberUpdActivationStatusQueueable(activation.Id, 'SUCCESS'));
        Test.stopTest();

        // ASSERT
        // Re-query the record to get the updated status
        Activation__c updatedActivation = [
            SELECT Phone_Number_Reservation_Status_Txt__c
            FROM Activation__c
            WHERE Id = :activation.Id
        ];

        System.assertEquals('SUCCESS', updatedActivation.Phone_Number_Reservation_Status_Txt__c, 'The status should be updated to SUCCESS.');
    }
}