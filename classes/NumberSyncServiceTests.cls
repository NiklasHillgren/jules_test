/**
 * The NumberSyncServiceTests is responsible for testing the synchronizing of Fokus phone numbers with Salesforce.
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær         27/07/2025      Initial version
 *
 * @author Kenneth Houkjær
 * @date 27/07/2025
 */
@isTest
private class NumberSyncServiceTests {

    /**
     * @description Helper to create Account_Phone_Number_Series__c for testing.
     * @param numberGroup The number group.
     * @param numberLocation The number location.
     * @param cvr The CVR number.
     * @param pattern The number pattern.
     * @param productType The product type.
     * @return An Account_Phone_Number_Series__c record.
     */
    private static Account_Phone_Number_Series__c createTestSeries(
        String numberGroup, String numberLocation, String cvr, String pattern, String productType
    ) {
        //'SAL', 'BRZ', '12345678','', 'GSM'
        // Name is an Auto Number field, so we don't set it.
        Account_Phone_Number_Series__c series = new Account_Phone_Number_Series__c(
            Number_Group__c = numberGroup, //P, SAL
            Number_Location__c = numberLocation, //BRZ, BUS, EKC, SAL
            CVR__c = cvr, //12345678
            Number_Pattern__c = pattern, //
            Product_type__c = productType //GSM
        );
        return series;
        // Actual insert will be done in test setup if needed for getLocalAssignments,
        // but primarily for mocking getAllAccountPhoneNumberSeries.
        
    }

    /**
     * @description Updated Helper to create Account_Phone_Number_Assignment__c records for testing.
     * @param phoneNumber The phone number.
     * @param ctnStatus The CTN status.
     * @param seriesId The ID of the parent series.
     * @param accountId The ID of the account.
     * @return An Account_Phone_Number_Assignment__c record.
     */
    private static Account_Phone_Number_Assignment__c createTestAssignment(
        String phoneNumber, String ctnStatus, Id seriesId, Id accountId // Added accountId
    ) {
        // Name is an Auto Number field.
        Account_Phone_Number_Assignment__c assignment = new Account_Phone_Number_Assignment__c(
            Phone_Number__c = phoneNumber,
            CTN_Number_Status__c = ctnStatus,
            Account_Phone_Number_Series__c = seriesId, // Master-Detail
            Account__c = accountId // Optional Account lookup
            // Add other necessary fields as per object definition if needed for tests
        );
        return assignment;
    }

    /**
     * @description Helper to create NumberClient.NumberData for mock remote responses.
     * @param phoneNumber The phone number.
     * @param status The number status.
     * @param nGroup The number group.
     * @param location The number location.
     * @return A NumberClientResponseDTO.NumberData object.
     */
    private static NumberClientResponseDTO.NumberData createRemoteData(String phoneNumber, String status, String nGroup, String location) {
        NumberClientResponseDTO.NumberData data = new NumberClientResponseDTO.NumberData();
        data.id = phoneNumber;
        data.phoneNumber = phoneNumber;
        data.numberStatus = status; // This maps to CTN_Number_Status__c
        data.numberGroup = nGroup;   // This is informational, actual series link is via parentSeriesId
        data.numberLocation = location;
        data.productType = new List<String>{'GSM'};
        return data;
    }

    /**
     * @description Helper to create mock OpenPhoneNumberSeries__mdt records for testing.
     * @param numberGroup The number group.
     * @param numberLocation The number location.
     * @return An OpenPhoneNumberSeries__mdt record.
     */
    private static OpenPhoneNumberSeries__mdt createMockOpenSeriesMetadata(String numberGroup, String numberLocation) {
        OpenPhoneNumberSeries__mdt seriesMeta = new OpenPhoneNumberSeries__mdt(
            // Assuming API names on CMD are NumberGroup__c and NumberLocation__c
            Number_Group__c = numberGroup,
            Number_Location__c = numberLocation
        );
        return seriesMeta;
    }

    /**
     * @description Class used for mocking NumberSyncService.
     */
    @TestVisible
    private class MockNumberSyncService extends NumberSyncService {
        private Map<String, List<NumberClientResponseDTO.NumberData>> mockRemoteDataBySeriesAndStatus;
        public List<String> calledParamsKeys = new List<String>();

