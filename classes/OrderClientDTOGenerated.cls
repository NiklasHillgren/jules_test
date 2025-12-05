public class OrderClientDTOGenerated {
    public enum AccountControlOption {
        BLOCK,
        NO_BLOCK,
        SOFT_BLOCK,
        FORCE_BLOCK
    }

    public enum AccountItem_BillingCycleEnum {
        MONTHLY,
        QUARTERLY
    }

    public enum AccountItem_InvoiceTypeEnum {
        PDF_BY_EMAIL,
        PAPER_INVOICE,
        OIO
    }

    public enum AccountItem_CategoryEnum {
        AXAPTA_B2B,
        AXAPTA_WHOLESALE,
        BG_BANK,
        CALL_ME_PREPAID_MIGRATED,
        CALL_ME_PREPAID_MIG,
        CALL_ME_RKI,
        CALL_ME_PRIVATE,
        CALL_ME_COMPANIES,
        CALL_ME_SMALL_COMPANIES,
        COMPANIES,
        COMPANY_EMPLOYEES,
        EMPLOYEE_BROADBAND,
        EXCEPTIONAL_CONTROL_ACCOUNT,
        GENSELGERE_B2B2B,
        GENSELGERE_B2B2C,
        HOLM_ERHVERV,
        HOLM_PRIVATE,
        KISBI_ENTERPRISE,
        KISBI_SOHO,
        MAJOR_COMPANIES,
        TELIA_PRIVATE,
        RESELLERS,
        SMALL_MEDIUM_COMPANY,
        SOHO,
        TELIA,
        VERO_SME,
        VERO_SOHO,
        VIP_BUSINESS,
        VIP_EXCELLENCE,
        VIP_GS_ICC,
        VIP_IPA,
        VIP_PREMIUM,
        VIP_SWEDISH_VAT,
        VIP_TML_ROOT,
        VIP
    }

    public class AccountItem extends OrderItem {
        public String billingAccountNumber;
        public PartyRole legalParty;
        public PartyRole billingParty;
        public AccountItem_BillingCycleEnum billingCycle;
        public AccountItem_InvoiceTypeEnum invoiceType;
        public Integer delayOfPayment;
        public PaymentMethod paymentMethod;
        public Bank bank;
        public String ean;
        public String label;
        public String upTransferChargeCode;
        public AccountItem_CategoryEnum category;
        public String productGroup;
    }

    public class AccountOwnerControlItem extends OrderItem {
        public AccountControlOption nationalUsageAllowance;
        public AccountControlOption roamingCostControl;
        public AccountControlOption retailRoaming;
        public Boolean unlimited;
        public Integer costLimit;
    }

    public enum AdditionalProductItem_ProductCategoryEnum {
        VOICE,
        MESSAGE,
        DATA,
        VAS,
        DISCOUNT,
        SERVICE,
        BARRING,
        OSPACKAGE,
        QOS,
        SIM,
        ESIM,
        HARDWARE,
        BROADBAND,
        EXTRADATACARD,
        INSURANCE,
        TV,
        DSL,
        FIBER,
        COAX,
        TPX
    }

    public class AdditionalProductItem extends OrderItem {
        public String productCode;
        public String productName;
        public AdditionalProductItem_ProductCategoryEnum productCategory;
        public List<String> productCategories;
        public Amount recurringPrice;
        public String discountCode;
        public Amount unitPrice;
        public Integer quantity;
        public SimDetails simDetails;
        public HardwareDetails hardwareDetails;
        public ShippingDetails shippingDetails;
        public ReturnDetails returnDetails;
    }

    public enum Address_TypeEnum {
        DANISH_ADDRESS,
        UNSTRUCTURED_ADDRESS
    }

    public virtual class Address {
        public Address_TypeEnum addressType;
        public String city;
        public String zipCode;
        public String country;
        //Name of C/O (in care of) person.
        public String coName;
        //Name of person (recipient). Mainly used for organization addresse where recipient is a specific person.
        public String attention;
    }

    public enum Amount_CurrencyEnum {
        DKK
    }

    public class Amount {
        public Decimal amount;
        public Decimal vat;
        public Amount_CurrencyEnum currencyValue; //TODO currency is keyword
        public Decimal catalogAmount;
        public Decimal catalogVat;
        public Discount discount;
    }


    /**
     * list of application ids
     */
    public enum ApplicationId {
        DOCUMENT_API,
        DIVA,
        POINT_OF_SALES,
        ENTERPRISE_SELF_SERVICE,
        DK_RPA_BLUEPRISM,
        SIMPLE_QUEUE_SERVICE
    }

    public class Bank {
        public String branch;
        public String accountNumber;
        public String name;
    }

    public class BankAccount {
        public String bankName;
        public String bankBranchCode;
        public String accountNumber;
    }

    /**
     * List of brands
     */
    public enum Brand {
        TELIADK,
        CALLME,
        MITTELE
    }

    public class CallForwardingItem extends OrderItem {
        public ForwardingSetting all;
        public ForwardingSetting inCall;
        public ForwardingSetting noContact;
        public NoAnswerForwardingSetting noAnswer;
    }

    public class CallWaitItem extends OrderItem {
        public Boolean enabled;
    }

    public class CardPaymentMethodDetail extends PaymentMethodDetail {
        public CreditCard creditCard;
    }

    public class ChangeActivationDateOrderPatch {
        public String teliaCircuitId;
        public Date newActivationDate;
    }

    public class ChargeItem extends OrderItem {
        public String chargeCode;
        public Amount price;
        public String description;
    }

    public class Consent {
        public Boolean writtenConsentGiven = false;
        public PhysicalIdentification consentById;
    }

    public class ConsentItem extends OrderItem {
        public String consentId; //UUID
        public Integer version;
        public String state;
    }

    public class CreditCard {
        public String name;
        public String maskedPan;
        public String token;
        public Date expirationDate;
    }

    public enum CreditEvaluationDetails_EmploymentTypeEnum {
        EMPLOYEE,
        HOMEMAKERS,
        RETIRED,
        SELF_EMPLOYED,
        STUDENT,
        UNEMPLOYED,
        OTHER,
        UNKNOWN
    }

    public enum CreditEvaluationDetails_ResidentialStatusEnum {
        COOPERATIVE,
        CONDOMINIUM,
        LIVING_HOME,
        RENTING,
        OTHER
    }

    /**
     * Details of credit evaluation, so that it can be retried.
     */
    public class CreditEvaluationDetails {
        public CreditEvaluationDetails_EmploymentTypeEnum employmentType;
        public CreditEvaluationDetails_ResidentialStatusEnum residentialStatus;
        public PaymentMethod paymentMethod;
        public Decimal creditLimit;
        public String creditClass;
    }

    public class CreditWatchItem extends OrderItem {
        public Decimal amount;
        public Boolean waiveFees;
        public Date expirationDate;
    }

    public class DanishAddress extends Address {
        public String streetName;
        public String streetNumber;
        public String streetNumberSuffix;
        public String floorNumber;
        public String doorNumber;
        public String direction;
        public String locality;
    }

    /**
     * the dealer organization that made the order
     */
    public class Dealer {
        //Required - code of the dealer like '1018'.
        public String dealerCode;
        public String dealerName;
        public String salesAgentCode;
        public String salesAgentName;
        public String posDealerId;
        public String posSalesAgentId;
    }

    public class Discount {
        public Decimal amount;
        public Decimal vat;
        public Decimal percentage;
        public String comment;
        public String reason;
    }

    public class DiscountItem extends OrderItem {
        public String discountCode;
        public String reason;
    }

    public class Document {
        public String documentType;
        public String url;
    }

    public enum DownPaymentPlan_DownPaymentTypeEnum {
        MOBILE_AGREEMENT,
        CREDIT_AGREEMENT
    }

    public enum DownPaymentPlan_CreditProviderEnum {
        CALL_ME,
        TELIA_DK,
        TELIA_FINANCE,
        RESURS
    }

    public class DownPaymentPlan {
        public DownPaymentPlan_DownPaymentTypeEnum downPaymentType;
        public DownPaymentPlan_CreditProviderEnum creditProvider;
        public PaymentAmount downPaymentAmount;
        public PaymentAmount installmentAmount;
        public Decimal numberOfInstallments;
    }

    public class ErrorContent {
        public String code;
        public String message;
        public List<ErrorParameter> parameters;
    }

    public class ErrorParameter {
        public String name;
        public String value;
    }

    public class ErrorResponse {
        public ErrorContent error;
    }

    public enum FeeItem_FeeTypeEnum {
        ACT_FEE,
        ACT_FEE_EXVAT,
        ACT_FEE_DISCOUNT,
        ADMIN_FEE,
        ADMIN_FEE_EXVAT,
        ADMIN_FEE_CREDIT_ACCOUNT,
        ADMIN_FEE_CREDIT_ACCOUNT_EXVAT,
        ADMIN_FEE_GIRO,
        ADMIN_FEE_GIRO_EXVAT,
        ADMIN_FEE_PBS,
        ADMIN_FEE_PBS_EXVAT,
        ADMIN_FEE_PAYMENT_CARD,
        INSTALLATION_FEE,
        PAYMENT_FEE,
        PRO_FEE,
        PRO_FEE_EXVAT,
        PRO_FEE_DISCOUNT,
        SHIPMENT_FEE,
        SIGN_UP_FEE,
        SIM_SWAP_FEE,
        SIM_SWAP_FEE_EXVAT,
        TRANSFER_FEE,
        TRANSFER_FEE_EXVAT
    }

    public class FeeItem extends OrderItem {
        public FeeItem_FeeTypeEnum feeType;
        public String billingCode;
        public String displayName;
        public Amount price;
        public Boolean waived;
    }

    public class FixedNetDetails {
        public FixedNetFlags fixedNetFlags;
        public String internalCircuitId;
        public Integer diggingDistance;
        public InstallationAddress installationAddress;
        public InstallationAddress lastMileAccessPointAddress;
        public String speedProduct;
        public String technicalProduct;
        public String speedDown;
        public String speedUp;
        public String packageId;
        public String accessType;
        public String dslTechnologyType;
        public String previousTdcCircuitId;
        public String destinationTdcCircuitId;
        public String previousLinePhoneNumber;
        public String destinationLinePhoneNumber;
        public String ipAddressType;
        public String cpeMode;
        public String dslType;
        public String sla;
        public String addExtraBeChannel;
        public String allowRedColor;
        public List<NetworkConfiguration> networkConfiguration;
        public String flowType;
        public String doItYourselfInstallation;
        public String doItYourselfContactName;
        public String doItYourselfContactNumber;
        public String providerReuseOfAddress;
        public String providerAoCustomerRefNumber;
        public String currentProviderName;
        public String aoCustomerReference;
        public String vendor;
        public String vendorProductCode;
        public String vendorProductCatalogId;
        public String customerProductId;
        public String existingVendorProductCode;
        public Boolean fixedIp;
        public List<OrderEventDetails> events;
    }

    public class FixedNetFlags {
        public Boolean skipStateEvent;
        public Boolean skipCpeTechnician;
        public Boolean skipIp;
        public Boolean skipInvoice;
        public Boolean hasInstallationTypeConflict;
        public Boolean manualChangeProvider;
        public Boolean coaxDifferentProvider;
        public Boolean diggingNeeded;
        public Boolean manualOrdering;
        public Boolean moveToDifferentAddress;
        public Boolean lineTakeOver;
        public Boolean activeBlockingLinePresent;
        public Boolean activeLineTerminated;
        public Boolean plugPresentPositiveValidation;
        public Boolean providerChangeAccountNumberMissing;
        public Boolean customerRequestsChangeProvider;
    }

    public class ForwardingSetting {
        public Boolean enabled;
        public String targetNumber;
    }

    public class GiroPaymentMethodDetail extends PaymentMethodDetail {
    }

    public enum HardwareDelivery_PreferredContactMethodEnum {
        PHONE,
        EMAIL
    }

    public class HardwareDelivery {
        //Unique identifier of hardware delivery.
        public Integer id;
        public PartyRole recipientParty;
        public PartyRole billingParty;
        //String identifier of delivery method.
        public String deliveryMethod;
        public Amount deliveryPrice;
        public HardwareDelivery_PreferredContactMethodEnum preferredContactMethod;
        //Date time with timezone according to ISO-8601.
        //Timestamp of when the hardware has been sent out from warehouse.
        public DateTime dispatchDate;
        public DateTime prefferedSendDate;
    }

    public class HardwareDetails {
        public String materialId;
        public HardwareType hardwareType;
        public String name;
        public List<SerialNumber> serialNumbers;
        //Type of package
        public String packageType;
    }

    public class HardwarePaymentConfigurationPatch {
        public PaymentType paymentType;
        public PaymentAmount totalPayment;
        public PaymentAmount upfrontPayment;
        public PaymentAmount downPayment;
        public Discount discount;
        public Decimal numberOfInstallments;
    }

    public class HardwarePaymentItem extends OrderItem {
        public PaymentType paymentType;
        //id of purchase in PaymentAPI
        public String purchaseId;
        public PaymentAmount totalPayment;
        public PaymentAmount upfrontPayment;
        public DownPaymentPlan downPaymentPlan;
    }

    /**
     * Order item containing info about hardware swapping
     */
    public class HardwareSwapItem extends OrderItem {
        // Status of hardware shipping
        public String shippingStatus;
        //Serial number of old hardware to swap
        public String oldSerialNumber;
    }

    /**
     * Type of hardware.
     */
    public enum HardwareType {
        SIM,
        HANDSET,
        LAPTOP,
        ACCESSORY,
        TABLET,
        MODEM,
        FEMTO,
        IWATCH,
        OTHER
    }

    public class HomeOfficeOrderPatch {
        public Person legalParty;
        public Person billingParty;
        public InstallationAddress installationAddress;
        public Person recipientParty;
        public String vendor;
        public String employeeId;
    }

    public class InstallationAddress {
        public Address postalAddress;
        public String streetCode;
        public String municipalityCode;
        public String siteId;
        public String kvh;
        public String kvhx;
        //This attribute is sent to LineInquiryAPI as DawaId.
        //The field in LineInquiryAPI request for this is called addressId.
        public String addressRefId;
    }

    public class IpConfiguration {
        public String ip;
        public String netmask;
        public String defaultGateway;
    }

    public class MarketingConsents {
        public String leadSourceId;
        public Boolean directMarketing;
        public Boolean tracking;
        public String url;
    }

    /**
     * Type representing Mobile payment method detail
     */
    public class MobilePaymentMethodDetail extends PaymentMethodDetail {
        public String mobilePayAgreementId;
    }

    public class NetworkConfiguration {
        public String cpeName;
        public String qosProfileName;
        public String vrfName;
        public String vpnInstance;
        public String pppMultilinkGroup;
        public String ipHelper;
        public String routingProtocol;
        public String asNumber;
        public String timeslots;
        public String internetPorts;
        public String cpeSerial;
        public String mobileDialerIp;
        public String mobileCpeSerial;
        public String mobileNetworkIp;
        public String mobileNetworkNetmask;
        public String proactivity;
        public String proactivityProactivityPhone;
        public IpConfiguration secondaryLanIpConfig;
        public IpConfiguration staticRouteIpConfig;
        public IpConfiguration snmpAclIpConfig;
        public String linkIpNetworkNetmask;
        public String linkIpNetworkIp;
        public String lanIpAddressIp;
        public String lanIpAddressNetmask;
        public String lanIpAddressHsrip;
        public String dhcpAddressRange;
        public String dhcpLeaseTime;
        public String dhcpDomainName;
        public String dhcpWinsPrimary;
        public String dhcpWinsSecondary;
        public String dhcpDnsPrimary;
        public String dhcpDnsSecondary;
        public String snmpCommunity;
    }

    public class NoAnswerForwardingSetting {
        public Boolean enabled;
        //Where to forward calls. Parameter is mandatory if enabled is set to true.
        public String targetNumber;
        public Integer delay;
    }

    public enum NotificationRecipient_RoleEnum {
        CUSTOMER,
        SALES_AGENT,
        SALES_MANAGER,
        EXTERNAL_SHIPPING_PARTNER
    }

    /**
     * Recipients registered here should be notified upon event that interests given role. 
     * So far used only to return recipients on NEO orders.
     */
    public class NotificationRecipient {
        public NotificationRecipient_RoleEnum role;
        public String email;
        public String telephoneNumber;
    }

    /**
     * Codes identifying the ordered service.
     */
    public class Offering {
        //Priceplan SOC code.
        public String priceplan;
        //Campaign SOC code.
        public String campaign;
        //Discount SOC code.
        public String discount;
        //Name of the whole offering that&#x27;s to be displayed on web or documents.
        public String name;
        //Type of the product (GSM, ...).
        public String bindingPeriod;
        public Amount monthlyPrice;
    }

    public class OrderAdditionalInfoPatch {
        public String orderMemo;
    }

    public class OrderApproval {
        public String approvalComment;
        public String approvalIp;
    }

    public class OrderCollectionResponse {
        public List<OrderV10> data;
        public Integer pageSize;
        //Link to the next page of orders.
        public String nextLink;
    }

    public class OrderEventDetails {
        public String category;
        public String description;
        public Date expectedCompletionDate;
        public Integer id;
        public Date startDate;
        public String purchaseOrderId;
        public String state;
        public TechnicianDetails technicianDetails;
    }

    public class OrderFlags {
        //Whether the order is confirmed or approved.
        public Boolean orderConfirmed;
        //If customer agrees with terms and conditions. Must be true :)
        public Boolean termsAccepted;
        //If the CPR check failed.
        public Boolean cprCheckFailed;
        //When the credit check failed.
        public Boolean creditCheckFailed;
        //Customer shall confirm the order as sales agent made it on their behalf.
        public Boolean needsConfirmation;
        //If there is any membership to be checked (voucher number or so)
        public Boolean membershipCheck;
        //The order is missing mandatory information
        public Boolean dirty;
        //Shall the backend send communication
        public Boolean doCommunication;
        //Shall the backend send request for hardware shipment
        public Boolean doLogistics;
        public Boolean addCharge;
        //Order has been created via new POS
        public Boolean posFlow;
        //If order represents Home Office order
        public Boolean homeOfficeOrder;
        //If draft order should be created during shopping cart submission
        public Boolean createDraftOrder;
        //If order follows manual signing flow
        public Boolean manualSigning;
        // If order is from Tango and has only SIM AdditionalProductItems
        public Boolean simOnly;
        //If order is from Tango and has at least one upfront payment on any HardwarePaymentItem
        public Boolean hasUpfrontPayment;
        //If order is from Tango and has at least one down payment on any HardwarePaymentItem
        public Boolean tfFinancingNeeded;
        //If order is from Tango and order was sold in shop
        public Boolean physicalIdPreidentified;
        //If order is from Tango and order was sold in external store
        public Boolean shopSales;
        //If order is already expired.
        public Boolean orderExpired;
        //Go with the new DIVA flow.
        public Boolean newDivaFlow;
        //If order is a sub order. Applies to return orders.
        public Boolean isSubOrder;
    }

    public enum OrderItem_ActivityEnum {
        CREATE,
        CHANGE,
        REMOVE,
        KEEP,
        BUYBACK
    }

    public enum OrderItem_OriginEnum {
        CLIENT,
        SYSTEMVALUE //TODO SYSTEM IS KEYWORD
    }

    public virtual class OrderItem {
        public String type;
        public OrderItem_ActivityEnum activity;
        public Integer id;
        public String channelOrderItemId;
        public List<ValidationError> validationErrors;
        public OrderItem_OriginEnum origin;
    }

    public enum OrderPart_TypeEnum {
        ACCOUNT,
        SUBSCRIPTION,
        HARDWARE
    }

    public enum OrderPart_ActivityEnum {
        ACCOUNT,
        SUBSCRIPTION,
        HARDWARE
    }

    public enum OrderPart_ChangeTypesEnum {
        PRICEPLAN,
        HANDOVER,
        CALL_FORWARDING,
        SIMCARD,
        ADDITIONAL_PRODUCTS
    }

    public class OrderPart {
        public List<OrderPartReference> references;
        public OrderPart_TypeEnum type;
        public OrderPart_ActivityEnum activity;
        public List<OrderPart_ChangeTypesEnum> changeTypes;
        public ProcessingStatus processingStatus;
        public String processingStatusDetail;
        public List<OrderItem> orderItems;
        public List<OrderPart> orderParts;
        public List<ValidationError> validationErrors;
        public Integer id;
        public String channelOrderPartId;
        public String splitOrderId;
        public String taskUrl;
        public Amount partTotal;
        public Amount hardwareTotal;
        public PaymentAmount hardwareTotalUpfront;
        public Amount productTotal;
        public PaymentAmount productTotalUpfront;
        public Amount servicesRecurringTotal;
        public PaymentAmount hardwareRecurringTotal;
    }

    public enum OrderPartReference_TypeEnum {
        SUBSCRIPTION_TELEPHONE_NUMBER,
        SUBSCRIPTION_ID,
        BILLING_ACCOUNT_NUMBER,
        INTERNAL_CIRCUIT_ID,
        DOCUMENT_ID,
        DST_ORDER_ID,
        ORIGINAL_ORDER_ID
    }

    public class OrderPartReference {
        public OrderPartReference_TypeEnum type;
        public String value;
    }

    public enum OpEnum {
        ADD,
        REMOVE,
        REPLACE,
        MOVE,
        COPY
    }

    public virtual class OrderPatchRequest {
        public OpEnum op;
        public String path;
        public Object value;
        public String fromValue; //TODO from is a type in apex
    }

    //public class OrderPatchRequests extends List<OrderPatchRequest> {} TODO HOW DO WE HADNLE THIS?
    public class OrderResponse {
        public OrderV10 data;
    }

    public class OrderSource {
        public String ipAddress;
        public Decimal port;
        public Datetime captureTimeStamp;
    }

    public enum OrderV10_SegmentEnum {
        B2C,
        B2B
    }

    public virtual class OrderV10 {
        public String id;
        public String orderId;
        public String parentOrderId;
        public String channelOrderReference;
        public String implementationCaseId;
        public String bpmOrderId;
        public String noosOrderId;
        public String mitIdVerificationToken;
        public String batchId;
        public Brand brand;
        //Required - Identifying what channel the order is made in, e.g. SALES_FORCE, TANGO, SELF_SERVICE ...
        public String channel;
        //the dealer organization that made the order
        public Dealer dealer;
        public OrderV10_SegmentEnum segment;
        public DateTime createdDate;
        public DateTime completedDate;
        //public String createdBy;
        //Status of whole order (calculated from orderItems)
        public ProcessingStatus processingStatus;
        public String processingStatusDetail;
        public CreditEvaluationDetails creditEvaluationDetails;
        public List<NotificationRecipient> notificationRecipients;
        public List<ValidationError> validationErrors;
        public Boolean hasValidationErrors;
        public OrderFlags flags;
        public PartyRole orderer;
        public List<OrderPart> orderParts = new List<OrderPart>();
        public List<HardwareDelivery> hardwareDeliveries;
        public String taskUrl;
        public Amount orderTotal;
        public Amount orderMinimumPrice;
        public Amount hardwareTotal;
        public PaymentAmount hardwareTotalUpfront;
        public Amount productTotal;
        public PaymentAmount productTotalUpfront;
        public Amount servicesRecurringTotal;
        public OrderSource orderSource;
        public String confirmationUrl;
        public String documentsUrl;
        public String paymentId;
        public PilPayment payment;
        public List<Document> documents;
        public MarketingConsents consents;
        public Integer contextId;
    }

    public class OrderVoice extends OrderV10 {
        public String createdBy;
        public List<HardwareDelivery> hardwareDeliveries;
    }
    
    public class OrderInternet extends OrderV10 {
    	public String implementationCaseId;
        
        /** @description A list of flags that control order processing behavior. */
        public List<Flag> flags;
	}
    
    public class Organization extends PartyRole {
        public String name;
        public String additionalName;
        public String cvr;
    }

    public virtual class PartyRole {
        public String type;
        public String email;
        public String customerId;
        public TelephoneNumber telephoneNumber;
        public Address address;
    }

    public enum PaymentAmount_CurrencyEnum {
        DKK
    }

    public class PaymentAmount {
        public Decimal amount;
        public Decimal vat;
        public PaymentAmount_CurrencyEnum currency_x; //TODO currency is reserved
        public Decimal amountWithoutVat;
    }

    public enum PaymentMethod {
        PBS,
        GIRO,
        CARD,
        OTHER
    }

    /**
     * Order item representing payment method change
     */
    public class PaymentMethodChangeItem extends OrderItem {
        public PaymentMethodDetail paymentMethodDetail;
        public String reasonCode;
        public String memoText;
    }

    /**
     * Parent type for all specific payment method detail types
     */
    public virtual class PaymentMethodDetail {
        public String paymentMethod;
    }

    public enum PaymentType {
        EXTERNAL_PAYMENT_SERVICE,
        INVOICE,
        SHOP
    }

    public class PbsPaymentMethodDetail extends PaymentMethodDetail {
        public BankAccount bankAccount;
    }

    public class Person extends PartyRole {
        public String firstName;
        public String lastName;
        //Birthday in format YYYY-MM-DD (according to ISO 8601).
        public Date birthday;
        public String cpr;
    }

    public class PhysicalIdentification {
        public String type;
        public String value;
    }

    public class PilPayment {
        public String paymentId;
        public Date updatedAt;
        public Decimal totalAmount;
        public Decimal totalVat;
        public Decimal paymentRoundingError;
    }

    public class PortingDetailsItem extends OrderItem {
        //Id of a network operator where the number is currently registered. Also known as number owner.
        public String networkOperatorId;
        public String donorSimNumber;
        public String poaDocumentUrl;
        //Indicates whether electronic Power of Attorney can be used.
        public Boolean digitalPoaAllowed;
        //Indicates whether the POA shall be signed via manual flow.
        public Boolean powerOfAttorneyManualHandling;
        //date in format YYYY-MM-DD (according to ISO 8601).
        public Date earliestPortingDate;
        //true if customer wishes to be ported in after end of commitment at the current operator. Use instead of earliestPortingDate.
        public Boolean portAfterCommitment;
        //The date at which the porting is planned. Date in format YYYY-MM-DD (according to ISO 8601).
        public Date actualPortingDate;
        public Consent donorConsent;
        public Consent portingProcessConditionsConsent;
    }

    public class PortingDetailsUpdate {
        public TelephoneNumber telephoneNumber;
        public String donorSimNumber;
        public Consent donorConsent;
        public Consent portingProcessConditionsConsent;
    }

    /**
     * Status of whole order (calculated from orderItems)
     */
    public enum ProcessingStatus {
        RECEIVED,
        SUBMITTED,
        PROCESSING,
        FAILED,
        CANCELLED,
        COMPLETED,
        DRAFT
    }

    /**
     * Order item containing information about subscription reactivation.
     */
    public class ReactivationItem extends OrderItem {
        public String reason;
    }

    /**
     * Used for regretting subscription creation order. Currently working for broadband only.
     */
    public class RegretItem extends OrderItem {
        //Effective date in format YYYY-MM-DD (according to ISO 8601).
        public Date effectiveDate;
    }

    /**
     * Details and information about returning the hardware.
     */
    public class ReturnDetails {
        public Decimal returnQuantity;
        public String creditInvoiceNumber;
        public Date creditInvoiceDate;
    }

    public class SerialNumber {
        public String type;
        public String value;
    }

    public enum ShippingDetails_DeliveryStatusEnum {
        READY_TO_SEND_ORDER,
        ORDER_SENT,
        PICKING_GOODS_FROM_WAREHOUSE,
        WAITING_FOR_STOCK,
        IN_STOCK,
        ORDER_SENT_TO_WAREHOUSE,
        GOODS_ISSUED,
        IN_TRANSIT_TO_CUSTOMER,
        WAITING_FOR_CUSTOMER_PICKUP,
        DELIVERED,
        RETURNING_FROM_CUSTOMER,
        RETURNED_BY_COURIER,
        RETURN_APPROVED,
        NON_TRACKABLE,
        CANCELLED,
        ERROR
    }

    public class ShippingDetails {
        public Integer toDeliverQuantity;
        //tsfOffering from ProductCatalog.
        public String tsfOffering;
        //erpTsProduct from ProductCatalog.
        public String erpTsProduct;
        //Id of delivery address.
        public Integer hardwareDeliveryId;
        // UserName label for the piece of hardware
        public String userName;
        public String userId;
        public String department;
        public ShippingDetails_DeliveryStatusEnum deliveryStatus;
        public String trackAndTraceNumber;
        public String trackAndTraceUrl;
        //date in format YYYY-MM-DD (according to ISO 8601).
        public Date shippingConfirmedDate;
    }

    public enum SimDetails_SimTypeEnum {
        MAIN_HARDWARE_SIM,
        EXTRA_HARDWARE_SIM,
        MAIN_ELECTRONIC_SIM,
        EXTRA_ELECTRONIC_SIM
    }

    public class SimDetails {
        //Type of sim card
        public SimDetails_SimTypeEnum simType;
        public String icc;
        public String imsi;
        //Icc to be replaced
        public String oldIcc;
        //IMSI to be replaced
        public String oldImsi;
        //new EID.
        public String eid;
        //new IMEI.
        public String imei;
        public String bindDeviceType;
        //Name of the device to be binded.
        public String bindDeviceName;
        public String alternateSmdpFqdn;
    }

    public class SplitPaymentPatchRequest {
        public PaymentAmount totalPaymentAmount;
        public PaymentAmount upfrontPaymentAmount;
        public PaymentAmount downPaymentAmount;
        public Date numberOfInstallments;
    }

    public enum SubscriptionControlOption {
        BLOCK,
        NO_BLOCK,
        ON_BAN
    }

    public enum SubscriptionItem_TelephoneNumberCategoryEnum {
        MOBILE,
        FIXED,
        PBX,
        MISCELLANEOUS
    }

    public enum SubscriptionItem_ProductTypeEnum {
        MOBILE_VOICE,
        MOBILE_DATA,
        MOBILE_BROADBAND,
        BROADBAND_FIBER,
        BROADBAND_COAX,
        BROADBAND_DSL,
        FIXED_WIRELESS_ACCESS
    }

    public enum SubscriptionItem_OfferingChangeTypeEnum {
        NEWVALUE, //TODO NEW IS KEYWORD
        UPGRADE,
        PROLONGING
    }

    public enum SubscriptionItem_PublishLevelEnum {
        ALL_INFORMATION_PROVIDED,
        OMITTED_NUMBER,
        SECRET_ADDRESS,
        NAME_AND_ADDRESS,
        EVERYTHING_EXCEPT_ADDITIONAL_INFORMATION,
        EVERYTHING_EXCEPT_EMAIL,
        NAME_AND_EMAIL,
        EVERYTHING_EXCEPT_ADDRESS,
        NAME_AND_FURTHER_INFORMATION,
        ADDRESS_ONLY,
        ADDRESS_AND_EMAIL,
        ALL_BUT_NAME,
        ADDRESS_AND_FURTHER_INFORMATION,
        EMAIL_ONLY,
        EMAIL_AND_FURTHER_INFORMATION,
        ONLY_FURTHER_INFORMATION
    }

    public enum SubscriptionItem_BillingSystemEnum {
        FOKUS,
        CERILLION,
        CCB,
        NAVIBILLING,
        NAVISION,
        SSP
    }

    public class SubscriptionItem extends OrderItem {
        public TelephoneNumber telephoneNumber;
        public SubscriptionItem_TelephoneNumberCategoryEnum telephoneNumberCategory;
        //Type of the new offering (priceplan). Present only if newOfferingCode is present. (priceplans.xlsx.productType
        public SubscriptionItem_ProductTypeEnum productType;
        //Offering change type. Only for output.
        public SubscriptionItem_OfferingChangeTypeEnum offeringChangeType;
        public Offering newOffering;
        public Offering currentOffering;
        //Can contain TOUCHPOINT.MASTER, TOUCHPOINT.AA AND so on.
        public String productCategory;
        public FixedNetDetails fixedNetDetails;
        //The subscription is to be transfered to account that has different legal owner than the previous account.
        public Boolean isTransfer;
        public SubscriptionUser subscriptionUser;
        //publish level (also known as directory listing)
        public SubscriptionItem_PublishLevelEnum publishLevel;
        public Amount recurringPrice;
        //Date YYYY-MM-DD (according to ISO 8601) of when the subscription shall be activated.
        public Date preferredActivationDate;
        //Date YYYY-MM-DD (according to ISO 8601) of when the subscription was really activated.
        public Date realActivationDate;
        //Replaces the preferred activation date with installation and activation as soon as possible.
        public Boolean productDeliveryAsap;
        public Boolean secret;
        //Label for additional info about subscription
        public String label;
        public TimePeriod terminationPeriod;
        public Date effectiveMoveDate;
        //Specifies the billing system on subscription going to NOOS
        public SubscriptionItem_BillingSystemEnum billingSystem;
    }

    public class SubscriptionOwnerControlItem extends OrderItem {
        public SubscriptionControlOption nationalUsageAllowance;
        public SubscriptionControlOption roamingCostControl;
        public SubscriptionControlOption retailRoaming;
        //Indicates whether the costLimit is actually unlimited.
        public Boolean unlimited;
        //The cost limit in DKK.
        public Integer costLimit;
    }

    public class SubscriptionUser {
        public String firstName;
        public String lastName;
        public Address address;
        //Birthday in format YYYY-MM-DD (according to ISO 8601).
        public Date birthday;
        public String email;
    }

    public class SuspensionItem extends OrderItem {
        public String reason;
    }

    /**
     * Details about the technician
     */
    public class TechnicianDetails {
        public String installationAddress;
        public Amount technicianFee;
        public String technicianName;
        public String technicianNumber;
        public Date technicianVisitDate;
    }

    public class TelephoneNumber {
        //country code like +45 for Denmark
        public String countryCode;
        //local area code
        public String areaCode;
        //the actual phone number
        public String localNumber;
    }

    public enum TerminationItem_ReasonCodeEnum {
        REPAYMENT_SCHEME_CHURN_BAD_DEBT,
        AKKORD,
        CANCELLATION,
        AUTOMATIC_SHUTDOWN,
        SUSPENSION_OF_PAYMENTS,
        REGRET_AFTER_REGRET_PERIOD,
        REGRET_IN_REGRET_PERIOD,
        LACK_OF_QUALITY_IN_SALES,
        CANCELLATION_WRITTEN_REQUEST_CANC,
        NON_PAYMENT,
        MOVE_FROM_POSTPAID_TO_CASH,
        CUSTOMER_REQUEST,
        CONVERSION,
        DUMMY_CANCELLATION,
        FRAUD_OR_DEALER_ERROR,
        FRAUD_DEPARTMENT_DECREASING_STOCK,
        DEBT_SETTLEMENT,
        INTERNAL_TERMINATION_NO_CHURN,
        INTERNAL_PORTING,
        BANKRUPTCY,
        LEAVE_TO_COMPETITION,
        CUSTOMER_CANNOT_AFFORD,
        DEATH,
        CANCELLATION_WRITTEN_REQUEST_KS50,
        OTHER,
        CEASED,
        PORT_OUT,
        FORCED_CANCELLATION,
        UNALLOCATED,
        AMENDMENT_OF_TERMS
    }

    /**
     * Order item containing information about termination.
     */
    public class TerminationItem extends OrderItem {
        public Date effectiveDate;
        //Reason code of termination
        public TerminationItem_ReasonCodeEnum reasonCode;
        public Boolean retention;
        public Boolean waiveTerminationFees;
        //Flag indicating if the number should be transferred to a different pool after termination
        public Boolean shouldTransferToDifferentPool;
        //Flag indicating if the number should be re-reserved after termination
        public Boolean shouldReReserve;
    }

    /**
     * Time period in amount of units like 1 month.
     */
    public class TimePeriod {
        public Integer amount;
        public TimeUnit unit;
    }

    public enum TimeUnit {
        DAY,
        WEEK,
        MONTH,
        YEAR
    }

    public class UnstructuredAddress extends Address {
        public String address1;
        public String address2;
        public String address3;
    }

    public class ValidationError {
        public String errorCode;
        public List<ValidationErrorParameter> parameters;
    }

    public class ValidationErrorParameter {
        public String target;
        public String reason;
    }
}