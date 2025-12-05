public class OrderPartSubscriptionBuilderNewNumber extends OrderPartSubscriptionBuilder {
    public OrderClientDTO.AdditionalProductItem sim;

    public override OrderClientDTO.OrderPart buildOrderPart() {
        this.orderPart.orderItems.add(subItem);
        this.orderPart.orderItems.add(sim);

        return this.orderPart;
    }

    public OrderPartSubscriptionBuilderNewNumber withSubscriptionItemProductTypeMobileVoice() {
        subItem.productType = OrderClientConstants.SubscriptionItemProductTypeEnum.MOBILE_VOICE;
        return this;
    }

    public OrderPartSubscriptionBuilderNewNumber withSubscriptionItemTerminationPeriod( Integer amount, OrderClientConstants.TimeUnit unit ){
        OrderClientDTO.TimePeriod tPeriod = new OrderClientDTO.TimePeriod();
        tPeriod.amount = amount;
        tPeriod.unit = unit;
        
        //ADD THE TIMEPERIOD TO THE SUBSCRIPTION ITEM NODE
        subItem.terminationPeriod = tPeriod;

        return this;
    }

    public OrderPartSubscriptionBuilderNewNumber withSIM() {
        sim = new OrderClientDTO.AdditionalProductItem();
        sim.type = OrderClientConstants.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM;
        sim.productCategory = OrderClientConstants.AdditionalProductItemProductCategoryEnum.SIM;
        sim.activity = OrderClientConstants.OrderItemActivityEnum.CREATE;
        sim.id = 0;
        sim.quantity = 1;
        sim.simDetails = new OrderClientDTO.SimDetails();
        sim.simDetails.simType = OrderClientConstants.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM;

        //TODO FIGURE OUT DATA
        sim.productCode = '9047807'; //TODO


        return this;
    }

    public OrderPartSubscriptionBuilderNewNumber withSIMHardwareDetails(){
        sim.hardwareDetails = new OrderClientDTO.HardwareDetails();
        sim.hardwareDetails.materialId = '9064434';
        sim.hardwareDetails.hardwareType = OrderClientConstants.HardwareType.SIM;
        sim.hardwareDetails.name = 'micro SIM';

        return this;
    }

    public OrderPartSubscriptionBuilderNewNumber withSIMShippingDetails(){
        sim.shippingDetails = new OrderClientDTO.ShippingDetails();
        sim.shippingDetails.toDeliverQuantity = 1;
        sim.shippingDetails.tsfOffering = 'TSF1005448';
        sim.shippingDetails.erpTsProduct = 'TSA1000159';
        sim.shippingDetails.hardwareDeliveryId = 1;
    
        return this;
    }
}