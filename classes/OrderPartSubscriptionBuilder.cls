public virtual class OrderPartSubscriptionBuilder {
    public OrderClientDTO.OrderPart orderPart;
    public OrderClientDTO.SubscriptionItem subItem = new OrderClientDTO.SubscriptionItem();

    public virtual OrderClientDTO.OrderPart buildOrderPart(){
        orderPart.orderItems.add(subItem);
        return orderPart;
    }

    public OrderPartSubscriptionBuilder(){
        createSubscriptionOrderPart();
        createSubscriptionItem();
    }

    // THE ROOT OF THE SUBSCRIPTION IS CREATED HERE!
    private void createSubscriptionOrderPart(){
        orderPart = new OrderClientDTO.OrderPart();
        orderPart.activity = OrderClientConstants.OrderPartActivityEnum.CREATE;
        orderPart.type = OrderClientConstants.OrderPartTypeEnum.SUBSCRIPTION;
        orderPart.id = 0;
        orderPart.orderItems = new List<OrderClientDTO.OrderItem>();
    }

    //EACH SUBSCRIPTION HAS AN ORDERPART!
    private void createSubscriptionItem(){
        subItem.type = OrderClientConstants.OrderItemTypeEnum.SUBSCRIPTION_ITEM;
        subItem.telephoneNumberCategory = OrderClientConstants.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE;
        subItem.publishLevel = OrderClientConstants.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED;
        subItem.productDeliveryAsap = false;
        subItem.activity = OrderClientConstants.OrderItemActivityEnum.CREATE;
        subItem.id = 0;
    }

    public OrderPartSubscriptionBuilder withSubscriptionItemUser(
        String firstName,
        String lastName,
        OrderClientDTO.Address addr,
        Date birthday,
        String email
    ) {
        subItem.subscriptionUser = new OrderClientDTO.SubscriptionUser();
        subItem.subscriptionUser.firstName = 'Bob';
        subItem.subscriptionUser.lastName = 'Bobsen';
        subItem.subscriptionUser.email = 'email@datadog.com';
        subItem.subscriptionUser.address = addr;

        return this;
    }

    public OrderPartSubscriptionBuilder withSubscriptionItemTelephoneNumber(String phone){
        subItem.telephoneNumber = new OrderClientDTO.TelephoneNumber();
        subItem.telephoneNumber.areaCode = '+45';
        subItem.telephoneNumber.localNumber = phone;

        return this;
    }

    public OrderPartSubscriptionBuilder withSubscriptionItemNewOffering(String pricePlan, String campaign){
        OrderClientDTO.Offering off = new OrderClientDTO.Offering();

        //TODO FIGURE OUT DATA ABOUT THE FOLLOWING FIELDS
        off.priceplan = pricePlan; // 'CORFRI1TB'; if location is filled out in the Activation Line and it has a subscription Product, use that otherwise use the priceplan in the activation line
        off.campaign = 'COR1TB24';
        off.name = '100010308';
        //off.productOfferingId = '100010308' MISSING IN SWAGGER

        subItem.newOffering = off;

        return this;
    }
}