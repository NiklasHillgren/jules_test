/**
* @description Test class for the refactored RootBanServiceAction class.
*              This class verifies that the action correctly calls the factory,
*              handles HTTP callouts, and processes API responses for Root BAN creation.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial version.
*  Kenneth Houkjær      11/09/2025      Rewritten to use MetadataSelector mock.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
@isTest
private class RootBanServiceActionTest extends NorlysSUnitTest {

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
    * @description Mocks a successful API response for Root BAN creation.
    */
    private class SuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            Order responseOrder = new Order();
            responseOrder.type = 'Internet'; // Set type for parser
            responseOrder.hasValidationErrors = false;
            
            OrderPart rootPart = new OrderPart();
            OrderItem item = new OrderItem();
            item.billingAccountNumber = '123456789';
            rootPart.orderItems = new List<OrderItem>{ item };
            responseOrder.orderParts = new List<OrderPart>{ rootPart };

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            System.JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeFieldName('data');
            responseOrder.serialize(gen);
            gen.writeEndObject();
            
            res.setBody(gen.getAsString());
            res.setStatusCode(200);
            return res;
        }
    }

    /**
    * @description Mocks an API response with validation errors for Root BAN creation.
    */
    private class ValidationErrorMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            Order responseOrder = new Order();
            responseOrder.type = 'Internet'; // Set type for parser
            responseOrder.hasValidationErrors = true;
            responseOrder.validationErrors = new List<ValidationErrors>{
                new ValidationErrors('BAN-ERROR-01', new List<Parameter>{ new Parameter('field', 'reason') })
            };
            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            System.JSONGenerator gen = JSON.createGenerator(true);
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
            .withCvr('11223344')
            .build();
        
        Account testAccount = scenario.account;

        RootBanServiceAction.Request request = new RootBanServiceAction.Request();
        request.inputAccount = testAccount;
        request.BanType = 'Home Office';
        List<RootBanServiceAction.Request> requests = new List<RootBanServiceAction.Request>{ request };

        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SuccessMock());
        List<RootBanServiceAction.RootBanResult> results = RootBanServiceAction.createRootBan(requests);
        Test.stopTest();

        // Assert
        Assert.isNotNull(results, 'Result list should not be null.');
        Assert.areEqual(1, results.size(), 'Should have one result.');
        
        RootBanServiceAction.RootBanResult result = results[0];
        Assert.isFalse(result.hasErrors, 'Should not have errors on success.');
        Assert.areEqual(123456789, result.billingAccountNumber, 'Billing Account Number should be returned correctly.');
    }

    @isTest
    static void testValidationErrorScenario() {
        // Arrange
        MetadataSelector.setMock(new MetadataSelectorMock());

        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr('55667788')
            .build();

        RootBanServiceAction.Request request = new RootBanServiceAction.Request();
        request.inputAccount = scenario.account;
        request.BanType = 'Home Office';
        List<RootBanServiceAction.Request> requests = new List<RootBanServiceAction.Request>{ request };

        // Act
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ValidationErrorMock());
        List<RootBanServiceAction.RootBanResult> results = RootBanServiceAction.createRootBan(requests);
        Test.stopTest();

        // Assert
        Assert.isNotNull(results, 'Result list should not be null.');
        Assert.areEqual(1, results.size(), 'Should have one result.');
        
        RootBanServiceAction.RootBanResult result = results[0];
        Assert.isTrue(result.hasErrors, 'Should have errors on validation failure.');
        Assert.isNull(result.billingAccountNumber, 'Billing Account Number should be null on failure.');

        // List<System_Log__c> logs = [SELECT Id FROM System_Log__c WHERE Error_Body__c != null];
        // Assert.areEqual(1, logs.size(), 'An error log should be created.');
    }
}