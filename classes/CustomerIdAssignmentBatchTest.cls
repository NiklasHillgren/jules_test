/**
 * Unit test class for CustomerIdAssignmentBatch functionality
 * Tests various scenarios for batch processing of Customer ID assignments
 * 
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Niklas Hillgren      28/10/2025      Initial
 *
 */
@IsTest
public with sharing class CustomerIdAssignmentBatchTest {
    /**
     * Mock instance for AccountSelector service
     */
    private static Mock accountSelectorMock;
    
    /**
     * Mock instance for CustomerClient service
     */
    private static Mock customerClientMock;
    
    /**
     * Mock database service for testing DML operations
     */
    private static DatabaseService dbService;

    /**
     * Sets up required mock objects for testing
     * Initializes AccountSelector, CustomerClient, and DatabaseService mocks
     * Registers them in the SingletonFactory for dependency injection
     */
    private static void setupMocks() {
        // Initialize mocks
        accountSelectorMock = Mock.forType(AccountSelector.class);
        customerClientMock = Mock.forType(CustomerClient.class);

        AccountSelector accountSelector = (AccountSelector) accountSelectorMock.stub;
        CustomerClient customerClient = (CustomerClient) customerClientMock.stub;
        DatabaseService mockDbService = new DatabaseService().mockDMLs();
        dbService = mockDbService;
        
        // Register singletons
        SingletonFactory factory = SingletonFactory.getFactory();
        factory.registerSingleton(AccountSelector.class, accountSelector);
        factory.registerSingleton(CustomerClient.class, customerClient);
        factory.registerSingleton(DatabaseService.class, mockDbService);
    }

    /**
     * Creates test accounts with predefined properties
     * Returns a list containing a single test account with CVR number
     *
     * @return List<Account> Pre-configured test accounts
     */
    private static List<Account> mockAccounts(){
        List<Account> mockedAccounts = new List<Account>();
        
        Account testAccount = new Account();
        testAccount.Id = DatabaseService.getFakeId(Account.SObjectType);
        testAccount.CVR__c = '12341234'; // Danish business identifier
        
        mockedAccounts.add(testAccount);
        return mockedAccounts;
    }

    /**
     * Tests successful execution of batch start operation
     * Verifies that the batch starts without exceptions and calls required methods
     */
    @IsTest
    public static void startBatch_execute_withoutException() {
        // Arrange phase: Setup test environment
        setupMocks();
        
        // Spy on getAccountsWithoutCustomerId method
        MethodSpy getCustomerCalloutSpy = accountSelectorMock.spyOn('getAccountsWithoutCustomerId');
        getCustomerCalloutSpy.whenCalledWith().thenReturn(null);
        
        CustomerIdAssignmentBatch batch = new CustomerIdAssignmentBatch();
        
        // Act: Execute the batch start
        Test.startTest();
        Database.QueryLocator locator = batch.startBatch(null);
        Test.stopTest();

        // Assert: Verify successful execution and method calls
        Assert.isTrue(true, 'We got to this point');
        Expect.that(getCustomerCalloutSpy).hasBeenCalled();
    }
    
    /**
     * Tests batch execution with valid customer client response
     * Verifies that Customer ID is correctly assigned when client returns matching data
     */
    @IsTest
    public static void executeBatchChunk_withClientResult_setCustomerId() {
        // Arrange phase: Setup test environment and mock responses
        setupMocks();
        List<CustomerClientResponseDTO.Customer> returnFromCallout = new List<CustomerClientResponseDTO.Customer>();
        CustomerClientResponseDTO.Customer dtoReturn = new CustomerClientResponseDTO.Customer();
        dtoReturn.id = '12341234_result';
        returnFromCallout.add(dtoReturn);
        
        // Configure mock behavior for getCustomers method
        MethodSpy getCustomerCalloutSpy = customerClientMock.spyOn('getCustomers');
        getCustomerCalloutSpy.whenCalledWith(Argument.any()).thenReturn(returnFromCallout);

        CustomerIdAssignmentBatch idAssignmentBatch = new CustomerIdAssignmentBatch();
        
        // Act: Execute the batch chunk
        Test.startTest();
        idAssignmentBatch.executeBatchChunk(null, mockAccounts());
        Test.stopTest();
        
        // Assert: Verify updates and Customer ID assignment
        Expect.that(getCustomerCalloutSpy).hasBeenCalled();
        Assert.areEqual(1, dbService.register.updates.size(), 'One update');
        Assert.areEqual('12341234_result', ((Account) (dbService.register.updated.get(0))).CustomerId__c, 'Value is not set');
    }

    /**
     * Tests batch execution with mixed client response
     * Verifies partial Customer ID assignment when some accounts have matching clients
     */
    @IsTest
    public static void executeBatchChunk_mixedClientResult_setSomeCustomerId() {
        // Arrange phase: Setup test environment and mock responses
        setupMocks();
        List<CustomerClientResponseDTO.Customer> returnFromCallout = new List<CustomerClientResponseDTO.Customer>();
        CustomerClientResponseDTO.Customer dtoReturn = new CustomerClientResponseDTO.Customer();
        dtoReturn.id = '12341234_result';
        returnFromCallout.add(dtoReturn);
        
        // Configure mock behavior for getCustomers method
        MethodSpy getCustomerCalloutSpy = customerClientMock.spyOn('getCustomers');
        
        Map<Object, Object> queryParams = new Map<Object, Object>();
        queryParams.put(CustomerClient.QUERY_GETCUSTOMERS.cvr, '12341234');
        getCustomerCalloutSpy.whenCalledWith(queryParams).thenReturn(returnFromCallout);

        CustomerIdAssignmentBatch idAssignmentBatch = new CustomerIdAssignmentBatch();
        
        // Prepare test data with mixed CVR numbers
        List<Account> accs = mockAccounts();
        accs.add(new Account(Id = DatabaseService.getFakeId(Account.SObjectType), CVR__c = '12345678'));
        
        // Act: Execute the batch chunk
        Test.startTest();
        idAssignmentBatch.executeBatchChunk(null, accs);
        Test.stopTest();
        
        // Assert: Verify partial updates
        Expect.that(getCustomerCalloutSpy).hasBeenCalled();
        Assert.areEqual(1, dbService.register.updates.size(), 'One update');
        Assert.areEqual('12341234_result', ((Account) (dbService.register.updated.get(0))).CustomerId__c, 'Value is set');
        Assert.areEqual(null, ((Account) (dbService.register.updated.get(1))).CustomerId__c, 'Value is set');
    }

    /**
     * Tests batch execution without client response
     * Verifies that Customer ID remains null when no matching client data exists
     */
    @IsTest
    public static void executeBatchChunk_withoutClientResult_setNoCustomerId() {
        // Arrange phase: Setup test environment
        setupMocks();
        List<CustomerClientResponseDTO.Customer> returnFromCallout = new List<CustomerClientResponseDTO.Customer>();
        MethodSpy getCustomerCalloutSpy = customerClientMock.spyOn('getCustomers');
        getCustomerCalloutSpy.whenCalledWith(Argument.any()).thenReturn(returnFromCallout);

        CustomerIdAssignmentBatch idAssignmentBatch = new CustomerIdAssignmentBatch();

        // Act: Execute the batch chunk
        Test.startTest();
        idAssignmentBatch.executeBatchChunk(null, mockAccounts());
        Test.stopTest();
        
        // Assert: Verify updates and null Customer ID
        Expect.that(getCustomerCalloutSpy).hasBeenCalled();
        Assert.areEqual(1, dbService.register.updates.size(), 'One update');
        Assert.areEqual(null, ((Account) (dbService.register.updated.get(0))).CustomerId__c, 'Value is not set');
    }

    /**
     * Tests successful execution of batch finish operation
     * Verifies that the batch completes without exceptions
     */
    @IsTest
    public static void finishBatch_execute_withoutException() {
        setupMocks();
        CustomerIdAssignmentBatch batch = new CustomerIdAssignmentBatch();
        Test.startTest();
        batch.finishBatch(null);
        Test.stopTest();
        Assert.isTrue(true, 'We got to this point');
    }
}
