/**
 * @description Handler for processing orders related to Activation Lines in batches.
 * 
 *  -----------------------------------------------------------------------------
 *  Developer               Date            Description
 *  -----------------------------------------------------------------------------
 *  Kirstine Nielsen        2025-11-03      Initial version
 * 
 * @author Kirstine Nielsen
 * @version 1.0 - Initial version
 * @since 2025-11-03
 */
public with sharing class OrderProcessorExecutorHandlerV3 implements IEventExecutableHandler {
    
    
    private final OrderClient orderClient;

    @TestVisible
    private OrderProcessorExecutorHandlerV3(OrderClient orderClient) {
        this.orderClient = orderClient;

    }

    public OrderProcessorExecutorHandlerV3() {
        this(SingletonFactory.getFactory());
    }

    private OrderProcessorExecutorHandlerV3(SingletonFactory singletonFactory) {
        this.orderClient = (OrderClient) singletonFactory.getOrRegisterSingleton(OrderClient.class);
    }

    /**
     * @description Parses the provided JSON Parameters into OrderProcessorExecutorHandlerV2.parameter
     */
    public Parameters parseParameters(String parameters) {
        Logger.logInfo(String.format('parseParameters( {0} )', new List<Object>{ parameters }));

        if (parameters == null) {
            return null;
        }

        return (Parameters) System.JSON.deserialize(parameters, Parameters.class);
    }

    public void execute(EventExecutor__e event) {
        /*
        Logger.logInfo(String.format('execute( {0} )', new List<Object>{ event }));

        // We might instead of the offset method use a processed checkbox on Activation_line__c to mark processed lines
        Integer incrementOffsetBy = 100;

        Parameters params = parseParameters(event.Parameters__c);

        if (String.isNotEmpty(params.caseId)) {
            Logger.logInfo('OrderProcessorExecutorHandlerV2 execute, Processing order for CaseId: ' + params.caseId);

            List<Activation_line__c> activationLines = [
                SELECT 
                    Id, 
                    Billing_Account_Number__c, 
                    Email__c,
                    Existing_SIM_number__c,
                    Express_Delivery__c,
                    First_Name__c,
                    Last_Name__c,
                    Location_Line__c,
                    Mobile_no__c,
                    Name,
                    Phone_no_Status__c,
                    PoA__c,
                    Priceplan_Code__c,
                    Activation__r.CreatedBy.Email,
                    Power_of_Attorney_record__r.Document_Id__c,
                    Power_of_Attorney_record__r.Porting_Day__c 
                FROM Activation_line__c
                WHERE Activation__r.Case__c = :caseId
            ];

            Map<String, Order> voiceOrders = buildVoiceOrders(params.caseId);
            Map<String, Activation_line__c> banToActivationLines = SObjectCollectionUtil.of(activationLines).groupByString(Billing_Account_Number__c);

            for(String ban : voiceOrders.keySet() ){
                List<Activation_line__c> actList = banToActivationLines.get(ban);
                OrderVoice voiceOrder = voiceOrder.get(ban);

                for(Activation_Line__c act : actList){
                    if (act.Phone_no_Status__c == 'Nummer skal porteres') {
                        

                        voiceOrder.orderParts.add(buildPortingOrder());
                    }
                }
            }

        }*/
    }

    public OrderClientDTO.OrderPart buildPortingOrder(){
        OrderClientDTO.OrderItemVTPXNumberPortingBuilder builder = new OrderClientDTO.OrderItemVTPXNumberPortingBuilder();

        builder.subscriptionItem_setPhoneNumber('40640332');
        OrderClientDTO.SubscriptionUser myUser = new OrderClientDTO.SubscriptionUser();
        myUser.firstName = 'Niklas';
        myUser.lastName = 'Hillgren';
        myUser.email = 'nikhil@norlys.dk';
        myUser.birthday = System.now().date();
        OrderClientDTO.DanishAddress add = new OrderClientDTO.DanishAddress();
        add.addressType = OrderClientConstants.AddressTypeEnum.DANISH_ADDRESS;
        add.streetName = 'Peder Skrams Gade';
        myUser.address = add;
        builder.addVasItem(); //ORDERPARTITEM
        builder.addVasItem();
        builder.addNewOffering();
        builder.subscriptionItem_setSubscriptionUser(myUser);
        builder.addSIM();
        builder.addPortingDetails();
        OrderClientDTO.OrderPart parts = builder.buildOrder();
        return parts;
    }


    public class Parameters {
        public String caseId;
        public String activationLineOffset;  // this is if we need to cater for max 100 lines at a time
        //public String typeOfOrder; // CANCEL OR CONFIRM
    }
}