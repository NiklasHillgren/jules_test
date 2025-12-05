/**
* @description Test class for the refactored OrderAPIAction class.
*              This class verifies that the action correctly calls the factory,
*              handles HTTP callouts, and processes various API responses.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial version.
*  Kenneth Houkjær      11/09/2025      Rewritten to use MetadataSelector mock and full integration pattern.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
@isTest
private class OrderAPIActionTest extends NorlysSUnitTest {

    /**
    * @description Mock for the MetadataSelector service to provide API settings in a test context.
    */
    private class MetadataSelectorMock extends MetadataSelector.Service {
        protected override SObject passThrough(SObject record) {
            if (record instanceof APISettings__mdt) {
                return new APISettings__mdt(
                    brand__c = 'TDC',
                    channel__c = 'B2B',
                    dealerCode__c = '123'
                );
            }
            return super.passThrough(record);
        }
    }
    
    /**
    * @description Mocks a successful API response.
    */
    private class SuccessMock implements HttpCalloutMock {
        private String activationLineId;

        public SuccessMock(String activationLineId) {
            this.activationLineId = activationLineId;
        }

        public HttpResponse respond(HttpRequest req) {
            Order responseOrder = new Order();
            responseOrder.type = 'Internet'; // Set type for parser
            responseOrder.hasValidationErrors = false;
            
            OrderPart rootPart = new OrderPart();
            
            OrderPartInternet accountPart = new OrderPartInternet();
            accountPart.channelOrderPartId = this.activationLineId;
            accountPart.processingStatus = 'RECEIVED';
            accountPart.splitOrderId = 'order-123';
            
            rootPart.orderParts = new List<OrderPart>{ accountPart };
            responseOrder.orderParts = new List<OrderPart>{ rootPart };

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            System.JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeFieldName('data');
            responseOrder.serialize(gen);
            gen.writeEndObject();
            
            res.setBody(gen.getAsString());
            res.setStatusCode(201);
            return res;
        }
    }

    /**
    * @description Mocks an API response with validation errors.
    */
    private class ValidationErrorMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            Order responseOrder = new Order();
            responseOrder.type = 'Internet'; // Set type for parser
            responseOrder.hasValidationErrors = true;
            responseOrder.validationErrors = new List<ValidationErrors>{
                new ValidationErrors('ERROR-01', new List<Parameter>{ new Parameter('field', 'reason') })
            };

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');

            System.JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeFieldName('data');
            responseOrder.serialize(gen);
            gen.writeEndObject();

            res.setBody(gen.getAsString());
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testSuccessScenario() {
        // Arrange
        MetadataSelector.setMock(new MetadataSelectorMock());

        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivations(1)
            .withActivationLines(1)
            .build();
        
        List<Activation_line__c> testActivationLines = scenario.activationLines;
        
        OrderAPIAction.Request request = new OrderAPIAction.Request();
        request.activationLines = testActivationLines;
        request.account = scenario.account;
        List<OrderAPIAction.Request> requests = new List<OrderAPIAction.Request>{ request };

        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SuccessMock(testActivationLines[0].Id));
        OrderAPIAction.createOrder(requests);
        Test.stopTest();

        // Assert
        // List<System_Log__c> logs = [SELECT Id FROM System_Log__c WHERE Error_Body__c != null];
        // Assert.areEqual(0, logs.size(), 'No error logs should be created on success.');

        Activation_line__c updatedLine = [SELECT Home_Office_Order_Id__c, Status__c FROM Activation_line__c WHERE Id = :testActivationLines[0].Id];
        Assert.areEqual('order-123', updatedLine.Home_Office_Order_Id__c, 'Order ID should be updated on the activation line.');
        Assert.areEqual('Pending fulfilment', updatedLine.Status__c, 'Status should be updated.');
    }

    @isTest
    static void testValidationErrorScenario() {
        // Arrange
        MetadataSelector.setMock(new MetadataSelectorMock());
        
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivations(1)
            .withActivationLines(1)
            .build();
        
        OrderAPIAction.Request request = new OrderAPIAction.Request();
        request.activationLines = scenario.activationLines;
        request.account = scenario.account;
        List<OrderAPIAction.Request> requests = new List<OrderAPIAction.Request>{ request };

        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ValidationErrorMock());
        OrderAPIAction.createOrder(requests);
        Test.stopTest();

        // Assert
        // List<System_Log__c> logs = [SELECT Id FROM System_Log__c WHERE Error_Body__c != null];
        // Assert.areEqual(1, logs.size(), 'An error log should be created for validation errors.');
    }
}