        // Data for mocking the new virtual methods
        private List<OpenPhoneNumberSeries__mdt> mockOpenSeriesMetadata;

        MockNumberSyncService(
            Map<String, List<NumberClientResponseDTO.NumberData>> mockRemoteData,
            List<OpenPhoneNumberSeries__mdt> openSeriesMeta
        ) {
            super();
            this.mockRemoteDataBySeriesAndStatus = mockRemoteData;
            this.mockOpenSeriesMetadata = openSeriesMeta;
        }

        /**
         * @description Overrides the callGetNumberDetails method to return mock data.
         * @param params The parameters for the getNumberDetails call.
         * @return The mock response from the getNumberDetails call.
         */
        protected override NumberClientResponseDTO.NumberDetails callGetNumberDetails(NumberClientRequestDTO.NumberDetails params) {
            NumberClientResponseDTO.NumberDetails details = new NumberClientResponseDTO.NumberDetails();
            details.data = new List<NumberClientResponseDTO.NumberData>();
            // Key for mockRemoteDataBySeriesAndStatus might need to consider location if group alone is not unique
            String key = params.numberGroup + '_' + params.numberLocation + '_' + params.numberStatus;
            
            calledParamsKeys.add(key);

            if (mockRemoteDataBySeriesAndStatus != null && mockRemoteDataBySeriesAndStatus.containsKey(key)) {
                 details.data.addAll(mockRemoteDataBySeriesAndStatus.get(key));
            }
            return details;
        }

        /**
         * @description Overrides the getOpenPhoneNumberSeriesMetadata method to return mock data.
         * @return A list of mock OpenPhoneNumberSeries__mdt records.
         */
        protected override List<OpenPhoneNumberSeries__mdt> getOpenPhoneNumberSeriesMetadata() {
            return this.mockOpenSeriesMetadata != null ? this.mockOpenSeriesMetadata : super.getOpenPhoneNumberSeriesMetadata();
        }
    }

    private class AccountPhoneNumberSeriesSelectorMock extends AccountPhoneNumberSeriesSelector {
        private List<Account_Phone_Number_Series__c> mockSeriesToReturn;

        public AccountPhoneNumberSeriesSelectorMock(List<Account_Phone_Number_Series__c> series) {
            this.mockSeriesToReturn = series;
        }

        public override List<Account_Phone_Number_Series__c> getAllAccountPhoneNumberSeriesImpl(List<Account> accounts) {
            return this.mockSeriesToReturn;
        }

        public override List<Account_Phone_Number_Series__c> getAllAccountPhoneNumberSeriesImpl(Account acc) {
            return this.mockSeriesToReturn;
        }
    }

