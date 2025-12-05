/**
* @description Test class for the OrderFactory. This class uses an integration testing
*              approach for data, but mocks the Custom Metadata dependency.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial version.
*  Kenneth Houkjær      11/09/2025      Rewritten to use MetadataSelector mock and correct data setup.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
@isTest
private class OrderFactoryTest extends NorlysSUnitTest {

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

    @isTest
    static void testCreateOrdersFromActivationLines() {
        // Arrange
        MetadataSelector.setMock(new MetadataSelectorMock());

        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withActivations(1)
            .withActivationLines(2)
            .build();
        
        List<Activation_line__c> testActivationLines = scenario.activationLines;
        String caseId = scenario.caseRecord.Id;
        String ban = 'ban-123';
        for(Activation_line__c al : testActivationLines) {
            al.BAN__c = ban; // Use the writable text field
        }
        update testActivationLines;

        // Act
        Test.startTest();
        // The factory calls the real selectors, which will query the data created by the scenario builder
        Map<String, Order> resultOrders = OrderFactory.createOrdersFromActivationLines(testActivationLines, caseId);
        Test.stopTest();

        // Assert
        Assert.isNotNull(resultOrders, 'The result map should not be null.');
        Assert.isTrue(resultOrders.containsKey(ban), 'The map should contain the BAN.');
        Assert.areEqual(1, resultOrders.size(), 'Should be one order for the BAN.');

        Order resultOrder = resultOrders.get(ban);
        Assert.areEqual('TDC', resultOrder.brand, 'Brand should be set correctly.');
        Assert.areEqual(caseId, ((OrderInternet)resultOrder).implementationCaseId, 'implementationCaseId should be set.');
        Assert.areEqual(1, resultOrder.orderParts.size(), 'Should have one root order part.');
    }

    @isTest
    static void testCreateRootBanOrder() {
        // Arrange
        MetadataSelector.setMock(new MetadataSelectorMock());
        
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr('11223344')
            .build();
        
        Account testAccount = scenario.account;
        testAccount.Phone = '87654321';
        update testAccount;

        OrderFactory.RootBanRequest request = new OrderFactory.RootBanRequest();
        request.inputAccount = testAccount;
        request.companyName = 'Test Company';
        request.BanType = 'Home Office';
        
        // Act
        Test.startTest();
        Order resultOrder = OrderFactory.createRootBanOrder(request);
        Test.stopTest();

        // Assert
        Assert.isNotNull(resultOrder, 'The result order should not be null.');
        Assert.areEqual('TDC', resultOrder.brand, 'Brand should be set.');
        Assert.isTrue(resultOrder.flags[0].homeOfficeOrder, 'homeOfficeOrder flag should be true.');
        
        OrganizationParty orderer = (OrganizationParty)resultOrder.orderer;
        Assert.areEqual('Test Company', orderer.name, 'Orderer name should match.');
    }
}