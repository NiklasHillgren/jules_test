public class OrderClientDTO {
    public virtual class Address {
        public OrderClientDTOEnums.AddressTypeEnum addressType;
        public String city;
        public String zipCode;
        public String country;
        //Name of C/O (in care of) person.
        public String coName;
        //Name of person (recipient). Mainly used for organization addresse where recipient is a specific person.
        public String attention;
    }
    
    public class UnstructuredAddress extends Address {
        public String address1;
        public String address2;
        public String address3;
    }

    public class DanishAddress extends Address {
        //THIS SHOULD BE A PART OF DanishAddress BUT we need it from payload
        public String streetName;
        public String streetNumber;
        public String streetNumberSuffix;
        public String floorNumber;
        public String doorNumber;
        public String direction;
        public String locality;
    }

    public class Amount {
        public Decimal amount;
        public Decimal vat;
        public OrderClientDTOEnums.AmountCurrencyEnum currency_x; 
        public Decimal catalogAmount;
        public Decimal catalogVat;
        public Discount discount;
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

    public class ChangeActivationDateOrderPatch {
        public String teliaCircuitId;
        public Date newActivationDate;
    }

    public class Consent {
        public Boolean writtenConsentGiven = false;
        public PhysicalIdentification consentById;
    }

    public class CreditCard {
        public String name;
        public String maskedPan;
        public String token;
        public Date expirationDate;
    }

    /**
     * Details of credit evaluation, so that it can be retried.
     */
    public class CreditEvaluationDetails {
        public OrderClientDTOEnums.CreditEvaluationDetailsEmploymentTypeEnum employmentType;
        public OrderClientDTOEnums.CreditEvaluationDetailsResidentialStatusEnum residentialStatus;
        public OrderClientDTOEnums.PaymentMethod paymentMethod;
        public Decimal creditLimit;
        public String creditClass;
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

    public class Document {
        public String documentType;
        public String url;
    }

    public class DownPaymentPlan {
        public OrderClientDTOEnums.DownPaymentPlanDownPaymentTypeEnum downPaymentType;
        public OrderClientDTOEnums.DownPaymentPlanCreditProviderEnum creditProvider;
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

    public class HardwareDelivery {
        //Unique identifier of hardware delivery.
        public Integer id;
        public PartyRole recipientParty;
        public PartyRole billingParty;
        //String identifier of delivery method.
        public String deliveryMethod;
        public Amount deliveryPrice;
        public OrderClientDTOEnums.HardwareDeliveryPreferredContactMethodEnum preferredContactMethod;
        //Date time with timezone according to ISO-8601.
        //Timestamp of when the hardware has been sent out from warehouse.
        public DateTime dispatchDate;
        public DateTime prefferedSendDate;
    }

    public class HardwareDetails {
        public String materialId;
        public OrderClientDTOEnums.HardwareType hardwareType;
        public String name;
        public List<SerialNumber> serialNumbers;
        //Type of package
        public String packageType;
    }

    public class HardwarePaymentConfigurationPatch {
        public OrderClientDTOEnums.PaymentType paymentType;
        public PaymentAmount totalPayment;
        public PaymentAmount upfrontPayment;
        public PaymentAmount downPayment;
        public Discount discount;
        public Decimal numberOfInstallments;
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

    /**
     * Recipients registered here should be notified upon event that interests given role.
     * So far used only to return recipients on NEO orders.
     */
    public class NotificationRecipient {
        public OrderClientDTOEnums.NotificationRecipientRoleEnum role;
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
        //Id of the offering as provided by ProductCatalog.
        public string productOfferingId;
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

    public virtual class OrderItem {
        public OrderClientDTOEnums.OrderItemTypeEnum type;
        public OrderClientDTOEnums.OrderItemActivityEnum activity;
        public Integer id;
        public String channelOrderItemId;
        public List<ValidationError> validationErrors;
        public OrderClientDTOEnums.OrderItemOriginEnum origin;
    }

    public class CreditWatchItem extends OrderItem {
        public Decimal amount;
        public Boolean waiveFees;
        public Date expirationDate;
    }

    public class DiscountItem extends OrderItem {
        public String discountCode;
        public String reason;
    }

    public class FeeItem extends OrderItem {
        public OrderClientDTOEnums.FeeItemFeeTypeEnum feeType;
        public String billingCode;
        public String displayName;
        public Amount price;
        public Boolean waived;
        public Boolean recurring;
    }

    public class HardwarePaymentItem extends OrderItem {
        public OrderClientDTOEnums.PaymentType paymentType;
        //id of purchase in PaymentAPI
        public String purchaseId;
        public PaymentAmount totalPayment;
        public PaymentAmount upfrontPayment;
        public DownPaymentPlan downPaymentPlan;
    }

    public class HardwareSwapItem extends OrderItem {
        // Status of hardware shipping
        public String shippingStatus;
        //Serial number of old hardware to swap
        public String oldSerialNumber;
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

    public class ChargeItem extends OrderItem {
        public String chargeCode;
        public Amount price;
        public String description;
    }

    public class ConsentItem extends OrderItem {
        public String consentId; //UUID
        public Integer version;
        public String state;
    }

    public class AccountItem extends OrderItem {
        public String billingAccountNumber;
        public PartyRole legalParty;
        public PartyRole billingParty;
        public OrderClientDTOEnums.AccountItemBillingCycleEnum billingCycle;
        public OrderClientDTOEnums.AccountItemInvoiceTypeEnum invoiceType;
        public Integer delayOfPayment;
        public OrderClientDTOEnums.PaymentMethod paymentMethod;
        public Bank bank;
        public String ean;
        public String label;
        public String upTransferChargeCode;
        public OrderClientDTOEnums.AccountItemCategoryEnum category;
        public String productGroup;
    }

    public class AccountOwnerControlItem extends OrderItem {
        public OrderClientDTOEnums.AccountControlOption nationalUsageAllowance;
        public OrderClientDTOEnums.AccountControlOption roamingCostControl;
        public OrderClientDTOEnums.AccountControlOption retailRoaming;
        public Boolean unlimited;
        public Integer costLimit;
    }

    public class AdditionalProductItem extends OrderItem {
        public String productCode;
        public String productName;
        public OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum productCategory;
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

    public class PaymentMethodChangeItem extends OrderItem {
        public PaymentMethodDetail paymentMethodDetail;
        public String reasonCode;
        public String memoText;
    }

    public class PortingDetailsItem extends OrderItem {
        //Id of a network operator where the number is currently registered. Also known as number owner.
        public String networkOperatorId;
        public String donorSimNumber;
        public String poaDocumentUrl;
        // Location of document within Norlys domain.
        public String poaDocumentId;
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

    public class ReactivationItem extends OrderItem {
        public String reason;
    }

    public class RegretItem extends OrderItem {
        //Effective date in format YYYY-MM-DD (according to ISO 8601).
        public Date effectiveDate;
    }

    public class SubscriptionItem extends OrderItem {
        public TelephoneNumber telephoneNumber;
        public OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum telephoneNumberCategory;
        //Type of the new offering (priceplan). Present only if newOfferingCode is present. (priceplans.xlsx.productType
        public OrderClientDTOEnums.SubscriptionItemProductTypeEnum productType;
        //Offering change type. Only for output.
        public OrderClientDTOEnums.SubscriptionItemOfferingChangeTypeEnum offeringChangeType;
        public Offering newOffering;
        public Offering currentOffering;
        //Can contain TOUCHPOINT.MASTER, TOUCHPOINT.AA AND so on.
        public String productCategory;
        public FixedNetDetails fixedNetDetails;
        //The subscription is to be transfered to account that has different legal owner than the previous account.
        public Boolean isTransfer;
        public SubscriptionUser subscriptionUser;
        //publish level (also known as directory listing)
        public OrderClientDTOEnums.SubscriptionItemPublishLevelEnum publishLevel;
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
        public OrderClientDTOEnums.SubscriptionItemBillingSystemEnum billingSystem;
    }

    public class SubscriptionOwnerControlItem extends OrderItem {
        public OrderClientDTOEnums.SubscriptionControlOption nationalUsageAllowance;
        public OrderClientDTOEnums.SubscriptionControlOption roamingCostControl;
        public OrderClientDTOEnums.SubscriptionControlOption retailRoaming;
        //Indicates whether the costLimit is actually unlimited.
        public Boolean unlimited;
        //The cost limit in DKK.
        public Integer costLimit;
    }

    public class SuspensionItem extends OrderItem {
        public String reason;
    }

    public class TerminationItem extends OrderItem {
        public Date effectiveDate;
        //Reason code of termination
        public OrderClientDTOEnums.TerminationItemReasonCodeEnum reasonCode;
        public Boolean retention;
        public Boolean waiveTerminationFees;
        //Flag indicating if the number should be transferred to a different pool after termination
        public Boolean shouldTransferToDifferentPool;
        //Flag indicating if the number should be re-reserved after termination
        public Boolean shouldReReserve;
    }

    public class OrderPart {
        public List<OrderPartReference> references;
        public OrderClientDTOEnums.OrderPartTypeEnum type;
        public OrderClientDTOEnums.OrderPartActivityEnum activity;
        public List<OrderClientDTOEnums.OrderPartChangeTypesEnum> changeTypes;
        public OrderClientDTOEnums.ProcessingStatus processingStatus;
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

    public class OrderPartReference {
        public OrderClientDTOEnums.OrderPartReferenceTypeEnum type;
        public String value;
    }

    //public class OrderPatchRequests extends List<OrderPatchRequest> {} TODO HOW DO WE HADNL THIS?
    public virtual class OrderPatchRequest {
        public OrderClientDTOEnums.OpEnum op;
        public String path;
        public Object value;
        public String from_x; //TODO from is a type in apex
    }

    public class OrderResponse {
        public OrderV10 data;
    }

    public class OrderSource {
        public String ipAddress;
        public Decimal port;
        public Datetime captureTimeStamp;
    }

    public class OrderV10 {
        public String id;
        public String orderId;
        public String parentOrderId;
        public String channelOrderReference;
        public String implementationCaseId;
        public String bpmOrderId;
        public String noosOrderId;
        public String mitIdVerificationToken;
        public String batchId;
        public OrderClientDTOEnums.Brand brand;
        //Required - Identifying what channel the order is made in, e.g. SALES_FORCE, TANGO, SELF_SERVICE ...
        public String channel;
        //the dealer organization that made the order
        public Dealer dealer;
        public OrderClientDTOEnums.OrderV10SegmentEnum segment;
        public DateTime createdDate;
        public DateTime completedDate;
        public String createdBy;
        //Status of whole order (calculated from orderItems)
        public OrderClientDTOEnums.ProcessingStatus processingStatus;
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

    public virtual class PartyRole {
        public String type;
        public String email;
        public String customerId;
        public TelephoneNumber telephoneNumber;
        public Address address;
    }

    public class Organization extends PartyRole {
        public String name;
        public String additionalName;
        public String cvr;
    }

    public class Person extends PartyRole {
        public String firstName;
        public String lastName;
        //Birthday in format YYYY-MM-DD (according to ISO 8601).
        public Date birthday;
        public String cpr;
    }

    public class PaymentAmount {
        public Decimal amount;
        public Decimal vat;
        public OrderClientDTOEnums.PaymentAmountCurrencyEnum currency_x; //TODO currency is reserved
        public Decimal amountWithoutVat;
    }

    /**
     * Parent type for all specific payment method detail types
     */
    public virtual class PaymentMethodDetail {
        public OrderClientDTOEnums.PaymentMethod paymentMethod;
    }

    public class CardPaymentMethodDetail extends PaymentMethodDetail {
        public CreditCard creditCard;
    }

    public class GiroPaymentMethodDetail extends PaymentMethodDetail {
    }

    public class PbsPaymentMethodDetail extends PaymentMethodDetail {
        public BankAccount bankAccount;
    }

    public class MobilePaymentMethodDetail extends PaymentMethodDetail {
        public String mobilePayAgreementId;
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

    public class PortingDetailsUpdate {
        public TelephoneNumber telephoneNumber;
        public String donorSimNumber;
        public Consent donorConsent;
        public Consent portingProcessConditionsConsent;
    }

    public class ReturnDetails {
        public Decimal returnQuantity;
        public String creditInvoiceNumber;
        public Date creditInvoiceDate;
    }

    public class SerialNumber {
        public String type;
        public String value;
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
        public OrderClientDTOEnums.ShippingDetailsDeliveryStatusEnum deliveryStatus;
        public String trackAndTraceNumber;
        public String trackAndTraceUrl;
        //date in format YYYY-MM-DD (according to ISO 8601).
        public Date shippingConfirmedDate;
    }

    public class SimDetails {
        //Type of sim card
        public OrderClientDTOEnums.SimDetailsSimTypeEnum simType;
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
        //Indicates whether to apply the sim swap fee.
        public Boolean waiveSimSwapFee;
    }

    public class SplitPaymentPatchRequest {
        public PaymentAmount totalPaymentAmount;
        public PaymentAmount upfrontPaymentAmount;
        public PaymentAmount downPaymentAmount;
        public Date numberOfInstallments;
    }

    public class SubscriptionUser {
        public String firstName;
        public String lastName;
        public Address address;
        //Birthday in format YYYY-MM-DD (according to ISO 8601).
        public Date birthday;
        public String email;
    }

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

    public class TimePeriod {
        public Integer amount;
        public OrderClientDTOEnums.TimeUnit unit;
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