    /**
     * @description Tests the creation of new assignments.
     */
    @isTest
    static void testCreateNewAssignments() {

        //ARRANGE
        Account testAccount = createTestAccount();
        insert testAccount;
        // 1. Setup Mock Series Data
        List<Account_Phone_Number_Series__c> testSeriesList = new List<Account_Phone_Number_Series__c>{
            createTestSeries('SAL', 'BRZ', '12345678','', 'GSM')
        };
        testSeriesList[0].Account__c = testAccount.Id;
        insert testSeriesList;

        // Re-query the series to ensure the Account relationship is populated for the mock selector
        List<Account_Phone_Number_Series__c> seriesForMock = [
            SELECT Id, Name, Number_Group__c, Number_Location__c, CVR__c, Number_Pattern__c, Product_type__c, Account__c, Account__r.CVR__c
            FROM Account_Phone_Number_Series__c
            WHERE Id IN :testSeriesList
        ];

        // 2. Setup Mock Open Series (empty for this test, assuming SAL_BRZ is not open)
        List<OpenPhoneNumberSeries__mdt> testOpenSeriesList = new List<OpenPhoneNumberSeries__mdt>();

        // 3. No Local Assignments for this test

        // 4. Setup Mock Remote Payload (keyed by Group_Location_Status)
        Map<String, List<NumberClientResponseDTO.NumberData>> mockRemotePayload =
            new Map<String, List<NumberClientResponseDTO.NumberData>>{
                'SAL_BRZ_AA' => new List<NumberClientResponseDTO.NumberData>{
                    createRemoteData('20202020', 'AA', 'SAL', 'BRZ'), // numberGroup in remoteData is informational
                    createRemoteData('20304050', 'AA', 'SAL', 'BRZ')
                }
                // Ensure other statuses for GRP1_LOCA return empty if queried
                ,'SAL_BRZ_AR' => new List<NumberClientResponseDTO.NumberData>()
                ,'SAL_BRZ_AI' => new List<NumberClientResponseDTO.NumberData>()
                ,'SAL_BRZ_AS' => new List<NumberClientResponseDTO.NumberData>()
            };

        //ACT    
        AccountPhoneNumberSeriesSelector.setMock(new AccountPhoneNumberSeriesSelectorMock(seriesForMock));
        Test.startTest();
        MockNumberSyncService service = new MockNumberSyncService(
            mockRemotePayload, testOpenSeriesList
        );
        service.synchronizeAllAssignments();
        Test.stopTest();

        List<Account_Phone_Number_Assignment__c> created = [
            SELECT Phone_Number__c, CTN_Number_Status__c, Account_Phone_Number_Series__c
            FROM Account_Phone_Number_Assignment__c
        ];


        //ASSERT
        System.assertEquals(2, created.size(), 'Should create 2 new assignments.');
        Set<String> createdPhones = new Set<String>();
        for(Account_Phone_Number_Assignment__c asn : created) {
            createdPhones.add(asn.Phone_Number__c);
            System.assertEquals(seriesForMock[0].Id, asn.Account_Phone_Number_Series__c, 'Series should match.');
            System.assertEquals('AA', asn.CTN_Number_Status__c, 'Status should be AA.');
        }
        System.assert(createdPhones.contains('20202020'), '20202020 should be created.');
        System.assert(createdPhones.contains('20304050'), '20304050 should be created.');
    }

    /**
     * @description Tests the update of existing assignments.
     */
    @isTest
    static void testUpdateExistingAssignments() {

        //ARRANGE
        Account testAccount = createTestAccount();
        insert testAccount;
        // 1. Setup Series (insert to get Id)
        List<Account_Phone_Number_Series__c> testSeriesList = new List<Account_Phone_Number_Series__c>{
            createTestSeries('SAL', 'BRZ', '12345678','', 'GSM')
        };
        testSeriesList[0].Account__c = testAccount.Id;
        insert testSeriesList;

        // Re-query the series to ensure the Account relationship is populated for the mock selector
        List<Account_Phone_Number_Series__c> seriesForMock = [
            SELECT Id, Name, Number_Group__c, Number_Location__c, CVR__c, Number_Pattern__c, Product_type__c, Account__c, Account__r.CVR__c
            FROM Account_Phone_Number_Series__c
            WHERE Id IN :testSeriesList
        ];
        Id series1Id = seriesForMock[0].Id;

        // 2. Setup Open Series CMD (empty for this test)
        List<OpenPhoneNumberSeries__mdt> testOpenSeriesList = new List<OpenPhoneNumberSeries__mdt>();

        // 3. Setup Local Assignments
        List<Account_Phone_Number_Assignment__c> localAssignments = new List<Account_Phone_Number_Assignment__c>{
            createTestAssignment('10101010', 'AA', series1Id, null)
        };
        insert localAssignments;

        // 4. Setup Mock Remote Payload - 10101010 status changes from AA to AR
        Map<String, List<NumberClientResponseDTO.NumberData>> mockRemotePayload =
            new Map<String, List<NumberClientResponseDTO.NumberData>>{
                'SAL_BRZ_AA' => new List<NumberClientResponseDTO.NumberData>{ // Remote data might still come with original status
                    createRemoteData('10101010', 'AR', 'SAL', 'BRZ')
                },
                'SAL_BRZ_AR' => new List<NumberClientResponseDTO.NumberData>(), // Ensure empty for other statuses
                'SAL_BRZ_AI' => new List<NumberClientResponseDTO.NumberData>(),
                'SAL_BRZ_AS' => new List<NumberClientResponseDTO.NumberData>()
            };
        // It's also possible the remote system now reports 10101010 under AR status directly.
        // Let's assume the service queries all statuses for non-open series.
        // If 10101010 is now 'AR', it might be returned when 'AR' status is queried.
        // For simplicity, let's assume it's found when SAL_BRZ_AA is queried, but data says AR.
        // The SUT's `compareAndPrepareDML` uses `remoteData.numberStatus` for comparison.

        //ACT
        AccountPhoneNumberSeriesSelector.setMock(new AccountPhoneNumberSeriesSelectorMock(seriesForMock));
        Test.startTest();
        MockNumberSyncService service = new MockNumberSyncService(
            mockRemotePayload, testOpenSeriesList
        );
        service.synchronizeAllAssignments();
        Test.stopTest();

        List<Account_Phone_Number_Assignment__c> updatedList = [
            SELECT Phone_Number__c, CTN_Number_Status__c FROM Account_Phone_Number_Assignment__c
            WHERE Phone_Number__c = '10101010'
        ];

        //ASSERT
        System.assertEquals(1, updatedList.size(), 'Should be 1 assignment for 10101010.');
        System.assertEquals(SFConstants.ASSIGNED_RESERVED, updatedList[0].CTN_Number_Status__c, 'Status should be updated to AR.');
    }

