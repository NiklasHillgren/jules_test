public with sharing class OrderProcessorExecutorHandlerV4 implements IEventExecutableHandler {
    
    private final OrderClient orderClient;
    public static final String PHONE_NO_STATUS_NUMMER_SKAL_PORTERES = 'Nummer skal porteres';
    public static final String PHONE_NO_STATUS_NYT_NUMMER = 'Nyt Nummer';
    public static final String PHONE_NO_STATUS_E_SIM = 'eSIM';  // TODO this value is not confirmed yet
    public static final String PHONE_NO_STATUS_PHYSICAL_SIM = 'Physical SIM';  // TODO this value is not confirmed yet


    @TestVisible
    private OrderProcessorExecutorHandlerV4(OrderClient orderClient) {
        this.orderClient = orderClient;

    }

    public OrderProcessorExecutorHandlerV4() {
        this(SingletonFactory.getFactory());
    }

    private OrderProcessorExecutorHandlerV4(SingletonFactory singletonFactory) {
        this.orderClient = (OrderClient) singletonFactory.getOrRegisterSingleton(OrderClient.class);
    }

    /**
     * @description Parses the provided JSON Parameters into OrderProcessorExecutorHandlerV4.parameter
     */
    public Parameters parseParameters(String parameters) {
        Logger.logInfo(String.format('parseParameters( {0} )', new List<Object>{ parameters }));

        if (parameters == null) {
            return null;
        }

        return (Parameters) System.JSON.deserialize(parameters, Parameters.class);
    }

    public void execute(EventExecutor__e event) {
        Logger.logInfo(String.format('execute( {0} )', new List<Object>{ event }));

        // We might instead of the offset method use a processed checkbox on Activation_line__c to mark processed lines
        Integer incrementOffsetBy = 100;

        Parameters params = parseParameters(event.Parameters__c);

        if (String.isNotEmpty(params.caseId)) {
            Logger.logInfo('OrderProcessorExecutorHandlerV4 execute, Processing order for CaseId: ' + params.caseId);

            List<Activation_line__c> activationLines = ActivationLineSelector.getActivationLinesForOrderByCaseId(params.caseId);

            Map<Id, Location_Line__c> locationLineMap = getLocationLineByIds(activationLines);
            // Map<String, Product2> productApiTeliaProductIdToProduct = getProductApiTeliaProductIdToProduct();

            // TODO consider what to do for Campaigns... 
            // Map<String, Fokus_Campaign__c> campaigns = CampaignSelector.getCampaignsByProductIds(productIds);

            // get the email from user with Id matching the invoicedByUserId
            String createdByEmail = getInvoicedByEmail(params.invoicedByUserId);
            Logger.logInfo('OrderProcessorExecutorHandlerV4 createdByEmail: ' + createdByEmail);

            // map the Ban to Activation Lines
            Map<String, List<Activation_line__c>> banToActivationLines = SObjectCollectionUtil.of(activationLines).groupByStrings('Billing_Account_Number__c');

            Map<String, OrderBuilder.OrderV10Builder> banToOrderBuilder = getBanToOrderBuilder(banToActivationLines.keySet(), createdByEmail);
            Map<String, OrderClientDTO.OrderV10> banToOrder = assembleContentForOrder(
                locationLineMap,
                banToActivationLines,
                banToOrderBuilder
            );

            // for each order, we place the order by calling the order clienta
            for (String ban : banToOrder.keySet()) {
                OrderClientDTO.OrderV10 voiceOrder = banToOrder.get(ban);
                Logger.logInfo('OrderProcessorExecutorHandlerV4 execute place order for BAN: ' + ban);
                System.debug('\n' + JSON.serializePretty(voiceOrder, true));

                //Logger.logInfo('OrderProcessorExecutorHandlerV4 execute, voiceOrder requ: ' + JSON.serializePretty(voiceOrder, true));
                //OrderClientDTO.OrderV10 voiceOrderResponse = (OrderClientDTO.OrderV10) orderClient.placeOrderByBAN(voiceOrder, ban);
                //Logger.logInfo('OrderProcessorExecutorHandlerV4 execute, voiceOrderResponse: ' + JSON.serialize(voiceOrderResponse));
            }

        }
    }

    private Map<String, OrderClientDTO.OrderV10> assembleContentForOrder(
        Map<Id, Location_Line__c> locationLineMap,
        Map<String, List<Activation_line__c>> banToActivationLines,
        Map<String, OrderBuilder.OrderV10Builder> banToOrderBuilder) {

        Map<String, OrderClientDTO.OrderV10> banToOrder = new Map<String, OrderClientDTO.OrderV10>();

        // ORDER (1 only)
        //     ORDER PARTS Level 1 (list with 1 only item in it, this is for a particular Ban)
        //         ORDER PARTS Level 2 (multiple subscription order parts, one per activation line)
        //             ORDER ITEMS (multiple order items per subscription order part)
        
        for (String ban : banToOrderBuilder.keySet()) {
            List<Activation_line__c> subsetOfActivationLines = banToActivationLines.get(ban);
            OrderBuilder.OrderV10Builder rootOrderBuilder = banToOrderBuilder.get(ban);

            // need to add the OrderParts for each activation line, so prep a list

            // BAN CREATION (Level 1 order part, and there will be only 1 in the list)
            OrderBuilder.OrderPartListBuilder outerOrderPartListBuilder = new OrderBuilder.OrderPartListBuilder();
            
            // Reference BILLING_ACCOUNT_NUMBER
            // TODO how to figure out to not create ref for nyt nummer, or is it a mistake it is not there?
            OrderBuilder.OrderPartReferenceListBuilder orderPartReferenceListBuilder = new OrderBuilder.OrderPartReferenceListBuilder();
            OrderBuilder.OrderPartReferenceBuilder orderPartReferenceBuilder = new OrderBuilder.OrderPartReferenceBuilder();
            orderPartReferenceBuilder
                .withType(OrderClientConstants.OrderPartReferenceTypeEnum.BILLING_ACCOUNT_NUMBER)
                .withValue(ban);
            orderPartReferenceListBuilder.withOrderPartReferenceBuilder(orderPartReferenceBuilder);

            // TODO for number porting what about hardwareDeliveries, and orderer
            // TODO for esim what about hardwareDeliveries
            // TODO for physical sim what about hardwareDeliveries
            OrderBuilder.OrderPartBuilder banOrderPartBuilder = new OrderBuilder.OrderPartBuilder()
                .withId(0)
                .withActivity(OrderClientConstants.OrderPartActivityEnum.CHANGE)  // This is CHANGE
                .withType(OrderClientConstants.OrderPartTypeEnum.ACCOUNT)
                .withOrderPartReferenceListBuilder(orderPartReferenceListBuilder);
                
            // now but this single 1 banOrderPartBuilder in the list
            outerOrderPartListBuilder.withOrderPartBuilder(banOrderPartBuilder);

            rootOrderBuilder.withOrderPartListBuilder(outerOrderPartListBuilder);
            
            // SUBSCRIPTION CREATION (list builder for the Level 2 order part list, one entry for each activationLine)
            // and this SUBSCRIPTION entry will have 1-many orderItem entries
            OrderBuilder.OrderPartListBuilder subscriptionOrderPartListBuilder = new OrderBuilder.OrderPartListBuilder();

            // TODO move this to a method
            for (Activation_Line__c activationLine : subsetOfActivationLines) {
                // each activation line will lead to 1 order part
                OrderBuilder.OrderPartBuilder innerOrderPartBuilder = new OrderBuilder.OrderPartBuilder()
                    .withId(0)
                    .withActivity(OrderClientConstants.OrderPartActivityEnum.CREATE)
                    .withType(OrderClientConstants.OrderPartTypeEnum.SUBSCRIPTION);

                // get the appropriate OrderProductBuilder (i.e. the one for Number Porting, New Number, etc.)
                OrderProductBuilder appropriateOrderProductBuilder = getOrderProductBuilder(activationLine);
 
                if (appropriateOrderProductBuilder != null) {
                    // ADD the subcription OrderPart Level 2 to the list of order parts on banOrderPart Level 1
                    innerOrderPartBuilder = appropriateOrderProductBuilder.createProductOrderPartBuilder(
                        innerOrderPartBuilder, 
                        activationLine
                    );
                                
                    // add the order part builder to the order part list builder for Level 2 order part
                    subscriptionOrderPartListBuilder.withOrderPartBuilder(innerOrderPartBuilder);
                    
                    // add the subscription order part list builder to the ban order part builder
                    banOrderPartBuilder.withOrderPartListBuilder(subscriptionOrderPartListBuilder);
                }
            }
            OrderClientDTO.OrderV10 order = rootOrderBuilder.build();
            banToOrder.put(ban, order);
        }
        return banToOrder;
    }


    public OrderProductBuilder getOrderProductBuilder(Activation_line__c activationLine){
        
        // // DUMMY to get around test data lacking
        // if (activationLine.Phone_no_Status__c == PHONE_NO_STATUS_NYT_NUMMER) {
        //     return new OrderProductPhysicalSim();
        // }

        
        if (activationLine.Phone_no_Status__c == PHONE_NO_STATUS_NUMMER_SKAL_PORTERES) {
            return new OrderProductPorting();
        }
        if (activationLine.Phone_no_Status__c == PHONE_NO_STATUS_NYT_NUMMER) {
            return new OrderProductNewNumber();
        }
        if (activationLine.Phone_no_Status__c == PHONE_NO_STATUS_E_SIM) {
            return new OrderProductESim();
        }
        if (activationLine.Phone_no_Status__c == PHONE_NO_STATUS_PHYSICAL_SIM) {
            return new OrderProductPhysicalSim();
        }
        return null;
    }


    /**
     * Retrieves the email of a User based on the provided User Id.
     *
     * This method performs a SOQL query to fetch the User record and returns
     * the value of the Email field. If no matching User is found or the Email
     * field is null, an empty string is returned.
     *
     * @param userId  The Id of the User whose email should be retrieved.
     *
     * @return String  
     *         The User's email, or an empty string if not found.
     */
    private String getInvoicedByEmail(String userId) {
        if (String.isBlank(userId)) {
            return '';
        }

        List<User> users = [
            SELECT Email
            FROM User
            WHERE Id = :userId
            LIMIT 1
        ];

        if (!users.isEmpty() && users[0].Email != null) {
            return users[0].Email;
        }

        return '';
    }

    /**
     * Retrieves a map of Location_Line__c records keyed by their Ids,
     * based on the list of Activation_line__c records provided.
     *
     * This method extracts the Location_Line__c lookup field from each
     * Activation_line__c record, collects all referenced Location Line Ids,
     * and delegates the retrieval to LocationLineSelector.getLocationLinesByIds().
     *
     * @param activationLines  A list of Activation_line__c records from which
     *                         the Location_Line__c Ids will be collected.
     *
     * @return Map<Id, Location_Line__c>  
     *         A map of Location_Line__c records, where the key is the record Id.
     */
    private Map<Id, Location_Line__c> getLocationLineByIds(List<Activation_line__c> activationLines) {
		List<Id> locationLineIds = new List<Id>();
		for (Activation_line__c activationLine : activationLines) {
			locationLineIds.add(activationLine.Location_Line__c);
		}
		return LocationLineSelector.getLocationLinesByIds(locationLineIds);
	}

    private List<String> getProductApiTeliaProductIdsForTrueVasFields(Activation_line__c activationLine) {

        List<String> teliaProductIds = new List<String>();

        List<String> mobileVasFieldApiNames = new List<String>{
            'VAS_ALLBIZA__c',
            'VAS_BAR3G__c',
            'VAS_BAR4G__c',
            'VAS_BAR90__c',
            'VAS_BARDATA__c',
            'VAS_BARINC__c',
            'VAS_BARINCRO__c',
            'VAS_BARINTCAL__c',
            'VAS_BARINTRO__c',
            'VAS_BARLEVEL__c',
            'VAS_BARMMS__c',
            'VAS_BARORXD__c',
            'VAS_BAROUTG__c',
            'VAS_BAROUTRO__c',
            'VAS_BARPRCSMS__c',
            'VAS_BARSTD__c',
            'VAS_BARTOTAL__c',
            'VAS_BARTOTRO__c',
            'VAS_CORAS5G__c',
            'VAS_CORDKTEU4__c',
            'VAS_CORDKTEU5__c',
            'VAS_CORDKTOEU__c',
            'VAS_CORUSA5G__c',
            'VAS_CORWA10G__c',
            'VAS_CORWA5G__c',
            'VAS_CORWA9G__c',
            'VAS_CORWB8G__c',
            'VAS_DUMMY2__c',
            'VAS_EntitleAW__c',
            'VAS_FINTDKEU__c',
            'VAS_FIX2MOBIL__c',
            'VAS_HBOBTB4__c',
            'VAS_M2MROAM__c',
            'VAS_MAXBTB__c',
            'VAS_MAXSPORTB__c',
            'VAS_OCFSERVUS__c',
            'VAS_OCFUSR__c',
            'VAS_OCFUSUS__c',
            'VAS_OCMUSR__c',
            'VAS_SFBTB40__c',
            'VAS_SIMBTB11__c',
            'VAS_SIMBTB2__c',
            'VAS_SIMBX2__c',
            'VAS_SIMBX3__c',
            'VAS_SIMBX4__c',
            'VAS_SIMBX5__c',
            'VAS_SIMBX6__c',
            'VAS_SIMBX7__c',
            'VAS_TEAMSPABA__c',
            'VAS_TEAMSPAUD__c',
            'VAS_TPXFNR1__c',
            'VAS_TPXREC3__c',
            'VAS_TPXREC7__c',
            'VAS_TPXRECB__c',
            'VAS_TPXTEAMSO__c',
            'VAS_TPXTEAMSR__c'
        };

        for (String mobileVasFieldApiName : mobileVasFieldApiNames) {
            // Get the field value dynamically
            Object value = activationLine.get(mobileVasFieldApiName);
            // AL-0442135

            // Check if it's true
            if (value == true) {
                teliaProductIds.add(getTeliaProductIdViaVasFieldApiName(mobileVasFieldApiName));
            }
        }
        return teliaProductIds;
    }

    /**
     * Receives a VAS field Api name and returns the corresponding telia product id.
     * To find the corresponding telia product id we remove the leading 'VAS_' and 
     * the trailing '__c' from the field name.
     * 
     * Example: VAS_FOO__c -> FOO
     * 
     * @param vasFieldApiName
     * @return String telia product id
     */
    private String getTeliaProductIdViaVasFieldApiName(String vasFieldApiName) {
        // leading substring to remove
        String prefixToRemove = 'VAS_';
        // trailing substring to remove
        String suffixToRemove = '__c';

        String cleaned = vasFieldApiName.replace(prefixToRemove, '').replace(suffixToRemove, '');
        return cleaned;
    }

    /**
     * Returns a map of ban to OrderV10Builder.
     * 
     * @param Set of bans
     * @param email
     * 
     * @return Map of ban to OrderV10Builder
     */
    private Map<String, OrderBuilder.OrderV10Builder> getBanToOrderBuilder(Set<String> bans, String createdByEmail) {

        // for each ban in the list, we create a shell OrderBuilder and put it in the map
        Map<String, OrderBuilder.OrderV10Builder> banToOrderBuilder = new Map<String, OrderBuilder.OrderV10Builder>();

        // get API settings
        APISettings__mdt api = MetadataSelector.getAPISettings('OrderAPISettings');
        
        OrderBuilder.DealerBuilder dealerBuilder = new OrderBuilder.DealerBuilder();
        dealerBuilder.withDealerCode(api.dealerCode__c);

        for (String ban : bans) {
            OrderBuilder.OrderV10Builder voiceOrderBuilder = new OrderBuilder.OrderV10Builder();

            voiceOrderBuilder.withBrand(OrderClientConstants.Brand.TELIADK) // TODO talk with Niklas this comes from api.brand__c; teliadk
                .withChannel(api.channel__c) // SALES_FORCE
                .withSegment(OrderClientConstants.OrderV10SegmentEnum.B2B) // B2B
                .withCreatedBy(createdByEmail) // TODO talk with Niklas about this field, should it be set?
                .withDealerBuilder(dealerBuilder);

            banToOrderBuilder.put(ban, voiceOrderBuilder);
        }

        return banToOrderBuilder;
    }

    // /**
    //  * Build and return a map of all Products where the Container__c = 'Mobile' and  
    //  * ProductAPI_Telia_Product_Id__c has a value. 
    //  * The mapping will be the ProductAPI_Telia_Product_Id__c to the Product record
    //  * 
    //  * @return map of Telia Product Id to Product record
    //  */
    // private Map<String, Product2> getProductApiTeliaProductIdToProduct() {
    //     // TODO move this to a selector once we know this is indeed how we should do it
    //     List<Product2> products = [
    //         SELECT 
    //             Id,
    //             Name,
    //             ProductCode,
    //             ProductAPI_Telia_Product_Id__c,
    //             Telia_Product_Code__c
    //         FROM Product2
    //         WHERE Container__c = 'MOBILE' AND ProductAPI_Telia_Product_Id__c != null                
    //     ];
    //     Map<String, Product2> productApiTeliaProductIdToProduct = new Map<String, Product2>();
    //     for (Product2 prod : products) {
    //         productApiTeliaProductIdToProduct.put(prod.ProductAPI_Telia_Product_Id__c, prod);
    //     }
    //     return productApiTeliaProductIdToProduct;
    // }    

    public class Parameters {
        public String caseId;
        public String activationLineOffset;  // this is if we need to cater for max 100 lines at a time
        //public String typeOfOrder; // CANCEL OR CONFIRM
        public String invoicedByUserId;
    }
}