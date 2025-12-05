public with sharing class OrderAPIActivationLineStatusAPIHandler extends NorlysAPIHandler {
    public override RestResponse doPost(NorlysAPIRequestResolver resolver, RestResponse resp) {
        Logger.logInfo('doPost');

        OrderAPIRequestDTO.OrderStatus myOrders = (OrderAPIRequestDTO.OrderStatus) parseRequest(resolver.requestBody, OrderAPIRequestDTO.OrderStatus.class);

        resp.responseBody = Blob.valueOf('OrderAPIActivationLineStatusHandler doPost - not implemented yet');

        //IMPLEMENT UPDATE STATUS ON ACTAVTION LINE BY ORDER ID
        resp.statusCode = 200;
        
        return resp;
    }
}