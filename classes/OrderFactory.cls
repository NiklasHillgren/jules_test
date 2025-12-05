/**
* @description A factory class for creating and parsing Order API DTOs.
*              This class is responsible for two main functions:
*              1. Building order request payloads from Salesforce records (`create...` methods).
*              2. Parsing JSON responses into the appropriate Order DTOs (`parse` method).
*              It encapsulates the complex logic of mapping Salesforce data to the Order API's contract.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial version with order creation logic.
*  Kenneth Houkjær      11/09/2025      Added Root BAN creation logic.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public class OrderFactory {
    // =================================================================================================================
    // State-holding properties for the factory process
    // These are temporary state holders for a single factory operation.
    // =================================================================================================================
    private static APISettings__mdt api;
	private static Map<Id, Location_Line__c> locationsByIds;
    private static Activation__c activation;

    // =================================================================================================================
    // Constants
    // =================================================================================================================
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

    // =================================================================================================================
    // Public Factory Methods for Creating Orders
    // =================================================================================================================

    /**
     * @description Creates a map of fully formed Order objects for new subscriptions based on a list of Activation Lines.
     *              The logic is ported from the legacy `OrderAPIAction` class. Each order is keyed by its
     *              Billing Account Number (BAN).
     * @param activationLines The list of activation lines to process.
     * @param caseId The parent Case ID to associate with these orders.
     * @return A map of Billing Account Number to a fully constructed Order object ready for serialization.
     */
    public static Map<String, Order> createOrdersFromActivationLines(List<Activation_line__c> activationLines, String caseId) {
        // 1. Initialize data
        api = MetadataSelector.getAPISettings('OrderAPIHomeOfficeSettings');
        locationsByIds = getLocationLineByIds(activationLines);
        activation = ActivationSelector.getActivationById(activationLines.get(0).Activation__c);

        // 2. Group activation lines by BAN
        Map<String, List<Activation_line__c>> activationLinesByBans = getActivationLinesByBans(activationLines);

        // 3. Create an Order for each BAN
        Map<String, Order> ordersByBan = new Map<String, Order>();
        for (String ban : activationLinesByBans.keySet()) {
            OrderInternet order = new OrderInternet();
            order.brand = api.brand__c;
            order.channel = api.channel__c;
            order.segment = DEFAULT_SEGMENT;
            order.implementationCaseId = caseId;

            order.dealer = createDealer();
            order.flags = new List<Flag>{ createFlag() };
            order.orderParts = createRootOrderParts(ban, activationLinesByBans.get(ban));

            ordersByBan.put(ban, order);
        }

        return ordersByBan;
    }

    private static Map<Id, Location_Line__c> getLocationLineByIds(List<Activation_line__c> activationLines) {
		List<Id> locationIds = new List<Id>();
		for (Activation_line__c activationLine : activationLines) {
			locationIds.add(activationLine.Location_Line__c);
		}
		return LocationLineSelector.getLocationLinesByIds(locationIds);
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

    private static Dealer createDealer() {
		Dealer d = new Dealer();
		d.dealerCode = api.dealerCode__c;
		return d;
	}

    private static Flag createFlag() {
		Flag f = new Flag();
		f.needsConfirmation = false;
		f.consentAccepted = false;
		f.termsAccepted = true;
		f.dirty = true;
		return f;
	}

    private static List<OrderPart> createRootOrderParts(String ban, List<Activation_line__c> activationLines) {
        OrderPart rootOrderPart = new OrderPart();
        rootOrderPart.type = TYPE_ACCOUNT;
        rootOrderPart.activity = ACTIVITY_CHANGE;
        rootOrderPart.references = new List<Reference>{ createBillingAccountReference(ban) };
        rootOrderPart.orderParts = createAccountOrderParts(activationLines);
        return new List<OrderPart>{ rootOrderPart };
    }

    private static Reference createBillingAccountReference(String ban) {
        Reference r = new Reference();
        r.type = TYPE_BILLING_ACCOUNT_NUMBER;
        r.value = ban;
        return r;
    }

    private static List<OrderPart> createAccountOrderParts(List<Activation_line__c> activationLines) {
        List<OrderPart> accountOrderParts = new List<OrderPart>();
        for (Activation_line__c activationLine : activationLines) {
            OrderPartInternet accountOrderPart = new OrderPartInternet();
            accountOrderPart.type = TYPE_ACCOUNT;
            accountOrderPart.activity = ACTIVITY_CREATE;
            accountOrderPart.channelOrderPartId = activationLine.Id;
            accountOrderPart.orderParts = createSubscriptions(activationLine);
            accountOrderPart.orderItems = createAccountOrderItems(activationLine);
            accountOrderParts.add(accountOrderPart);
        }
        return accountOrderParts;
    }

    private static List<OrderPart> createSubscriptions(Activation_line__c activationLine) {
        OrderPart subscription = new OrderPart();
        subscription.activity = ACTIVITY_CREATE;
        subscription.type = TYPE_SUBSCRIPTION;
        subscription.orderItems = new List<OrderItem>{ createSubscriptionOrderItem(activationLine) };
        // Note: VAS and OTC products are also handled here in the old code
        // by adding more OrderItems. This logic should be added if needed.
        return new List<OrderPart>{ subscription };
    }

    private static List<OrderItem> createAccountOrderItems(Activation_line__c activationLine) {
        OrderItem item = new OrderItem();
        item.activity = ACTIVITY_CREATE;
        item.type = TYPE_ACCOUNT_ITEM;
        item.legalParty = createLegalParty(activationLine);
        item.invoiceType = activationLine.Invoice_Type_F__c;
		item.billingCycle = activation.Billing_Frequency__c;
        return new List<OrderItem>{ item };
    }

    private static OrderItemInternet createSubscriptionOrderItem(Activation_line__c activationLine) {
		OrderItemInternet subscriptionItem = new OrderItemInternet();
		subscriptionItem.type = TYPE_SUBSCRIPTION_ITEM;
		subscriptionItem.activity = ACTIVITY_CREATE;
		subscriptionItem.offering = createOffering(activationLine);
		subscriptionItem.fixedNetDetails = createFixedNetDetails(activationLine);
		subscriptionItem.preferredActivationDate = activationLine.Home_Office_Requested_Activation_Date__c;
		subscriptionItem.productDeliveryAsap = activationLine.Express_Delivery__c;
		return subscriptionItem;
	}

    private static Offering createOffering(Activation_line__c activationLine) {
		Offering o = new Offering();
		Location_Line__c location = locationsByIds.get(activationLine.Location_Line__c);
		o.priceplan = (location != null && location.Subscription_product__c != null) ? location.Subscription_product__c : activationLine.Priceplan_Code__c;
		return o;
	}

    private static FixedNetDetail createFixedNetDetails(Activation_line__c activationLine) {
		FixedNetDetail fnd = new FixedNetDetail();
		Location_Line__c location = locationsByIds.get(activationLine.Location_Line__c);
		fnd.installationAddress = createInstallationAddress(activationLine);
		fnd.fixedNetFlags = createFixedNetFlags(activationLine);
		fnd.speedDown = getSpeedFromProductName(activationLine);
		fnd.speedUp = getSpeedFromProductName(activationLine);
		fnd.doItYourselfInstallation = activationLine.DIY_Installation__c;
		fnd.vendor = (location != null) ? location.lineProvider__c : null;
		fnd.vendorProductCatalogId = (location != null) ? location.VendorProductCatalogId__c : null;
		fnd.vendorProductCode =  (location != null) ? location.VendorProductCode__c : null;
		fnd.lineConnectionStatus = (location != null) ? location.lineConnectionStatus__c : null;
		return fnd;
	}

    private static FixedNetFlag createFixedNetFlags(Activation_line__c activationLine) {
		FixedNetFlag fnf = new FixedNetFlag();
		fnf.customerRequestsChangeProvider = false;
		fnf.plugPresentPositiveValidation = activationLine.plugPresentPositiveValidation__c;
		fnf.diggingNeeded = activationLine.Is_Digging_Needed__c;
		fnf.activeBlockingLinePresent = activationLine.Active_Blocking_Line_Present__c;
		fnf.plugTechnicianRequired = activationLine.Plug_Technician_Required__c;
		return fnf;
	}

    private static Address createInstallationAddress(Activation_line__c activationLine) {
        Location_Line__c location = locationsByIds.get(activationLine.Location_Line__c);
        Address addr = createAddress(activationLine); // Get base address fields
        addr.municipalityCode = String.valueOf(activationLine.Municipality_Code__c);
		addr.streetCode = String.valueOf(activationLine.Street_Code__c);
		addr.addressRefId = (location != null) ? location.AddressRefId__c : null;
		addr.siteId = (location != null) ? location.SiteId__c : null;
        return addr;
    }

    private static Party createLegalParty(Activation_line__c activationLine) {
		Party p = new Party();
		p.type = TYPE_PERSON;
		p.email = activationLine.Email__c;
		p.firstName = activationLine.First_name__c;
		p.lastName = activationLine.Last_name__c;
		p.telephoneNumber = createTelephone(activationLine);
		p.address = createAddress(activationLine);
		return p;
	}

    private static Telephone createTelephone(Activation_line__c activationLine) {
        Telephone t = new Telephone();
        t.countryCode = COUNTRY_CODE;
		t.localNumber = activationLine.Mobile_no__c;
        return t;
    }

    private static Address createAddress(Activation_line__c activationLine) {
		Address addr = new Address();
		Location_Line__c location = locationsByIds.get(activationLine.Location_Line__c);

		addr.streetName = (location != null && location.Street_Name__c != null) ? location.Street_Name__c : activationLine.Street_Name__c;
		addr.city = (location != null && location.City__c != null) ? location.City__c : activationLine.City__c;
		addr.streetNumber = cleanHouseNumber((location != null && location.Number__c != null) ? location.Number__c : activationLine.Number__c);
		addr.streetNumberSuffix = cleanHouseLetter((location != null && location.Number__c != null) ? location.Number__c : activationLine.Number__c);
		addr.floorNumber = (location != null && location.Floor__c != null) ? location.Floor__c : activationLine.Floor__c;
		addr.doorNumber = (location != null && location.Door__c != null) ? location.Door__c : activationLine.Door__c;
		addr.zipCode = (location != null && location.ZIP_Code__c != null) ? location.ZIP_Code__c : activationLine.ZIP_Code__c;
		addr.country = DEFAULT_COUNTRY;

		return addr;
	}

    private static String cleanHouseNumber(String houseNumber) {
		if (houseNumber == null) return null;
		return houseNumber.replaceAll('[A-Za-z]', '');
	}

	private static String cleanHouseLetter(String houseNumber) {
		if (houseNumber == null) return null;
		return houseNumber.replaceAll('[^A-Za-z]', '');
	}

    private static String getSpeedFromProductName(Activation_line__c activationLine) {
		String productName = activationLine.Product__c;
		if (productName != null && productName.contains('Mbit/s')) {
			List<String> splittedName = productName.split(' ');
			return splittedName.get(splittedName.size() - 2);
		}
		return null;
	}

    // --- Passthrough for existing functionality ---
    /**
    * @description Parses a JSON response string into the appropriate Order DTO.
    *              It uses a discriminator 'type' field in the JSON to decide which
    *              subclass to instantiate (OrderVoice, OrderInternet, or base Order).
    * @param jsonInput The raw JSON string from the API response.
    * @return An instance of the appropriate Order subclass.
    */
    public static Order parse(String jsonInput) {
        System.JSONParser parser = System.JSON.createParser(jsonInput);
        if (parser.nextToken() != System.JSONToken.START_OBJECT) return null;
        String orderType = null;
        // scan for discriminator 'type' without consuming whole stream
        Integer depth = 0;
        while(parser.getCurrentToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME && parser.getText() == 'type') {
                parser.nextToken();
                orderType = parser.getText();
                break;
            }
            if (parser.nextToken() == null) break;
        }
        // create fresh parser so parsing methods see full document
        parser = System.JSON.createParser(jsonInput);
        if ('Voice' == orderType) return OrderVoice.parse(parser);
        if ('Internet' == orderType) return OrderInternet.parse(parser);
        return Order.parse(parser);
    }

    /*******************************************************************************************************
    * @description Inner request class to hold parameters for Root BAN creation
    *******************************************************************************************************/
    public class RootBanRequest {
		public Account inputAccount;
		public Opportunity inputOppoty;
		public String companyName;
		public String billingAtt;
		public String email;
		public String streetName;
		public String streetNumber;
		public String postalCode;
		public String city;
		public String country;
		public String BanType;
	}

    /*******************************************************************************************************
    * @description Creates a fully formed Order object for creating a new Root BAN.
    * @param request The request object containing all necessary data.
    * @return A new Order object configured for Root BAN creation.
    *******************************************************************************************************/
    public static Order createRootBanOrder(RootBanRequest request) {
        api = MetadataSelector.getAPISettings('OrderAPIHomeOfficeSettings');

        Order order = new Order();
        order.brand = api.brand__c;
        order.segment = DEFAULT_SEGMENT;
        order.channel = api.channel__c;
        order.dealer = createDealer(); // Re-uses dealer logic

        // Root BAN specific flags
        Flag rootBanFlag = new Flag();
        rootBanFlag.homeOfficeOrder = (request.BanType == 'Home Office');
        order.flags = new List<Flag>{ rootBanFlag };

        // Orderer
        // Note: The original DAO had a separate 'Orderer' class. Here we reuse OrganizationParty.
        order.orderer = createRootBanOrderer(request);

        // Order Parts
        order.orderParts = createRootBanOrderParts(request);

        return order;
    }

    private static OrganizationParty createRootBanOrderer(RootBanRequest request) {
        OrganizationParty orderer = new OrganizationParty();
        orderer.type = 'ORGANIZATION';
        orderer.name = request.companyName.left(60);
        orderer.cvr = request.inputAccount.CVR__c;

        Telephone tPhone = new Telephone();
		tPhone.countryCode = COUNTRY_CODE;
		tPhone.localNumber = request.inputAccount.Phone;
		orderer.telephoneNumber = tPhone;

        orderer.address = getBanAddress(request);
        return orderer;
    }

    private static Address getBanAddress(RootBanRequest input) {
		Address address = new Address();
		// The original RootBanServiceAction had an 'attention' field in its own Address DAO.
        // The new consolidated Address class does not. This logic will need to be revisited
        // if 'attention' is a required field for the BAN address.
		// address.attention = input.billingAtt;
		address.zipCode = input.postalCode;
		address.streetName = input.streetName;
		address.streetNumber = input.streetNumber;
		address.city = input.city;
		address.country = input.country;
		return address;
	}

    private static List<OrderPart> createRootBanOrderParts(RootBanRequest request) {
        OrderPart orderPart = new OrderPart();
        orderPart.type = TYPE_ACCOUNT;
        orderPart.activity = ACTIVITY_CREATE;

        List<OrderItem> orderItems = new List<OrderItem>();
        orderItems.add(createRootBanAccountItem(request));

        if (request.BanType == 'Home Office') {
            orderItems.add(createRootBanDiscountItem());
        }
        orderPart.orderItems = orderItems;

        return new List<OrderPart>{ orderPart };
    }

    private static OrderItem createRootBanAccountItem(RootBanRequest request) {
        OrderItem item = new OrderItem();
        item.type = TYPE_ACCOUNT_ITEM;
        item.activity = ACTIVITY_CREATE;
        item.billingCycle = 'MONTHLY';
        item.upTransferChargeCode = 'THOD22';
        item.invoiceType = 'PDF_BY_EMAIL';
        item.productGroup = (request.BanType != 'Home Office') ? 'BusinessInternet' : 'HomeOffice';
        if(item.productGroup == 'BusinessInternet' || item.productGroup == 'HomeOffice'){
			item.category = 'VIP_TML_ROOT';
		}

        item.legalParty = createRootBanLegalParty(request.inputAccount, request.billingAtt);
        item.billingParty = createRootBanBillingParty(request.inputAccount, request.billingAtt);
        return item;
    }

    private static OrderItem createRootBanDiscountItem() {
        OrderItem discountItem = new OrderItem();
        discountItem.type = 'DISCOUNT_ITEM';
        discountItem.activity = ACTIVITY_CREATE;
        discountItem.discountCode = 'HOF001';
        return discountItem;
    }

    private static OrganizationParty createRootBanLegalParty(Account acc, String attention) {
        OrganizationParty legalParty = new OrganizationParty();
        legalParty.type = 'ORGANIZATION';
        legalParty.name = acc.Name.left(60);
        legalParty.cvr = acc.CVR__c;

        Telephone tPhone = new Telephone();
		tPhone.countryCode = COUNTRY_CODE;
		tPhone.localNumber = acc.Phone;
        legalParty.telephoneNumber = tPhone;

        legalParty.address = getLegalAddress(acc, attention);
        return legalParty;
    }

    private static BillingParty createRootBanBillingParty(Account acc, String attention) {
        BillingParty billingParty = new BillingParty();
        billingParty.type = 'ORGANIZATION';
		billingParty.name = acc.Name.left(60);
		billingParty.cvr = acc.CVR__c;

        BillingParty.TelephoneNumberCCode tPhone = new BillingParty.TelephoneNumberCCode();
        tPhone.countryCode = COUNTRY_CODE;
        billingParty.telephoneNumber = tPhone;

        billingParty.address = getLegalAddress(acc, attention);
        return billingParty;
    }

    private static Address getLegalAddress(Account input, String attention) {
        Address address = new Address();
        // The original RootBanServiceAction had an 'attention' field in its own Address DAO.
        // The new consolidated Address class does not. This logic will need to be revisited.
		// address.attention = attention;
		address.zipCode = input.BillingPostalCode;
		address.streetName = input.Billing_Street_Name__c;
		address.streetNumber = input.Billing_Street_Number__c;
		address.streetNumberSuffix = input.Billing_Street_Number_Suffix__c;
		address.floorNumber = input.Billing_Floor_Number__c;
		address.city = input.BillingCity;
		address.country = input.BillingCountry;
        // The original also had logic to map door direction vs number.
        // This should be added back if required.
		return address;
    }
}