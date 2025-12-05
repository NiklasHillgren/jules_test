/**
 * @description 
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
public with sharing class OrderProductPhysicalSim implements OrderProductBuilder {
    private final OrderService orderService;

    public OrderProductPhysicalSim() {
        this(SingletonFactory.getFactory());
    }

    private OrderProductPhysicalSim(SingletonFactory singletonFactory) {
        this.orderService = (OrderService) singletonFactory.getOrRegisterSingleton(OrderService.class);
    }
    
    /**
     * @description
     * Creates and returns an OrderPartBuilder for Physical SIM activation lines.
     * This includes setting up the subscription item and additional product
     * item for the SIM.
     * @param hardwareDeliveryId  The ID of the hardware delivery associated
     *                            with the Physical SIM.
     * @param activationLine      The Activation_line__c record containing details
     *                            for building the OrderPartBuilder.
     * @return OrderBuilder.OrderPartBuilder
     *         The constructed OrderPartBuilder for the Physical SIM order.
     */
    public OrderBuilder.OrderPartBuilder createProductOrderPartBuilder(
        Integer hardwareDeliveryId,
        Activation_line__c activationLine
    ) {  
        OrderBuilder.OrderPartBuilder innerOrderPartBuilder = new OrderBuilder.OrderPartBuilder()
            .withId(0)
            .withActivity(OrderClientDTOConstants.OrderPartActivityEnum.CREATE)
            .withType(OrderClientDTOConstants.OrderPartTypeEnum.SUBSCRIPTION);
            
        // order item list builder will hold orderItemBuilder entries (i.e. SubscriptionItemBuilder, AdditionalProductItemBuilder, PortingDetailsItemBuilder)
        OrderBuilder.OrderItemListBuilder orderItemListBuilder = new OrderBuilder.OrderItemListBuilder();
            
        // SUBSCRIPTION ITEM - SUBSCRIPTION_ITEM        
        orderItemListBuilder.withOrderItemBuilder(getSubscriptionItemBuilder(activationLine));

        // ensure that we have VAS if any, SIM (how many?) and PORTING DETAILS
        // TODO do we have VAS on physical sim?
        // ADDITIONAL PRODUCT ITEMS - ADDITIONAL_PRODUCT_ITEM (could be many) for VAS
        
        // TODO do we have many SIMs on physical sim?

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
     * @param activationLine  The Activation_line__c record containing details
     *                        for building the SubscriptionItemBuilder.
     * @return OrderBuilder.SubscriptionItemBuilder
     *         The constructed SubscriptionItemBuilder.
     */
    private OrderBuilder.SubscriptionItemBuilder getSubscriptionItemBuilder(Activation_line__c activationLine) {

        // we need telephone builder for the 
        OrderBuilder.TelephoneNumberBuilder telephoneNumberBuilder = new OrderBuilder.TelephoneNumberBuilder();
        telephoneNumberBuilder
            .withPhoneNumber(activationLine.Mobile_no__c)
            .withCountryCode('45');

        // Currently commented out, but is should come from Fokus based on the product ID present in the location

        // Fokus_Campaign__c campaign = campaignsByProductIds.get(location.Subscription_product__c);
        // if (campaign != null) {
            // newOffering.campaign = campaign.Campaign_Id__c;
        // }


        String campaign = 'COR1TB24';  // TODO what is campaign

        OrderBuilder.OfferingBuilder offeringBuilder = new OrderBuilder.OfferingBuilder();
        offeringBuilder
            .withPriceplan(activationLine.Priceplan_Code__c)
            .withCampaign(campaign);  // TODO what is campaign

        OrderBuilder.SubscriptionUserBuilder subscriptionUserBuilder =  new OrderBuilder.SubscriptionUserBuilder(); 
        subscriptionUserBuilder
            .withFirstName(activationLine.First_Name__c)
            .withLastName(activationLine.Last_Name__c)
            .withEmail(activationLine.Email__c);
            // we don't need Address on the subscription user

        OrderBuilder.SubscriptionItemBuilder subscriptionItemBuilder = new OrderBuilder.SubscriptionItemBuilder();
        subscriptionItemBuilder
            .withTelephoneNumberBuilder(telephoneNumberBuilder)
            .withTelephoneNumberCategory(OrderClientDTOConstants.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE)
            .withNewOfferingBuilder(offeringBuilder)
            .withSubscriptionUserBuilder(subscriptionUserBuilder)
            .withProductType(OrderClientDTOConstants.SubscriptionItemProductTypeEnum.MOBILE_VOICE)
            .withPublishLevel(OrderClientDTOConstants.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED)
            .withActivity(OrderClientDTOConstants.OrderItemActivityEnum.CREATE);

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
        OrderBuilder.HardwareDetailsBuilder hardwareDetailsBuilder = new OrderBuilder.HardwareDetailsBuilder();
        hardwareDetailsBuilder
            .withHardwareType(OrderClientDTOConstants.HardwareType.SIM)
            .withMaterialId('5012323');  // TODO still to understand what this value should be
            // name can be omitted on hardware details

        OrderBuilder.SimDetailsBuilder simDetailsBuilder = new OrderBuilder.SimDetailsBuilder();
        simDetailsBuilder.withSimType(OrderClientDTOConstants.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM);
        
        OrderBuilder.ShippingDetailsBuilder shippingDetailsBuilder = new OrderBuilder.ShippingDetailsBuilder();
        shippingDetailsBuilder
            .withHardwareDeliveryId(hardwareDeliveryId)  // value is a reference to the HardwareDelivery id we create elsewhere
            .withToDeliverQuantity(1);  // 1
            // we don't need erpTsProduct
            // we don't need tsfOffering

        OrderBuilder.AdditionalProductItemBuilder additionalProductItemBuilderSIM = new OrderBuilder.AdditionalProductItemBuilder();
        additionalProductItemBuilderSIM
            .withProductCategory(OrderClientDTOConstants.AdditionalProductItemProductCategoryEnum.SIM)
            .withQuantity(1)  // always 1
            .withHardwareDetailsBuilder(hardwareDetailsBuilder)
            .withSimDetailsBuilder(simDetailsBuilder)
            .withShippingDetailsBuilder(shippingDetailsBuilder)
            .withActivity(OrderClientDTOConstants.OrderItemActivityEnum.CREATE);

        return additionalProductItemBuilderSIM;
    }
    
    /**
     * @description
     * Creates and returns a HardwareDeliveryBuilder based on the provided
     * Activation_Line__c record.
     * @param activationLine  The Activation_Line__c record containing details
     *                        for the hardware delivery.
     * @return OrderBuilder.HardwareDeliveryBuilder
     *         The constructed HardwareDeliveryBuilder for the order.
     */
    public OrderBuilder.HardwareDeliveryBuilder createHardwareDeliveryBuilder(Activation_line__c activationLine) {
        OrderBuilder.HardwareDeliveryBuilder hardwareDeliveryBuilder = new OrderBuilder.HardwareDeliveryBuilder();

        // TODO which field on which object to use. does this come from AL or Account?
        // inner object node for recipientPartyRoleBuilder
        OrderBuilder.TelephoneNumberBuilder recipientPartyTelephoneNumberBuilder = new OrderBuilder.TelephoneNumberBuilder();
        recipientPartyTelephoneNumberBuilder
            .withCountryCode('45')
            .withPhoneNumber(activationLine.Mobile_no__c);

        // inner object node for recipientPartyRoleBuilder - from Account
        OrderBuilder.DanishAddressBuilder recipientPartyAddressBuilder = new OrderBuilder.DanishAddressBuilder();

        recipientPartyAddressBuilder
            // .withAttention(???) // TODO for Address what is property attention, could it maybe be the name from Activation Line?
            .withStreetName(orderService.getAccount().Billing_Street_Name__c)
            .withStreetNumber(orderService.getAccount().Billing_Street_Number__c)
            .withStreetNumberSuffix(orderService.getAccount().Billing_Street_Number_Suffix__c)
            .withFloorNumber(orderService.getAccount().Billing_Floor_Number__c)
            .withDoorNumber(orderService.getAccount().Billing_Door_Number__c)
            .withCity(orderService.getAccount().BillingCity)
            .withZipCode(orderService.getAccount().BillingPostalCode)
            // .withDirection(what is this)  // TODO for Address what is property direction
            .withCountry('DNK');

        // OrganizationBuilder extends PartyRoleBuilder
        OrderBuilder.OrganizationBuilder recipientPartyRoleBuilder = new OrderBuilder.OrganizationBuilder();  // type is ORGANIZATION
        recipientPartyRoleBuilder
            .withCvr(orderService.getAccount().CVR__c)
            .withName(orderService.getAccount().Name)
            .withTelephoneNumberBuilder(recipientPartyTelephoneNumberBuilder)
            .withAddressBuilder(recipientPartyAddressBuilder);
            // .withEmail(from AL or Account???);  // TODO which field on which object to use. email property sits on the PartyRoleBuilder so call withEmail as the last

        hardwareDeliveryBuilder
            .withDeliveryMethod('POST')
            .withPreferredContactMethod(OrderClientDTOConstants.HardwareDeliveryPreferredContactMethodEnum.PHONE)
            .withRecipientPartyRoleBuilder(recipientPartyRoleBuilder);

        return hardwareDeliveryBuilder;
    }

}