    /**
     * @description Tests the deletion of obsolete assignments.
     */
    @isTest
    static void testDeleteObsoleteAssignments() {
        
        //ARRANGE
        Account testAccount = createTestAccount();
        insert testAccount;
        // 1. Setup Series
        List<Account_Phone_Number_Series__c> testSeriesList = new List<Account_Phone_Number_Series__c>{
            createTestSeries('SAL', 'BRZ', '10101010','', 'GSM'),
            createTestSeries('SAL', 'SAL', '20202020','', 'GSM')
        };
        testSeriesList[0].Account__c = testAccount.Id;
        testSeriesList[1].Account__c = testAccount.Id;
        insert testSeriesList;

        // Re-query the series to ensure the Account relationship is populated for the mock selector
        List<Account_Phone_Number_Series__c> seriesForMock = [
            SELECT Id, Name, Number_Group__c, Number_Location__c, CVR__c, Number_Pattern__c, Product_type__c, Account__c, Account__r.CVR__c
            FROM Account_Phone_Number_Series__c
            WHERE Id IN :testSeriesList
        ];
        Id series1Id = seriesForMock[0].Id;
        Id series2Id = seriesForMock[1].Id;

        // 2. Setup Open Series CMD (empty)
        List<OpenPhoneNumberSeries__mdt> testOpenSeriesList = new List<OpenPhoneNumberSeries__mdt>();

        // 3. Setup Local Assignments
        List<Account_Phone_Number_Assignment__c> localAssignments = new List<Account_Phone_Number_Assignment__c>{
            createTestAssignment('10101010', 'AA', series1Id, null),
            createTestAssignment('20202020', 'AA', series2Id, null)
        };
        insert localAssignments;

        // 4. Setup Mock Remote Payload
        // SAL_BRZ returns no numbers (so 10101010 is obsolete)
        // SAL_SAL returns 20202020
        Map<String, List<NumberClientResponseDTO.NumberData>> mockRemotePayload =
            new Map<String, List<NumberClientResponseDTO.NumberData>>{
                'SAL_BRZ_AA' => new List<NumberClientResponseDTO.NumberData>(),
                'SAL_BRZ_AR' => new List<NumberClientResponseDTO.NumberData>(),
                'SAL_BRZ_AI' => new List<NumberClientResponseDTO.NumberData>(),
                'SAL_BRZ_AS' => new List<NumberClientResponseDTO.NumberData>(),
                'SAL_SAL_AA' => new List<NumberClientResponseDTO.NumberData>{
                    createRemoteData('20202020', 'AA', 'SAL', 'SAL')
                },
                'SAL_SAL_AR' => new List<NumberClientResponseDTO.NumberData>(),
                'SAL_SAL_AI' => new List<NumberClientResponseDTO.NumberData>(),
                'SAL_SAL_AS' => new List<NumberClientResponseDTO.NumberData>()
            };

        //ACT
        AccountPhoneNumberSeriesSelector.setMock(new AccountPhoneNumberSeriesSelectorMock(seriesForMock));
        Test.startTest();
        MockNumberSyncService service = new MockNumberSyncService(
            mockRemotePayload, testOpenSeriesList
        );
        service.synchronizeAllAssignments();
        Test.stopTest();

        List<Account_Phone_Number_Assignment__c> remainingAssignments = [
            SELECT Phone_Number__c FROM Account_Phone_Number_Assignment__c
        ];

        //ASSERT
        System.assertEquals(1, remainingAssignments.size(), 'Only one assignment should remain.');
        System.assertEquals('20202020', remainingAssignments[0].Phone_Number__c, '20202020 should remain.');
    }

