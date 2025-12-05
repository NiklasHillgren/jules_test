public with sharing class OrderPartBuilderPortingBuilder {
    public OrderBuilder.OrderPartBuilder builder;

    public OrderPartBuilderPortingBuilder() {
        this.builder = new OrderBuilder.OrderPartBuilder()
            .withId(0)
            .withActivity(OrderClientConstants.OrderPartActivityEnum.CREATE)
            .withType(OrderClientConstants.OrderPartTypeEnum.SUBSCRIPTION);
    }

    public OrderBuilder.OrderPartBuilder getBuilder(){
        return this.builder;
    }
}