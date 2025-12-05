/**
 * @description
 * Order Processor Executor Handler class responsible for processing
 * order events and orchestrating the creation and submission of orders.
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
public with sharing class OrderProcessorExecutorHandler implements IEventExecutableHandler {    
    
    private final OrderClient orderClient;
    private final OrderService orderService;

    private final String PHONE_NO_STATUS_NYT_NUMMER = 'Nyt Nummer';
    private final String PHONE_NO_STATUS_NUMMER_SKAL_PORTERES = 'Nummer skal porteres';
    private final String PHONE_NO_STATUS_EKSISTERENDE_NORLYS_NUMMER = 'Eksisterende Norlys nummer';
    private final String PHONE_NO_STATUS_NORLYS_TIL_NORLYS_TRANSFER = 'Norlys til Norlys transfer';


    // private final String PHONE_NO_STATUS_E_SIM = 'eSIM';  // TODO this value is not confirmed yet
    // private final String PHONE_NO_STATUS_PHYSICAL_SIM = 'Physical SIM';  // TODO this value is not confirmed yet

    @TestVisible
    private OrderProcessorExecutorHandler(OrderClient orderClient) {
        this.orderClient = orderClient;
    }

    public OrderProcessorExecutorHandler() {
        this(SingletonFactory.getFactory());
    }

    private OrderProcessorExecutorHandler(SingletonFactory singletonFactory) {
        this.orderClient = (OrderClient) singletonFactory.getOrRegisterSingleton(OrderClient.class);
        this.orderService = (OrderService) singletonFactory.getOrRegisterSingleton(OrderService.class);
    }

    /**
     * @description Parses the provided JSON Parameters into OrderProcessorExecutorHandler.parameter
     */
    public Parameters parseParameters(String parameters) {
        Logger.logInfo(String.format('parseParameters( {0} )', new List<Object>{ parameters }));

        if (parameters == null) {
            return null;
        }

        return (Parameters) System.JSON.deserialize(parameters, Parameters.class);
    }

    /**
     * @description
     * Executes the order processing based on the provided event.
     * @param event  The EventExecutor__e event containing parameters for processing.
     * @return void
     */
    public void execute(EventExecutor__e event) {
        Logger.logInfo(String.format('execute( {0} )', new List<Object>{ event }));

        // We might instead of the offset method use a processed checkbox on Activation_line__c to mark processed lines
        Integer incrementOffsetBy = 100;

        Parameters params = parseParameters(event.Parameters__c);

        if (String.isNotEmpty(params.caseId)) {
            Logger.logInfo('OrderProcessorExecutorHandler execute, Processing order for CaseId: ' + params.caseId);

            // get Account for the case
            this.orderService.getAccount(params.caseId);

            List<Activation_line__c> activationLines = ActivationLineSelector.getActivationLinesForOrderByCaseId(params.caseId);

            // get Power of Attorney documents for all activation lines
            this.orderService.getPowerOfAttorneyDocuments(activationLines);  // powerOfAttorneyIdToContentDocumentLink will be populated inside this method

            // TODO consider what to do for Campaigns... 
            // Map<String, Fokus_Campaign__c> campaigns = CampaignSelector.getCampaignsByProductIds(productIds);

            // get the email from user with Id matching the invoicedByUserId
            String createdByEmail = this.orderService.getInvoicedByEmail(params.invoicedByUserId);
            Logger.logInfo('OrderProcessorExecutorHandler createdByEmail: ' + createdByEmail);

            // map the Ban to Activation Lines
            Map<String, List<Activation_line__c>> banToActivationLines = SObjectCollectionUtil.of(activationLines).groupByStrings('Billing_Account_Number__c');

            Map<String, OrderClientDTOBuilder.OrderV10Builder> banToOrderBuilder = getBanToOrderBuilder(banToActivationLines.keySet(), createdByEmail);
            banToOrderBuilder = assembleContentForOrder(banToActivationLines, banToOrderBuilder);

            // for each order, we place the order by calling the order client
            for (String ban : banToOrderBuilder.keySet()) {
                OrderClientDTOBuilder.OrderV10Builder rootOrderBuilder = banToOrderBuilder.get(ban);
                OrderClientDTO.OrderV10 voiceOrder = rootOrderBuilder.build();
                Logger.logInfo('OrderProcessorExecutorHandler execute place order for BAN: ' + ban);
                System.debug('\n' + JSON.serializePretty(voiceOrder, true));

                // Logger.logInfo('OrderProcessorExecutorHandler execute, voiceOrder requ: ' + JSON.serializePretty(voiceOrder, true));
                // OrderClientDTO.OrderV10 voiceOrderResponse = (OrderClientDTO.OrderV10) orderClient.validateOrder(voiceOrder, ban);
                // OrderClientDTO.OrderV10 voiceOrderResponse = (OrderClientDTO.OrderV10) orderClient.placeOrderByBAN(voiceOrder, ban);
                // Logger.logInfo('OrderProcessorExecutorHandler execute, voiceOrderResponse: ' + JSON.serialize(voiceOrderResponse));
            }
        }
    }

    /**
     * @description
     * Assembles the content for the order based on the provided activation lines
     * grouped by BAN and the corresponding OrderV10Builders.
     * @param banToActivationLines  Map of BAN to list of Activation_line__c records.
     * @param banToOrderBuilder     Map of BAN to OrderV10Builder.
     * @return Map<String, OrderClientDTO.OrderV10>
     *         Map of BAN to constructed OrderV10.
     */
    private Map<String, OrderClientDTOBuilder.OrderV10Builder> assembleContentForOrder(
        Map<String, List<Activation_line__c>> banToActivationLines,
        Map<String, OrderClientDTOBuilder.OrderV10Builder> banToOrderBuilder) {

        Map<String, OrderClientDTO.OrderV10> banToOrder = new Map<String, OrderClientDTO.OrderV10>();

        // ORDER (1 only)
        //     ORDER PARTS Level 1 (list with 1 only item in it, this is for a particular BAN)
        //         ORDER PARTS Level 2 (multiple subscription order parts, one per activation line)
        //             ORDER ITEMS (multiple order items per subscription order part)
        
        for (String ban : banToOrderBuilder.keySet()) {
            List<Activation_line__c> activationLinesOnBan = banToActivationLines.get(ban);
            OrderClientDTOBuilder.OrderV10Builder rootOrderBuilder = banToOrderBuilder.get(ban);

            // need to add the OrderParts for each activation line, so prep a list

            // BAN CREATION (Level 1 order part, and there will be only 1 in the list)
            OrderClientDTOBuilder.OrderPartListBuilder outerOrderPartListBuilder = new OrderClientDTOBuilder.OrderPartListBuilder();
            
            // Reference BILLING_ACCOUNT_NUMBER
            // TODO how to figure out to not create ref for nyt nummer, or is it a mistake it is not there?
            OrderClientDTOBuilder.OrderPartReferenceListBuilder orderPartReferenceListBuilder = new OrderClientDTOBuilder.OrderPartReferenceListBuilder();
            OrderClientDTOBuilder.OrderPartReferenceBuilder orderPartReferenceBuilder = new OrderClientDTOBuilder.OrderPartReferenceBuilder();
            orderPartReferenceBuilder
                .withType(OrderClientDTOEnums.OrderPartReferenceTypeEnum.BILLING_ACCOUNT_NUMBER)
                .withValue(ban);
            orderPartReferenceListBuilder.withOrderPartReferenceBuilder(orderPartReferenceBuilder);

            // TODO for new number what about orderer
            OrderClientDTOBuilder.OrderPartBuilder banOrderPartBuilder = new OrderClientDTOBuilder.OrderPartBuilder()
                .withId(0)
                .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CHANGE)  // This is CHANGE
                .withType(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT)
                .withOrderPartReferenceListBuilder(orderPartReferenceListBuilder);
                
            // now put this single banOrderPartBuilder in the list
            outerOrderPartListBuilder.withOrderPartBuilder(banOrderPartBuilder);

            rootOrderBuilder.withOrderPartListBuilder(outerOrderPartListBuilder);

            assembleInnerNodes(activationLinesOnBan, rootOrderBuilder, banOrderPartBuilder);
        }
        return banToOrderBuilder;
    }

    /**
     * @description
     * Assembles the inner nodes of the order for the provided activation lines
     * on a BAN, updating the root order builder and BAN order part builder.
     * @param activationLinesOnBan     List of Activation_line__c records for the BAN.
     * @param rootOrderBuilder         The root OrderV10Builder to update.
     * @param banOrderPartBuilder      The BAN OrderPartBuilder to update.
     * @return void
     */
    private void assembleInnerNodes(
        List<Activation_line__c> activationLinesOnBan, 
        OrderClientDTOBuilder.OrderV10Builder rootOrderBuilder, 
        OrderClientDTOBuilder.OrderPartBuilder banOrderPartBuilder) {
        // we need list of hardwareDeliveries at root level
        OrderClientDTOBuilder.HardwareDeliveryListBuilder hardwareDeliveryListBuilder = new OrderClientDTOBuilder.HardwareDeliveryListBuilder();
        
        // SUBSCRIPTION CREATION (list builder for the Level 2 order part list, one entry for each activationLine)
        // and this SUBSCRIPTION entry will have 1 or more orderItem entries
        OrderClientDTOBuilder.OrderPartListBuilder subscriptionOrderPartListBuilder = new OrderClientDTOBuilder.OrderPartListBuilder();

        for (Integer counter = 0; counter < activationLinesOnBan.size(); counter++) {
            Activation_Line__c activationLine = activationLinesOnBan[counter];

            // get the appropriate OrderProductBuilder (i.e. the one for Number Porting, New Number, etc.)
            OrderProductBuilder appropriateOrderProductBuilder = getOrderProductBuilder(activationLine);

            if (appropriateOrderProductBuilder != null) {
                // each activation line will lead to 1 order part
                OrderClientDTOBuilder.OrderPartBuilder innerOrderPartBuilder = appropriateOrderProductBuilder.createProductOrderPartBuilder(
                    counter,
                    activationLine
                );
                        
                Logger.logInfo('OrderProcessorExecutorHandler create hardwareDeliveryBuilder');
                OrderClientDTOBuilder.HardwareDeliveryBuilder hardwareDeliveryBuilder = appropriateOrderProductBuilder
                    .createHardwareDeliveryBuilder(activationLine)
                    .withId(counter);
                hardwareDeliveryListBuilder.withHardwareDeliveryBuilder(hardwareDeliveryBuilder);                    

                // add the order part builder to the order part list builder for Level 2 order part
                subscriptionOrderPartListBuilder.withOrderPartBuilder(innerOrderPartBuilder);
                
                // add the subscription order part list builder to the ban order part builder
                banOrderPartBuilder.withOrderPartListBuilder(subscriptionOrderPartListBuilder);
            }
        }
        rootOrderBuilder.withHardwareDeliveryListBuilder(hardwareDeliveryListBuilder);  
    }

    /**
     * @description
     * Returns the appropriate OrderProductBuilder based on the Phone_no_Status__c
     * field of the provided Activation_Line__c record.
     * @param activationLine  The Activation_Line__c record to evaluate.
     * @return OrderProductBuilder
     *         The corresponding OrderProductBuilder implementation.
     */
    private OrderProductBuilder getOrderProductBuilder(Activation_line__c activationLine){
        
        // // DUMMY to get around test data lacking
        // if (activationLine.Phone_no_Status__c == PHONE_NO_STATUS_NYT_NUMMER) {
        //     return new OrderProductNewNumber();
        // }

        if (activationLine.Phone_no_Status__c == PHONE_NO_STATUS_NUMMER_SKAL_PORTERES ||
            activationLine.Phone_no_Status__c == PHONE_NO_STATUS_EKSISTERENDE_NORLYS_NUMMER ||
            activationLine.Phone_no_Status__c == PHONE_NO_STATUS_NORLYS_TIL_NORLYS_TRANSFER) {
            return new OrderProductPorting();
        }
        if (activationLine.Phone_no_Status__c == PHONE_NO_STATUS_NYT_NUMMER) {
            return new OrderProductNewNumber();
        }
        return null;
    }

    /**
     * @description
     * Returns a map of ban to OrderV10Builder.
     * 
     * @param Set of bans
     * @param email
     * 
     * @return Map of ban to OrderV10Builder
     */
    private Map<String, OrderClientDTOBuilder.OrderV10Builder> getBanToOrderBuilder(Set<String> bans, String createdByEmail) {

        // for each ban in the list, we create a shell OrderClientDTOBuilder and put it in the map
        Map<String, OrderClientDTOBuilder.OrderV10Builder> banToOrderBuilder = new Map<String, OrderClientDTOBuilder.OrderV10Builder>();

        // Dealer Builder        
        OrderClientDTOBuilder.DealerBuilder dealerBuilder = new OrderClientDTOBuilder.DealerBuilder();
        dealerBuilder.withDealerCode(OrderConstants.DEALER_CODE);

        for (String ban : bans) {
            OrderClientDTOBuilder.OrderV10Builder voiceOrderBuilder = new OrderClientDTOBuilder.OrderV10Builder();
            voiceOrderBuilder
                .withBrand(this.orderService.getBrand())  // TODO how to handle exception if brand config value won't find an enum?
                .withChannel(OrderConstants.CHANNEL)  // not an enum, get value from Company Settings custom metadata
                .withSegment(OrderClientDTOEnums.OrderV10SegmentEnum.B2B)
                .withCreatedBy(createdByEmail)
                .withDealerBuilder(dealerBuilder);

            banToOrderBuilder.put(ban, voiceOrderBuilder);
        }

        return banToOrderBuilder;
    }

    public class Parameters {
        public String caseId;
        public String activationLineOffset;  // this is if we need to cater for max 100 lines at a time
        public String invoicedByUserId;
    }
}