    /**
     * @description Tests the handling of open phone number series.
     */
    @isTest
    static void testOpenPhoneNumberSeriesHandling() {

        //ARRANGE
        Account testAccount = createTestAccount();
        insert testAccount;
        // 1. Setup Series: One regular, one matching the open series criteria
        List<Account_Phone_Number_Series__c> testSeriesList = new List<Account_Phone_Number_Series__c>{
            createTestSeries('SAL', 'BRZ', '12345678','', 'GSM'),
            createTestSeries('P', 'EKC', '12345679','', 'GSM')
        };
        testSeriesList[0].Account__c = testAccount.Id;
        testSeriesList[1].Account__c = testAccount.Id;
        insert testSeriesList;

        // Re-query the series to ensure the Account relationship is populated for the mock selector
        List<Account_Phone_Number_Series__c> seriesForMock = [
            SELECT Id, Name, Number_Group__c, Number_Location__c, CVR__c, Number_Pattern__c, Product_type__c, Account__c, Account__r.CVR__c
            FROM Account_Phone_Number_Series__c
            WHERE Id IN :testSeriesList
        ];

        // 2. Setup Mock Open Series (P, EKC is open)
        List<OpenPhoneNumberSeries__mdt> testOpenSeriesList = new List<OpenPhoneNumberSeries__mdt>{
            createMockOpenSeriesMetadata('P', 'EKC')
        };

        // 3. No Local Assignments for this test (focus on creation & call behavior)

        // 4. Setup Mock Remote Payload
        Map<String, List<NumberClientResponseDTO.NumberData>> mockRemotePayload =
            new Map<String, List<NumberClientResponseDTO.NumberData>>{
                // Standard Series SAL_BRZ: Expect calls for AA, AR, AI, AS. Provide data for AA.
                'SAL_BRZ_AA' => new List<NumberClientResponseDTO.NumberData>{ 
                    createRemoteData('STD_PHONE1', 'AA', 'SAL', 'BRZ') },
                'SAL_BRZ_AR' => new List<NumberClientResponseDTO.NumberData>(),
                'SAL_BRZ_AI' => new List<NumberClientResponseDTO.NumberData>(),
                'SAL_BRZ_AS' => new List<NumberClientResponseDTO.NumberData>(),
                // Open Series P_EKC: Expect call only for AR. Provide data for AR.
                'P_EKC_AR' => new List<NumberClientResponseDTO.NumberData>{ createRemoteData('OPEN_PHONE1', 'AR', 'P', 'EKC') }
                // No data for P_EKC_AA, P_EKC_AI, P_EKC_AS as they shouldn't be called.
            };

        //ACT
        AccountPhoneNumberSeriesSelector.setMock(new AccountPhoneNumberSeriesSelectorMock(seriesForMock));
        Test.startTest();
        MockNumberSyncService service = new MockNumberSyncService(
            mockRemotePayload, testOpenSeriesList
        );
        service.synchronizeAllAssignments();
        Test.stopTest();

        // Assert DML outcomes
        List<Account_Phone_Number_Assignment__c> created = [
            SELECT Phone_Number__c, CTN_Number_Status__c, Account_Phone_Number_Series__r.Number_Group__c
            FROM Account_Phone_Number_Assignment__c
            ORDER BY Phone_Number__c
        ];

        //ASSERT
        System.assertEquals(2, created.size(), 'Should create one std and one open series assignment.');
        System.assertEquals('OPEN_PHONE1', created[0].Phone_Number__c);
        System.assertEquals('AR', created[0].CTN_Number_Status__c);
        System.assertEquals('P', created[0].Account_Phone_Number_Series__r.Number_Group__c);

        System.assertEquals('STD_PHONE1', created[1].Phone_Number__c);
        System.assertEquals('AA', created[1].CTN_Number_Status__c);
        System.assertEquals('SAL', created[1].Account_Phone_Number_Series__r.Number_Group__c);

        // Assert call behavior
        Set<String> expectedCallKeys = new Set<String>{
            'SAL_BRZ_AA', 'SAL_BRZ_AR', 'SAL_BRZ_AI', 'SAL_BRZ_AS', // Standard series
            'P_EKC_AR'                                              // Open series (only AR)
        };

        System.assertEquals(expectedCallKeys.size(), service.calledParamsKeys.size(),
            'Called keys count mismatch. Called: ' + service.calledParamsKeys);
        for(String key : expectedCallKeys) {
            System.assert(service.calledParamsKeys.contains(key), 'Expected call key: ' + key + '. Actual calls: ' + service.calledParamsKeys);
        }
        System.assert(!service.calledParamsKeys.contains('P_EKC_AA'), 'P_EKC_AA should not have been called.');
        System.assert(!service.calledParamsKeys.contains('P_EKC_AI'), 'P_EKC_AI should not have been called.');
        System.assert(!service.calledParamsKeys.contains('P_EKC_AS'), 'P_EKC_AS should not have been called.');
    }

