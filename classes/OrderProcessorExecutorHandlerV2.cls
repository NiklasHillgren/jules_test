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
public with sharing class OrderProcessorExecutorHandlerV2 implements IEventExecutableHandler {
    
    
    private final OrderClient orderClient;

    @TestVisible
    private OrderProcessorExecutorHandlerV2(OrderClient orderClient) {
        this.orderClient = orderClient;

    }

    public OrderProcessorExecutorHandlerV2() {
        this(SingletonFactory.getFactory());
    }

    private OrderProcessorExecutorHandlerV2(SingletonFactory singletonFactory) {
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
        Logger.logInfo(String.format('execute( {0} )', new List<Object>{ event }));

        // We might instead of the offset method use a processed checkbox on Activation_line__c to mark processed lines
        Integer incrementOffsetBy = 100;

        Parameters params = parseParameters(event.Parameters__c);

        if (String.isNotEmpty(params.caseId)) {
            Logger.logInfo('OrderProcessorExecutorHandlerV2 execute, Processing order for CaseId: ' + params.caseId);

            // create Voice Orders (we build one Voice Order per BAN)
            List<OrderVoice> voiceOrders = buildVoiceOrders(params.caseId);

            Logger.logInfo('OrderProcessorExecutorHandlerV2 execute, CaseId: ' + params.caseId + ', voiceOrders.size(): ' + voiceOrders.size());
            Logger.logInfo('OrderProcessorExecutorHandlerV2 execute, voiceOrders: ' + JSON.serialize(voiceOrders));

            // for each order, we place the order by calling the order client
            for (OrderVoice voiceOrder : voiceOrders) {
                String banForThisOrder = voiceOrder.orderParts[0].references[0].value;
                Logger.logInfo('OrderProcessorExecutorHandlerV2 execute, banForThisOrder: ' + banForThisOrder);
                // placeOrderByBAN(Order customerOrder, String banNumber)
                OrderVoice voiceOrderResponse = (OrderVoice) orderClient.placeOrderByBAN(voiceOrder, banForThisOrder);
                Logger.logInfo('OrderProcessorExecutorHandlerV2 execute, voiceOrderResponse: ' + JSON.serialize(voiceOrderResponse));
            }

            // List<Activation_line__c> activationLines = [
            //     SELECT Id, Status__c, Order_Status__c, Order_Confirmation_Status__c, Order_Cancellation_Status__c 
            //     FROM Activation_line__c 
            //     WHERE CaseId = :params.caseId 
            //     ORDER BY Id
            //     LIMIT 100
            //     OFFSET :params.activationLineOffset
            // ];

            // update activationLines;

            // we need to continue processing if there are more lines to process, so you keep publishing events until all lines are processed
            // // we might use the off set method, or we might add a new field on Activation_line__c to mark processed lines and then query only unprocessed lines next time and so on...
            // // fire next event if there are more lines to process
            // if(activationLines.size() == 100){
            //     EventExecutor__e nextEventExecutor = new EventExecutor__e();
            //     params.caseId = params.caseId;
            //     // increment offset by 100
            //     Integer nextOffset = Integer.valueOf(params.activationLineOffset) + incrementOffsetBy;
            //     params.activationLineOffset = String.valueOf(nextOffset);
            //     nextEventExecutor.Parameters__c = JSON.serialize(params);
            //     nextEventExecutor.Executor__c = event.Executor__c;
            //     EventBus.publish(nextEventExecutor);
            // }
            
        }
    }

    
    // TODO the below method helping build orders should be moved to maybe orderfactory class...        
    private static final String TYPE_BILLING_ACCOUNT_NUMBER = 'BILLING_ACCOUNT_NUMBER';
    private static final String TYPE_ACCOUNT = 'ACCOUNT';
    private static final String TYPE_ACCOUNT_ITEM = 'ACCOUNT_ITEM';
    private static final String TYPE_SUBSCRIPTION_ITEM = 'SUBSCRIPTION_ITEM';
    private static final String TYPE_SUBSCRIPTION = 'SUBSCRIPTION';
    private static final String TYPE_PERSON = 'PERSON';
    private static final String ACTIVITY_CREATE = 'CREATE';
    private static final String ACTIVITY_CHANGE = 'CHANGE';
    private static final String DEFAULT_COUNTRY = 'DNK';
    private static final String COUNTRY_CODE = '45';
    private static final String DEFAULT_SEGMENT = 'B2B';

    // (we build one Voice Order per BAN)
    private List<OrderVoice> buildVoiceOrders(Id caseId) {
        
        // create an Order for each BAN
        List<OrderVoice> voiceOrders = new List<OrderVoice>();

        // Query activation lines related to the case
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

        Map<Id, Location_Line__c> locationLineMap = getLocationLineByIds(activationLines);

        // get API settings
        APISettings__mdt api = MetadataSelector.getAPISettings('OrderAPISettings');
        
        // group activation lines by BAN
        Map<String, List<Activation_line__c>> banToActivationLinesMap = getActivationLinesByBans(activationLines);
        // Logger.logInfo('OrderProcessorExecutorHandlerV2 execute, banToActivationLinesMap: ' + banToActivationLinesMap);

        String createByEmail = activationLines.size() > 0 ? activationLines[0].Activation__r.CreatedBy.Email : ''; // TODO

        // create an Order for each BAN
        for (String ban : banToActivationLinesMap.keySet()) { 
            List<Activation_line__c> activationLinesForSpecificBAN = banToActivationLinesMap.get(ban);  

            // build a voice order per BAN
            OrderVoice voiceOrder = new OrderVoice();
            voiceOrder.brand = api.brand__c;  // teliadk
            voiceOrder.channel = api.channel__c; // SALES_FORCE
            voiceOrder.segment = DEFAULT_SEGMENT; // B2B
            voiceOrder.createdBy = createByEmail; // TODO
            voiceOrder.dealer = createDealer(api);

            // we don't need the level with the root ban...

            voiceOrder.orderParts = createBanVoiceOrderParts(ban, activationLinesForSpecificBAN, locationLineMap);  // will return a list with only one item in it, the Order Part for one BAN
            voiceOrders.add(voiceOrder);
        }
        return voiceOrders;
    }

    // we need a list with only one item in it, the order part for one BAN
    private static List<OrderPartVoice> createBanVoiceOrderParts(
        String ban, 
        List<Activation_line__c> activationLines,
        Map<Id, Location_Line__c> locationLineMap) {

        OrderPartVoice voiceOrderPart = new OrderPartVoice();

        voiceOrderPart.type = TYPE_ACCOUNT; // ACCOUNT
        voiceOrderPart.activity = ACTIVITY_CHANGE; // CHANGE  TODO should it be CHANGE or CREATE??? when this is for a child BAN
        voiceOrderPart.orderPartVoiceId = '0';  // TODO is this ORDER_API_Order_Id__c on the Activation__c ??? or is it '0' for number porting??? and is it id or orderPartVoiceId???

        voiceOrderPart.references = new List<Reference>{ createBillingAccountReference(ban) };

        // list with entry for each subscription under the BAN
        voiceOrderPart.orderParts = createSubscriptionVoiceOrderParts(locationLineMap, activationLines);  // list with entry for each subscription under the BAN

        // return a list with only one item in it, the order part for one BAN
        return new List<OrderPartVoice>{ voiceOrderPart };
    }


    private static Dealer createDealer(APISettings__mdt api) {
		Dealer d = new Dealer();
		d.dealerCode = api.dealerCode__c;
		return d;
	}

    private static Reference createBillingAccountReference(String ban) {
        Reference ref = new Reference();
        ref.type = TYPE_BILLING_ACCOUNT_NUMBER; // BILLING_ACCOUNT_NUMBER
        ref.value = ban;
        return ref;
    }
    
    private static Telephone createTelephone(Activation_line__c activationLine) {
        Telephone tPhone = new Telephone();
		tPhone.countryCode = COUNTRY_CODE;
		tPhone.localNumber = activationLine.Mobile_no__c;
        return tPhone;
    }

    private static Offering createOffering(Map<Id, Location_Line__c> locationLineMap, Activation_line__c activationLine) {
		Offering o = new Offering();

        // if location is filled out in the Activation Line and it has a subscription Product, 
        // use that otherwise use the priceplan in the activation line
		Location_Line__c location = locationLineMap.get(activationLine.Location_Line__c);
		o.priceplan = (location != null && location.Subscription_product__c != null) ? location.Subscription_product__c : activationLine.Priceplan_Code__c;
        // o.campaign ???
        o.productOfferingId = '100010308' ; // constant for number porting call
		return o;
	}

    // create a party
    private static Party createParty(Activation_line__c activationLine) {
        Party p = new Party();
        p.firstName = activationLine.First_Name__c;
        p.lastName = activationLine.Last_Name__c;
        p.type = 'PERSON'; // constant
        p.email = activationLine.Email__c;
        return p;
    }

    // you will create OrderPartVoice records, one per subscription, i.e. one per activation line
    private static List<OrderPartVoice> createSubscriptionVoiceOrderParts(  // this is a list of subscription order parts for a BAN
        Map<Id, Location_Line__c> locationLineMap, 
        List<Activation_line__c> activationLines) {

        List<OrderPartVoice> voiceOrderParts = new List<OrderPartVoice>();     

        for (Activation_line__c activationLine : activationLines) {

            // this is for one Activation Line
            OrderPartVoice voiceOrderPart = new OrderPartVoice();

            voiceOrderPart.type = TYPE_SUBSCRIPTION; // SUBSCRIPTION
            voiceOrderPart.activity = ACTIVITY_CREATE; // CREATE
            voiceOrderPart.orderPartVoiceId = '0';  // TODO is this ORDER_API_Order_Id__c on the Activation__c ??? or is it '0' for number porting??? and is it id or orderPartVoiceId???

            // list of order items (an Activation Line can have multiple order items, e.g. subscription item, additional product item, porting details item etc.)
            voiceOrderPart.orderItems = createVoiceOrderItemsPerActivationLine(locationLineMap, activationLine);

            // add to list
            voiceOrderParts.add(voiceOrderPart);
        }   
        return voiceOrderParts;
    }

    private static List<OrderItemVoice> createVoiceOrderItemsPerActivationLine(
        Map<Id, Location_Line__c> locationLineMap, 
        Activation_line__c activationLine) {

        List<OrderItemVoice> voiceOrderItemsPerActivationLine = new List<OrderItemVoice>();

        // TODO implement logic to create different order items based on activation line details
        if (activationLine.Phone_no_Status__c == 'Nummer skal porteres') {
            Logger.logInfo('OrderProcessorExecutorHandlerV2 execute, Nummer skal porteres: ' + activationLine.Name);
            voiceOrderItemsPerActivationLine = createVoiceOrderItemsPerActivationLineNumberPorting(locationLineMap, activationLine);
        } else if (activationLine.Phone_no_Status__c == 'Nyt Nummer') {
            Logger.logInfo('OrderProcessorExecutorHandlerV2 execute, Nyt Nummer: ' + activationLine.Name);
            voiceOrderItemsPerActivationLine = createVoiceOrderItemsPerActivationLineNewNumber(locationLineMap, activationLine);
        } else {
            //

        }

        return voiceOrderItemsPerActivationLine;
    }

    // VAS_ALLBIZA__c
    // VAS_BAR3G__c
    // VAS_BAR4G__c
    // VAS_BAR90__c
    // VAS_BARDATA__c
    // VAS_BARINC__c
    // VAS_BARINCRO__c
    // VAS_BARINTCAL__c
    // VAS_BARINTRO__c
    // VAS_BARLEVEL__c
    // VAS_BARMMS__c
    // VAS_BARORXD__c
    // VAS_BAROUTG__c
    // VAS_BAROUTRO__c
    // VAS_BARPRCSMS__c
    // VAS_BARSTD__c
    // VAS_BARTOTAL__c
    // VAS_BARTOTRO__c
    // VAS_CORAS5G__c
    // VAS_CORDKTEU4__c
    // VAS_CORDKTEU5__c
    // VAS_CORDKTOEU__c
    // VAS_CORUSA5G__c
    // VAS_CORWA10G__c
    // VAS_CORWA5G__c
    // VAS_CORWA9G__c
    // VAS_CORWB8G__c
    // VAS_DUMMY2__c
    // VAS_EntitleAW__c
    // VAS_FINTDKEU__c
    // VAS_FIX2MOBIL__c
    // VAS_HBOBTB4__c
    // VAS_M2MROAM__c
    // VAS_MAXBTB__c
    // VAS_MAXSPORTB__c
    // VAS_OCFSERVUS__c
    // VAS_OCFUSR__c
    // VAS_OCFUSUS__c
    // VAS_OCMUSR__c
    // VAS_SFBTB40__c
    // VAS_SIMBTB11__c
    // VAS_SIMBTB2__c
    // VAS_SIMBX2__c
    // VAS_SIMBX3__c
    // VAS_SIMBX4__c
    // VAS_SIMBX5__c
    // VAS_SIMBX6__c
    // VAS_SIMBX7__c
    // VAS_TEAMSPABA__c
    // VAS_TEAMSPAUD__c
    // VAS_TPXFNR1__c
    // VAS_TPXREC3__c
    // VAS_TPXREC7__c
    // VAS_TPXRECB__c
    // VAS_TPXTEAMSO__c
    // VAS_TPXTEAMSR__c

    private static void getVASOrderItems(Activation_line__c activationLine) {
        // TODO implement if needed
        // an Activation Line can have multiple VAS items, I think it is driven by the checkboxes on Activation Line VAS_someTeliaProductId__c.
        // be aware we only are interested in the VAS items that are relevant for Mobile (and possibly only the ones of data type checkbox??? ask Jay)
        // if ticked, then you need to find the sibling Quote Line on the Quote, that is associated to the Product with this someTeliaProductId__c (ProductAPI_Telia_Product_Id__c)
        // then for each of these, you need to create an OrderItemVoice with type = 'ADDITIONAL_PRODUCT_ITEM', activity = 'CREATE'.... 

    }
    
    private static List<OrderItemVoice> createVoiceOrderItemsPerActivationLineNumberPorting(
        Map<Id, Location_Line__c> locationLineMap, 
        Activation_line__c activationLine) {

        // TODO implement logic to create different order items based on activation line details

        List<OrderItemVoice> voiceOrderItemsPerActivationLine = new List<OrderItemVoice>();

        // how do you know if it is a subscription item or an additional product item???
        // SUBSCRIPTION_ITEM, ADDITIONAL_PRODUCT_ITEM, PORTING_DETAILS_ITEM

        // ------- SUBSCRIPTION_ITEM --------
        // Telephone
        // Offering
        // Party (Subscription User)
        OrderItemVoice itemSubscription = new OrderItemVoice();
        itemSubscription.type = 'SUBSCRIPTION_ITEM'; // constant
        itemSubscription.activity = ACTIVITY_CREATE; // constant
        itemSubscription.telephoneNumber = createTelephone(activationLine); // TODO Telephone
        itemSubscription.telephoneNumberCategory = 'MOBILE'; // constant
        itemSubscription.offering = createOffering(locationLineMap, activationLine); // TODO Offering is this correct, can see offering on OrderItem, but cannot see newOffering???
        itemSubscription.subscriptionUser = createParty(activationLine); // TODO Party
        itemSubscription.publishLevel = 'ALL_INFORMATION_PROVIDED'; // constant
        itemSubscription.productDeliveryAsap = activationLine.Express_Delivery__c; // Activation_Line__c.Express_Delivery__c
        itemSubscription.id = 0; // constant, Only in the number porting call ???

        voiceOrderItemsPerActivationLine.add(itemSubscription);

        // ------- ADDITIONAL_PRODUCT_ITEM--------

        // TODO - do we need SimDetail 

        // TODO - do we need VAS
        // OrderItemVoice itemAdditionalProductVAS = new OrderItemVoice();
        // itemAdditionalProductVAS.productCode = 'TPSRAB6NP'; // TODO dummy value for now, what is this field for number porting
        // itemAdditionalProductVAS.productCategory = 'VAS'; // TODO 
        // itemAdditionalProductVAS.simDetail = ; // TODO SimDetail
        // itemAdditionalProductVAS.type = 'ADDITIONAL_PRODUCT_ITEM'; // constant
        // itemAdditionalProductVAS.activity = ACTIVITY_CREATE; // constant
        // itemAdditionalProductVAS.id = 0; // TODO which id is it
        // itemAdditionalProductVAS.quantity = 10; // TODO 

        // voiceOrderItemsPerActivationLine.add(itemPortingDetails);

        // TODO ask if we need the "type": "PORTING_DETAILS_ITEM",
        OrderItemVoice itemPortingDetails = new OrderItemVoice();
        // Existing_SIM_number__c or SIM_number__c
        itemPortingDetails.donorSimNumber = activationLine.Existing_SIM_number__c; // TODO Existing_SIM_number__c or SIM_number__c
        itemPortingDetails.poaDocumentUrl = activationLine.PoA__c; // TODO
        itemPortingDetails.poaDocumentId = activationLine.Power_of_Attorney_record__r.Document_Id__c; // TODO
        itemPortingDetails.powerOfAttorneyManualHandling = true; // TODO should it be true?
        itemPortingDetails.earliestPortingDate = activationLine.Power_of_Attorney_record__r.Porting_Day__c; // TODO
        // itemPortingDetails.portAfterCommitment = false; // TODO should it be false? which field? from where? cannot see on classes
        itemPortingDetails.type = 'PORTING_DETAILS_ITEM'; // constant
        itemPortingDetails.activity = ACTIVITY_CREATE; // constant
        itemPortingDetails.id = 0; // constant, Only in the number porting call ???
        
        voiceOrderItemsPerActivationLine.add(itemPortingDetails);

        return voiceOrderItemsPerActivationLine;
    }
    









    private static List<OrderItemVoice> createVoiceOrderItemsPerActivationLineNewNumber(
        Map<Id, Location_Line__c> locationLineMap, 
        Activation_line__c activationLine) {

        // TODO implement logic to create different order items based on activation line details

        List<OrderItemVoice> voiceOrderItemsPerActivationLine = new List<OrderItemVoice>();

        // how do you know if it is a subscription item or an additional product item???
        // SUBSCRIPTION_ITEM, ADDITIONAL_PRODUCT_ITEM, PORTING_DETAILS_ITEM

        // ------- SUBSCRIPTION_ITEM --------
        // Telephone
        // Offering
        // Party (Subscription User)
        OrderItemVoice itemSubscription = new OrderItemVoice();
        itemSubscription.type = 'SUBSCRIPTION_ITEM'; // constant
        itemSubscription.activity = ACTIVITY_CREATE; // constant
        itemSubscription.telephoneNumber = createTelephone(activationLine); // TODO Telephone
        itemSubscription.telephoneNumberCategory = 'MOBILE'; // constant
        itemSubscription.offering = createOffering(locationLineMap, activationLine); // TODO Offering is this correct, can see offering on OrderItem, but cannot see newOffering???
        itemSubscription.subscriptionUser = createParty(activationLine); // TODO Party
        itemSubscription.publishLevel = 'ALL_INFORMATION_PROVIDED'; // constant
        itemSubscription.productDeliveryAsap = false; // constant
        itemSubscription.id = 0; // constant, Only in the number porting call ???

        voiceOrderItemsPerActivationLine.add(itemSubscription);

        // ------- ADDITIONAL_PRODUCT_ITEM--------

        // TODO - do we need SimDetail 

        // TODO - do we need VAS
        // OrderItemVoice itemAdditionalProductVAS = new OrderItemVoice();
        // itemAdditionalProductVAS.productCode = 'TPSRAB6NP'; // TODO dummy value for now, what is this field for number porting
        // itemAdditionalProductVAS.productCategory = 'VAS'; // TODO 
        // itemAdditionalProductVAS.simDetail = ; // TODO SimDetail
        // itemAdditionalProductVAS.type = 'ADDITIONAL_PRODUCT_ITEM'; // constant
        // itemAdditionalProductVAS.activity = ACTIVITY_CREATE; // constant
        // itemAdditionalProductVAS.id = 0; // TODO which id is it
        // itemAdditionalProductVAS.quantity = 10; // TODO 

        // voiceOrderItemsPerActivationLine.add(itemPortingDetails);

        // TODO ask if we need the "type": "PORTING_DETAILS_ITEM",
        OrderItemVoice itemPortingDetails = new OrderItemVoice();
        // Existing_SIM_number__c or SIM_number__c
        itemPortingDetails.donorSimNumber = activationLine.Existing_SIM_number__c; // TODO Existing_SIM_number__c or SIM_number__c
        itemPortingDetails.poaDocumentUrl = activationLine.PoA__c; // TODO
        itemPortingDetails.poaDocumentId = activationLine.Power_of_Attorney_record__r.Document_Id__c; // TODO
        itemPortingDetails.powerOfAttorneyManualHandling = true; // TODO should it be true?
        itemPortingDetails.earliestPortingDate = activationLine.Power_of_Attorney_record__r.Porting_Day__c; // TODO
        // itemPortingDetails.portAfterCommitment = false; // TODO should it be false? which field? from where? cannot see on classes
        itemPortingDetails.type = 'PORTING_DETAILS_ITEM'; // constant
        itemPortingDetails.activity = ACTIVITY_CREATE; // constant
        itemPortingDetails.id = 0; // constant, Only in the number porting call ???
        
        voiceOrderItemsPerActivationLine.add(itemPortingDetails);

        return voiceOrderItemsPerActivationLine;
    }

    private static Map<Id, Location_Line__c> getLocationLineByIds(List<Activation_line__c> activationLines) {
		List<Id> locationLineIds = new List<Id>();
		for (Activation_line__c activationLine : activationLines) {
			locationLineIds.add(activationLine.Location_Line__c);
		}
		return LocationLineSelector.getLocationLinesByIds(locationLineIds);
	}

    private static Map<String, List<Activation_line__c>> getActivationLinesByBans(List<Activation_line__c> activationLines) {
		Map<String, List<Activation_line__c>> activationLinesByBans = new Map<String, List<Activation_line__c>>();
		for (Activation_line__c activationLine : activationLines) {
			if (activationLinesByBans.containsKey(activationLine.Billing_Account_Number__c)) {
				activationLinesByBans.get(activationLine.Billing_Account_Number__c).add(activationLine);
			} else {
				activationLinesByBans.put(activationLine.Billing_Account_Number__c, new List<Activation_line__c>{ activationLine });
			}
		}
		return activationLinesByBans;
	}

    public class Parameters {
        public String caseId;
        public String activationLineOffset;  // this is if we need to cater for max 100 lines at a time
        //public String typeOfOrder; // CANCEL OR CONFIRM
    }
}