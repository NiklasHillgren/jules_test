/**
 * This test class validates the functionality of CustomerClient class operations.
 * 
 * 
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Niklas Hillgren      28/10/2025      Initial
 * 
 * @author Niklas Hillgren
 * @version 1.0
 * @since 28/10/2025
 */
@isTest
public with sharing class CustomerClientTest {
    // Mock JSON response containing sample customer data
    private static final String MOCK_CUSTOMER_RESPONSE = '{"data": [{"id": "12345678"}]}';

    /**
     * Verifies successful customer retrieval with valid query parameters
     * 
     * Test Case ID: CC001
     * Test Scenario: Valid CVR number provided in query parameters
     * Expected Result: Returns a list containing one matching customer record
     */
    @isTest
    private static void getCustomers_WithValidQueryParams_ReturnsCustomers() {
        // Arrange: Setup test data
        Map<Object, Object> queryParams = new Map<Object, Object>();
        queryParams.put(CustomerClient.QUERY_GETCUSTOMERS.cvr, '12345678');
        
        // Mock HTTP response with success status and sample data
        HttpResponseMock mockResponse = new HttpResponseMock(
            200,                    // Success status code
            'OK',                   // Status message
            MOCK_CUSTOMER_RESPONSE  // Response body
        );
        
        // Configure mock for HTTP callouts
        Test.setMock(HttpCalloutMock.class, mockResponse);
        
        // Initialize client instance
        CustomerClient client = new CustomerClient();
        
        // Act: Execute test logic
        Test.startTest();
        List<CustomerClientResponseDTO.Customer> customers = client.getCustomers(queryParams);
        Test.stopTest();
        
        // Assert: Verify response is valid
        System.assertNotEquals(null, customers, 'Customers list should not be null');
        System.assertEquals(1, customers.size(), 'Should return exactly one customer');
        System.assertEquals('12345678', customers[0].id, 'Customer CVR should match');
    }

    /**
     * Verifies exception handling for empty query parameters
     * 
     * Test Case ID: CC002
     * Test Scenario: No identifiers provided in query parameters
     * Expected Result: Throws CustomerException with specific error message
     */
    @isTest
    private static void getCustomers_WithEmptyQueryParams_ThrowsException() {
        // Arrange
        Map<Object, Object> queryParams = new Map<Object, Object>();
        
        // Initialize client instance
        CustomerClient client = new CustomerClient();
        
        // Act & Assert
        Test.startTest();
        try {
            // Attempt to retrieve customers with invalid parameters
            client.getCustomers(queryParams);
            System.assert(false, 'Expected CustomerException was not thrown');
        } catch(CustomerException ex) {
            // Validate exception message
            System.assertEquals(
                'At least one identifier must be provided',
                ex.getMessage(),
                'Exception message should match expected'
            );
        }
        Test.stopTest();
    }
}