    /**
     * @description Helper to create an Account for testing.
     * @return An Account record.
     */
    private static Account createTestAccount() {
        return new Account(Name = 'Test Account', CVR__c = '12345678');
    }

    /**
     * @description Tests the creation of new assignments with an account.
     */
    @isTest
    static void testCreateNewAssignmentsWithAccount() {

        //ARRANGE
        // 1. Setup Mock Series Data
        Account testAccount = createTestAccount();
        insert testAccount;

        List<Account_Phone_Number_Series__c> testSeriesList = new List<Account_Phone_Number_Series__c>{
            createTestSeries('SAL', 'BRZ', '12345678','', 'GSM')
        };
        testSeriesList[0].Account__c = testAccount.Id;
        insert testSeriesList;

        // Re-query the series to ensure the Account relationship is populated for the mock selector
        List<Account_Phone_Number_Series__c> seriesForMock = [
            SELECT Id, Name, Number_Group__c, Number_Location__c, CVR__c, Number_Pattern__c, Product_type__c, Account__c, Account__r.CVR__c
            FROM Account_Phone_Number_Series__c
            WHERE Id IN :testSeriesList
        ];

        // 2. Setup Mock Open Series (empty for this test, assuming SAL_BRZ is not open)
        List<OpenPhoneNumberSeries__mdt> testOpenSeriesList = new List<OpenPhoneNumberSeries__mdt>();

        // 3. No Local Assignments for this test

        // 4. Setup Mock Remote Payload (keyed by Group_Location_Status)
        Map<String, List<NumberClientResponseDTO.NumberData>> mockRemotePayload =
            new Map<String, List<NumberClientResponseDTO.NumberData>>{
                'SAL_BRZ_AA' => new List<NumberClientResponseDTO.NumberData>{
                    createRemoteData('20202020', 'AA', 'SAL', 'BRZ'), // numberGroup in remoteData is informational
                    createRemoteData('20304050', 'AA', 'SAL', 'BRZ')
                }
                // Ensure other statuses for GRP1_LOCA return empty if queried
                ,'SAL_BRZ_AR' => new List<NumberClientResponseDTO.NumberData>()
                ,'SAL_BRZ_AI' => new List<NumberClientResponseDTO.NumberData>()
                ,'SAL_BRZ_AS' => new List<NumberClientResponseDTO.NumberData>()
            };

        //ACT    
        AccountPhoneNumberSeriesSelector.setMock(new AccountPhoneNumberSeriesSelectorMock(seriesForMock));
        Test.startTest();
        MockNumberSyncService service = new MockNumberSyncService(
            mockRemotePayload, testOpenSeriesList
        );
        service.synchronizeAssignmentsForAccount(testAccount);
        Test.stopTest();

        List<Account_Phone_Number_Assignment__c> created = [
            SELECT Phone_Number__c, CTN_Number_Status__c, Account_Phone_Number_Series__c, Account__c
            FROM Account_Phone_Number_Assignment__c
        ];


        //ASSERT
        System.assertEquals(2, created.size(), 'Should create 2 new assignments.');
        Set<String> createdPhones = new Set<String>();
        for(Account_Phone_Number_Assignment__c asn : created) {
            createdPhones.add(asn.Phone_Number__c);
            System.assertEquals(seriesForMock[0].Id, asn.Account_Phone_Number_Series__c, 'Series should match.');
            System.assertEquals('AA', asn.CTN_Number_Status__c, 'Status should be AA.');
            System.assertEquals(testAccount.Id, asn.Account__c, 'Account should be set.');
        }
        System.assert(createdPhones.contains('20202020'), '20202020 should be created.');
        System.assert(createdPhones.contains('20304050'), '20304050 should be created.');
    }

