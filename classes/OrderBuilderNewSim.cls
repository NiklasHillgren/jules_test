public with sharing class OrderBuilderNewSim {
    public OrderBuilder.OrderPartBuilder builder;

    public OrderBuilder.OrderItemListBuilder orderItemListBuilder;

    public OrderBuilder.SubscriptionItemBuilder subscriptionItemBuilder;

    public OrderBuilderNewSim(OrderBuilder.OrderPartBuilder builder) {
        this.builder = builder;

        this.orderItemListBuilder = new OrderBuilder.orderItemListBuilder();
    }

    public OrderBuilderNewSim withSubscription() {
        this.builder.withType(OrderClientConstants.OrderPartTypeEnum.SUBSCRIPTION)
            .withActivity(OrderClientConstants.OrderPartActivityEnum.CREATE);

        return this;
    }

    public OrderBuilderNewSim withSubscriptionItem() {
        if (subscriptionItemBuilder == null) {
            subscriptionItemBuilder = new OrderBuilder.SubscriptionItemBuilder();
        }

        //Setting properties that is common for the OrderItem - since they will not return the subscriptionItemBuilder
        //But the OrderItemBuilder they cannot be chained!
        subscriptionItemBuilder
            .withType(OrderClientConstants.OrderItemTypeEnum.SUBSCRIPTION_ITEM)
            .withActivity(OrderClientConstants.OrderItemActivityEnum.CREATE);

        //Setting stuff only related to the subscriptionItemBuilder
        subscriptionItemBuilder.withProductType(OrderClientConstants.SubscriptionItemProductTypeEnum.MOBILE_VOICE)
            .withPublishLevel(OrderClientConstants.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED)
            .withTelephoneNumberBuilder(
                new OrderBuilder.TelephoneNumberBuilder().withCountryCode('45').withPhoneNumber('28968332')
            )
            .withTelephoneNumberCategory(OrderClientConstants.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE);

        return this;
    }

    public OrderBuilderNewSim withCampaign() {
        if (subscriptionItemBuilder == null) {
            subscriptionItemBuilder = new OrderBuilder.SubscriptionItemBuilder();
        }

        subscriptionItemBuilder.withNewOffering(
            new OrderBuilder.OfferingBuilder().withPriceplan('CHAMPEBA').withCampaign('CHAMPEBAS')
        );

        return this;
    }

    public OrderClientDTO.OrderPart build() {
        this.builder.withOrderItemListBuilder(orderItemListBuilder);
        orderItemListBuilder.withOrderItemBuilder(subscriptionItemBuilder);

        return builder.build();
    }

    /*
      "orderParts": [
        {
          "orderItems": [
            {
              "publishLevel": "ALL_INFORMATION_PROVIDED",
              "productType": "MOBILE_VOICE",
              "subscriptionUser": {
                "firstName": "Mirka",
                "lastName": "Havrlantova",
                "birthDate": "1987-08-08",
                "email": "miroslava.havrlantova@teliacompany.com",
                "address": {
                  "streetName": "Rubyvej",
                  "streetNumber": "8",
                  "city": "Odense N",
                  "zipCode": "5270",
                  "coName": "Odense N",
                  "country": "DNK"
                }
              }
            },
            {
              "type": "ADDITIONAL_PRODUCT_ITEM",
              "activity": "CREATE",
              "productCode": "5012323",
              "productCategory": "SIM",
              "quantity": 1,
              "hardwareDetails": {
                "materialId": "5012323",
                "hardwareType": "SIM",
                "name": "micro SIM"
              },
              "shippingDetails": {
                "toDeliverQuantity": 1,
                "hardwareDeliveryId": 1
              },
              "simDetails": {
                "simType": "MAIN_ELECTRONIC_SIM"
              }
            }
          ]
        }
      ]
    }
      */
}