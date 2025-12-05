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
public with sharing class OrderProductPorting implements OrderProductBuilder {
    private final OrderService orderService;

    public OrderProductPorting() {
        this(SingletonFactory.getFactory());
    }

    private OrderProductPorting(SingletonFactory singletonFactory) {
        this.orderService = (OrderService) singletonFactory.getOrRegisterSingleton(OrderService.class);
    }

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

        // we need telephone builder for the 
        OrderBuilder.TelephoneNumberBuilder telephoneNumberBuilder = new OrderBuilder.TelephoneNumberBuilder();
        telephoneNumberBuilder
            .withPhoneNumber(activationLine.Mobile_no__c)
            .withCountryCode('45'); // 45 in confluence

        // TODO we won't have location lines, so we should actually not even consider location line in the logic
        // if locationLine is filled out in the Activation Line and it has a subscription Product, 
        // use that, otherwise use the priceplan in the activation line
        // Location_Line__c locationLine = locationLineMap.get(activationLine.Location_Line__c);
        // String priceplan = (locationLine != null && locationLine.Subscription_product__c != null) ? locationLine.Subscription_product__c : activationLine.Priceplan_Code__c;

        OrderBuilder.OfferingBuilder offeringBuilder = new OrderBuilder.OfferingBuilder();
        offeringBuilder
            .withPriceplan(activationLine.Priceplan_Code__c)
            .withCampaign('COR1TB24');  // TODO what is campaign
            // TODO productOfferingId is according to mapping confluence '100010308' (Only in the number porting call)

        OrderBuilder.SubscriptionUserBuilder subscriptionUserBuilder =  new OrderBuilder.SubscriptionUserBuilder(); 
        subscriptionUserBuilder
            .withFirstName(activationLine.First_Name__c)
            .withLastName(activationLine.Last_Name__c)
            .withEmail(activationLine.Email__c);
            // TODO what about type PERSON, wait for Borak

        OrderBuilder.SubscriptionItemBuilder subscriptionItemBuilder = new OrderBuilder.SubscriptionItemBuilder();
        subscriptionItemBuilder
            .withTelephoneNumberBuilder(telephoneNumberBuilder)
            .withTelephoneNumberCategory(OrderClientDTOConstants.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE)
            .withNewOfferingBuilder(offeringBuilder)
            .withSubscriptionUserBuilder(subscriptionUserBuilder)
            .withPublishLevel(OrderClientDTOConstants.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED)
            .withProductDeliveryAsap(activationLine.Express_Delivery__c)  // use Express_Delivery__c from activation line confluence mapping
            .withId(0)
            .withActivity(OrderClientDTOConstants.OrderItemActivityEnum.CREATE);
        
        orderItemListBuilder.withOrderItemBuilder(subscriptionItemBuilder);

        // ensure that we have VAS if any, SIM (how many?) and PORTING DETAILS

        // ADDITIONAL PRODUCT ITEMS - ADDITIONAL_PRODUCT_ITEM (could be many) for VAS

        List<String> productApiTeliaProductIdsTrue = orderService.getProductApiTeliaProductIdsForTrueVasFields(activationLine);
        Logger.logInfo('OrderProductPorting productApiTeliaProductIdsTrue: ' + productApiTeliaProductIdsTrue);

        // for each VAS_ field (mobile relevant) that is True, we will add an Additional Product Item
        for (String productApiTeliaProductIdTrue : productApiTeliaProductIdsTrue) {
            OrderBuilder.AdditionalProductItemBuilder additionalProductItemBuilderVAS = new OrderBuilder.AdditionalProductItemBuilder();
            // the productCode is merely the substring of the VAS_ field's API Name
            // i.e. VAS_CORDKTOEU__c will become 'CORDKTOEU' and this is a ProductAPI_Telia_Product_Id__c value on a Product2 record
            String productCode = productApiTeliaProductIdTrue;

            additionalProductItemBuilderVAS
                .withProductCode(productCode)
                .withProductCategory(OrderClientDTOConstants.AdditionalProductItemProductCategoryEnum.VAS)
                .withQuantity(1)  // for ADDITIONAL_PRODUCT_ITEM quantity is always 1
                .withActivity(OrderClientDTOConstants.OrderItemActivityEnum.CREATE)
                .withType(OrderClientDTOConstants.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM);
                // .withId(0);  OrderAPI assigns this id. 

            orderItemListBuilder.withOrderItemBuilder(additionalProductItemBuilderVAS);
        }

        // ADDITIONAL PRODUCT ITEMS - ADDITIONAL_PRODUCT_ITEM (could be many?) for SIM

        OrderBuilder.SimDetailsBuilder simDetailsBuilder = new OrderBuilder.SimDetailsBuilder();
        simDetailsBuilder
            .withSimType(OrderClientDTOConstants.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM)
            .withIcc(activationLine.SIM_number__c);  // when icc is present, then we can omit shippingDetails
            // TODO await niklas for the waiveSimSwapFee

        OrderBuilder.AdditionalProductItemBuilder additionalProductItemBuilderSIM = new OrderBuilder.AdditionalProductItemBuilder();
        additionalProductItemBuilderSIM
            .withProductCode('dummy') // TODO decision to fetch from custom metadata type, we still need the code
            .withProductCategory(OrderClientDTOConstants.AdditionalProductItemProductCategoryEnum.SIM)
            .withQuantity(1)  // for ADDITIONAL_PRODUCT_ITEM quantity is always 1
            .withSimDetailsBuilder(simDetailsBuilder)
            .withType(OrderClientDTOConstants.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM)
            .withActivity(OrderClientDTOConstants.OrderItemActivityEnum.CREATE);
            // id: Borak has confirmed this can be omitted for SIM ADDITIONAL_PRODUCT_ITEM

        orderItemListBuilder.withOrderItemBuilder(additionalProductItemBuilderSIM);

        // PORTING DETAILS ITEM - PORTING_DETAILS_ITEM

        // check if we have POA document for this activation line
        Boolean poaManualHandling = false;
        if (orderService.getPoaDocumentIdByActivationLine(activationLine) == null) {
            Logger.logInfo('OrderProductPorting: No POA document found for Activation Line Id: ' + activationLine.Id);
            poaManualHandling = true;
        }
        OrderBuilder.PortingDetailsItemBuilder portingDetailsItemBuilder = new OrderBuilder.PortingDetailsItemBuilder();
        portingDetailsItemBuilder
            .withDonorSimNumber(activationLine.Existing_SIM_number__c) // this is Existing_SIM_number__c, not SIM_number__c
            .withPoaDocumentId(orderService.getPoaDocumentIdByActivationLine(activationLine))
            .withPoaDocumentUrl(orderService.getPoaDocumentURLByActivationLine(activationLine))  // do NOT use POA__c
            .withPowerOfAttorneyManualHandling(poaManualHandling) 
            .withEarliestPortingDate(System.now().date()) // TODO decide which option we will do, see confluence.  activationLine.Power_of_Attorney_record__r.Porting_Day__c (this is a text field, and we might not always be successful in parsing it to a date if it holds 'this is gonna be hard to parse')
            .withActivity(OrderClientDTOConstants.OrderItemActivityEnum.CREATE);
            // id ReadOnly. OrderAPI fills, so we can omit
        
        orderItemListBuilder.withOrderItemBuilder(portingDetailsItemBuilder);

        // we can now assemble all pieces
        // add the order items list builder to the list on the order part builder for Level 2 order part
        innerOrderPartBuilder.withOrderItemListBuilder(orderItemListBuilder);

        return innerOrderPartBuilder;
    }
    
    // TODO porting does not have the hardwareDeliveries in the node, so can we leave this method like this?
    public OrderBuilder.HardwareDeliveryBuilder createHardwareDeliveryBuilder(
        Activation_line__c activationLine
    ) {
        OrderBuilder.HardwareDeliveryBuilder hardwareDeliveryBuilder = new OrderBuilder.HardwareDeliveryBuilder();
        return hardwareDeliveryBuilder;
    }

}