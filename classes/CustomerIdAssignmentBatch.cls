/**
 * A batch job implementation responsible for assigning Customer IDs to Accounts based on CVR numbers.
 * This class processes accounts without assigned Customer IDs by querying external customer data 
 * and updating the corresponding records.
 * 
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Niklas Hillgren      28/10/2025      Initial
 * 
 * @author Niklas Hillgren
 * @version 1.0
 * @since 28/10/2025
 */
public with sharing class CustomerIdAssignmentBatch extends BatchJob {
    
    // Dependencies injected through SingletonFactory pattern
    private final CustomerClient customerClientAPI;      // Handles communication with customer API
    private final AccountSelector accSelector;           // Manages account selection logic
    private final DatabaseService dbService;             // Provides database operation utilities

    /**
     * Default constructor that delegates to the parameterized constructor with SingletonFactory
     */
    public CustomerIdAssignmentBatch() {
        this(SingletonFactory.getFactory());
    }

    /**
     * Parameterized constructor for dependency injection
     * @param singletonFactory Factory instance providing singleton dependencies
     */
    private CustomerIdAssignmentBatch(SingletonFactory singletonFactory) {
        this.customerClientAPI = (CustomerClient) singletonFactory.getOrRegisterSingleton(CustomerClient.class);
        this.dbService = (DatabaseService) singletonFactory.getOrRegisterSingleton(DatabaseService.class);
        this.accSelector = (AccountSelector) singletonFactory.getOrRegisterSingleton(AccountSelector.class);
    }

    /**
     * Returns the unique identifier for this batch job
     * @return String representing the job name
     */
    public override String getJobName() {
        return 'CustomerIdAssignmentBatch';
    }

    /**
     * Initiates the batch process by retrieving all accounts without Customer IDs
     * @param bc Context object containing batch job information
     * @return QueryLocator pointing to the collection of accounts to process
     */
    public override Database.QueryLocator startBatch(Database.BatchableContext bc) {
        Logger.logInfo(String.format('startBatch( {0} )', new List<Object>{ bc }));
        return accSelector.getAccountsWithoutCustomerId();  // Get initial set of accounts to process
    }

    /**
     * Processes chunks of accounts during the batch execution
     * @param bc Batch context containing job information
     * @param scope List of SObjects (Accounts) to process in current chunk
     */
    public override void executeBatchChunk(Database.BatchableContext bc, List<SObject> scope) {
        Logger.logInfo(String.format('executeBatchChunk( {0}, {1} )', new List<Object>{ bc, scope }));
        
        // Initialize collection for accounts requiring updates
        List<Account> toUpdate = new List<Account>();

        // Process each account in the current chunk
        for (Account acc : (List<Account>) scope) {
            Account accountToUpdate = new Account();
            accountToUpdate.Id = acc.Id;
            
            // Set processing timestamp
            accountToUpdate.CustomerIdProcessedDate__c = System.now();

            try {
                Logger.logInfo(String.format('acc: {0}', new List<Object>{ acc }));

                // Prepare query parameters for customer lookup
                Map<Object, Object> queryParams = new Map<Object, Object>();
                queryParams.put(CustomerClient.QUERY_GETCUSTOMERS.cvr, acc.CVR__c);

                // Query external system for matching customer
                List<CustomerClientResponseDTO.Customer> matchedCustomer = 
                    customerClientAPI.getCustomers(queryParams);

                // Validate customer existence
                if (matchedCustomer == null || matchedCustomer.isEmpty()) {
                    // Handle case where no matching customer found
                    String fatalString = String.format(
                        'CustomerClient.getCustomers( {0} ) returned empty result',
                        new List<Object>{ queryParams }
                    );
                    throw new CustomerException(fatalString);
                } else {
                    // Assign customer ID from matched result
                    accountToUpdate.CustomerId__c = matchedCustomer.get(0).Id;
                }
            } catch (Exception ex) {
                // Log any errors during processing
                String error = String.format(
                    'TraceId: {0}, Message: {1}',
                    new List<Object>{ Logger.getTraceId() , ex.getMessage() }
                );

                if( error.length() > 254 ) {
                    error = error.substring(0, 254);
                }

                accountToUpdate.CustomerIdProcessedError__c = error;
                Logger.logError(ex);
            } finally {
                // Add account to update collection regardless of success/failure
                toUpdate.add(accountToUpdate);
            }
        }

        // Bypass trigger handling for performance optimization
        TriggerHandler.byPass('AccountTriggerHandler');
        
        // Update all processed accounts in bulk
        dbService.updateRecords(toUpdate);
    }

    /**
     * Finalizes the batch job after all chunks have been processed
     * @param bc Batch context containing job information
     */
    public override void finishBatch(Database.BatchableContext bc) {
        Logger.logInfo(String.format('finishBatch( {0} )', new List<Object>{ bc }));
    }
}
