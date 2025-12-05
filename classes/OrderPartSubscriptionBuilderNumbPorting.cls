public class OrderPartSubscriptionBuilderNumbPorting extends OrderPartSubscriptionBuilder {
    public OrderClientDTO.PortingDetailsItem portingDetails;
    public OrderClientDTO.AdditionalProductItem sim;
    public List<OrderClientDTO.AdditionalProductItem> VAS = new List<OrderClientDTO.AdditionalProductItem>();

    public override OrderClientDTO.OrderPart buildOrderPart() {
        orderPart.orderItems.add(subItem);
        orderPart.orderItems.add(portingDetails);

        if ( sim != null ){
            orderPart.orderItems.add(sim);
        }

        if ( !vas.isEmpty() ){
            orderPart.orderItems.addAll(VAS);
        }
        
        return orderPart;
    }

    public OrderPartSubscriptionBuilderNumbPorting withPortingDetails(String simNumber, String documentURL, Date earliestPortingDate) {
        portingDetails = new OrderClientDTO.PortingDetailsItem();
        portingDetails.activity = OrderClientConstants.OrderItemActivityEnum.CREATE;
        portingDetails.type = OrderClientConstants.OrderItemTypeEnum.PORTING_DETAILS_ITEM;

        //TODO FIGURE OUT DATA ABOUT THE FOLLOWING FIELDS
        portingDetails.donorSimNumber = simNumber; // '89450401220312170491';
        portingDetails.poaDocumentUrl = documentURL; // 'URL TO FILE';
        //portingDetails.poaDocumentId = 'redacted' MISSING IN SWAGGER
        portingDetails.earliestPortingDate = earliestPortingDate; // System.now().date();  // TODO Porting__c (Power of Attorney has the Porting_Day__c field which is a text field)
        portingDetails.powerOfAttorneyManualHandling = true;  // TODO should it be true? in confluence it says true?
        portingDetails.portAfterCommitment = false;
        portingDetails.id = 0;

        return this;
    }

    public OrderPartSubscriptionBuilderNumbPorting withSIM(String productCode) {
        sim = new OrderClientDTO.AdditionalProductItem();
        sim.type = OrderClientConstants.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM;
        sim.productCategory = OrderClientConstants.AdditionalProductItemProductCategoryEnum.SIM;
        sim.activity = OrderClientConstants.OrderItemActivityEnum.CREATE;
        sim.id = 0;
        sim.quantity = 1;

        sim.simDetails = new OrderClientDTO.SimDetails();
        sim.simDetails.simType = OrderClientConstants.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM;
        //TODO FIGURE OUT DATA
        sim.productCode = productCode; // '9047807';  // confluence says Home_Office_VAS_Product__c on the ActivationLine. which is a bit strange???
        sim.simDetails.icc = '89450401220312168545';
        //sim.simDetails.waiveSimSwapFee = false; MISSING IN SWAGGER

        return this;
    }

    public OrderPartSubscriptionBuilderNumbPorting addVasItem(String productCode) {
        OrderClientDTO.AdditionalProductItem vasOrderItem = new OrderClientDTO.AdditionalProductItem();
        vasOrderItem.type = OrderClientConstants.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM;
        vasOrderItem.productCategory = OrderClientConstants.AdditionalProductItemProductCategoryEnum.VAS;
        vasOrderItem.activity = OrderClientConstants.OrderItemActivityEnum.CREATE;

        //TODO FIGURE OUT DATA
        vasOrderItem.productCode = productCode;  // 'TPSRAB6NP'; 
        vasOrderItem.quantity = 1;

        VAS.add(vasOrderItem);

        return this;
    }
}