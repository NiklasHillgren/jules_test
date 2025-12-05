/**
* @description Test class for the Order API Data Transfer Objects (DTOs).
*              This class verifies that the DTOs can be correctly serialized to JSON
*              and deserialized back into objects, maintaining data integrity.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
@isTest
private class OrderDTOTest {

    @isTest
    static void testOrderSerializationDeserialization() {
        // Arrange: Create a complex Order object
        Order originalOrder = new OrderInternet();
        originalOrder.brand = 'TDC';
        originalOrder.channel = 'B2B';
        originalOrder.segment = 'SME';
        ((OrderInternet)originalOrder).implementationCaseId = '12345';

        Flag flag = new Flag();
        flag.dirty = true;
        flag.termsAccepted = true;
        originalOrder.flags = new List<Flag>{ flag };

        OrderPart rootPart = new OrderPart();
        rootPart.type = 'ACCOUNT';
        rootPart.activity = 'CHANGE';

        OrderPartInternet accountPart = new OrderPartInternet();
        accountPart.type = 'ACCOUNT';
        accountPart.activity = 'CREATE';
        accountPart.channelOrderPartId = 'act-line-123';
        
        OrderItemInternet item = new OrderItemInternet();
        item.type = 'SUBSCRIPTION_ITEM';
        item.activity = 'CREATE';
        item.preferredActivationDate = Date.newInstance(2025, 10, 20);
        
        Offering offering = new Offering();
        offering.priceplan = 'FP_1000';
        item.offering = offering;

        accountPart.orderItems = new List<OrderItem>{ item };
        rootPart.orderParts = new List<OrderPart>{ accountPart };
        originalOrder.orderParts = new List<OrderPart>{ rootPart };

        // Act: Serialize and then deserialize the object
        String jsonString = JSON.serialize(originalOrder, true);
        System.debug('Serialized Order: ' + jsonString);

        Order deserializedOrder = OrderFactory.parse(jsonString);

        // Assert: Verify that the deserialized object matches the original
        System.assertEquals(originalOrder.brand, deserializedOrder.brand, 'Brand should match.');
        System.assertEquals(originalOrder.channel, deserializedOrder.channel, 'Channel should match.');
        System.assertEquals(originalOrder.segment, deserializedOrder.segment, 'Segment should match.');
        
        OrderInternet deserializedInternetOrder = (OrderInternet)deserializedOrder;
        System.assertEquals(((OrderInternet)originalOrder).implementationCaseId, deserializedInternetOrder.implementationCaseId, 'ImplementationCaseId should match.');

        System.assertEquals(1, deserializedOrder.flags.size(), 'Should have one flag.');
        System.assertEquals(originalOrder.flags[0].dirty, deserializedOrder.flags[0].dirty, 'Flag.dirty should match.');

        System.assertEquals(1, deserializedOrder.orderParts.size(), 'Should have one root order part.');
        OrderPart deserializedRootPart = deserializedOrder.orderParts[0];
        System.assertEquals(rootPart.type, deserializedRootPart.type, 'Root part type should match.');
        System.assertEquals(rootPart.activity, deserializedRootPart.activity, 'Root part activity should match.');

        System.assertEquals(1, deserializedRootPart.orderParts.size(), 'Should have one account part.');
        OrderPartInternet deserializedAccountPart = (OrderPartInternet)deserializedRootPart.orderParts[0];
        System.assertEquals(accountPart.channelOrderPartId, deserializedAccountPart.channelOrderPartId, 'Account part channelOrderPartId should match.');

        System.assertEquals(1, deserializedAccountPart.orderItems.size(), 'Should have one order item.');
        OrderItemInternet deserializedItem = (OrderItemInternet)deserializedAccountPart.orderItems[0];
        System.assertEquals(item.preferredActivationDate, deserializedItem.preferredActivationDate, 'Item preferredActivationDate should match.');
        System.assertEquals(item.offering.priceplan, deserializedItem.offering.priceplan, 'Item offering priceplan should match.');
    }

    @isTest
    static void testOrganizationPartySerialization() {
        // Arrange
        OrganizationParty originalParty = new OrganizationParty();
        originalParty.name = 'Test Corp';
        originalParty.cvr = '12345678';
        originalParty.type = 'ORGANIZATION';
        originalParty.email = 'contact@testcorp.com';

        Address addr = new Address();
        addr.streetName = 'Test Street';
        originalParty.address = addr;

        // Act
        String jsonString = JSON.serialize(originalParty, true);

        // Assert
        // We are primarily concerned with serialization for the factory.
        // A full deserialization test would require a more robust, polymorphic parse method.
        System.assert(jsonString.contains('"name":"Test Corp"'), 'JSON should contain the name.');
        System.assert(jsonString.contains('"cvr":"12345678"'), 'JSON should contain the cvr.');
        System.assert(jsonString.contains('"type":"ORGANIZATION"'), 'JSON should contain the type.');
        System.assert(jsonString.contains('"streetName":"Test Street"'), 'JSON should contain the streetName.');
    }
}