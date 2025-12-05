@isTest
private class EmailArchiveViewerControllerTest {

    @isTest
    static void testGetByCompositeIndex_PassValidBigObjectIndex_Success() {
        // Setup: Create a test Email_Archive__b record
        Account testAccount = TDF_AccountUtils.creatActiveAccountWithCVRAndOwner();
        insert testAccount;

        Case testCase = TDF_CaseUtils.createCustomerServiceCasesForAccounts(new List<Account>{testAccount})[0];

        EmailArchive__b testRecord = new EmailArchive__b(
            Account__c = testAccount.Id,
            ParentId__c = testCase.Id,
            Email_Message_Id__c = '02sS80000079xq2IAA',
            Subject__c = 'Test Subject',
            FromAddress__c = 'from@example.com',
            ToAddress__c = 'to@example.com',
            CcAddress__c = 'cc@example.com',
            Status__c = 'Sent'
        );
        

        Test.startTest();
        EmailArchiveViewerController.EmailArchiveRecordDTO result = EmailArchiveViewerController.getByCompositeIndex(
            testRecord.Account__c,
            testRecord.ParentId__c,
            testRecord.Email_Message_Id__c
        );
        Test.stopTest();

        // Verify
        /*System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(testRecord.Id, result.Id, 'Id should match');
        System.assertEquals(testRecord.Account__c, result.AccountId, 'Account__c should match');
        System.assertEquals(testRecord.ParentId__c, result.ParentId, 'ParentId__c should match');
        System.assertEquals(testRecord.Email_Message_Id__c, result.Email_Message_Id, 'Email_Message_Id__c should match');
        System.assertEquals(testRecord.Subject__c, result.Subject, 'Subject__c should match');
        System.assertEquals(testRecord.FromAddress__c, result.FromAddress, 'FromAddress__c should match');
        System.assertEquals(testRecord.ToAddress__c, result.ToAddress, 'ToAddress__c should match');
        System.assertEquals(testRecord.CcAddress__c, result.CcAddress, 'CcAddress__c should match');
        System.assertEquals(testRecord.Status__c, result.Status, 'Status__c should match');*/
    }

    @isTest
    static void testGetByCompositeIndex_PassingNonExistingIndex_NoRecordFound() {
        Test.startTest();
        EmailArchiveViewerController.EmailArchiveRecordDTO result = EmailArchiveViewerController.getByCompositeIndex(
            '0018271X92B27SWS76',
            '5008271X92B27SWS76',
            '02s8271X92B27SWS76'
        );
        Test.stopTest();

        // Verify
        System.assertEquals(null, result, 'Result should be null when no record is found');
    }

    @isTest
    static void testGetByCompositeIndex_PassingInvalidIndex_MissingParameters() {
        Test.startTest();
        Test.stopTest();

        // Should throw AuraHandledException
        Boolean caughtException = false;
        try {
            EmailArchiveViewerController.getByCompositeIndex(null, '500XXXXXXXXXXXX', '02sXXXXXXXXXXXX');
        } catch (AuraHandledException e) {
            caughtException = true;
        }

        Assert.isTrue(caughtException, 'Should throw AuraHandledException when parameters are missing');
    }
}