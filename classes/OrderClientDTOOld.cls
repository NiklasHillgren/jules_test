public class OrderClientDTOOld {
	public virtual class Order {
        /** @description The brand context for the order (e.g., 'TDC'). */
        public String brand;
        /** @description The sales channel through which the order was placed (e.g., 'B2B'). */
        public String channel;
        /** @description The customer segment (e.g., 'B2B'). */
        public String segment;
        /** @description The dealer associated with the order. */
        public Dealer dealer;
        /** @description The party placing the order, especially for Root BAN creation. */
        public Party orderer;
        /** @description A list of order parts, which form the hierarchical structure of the order. */
        public List<OrderPart> orderParts;
        /** @description Indicates if the response contains validation errors. */
        public Boolean hasValidationErrors;
        /** @description A list of validation errors. */
        public List<ValidationErrors> validationErrors;
    }
    
    public class OrderVoice extends Order {
        public String createdBy;
        public List<HardwareDelivery> hardwareDeliveries;
        
        public OrderVoice(){ 
            hardwareDeliveries = new List<HardwareDelivery>(); 
        }
    }
    
    public class OrderInternet extends Order {
    	public String implementationCaseId;

        /** @description A list of flags that control order processing behavior. */
        public List<Flag> flags;
        public OrderInternet(){ }
	}

    public virtual class OrderItem {
        /** @description The type of order item (e.g., 'SUBSCRIPTION_ITEM', 'ACCOUNT_ITEM', 'DISCOUNT_ITEM'). */
        public String type;
        /** @description The activity being performed (e.g., 'CREATE', 'CHANGE'). */
        public String activity;
        /** @description The specific code or ID for the product. */
        public String productCode;
        /** @description The quantity of the product/service. */
        public Integer quantity;
        /** @description The offering details, such as price plan and campaign. */
        public Offering offering;
        /** @description The legal party associated with this item, particularly for account creation. */
        public Party legalParty;
       
        
        public Boolean productDeliveryAsap;
        /** @description The desired invoice method (e.g., 'PDF_BY_EMAIL'). */
        public String invoiceType;
        /** @description The billing frequency (e.g., 'MONTHLY'). */
        public String billingCycle;
        /** @description The category of the product (e.g., 'VIP_TML_ROOT'). */
        public String category;
            /** @description The category of the product (e.g., 'VIP_TML_ROOT'). */
        public String paymentMethod;
    
        /** @description A list of validation errors specific to this order item. */
        public List<ValidationErrors> validationErrors;
    
        /**
        * @description Default constructor, initializes lists.
        */
        public OrderItem(){ validationErrors = new List<ValidationErrors>(); }

    }
    
    public class OrderItemInternet extends OrderItem {
        /** @description A nested object containing the technical details of the fixed net connection. */
        public FixedNetDetail fixedNetDetails;
        /** @description The overall price details for the order. */
        public Price price;
        /** @description The customer's preferred date for service activation. */
        public Date preferredActivationDate;
        /** @description A flag to request As-Soon-As-Possible delivery for any related products. */
        public Boolean productDeliveryAsap;
        /** @description A charge code for transfers. */
        public String upTransferChargeCode;
        /** @description A discount code to be applied. */
        public String discountCode;
        
        public String feeId;
        public String feeType;
        public String displayName;
        public String label;
        public String billingCode;
        public String productGroup;
        public Boolean recurring;

    }
    
    public class OrderItemVoice extends OrderItem {
        public Integer id;
        public String publishLevel;
        public Telephone telephoneNumber;
        public String telephoneNumberCategory;
        public String donorSimNumber;
        public String poaDocumentUrl;
        public String poaDocumentId;
        public Boolean powerOfAttorneyManualHandling;
        public String earliestPortingDate;
        public Party subscriptionUser;
        public HardwareDetail hardwareDetail;
        public SimDetail simDetail;
        public ShippingDetail shippingDetail;
        /** @description The type of product. */
        public String productType;
        /** @description The billing party for this item, used in Root BAN creation. */
        public Party billingParty;
        public TerminationPeriod terminationPeriod;
    }
    
    public virtual class OrderPart {
        /** @description The activity being performed on this part of the order (e.g., 'CREATE', 'CHANGE'). */
        public String activity;
        /** @description The type of entity this order part represents (e.g., 'ACCOUNT', 'SUBSCRIPTION'). */
        public String type;
        /** @description A list of individual items (products, services, fees) within this order part. */
        public List<OrderItem> orderItems;
        /** @description A list of nested order parts to create a hierarchical structure. */
        public List<OrderPart> orderParts;
        /** @description A list of references to other entities, like a Billing Account Number. */
        public List<Reference> references;
     
        /** @description A list of validation errors specific to this order part. */
        public List<ValidationErrors> validationErrors;
    
        /**
        * @description Default constructor, initializes lists.
        */
        public OrderPart(){ 
            orderItems = new List<OrderItem>(); 
            references = new List<Reference>(); 
            orderParts = new List<OrderPart>(); 
            validationErrors = new List<ValidationErrors>(); 
        }
    }
    
    public class OrderPartInternet extends OrderPart {
        /** @description A channel-specific identifier for this part of the order, typically the Salesforce Record ID of the Activation Line. */
        public String channelOrderPartId;
    }
    
    public class OrderPartVoice extends OrderPart {
    	public String orderPartVoiceId;
    }
    
    public virtual class Party {
        /** @description The first name of the person. */
        public String firstName;
        /** @description The last name of the person. */
        public String lastName;
        /** @description The type of party (e.g., 'PERSON', 'ORGANIZATION'). */
        public String type;
        /** @description The email address of the party. */
        public String email;
        public String cvr;
        public String cpr;
        public String birthDate;
        /** @description The address of the party. */
        public Address address;
        /** @description The telephone number of the party. */
        public Telephone telephoneNumber;

    }
    
    public class OrganizationParty extends Party {
        /** @description The legal name of the organization. */
        public String name;
        /** @description The CVR (company registration) number of the organization. */
        public String cvr;
    }
    
    public class Parameter {
        /** @description The target or field the error relates to. */
        public String target;
        /** @description The reason for the error. */
        public String reason;
    }
    
    public class Price {
    	public String priceCurrency;
    	public Decimal amount;
        public Decimal vat;
    }
    
    public class Recipient {
    	public String type;
    	public String name;
    	public String cvr;
    	public Address address;
    	public String email;
        public Telephone telephoneNumber;
    }
    
    public class Reference {
    	/** @description The type of reference (e.g., 'BILLING_ACCOUNT_NUMBER'). */
    	public String type;
    	/** @description The value of the reference (e.g., the actual BAN). */
    	public String value;
    }
    
    public class ShippingDetail {
        public Integer hardwareDeliveryId;
        public Integer toDeliverQuantity;
        public String erpTsProduct;
        public String tsfOffering;
    }
    
    public class SimDetail {
    	public String simType;
    	public Boolean waiveSimSwapFee;
    	public String hardwareType;
    }
    
    public class Address {
        /** @description The name of the street. */
        public String streetName;
        /** @description The house number on the street. */
        public String streetNumber;
        /** @description The suffix for the house number (e.g., 'A', 'B'). */
        public String streetNumberSuffix;
        /** @description The floor number. */
        public String floorNumber;
        /** @description The door number or apartment number. */
        public String doorNumber;
        /** @description The direction of the door (e.g., 'tv', 'th'). */
        public String direction;
        /** @description The city name. */
        public String city;
        /** @description The postal zip code. */
        public String zipCode;
        /** @description The country, typically in 3-letter ISO format (e.g., 'DNK'). */
        public String country;
        /** @description The official municipality code. */
        public String municipalityCode;
        /** @description The official street code. */
        public String attention;
        /** @description A reference ID for the address from an external system. */
        public String coName;
    }
    
    public class BillingParty {
        /** @description The type of party, typically 'ORGANIZATION' for a Root BAN. */
        public String type;
        /** @description The telephone number, containing only a country code for this specific DTO. */
        public TelephoneNumberCCode telephoneNumber;
        /** @description The legal name of the organization. */
        public String name;
        /** @description The CVR (company registration) number of the organization. */
        public String cvr;
        /** @description An optional label for the billing party. */
        public String label;
        /** @description The address of the billing party. */
        public Address address;
    }
    
    public class TerminationPeriod {
    	public Integer amount;
        public String unit;
    }
    
    public class Telephone {
        /** @description The international country code (e.g., '45' for Denmark). */
        public String countryCode;
        /** @description The local part of the telephone number. */
        public String localNumber;
    }
    
    public class Dealer {
        public String dealerCode;
    }
    
    /**
    * @description Represents a telephone number with only a country code, for use within the BillingParty DTO.
    */
    public class TelephoneNumberCCode {
        /** @description The international country code. */
        public String countryCode;
    }
    
    public class FixedNetDetail {
        /** @description A nested object containing boolean flags specific to the fixed net connection. */
        public FixedNetFlag fixedNetFlags;
        /** @description The physical address where the service will be installed. */
        public Address installationAddress;
        /** @description The download speed for the connection (e.g., "1000"). */
        public String speedDown;
        /** @description The upload speed for the connection (e.g., "1000"). */
        public String speedUp;
        
        public Boolean providerReuseOfAddress;
        public String previousEmployerAdminEmail;    
        
        /** @description Flag indicating if the customer will perform a Do-It-Yourself installation. */
        public Boolean doItYourselfInstallation;
        /** @description The underlying network vendor (e.g., 'TDC', 'Norlys'). */
        public String vendor;
        /** @description The vendor's specific code for the product. */
        public String vendorProductCode;
        /** @description The vendor's catalog ID for the product. */
        public String vendorProductCatalogId;
        /** @description The current status of the physical line connection. */
        public String lineConnectionStatus;
    }
    
    public class FixedNetFlag {
        /** @description Indicates if the customer is requesting to change providers. */
        public Boolean customerRequestsChangeProvider;
        /** @description Indicates if digging is required for the installation. */
        public Boolean diggingNeeded;
        /** @description Indicates a positive validation that a plug is present at the installation address. */
        public Boolean plugPresentPositiveValidation;
        /** @description Indicates if there is an active, blocking line at the address. */
        public Boolean activeBlockingLinePresent;
        /** @description Indicates if a technician is required to install a plug. */
        public Boolean plugTechnicianRequired;
    }
    
    public class Flag {
        /** @description Indicates if the order requires manual confirmation. */
        public Boolean needsConfirmation;
        /** @description Indicates if the necessary consents have been accepted. */
        public Boolean consentAccepted;
        /** @description Indicates if the terms and conditions have been accepted. */
        public Boolean termsAccepted;
        /** @description A specific flag for Home Office orders. */
        public Boolean homeOfficeOrder;
        /** @description A flag indicating that the order is 'dirty' and requires the API to fetch additional information. */
        public Boolean dirty;
    }
    
    public class HardwareDelivery {
        public Integer id;
        public String deliveryMethod;
        public String preferredContactMethod;
        public Recipient recipient;
        public Price deliveryPrice;
        public Party billingParty;
    }
    
    public class HardwareDetail {
        public String materialId;
        public String hardwareType;
        public String name;
    }
    
    public class ValidationErrors {
        /** @description The code for the validation error. */
        public String errorCode;
        /** @description A list of parameters providing more detail about the error. */
        public List<Parameter> parameters;
    
        public ValidationErrors(String errorCode, List<Parameter> parameters) {
            this.errorCode = errorCode;
            this.parameters = parameters;
        }
    }
    
    public class Offering {
        /** @description The code for the price plan associated with the offering. */
        public String priceplan;
        /** @description The code for the campaign associated with the offering. */
        public String campaign;
        /** @description A unique identifier for the product offering. */
        public String productOfferingId;
    }
}