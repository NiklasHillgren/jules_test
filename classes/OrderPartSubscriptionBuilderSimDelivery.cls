public with sharing class OrderPartSubscriptionBuilderSimDelivery extends OrderPartSubscriptionBuilder {
    public OrderClientDTO.AdditionalProductItem sim;

    public OrderPartSubscriptionBuilderSimDelivery(){
    }

    public OrderPartSubscriptionBuilderSimDelivery withSubscriptionItemProductTypeMobileVoice() {
        subItem.productType = OrderClientConstants.SubscriptionItemProductTypeEnum.MOBILE_VOICE;
        return this;
    }

    public OrderPartSubscriptionBuilderSimDelivery withSIM() {
        sim = new OrderClientDTO.AdditionalProductItem();
        sim.type = OrderClientConstants.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM;
        sim.activity = OrderClientConstants.OrderItemActivityEnum.CREATE;
        sim.productCategory = OrderClientConstants.AdditionalProductItemProductCategoryEnum.SIM;
        sim.quantity = 1;

        sim.hardwareDetails = new OrderClientDTO.HardwareDetails();
        sim.hardwareDetails.materialId = '9064434';
        sim.hardwareDetails.hardwareType = OrderClientConstants.HardwareType.SIM;
        sim.hardwareDetails.name = 'micro SIM';

        sim.shippingDetails = new OrderClientDTO.ShippingDetails();
        sim.shippingDetails.toDeliverQuantity = 1;
        sim.shippingDetails.tsfOffering = 'TSF1005448';
        sim.shippingDetails.erpTsProduct = 'TSF1005448';
        sim.shippingDetails.hardwareDeliveryId = 1;

        sim.simDetails = new OrderClientDTO.SimDetails();
        sim.simDetails.simType = OrderClientConstants.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM;

        return this;
    }
}