    @isTest
    static void testRecreatesMissingAssignment() {
        //ARRANGE
        Account testAccount = createTestAccount();
        insert testAccount;
        // 1. Setup Series
        List<Account_Phone_Number_Series__c> testSeriesList = new List<Account_Phone_Number_Series__c>{
            createTestSeries('SAL', 'BRZ', '12345678','', 'GSM')
        };
        testSeriesList[0].Account__c = testAccount.Id;
        insert testSeriesList;

        // Re-query the series to ensure the Account relationship is populated for the mock selector
        List<Account_Phone_Number_Series__c> seriesForMock = [
            SELECT Id, Name, Number_Group__c, Number_Location__c, CVR__c, Number_Pattern__c, Product_type__c, Account__c, Account__r.CVR__c
            FROM Account_Phone_Number_Series__c
            WHERE Id IN :testSeriesList
        ];
        Id series1Id = seriesForMock[0].Id;

        // 2. Setup Open Series CMD (empty)
        List<OpenPhoneNumberSeries__mdt> testOpenSeriesList = new List<OpenPhoneNumberSeries__mdt>();

        // 3. Setup Local Assignments - one is missing ('30303030')
        List<Account_Phone_Number_Assignment__c> localAssignments = new List<Account_Phone_Number_Assignment__c>{
            createTestAssignment('10101010', 'AA', series1Id, testAccount.Id),
            createTestAssignment('20202020', 'AA', series1Id, testAccount.Id)
        };
        insert localAssignments;

        // 4. Setup Mock Remote Payload - remote has all three
        Map<String, List<NumberClientResponseDTO.NumberData>> mockRemotePayload =
            new Map<String, List<NumberClientResponseDTO.NumberData>>{
                'SAL_BRZ_AA' => new List<NumberClientResponseDTO.NumberData>{
                    createRemoteData('10101010', 'AA', 'SAL', 'BRZ'),
                    createRemoteData('20202020', 'AA', 'SAL', 'BRZ'),
                    createRemoteData('30303030', 'AA', 'SAL', 'BRZ')
                },
                'SAL_BRZ_AR' => new List<NumberClientResponseDTO.NumberData>(),
                'SAL_BRZ_AI' => new List<NumberClientResponseDTO.NumberData>(),
                'SAL_BRZ_AS' => new List<NumberClientResponseDTO.NumberData>()
            };

        //ACT
        AccountPhoneNumberSeriesSelector.setMock(new AccountPhoneNumberSeriesSelectorMock(seriesForMock));
        Test.startTest();
        MockNumberSyncService service = new MockNumberSyncService(
            mockRemotePayload, testOpenSeriesList
        );
        service.synchronizeAssignmentsForAccount(testAccount);
        Test.stopTest();

        //ASSERT
        List<Account_Phone_Number_Assignment__c> finalAssignments = [
            SELECT Phone_Number__c FROM Account_Phone_Number_Assignment__c
        ];
        System.assertEquals(3, finalAssignments.size(), 'Should be 3 assignments in total.');

        Set<String> finalPhones = new Set<String>();
        for(Account_Phone_Number_Assignment__c asn : finalAssignments) {
            finalPhones.add(asn.Phone_Number__c);
        }
        System.assert(finalPhones.contains('10101010'), '10101010 should exist.');
        System.assert(finalPhones.contains('20202020'), '20202020 should exist.');
        System.assert(finalPhones.contains('30303030'), 'The missing assignment 30303030 should have been recreated.');
    }
}