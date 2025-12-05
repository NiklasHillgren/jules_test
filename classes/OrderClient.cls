/**
 * A client implementation for interacting with the external Order API service.
 * This class handles the communication with the Order API endpoint.
 *
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Niklas Hillgren      03/11/2025      Initial
 *
 * @author Niklas Hillgren
 * @version 1.0
 * @since 03/11/2025
 */
public with sharing class OrderClient extends HTTPClient {
    /**
     * Named credential used for authenticating with the Order_API endpoint.
     * Provides secure authentication for all HTTP requests made by this client.
     */
    private static String NAMED_CREDENTIAL {
        get {
            return 'Order_API';
        }
    }

    private static String ENDPOINT_PLACE_ORDER_ON_EXISTING_BAN_CONFIG {
        get {
            return 'endpointOrderClientPlaceOrdersByBAN';
        }
    }

    /**
     * Endpoint URL for placing orders associated with existing Business Account Numbers (BAN).
     * Retrieved dynamically from Org configuration settings.
     */
    private static String ENDPOINT_PLACE_ORDER_ON_EXISTING_BAN {
        get {
            return OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
                OrderClient.ENDPOINT_PLACE_ORDER_ON_EXISTING_BAN_CONFIG
            );
        }
    }

    public OrderClient() {
        super(NAMED_CREDENTIAL);
    }

    public OrderClientDTO.OrderV10 validateOrder(OrderClientDTO.OrderV10 customerOrder, String banNumber) {
        String endpoint = '/accounts/'+banNumber+'/orders/validate';


        String requestBody = JSON.serialize(customerOrder, true);

        requestBody = OrgUtils.escapeApexReservedKeywords(requestBody, true);
        HttpResponse response = this.post(endpoint, requestBody); //WOULD EXPECT THIS TO THROW UP IF WE HAVE WRONG COUNTRY CODE!
        response.setBody(OrgUtils.escapeApexReservedKeywords(response.getBody(), false));

        return (OrderClientDTO.OrderV10) handleHttpResponse(response, OrderClientDTO.OrderV10.class);
    }

    public OrderClientDTO.OrderV10 placeOrderByBAN(OrderClientDTO.OrderV10 customerOrder, String banNumber) {
        Logger.logInfo(
            String.format(ENDPOINT_PLACE_ORDER_ON_EXISTING_BAN, new List<Object>{ customerOrder, banNumber })
        );

        String endpoint = String.format(ENDPOINT_PLACE_ORDER_ON_EXISTING_BAN, new List<Object>{ banNumber });
        String requestBody = JSON.serialize(customerOrder, true);

        requestBody = OrgUtils.escapeApexReservedKeywords(requestBody, true);
        HttpResponse response = this.post(endpoint, requestBody); //WOULD EXPECT THIS TO THROW UP IF WE HAVE WRONG COUNTRY CODE!
        response.setBody(OrgUtils.escapeApexReservedKeywords(response.getBody(), false));

        return (OrderClientDTO.OrderV10) handleHttpResponse(response, OrderClientDTO.OrderV10.class);
    }

    public void getOrderById (){
        String endpointPartial = '/orders/SF119490';
        
        HttpResponse response = this.get(endpointPartial);
        System.debug(response);
    }
}
