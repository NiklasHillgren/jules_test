/**
 * @description 
 * Class to build Order Parts for New Number activation lines.
 * 
 *  -----------------------------------------------------------------------------
 *  Developer                   Date            Description
 *  -----------------------------------------------------------------------------
 *  Kirstine Nielsen            2025-11-20      Initial version
 * 
 * @author Kirstine Nielsen
 * @version 1.0 - Initial version
 * @since 2025-11-20
 */
public with sharing class OrderProductNewNumber implements OrderProductBuilder {
    private final OrderService orderService;

    public OrderProductNewNumber() {
        this(SingletonFactory.getFactory());
    }

    private OrderProductNewNumber(SingletonFactory singletonFactory) {
        this.orderService = (OrderService) singletonFactory.getOrRegisterSingleton(OrderService.class);
    }

    /**
     * @description
     * Creates and returns an OrderPartBuilder for a New Number activation.
     * This includes building the necessary order items such as Subscription
     * and Additional Product items (SIM).
     * @param hardwareDeliveryId  The ID of the hardware delivery associated
     *                            with the order.
     * @param activationLine      The Activation_Line__c record containing
     *                            details for the order part.
     * @return OrderBuilder.OrderPartBuilder
     *         The constructed OrderPartBuilder for the New Number order.
     */
    public OrderBuilder.OrderPartBuilder createProductOrderPartBuilder(
        Integer hardwareDeliveryId,
        Activation_line__c activationLine
    ) {
        OrderBuilder.OrderPartBuilder innerOrderPartBuilder = new OrderBuilder.OrderPartBuilder()
            .withActivity(OrderClientDTOConstants.OrderPartActivityEnum.CREATE)
            .withType(OrderClientDTOConstants.OrderPartTypeEnum.SUBSCRIPTION);   
            
        // order item list builder will hold orderItemBuilder entries (i.e. SubscriptionItemBuilder, AdditionalProductItemBuilder, PortingDetailsItemBuilder)
        OrderBuilder.OrderItemListBuilder orderItemListBuilder = new OrderBuilder.OrderItemListBuilder();        
        
        // SUBSCRIPTION ITEM - SUBSCRIPTION_ITEM
        orderItemListBuilder.withOrderItemBuilder(getSubscriptionItemBuilder(activationLine));

        // ensure that we have VAS if any, SIM (how many?) and PORTING DETAILS

        // TODO do we have VAS on new number?
        // ADDITIONAL PRODUCT ITEMS - ADDITIONAL_PRODUCT_ITEM (could be many) for VAS

        // TODO do we have many SIMs on new number?

        // ADDITIONAL PRODUCT ITEMS - ADDITIONAL_PRODUCT_ITEM (could be many?) for SIM        
        orderItemListBuilder.withOrderItemBuilder(getAdditionalProductItemBuilderSIM(hardwareDeliveryId));

        // add the order items list builder to the list on the order part builder for Level 2 order part
        innerOrderPartBuilder.withOrderItemListBuilder(orderItemListBuilder);

        return innerOrderPartBuilder;
    }

    /**
     * @description
     * Private helper method to create and return a SubscriptionItemBuilder
     * based on the provided Activation Line.
     * @param activationLine  The Activation_Line__c record containing details
     *                        for building the SubscriptionItemBuilder.
     * @return OrderBuilder.SubscriptionItemBuilder
     *         The constructed SubscriptionItemBuilder.
     */
    private OrderBuilder.SubscriptionItemBuilder getSubscriptionItemBuilder(Activation_line__c activationLine) {
        OrderBuilder.TelephoneNumberBuilder telephoneNumberBuilder = new OrderBuilder.TelephoneNumberBuilder();
        telephoneNumberBuilder
            .withPhoneNumber(activationLine.Mobile_no__c)
            .withCountryCode('45');

        OrderBuilder.OfferingBuilder offeringBuilder = new OrderBuilder.OfferingBuilder();
        offeringBuilder
            .withPriceplan(activationLine.Priceplan_Code__c)
            .withCampaign('COR1TB24');  // TODO what is campaign
            // we don't need name

        OrderBuilder.SubscriptionUserBuilder subscriptionUserBuilder =  new OrderBuilder.SubscriptionUserBuilder(); 
        subscriptionUserBuilder
            .withLastName(activationLine.Last_Name__c)
            .withEmail(activationLine.Email__c);
            // we don't need Address
            // we don't need BirthDate
            
        OrderBuilder.SubscriptionItemBuilder subscriptionItemBuilder = new OrderBuilder.SubscriptionItemBuilder();
        subscriptionItemBuilder
            .withTelephoneNumberBuilder(telephoneNumberBuilder)
            .withTelephoneNumberCategory(OrderClientDTOConstants.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE)
            .withNewOfferingBuilder(offeringBuilder)
            .withProductType(OrderClientDTOConstants.SubscriptionItemProductTypeEnum.MOBILE_VOICE)
            .withSubscriptionUserBuilder(subscriptionUserBuilder)
            .withPublishLevel(OrderClientDTOConstants.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED)
            .withActivity(OrderClientDTOConstants.OrderItemActivityEnum.CREATE);            
            // we don't need timePeriod

        return subscriptionItemBuilder;
    }

    /**
     * @description
     * Private helper method to create and return an AdditionalProductItemBuilder
     * for a SIM based on the provided hardwareDeliveryId.
     * @param hardwareDeliveryId  The ID of the hardware delivery associated
     *                            with the SIM.
     * @return OrderBuilder.AdditionalProductItemBuilder
     *         The constructed AdditionalProductItemBuilder for the SIM.
     */
    private OrderBuilder.AdditionalProductItemBuilder getAdditionalProductItemBuilderSIM(Integer hardwareDeliveryId) {        
        OrderBuilder.SimDetailsBuilder simDetailsBuilder = new OrderBuilder.SimDetailsBuilder();
        simDetailsBuilder.withSimType(OrderClientDTOConstants.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM);
        
        OrderBuilder.ShippingDetailsBuilder shippingDetailsBuilder = new OrderBuilder.ShippingDetailsBuilder();
        shippingDetailsBuilder
            .withHardwareDeliveryId(hardwareDeliveryId)  // value is a reference to the HardwareDelivery id we create elsewhere
            .withToDeliverQuantity(1);  // 1
            // we don't need erpTsProduct
            // we don't need tsfOffering

        OrderBuilder.HardwareDetailsBuilder hardwareDetailsBuilder = new OrderBuilder.HardwareDetailsBuilder();
        hardwareDetailsBuilder
            .withHardwareType(OrderClientDTOConstants.HardwareType.SIM)
            .withMaterialId('9064434');  // TODO move it to a constant. still to understand what this value should be
            // we don't need name

        OrderBuilder.AdditionalProductItemBuilder additionalProductItemBuilderSIM = new OrderBuilder.AdditionalProductItemBuilder();
        additionalProductItemBuilderSIM
            .withProductCategory(OrderClientDTOConstants.AdditionalProductItemProductCategoryEnum.SIM)
            .withQuantity(1) // always 1
            .withSimDetailsBuilder(simDetailsBuilder)
            .withShippingDetailsBuilder(shippingDetailsBuilder)
            .withHardwareDetailsBuilder(hardwareDetailsBuilder)
            .withActivity(OrderClientDTOConstants.OrderItemActivityEnum.CREATE);
            // we don't need name id: Borak has confirmed this can be omitted for SIM ADDITIONAL_PRODUCT_ITEM

        return additionalProductItemBuilderSIM;
    }
    
    /**
     * @description
     * Creates and returns a HardwareDeliveryBuilder for the New Number activation line.
     * This includes setting up the recipient party details based on the
     * activation line and account information.
     * @param activationLine  The Activation_Line__c record containing details
     *                        for the hardware delivery.
     * @return OrderBuilder.HardwareDeliveryBuilder
     *         The constructed HardwareDeliveryBuilder for the New Number order.
     */
    public OrderBuilder.HardwareDeliveryBuilder createHardwareDeliveryBuilder(Activation_line__c activationLine) {
        OrderBuilder.HardwareDeliveryBuilder hardwareDeliveryBuilder = new OrderBuilder.HardwareDeliveryBuilder();

        // inner object node for recipientPartyRoleBuilder
        OrderBuilder.TelephoneNumberBuilder recipientPartyTelephoneNumberBuilder = new OrderBuilder.TelephoneNumberBuilder();
        recipientPartyTelephoneNumberBuilder
            .withCountryCode('45')
            .withPhoneNumber(activationLine.Mobile_no__c);

        // inner object node for recipientPartyRoleBuilder - from Account
        OrderBuilder.DanishAddressBuilder recipientPartyAddressBuilder = new OrderBuilder.DanishAddressBuilder();
        recipientPartyAddressBuilder
            .withStreetName(orderService.getAccount().Billing_Street_Name__c)
            .withStreetNumber(orderService.getAccount().Billing_Street_Number__c)
            .withStreetNumberSuffix(orderService.getAccount().Billing_Street_Number_Suffix__c)
            .withFloorNumber(orderService.getAccount().Billing_Floor_Number__c)
            .withDoorNumber(orderService.getAccount().Billing_Door_Number__c)
            .withCity(orderService.getAccount().BillingCity)
            .withZipCode(orderService.getAccount().BillingPostalCode)
            .withCountry('DNK');

        // PersonBuilder extends PartyRoleBuilder
        OrderBuilder.PersonBuilder recipientPartyRoleBuilder = new OrderBuilder.PersonBuilder();  // type is PERSON
        recipientPartyRoleBuilder
            .withFirstName(activationLine.First_Name__c)
            .withLastName(activationLine.Last_Name__c)
            .withTelephoneNumberBuilder(recipientPartyTelephoneNumberBuilder)
            .withAddressBuilder(recipientPartyAddressBuilder)
            .withEmail(activationLine.Email__c);  // email property sits on the PartyRoleBuilder so call withEmail as the last

        hardwareDeliveryBuilder
            .withDeliveryMethod('POST')
            .withPreferredContactMethod(OrderClientDTOConstants.HardwareDeliveryPreferredContactMethodEnum.PHONE)
            .withRecipientPartyRoleBuilder(recipientPartyRoleBuilder);
            // we can omit deliveryPrice
            // we can omit billing party

        return hardwareDeliveryBuilder;
    }
}