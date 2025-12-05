@IsTest
public with sharing class OrderAPIActivationLineStatusAPIHandlTest {
    @IsTest
    public static void doPost_withValidBody_returnBody() {
        // Arrange
        OrderAPIActivationLineStatusAPIHandler apiHandler = new OrderAPIActivationLineStatusAPIHandler();

        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf('{"caseId": "xyz8929","orders": [{"orderId": "SF2846564", "status": "PROCESSING", "statusMessage": "<optional_status_reason>"},{"orderId": "SF2846567", "status": "COMPLETED", "statusMessage":"<optional_status_reason>"}]}');
        NorlysAPIRequestResolver resolver = new NorlysAPIRequestResolver( req );

        RestContext.response = new RestResponse();
        // Act
        Test.startTest();
        RestResponse resp = apiHandler.doPost( resolver, RestContext.response );
        Test.stopTest();

        // Assert
        Assert.areEqual(
            Blob.valueOf('OrderAPIActivationLineStatusHandler doPost - not implemented yet'),
            resp.responseBody
        );
    }
}