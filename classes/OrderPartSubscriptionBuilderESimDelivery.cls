public with sharing class OrderPartSubscriptionBuilderESimDelivery extends OrderPartSubscriptionBuilder {
    public OrderClientDTO.AdditionalProductItem sim;

    public OrderPartSubscriptionBuilderESimDelivery() {
    }

    public OrderPartSubscriptionBuilderESimDelivery withSubscriptionItemProductTypeMobileVoice() {
        subItem.productType = OrderClientConstants.SubscriptionItemProductTypeEnum.MOBILE_VOICE;
        return this;
    }

    public OrderPartSubscriptionBuilderESimDelivery withSIM() {
        sim = new OrderClientDTO.AdditionalProductItem();
        sim.type = OrderClientConstants.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM;
        sim.activity = OrderClientConstants.OrderItemActivityEnum.CREATE;
        sim.productCode = '5012323'; //TODO
        sim.productCategory = OrderClientConstants.AdditionalProductItemProductCategoryEnum.SIM;
        sim.quantity = 1;

        sim.hardwareDetails = new OrderClientDTO.HardwareDetails();
        sim.hardwareDetails.materialId = '5012323';
        sim.hardwareDetails.hardwareType = OrderClientConstants.HardwareType.SIM;
        sim.hardwareDetails.name = 'micro SIM';

        sim.shippingDetails = new OrderClientDTO.ShippingDetails();
        sim.shippingDetails.toDeliverQuantity = 1;
        sim.shippingDetails.hardwareDeliveryId = 1;

        sim.simDetails = new OrderClientDTO.SimDetails();
        sim.simDetails.simType = OrderClientConstants.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM;

        return this;
    }
}