/**
 * A client implementation for interacting with the external customer API service.
 * This class handles all communication with the customer service endpoint, including
 * authentication and data transformation.
 * 
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Niklas Hillgren      28/10/2025      Initial
 * 
 * @author Niklas Hillgren
 * @version 1.0
 * @since 28/10/2025
 */
public with sharing class CustomerClient extends HTTPClient {
    private static Map<String, String> defaultHeaders = new Map<String, String>{
        'X-Application-Id' => 'salesforce',
        'X-Norlys-TraceId' => Logger.getTraceId()
    };

    /**
     * Named credential used for authenticating with the customer API
     */
    private static final String NAMED_CREDENTIAL = 'Customer_API';

    /**
     * Base endpoint URL for customer API operations
     */
    private static final String ENDPOINT_GET_CUSTOMERS = OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'endpointCustomerClient'
    );

    /**
     * Constructor initializing the HTTP client with named credentials
     */
    public CustomerClient() {
        super(NAMED_CREDENTIAL);
    }

    /**
     * This method is provided to be able to override headers
     * @see CustomerClient for an example
     */
    public override Map<String, String> getDefaultHeaders(){
        return CustomerClient.defaultHeaders;
    }

    /**
     * Retrieves a list of customers based on the provided query parameters.
     * 
     * @param queryParams Map containing search criteria where keys are QUERY_GETCUSTOMERS enum values
     *                   and values are the corresponding search terms
     * @return List of Customer objects matching the search criteria
     * @throws CustomerException if no query parameters are provided
     * @throws HTTPException if there are issues with the HTTP request/response
     */
    public List<CustomerClientResponseDTO.Customer> getCustomers(Map<Object, Object> queryParams) {
        // Log the incoming query parameters for debugging purposes
        Logger.logInfo(String.format('getCustomers( {0} )', new List<Object>{ queryParams }));

        // Validate that at least one parameter is provided
        if (queryParams.isEmpty()) {
            throw new CustomerException('At least one identifier must be provided');
        }

        // Construct the full endpoint URL with query parameters
        String endpoint = ENDPOINT_GET_CUSTOMERS;
        String query = makeQueryParams(queryParams);

        // Execute the GET request to retrieve customers
        HttpResponse response = get(endpoint, query);
        response.setBody(OrgUtils.escapeApexReservedKeywords(response.getBody(), false));

        CustomerClientResponseDTO.GetCustomerResponse responsData = (CustomerClientResponseDTO.GetCustomerResponse) handleHttpResponse(
            response,
            CustomerClientResponseDTO.GetCustomerResponse.class
        );

        return responsData.data;
    }

    /**
     * Enum defining valid query parameters for customer searches
     */
    public enum QUERY_GETCUSTOMERS {
        cvr,      // Company registration number
        account_id,// Account identifier
        cpr       // Personal identification number
    }
}
