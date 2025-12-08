/**
 * OrderClientDTOBuilder is a class that constructs objects defiened by the classes in OrderClientDTO.
 *
 * For each inner class defined here there is a corresponding inner class in the OrderClientDTO.
 *
 *
 * !IMPORTANT!
 *
 * The following three classes are superclasses and some classes relies on inheritence:
 * AddressBuilder, OrderItemBuilder, PartyRoleBuilder.
 *
 * When calling a with on a subclas that exists on the super class the "fluency" pattern loses itself.
 *
 * Example for danish address:
 *  new OrderClientDTOBuilder.DanishAddressBuilder()
 *       .withStreetNumber('8')
 *       .withCity('Odense N') //CITY SITS ON PARENT "AddressBuilder"
 *       .withStreetName('Rubyvej')
 *
 * Solvable by either calling the superclass methods last.
 *
 * new OrderClientDTOBuilder.DanishAddressBuilder()
 *       .withStreetNumber('8')
 *       .withStreetName('Rubyvej')
 *       .withCity('Odense N') //withCity returns AddressBuilder not DanishAddressbuilder!
 *
 * Or by casting:
 * (OrderClientDTOBuilder.DanishAddressBuilder (new OrderClientDTOBuilder.DanishAddressBuilder()
 *       .withStreetNumber('8')
 *       .withCity('Odense N')))
 *       .withStreetName('Rubyvej')
 *
 *
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Niklas Hillgren      01/12/2025      Initial
 *
 * @author Niklas Hillgren
 * @version 1.0
 * @since 01/12/2025
 */
public with sharing class OrderClientDTOBuilder {
    /**
     * AddressBuilder used to build OrderClientDTO.Address
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public virtual class AddressBuilder {
        private OrderClientDTOEnums.AddressTypeEnum addressType;
        private String city;
        private String zipCode;
        private String country;
        private String coName;
        private String attention;

        /**
         *  Name of C/O (in care of) person.
         */
        public AddressBuilder withCoName(String coName) {
            this.coName = coName;
            return this;
        }

        public AddressBuilder withAddressType(OrderClientDTOEnums.AddressTypeEnum addressType) {
            this.addressType = addressType;
            return this;
        }

        public AddressBuilder withCity(String city) {
            this.city = city;
            return this;
        }

        public AddressBuilder withZipCode(String zipCode) {
            this.zipCode = zipCode;
            return this;
        }

        public AddressBuilder withCountry(String country) {
            this.country = country;
            return this;
        }

        /**
         * Name of person (recipient). Mainly used for organization addresse where recipient is a specific person.
         */
        public AddressBuilder withAttention(String attention) {
            this.attention = attention;
            return this;
        }

        public OrderClientDTO.Address setProperties(OrderClientDTO.Address address) {
            address.addressType = this.addressType;
            address.city = this.city;
            address.zipCode = this.zipCode;
            address.country = this.country;
            address.coName = this.coName;
            address.attention = this.attention;

            return address;
        }

        public virtual OrderClientDTO.Address build() {
            OrderClientDTO.Address result = new OrderClientDTO.Address();

            result = setProperties(result);

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * UnstructuredAddress used to build OrderClientDTO.UnstructuredAddress
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class UnstructuredAddressBuilder extends AddressBuilder {
        private String address1;
        private String address2;
        private String address3;

        public UnstructuredAddressBuilder() {
            withAddressType(OrderClientDTOEnums.AddressTypeEnum.UNSTRUCTURED_ADDRESS);
        }

        public UnstructuredAddressBuilder withAddress1(String address1) {
            this.address1 = address1;
            return this;
        }

        public UnstructuredAddressBuilder withAddress2(String address2) {
            this.address2 = address2;
            return this;
        }

        public UnstructuredAddressBuilder withAddress3(String address3) {
            this.address3 = address3;
            return this;
        }

        public override OrderClientDTO.Address build() {
            OrderClientDTO.UnstructuredAddress result = new OrderClientDTO.UnstructuredAddress();

            setProperties(result);

            result.address1 = this.address1;
            result.address2 = this.address2;
            result.address3 = this.address3;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * DanishAddress used to build OrderClientDTO.DanishAddress
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class DanishAddressBuilder extends AddressBuilder {
        private String streetName;
        private String streetNumber;
        private String streetNumberSuffix;
        private String floorNumber;
        private String doorNumber;
        private String direction;
        private String locality;

        public DanishAddressBuilder() {
            withAddressType(OrderClientDTOEnums.AddressTypeEnum.DANISH_ADDRESS);
        }

        /**
         * Street name (e.g. Karl Johans Gate)
         */
        public DanishAddressBuilder withStreetName(String streetName) {
            this.streetName = streetName;
            return this;
        }

        /**
         * Street number (e.g. 20)
         */
        public DanishAddressBuilder withStreetNumber(String streetNumber) {
            this.streetNumber = streetNumber;
            return this;
        }

        /**
         * Usually a letter right after the number (A in 10A, B in 15B)
         */
        public DanishAddressBuilder withStreetNumberSuffix(String streetNumberSuffix) {
            this.streetNumberSuffix = streetNumberSuffix;
            return this;
        }

        /**
         * Floor number identifying the floor (e.g. 5)
         */
        public DanishAddressBuilder withFloorNumber(String floorNumber) {
            this.floorNumber = floorNumber;
            return this;
        }

        /**
         * Door number identifying the door (e.g. 10)
         */
        public DanishAddressBuilder withDoorNumber(String doorNumber) {
            this.doorNumber = doorNumber;
            return this;
        }

        /**
         * like 'tv' (meaning 'til venstre' -> left)
         */
        public DanishAddressBuilder withDirection(String direction) {
            this.direction = direction;
            return this;
        }

        /**
         * for ex. V is the locality in COPENHAGEN V
         */
        public DanishAddressBuilder withLocality(String locality) {
            this.locality = locality;
            return this;
        }

        public override OrderClientDTO.Address build() {
            OrderClientDTO.DanishAddress result = new OrderClientDTO.DanishAddress();

            setProperties(result);

            result.streetName = this.streetName;
            result.streetNumber = this.streetNumber;
            result.streetNumberSuffix = this.streetNumberSuffix;
            result.floorNumber = this.floorNumber;
            result.doorNumber = this.doorNumber;
            result.direction = this.direction;
            result.locality = this.locality;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * AmountBuilder used to build OrderClientDTO.Amount
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class AmountBuilder {
        private Decimal amount;
        private Decimal vat;
        private OrderClientDTOEnums.AmountCurrencyEnum currency_x;
        private Decimal catalogAmount;
        private Decimal catalogVat;
        private DiscountBuilder discountBuilder;

        /**
         * amount including VAT
         */
        public AmountBuilder withAmount(Decimal amount) {
            this.amount = amount;
            return this;
        }

        /**
         * VAT amount
         */
        public AmountBuilder withVAT(Decimal vat) {
            this.vat = vat;
            return this;
        }

        public AmountBuilder withCurrency(OrderClientDTOEnums.AmountCurrencyEnum currency_x) {
            this.currency_x = currency_x;
            return this;
        }

        /**
         * original amount including VAT before applying any discount
         */
        public AmountBuilder withCatalogAmount(Decimal catalogAmount) {
            this.catalogAmount = catalogAmount;
            return this;
        }

        /**
         * original VAT amount before applying any discount
         */
        public AmountBuilder withCatalogVat(Decimal catalogVat) {
            this.catalogVat = catalogVat;
            return this;
        }

        public AmountBuilder withDiscountBuilder(DiscountBuilder discountBuilder) {
            this.discountBuilder = discountBuilder;
            return this;
        }

        public OrderClientDTO.Amount build() {
            OrderClientDTO.Amount result = new OrderClientDTO.Amount();
            result.amount = this.amount;
            result.vat = this.vat;
            result.currency_x = this.currency_x;
            result.catalogAmount = this.catalogAmount;
            result.catalogVat = this.catalogVat;

            if (this.discountBuilder != null) {
                result.discount = this.discountBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * BankBuilder used to build OrderClientDTO.Bank
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class BankBuilder {
        private String accountNumber;
        private String branch;
        private String name;

        /**
         * account number
         */
        public BankBuilder withAccountNumber(String accountNumber) {
            this.accountNumber = accountNumber;
            return this;
        }

        /**
         * branch
         */
        public BankBuilder withBranch(String branch) {
            this.branch = branch;
            return this;
        }

        /**
         * name of the bank
         */
        public BankBuilder withName(String name) {
            this.name = name;
            return this;
        }

        public OrderClientDTO.Bank build() {
            OrderClientDTO.Bank result = new OrderClientDTO.Bank();
            result.branch = this.branch;
            result.accountNumber = this.accountNumber;
            result.name = this.name;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * BankAccountBuilder used to build OrderClientDTO.BankAccount
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class BankAccountBuilder {
        private String bankName;
        private String bankBranchCode;
        private String accountNumber;

        public BankAccountBuilder withBankName(String bankName) {
            this.bankName = bankName;
            return this;
        }

        public BankAccountBuilder withBankBranchCode(String bankBranchCode) {
            this.bankBranchCode = bankBranchCode;
            return this;
        }

        public BankAccountBuilder withAccountNumber(String accountNumber) {
            this.accountNumber = accountNumber;
            return this;
        }

        public OrderClientDTO.BankAccount build() {
            OrderClientDTO.BankAccount result = new OrderClientDTO.BankAccount();
            result.bankName = this.bankName;
            result.bankBranchCode = this.bankBranchCode;
            result.accountNumber = this.accountNumber;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * ChangeActivationDateOrderPatchBuilder used to build OrderClientDTO.ChangeActivationDateOrderPatch
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class ChangeActivationDateOrderPatchBuilder {
        private String teliaCircuitId;
        private Date newActivationDate;

        public ChangeActivationDateOrderPatchBuilder withNewActivationDate(Date newActivationDate) {
            this.newActivationDate = newActivationDate;
            return this;
        }

        public ChangeActivationDateOrderPatchBuilder withTeliaCircuitId(String teliaCircuitId) {
            this.teliaCircuitId = teliaCircuitId;
            return this;
        }

        public OrderClientDTO.ChangeActivationDateOrderPatch build() {
            OrderClientDTO.ChangeActivationDateOrderPatch result = new OrderClientDTO.ChangeActivationDateOrderPatch();
            result.newActivationDate = this.newActivationDate;
            result.teliaCircuitId = this.teliaCircuitId;
            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * ConsentBuilder used to build OrderClientDTO.Consent
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class ConsentBuilder {
        private Boolean writtenConsentGiven = false;
        private PhysicalIdentificationBuilder consentByIdPhysicalIdentificationBuilder;

        public ConsentBuilder withWrittenConsentGiven(Boolean writtenConsentGiven) {
            this.writtenConsentGiven = writtenConsentGiven;

            return this;
        }

        public ConsentBuilder withConsentByIdPhysicalIdentificationBuilder(
            PhysicalIdentificationBuilder consentByIdPhysicalIdentificationBuilder
        ) {
            this.consentByIdPhysicalIdentificationBuilder = consentByIdPhysicalIdentificationBuilder;

            return this;
        }

        public OrderClientDTO.Consent build() {
            OrderClientDTO.Consent result = new OrderClientDTO.Consent();

            if (this.consentByIdPhysicalIdentificationBuilder != null) {
                result.consentById = this.consentByIdPhysicalIdentificationBuilder.build();
            }

            result.writtenConsentGiven = writtenConsentGiven;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * CreditCardBuilder used to build OrderClientDTO.CreditCard
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class CreditCardBuilder {
        private String name;
        private String maskedPan;
        private String token;
        private Date expirationDate;

        public CreditCardBuilder withName(String name) {
            this.name = name;
            return this;
        }

        public CreditCardBuilder withMaskedPan(String maskedPan) {
            this.maskedPan = maskedPan;
            return this;
        }

        public CreditCardBuilder withToken(String token) {
            this.token = token;
            return this;
        }

        /**
         * Date in format YYYY-MM-DD (according to ISO 8601).
         */
        public CreditCardBuilder withExpirationDate(Date expirationDate) {
            this.expirationDate = expirationDate;
            return this;
        }

        public OrderClientDTO.CreditCard build() {
            OrderClientDTO.CreditCard result = new OrderClientDTO.CreditCard();
            result.name = this.name;
            result.maskedPan = this.maskedPan;
            result.expirationDate = this.expirationDate;
            result.token = this.token;
            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * CreditEvaluationDetailsBuilder used to build OrderClientDTO.CreditEvaluationDetails
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class CreditEvaluationDetailsBuilder {
        private OrderClientDTOEnums.CreditEvaluationDetailsEmploymentTypeEnum employmentType;
        private OrderClientDTOEnums.CreditEvaluationDetailsResidentialStatusEnum residentialStatus;
        private OrderClientDTOEnums.PaymentMethod paymentMethod;
        private Decimal creditLimit;
        private String creditClass;

        public CreditEvaluationDetailsBuilder withEmploymentType(
            OrderClientDTOEnums.CreditEvaluationDetailsEmploymentTypeEnum employmentType
        ) {
            this.employmentType = employmentType;
            return this;
        }

        public CreditEvaluationDetailsBuilder withResidentialStatus(
            OrderClientDTOEnums.CreditEvaluationDetailsResidentialStatusEnum residentialStatus
        ) {
            this.residentialStatus = residentialStatus;
            return this;
        }

        public CreditEvaluationDetailsBuilder withPaymentMethod(OrderClientDTOEnums.PaymentMethod paymentMethod) {
            this.paymentMethod = paymentMethod;
            return this;
        }

        public CreditEvaluationDetailsBuilder withCreditLimit(Decimal creditLimit) {
            this.creditLimit = creditLimit;
            return this;
        }

        public CreditEvaluationDetailsBuilder withCreditClass(String creditClass) {
            this.creditClass = creditClass;
            return this;
        }

        public OrderClientDTO.CreditEvaluationDetails build() {
            OrderClientDTO.CreditEvaluationDetails result = new OrderClientDTO.CreditEvaluationDetails();
            result.employmentType = this.employmentType;
            result.residentialStatus = this.residentialStatus;
            result.paymentMethod = this.paymentMethod;
            result.creditLimit = this.creditLimit;
            result.creditClass = this.creditClass;
            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * DealerBuilder used to build OrderClientDTO.Dealer
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class DealerBuilder {
        private String dealerCode;
        private String dealerName;
        private String salesAgentCode;
        private String salesAgentName;
        private String posDealerId;
        private String posSalesAgentId;

        /**
         * name of the dealer like 'BtC Amager'.
         */
        public DealerBuilder withDealerName(String dealerName) {
            this.dealerName = dealerName;
            return this;
        }
        /**
         * code of the dealer like '1018'.
         */
        public DealerBuilder withDealerCode(String dealerCode) {
            this.dealerCode = dealerCode;
            return this;
        }
        /**
         * shall contain sales agent code (as handled by DealerAdmin), so far not used.
         */
        public DealerBuilder withSalesAgentCode(String salesAgentCode) {
            this.salesAgentCode = salesAgentCode;
            return this;
        }
        /**
         * Name of the sales representative.
         */
        public DealerBuilder withSalesAgentName(String salesAgentName) {
            this.salesAgentName = salesAgentName;
            return this;
        }
        /**
         * id of the dealer in ODOO
         */
        public DealerBuilder withPosDealerId(String posDealerId) {
            this.posDealerId = posDealerId;
            return this;
        }
        /**
         * id of the sales agent in ODOO
         */
        public DealerBuilder withPosSalesAgentId(String posSalesAgentId) {
            this.posSalesAgentId = posSalesAgentId;
            return this;
        }

        public OrderClientDTO.Dealer build() {
            OrderClientDTO.Dealer result = new OrderClientDTO.Dealer();
            result.dealerCode = this.dealerCode;
            result.dealerName = this.dealerName;
            result.salesAgentCode = this.salesAgentCode;
            result.salesAgentName = this.salesAgentName;
            result.posDealerId = this.posDealerId;
            result.posSalesAgentId = this.posSalesAgentId;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * DiscountBuilder used to build OrderClientDTO.Discount
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class DiscountBuilder {
        private Decimal amount;
        private Decimal vat;
        private Decimal percentage;
        private String comment;
        private String reason;

        /**
         * discount amount including VAT
         */
        public DiscountBuilder withAmount(Decimal amount) {
            this.amount = amount;
            return this;
        }

        /**
         * discount VAT amount
         */
        public DiscountBuilder withVAT(Decimal vat) {
            this.vat = vat;
            return this;
        }

        /**
         * percentage discount
         */
        public DiscountBuilder withPercentage(Decimal percentage) {
            this.percentage = percentage;
            return this;
        }

        /**
         * comment for discount
         */
        public DiscountBuilder withComment(String comment) {
            this.comment = comment;
            return this;
        }

        /**
         * justification of applying discount
         */
        public DiscountBuilder withReason(String reason) {
            this.reason = reason;
            return this;
        }

        public OrderClientDTO.Discount build() {
            OrderClientDTO.Discount result = new OrderClientDTO.Discount();
            result.amount = this.amount;
            result.vat = this.vat;
            result.percentage = this.percentage;
            result.comment = this.comment;
            result.reason = this.reason;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * DocumentBuilder used to build OrderClientDTO.Document
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class DocumentBuilder {
        private String url;
        private String documentType;

        /**
         * Type of document, enum comes from DocumentAPI (located in components.schemas.Document.properties.type)
         */
        public DocumentBuilder withDocumentType(String documentType) {
            this.documentType = documentType;
            return this;
        }
        /**
         * URL the document is located at
         */
        public DocumentBuilder withUrl(String url) {
            this.url = url;
            return this;
        }

        public OrderClientDTO.Document build() {
            OrderClientDTO.Document result = new OrderClientDTO.Document();
            result.documentType = this.documentType;
            result.url = this.url;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * DownPaymentPlanBuilder used to build OrderClientDTO.DownPaymentPlan
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class DownPaymentPlanBuilder {
        private OrderClientDTOEnums.DownPaymentPlanDownPaymentTypeEnum downPaymentType;
        private OrderClientDTOEnums.DownPaymentPlanCreditProviderEnum creditProvider;
        private PaymentAmountBuilder downPaymentAmountBuilder;
        private PaymentAmountBuilder installmentAmountBuilder;
        private Decimal numberOfInstallments;

        public DownPaymentPlanBuilder withDownPaymentType(
            OrderClientDTOEnums.DownPaymentPlanDownPaymentTypeEnum downPaymentType
        ) {
            this.downPaymentType = downPaymentType;
            return this;
        }

        public DownPaymentPlanBuilder withCreditProvider(
            OrderClientDTOEnums.DownPaymentPlanCreditProviderEnum creditProvider
        ) {
            this.creditProvider = creditProvider;
            return this;
        }

        public DownPaymentPlanBuilder withDownPaymentAmountBuilder(PaymentAmountBuilder downPaymentAmountBuilder) {
            this.downPaymentAmountBuilder = downPaymentAmountBuilder;
            return this;
        }

        public DownPaymentPlanBuilder withInstallmentAmountBuilder(PaymentAmountBuilder installmentAmountBuilder) {
            this.installmentAmountBuilder = installmentAmountBuilder;
            return this;
        }

        public DownPaymentPlanBuilder withNumberOfInstallments(Decimal numberOfInstallments) {
            this.numberOfInstallments = numberOfInstallments;
            return this;
        }

        public OrderClientDTO.DownPaymentPlan build() {
            OrderClientDTO.DownPaymentPlan result = new OrderClientDTO.DownPaymentPlan();
            result.downPaymentType = this.downPaymentType;
            result.creditProvider = this.creditProvider;
            result.numberOfInstallments = this.numberOfInstallments;

            if (this.downPaymentAmountBuilder != null) {
                result.downPaymentAmount = this.downPaymentAmountBuilder.build();
            }
            if (this.installmentAmountBuilder != null) {
                result.installmentAmount = this.installmentAmountBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * ErrorContentBuilder used to build OrderClientDTO.ErrorContent
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class ErrorContentBuilder {
        private String code;
        private String message;
        private ErrorParameterListBuilder errorParameterListBuilder;

        public ErrorContentBuilder withCode(String code) {
            this.code = code;
            return this;
        }

        public ErrorContentBuilder withMessage(String message) {
            this.message = message;
            return this;
        }

        public ErrorContentBuilder withErrorParameterListBuilder(ErrorParameterListBuilder errorParameterListBuilder) {
            this.errorParameterListBuilder = errorParameterListBuilder;
            return this;
        }

        public OrderClientDTO.ErrorContent build() {
            OrderClientDTO.ErrorContent result = new OrderClientDTO.ErrorContent();
            result.message = this.message;
            result.code = this.code;

            if (this.errorParameterListBuilder != null) {
                result.parameters = this.errorParameterListBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * ErrorParameterBuilder used to build OrderClientDTO.ErrorParameter
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class ErrorParameterBuilder {
        private String name;
        private String value;

        public ErrorParameterBuilder withName(String name) {
            this.name = name;
            return this;
        }

        public ErrorParameterBuilder withValue(String value) {
            this.value = value;
            return this;
        }

        public OrderClientDTO.ErrorParameter build() {
            OrderClientDTO.ErrorParameter result = new OrderClientDTO.ErrorParameter();

            result.name = this.name;
            result.value = this.value;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * ErrorResponseBuilder used to build OrderClientDTO.ErrorResponse
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class ErrorResponseBuilder {
        private ErrorContentBuilder errorContentBuilder;

        public ErrorResponseBuilder withErrorContentBuilder(ErrorContentBuilder errorContentBuilder) {
            this.errorContentBuilder = errorContentBuilder;
            return this;
        }

        public OrderClientDTO.ErrorResponse build() {
            OrderClientDTO.ErrorResponse result = new OrderClientDTO.ErrorResponse();

            if (this.errorContentBuilder != null) {
                result.error = this.errorContentBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * FixedNetDetailsBuilder used to build OrderClientDTO.FixedNetDetails
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class FixedNetDetailsBuilder {
        private OrderEventDetailListBuilder orderEventDetailListBuilder;
        private FixedNetFlagsBuilder fixedNetFlagsBuilder;
        private InstallationAddressBuilder installationAddressBuilder;
        private InstallationAddressBuilder lastMileAccessPointAddressBuilder;
        private NetworkConfigurationListBuilder networkConfigurationListBuilder;
        public String internalCircuitId;
        public Integer diggingDistance;
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

        public FixedNetDetailsBuilder withNetworkConfigurationListBuilder(
            NetworkConfigurationListBuilder networkConfigurationListBuilder
        ) {
            this.networkConfigurationListBuilder = networkConfigurationListBuilder;
            return this;
        }

        public FixedNetDetailsBuilder withEventsOrderEventDetailListBuilder(
            OrderEventDetailListBuilder orderEventDetailListBuilder
        ) {
            this.orderEventDetailListBuilder = orderEventDetailListBuilder;
            return this;
        }

        public FixedNetDetailsBuilder withFixedNetFlagsBuilder(FixedNetFlagsBuilder fixedNetFlagsBuilder) {
            this.fixedNetFlagsBuilder = fixedNetFlagsBuilder;
            return this;
        }

        public FixedNetDetailsBuilder withInstallationAddressBuilder(
            InstallationAddressBuilder installationAddressBuilder
        ) {
            this.installationAddressBuilder = installationAddressBuilder;
            return this;
        }

        public FixedNetDetailsBuilder withIastMileAccessPointAddressBuilder(
            InstallationAddressBuilder lastMileAccessPointAddressBuilder
        ) {
            this.lastMileAccessPointAddressBuilder = lastMileAccessPointAddressBuilder;
            return this;
        }
        /**
         * Length of the distance from existing local line termination point to customer's premises.
         */
        public FixedNetDetailsBuilder withDiggingDistance(Integer diggingDistance) {
            this.diggingDistance = diggingDistance;
            return this;
        }

        public FixedNetDetailsBuilder withSpeedProduct(String speedProduct) {
            this.speedProduct = speedProduct;
            return this;
        }

        public FixedNetDetailsBuilder withTechnicalProduct(String technicalProduct) {
            this.technicalProduct = technicalProduct;
            return this;
        }

        public FixedNetDetailsBuilder withSpeedDown(String speedDown) {
            this.speedDown = speedDown;
            return this;
        }

        public FixedNetDetailsBuilder withSpeedUp(String speedUp) {
            this.speedUp = speedUp;
            return this;
        }

        public FixedNetDetailsBuilder withPackageId(String packageId) {
            this.packageId = packageId;
            return this;
        }

        public FixedNetDetailsBuilder withAccessType(String accessType) {
            this.accessType = accessType;
            return this;
        }

        public FixedNetDetailsBuilder withDslTechnologyType(String dslTechnologyType) {
            this.dslTechnologyType = dslTechnologyType;
            return this;
        }

        public FixedNetDetailsBuilder withPreviousTdcCircuitId(String previousTdcCircuitId) {
            this.previousTdcCircuitId = previousTdcCircuitId;
            return this;
        }

        public FixedNetDetailsBuilder withDestinationTdcCircuitId(String destinationTdcCircuitId) {
            this.destinationTdcCircuitId = destinationTdcCircuitId;
            return this;
        }

        public FixedNetDetailsBuilder withPreviousLinePhoneNumber(String previousLinePhoneNumber) {
            this.previousLinePhoneNumber = previousLinePhoneNumber;
            return this;
        }

        public FixedNetDetailsBuilder withDestinationLinePhoneNumber(String destinationLinePhoneNumber) {
            this.destinationLinePhoneNumber = destinationLinePhoneNumber;
            return this;
        }

        public FixedNetDetailsBuilder withIpAddressType(String ipAddressType) {
            this.ipAddressType = ipAddressType;
            return this;
        }

        public FixedNetDetailsBuilder withCpeMode(String cpeMode) {
            this.cpeMode = cpeMode;
            return this;
        }

        public FixedNetDetailsBuilder withDslType(String dslType) {
            this.dslType = dslType;
            return this;
        }

        public FixedNetDetailsBuilder withSla(String sla) {
            this.sla = sla;
            return this;
        }

        public FixedNetDetailsBuilder withAddExtraBeChannel(String addExtraBeChannel) {
            this.addExtraBeChannel = addExtraBeChannel;
            return this;
        }

        public FixedNetDetailsBuilder withAllowRedColor(String allowRedColor) {
            this.allowRedColor = allowRedColor;
            return this;
        }

        public FixedNetDetailsBuilder withFlowType(String flowType) {
            this.flowType = flowType;
            return this;
        }

        public FixedNetDetailsBuilder withDoItYourselfInstallation(String doItYourselfInstallation) {
            this.doItYourselfInstallation = doItYourselfInstallation;
            return this;
        }

        public FixedNetDetailsBuilder withDoItYourselfContactName(String doItYourselfContactName) {
            this.doItYourselfContactName = doItYourselfContactName;
            return this;
        }

        public FixedNetDetailsBuilder withDoItYourselfContactNumber(String doItYourselfContactNumber) {
            this.doItYourselfContactNumber = doItYourselfContactNumber;
            return this;
        }
        /**
         * Tells the provider that there is already a broadband connection, but it is not yours and you need to terminate it to create your own broadband connection.
         */
        public FixedNetDetailsBuilder withProviderReuseOfAddress(String providerReuseOfAddress) {
            this.providerReuseOfAddress = providerReuseOfAddress;
            return this;
        }
        /**
         * Reference number of customer within current provider.
         */
        public FixedNetDetailsBuilder withProviderAoCustomerRefNumber(String providerAoCustomerRefNumber) {
            this.providerAoCustomerRefNumber = providerAoCustomerRefNumber;
            return this;
        }
        /**
         * Name of the current connectivity provider.
         */
        public FixedNetDetailsBuilder withCurrentProviderName(String currentProviderName) {
            this.currentProviderName = currentProviderName;
            return this;
        }

        public FixedNetDetailsBuilder withAoCustomerReference(String aoCustomerReference) {
            this.aoCustomerReference = aoCustomerReference;
            return this;
        }

        public FixedNetDetailsBuilder withVendor(String vendor) {
            this.vendor = vendor;
            return this;
        }

        public FixedNetDetailsBuilder withVendorProductCode(String vendorProductCode) {
            this.vendorProductCode = vendorProductCode;
            return this;
        }

        public FixedNetDetailsBuilder withVendorProductCatalogId(String vendorProductCatalogId) {
            this.vendorProductCatalogId = vendorProductCatalogId;
            return this;
        }

        public FixedNetDetailsBuilder withCustomerProductId(String customerProductId) {
            this.customerProductId = customerProductId;
            return this;
        }

        public FixedNetDetailsBuilder withExistingVendorProductCode(String existingVendorProductCode) {
            this.existingVendorProductCode = existingVendorProductCode;
            return this;
        }

        public FixedNetDetailsBuilder withFixedIp(Boolean fixedIp) {
            this.fixedIp = fixedIp;
            return this;
        }

        public OrderClientDTO.FixedNetDetails build() {
            OrderClientDTO.FixedNetDetails result = new OrderClientDTO.FixedNetDetails();

            if (this.networkConfigurationListBuilder != null) {
                result.networkConfiguration = this.networkConfigurationListBuilder.build();
            }

            if (this.orderEventDetailListBuilder != null) {
                result.events = this.orderEventDetailListBuilder.build();
            }

            if (this.fixedNetFlagsBuilder != null) {
                result.fixedNetFlags = this.fixedNetFlagsBuilder.build();
            }

            if (this.installationAddressBuilder != null) {
                result.installationAddress = this.installationAddressBuilder.build();
            }

            if (this.lastMileAccessPointAddressBuilder != null) {
                result.lastMileAccessPointAddress = this.lastMileAccessPointAddressBuilder.build();
            }

            result.internalCircuitId = this.internalCircuitId;
            result.diggingDistance = this.diggingDistance;
            result.speedProduct = this.speedProduct;
            result.technicalProduct = this.technicalProduct;
            result.speedDown = this.speedDown;
            result.speedUp = this.speedUp;
            result.packageId = this.packageId;
            result.accessType = this.accessType;
            result.dslTechnologyType = this.dslTechnologyType;
            result.previousTdcCircuitId = this.previousTdcCircuitId;
            result.destinationTdcCircuitId = this.destinationTdcCircuitId;
            result.previousLinePhoneNumber = this.previousLinePhoneNumber;
            result.destinationLinePhoneNumber = this.destinationLinePhoneNumber;
            result.ipAddressType = this.ipAddressType;
            result.cpeMode = this.cpeMode;
            result.dslType = this.dslType;
            result.sla = this.sla;
            result.addExtraBeChannel = this.addExtraBeChannel;
            result.allowRedColor = this.allowRedColor;
            result.flowType = this.flowType;
            result.doItYourselfInstallation = this.doItYourselfInstallation;
            result.doItYourselfContactName = this.doItYourselfContactName;
            result.doItYourselfContactNumber = this.doItYourselfContactNumber;
            result.providerReuseOfAddress = this.providerReuseOfAddress;
            result.providerAoCustomerRefNumber = this.providerAoCustomerRefNumber;
            result.currentProviderName = this.currentProviderName;
            result.aoCustomerReference = this.aoCustomerReference;
            result.vendor = this.vendor;
            result.vendorProductCode = this.vendorProductCode;
            result.vendorProductCatalogId = this.vendorProductCatalogId;
            result.customerProductId = this.customerProductId;
            result.existingVendorProductCode = this.existingVendorProductCode;
            result.fixedIp = this.fixedIp;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * FixedNetFlagsBuilder used to build OrderClientDTO.FixedNetFlags
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class FixedNetFlagsBuilder {
        private Boolean skipStateEvent;
        private Boolean skipCpeTechnician;
        private Boolean skipIp;
        private Boolean skipInvoice;
        private Boolean hasInstallationTypeConflict;
        private Boolean manualChangeProvider;
        private Boolean coaxDifferentProvider;
        private Boolean diggingNeeded;
        private Boolean manualOrdering;
        private Boolean moveToDifferentAddress;
        private Boolean lineTakeOver;
        private Boolean activeBlockingLinePresent;
        private Boolean activeLineTerminated;
        private Boolean plugPresentPositiveValidation;
        private Boolean providerChangeAccountNumberMissing;
        private Boolean customerRequestsChangeProvider;

        public FixedNetFlagsBuilder withSkipStateEvent(Boolean skipStateEvent) {
            this.skipStateEvent = skipStateEvent;
            return this;
        }

        public FixedNetFlagsBuilder withSkipCpeTechnician(Boolean skipCpeTechnician) {
            this.skipCpeTechnician = skipCpeTechnician;
            return this;
        }

        public FixedNetFlagsBuilder withSkipIp(Boolean skipIp) {
            this.skipIp = skipIp;
            return this;
        }

        public FixedNetFlagsBuilder withSkipInvoice(Boolean skipInvoice) {
            this.skipInvoice = skipInvoice;
            return this;
        }

        public FixedNetFlagsBuilder withHasInstallationTypeConflict(Boolean hasInstallationTypeConflict) {
            this.hasInstallationTypeConflict = hasInstallationTypeConflict;
            return this;
        }

        public FixedNetFlagsBuilder withManualChangeProvider(Boolean manualChangeProvider) {
            this.manualChangeProvider = manualChangeProvider;
            return this;
        }

        public FixedNetFlagsBuilder withCoaxDifferentProvider(Boolean coaxDifferentProvider) {
            this.coaxDifferentProvider = coaxDifferentProvider;
            return this;
        }

        public FixedNetFlagsBuilder withDiggingNeeded(Boolean diggingNeeded) {
            this.diggingNeeded = diggingNeeded;
            return this;
        }

        public FixedNetFlagsBuilder withManualOrdering(Boolean manualOrdering) {
            this.manualOrdering = manualOrdering;
            return this;
        }

        public FixedNetFlagsBuilder withMoveToDifferentAddress(Boolean moveToDifferentAddress) {
            this.moveToDifferentAddress = moveToDifferentAddress;
            return this;
        }

        public FixedNetFlagsBuilder withLineTakeOver(Boolean lineTakeOver) {
            this.lineTakeOver = lineTakeOver;
            return this;
        }

        public FixedNetFlagsBuilder withActiveBlockingLinePresent(Boolean activeBlockingLinePresent) {
            this.activeBlockingLinePresent = activeBlockingLinePresent;
            return this;
        }

        public FixedNetFlagsBuilder withActiveLineTerminated(Boolean activeLineTerminated) {
            this.activeLineTerminated = activeLineTerminated;
            return this;
        }

        public FixedNetFlagsBuilder withPlugPresentPositiveValidation(Boolean plugPresentPositiveValidation) {
            this.plugPresentPositiveValidation = plugPresentPositiveValidation;
            return this;
        }

        public FixedNetFlagsBuilder withProviderChangeAccountNumberMissing(Boolean providerChangeAccountNumberMissing) {
            this.providerChangeAccountNumberMissing = providerChangeAccountNumberMissing;
            return this;
        }

        public FixedNetFlagsBuilder withCustomerRequestsChangeProvider(Boolean customerRequestsChangeProvider) {
            this.customerRequestsChangeProvider = customerRequestsChangeProvider;
            return this;
        }

        public OrderClientDTO.FixedNetFlags build() {
            OrderClientDTO.FixedNetFlags result = new OrderClientDTO.FixedNetFlags();
            result.skipStateEvent = this.skipStateEvent;
            result.skipCpeTechnician = this.skipCpeTechnician;
            result.skipIp = this.skipIp;
            result.skipInvoice = this.skipInvoice;
            result.hasInstallationTypeConflict = this.hasInstallationTypeConflict;
            result.manualChangeProvider = this.manualChangeProvider;
            result.coaxDifferentProvider = this.coaxDifferentProvider;
            result.diggingNeeded = this.diggingNeeded;
            result.manualOrdering = this.manualOrdering;
            result.moveToDifferentAddress = this.moveToDifferentAddress;
            result.lineTakeOver = this.lineTakeOver;
            result.activeBlockingLinePresent = this.activeBlockingLinePresent;
            result.activeLineTerminated = this.activeLineTerminated;
            result.plugPresentPositiveValidation = this.plugPresentPositiveValidation;
            result.providerChangeAccountNumberMissing = this.providerChangeAccountNumberMissing;
            result.customerRequestsChangeProvider = this.customerRequestsChangeProvider;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * ForwardingSettingBuilder used to build OrderClientDTO.ForwardingSetting
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class ForwardingSettingBuilder {
        private Boolean enabled;
        private String targetNumber;

        public ForwardingSettingBuilder withEnabled(Boolean enabled) {
            this.enabled = enabled;
            return this;
        }

        /**
         * Where to forward calls. Parameter is mandatory if enabled is set to true.
         */
        public ForwardingSettingBuilder withTargetNumber(String targetNumber) {
            this.targetNumber = targetNumber;
            return this;
        }

        public OrderClientDTO.ForwardingSetting build() {
            OrderClientDTO.ForwardingSetting result = new OrderClientDTO.ForwardingSetting();
            result.enabled = this.enabled;
            result.targetNumber = this.targetNumber;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * HardwareDeliveryBuilder used to build OrderClientDTO.HardwareDelivery
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class HardwareDeliveryBuilder {
        private Integer id;
        private PartyRoleBuilder recipientPartyRoleBuilder;
        private PartyRoleBuilder billingPartyRoleBuilder;
        private String deliveryMethod;
        private AmountBuilder deliveryPriceAmountBuilder;
        private OrderClientDTOEnums.HardwareDeliveryPreferredContactMethodEnum preferredContactMethod;
        private DateTime dispatchDate;
        private DateTime preferredSendDate;

        /**
         * Unique identifier of hardware delivery.
         */
        public HardwareDeliveryBuilder withId(Integer id) {
            this.id = id;
            return this;
        }

        public HardwareDeliveryBuilder withRecipientPartyRoleBuilder(PartyRoleBuilder recipientPartyRoleBuilder) {
            this.recipientPartyRoleBuilder = recipientPartyRoleBuilder;
            return this;
        }

        public HardwareDeliveryBuilder withBillingPartyRoleBuilder(PartyRoleBuilder billingPartyRoleBuilder) {
            this.billingPartyRoleBuilder = billingPartyRoleBuilder;
            return this;
        }
        /**
         * String identifier of delivery method.
         */
        public HardwareDeliveryBuilder withDeliveryMethod(String deliveryMethod) {
            this.deliveryMethod = deliveryMethod;
            return this;
        }

        public HardwareDeliveryBuilder withDeliveryPriceAmountBuilder(AmountBuilder deliveryPriceAmountBuilder) {
            this.deliveryPriceAmountBuilder = deliveryPriceAmountBuilder;
            return this;
        }

        public HardwareDeliveryBuilder withPreferredContactMethod(
            OrderClientDTOEnums.HardwareDeliveryPreferredContactMethodEnum preferredContactMethod
        ) {
            this.preferredContactMethod = preferredContactMethod;
            return this;
        }
        /**
         * Date time with timezone according to ISO-8601. Timestamp of when the hardware has been sent out from warehouse.
         */
        public HardwareDeliveryBuilder withDispatchDate(DateTime dispatchDate) {
            this.dispatchDate = dispatchDate;
            return this;
        }

        public HardwareDeliveryBuilder withPreferredSendDate(DateTime preferredSendDate) {
            this.preferredSendDate = preferredSendDate;

            return this;
        }

        public OrderClientDTO.HardwareDelivery build() {
            OrderClientDTO.HardwareDelivery result = new OrderClientDTO.HardwareDelivery();
            result.id = this.id;
            result.deliveryMethod = this.deliveryMethod;
            result.preferredContactMethod = this.preferredContactMethod;
            result.dispatchDate = this.dispatchDate;
            result.prefferedSendDate = this.preferredSendDate;

            if (deliveryPriceAmountBuilder != null) {
                result.deliveryPrice = this.deliveryPriceAmountBuilder.build();
            }

            if (this.recipientPartyRoleBuilder != null) {
                result.recipientParty = this.recipientPartyRoleBuilder.build();
            }

            if (this.billingPartyRoleBuilder != null) {
                result.billingParty = this.billingPartyRoleBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * HardwarePaymentConfigurationPatchBuilder used to build OrderClientDTO.HardwarePaymentConfigurationPatch
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class HardwarePaymentConfigurationPatchBuilder {
        private OrderClientDTOEnums.PaymentType paymentType;
        private PaymentAmountBuilder totalPaymentAmountBuilder;
        private PaymentAmountBuilder upfrontPaymentAmountBuilder;
        private PaymentAmountBuilder downPaymentAmountBuilder;
        private DiscountBuilder discountBuilder;
        private Decimal numberOfInstallments;

        public HardwarePaymentConfigurationPatchBuilder withPaymentType(OrderClientDTOEnums.PaymentType paymentType) {
            this.paymentType = paymentType;
            return this;
        }

        public HardwarePaymentConfigurationPatchBuilder withTotalPaymentAmount(
            PaymentAmountBuilder totalPaymentAmountBuilder
        ) {
            this.totalPaymentAmountBuilder = totalPaymentAmountBuilder;
            return this;
        }

        public HardwarePaymentConfigurationPatchBuilder withUpfrontPaymentAmount(
            PaymentAmountBuilder upfrontPaymentAmountBuilder
        ) {
            this.upfrontPaymentAmountBuilder = upfrontPaymentAmountBuilder;
            return this;
        }

        public HardwarePaymentConfigurationPatchBuilder withDownPaymentAmount(
            PaymentAmountBuilder downPaymentAmountBuilder
        ) {
            this.downPaymentAmountBuilder = downPaymentAmountBuilder;
            return this;
        }

        public HardwarePaymentConfigurationPatchBuilder withDiscount(DiscountBuilder discountBuilder) {
            this.discountBuilder = discountBuilder;
            return this;
        }

        public HardwarePaymentConfigurationPatchBuilder withNumberOfInstallments(Decimal numberOfInstallments) {
            this.numberOfInstallments = numberOfInstallments;
            return this;
        }

        public OrderClientDTO.HardwarePaymentConfigurationPatch build() {
            OrderClientDTO.HardwarePaymentConfigurationPatch result = new OrderClientDTO.HardwarePaymentConfigurationPatch();
            result.paymentType = this.paymentType;
            result.numberOfInstallments = this.numberOfInstallments;

            if (this.totalPaymentAmountBuilder != null) {
                result.totalPayment = this.totalPaymentAmountBuilder.build();
            }

            if (this.upfrontPaymentAmountBuilder != null) {
                result.upfrontPayment = this.upfrontPaymentAmountBuilder.build();
            }

            if (this.downPaymentAmountBuilder != null) {
                result.downPayment = this.downPaymentAmountBuilder.build();
            }

            if (this.discountBuilder != null) {
                result.discount = this.discountBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * HomeOfficeOrderPatchBuilder used to build OrderClientDTO.HomeOfficeOrderPatch
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class HomeOfficeOrderPatchBuilder {
        private PersonBuilder legalPartyBuilder;
        private PersonBuilder billingPartyBuilder;
        private InstallationAddressBuilder installationAddressBuilder;
        private PersonBuilder recipientPartyBuilder;
        private String vendor;
        private String employeeId;

        public HomeOfficeOrderPatchBuilder withLegalParty(PersonBuilder legalPartyBuilder) {
            this.legalPartyBuilder = legalPartyBuilder;
            return this;
        }

        public HomeOfficeOrderPatchBuilder withBillingParty(PersonBuilder billingPartyBuilder) {
            this.billingPartyBuilder = billingPartyBuilder;
            return this;
        }

        public HomeOfficeOrderPatchBuilder withInstallationAddress(
            InstallationAddressBuilder installationAddressBuilder
        ) {
            this.installationAddressBuilder = installationAddressBuilder;
            return this;
        }

        public HomeOfficeOrderPatchBuilder withRecipientParty(PersonBuilder recipientPartyBuilder) {
            this.recipientPartyBuilder = recipientPartyBuilder;
            return this;
        }

        public HomeOfficeOrderPatchBuilder withVendor(String vendor) {
            this.vendor = vendor;
            return this;
        }

        public HomeOfficeOrderPatchBuilder withEmployeeId(String employeeId) {
            this.employeeId = employeeId;
            return this;
        }

        //TODO UNIT TEST THIS BUILDER! CASTING TO PERSON!
        public OrderClientDTO.HomeOfficeOrderPatch build() {
            OrderClientDTO.HomeOfficeOrderPatch result = new OrderClientDTO.HomeOfficeOrderPatch();

            if (this.legalPartyBuilder != null) {
                result.legalParty = (OrderClientDTO.Person) this.legalPartyBuilder.build();
            }

            if (this.billingPartyBuilder != null) {
                result.billingParty = (OrderClientDTO.Person) this.billingPartyBuilder.build();
            }

            if (this.recipientPartyBuilder != null) {
                result.recipientParty = (OrderClientDTO.Person) this.recipientPartyBuilder.build();
            }

            if (this.installationAddressBuilder != null) {
                result.installationAddress = this.installationAddressBuilder.build();
            }

            result.vendor = this.vendor;
            result.employeeId = this.employeeId;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * InstallationAddressBuilder used to build OrderClientDTO.InstallationAddress
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class InstallationAddressBuilder {
        private AddressBuilder postalAddressBuilder;
        private String streetCode;
        private String municipalityCode;
        private String siteId;
        private String kvh;
        private String kvhx;
        private String addressRefId;

        public InstallationAddressBuilder withPostalAddressBuilder(AddressBuilder postalAddressBuilder) {
            this.postalAddressBuilder = postalAddressBuilder;
            return this;
        }

        public InstallationAddressBuilder withStreetCode(String streetCode) {
            this.streetCode = streetCode;
            return this;
        }

        public InstallationAddressBuilder withMunicipalityCode(String municipalityCode) {
            this.municipalityCode = municipalityCode;
            return this;
        }

        public InstallationAddressBuilder withSiteId(String siteId) {
            this.siteId = siteId;
            return this;
        }

        public InstallationAddressBuilder withKvh(String kvh) {
            this.kvh = kvh;
            return this;
        }

        public InstallationAddressBuilder withKvhx(String kvhx) {
            this.kvhx = kvhx;
            return this;
        }

        /**
         *  This attribute is sent to LineInquiryAPI as DawaId. The field in LineInquiryAPI request for this is called addressId.
         */
        public InstallationAddressBuilder withAddressRefId(String addressRefId) {
            this.addressRefId = addressRefId;
            return this;
        }

        public OrderClientDTO.InstallationAddress build() {
            OrderClientDTO.InstallationAddress result = new OrderClientDTO.InstallationAddress();

            if (this.postalAddressBuilder != null) {
                result.postalAddress = this.postalAddressBuilder.build();
            }
            result.streetCode = this.streetCode;
            result.municipalityCode = this.municipalityCode;
            result.siteId = this.siteId;
            result.kvh = this.kvh;
            result.kvhx = this.kvhx;
            result.addressRefId = this.addressRefId;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * IpConfigurationBuilder used to build OrderClientDTO.IpConfiguration
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class IpConfigurationBuilder {
        private String ip;
        private String netmask;
        private String defaultGateway;

        public IpConfigurationBuilder withIp(String ip) {
            this.ip = ip;
            return this;
        }

        public IpConfigurationBuilder withNetmask(String netmask) {
            this.netmask = netmask;
            return this;
        }

        public IpConfigurationBuilder withDefaultGateway(String defaultGateway) {
            this.defaultGateway = defaultGateway;
            return this;
        }

        public OrderClientDTO.IpConfiguration build() {
            OrderClientDTO.IpConfiguration result = new OrderClientDTO.IpConfiguration();
            result.defaultGateway = this.defaultGateway;
            result.ip = this.ip;
            result.netmask = this.netmask;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * MarketingConsentBuilder used to build OrderClientDTO.MarketingConsent
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class MarketingConsentBuilder {
        private String leadSourceId;
        private Boolean directMarketing;
        private String url;
        private Boolean tracking;

        public MarketingConsentBuilder withLeadSourceId(String leadSourceId) {
            this.leadSourceId = leadSourceId;
            return this;
        }

        public MarketingConsentBuilder withDirectMarketing(Boolean directMarketing) {
            this.directMarketing = directMarketing;
            return this;
        }

        public MarketingConsentBuilder withTracking(Boolean tracking) {
            this.tracking = tracking;
            return this;
        }

        public MarketingConsentBuilder withUrl(String url) {
            this.url = url;
            return this;
        }

        public OrderClientDTO.MarketingConsents build() {
            OrderClientDTO.MarketingConsents result = new OrderClientDTO.MarketingConsents();
            result.leadSourceId = this.leadSourceId;
            result.directMarketing = this.directMarketing;
            result.tracking = this.tracking;
            result.url = this.url;
            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * NetworkConfigurationBuilder used to build OrderClientDTO.NetworkConfiguration
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class NetworkConfigurationBuilder {
        private String cpeName;
        private String qosProfileName;
        private String vrfName;
        private String vpnInstance;
        private String pppMultilinkGroup;
        private String ipHelper;
        private String routingProtocol;
        private String asNumber;
        private String timeslots;
        private String internetPorts;
        private String cpeSerial;
        private String mobileDialerIp;
        private String mobileCpeSerial;
        private String mobileNetworkIp;
        private String mobileNetworkNetmask;
        private String proactivity;
        private String proactivityProactivityPhone;
        private IpConfigurationBuilder secondaryLanIpConfigBuilder;
        private IpConfigurationBuilder staticRouteIpConfigBuilder;
        private IpConfigurationBuilder snmpAclIpConfigBuilder;
        private String linkIpNetworkNetmask;
        private String linkIpNetworkIp;
        private String lanIpAddressIp;
        private String lanIpAddressNetmask;
        private String lanIpAddressHsrip;
        private String dhcpAddressRange;
        private String dhcpLeaseTime;
        private String dhcpDomainName;
        private String dhcpWinsPrimary;
        private String dhcpWinsSecondary;
        private String dhcpDnsPrimary;
        private String dhcpDnsSecondary;
        private String snmpCommunity;

        public NetworkConfigurationBuilder withCpeName(String cpeName) {
            this.cpeName = cpeName;
            return this;
        }

        public NetworkConfigurationBuilder withQosProfileName(String qosProfileName) {
            this.qosProfileName = qosProfileName;
            return this;
        }

        public NetworkConfigurationBuilder withVrfName(String vrfName) {
            this.vrfName = vrfName;
            return this;
        }

        public NetworkConfigurationBuilder withVpnInstance(String vpnInstance) {
            this.vpnInstance = vpnInstance;
            return this;
        }

        public NetworkConfigurationBuilder withPppMultilinkGroup(String pppMultilinkGroup) {
            this.pppMultilinkGroup = pppMultilinkGroup;
            return this;
        }

        public NetworkConfigurationBuilder withIpHelper(String ipHelper) {
            this.ipHelper = ipHelper;
            return this;
        }

        public NetworkConfigurationBuilder withRoutingProtocol(String routingProtocol) {
            this.routingProtocol = routingProtocol;
            return this;
        }

        public NetworkConfigurationBuilder withAsNumber(String asNumber) {
            this.asNumber = asNumber;
            return this;
        }

        public NetworkConfigurationBuilder withTimeslots(String timeslots) {
            this.timeslots = timeslots;
            return this;
        }

        public NetworkConfigurationBuilder withInternetPorts(String internetPorts) {
            this.internetPorts = internetPorts;
            return this;
        }

        public NetworkConfigurationBuilder withCpeSerial(String cpeSerial) {
            this.cpeSerial = cpeSerial;
            return this;
        }

        public NetworkConfigurationBuilder withMobileDialerIp(String mobileDialerIp) {
            this.mobileDialerIp = mobileDialerIp;
            return this;
        }

        public NetworkConfigurationBuilder withMobileCpeSerial(String mobileCpeSerial) {
            this.mobileCpeSerial = mobileCpeSerial;
            return this;
        }

        public NetworkConfigurationBuilder withMobileNetworkIp(String mobileNetworkIp) {
            this.mobileNetworkIp = mobileNetworkIp;
            return this;
        }

        public NetworkConfigurationBuilder withMobileNetworkNetmask(String mobileNetworkNetmask) {
            this.mobileNetworkNetmask = mobileNetworkNetmask;
            return this;
        }

        public NetworkConfigurationBuilder withProactivity(String proactivity) {
            this.proactivity = proactivity;
            return this;
        }

        public NetworkConfigurationBuilder withProactivityPhone(String proactivityProactivityPhone) {
            this.proactivityProactivityPhone = proactivityProactivityPhone;
            return this;
        }

        public NetworkConfigurationBuilder withSecondaryLanIpConfig(
            IpConfigurationBuilder secondaryLanIpConfigBuilder
        ) {
            this.secondaryLanIpConfigBuilder = secondaryLanIpConfigBuilder;
            return this;
        }

        public NetworkConfigurationBuilder withStaticRouteIpConfig(IpConfigurationBuilder staticRouteIpConfigBuilder) {
            this.staticRouteIpConfigBuilder = staticRouteIpConfigBuilder;
            return this;
        }

        public NetworkConfigurationBuilder withSnmpAclIpConfig(IpConfigurationBuilder snmpAclIpConfigBuilder) {
            this.snmpAclIpConfigBuilder = snmpAclIpConfigBuilder;
            return this;
        }

        public NetworkConfigurationBuilder withLinkIpNetworkNetmask(String linkIpNetworkNetmask) {
            this.linkIpNetworkNetmask = linkIpNetworkNetmask;
            return this;
        }

        public NetworkConfigurationBuilder withLinkIpNetworkIp(String linkIpNetworkIp) {
            this.linkIpNetworkIp = linkIpNetworkIp;
            return this;
        }

        public NetworkConfigurationBuilder withLanIpAddressIp(String lanIpAddressIp) {
            this.lanIpAddressIp = lanIpAddressIp;
            return this;
        }

        public NetworkConfigurationBuilder withLanIpAddressNetmask(String lanIpAddressNetmask) {
            this.lanIpAddressNetmask = lanIpAddressNetmask;
            return this;
        }

        public NetworkConfigurationBuilder withLanIpAddressHsrip(String lanIpAddressHsrip) {
            this.lanIpAddressHsrip = lanIpAddressHsrip;
            return this;
        }

        public NetworkConfigurationBuilder withDhcpAddressRange(String dhcpAddressRange) {
            this.dhcpAddressRange = dhcpAddressRange;
            return this;
        }

        public NetworkConfigurationBuilder withDhcpLeaseTime(String dhcpLeaseTime) {
            this.dhcpLeaseTime = dhcpLeaseTime;
            return this;
        }

        public NetworkConfigurationBuilder withDhcpDomainName(String dhcpDomainName) {
            this.dhcpDomainName = dhcpDomainName;
            return this;
        }

        public NetworkConfigurationBuilder withDhcpWinsPrimary(String dhcpWinsPrimary) {
            this.dhcpWinsPrimary = dhcpWinsPrimary;
            return this;
        }

        public NetworkConfigurationBuilder withDhcpWinsSecondary(String dhcpWinsSecondary) {
            this.dhcpWinsSecondary = dhcpWinsSecondary;
            return this;
        }

        public NetworkConfigurationBuilder withDhcpDnsPrimary(String dhcpDnsPrimary) {
            this.dhcpDnsPrimary = dhcpDnsPrimary;
            return this;
        }

        public NetworkConfigurationBuilder withDhcpDnsSecondary(String dhcpDnsSecondary) {
            this.dhcpDnsSecondary = dhcpDnsSecondary;
            return this;
        }

        public NetworkConfigurationBuilder withSnmpCommunity(String snmpCommunity) {
            this.snmpCommunity = snmpCommunity;
            return this;
        }

        public OrderClientDTO.NetworkConfiguration build() {
            OrderClientDTO.NetworkConfiguration result = new OrderClientDTO.NetworkConfiguration();

            if (this.secondaryLanIpConfigBuilder != null) {
                result.secondaryLanIpConfig = this.secondaryLanIpConfigBuilder.build();
            }

            if (this.staticRouteIpConfigBuilder != null) {
                result.staticRouteIpConfig = this.staticRouteIpConfigBuilder.build();
            }

            if (this.snmpAclIpConfigBuilder != null) {
                result.snmpAclIpConfig = this.snmpAclIpConfigBuilder.build();
            }

            result.cpeName = this.cpeName;
            result.qosProfileName = this.qosProfileName;
            result.vrfName = this.vrfName;
            result.vpnInstance = this.vpnInstance;
            result.pppMultilinkGroup = this.pppMultilinkGroup;
            result.ipHelper = this.ipHelper;
            result.routingProtocol = this.routingProtocol;
            result.asNumber = this.asNumber;
            result.timeslots = this.timeslots;
            result.internetPorts = this.internetPorts;
            result.cpeSerial = this.cpeSerial;
            result.mobileDialerIp = this.mobileDialerIp;
            result.mobileCpeSerial = this.mobileCpeSerial;
            result.mobileNetworkIp = this.mobileNetworkIp;
            result.mobileNetworkNetmask = this.mobileNetworkNetmask;
            result.proactivity = this.proactivity;
            result.proactivityProactivityPhone = this.proactivityProactivityPhone;
            result.linkIpNetworkNetmask = this.linkIpNetworkNetmask;
            result.linkIpNetworkIp = this.linkIpNetworkIp;
            result.lanIpAddressIp = this.lanIpAddressIp;
            result.lanIpAddressNetmask = this.lanIpAddressNetmask;
            result.lanIpAddressHsrip = this.lanIpAddressHsrip;
            result.dhcpAddressRange = this.dhcpAddressRange;
            result.dhcpLeaseTime = this.dhcpLeaseTime;
            result.dhcpDomainName = this.dhcpDomainName;
            result.dhcpWinsPrimary = this.dhcpWinsPrimary;
            result.dhcpWinsSecondary = this.dhcpWinsSecondary;
            result.dhcpDnsPrimary = this.dhcpDnsPrimary;
            result.dhcpDnsSecondary = this.dhcpDnsSecondary;
            result.snmpCommunity = this.snmpCommunity;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * NoAnswerForwardingSettingBuilder used to build OrderClientDTO.NoAnswerForwardingSetting
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class NoAnswerForwardingSettingBuilder {
        private Boolean enabled;
        private String targetNumber;
        private Integer delay;

        public NoAnswerForwardingSettingBuilder withEnabled(Boolean enabled) {
            this.enabled = enabled;
            return this;
        }

        /**
         * Where to forward calls. Parameter is mandatory if enabled is set to true.
         */
        public NoAnswerForwardingSettingBuilder withTargetNumber(String targetNumber) {
            this.targetNumber = targetNumber;
            return this;
        }

        /**
         * Delay after which to forward the call. Parameter is mandatory if enabled is set to true.
         */
        public NoAnswerForwardingSettingBuilder withDelay(Integer delay) {
            this.delay = delay;
            return this;
        }

        public OrderClientDTO.NoAnswerForwardingSetting build() {
            OrderClientDTO.NoAnswerForwardingSetting result = new OrderClientDTO.NoAnswerForwardingSetting();
            result.enabled = this.enabled;
            result.targetNumber = this.targetNumber;
            result.delay = this.delay;
            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * NotificationRecipientBuilder used to build OrderClientDTO.NotificationRecipient
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class NotificationRecipientBuilder {
        private OrderClientDTOEnums.NotificationRecipientRoleEnum role;
        private String email;
        private String telephoneNumber;

        public NotificationRecipientBuilder withRole(OrderClientDTOEnums.NotificationRecipientRoleEnum role) {
            this.role = role;
            return this;
        }

        public NotificationRecipientBuilder withEmail(String email) {
            this.email = email;
            return this;
        }

        public NotificationRecipientBuilder withTelephoneNumber(String telephoneNumber) {
            this.telephoneNumber = telephoneNumber;
            return this;
        }

        public OrderClientDTO.NotificationRecipient build() {
            OrderClientDTO.NotificationRecipient result = new OrderClientDTO.NotificationRecipient();
            result.email = this.email;
            result.telephoneNumber = this.telephoneNumber;
            result.role = this.role;
            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OfferingBuilder used to build OrderClientDTO.Offering
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OfferingBuilder {
        private String priceplan;
        private String campaign;
        private String discount;
        private String name;
        private String bindingPeriod;
        private String productOfferingId;
        private AmountBuilder monthlyPriceAmountBuilder;

        /**
         * Priceplan SOC code.
         */
        public OfferingBuilder withPriceplan(String priceplan) {
            this.priceplan = priceplan;
            return this;
        }

        /**
         * Campaign SOC code.
         */
        public OfferingBuilder withCampaign(String campaign) {
            this.campaign = campaign;

            return this;
        }

        /**
         * Discount SOC code.
         */
        public OfferingBuilder withDiscount(String discount) {
            this.discount = discount;

            return this;
        }

        /**
         * Name of the whole offering that's to be displayed on web or documents.
         */
        public OfferingBuilder withName(String name) {
            this.name = name;

            return this;
        }

        /**
         * Type of the product (GSM, ...).
         */
        public OfferingBuilder withBindingPeriod(String bindingPeriod) {
            this.bindingPeriod = bindingPeriod;

            return this;
        }

        public OfferingBuilder withMonthlyPriceAmountBuilder(AmountBuilder monthlyPriceBuilder) {
            this.monthlyPriceAmountBuilder = monthlyPriceAmountBuilder;
            return this;
        }

        /**
         * Id of the offering as provided by ProductCatalog.
         */
        public OfferingBuilder withProductOfferingId(String ProductOfferingId) {
            this.productOfferingId = productOfferingId;
            return this;
        }

        public OrderClientDTO.Offering build() {
            OrderClientDTO.Offering result = new OrderClientDTO.Offering();
            result.priceplan = this.priceplan;
            result.campaign = this.campaign;
            result.discount = this.discount;
            result.name = this.name;
            result.bindingPeriod = this.bindingPeriod;
            result.productOfferingId = this.productOfferingId;

            if (this.monthlyPriceAmountBuilder != null) {
                result.monthlyPrice = this.monthlyPriceAmountBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderAdditionalInfoPatchBuilder used to build OrderClientDTO.OrderAdditionalInfoPatch
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrderAdditionalInfoPatchBuilder {
        private String orderMemo;

        public OrderAdditionalInfoPatchBuilder withOrderMemo(String orderMemo) {
            this.orderMemo = orderMemo;
            return this;
        }

        public OrderClientDTO.OrderAdditionalInfoPatch build() {
            OrderClientDTO.OrderAdditionalInfoPatch result = new OrderClientDTO.OrderAdditionalInfoPatch();
            result.orderMemo = this.orderMemo;
            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderApprovalBuilder used to build OrderClientDTO.OrderApproval
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrderApprovalBuilder {
        private String approvalComment;
        private String approvalIp;

        public OrderApprovalBuilder withApprovalComment(String approvalComment) {
            this.approvalComment = approvalComment;
            return this;
        }

        public OrderApprovalBuilder withApprovalIp(String approvalIp) {
            this.approvalIp = approvalIp;
            return this;
        }

        public OrderClientDTO.OrderApproval build() {
            OrderClientDTO.OrderApproval result = new OrderClientDTO.OrderApproval();
            result.approvalIp = this.approvalIp;
            result.approvalComment = this.approvalComment;
            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderEventDetailsBuilder used to build OrderClientDTO.OrderEventDetails
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrderEventDetailsBuilder {
        private String category;
        private String description;
        private Date expectedCompletionDate;
        private Integer id;
        private Date startDate;
        private String purchaseOrderId;
        private String state;
        private TechnicianDetailsBuilder technicianDetailsBuilder;

        public OrderEventDetailsBuilder withCategory(String category) {
            this.category = category;
            return this;
        }

        public OrderEventDetailsBuilder withDescription(String description) {
            this.description = description;
            return this;
        }

        public OrderEventDetailsBuilder withExpectedCompletionDate(Date expectedCompletionDate) {
            this.expectedCompletionDate = expectedCompletionDate;
            return this;
        }

        public OrderEventDetailsBuilder withId(Integer id) {
            this.id = id;
            return this;
        }

        public OrderEventDetailsBuilder withStartDate(Date startDate) {
            this.startDate = startDate;
            return this;
        }

        public OrderEventDetailsBuilder withPurchaseOrderId(String purchaseOrderId) {
            this.purchaseOrderId = purchaseOrderId;
            return this;
        }

        public OrderEventDetailsBuilder withState(String state) {
            this.state = state;
            return this;
        }

        public OrderEventDetailsBuilder withTechnicianDetailsBuilder(
            TechnicianDetailsBuilder technicianDetailsBuilder
        ) {
            this.technicianDetailsBuilder = technicianDetailsBuilder;
            return this;
        }

        public OrderClientDTO.OrderEventDetails build() {
            OrderClientDTO.OrderEventDetails result = new OrderClientDTO.OrderEventDetails();

            if (this.technicianDetailsBuilder != null) {
                result.technicianDetails = this.technicianDetailsBuilder.build();
            }

            result.category = this.category;
            result.description = this.description;
            result.expectedCompletionDate = this.expectedCompletionDate;
            result.id = this.id;
            result.startDate = this.startDate;
            result.purchaseOrderId = this.purchaseOrderId;
            result.state = this.state;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderFlagsBuilder used to build OrderClientDTO.OrderFlags
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrderFlagsBuilder {
        private Boolean orderConfirmed;
        private Boolean termsAccepted;
        private Boolean cprCheckFailed;
        private Boolean creditCheckFailed;
        private Boolean needsConfirmation;
        private Boolean membershipCheck;
        private Boolean dirty;
        private Boolean doCommunication;
        private Boolean doLogistics;
        private Boolean addCharge;
        private Boolean posFlow;
        private Boolean homeOfficeOrder;
        private Boolean createDraftOrder;
        private Boolean manualSigning;
        private Boolean simOnly;
        private Boolean hasUpfrontPayment;
        private Boolean tfFinancingNeeded;
        private Boolean physicalIdPreidentified;
        private Boolean shopSales;
        private Boolean orderExpired;
        private Boolean newDivaFlow;
        private Boolean isSubOrder;

        /**
         * Whether the order is confirmed or approved.
         */
        public OrderFlagsBuilder withOrderConfirmed(Boolean orderConfirmed) {
            this.orderConfirmed = orderConfirmed;
            return this;
        }

        /**
         * If customer agrees with terms and conditions. Must be true :)
         */
        public OrderFlagsBuilder withTermsAccepted(Boolean termsAccepted) {
            this.termsAccepted = termsAccepted;
            return this;
        }
        /**
         * If the CPR check failed.
         */
        public OrderFlagsBuilder withCprCheckFailed(Boolean cprCheckFailed) {
            this.cprCheckFailed = cprCheckFailed;
            return this;
        }
        /**
         * When the credit check failed.
         */
        public OrderFlagsBuilder withCreditCheckFailed(Boolean creditCheckFailed) {
            this.creditCheckFailed = creditCheckFailed;
            return this;
        }
        /**
         * Customer shall confirm the order as sales agent made it on their behalf.
         */
        public OrderFlagsBuilder withNeedsConfirmation(Boolean needsConfirmation) {
            this.needsConfirmation = needsConfirmation;
            return this;
        }
        /**
         * If there is any membership to be checked (voucher number or so)
         */
        public OrderFlagsBuilder withMembershipCheck(Boolean membershipCheck) {
            this.membershipCheck = membershipCheck;
            return this;
        }
        /**
         * The order is missing mandatory information
         */
        public OrderFlagsBuilder withDirty(Boolean dirty) {
            this.dirty = dirty;
            return this;
        }
        /**
         * Shall the backend send communication
         */
        public OrderFlagsBuilder withDoCommunication(Boolean doCommunication) {
            this.doCommunication = doCommunication;
            return this;
        }
        /**
         * Shall the backend send request for hardware shipment
         */
        public OrderFlagsBuilder withDoLogistics(Boolean doLogistics) {
            this.doLogistics = doLogistics;
            return this;
        }

        public OrderFlagsBuilder withAddCharge(Boolean addCharge) {
            this.addCharge = addCharge;
            return this;
        }
        /**
         * Order has been created via new POS
         */
        public OrderFlagsBuilder withPosFlow(Boolean posFlow) {
            this.posFlow = posFlow;
            return this;
        }
        /**
         * If order represents Home Office order
         */
        public OrderFlagsBuilder withHomeOfficeOrder(Boolean homeOfficeOrder) {
            this.homeOfficeOrder = homeOfficeOrder;
            return this;
        }
        /**
         * If draft order should be created during shopping cart submission
         */
        public OrderFlagsBuilder withCreateDraftOrder(Boolean createDraftOrder) {
            this.createDraftOrder = createDraftOrder;
            return this;
        }
        /**
         * If order follows manual signing flow
         */
        public OrderFlagsBuilder withManualSigning(Boolean manualSigning) {
            this.manualSigning = manualSigning;
            return this;
        }
        /**
         * If order is from Tango and has only SIM AdditionalProductItems
         */
        public OrderFlagsBuilder withSimOnly(Boolean simOnly) {
            this.simOnly = simOnly;
            return this;
        }
        /**
         * If order is from Tango and has at least one upfront payment on any HardwarePaymentItem
         */
        public OrderFlagsBuilder withHasUpfrontPayment(Boolean hasUpfrontPayment) {
            this.hasUpfrontPayment = hasUpfrontPayment;
            return this;
        }
        /**
         * If order is from Tango and has at least one down payment on any HardwarePaymentItem
         */
        public OrderFlagsBuilder withTfFinancingNeeded(Boolean tfFinancingNeeded) {
            this.tfFinancingNeeded = tfFinancingNeeded;
            return this;
        }
        /**
         * If order is from Tango and order was sold in shop
         */
        public OrderFlagsBuilder withPhysicalIdPreidentified(Boolean physicalIdPreidentified) {
            this.physicalIdPreidentified = physicalIdPreidentified;
            return this;
        }
        /**
         * If order is from Tango and order was sold in external store
         */
        public OrderFlagsBuilder withShopSales(Boolean shopSales) {
            this.shopSales = shopSales;
            return this;
        }
        /**
         * If order is already expired.
         */
        public OrderFlagsBuilder withOrderExpired(Boolean orderExpired) {
            this.orderExpired = orderExpired;
            return this;
        }
        /**
         * Go with the new DIVA flow.
         */
        public OrderFlagsBuilder withNewDivaFlow(Boolean newDivaFlow) {
            this.newDivaFlow = newDivaFlow;
            return this;
        }
        /**
         * If order is a sub order. Applies to return orders.
         */
        public OrderFlagsBuilder withIsSubOrder(Boolean isSubOrder) {
            this.isSubOrder = isSubOrder;
            return this;
        }

        public OrderClientDTO.OrderFlags build() {
            OrderClientDTO.OrderFlags result = new OrderClientDTO.OrderFlags();

            result.orderConfirmed = this.orderConfirmed;
            result.termsAccepted = this.termsAccepted;
            result.cprCheckFailed = this.cprCheckFailed;
            result.creditCheckFailed = this.creditCheckFailed;
            result.needsConfirmation = this.needsConfirmation;
            result.membershipCheck = this.membershipCheck;
            result.dirty = this.dirty;
            result.doCommunication = this.doCommunication;
            result.doLogistics = this.doLogistics;
            result.addCharge = this.addCharge;
            result.posFlow = this.posFlow;
            result.homeOfficeOrder = this.homeOfficeOrder;
            result.createDraftOrder = this.createDraftOrder;
            result.manualSigning = this.manualSigning;
            result.simOnly = this.simOnly;
            result.hasUpfrontPayment = this.hasUpfrontPayment;
            result.tfFinancingNeeded = this.tfFinancingNeeded;
            result.physicalIdPreidentified = this.physicalIdPreidentified;
            result.shopSales = this.shopSales;
            result.orderExpired = this.orderExpired;
            result.newDivaFlow = this.newDivaFlow;
            result.isSubOrder = this.isSubOrder;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderItemBuilder used to build OrderClientDTO.OrderItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public virtual class OrderItemBuilder {
        //TODO BUILDER FOR List<ValidationError>
        protected List<OrderClientDTO.ValidationError> validationErrors;

        protected OrderClientDTOEnums.OrderItemTypeEnum type;
        protected OrderClientDTOEnums.OrderItemActivityEnum activity;
        protected Integer id;
        protected String channelOrderItemId;
        protected OrderClientDTOEnums.OrderItemOriginEnum origin;

        public OrderItemBuilder withType(OrderClientDTOEnums.OrderItemTypeEnum type) {
            this.type = type;
            return this;
        }

        public OrderItemBuilder withActivity(OrderClientDTOEnums.OrderItemActivityEnum activity) {
            this.activity = activity;
            return this;
        }

        /**
         * Identifies the element uniquely in whole order. Is assigned by OrderAPI.
         */
        public OrderItemBuilder withId(Integer id) {
            this.id = id;
            return this;
        }

        /**
         * Intended to identify the element uniquely in whole order. Is assigned by the channel.
         */
        public OrderItemBuilder withChannelOrderItemId(String channelOrderItemId) {
            this.channelOrderItemId = channelOrderItemId;
            return this;
        }

        public OrderItemBuilder withOrigin(OrderClientDTOEnums.OrderItemOriginEnum origin) {
            this.origin = origin;
            return this;
        }

        public OrderClientDTO.OrderItem setProperties(OrderClientDTO.OrderItem orderItem) {
            orderItem.type = this.type;
            orderItem.activity = this.activity;
            orderItem.id = this.id;
            orderItem.channelOrderItemId = this.channelOrderItemId;
            orderItem.origin = this.origin;

            return orderItem;
        }

        public virtual OrderClientDTO.OrderItem build() {
            OrderClientDTO.OrderItem result = new OrderClientDTO.OrderItem();

            setProperties(result);

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * CreditWatchItemBuilder used to build OrderClientDTO.CreditWatchItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class CreditWatchItemBuilder extends OrderItemBuilder {
        private Decimal amount;
        private Boolean waiveFees;
        private Date expirationDate;

        public CreditWatchItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.CREDIT_WATCH_ITEM);
        }

        /**
         * Credit watch amount limit in DKK.
         */
        public CreditWatchItemBuilder withAmount(Decimal amount) {
            this.amount = amount;
            return this;
        }

        public CreditWatchItemBuilder withWaiveFees(Boolean waiveFees) {
            this.waiveFees = waiveFees;
            return this;
        }

        /**
         * Credit watch expiration date in format YYYY-MM-DD (according to ISO 8601)
         */
        public CreditWatchItemBuilder withExpirationDate(Date expirationDate) {
            this.expirationDate = expirationDate;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.CreditWatchItem result = new OrderClientDTO.CreditWatchItem();

            setProperties(result);

            result.amount = this.amount;
            result.waiveFees = this.waiveFees;
            result.expirationDate = this.expirationDate;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * DiscountItemBuilder used to build OrderClientDTO.DiscountItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class DiscountItemBuilder extends OrderItemBuilder {
        private String discountCode;
        private String reason;

        public DiscountItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.DISCOUNT_ITEM);
        }

        /**
         * Discount code as registered in Fokus
         */
        public DiscountItemBuilder withDiscountCode(String discountCode) {
            this.discountCode = discountCode;
            return this;
        }

        /**
         * Reason for the discount
         */
        public DiscountItemBuilder withReason(String reason) {
            this.reason = reason;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.DiscountItem result = new OrderClientDTO.DiscountItem();

            setProperties(result);

            result.discountCode = this.discountCode;
            result.reason = this.reason;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * FeeItemBuilder used to build OrderClientDTO.FeeItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class FeeItemBuilder extends OrderItemBuilder {
        private OrderClientDTOEnums.FeeItemFeeTypeEnum feeType;
        private String billingCode;
        private String displayName;
        private AmountBuilder priceAmountBuilder;
        private Boolean waived;
        private Boolean recurring;

        public FeeItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.FEE_ITEM);
        }

        /**
         * type of fee
         */
        public FeeItemBuilder withFeeType(OrderClientDTOEnums.FeeItemFeeTypeEnum feeType) {
            this.feeType = feeType;
            return this;
        }

        /**
         * Billing code
         */
        public FeeItemBuilder withBillingCode(String billingCode) {
            this.billingCode = billingCode;
            return this;
        }

        /**
         * Name of the fee
         */
        public FeeItemBuilder withDisplayName(String displayName) {
            this.displayName = displayName;
            return this;
        }

        public FeeItemBuilder withPriceAmountBuilder(AmountBuilder priceAmountBuilder) {
            this.priceAmountBuilder = priceAmountBuilder;
            return this;
        }

        /**
         * Information if the item has been left
         */
        public FeeItemBuilder withFeeType(Boolean waived) {
            this.waived = waived;
            return this;
        }

        public FeeItemBuilder withRecurring(Boolean recurring) {
            this.recurring = recurring;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.FeeItem result = new OrderClientDTO.FeeItem();
            setProperties(result);

            result.feeType = this.feeType;
            result.billingCode = this.billingCode;
            result.displayName = this.displayName;
            result.recurring = this.recurring;

            if (this.priceAmountBuilder != null) {
                result.price = this.priceAmountBuilder.build();
            }

            result.waived = this.waived;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * HardwarePaymentItemBuilder used to build OrderClientDTO.HardwarePaymentItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class HardwarePaymentItemBuilder extends OrderItemBuilder {
        public OrderClientDTOEnums.PaymentType paymentType;
        //id of purchase in PaymentAPI
        public String purchaseId;
        public PaymentAmountBuilder totalPaymentAmountBuilder;
        public PaymentAmountBuilder upfrontPaymentAmountBuilder;
        public DownPaymentPlanBuilder downPaymentPlanBuilder;

        public HardwarePaymentItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.HARDWARE_PAYMENT_ITEM);
        }

        public HardwarePaymentItemBuilder withPaymentType(OrderClientDTOEnums.PaymentType paymentType) {
            this.paymentType = paymentType;
            return this;
        }

        /**
         * id of purchase in PaymentAPI
         */
        public HardwarePaymentItemBuilder withPurchaseId(String purchaseId) {
            this.purchaseId = purchaseId;
            return this;
        }

        public HardwarePaymentItemBuilder withTotalPaymentAmountBuilder(
            PaymentAmountBuilder totalPaymentAmountBuilder
        ) {
            this.totalPaymentAmountBuilder = totalPaymentAmountBuilder;
            return this;
        }

        public HardwarePaymentItemBuilder withUpfrontPaymentAmountBuilder(
            PaymentAmountBuilder upfrontPaymentAmountBuilder
        ) {
            this.upfrontPaymentAmountBuilder = upfrontPaymentAmountBuilder;
            return this;
        }

        public HardwarePaymentItemBuilder withDownPaymentPlanBuilder(DownPaymentPlanBuilder downPaymentPlanBuilder) {
            this.downPaymentPlanBuilder = downPaymentPlanBuilder;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.HardwarePaymentItem result = new OrderClientDTO.HardwarePaymentItem();

            setProperties(result);

            result.paymentType = this.paymentType;
            result.purchaseId = this.purchaseId;

            if (this.totalPaymentAmountBuilder != null) {
                result.totalPayment = this.totalPaymentAmountBuilder.build();
            }

            if (this.upfrontPaymentAmountBuilder != null) {
                result.upfrontPayment = this.upfrontPaymentAmountBuilder.build();
            }

            if (this.downPaymentPlanBuilder != null) {
                result.downPaymentPlan = this.downPaymentPlanBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * HardwareSwapItemBuilder used to build OrderClientDTO.HardwareSwapItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class HardwareSwapItemBuilder extends OrderItemBuilder {
        private String shippingStatus;
        private String oldSerialNumber;

        public HardwareSwapItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.HARDWARE_SWAP_ITEM);
        }

        /**
         * Status of hardware shipping
         */
        public HardwareSwapItemBuilder withShippingStatus(String shippingStatus) {
            this.shippingStatus = shippingStatus;
            return this;
        }

        /**
         * Serial number of old hardware to swap
         */
        public HardwareSwapItemBuilder withOldSerialNumber(String oldSerialNumber) {
            this.oldSerialNumber = oldSerialNumber;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.HardwareSwapItem result = new OrderClientDTO.HardwareSwapItem();

            setProperties(result);

            result.shippingStatus = this.shippingStatus;
            result.oldSerialNumber = this.oldSerialNumber;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * CallForwardingItemBuilder used to build OrderClientDTO.CallForwardingItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class CallForwardingItemBuilder extends OrderItemBuilder {
        private ForwardingSettingBuilder allForwardingSettingBuilder;
        private ForwardingSettingBuilder inCallForwardingSettingBuilder;
        private ForwardingSettingBuilder noContactForwardingSettingBuilder;
        private NoAnswerForwardingSettingBuilder noAnswerForwardingSettingBuilder;

        public CallForwardingItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.CALL_FORWARDING_ITEM);
        }

        public CallForwardingItemBuilder withAllForwardingSettingBuilder(
            ForwardingSettingBuilder allForwardingSettingBuilder
        ) {
            this.allForwardingSettingBuilder = allForwardingSettingBuilder;
            return this;
        }

        public CallForwardingItemBuilder withInCallForwardingSettingBuilder(
            ForwardingSettingBuilder inCallForwardingSettingBuilder
        ) {
            this.inCallForwardingSettingBuilder = inCallForwardingSettingBuilder;
            return this;
        }

        public CallForwardingItemBuilder withNoContactForwardingSettingBuilder(
            ForwardingSettingBuilder noContactForwardingSettingBuilder
        ) {
            this.noContactForwardingSettingBuilder = noContactForwardingSettingBuilder;
            return this;
        }

        public CallForwardingItemBuilder withNoAnswerForwardingSettingBuilder(
            NoAnswerForwardingSettingBuilder noAnswerForwardingSettingBuilder
        ) {
            this.noAnswerForwardingSettingBuilder = noAnswerForwardingSettingBuilder;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.CallForwardingItem result = new OrderClientDTO.CallForwardingItem();

            setProperties(result);

            if (this.allForwardingSettingBuilder != null) {
                result.all = this.allForwardingSettingBuilder.build();
            }

            if (this.inCallForwardingSettingBuilder != null) {
                result.inCall = this.inCallForwardingSettingBuilder.build();
            }

            if (this.noContactForwardingSettingBuilder != null) {
                result.noContact = this.noContactForwardingSettingBuilder.build();
            }

            if (this.noAnswerForwardingSettingBuilder != null) {
                result.noAnswer = this.noAnswerForwardingSettingBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * CallWaitItemBuilder used to build OrderClientDTO.CallWaitItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class CallWaitItemBuilder extends OrderItemBuilder {
        private Boolean enabled;

        public CallWaitItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.CALL_WAIT_ITEM);
        }

        public CallWaitItemBuilder withEnabled(Boolean enabled) {
            this.enabled = enabled;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.CallWaitItem result = new OrderClientDTO.CallWaitItem();

            setProperties(result);

            result.enabled = this.enabled;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * ChargeItemBuilder used to build OrderClientDTO.ChargeItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class ChargeItemBuilder extends OrderItemBuilder {
        private String chargeCode;
        private AmountBuilder priceAmountBuilder;
        private String description;

        public ChargeItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.CHARGE_ITEM);
        }

        /**
         * Charge code
         */
        public ChargeItemBuilder withChargeCode(String chargeCode) {
            this.chargeCode = chargeCode;
            return this;
        }

        /**
         * Charge description
         */
        public ChargeItemBuilder withDescription(String description) {
            this.description = description;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.ChargeItem result = new OrderClientDTO.ChargeItem();

            setProperties(result);

            result.chargeCode = this.chargeCode;
            result.description = this.description;

            if (this.priceAmountBuilder != null) {
                result.price = priceAmountBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * ConsentItemBuilder used to build OrderClientDTO.ConsentItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class ConsentItemBuilder extends OrderItemBuilder {
        private String consentId;
        private Integer version;
        private String state;

        public ConsentItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.CONSENT_ITEM);
        }

        /**
         * consent identifier
         */
        public ConsentItemBuilder withConsentId(String consentId) {
            this.consentId = consentId;
            return this;
        }

        public ConsentItemBuilder withVersion(Integer version) {
            this.version = version;
            return this;
        }

        /**
         * Whether the consent is 'given', 'unconfirmed' or 'declined'.
         */
        public ConsentItemBuilder withState(String state) {
            this.state = state;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.ConsentItem result = new OrderClientDTO.ConsentItem();

            setProperties(result);

            result.consentId = this.consentId;
            result.version = this.version;
            result.state = this.state;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * AccountItemBuilder used to build OrderClientDTO.AccountItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class AccountItemBuilder extends OrderItemBuilder {
        private String billingAccountNumber;
        private PartyRoleBuilder legalPartyBuilder;
        private PartyRoleBuilder billingPartyBuilder;
        private OrderClientDTOEnums.AccountItemBillingCycleEnum billingCycle;
        private OrderClientDTOEnums.AccountItemInvoiceTypeEnum invoiceType;
        private Integer delayOfPayment;
        private OrderClientDTOEnums.PaymentMethod paymentMethod;
        private BankBuilder bankBuilder;
        private String ean;
        private String label;
        private String upTransferChargeCode;
        private OrderClientDTOEnums.AccountItemCategoryEnum category;
        private String productGroup;

        public AccountItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.ACCOUNT_ITEM);
        }

        /**
         * BAN assigned to newly created account during processing.
         */
        public AccountItemBuilder withBillingAccountNumber(String billingAccountNumber) {
            this.billingAccountNumber = billingAccountNumber;
            return this;
        }

        /**
         * interval of payments
         */
        public AccountItemBuilder withBillingCycle(OrderClientDTOEnums.AccountItemBillingCycleEnum billingCycle) {
            this.billingCycle = billingCycle;
            return this;
        }

        public AccountItemBuilder withInvoiceType(OrderClientDTOEnums.AccountItemInvoiceTypeEnum invoiceType) {
            this.invoiceType = invoiceType;
            return this;
        }

        /**
         * Delay of payment in days. 0 - 999 values applicable.
         */
        public AccountItemBuilder withDelayOfPayment(Integer delayOfPayment) {
            this.delayOfPayment = delayOfPayment;
            return this;
        }

        public AccountItemBuilder withBankBuilder(BankBuilder bankBuilder) {
            this.bankBuilder = bankBuilder;
            return this;
        }

        public AccountItemBuilder withPaymentMethod(OrderClientDTOEnums.PaymentMethod paymentMethod) {
            this.paymentMethod = paymentMethod;
            return this;
        }

        /**
         * In case of OIO invoice type the EAN number must be given.
         */
        public AccountItemBuilder withEan(String ean) {
            this.ean = ean;
            return this;
        }

        /**
         * Serves for naming the account.
         */
        public AccountItemBuilder withLabel(String label) {
            this.label = label;

            return this;
        }

        /**
         * Code to define what is paid by the root ban and what is paid by the child ban.
         */
        public AccountItemBuilder withUpTransferChargeCode(String upTransferChargeCode) {
            this.upTransferChargeCode = upTransferChargeCode;
            return this;
        }

        /**
         * Category of the account
         */
        public AccountItemBuilder withCategory(OrderClientDTOEnums.AccountItemCategoryEnum category) {
            this.category = category;
            return this;
        }

        /**
         * Currently home office or business internet, given in addInfo (cope order)
         */
        public AccountItemBuilder withProductGroup(String productGroup) {
            this.productGroup = productGroup;
            return this;
        }

        public AccountItemBuilder withLegalPartyBuilder(PartyRoleBuilder legalPartyBuilder) {
            this.legalPartyBuilder = legalPartyBuilder;
            return this;
        }

        public AccountItemBuilder withBillingPartyBuilder(PartyRoleBuilder billingPartyBuilder) {
            this.billingPartyBuilder = billingPartyBuilder;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.AccountItem result = new OrderClientDTO.AccountItem();

            setProperties(result);

            result.billingAccountNumber = this.billingAccountNumber;

            if (this.legalPartyBuilder != null) {
                result.legalParty = this.legalPartyBuilder.build();
            }

            if (this.billingPartyBuilder != null) {
                result.billingParty = this.billingPartyBuilder.build();
            }

            result.billingCycle = this.billingCycle;
            result.invoiceType = this.invoiceType;
            result.delayOfPayment = this.delayOfPayment;
            result.paymentMethod = this.paymentMethod;

            if (this.bankBuilder != null) {
                result.bank = this.bankbuilder.build();
            }

            result.ean = this.ean;
            result.label = this.label;
            result.upTransferChargeCode = this.upTransferChargeCode;
            result.category = this.category;
            result.productGroup = this.productGroup;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * AccountOwnerControlItemBuilder used to build OrderClientDTO.AccountOwnerControlItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class AccountOwnerControlItemBuilder extends OrderItemBuilder {
        public OrderClientDTOEnums.AccountControlOption nationalUsageAllowance;
        public OrderClientDTOEnums.AccountControlOption roamingCostControl;
        public OrderClientDTOEnums.AccountControlOption retailRoaming;
        public Boolean unlimited;
        public Integer costLimit;

        public AccountOwnerControlItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.ACCOUNT_OWNER_CONTROL_ITEM);
        }

        /**
         * NUA - Controls domestic TOP-UP purchase
         */
        public AccountOwnerControlItemBuilder withNationalUsageAllowance(
            OrderClientDTOEnums.AccountControlOption nationalUsageAllowance
        ) {
            this.nationalUsageAllowance = nationalUsageAllowance;
            return this;
        }

        /**
         * RCC - Controls limit settings for roaming
         */
        public AccountOwnerControlItemBuilder withRoamingCostControl(
            OrderClientDTOEnums.AccountControlOption roamingCostControl
        ) {
            this.roamingCostControl = roamingCostControl;
            return this;
        }

        /**
         * TSRR - Controls roaming TOP-UP purchase
         */
        public AccountOwnerControlItemBuilder withRetailRoaming(
            OrderClientDTOEnums.AccountControlOption retailRoaming
        ) {
            this.retailRoaming = retailRoaming;
            return this;
        }

        /**
         * The cost limit in DKK.
         */
        public AccountOwnerControlItemBuilder withCostLimit(Integer costLimit) {
            this.costLimit = costLimit;
            return this;
        }

        /**
         * Indicates whether the costLimit is actually unlimited.
         */
        public AccountOwnerControlItemBuilder withState(Boolean unlimited) {
            this.unlimited = unlimited;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.AccountOwnerControlItem result = new OrderClientDTO.AccountOwnerControlItem();

            setProperties(result);

            result.nationalUsageAllowance = this.nationalUsageAllowance;
            result.roamingCostControl = this.roamingCostControl;
            result.retailRoaming = this.retailRoaming;
            result.unlimited = this.unlimited;
            result.costLimit = this.costLimit;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * AdditionalProductItemBuilder used to build OrderClientDTO.AdditionalProductItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class AdditionalProductItemBuilder extends OrderItemBuilder {
        private String productCode;
        private String productName;
        private OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum productCategory;
        private List<String> productCategories;
        private AmountBuilder recurringPriceAmountBuilder;
        private String discountCode;
        private AmountBuilder unitPriceAmountBuilder;
        private Integer quantity;
        private SimDetailsBuilder simDetailsBuilder;
        private HardwareDetailsBuilder hardwareDetailsBuilder;
        private ShippingDetailsBuilder shippingDetailsBuilder;
        private ReturnDetailsBuilder returnDetailsBuilder;

        public AdditionalProductItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM);
        }

        public AdditionalProductItemBuilder withProductCode(String productCode) {
            this.productCode = productCode;
            return this;
        }

        public AdditionalProductItemBuilder withProductName(String productName) {
            this.productName = productName;
            return this;
        }

        /**
         * The 'family' or group of additionalproducts. Can be null!
         */
        public AdditionalProductItemBuilder withProductCategory(
            OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum productCategory
        ) {
            this.productCategory = productCategory;
            return this;
        }

        /**
         * List of categories from product catalog
         */
        public AdditionalProductItemBuilder withProductCategories(List<String> productCategories) {
            this.productCategories = productCategories;
            return this;
        }

        public AdditionalProductItemBuilder withRecurringPriceAmountBuilder(AmountBuilder recurringPriceAmountBuilder) {
            this.recurringPriceAmountBuilder = recurringPriceAmountBuilder;
            return this;
        }

        public AdditionalProductItemBuilder withDiscountCode(String discountCode) {
            this.discountCode = discountCode;
            return this;
        }

        public AdditionalProductItemBuilder withUnitPriceAmountBuilder(AmountBuilder unitPriceAmountBuilder) {
            this.unitPriceAmountBuilder = unitPriceAmountBuilder;
            return this;
        }

        /**
         * quantity of ordered items.
         */
        public AdditionalProductItemBuilder withQuantity(Integer quantity) {
            this.quantity = quantity;
            return this;
        }

        public AdditionalProductItemBuilder withSimDetailsBuilder(SimDetailsBuilder simDetailsBuilder) {
            this.simDetailsBuilder = simDetailsBuilder;
            return this;
        }

        public AdditionalProductItemBuilder withHardwareDetailsBuilder(HardwareDetailsBuilder hardwareDetailsBuilder) {
            this.hardwareDetailsBuilder = hardwareDetailsBuilder;
            return this;
        }

        public AdditionalProductItemBuilder withShippingDetailsBuilder(ShippingDetailsBuilder shippingDetailsBuilder) {
            this.shippingDetailsBuilder = shippingDetailsBuilder;
            return this;
        }

        public AdditionalProductItemBuilder withReturnDetailsBuilder(ReturnDetailsBuilder returnDetailsBuilder) {
            this.returnDetailsBuilder = returnDetailsBuilder;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.AdditionalProductItem result = new OrderClientDTO.AdditionalProductItem();

            setProperties(result);

            result.productCode = this.productCode;
            result.productName = this.productName;
            result.productCategory = this.productCategory;
            result.productCategories = this.productCategories;

            if (this.recurringPriceAmountBuilder != null) {
                result.recurringPrice = this.recurringPriceAmountBuilder.build();
            }

            result.discountCode = this.discountCode;

            if (this.unitPriceAmountBuilder != null) {
                result.unitPrice = unitPriceAmountBuilder.build();
            }

            result.quantity = this.quantity;

            if (this.simDetailsBuilder != null) {
                result.simDetails = this.simDetailsBuilder.build();
            }

            if (this.hardwareDetailsBuilder != null) {
                result.hardwareDetails = this.hardwareDetailsBuilder.build();
            }

            if (this.shippingDetailsBuilder != null) {
                result.shippingDetails = this.shippingDetailsBuilder.build();
            }

            if (this.returnDetailsBuilder != null) {
                result.returnDetails = this.returnDetailsBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * PaymentMethodChangeItemBuilder used to build OrderClientDTO.PaymentMethodChangeItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class PaymentMethodChangeItemBuilder extends OrderItemBuilder {
        private PaymentMethodDetailBuilder paymentMethodDetailBuilder;
        private String reasonCode;
        private String memoText;

        public PaymentMethodChangeItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.PAYMENT_METHOD_CHANGE_ITEM);
        }

        public PaymentMethodChangeItemBuilder withPaymentMethodDetailBuilder(
            PaymentMethodDetailBuilder paymentMethodDetailBuilder
        ) {
            this.paymentMethodDetailBuilder = paymentMethodDetailBuilder;
            return this;
        }

        public PaymentMethodChangeItemBuilder withReasonCode(String reasonCode) {
            this.reasonCode = reasonCode;
            return this;
        }

        public PaymentMethodChangeItemBuilder withMemoText(String memoText) {
            this.memoText = memoText;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.PaymentMethodChangeItem result = new OrderClientDTO.PaymentMethodChangeItem();
            setProperties(result);

            if (this.paymentMethodDetailBuilder != null) {
                result.paymentMethodDetail = this.paymentMethodDetailBuilder.build();
            }

            result.reasonCode = this.reasonCode;
            result.memoText = this.memoText;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * PortingDetailsItemBuilder used to build OrderClientDTO.PortingDetailsItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class PortingDetailsItemBuilder extends OrderItemBuilder {
        private String networkOperatorId;
        private String donorSimNumber;
        private String poaDocumentUrl;
        private String poaDocumentId;
        private Boolean digitalPoaAllowed;
        private Boolean powerOfAttorneyManualHandling;
        private Date earliestPortingDate;
        private Boolean portAfterCommitment;
        private Date actualPortingDate;
        private ConsentBuilder donorConsentBuilder;
        private ConsentBuilder portingProcessConditionsConsentBuilder;

        public PortingDetailsItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.PORTING_DETAILS_ITEM);
        }
        /**
         * Id of a network operator where the number is currently registered. Also known as number owner.
         */
        public PortingDetailsItemBuilder withNetworkOperatorId(String networkOperatorId) {
            this.networkOperatorId = networkOperatorId;
            return this;
        }

        public PortingDetailsItemBuilder withDonorSimNumber(String donorSimNumber) {
            this.donorSimNumber = donorSimNumber;
            return this;
        }
        /**
         * Location of document within Norlys domain.
         */
        public PortingDetailsItemBuilder withPoaDocumentUrl(String poaDocumentUrl) {
            this.poaDocumentUrl = poaDocumentUrl;
            return this;
        }
        /**
         * Indicates whether electronic Power of Attorney can be used.
         */
        public PortingDetailsItemBuilder withDigitalPoaAllowed(Boolean digitalPoaAllowed) {
            this.digitalPoaAllowed = digitalPoaAllowed;
            return this;
        }
        /**
         * Indicates whether the POA shall be signed via manual flow.
         */
        public PortingDetailsItemBuilder withPowerOfAttorneyManualHandling(Boolean powerOfAttorneyManualHandling) {
            this.powerOfAttorneyManualHandling = powerOfAttorneyManualHandling;
            return this;
        }
        /**
         * date in format YYYY-MM-DD (according to ISO 8601).
         */
        public PortingDetailsItemBuilder withEarliestPortingDate(Date earliestPortingDate) {
            this.earliestPortingDate = earliestPortingDate;
            return this;
        }
        /**
         * true if customer wishes to be ported in after end of commitment at the current operator. Use instead of earliestPortingDate.
         */
        public PortingDetailsItemBuilder withPortAfterCommitment(Boolean portAfterCommitment) {
            this.portAfterCommitment = portAfterCommitment;
            return this;
        }
        /**
         * The date at which the porting is planned. Date in format YYYY-MM-DD (according to ISO 8601).
         */
        public PortingDetailsItemBuilder withActualPortingDate(Date actualPortingDate) {
            this.actualPortingDate = actualPortingDate;
            return this;
        }

        public PortingDetailsItemBuilder withDonorConsentBuilder(ConsentBuilder donorConsentBuilder) {
            this.donorConsentBuilder = donorConsentBuilder;
            return this;
        }

        public PortingDetailsItemBuilder withPortingProcessConditionsConsentBuilder(
            ConsentBuilder portingProcessConditionsConsentBuilder
        ) {
            this.portingProcessConditionsConsentBuilder = portingProcessConditionsConsentBuilder;
            return this;
        }

        public PortingDetailsItemBuilder withPoaDocumentId(String poaDocumentId) {
            this.poaDocumentId = poaDocumentId;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.PortingDetailsItem result = new OrderClientDTO.PortingDetailsItem();
            setProperties(result);

            result.networkOperatorId = this.networkOperatorId;
            result.donorSimNumber = this.donorSimNumber;
            result.poaDocumentUrl = this.poaDocumentUrl;
            result.digitalPoaAllowed = this.digitalPoaAllowed;
            result.powerOfAttorneyManualHandling = this.powerOfAttorneyManualHandling;
            result.earliestPortingDate = this.earliestPortingDate;
            result.portAfterCommitment = this.portAfterCommitment;
            result.actualPortingDate = this.actualPortingDate;
            result.poaDocumentId = this.poaDocumentId;

            if (this.donorConsentBuilder != null) {
                result.donorConsent = this.donorConsentBuilder.build();
            }

            if (this.portingProcessConditionsConsentBuilder != null) {
                result.portingProcessConditionsConsent = this.portingProcessConditionsConsentBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * ReactivationItemBuilder used to build OrderClientDTO.ReactivationItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class ReactivationItemBuilder extends OrderItemBuilder {
        private String reason;

        public ReactivationItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.REACTIVATION_ITEM);
        }

        /**
         * Reason of reactivation.
         */
        public ReactivationItemBuilder withReason(String reason) {
            this.reason = reason;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.ReactivationItem result = new OrderClientDTO.ReactivationItem();
            setProperties(result);
            result.reason = this.reason;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * RegretItemBuilder used to build OrderClientDTO.RegretItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class RegretItemBuilder extends OrderItemBuilder {
        //Effective date in format YYYY-MM-DD (according to ISO 8601).
        private Date effectiveDate;

        public RegretItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.REGRET_ITEM);
        }

        /**
         * Effective date in format YYYY-MM-DD (according to ISO 8601).
         */
        public RegretItemBuilder withEffectiveDate(Date effectiveDate) {
            this.effectiveDate = effectiveDate;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.RegretItem result = new OrderClientDTO.RegretItem();
            setProperties(result);

            result.effectiveDate = this.effectiveDate;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * SubscriptionItemBuilder used to build OrderClientDTO.SubscriptionItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class SubscriptionItemBuilder extends OrderItemBuilder {
        private FixedNetDetailsBuilder fixedNetDetailsBuilder;
        private TelephoneNumberBuilder telephoneNumberBuilder;
        private OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum telephoneNumberCategory;
        private OrderClientDTOEnums.SubscriptionItemProductTypeEnum productType;
        private OrderClientDTOEnums.SubscriptionItemOfferingChangeTypeEnum offeringChangeType;
        private OfferingBuilder newOfferingBuilder;
        private OfferingBuilder currentOfferingBuilder;
        private String productCategory;
        private Boolean isTransfer;
        private SubscriptionUserBuilder subscriptionUserBuilder;
        private OrderClientDTOEnums.SubscriptionItemPublishLevelEnum publishLevel;
        private AmountBuilder recurringPriceAmountBuilder;
        private Date preferredActivationDate;
        private Date realActivationDate;
        private Boolean productDeliveryAsap;
        private Boolean secret;
        private String label;
        private TimePeriodBuilder terminationPeriodBuilder;
        private Date effectiveMoveDate;
        private OrderClientDTOEnums.SubscriptionItemBillingSystemEnum billingSystem;

        public SubscriptionItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM);
        }

        public SubscriptionItemBuilder withFixedNetDetailsBuilder(FixedNetDetailsBuilder fixedNetDetailsBuilder) {
            this.fixedNetDetailsBuilder = fixedNetDetailsBuilder;
            return this;
        }

        /**
         * Category of telephone number. For mobile it can be for instance SILVER.
         */
        public SubscriptionItemBuilder withTelephoneNumberCategory(
            OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum telephoneNumberCategory
        ) {
            this.telephoneNumberCategory = telephoneNumberCategory;
            return this;
        }

        /**
         * Defines what directories the subscription is published in.
         */
        public SubscriptionItemBuilder withPublishLevel(
            OrderClientDTOEnums.SubscriptionItemPublishLevelEnum publishLevel
        ) {
            this.publishLevel = publishLevel;
            return this;
        }

        public SubscriptionItemBuilder withTelephoneNumberBuilder(TelephoneNumberBuilder telephoneNumberBuilder) {
            this.telephoneNumberBuilder = telephoneNumberBuilder;
            return this;
        }

        /**
         * Product type.
         */
        public SubscriptionItemBuilder withProductType(
            OrderClientDTOEnums.SubscriptionItemProductTypeEnum productType
        ) {
            this.productType = productType;
            return this;
        }

        /**
         * Type of change on the offering.
         */
        public SubscriptionItemBuilder withOfferingChangeTypeEnum(
            OrderClientDTOEnums.SubscriptionItemOfferingChangeTypeEnum offeringChangeType
        ) {
            this.offeringChangeType = offeringChangeType;
            return this;
        }

        public SubscriptionItemBuilder withNewOfferingBuilder(OfferingBuilder newOfferingBuilder) {
            this.newOfferingBuilder = newOfferingBuilder;
            return this;
        }

        public SubscriptionItemBuilder withCurrentOfferingBuilder(OfferingBuilder currentOfferingBuilder) {
            this.currentOfferingBuilder = currentOfferingBuilder;
            return this;
        }

        /**
         * Product category.
         */
        public SubscriptionItemBuilder withProductCategory(String productCategory) {
            this.productCategory = productCategory;
            return this;
        }

        /**
         * If subscription is part of a transfer.
         */
        public SubscriptionItemBuilder withTransfer(Boolean isTransfer) {
            this.isTransfer = isTransfer;
            return this;
        }

        public SubscriptionItemBuilder withRecurringPriceBuilder(AmountBuilder recurringPriceAmountBuilder) {
            this.recurringPriceAmountBuilder = recurringPriceAmountBuilder;
            return this;
        }

        /**
         * Defines the billing system where the subscription shall be billed
         */
        public SubscriptionItemBuilder withBillingSystem(
            OrderClientDTOEnums.SubscriptionItemBillingSystemEnum billingSystem
        ) {
            this.billingSystem = billingSystem;
            return this;
        }

        /**
         * Preferred date of activation. Date in format YYYY-MM-DD (according to ISO 8601).
         */
        public SubscriptionItemBuilder withPreferredActivationDate(Date preferredActivationDate) {
            this.preferredActivationDate = preferredActivationDate;
            return this;
        }

        /**
         * Real date of activation. Date in format YYYY-MM-DD (according to ISO 8601).
         */
        public SubscriptionItemBuilder withRealActivationDate(Date realActivationDate) {
            this.realActivationDate = realActivationDate;
            return this;
        }

        /**
         * Date when the subscription is moved. Date in format YYYY-MM-DD (according to ISO 8601).
         */
        public SubscriptionItemBuilder withEffectiveMoveDate(Date effectiveMoveDate) {
            this.effectiveMoveDate = effectiveMoveDate;
            return this;
        }

        /**
         * Name of subscription given by customer.
         */
        public SubscriptionItemBuilder withLabel(String label) {
            this.label = label;
            return this;
        }

        /**
         * Indicates whether the number shall be secret.
         */
        public SubscriptionItemBuilder withSecret(Boolean secret) {
            this.secret = secret;
            return this;
        }

        /**
         * Indicates if the product shall be delivered as soon as possible
         */
        public SubscriptionItemBuilder withProductDeliveryAsap(Boolean productDeliveryAsap) {
            this.productDeliveryAsap = productDeliveryAsap;
            return this;
        }

        public SubscriptionItemBuilder withSubscriptionUserBuilder(SubscriptionUserBuilder subscriptionUserBuilder) {
            this.subscriptionUserBuilder = subscriptionUserBuilder;
            return this;
        }

        public SubscriptionItemBuilder withTerminationPeriodBuilder(TimePeriodBuilder terminationPeriodBuilder) {
            this.terminationPeriodBuilder = terminationPeriodBuilder;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.subscriptionItem result = new OrderClientDTO.subscriptionItem();

            setProperties(result);

            if (this.fixedNetDetailsBuilder != null) {
                result.fixedNetDetails = fixedNetDetailsBuilder.build();
            }

            if (this.telephoneNumberBuilder != null) {
                result.telephoneNumber = this.telephoneNumberBuilder.build();
            }

            result.telephoneNumberCategory = this.telephoneNumberCategory;
            result.productType = this.productType;
            result.offeringChangeType = this.offeringChangeType;

            if (this.newOfferingBuilder != null) {
                result.newOffering = this.newOfferingBuilder.build();
            }

            if (this.currentOfferingBuilder != null) {
                result.currentOffering = currentOfferingBuilder.build();
            }

            result.productCategory = this.productCategory;
            result.isTransfer = this.isTransfer;

            if (this.subscriptionUserBuilder != null) {
                result.subscriptionUser = this.subscriptionUserBuilder.build();
            }

            result.publishLevel = this.publishLevel;

            if (this.recurringPriceAmountBuilder != null) {
                result.recurringPrice = this.recurringPriceAmountBuilder.build();
            }

            result.preferredActivationDate = this.preferredActivationDate;
            result.realActivationDate = this.realActivationDate;
            result.productDeliveryAsap = this.productDeliveryAsap;
            result.secret = this.secret;
            result.label = this.label;

            if (this.terminationPeriodBuilder != null) {
                result.terminationPeriod = this.terminationPeriodBuilder.build();
            }

            result.effectiveMoveDate = this.effectiveMoveDate;
            result.billingSystem = this.billingSystem;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * SuspensionItemBuilder used to build OrderClientDTO.SuspensionItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class SuspensionItemBuilder extends OrderItemBuilder {
        private String reason;

        public SuspensionItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.SUSPENSION_ITEM);
        }

        /**
         * Reason of suspension.
         */
        public SuspensionItemBuilder withReason(String reason) {
            this.reason = reason;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.SuspensionItem result = new OrderClientDTO.SuspensionItem();

            setProperties(result);
            result.reason = this.reason;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * TerminationItemBuilder used to build OrderClientDTO.TerminationItem
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class TerminationItemBuilder extends OrderItemBuilder {
        private Date effectiveDate;
        private OrderClientDTOEnums.TerminationItemReasonCodeEnum reasonCode;
        private Boolean retention;
        private Boolean waiveTerminationFees;
        private Boolean shouldTransferToDifferentPool;
        private Boolean shouldReReserve;

        public TerminationItemBuilder() {
            withType(OrderClientDTOEnums.OrderItemTypeEnum.TERMINATION_ITEM);
        }

        /**
         * Effective date in format YYYY-MM-DD (according to ISO 8601).
         */
        public TerminationItemBuilder withEffectiveDate(Date effectiveDate) {
            this.effectiveDate = effectiveDate;
            return this;
        }

        /**
         * Reason code of termination
         */
        public TerminationItemBuilder withReasonCode(OrderClientDTOEnums.TerminationItemReasonCodeEnum reasonCode) {
            this.reasonCode = reasonCode;
            return this;
        }

        /**
         * Flag for subscription retention
         */
        public TerminationItemBuilder withRetention(Boolean retention) {
            this.retention = retention;
            return this;
        }

        /**
         * Flag indicating if fees connected to termination shall be waived.
         */
        public TerminationItemBuilder withWaiveTerminationFees(Boolean waiveTerminationFees) {
            this.waiveTerminationFees = waiveTerminationFees;
            return this;
        }

        /**
         * Flag indicating if the number should be transferred to a different pool after termination
         */
        public TerminationItemBuilder withShouldTransferToDifferentPool(Boolean shouldTransferToDifferentPool) {
            this.shouldTransferToDifferentPool = shouldTransferToDifferentPool;
            return this;
        }

        /**
         * Flag indicating if the number should be re-reserved after termination
         */
        public TerminationItemBuilder withShouldReReserve(Boolean shouldReReserve) {
            this.shouldReReserve = shouldReReserve;
            return this;
        }

        public override OrderClientDTO.OrderItem build() {
            OrderClientDTO.TerminationItem result = new OrderClientDTO.TerminationItem();
            setProperties(result);

            result.effectiveDate = this.effectiveDate;
            result.reasonCode = this.reasonCode;
            result.retention = this.retention;
            result.waiveTerminationFees = this.waiveTerminationFees;
            result.shouldTransferToDifferentPool = this.shouldTransferToDifferentPool;
            result.shouldReReserve = this.shouldReReserve;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderPartBuilder used to build OrderClientDTO.OrderPart
     *
     * Order Part - container for LineItems belonging together
     * 
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrderPartBuilder {
        //TODO BUILDER FOR List<ValidationError>
        public List<OrderClientDTO.ValidationError> validationErrors;
        public List<OrderClientDTOEnums.OrderPartChangeTypesEnum> changeTypes;
        private OrderPartReferenceListBuilder orderPartReferenceListBuilder;
        private OrderClientDTOEnums.OrderPartTypeEnum type;
        private OrderClientDTOEnums.OrderPartActivityEnum activity;
        private OrderClientDTOEnums.ProcessingStatus processingStatus;
        private String processingStatusDetail;
        private OrderItemListBuilder orderItemListBuilder;
        private OrderPartListBuilder orderPartListBuilder;
        private Integer id;
        private String channelOrderPartId;
        private String splitOrderId;
        private String taskUrl;
        private AmountBuilder partTotalAmountBuilder;
        private AmountBuilder hardwareTotalAmountBuilder;
        private PaymentAmountBuilder hardwareTotalUpfrontPaymentAmountBuilder;
        private AmountBuilder productTotalAmountBuilder;
        private PaymentAmountBuilder productTotalUpfrontPaymentAmountBuilder;
        private AmountBuilder servicesRecurringTotalAmountBuilder;
        private PaymentAmountBuilder hardwareRecurringTotalPaymentAmountBuilder;

        /**
         * Used to refer to existing entities like account or subscription. 
         * When ordering new additionalProduct on subscription, place subscription identifier here.
         */
        public OrderPartBuilder withOrderPartReferenceListBuilder(
            OrderPartReferenceListBuilder orderPartReferenceListBuilder
        ) {
            this.orderPartReferenceListBuilder = orderPartReferenceListBuilder;
            return this;
        }

        public OrderPartBuilder withType(OrderClientDTOEnums.OrderPartTypeEnum type) {
            this.type = type;
            return this;
        }

        public OrderPartBuilder withActivity(OrderClientDTOEnums.OrderPartActivityEnum activity) {
            this.activity = activity;
            return this;
        }

        /**
         * a Set of the types of changes contained in the orderpart
         */
        public OrderPartBuilder withChangeType(OrderClientDTOEnums.OrderPartChangeTypesEnum changeType) {
            if (this.changeTypes == null) {
                this.changeTypes = new List<OrderClientDTOEnums.OrderPartChangeTypesEnum>();
            }
            this.changeTypes.add(changeType);
            return this;
        }

        public OrderPartBuilder withProcessingStatus(OrderClientDTOEnums.ProcessingStatus processingStatus) {
            this.processingStatus = processingStatus;
            return this;
        }

        public OrderPartBuilder withProcessingStatusDetail(String processingStatusDetail) {
            this.processingStatusDetail = processingStatusDetail;
            return this;
        }

        public OrderPartBuilder withOrderItemListBuilder(OrderItemListBuilder orderItemListBuilder) {
            this.orderItemListBuilder = orderItemListBuilder;
            return this;
        }

        public OrderPartBuilder withOrderPartListBuilder(OrderPartListBuilder orderPartListBuilder) {
            this.orderPartListBuilder = orderPartListBuilder;
            return this;
        }

        /**
         * Identifies the element in collection uniquely in whole order. 
         * Is assigned by OrderAPI.
         */
        public OrderPartBuilder withId(Integer id) {
            this.id = id;
            return this;
        }

        /**
         * Intended to identify the element uniquely in whole order. 
         * Can be assigned by external services.
         */
        public OrderPartBuilder withChannelOrderPartId(String channelOrderPartId) {
            this.channelOrderPartId = channelOrderPartId;
            return this;
        }

        /**
         * Intended to identify the element uniquely in whole order. Is assigned by OrderAPI.
         */
        public OrderPartBuilder withSplitOrderId(String splitOrderId) {
            this.splitOrderId = splitOrderId;
            return this;
        }

        /**
         * Link to task for manual handling of the orderPart.
         */
        public OrderPartBuilder withTaskUrl(String taskUrl) {
            this.taskUrl = taskUrl;
            return this;
        }
        /**
         * Sum of all one time fees, charges, and additional product one time price (like hardware price).
         */
        public OrderPartBuilder withPartTotalAmountBuilder(AmountBuilder partTotalAmountBuilder) {
            this.partTotalAmountBuilder = partTotalAmountBuilder;
            return this;
        }
        /**
         * Sum of hardware amount.
         */
        public OrderPartBuilder withHardwareTotalAmountBuilder(AmountBuilder hardwareTotalAmountBuilder) {
            this.hardwareTotalAmountBuilder = hardwareTotalAmountBuilder;
            return this;
        }
        /**
         * Sum of product amount.
         */
        public OrderPartBuilder withProductTotalAmountBuilder(AmountBuilder productTotalAmountBuilder) {
            this.productTotalAmountBuilder = productTotalAmountBuilder;
            return this;
        }
        /**
         * All services recurring prices.
         */
        private OrderPartBuilder withServicesRecurringTotalAmountBuilder(
            AmountBuilder servicesRecurringTotalAmountBuilder
        ) {
            this.servicesRecurringTotalAmountBuilder = servicesRecurringTotalAmountBuilder;
            return this;
        }
        /**
         * Sum of hardware upfront amount (to be paid immediately).
         */
        public OrderPartBuilder withHardwareTotalUpfrontPaymentAmountBuilder(
            PaymentAmountBuilder hardwareTotalUpfrontPaymentAmountBuilder
        ) {
            this.hardwareTotalUpfrontPaymentAmountBuilder = hardwareTotalUpfrontPaymentAmountBuilder;
            return this;
        }
        /**
         * Sum of product upfront amount (to be paid immediately).
         */
        public OrderPartBuilder withProductTotalUpfrontPaymentAmountBuilder(
            PaymentAmountBuilder productTotalUpfrontPaymentAmountBuilder
        ) {
            this.productTotalUpfrontPaymentAmountBuilder = productTotalUpfrontPaymentAmountBuilder;
            return this;
        }
        /**
         * All hardware installment recurring payments per month.
         */
        public OrderPartBuilder withJardwareRecurringTotalPaymentAmountBuilder(
            PaymentAmountBuilder hardwareRecurringTotalPaymentAmountBuilder
        ) {
            this.hardwareRecurringTotalPaymentAmountBuilder = hardwareRecurringTotalPaymentAmountBuilder;
            return this;
        }

        public OrderClientDTO.OrderPart build() {
            OrderClientDTO.OrderPart result = new OrderClientDTO.OrderPart();

            if (this.orderPartReferenceListBuilder != null) {
                result.references = this.orderPartReferenceListBuilder.build();
            }

            result.type = this.type;
            result.activity = this.activity;
            result.changeTypes = this.changeTypes;
            result.processingStatus = this.processingStatus;
            result.processingStatusDetail = this.processingStatusDetail;

            if (this.orderItemListBuilder != null) {
                result.orderItems = this.orderItemListBuilder.build();
            }

            if (this.orderPartListBuilder != null) {
                result.orderParts = this.orderPartListBuilder.build();
            }

            result.validationErrors = this.validationErrors;
            result.id = this.id;
            result.channelOrderPartId = this.channelOrderPartId;
            result.splitOrderId = this.splitOrderId;
            result.taskUrl = this.taskUrl;

            if (this.partTotalAmountBuilder != null) {
                result.partTotal = this.partTotalAmountBuilder.build();
            }

            if (this.hardwareTotalAmountBuilder != null) {
                result.hardwareTotal = this.hardwareTotalAmountBuilder.build();
            }

            if (this.hardwareTotalUpfrontPaymentAmountBuilder != null) {
                result.hardwareTotalUpfront = this.hardwareTotalUpfrontPaymentAmountBuilder.build();
            }

            if (this.productTotalAmountBuilder != null) {
                result.productTotal = this.productTotalAmountBuilder.build();
            }

            if (this.productTotalUpfrontPaymentAmountBuilder != null) {
                result.productTotalUpfront = this.productTotalUpfrontPaymentAmountBuilder.build();
            }

            if (this.servicesRecurringTotalAmountBuilder != null) {
                result.servicesRecurringTotal = this.servicesRecurringTotalAmountBuilder.build();
            }

            if (this.hardwareRecurringTotalPaymentAmountBuilder != null) {
                result.hardwareRecurringTotal = this.hardwareRecurringTotalPaymentAmountBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    public class OrderPartReferenceBuilder {
        private OrderClientDTOEnums.OrderPartReferenceTypeEnum type;
        private String value;

        public OrderPartReferenceBuilder withType(OrderClientDTOEnums.OrderPartReferenceTypeEnum type) {
            this.type = type;
            return this;
        }

        public OrderPartReferenceBuilder withValue(String value) {
            this.value = value;
            return this;
        }

        public OrderClientDTO.OrderPartReference build() {
            OrderClientDTO.OrderPartReference result = new OrderClientDTO.OrderPartReference();
            result.value = this.value;
            result.type = this.type;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderPatchRequestBuilder used to build OrderClientDTO.OrderPatchRequest
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrderPatchRequestBuilder {
        private OrderClientDTOEnums.OpEnum op;
        private String path;
        private Object value;
        private String from_x;

        /**
         * Operation to do
         */
        public OrderPatchRequestBuilder withOperation(OrderClientDTOEnums.OpEnum op) {
            this.op = op;
            return this;
        }

        public OrderPatchRequestBuilder withPath(String path) {
            this.path = path;
            return this;
        }

        public OrderPatchRequestBuilder withValue(Object value) {
            this.value = value;
            return this;
        }

        public OrderPatchRequestBuilder withFromValue(String from_x) {
            this.from_x = from_x;
            return this;
        }

        public OrderClientDTO.OrderPatchRequest build() {
            OrderClientDTO.OrderPatchRequest result = new OrderClientDTO.OrderPatchRequest();
            result.op = this.op;
            result.path = this.path;
            result.value = this.value;
            result.from_x = this.from_x;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    public class OrderSourceBuilder {
        private String ipAddress;
        private Decimal port;
        private Datetime captureTimeStamp;

        public OrderSourceBuilder withIpAddress(String value) {
            this.ipAddress = value;
            return this;
        }

        public OrderSourceBuilder withPort(Decimal value) {
            this.port = value;
            return this;
        }

        public OrderSourceBuilder withCaptureTimeStamp(Datetime value) {
            this.captureTimeStamp = value;
            return this;
        }

        public OrderClientDTO.OrderSource build() {
            OrderClientDTO.OrderSource result = new OrderClientDTO.OrderSource();
            result.ipAddress = this.ipAddress;
            result.port = this.port;
            result.captureTimeStamp = this.captureTimeStamp;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderV10Builder used to build OrderClientDTO.OrderV10
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrderV10Builder {
        private String id;
        private String orderId;
        private String parentOrderId;
        private String channelOrderReference;
        private String implementationCaseId;
        private String bpmOrderId;
        private String noosOrderId;
        private String mitIdVerificationToken;
        private String batchId;
        private OrderClientDTOEnums.Brand brand;
        private String channel;
        private OrderClientDTOEnums.OrderV10SegmentEnum segment;
        private DateTime createdDate;
        private DateTime completedDate;
        private String createdBy;
        private OrderClientDTOEnums.ProcessingStatus processingStatus;
        private String processingStatusDetail;
        private Boolean hasValidationErrors;
        private String taskUrl;
        private String confirmationUrl;
        private String documentsUrl;
        private String paymentId;
        private Integer contextId;
        private List<OrderClientDTO.ValidationError> validationErrors;
        private AmountBuilder orderTotalAmountBuilder;
        private AmountBuilder orderMinimumPriceAmountBuilder;
        private AmountBuilder hardwareTotalAmountBuilder;
        private AmountBuilder productTotalAmountBuilder;
        private AmountBuilder servicesRecurringTotalAmountBuilder;
        private PaymentAmountBuilder hardwareTotalUpfrontPaymentAmountBuilder;
        private PaymentAmountBuilder productTotalUpfrontPaymentAmountBuilder;
        private OrderPartListBuilder orderPartListBuilder;
        private CreditEvaluationDetailsBuilder creditEvaluationDetailsBuilder;
        private NotificationRecipientListBuilder notificationRecipientListBuilder;
        private HardwareDeliveryListBuilder hardwareDeliveryListBuilder;
        private DocumentListBuilder documentListBuilder;
        private PilPaymentBuilder pilPaymentBuilder;
        private OrderFlagsBuilder orderFlagsBuilder;
        private MarketingConsentBuilder marketingConsentBuilder;
        private OrderSourceBuilder orderSourceBuilder;
        private DealerBuilder dealerBuilder;
        private PartyRoleBuilder ordererPartyRoleBuilder;

        /**
         * Id from internal order database, is numeric value and starting from 10000.
         */
        public OrderV10Builder withId(String id) {
            this.id = id;
            return this;
        }
        /**
         * Can be BPM orderID like 'BPMT0153200309110744' or just Order Id from OrderManager '99089093'.
         */
        public OrderV10Builder withOrderId(String orderId) {
            this.orderId = orderId;
            return this;
        }
        /**
         * Parent order id if this order is a return of another order.
         */
        public OrderV10Builder withParentOrderId(String parentOrderId) {
            this.parentOrderId = parentOrderId;
            return this;
        }
        /**
         * Order identifier provided by the channel.
         */
        public OrderV10Builder withChannelOrderReference(String channelOrderReference) {
            this.channelOrderReference = channelOrderReference;
            return this;
        }
        /**
         * Implementation case Id coming from SalesForce channel.
         */
        public OrderV10Builder withImplementationCaseId(String implementationCaseId) {
            this.implementationCaseId = implementationCaseId;
            return this;
        }
        /**
         * Bpm order id returned from CoPE services.
         */
        public OrderV10Builder withBpmOrderId(String bpmOrderId) {
            this.bpmOrderId = bpmOrderId;
            return this;
        }
        /**
         * NOOS order id.
         */
        public OrderV10Builder withNoosOrderId(String noosOrderId) {
            this.noosOrderId = noosOrderId;
            return this;
        }
        /**
         * Token used for verification of the identity of the person making the order.
         */
        public OrderV10Builder withMitIdVerificationToken(String mitIdVerificationToken) {
            this.mitIdVerificationToken = mitIdVerificationToken;
            return this;
        }
        /**
         * Identifier of the batch the order is being processed in.
         */
        public OrderV10Builder withBatchId(String batchId) {
            this.batchId = batchId;
            return this;
        }
        /**
         * must be entered in the 'brand' header and is then placed on the order.
         */
        public OrderV10Builder withBrand(OrderClientDTOEnums.Brand brand) {
            this.brand = brand;
            return this;
        }
        /**
         * Identifying what channel the order is made in, e.g. SALES_FORCE, TANGO, SELF_SERVICE ...
         */
        public OrderV10Builder withChannel(String channel) {
            this.channel = channel;
            return this;
        }

        public OrderV10Builder withDealerBuilder(DealerBuilder dealerBuilder) {
            this.dealerBuilder = dealerBuilder;
            return this;
        }

        public OrderV10Builder withSegment(OrderClientDTOEnums.OrderV10SegmentEnum segment) {
            this.segment = segment;
            return this;
        }

        /**
         * Date time with timezone according to ISO-8601.
         */
        public OrderV10Builder withCreatedDate(DateTime createdDate) {
            this.createdDate = createdDate;
            return this;
        }
        /**
         * Date time with timezone according to ISO-8601. Timestamp of when the order has been completed or cancelled.
         */
        public OrderV10Builder withCompletedDate(DateTime completedDate) {
            this.completedDate = completedDate;
            return this;
        }
        /**
         * Identifier of the person making this order.
         */
        public OrderV10Builder withCreatedBy(String createdBy) {
            this.createdBy = createdBy;
            return this;
        }

        public OrderV10Builder withProcessingStatus(OrderClientDTOEnums.ProcessingStatus processingStatus) {
            this.processingStatus = processingStatus;
            return this;
        }

        public OrderV10Builder withProcessingStatusDetail(String processingStatusDetail) {
            this.processingStatusDetail = processingStatusDetail;
            return this;
        }

        public OrderV10Builder withCreditEvaluationDetailsBuilder(
            CreditEvaluationDetailsBuilder creditEvaluationDetailsbuilder
        ) {
            this.creditEvaluationDetailsBuilder = creditEvaluationDetailsbuilder;
            return this;
        }

        public OrderV10Builder withNotificationRecipientListBuilder(
            NotificationRecipientListBuilder notificationRecipientListBuilder
        ) {
            this.notificationRecipientListBuilder = notificationRecipientListBuilder;
            return this;
        }

        public OrderV10Builder withValidationErrors(List<OrderClientDTO.ValidationError> validationErrors) {
            this.validationErrors = validationErrors;
            return this;
        }

        public OrderV10Builder withHasValidationErrors(Boolean hasValidationErrors) {
            this.hasValidationErrors = hasValidationErrors;
            return this;
        }

        public OrderV10Builder withFlagsBuilder(OrderFlagsBuilder orderFlagsBuilder) {
            this.orderFlagsBuilder = orderFlagsBuilder;
            return this;
        }

        public OrderV10Builder withOrdererPartyRoleBuilder(PartyRoleBuilder ordererPartyRoleBuilder) {
            this.ordererPartyRoleBuilder = ordererPartyRoleBuilder;
            return this;
        }

        public OrderV10Builder withOrderPartListBuilder(OrderPartListBuilder orderPartListBuilder) {
            this.orderPartListBuilder = orderPartListBuilder;
            return this;
        }

        public OrderV10Builder withHardwareDeliveryListBuilder(
            HardwareDeliveryListBuilder hardwareDeliveryListBuilder
        ) {
            this.hardwareDeliveryListBuilder = hardwareDeliveryListBuilder;
            return this;
        }

        /**
         * Link to task for order manual handling.
         */
        public OrderV10Builder withTaskUrl(String taskUrl) {
            this.taskUrl = taskUrl;
            return this;
        }
        /**
         * Sum of all one time fees, charges, and additional product one time price (like hardware price).
         */
        public OrderV10Builder withOrderTotalBuilder(AmountBuilder orderTotalAmountBuilder) {
            this.orderTotalAmountBuilder = orderTotalAmountBuilder;
            return this;
        }
        /**
         * Sum of all one time fees, charges, and additional product one time price (like hardware price.
         */
        public OrderV10Builder withOrderMinimumPriceAmountBuilder(AmountBuilder orderMinimumPriceAmountBuilder) {
            this.orderMinimumPriceAmountBuilder = orderMinimumPriceAmountBuilder;
            return this;
        }
        /**
         * Sum of hardware amount to be paid.
         */
        public OrderV10Builder withHardwareTotalAmountBuilder(AmountBuilder hardwareTotalAmountBuilder) {
            this.hardwareTotalAmountBuilder = hardwareTotalAmountBuilder;
            return this;
        }
        /**
         * Sum of hardware upfront amount (to be paid immediately).
         */
        public OrderV10Builder withHardwareTotalUpfrontPaymentAmountBuilder(
            PaymentAmountBuilder hardwareTotalUpfrontPaymentAmountBuilder
        ) {
            this.hardwareTotalUpfrontPaymentAmountBuilder = hardwareTotalUpfrontPaymentAmountBuilder;
            return this;
        }
        /**
         * Sum of product amount.
         */
        public OrderV10Builder withProductTotalAmountBuilder(AmountBuilder productTotalAmountBuilder) {
            this.productTotalAmountBuilder = productTotalAmountBuilder;
            return this;
        }
        /**
         * Sum of product upfront amount (to be paid immediately).
         */
        public OrderV10Builder withProductTotalUpfrontPaymentAmountBuilder(
            PaymentAmountBuilder productTotalUpfrontPaymentAmountBuilder
        ) {
            this.productTotalUpfrontPaymentAmountBuilder = productTotalUpfrontPaymentAmountBuilder;
            return this;
        }
        /**
         * All services recurring prices.
         */
        public OrderV10Builder withServicesRecurringTotalAmountBuilder(
            AmountBuilder servicesRecurringTotalAmountBuilder
        ) {
            this.servicesRecurringTotalAmountBuilder = servicesRecurringTotalAmountBuilder;
            return this;
        }

        public OrderV10Builder withOrderSourceBuilder(OrderSourceBuilder orderSourceBuilder) {
            this.orderSourceBuilder = orderSourceBuilder;
            return this;
        }

        public OrderV10Builder withConfirmationUrl(String confirmationUrl) {
            this.confirmationUrl = confirmationUrl;
            return this;
        }

        public OrderV10Builder withDocumentsUrl(String documentsUrl) {
            this.documentsUrl = documentsUrl;
            return this;
        }

        public OrderV10Builder withPaymentId(String paymentId) {
            this.paymentId = paymentId;
            return this;
        }

        public OrderV10Builder withPaymentBuilder(PilPaymentBuilder pilPaymentBuilder) {
            this.pilPaymentBuilder = pilPaymentBuilder;
            return this;
        }

        public OrderV10Builder withDocumentListBuilder(DocumentListBuilder documentListBuilder) {
            this.documentListBuilder = documentListBuilder;
            return this;
        }

        public OrderV10Builder withConsentsBuilder(MarketingConsentBuilder marketingConsentBuilder) {
            this.marketingConsentBuilder = marketingConsentBuilder;
            return this;
        }

        public OrderV10Builder withContextId(Integer contextId) {
            this.contextId = contextId;
            return this;
        }

        public OrderClientDTO.OrderV10 build() {
            OrderClientDTO.OrderV10 result = new OrderClientDTO.OrderV10();

            result.id = this.id;
            result.orderId = this.orderId;
            result.parentOrderId = this.parentOrderId;
            result.channelOrderReference = this.channelOrderReference;
            result.implementationCaseId = this.implementationCaseId;
            result.bpmOrderId = this.bpmOrderId;
            result.noosOrderId = this.noosOrderId;
            result.mitIdVerificationToken = this.mitIdVerificationToken;
            result.batchId = this.batchId;
            result.brand = this.brand;
            result.channel = this.channel;

            if (this.dealerBuilder != null) {
                result.dealer = this.dealerBuilder.build();
            }

            result.segment = this.segment;
            result.createdDate = this.createdDate;
            result.completedDate = this.completedDate;
            result.createdBy = this.createdBy;
            result.processingStatus = this.processingStatus;
            result.processingStatusDetail = this.processingStatusDetail;

            if (this.creditEvaluationDetailsBuilder != null) {
                result.creditEvaluationDetails = this.creditEvaluationDetailsBuilder.build();
            }

            if (this.notificationRecipientListBuilder != null) {
                result.notificationRecipients = this.notificationRecipientListBuilder.build();
            }

            result.validationErrors = this.validationErrors;
            result.hasValidationErrors = this.hasValidationErrors;

            if (this.orderFlagsBuilder != null) {
                result.flags = this.orderFlagsBuilder.build();
            }

            if (this.ordererPartyRoleBuilder != null) {
                result.orderer = this.ordererPartyRoleBuilder.build();
            }

            if (this.orderPartListBuilder != null) {
                result.orderParts = this.orderPartListBuilder.build();
            }

            if (this.hardwareDeliveryListBuilder != null) {
                result.hardwareDeliveries = this.hardwareDeliveryListBuilder.build();
            }

            result.taskUrl = this.taskUrl;

            if (this.orderTotalAmountBuilder != null) {
                result.orderTotal = this.orderTotalAmountBuilder.build();
            }

            if (this.orderMinimumPriceAmountBuilder != null) {
                result.orderMinimumPrice = this.orderMinimumPriceAmountBuilder.build();
            }

            if (this.hardwareTotalAmountBuilder != null) {
                result.hardwareTotal = this.hardwareTotalAmountBuilder.build();
            }

            if (this.hardwareTotalUpfrontPaymentAmountBuilder != null) {
                result.hardwareTotalUpfront = this.hardwareTotalUpfrontPaymentAmountBuilder.build();
            }

            if (this.productTotalAmountBuilder != null) {
                result.productTotal = this.productTotalAmountBuilder.build();
            }

            if (this.productTotalUpfrontPaymentAmountBuilder != null) {
                result.productTotalUpfront = this.productTotalUpfrontPaymentAmountBuilder.build();
            }

            if (this.servicesRecurringTotalAmountBuilder != null) {
                result.servicesRecurringTotal = this.servicesRecurringTotalAmountBuilder.build();
            }

            if (this.orderSourceBuilder != null) {
                result.orderSource = this.orderSourceBuilder.build();
            }

            result.confirmationUrl = this.confirmationUrl;
            result.documentsUrl = this.documentsUrl;
            result.paymentId = this.paymentId;

            if (this.pilPaymentBuilder != null) {
                result.payment = this.pilPaymentBuilder.build();
            }

            if (this.documentListBuilder != null) {
                result.documents = this.documentListBuilder.build();
            }

            if (this.marketingConsentBuilder != null) {
                result.consents = this.marketingConsentBuilder.build();
            }
            result.contextId = this.contextId;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * PartyRoleBuilder used to build OrderClientDTO.PartyRole
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public virtual class PartyRoleBuilder {
        private String type;
        private String email;
        private String customerId;
        private TelephoneNumberBuilder telephoneNumberBuilder;
        private AddressBuilder addressBuilder;

        public PartyRoleBuilder withType(String type) {
            this.type = type;
            return this;
        }

        public PartyRoleBuilder withEmail(String email) {
            this.email = email;
            return this;
        }

        public PartyRoleBuilder withCustomerId(String customerId) {
            this.customerId = customerId;
            return this;
        }

        public PartyRoleBuilder withTelephoneNumberBuilder(TelephoneNumberBuilder telephoneNumberBuilder) {
            this.telephoneNumberBuilder = telephoneNumberBuilder;
            return this;
        }

        public PartyRoleBuilder withAddressBuilder(AddressBuilder addressBuilder) {
            this.addressBuilder = addressBuilder;
            return this;
        }

        public OrderClientDTO.PartyRole setProperties(OrderClientDTO.PartyRole partyRole) {
            partyRole.type = this.type;
            partyRole.email = this.email;
            partyRole.customerId = this.customerId;

            if (this.telephoneNumberBuilder != null) {
                partyRole.telephoneNumber = this.telephoneNumberBuilder.build();
            }

            if (this.addressBuilder != null) {
                partyRole.address = this.addressBuilder.build();
            }

            return partyRole;
        }

        public virtual OrderClientDTO.PartyRole build() {
            OrderClientDTO.PartyRole result = new OrderClientDTO.PartyRole();
            setProperties(result);

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrganizationBuilder used to build OrderClientDTO.Organization
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrganizationBuilder extends PartyRoleBuilder {
        private String name;
        private String additionalName;
        private String cvr;

        public OrganizationBuilder() {
            withType('ORGANIZATION');
        }

        public OrganizationBuilder withName(String name) {
            this.name = name;
            return this;
        }

        public OrganizationBuilder withAdditionalName(String additionalName) {
            this.additionalName = additionalName;
            return this;
        }

        public OrganizationBuilder withCvr(String cvr) {
            this.cvr = cvr;
            return this;
        }

        public override OrderClientDTO.PartyRole build() {
            OrderClientDTO.Organization result = new OrderClientDTO.Organization();
            setProperties(result);

            result.name = this.name;
            result.additionalName = this.additionalName;
            result.cvr = this.cvr;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * PersonBuilder used to build OrderClientDTO.Person
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class PersonBuilder extends PartyRoleBuilder {
        private String firstName;
        private String lastName;
        private Date birthday;
        private String cpr;

        public PersonBuilder() {
            withType('PERSON');
        }

        public PersonBuilder withFirstName(String firstName) {
            this.firstName = firstName;
            return this;
        }

        public PersonBuilder withLastName(String lastName) {
            this.lastName = lastName;
            return this;
        }

        public PersonBuilder withBirthday(Date birthday) {
            this.birthday = birthday;
            return this;
        }

        public PersonBuilder withCpr(String cpr) {
            this.cpr = cpr;
            return this;
        }

        public override OrderClientDTO.PartyRole build() {
            OrderClientDTO.Person result = new OrderClientDTO.Person();
            setProperties(result);

            result.firstName = this.firstName;
            result.lastName = this.lastName;
            result.birthday = this.birthday;
            result.cpr = this.cpr;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * PaymentAmountBuilder used to build OrderClientDTO.PaymentAmount
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class PaymentAmountBuilder {
        private Decimal amount;
        private Decimal vat;
        private OrderClientDTOEnums.PaymentAmountCurrencyEnum currency_x;
        private Decimal amountWithoutVat;

        /**
         * amount including VAT
         */
        public PaymentAmountBuilder withAmount(Decimal amount) {
            this.amount = amount;
            return this;
        }

        /**
         * VAT amount
         */
        public PaymentAmountBuilder withVat(Decimal vat) {
            this.vat = this.vat;
            return this;
        }

        /**
         * amount without VAT
         */
        public PaymentAmountBuilder withAmountWithoutVat(Decimal amountWithoutVat) {
            this.amountWithoutVat = this.amountWithoutVat;
            return this;
        }

        public PaymentAmountBuilder withCurrency(OrderClientDTOEnums.PaymentAmountCurrencyEnum currency_x) {
            this.currency_x = currency_x;
            return this;
        }

        public OrderClientDTO.PaymentAmount build() {
            OrderClientDTO.PaymentAmount result = new OrderClientDTO.PaymentAmount();
            result.amount = this.amount;
            result.vat = this.vat;
            result.currency_x = this.currency_x;
            result.amountWithoutVat = this.amountWithoutVat;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * PaymentMethodDetailBuilder used to build OrderClientDTO.PaymentMethodDetail
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public virtual class PaymentMethodDetailBuilder {
        private OrderClientDTOEnums.PaymentMethod paymentMethod;

        public PaymentMethodDetailBuilder withPaymentMethod(OrderClientDTOEnums.PaymentMethod paymentMethod) {
            this.paymentMethod = paymentMethod;
            return this;
        }

        public OrderClientDTO.PaymentMethodDetail build() {
            OrderClientDTO.PaymentMethodDetail result = new OrderClientDTO.PaymentMethodDetail();
            result.paymentMethod = paymentMethod;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    //TODO OrderClientDTO.CardPaymentMethodDetailBuilder
    //TODO OrderClientDTO.GiroPaymentMethodDetailBuilder
    //TODO OrderClientDTO.PbsPaymentMethodDetailBuilder
    //TODO OrderClientDTO.MobilePaymentMethodDetailBuilder

    /**
     * PhysicalIdentificationBuilder used to build OrderClientDTO.PhysicalIdentification
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class PhysicalIdentificationBuilder {
        private String type;
        private String value;

        public PhysicalIdentificationBuilder withType(String type) {
            this.type = type;
            return this;
        }

        public PhysicalIdentificationBuilder withValue(String value) {
            this.value = value;
            return this;
        }

        public OrderClientDTO.PhysicalIdentification build() {
            OrderClientDTO.PhysicalIdentification result = new OrderClientDTO.PhysicalIdentification();
            result.value = this.value;
            result.type = this.type;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * PilPaymentBuilder used to build OrderClientDTO.PilPayment
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class PilPaymentBuilder {
        private String paymentId;
        private Date updatedAt;
        private Decimal totalAmount;
        private Decimal totalVat;
        private Decimal paymentRoundingError;

        /**
         * Id of related payment entity in PaymentIntegrationLayer API
         */
        public PilPaymentBuilder withPaymentId(String paymentId) {
            this.paymentId = paymentId;
            return this;
        }

        /**
         * Date time with timezone according to ISO-8601
         */
        public PilPaymentBuilder withUpdatedAt(Date updatedAt) {
            this.updatedAt = updatedAt;
            return this;
        }

        /**
         * Payed amount including VAT
         */
        public PilPaymentBuilder withTotalAmount(Decimal totalAmount) {
            this.totalAmount = totalAmount;
            return this;
        }

        /**
         * Payed VAT amount
         */
        public PilPaymentBuilder withTotalVat(Decimal totalVat) {
            this.totalVat = totalVat;
            return this;
        }

        /**
         * Difference between hardware total upfront amount and payed total amount
         */
        public PilPaymentBuilder withPaymentRoundingError(Decimal paymentRoundingError) {
            this.paymentRoundingError = paymentRoundingError;
            return this;
        }

        public OrderClientDTO.PilPayment build() {
            OrderClientDTO.PilPayment result = new OrderClientDTO.PilPayment();
            result.paymentId = this.paymentId;
            result.updatedAt = this.updatedAt;
            result.totalAmount = this.totalAmount;
            result.totalVat = this.totalVat;
            result.paymentRoundingError = this.paymentRoundingError;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * PortingDetailsUpdateBuilder used to build OrderClientDTO.PortingDetailsUpdate
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class PortingDetailsUpdateBuilder {
        private TelephoneNumberBuilder telephoneNumberBuilder;
        private String donorSimNumber;
        private ConsentBuilder donorConsentBuilder;
        private ConsentBuilder portingProcessConditionsConsentBuilder;

        public PortingDetailsUpdateBuilder withTelephoneNumber(TelephoneNumberBuilder telephoneNumberBuilder) {
            this.telephoneNumberBuilder = telephoneNumberBuilder;
            return this;
        }

        public PortingDetailsUpdateBuilder withDonorSimNumber(String donorSimNumber) {
            this.donorSimNumber = donorSimNumber;
            return this;
        }

        public PortingDetailsUpdateBuilder withDonorConsent(ConsentBuilder donorConsentBuilder) {
            this.donorConsentBuilder = donorConsentBuilder;
            return this;
        }

        public PortingDetailsUpdateBuilder withPortingProcessConditionsConsent(
            ConsentBuilder portingProcessConditionsConsentBuilder
        ) {
            this.portingProcessConditionsConsentBuilder = portingProcessConditionsConsentBuilder;
            return this;
        }

        public OrderClientDTO.PortingDetailsUpdate build() {
            OrderClientDTO.PortingDetailsUpdate result = new OrderClientDTO.PortingDetailsUpdate();
            if (this.telephoneNumberBuilder != null) {
                result.telephoneNumber = this.telephoneNumberBuilder.build();
            }
            result.donorSimNumber = this.donorSimNumber;
            if (this.donorConsentBuilder != null) {
                result.donorConsent = this.donorConsentBuilder.build();
            }
            if (this.portingProcessConditionsConsentBuilder != null) {
                result.portingProcessConditionsConsent = this.portingProcessConditionsConsentBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * ReturnDetailsBuilder used to build OrderClientDTO.ReturnDetails
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class ReturnDetailsBuilder {
        private Decimal returnQuantity;
        private String creditInvoiceNumber;
        private Date creditInvoiceDate;

        /**
         * Quantity to return
         */
        public ReturnDetailsBuilder withReturnQuantity(Decimal returnQuantity) {
            this.returnQuantity = returnQuantity;
            return this;
        }

        /**
         * Credit invoice number for returned hardware of this order.
         */
        public ReturnDetailsBuilder withCreditInvoiceNumber(String creditInvoiceNumber) {
            this.creditInvoiceNumber = creditInvoiceNumber;
            return this;
        }

        /**
         * date in format YYYY-MM-DD (according to ISO 8601) when was the credit invoice issued.
         */
        public ReturnDetailsBuilder withCreditInvoiceDate(Date creditInvoiceDate) {
            this.creditInvoiceDate = creditInvoiceDate;
            return this;
        }

        public OrderClientDTO.ReturnDetails build() {
            OrderClientDTO.ReturnDetails result = new OrderClientDTO.ReturnDetails();
            result.returnQuantity = this.returnQuantity;
            result.creditInvoiceNumber = this.creditInvoiceNumber;
            result.creditInvoiceDate = this.creditInvoiceDate;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * SerialNumberBuilder used to build OrderClientDTO.SerialNumber
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class SerialNumberBuilder {
        private String type;
        private String value;

        public SerialNumberBuilder withType(String type) {
            this.type = type;
            return this;
        }

        public SerialNumberBuilder withValue(String value) {
            this.value = value;
            return this;
        }

        public OrderClientDTO.SerialNumber build() {
            OrderClientDTO.SerialNumber result = new OrderClientDTO.SerialNumber();
            result.type = this.type;
            result.value = this.value;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * ShippingDetailsBuilder used to build OrderClientDTO.ShippingDetails
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class ShippingDetailsBuilder {
        private Integer toDeliverQuantity;
        private String tsfOffering;
        private String erpTsProduct;
        private Integer hardwareDeliveryId;
        private String userName;
        private String userId;
        private String department;
        private OrderClientDTOEnums.ShippingDetailsDeliveryStatusEnum deliveryStatus;
        private String trackAndTraceNumber;
        private String trackAndTraceUrl;
        private Date shippingConfirmedDate;

        /**
         * Quantity to deliver.
         */
        public ShippingDetailsBuilder withToDeliverQuantity(Integer toDeliverQuantity) {
            this.toDeliverQuantity = toDeliverQuantity;
            return this;
        }

        /**
         * tsfOffering from ProductCatalog.
         */
        public ShippingDetailsBuilder withTSFOffering(String tsfOffering) {
            this.tsfOffering = tsfOffering;
            return this;
        }

        /**
         * erpTsProduct from ProductCatalog.
         */
        public ShippingDetailsBuilder withERPTSProduct(String erpTsProduct) {
            this.erpTsProduct = erpTsProduct;
            return this;
        }

        /**
         * Id of delivery address.
         */
        public ShippingDetailsBuilder withHardwareDeliveryId(Integer hardwareDeliveryId) {
            this.hardwareDeliveryId = hardwareDeliveryId;
            return this;
        }

        /**
         * UserName label for the piece of hardware
         */
        public ShippingDetailsBuilder withUserName(String userName) {
            this.userName = userName;
            return this;
        }

        /**
         * UserName label for the piece of hardware
         */
        public ShippingDetailsBuilder withUserId(String userId) {
            this.userId = userId;
            return this;
        }

        /**
         * UserName label for the piece of hardware
         */
        public ShippingDetailsBuilder withDepartment(String department) {
            this.department = department;
            return this;
        }

        public ShippingDetailsBuilder withDeliveryStatus(
            OrderClientDTOEnums.ShippingDetailsDeliveryStatusEnum deliveryStatus
        ) {
            this.deliveryStatus = deliveryStatus;
            return this;
        }

        public ShippingDetailsBuilder withTrackAndTraceNumber(String trackAndTraceNumber) {
            this.trackAndTraceNumber = trackAndTraceNumber;
            return this;
        }

        public ShippingDetailsBuilder withTrackAndTraceUrl(String trackAndTraceUrl) {
            this.trackAndTraceUrl = trackAndTraceUrl;
            return this;
        }

        /**
         * date in format YYYY-MM-DD (according to ISO 8601).
         */
        public ShippingDetailsBuilder withShippingConfirmedDate(Date shippingConfirmedDate) {
            this.shippingConfirmedDate = shippingConfirmedDate;
            return this;
        }

        public OrderClientDTO.ShippingDetails build() {
            OrderClientDTO.ShippingDetails result = new OrderClientDTO.ShippingDetails();
            result.toDeliverQuantity = this.toDeliverQuantity;
            result.tsfOffering = this.tsfOffering;
            result.erpTsProduct = this.erpTsProduct;
            result.hardwareDeliveryId = this.hardwareDeliveryId;
            result.userName = this.userName;
            result.userId = this.userId;
            result.department = this.department;
            result.deliveryStatus = this.deliveryStatus;
            result.trackAndTraceNumber = this.trackAndTraceNumber;
            result.trackAndTraceUrl = this.trackAndTraceUrl;
            result.shippingConfirmedDate = this.shippingConfirmedDate;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * SimDetailsBuilder used to build OrderClientDTO.SimDetails
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class SimDetailsBuilder {
        private OrderClientDTOEnums.SimDetailsSimTypeEnum simType;
        private String icc;
        private String imsi;
        private String oldIcc;
        private String oldImsi;
        private String eid;
        private String imei;
        private String bindDeviceType;
        private String bindDeviceName;
        private String alternateSmdpFqdn;
        private Boolean waiveSimSwapFee;

        /**
         * Type of sim card.
         */
        public SimDetailsBuilder withSimType(OrderClientDTOEnums.SimDetailsSimTypeEnum simType) {
            this.simType = simType;
            return this;
        }
        /**
         * ICC.
         */
        public SimDetailsBuilder withIcc(String icc) {
            this.icc = icc;
            return this;
        }
        /**
         * IMSI.
         */
        public SimDetailsBuilder withImsi(String imsi) {
            this.imsi = imsi;
            return this;
        }
        /**
         * Icc to be replaced
         */
        public SimDetailsBuilder withOldIcc(String oldIcc) {
            this.oldIcc = oldIcc;
            return this;
        }
        /**
         * IMSI to be replaced
         */
        public SimDetailsBuilder withOldImsi(String oldImsi) {
            this.oldImsi = oldImsi;
            return this;
        }
        /**
         * new EID.
         */
        public SimDetailsBuilder withEid(String eid) {
            this.eid = eid;
            return this;
        }
        /**
         * new IMEI.
         */
        public SimDetailsBuilder withImei(String imei) {
            this.imei = imei;
            return this;
        }

        public SimDetailsBuilder withBindDeviceType(String bindDeviceType) {
            this.bindDeviceType = bindDeviceType;
            return this;
        }
        /**
         * Name of the device to be binded.
         */
        public SimDetailsBuilder withBindDeviceName(String bindDeviceName) {
            this.bindDeviceName = bindDeviceName;
            return this;
        }

        public SimDetailsBuilder withAlternateSmdpFqdn(String alternateSmdpFqdn) {
            this.alternateSmdpFqdn = alternateSmdpFqdn;
            return this;
        }
        /**
         * Indicates whether to apply the sim swap fee.
         */
        public SimDetailsBuilder withWaiveSimSwapFee(Boolean waiveSimSwapFee) {
            this.waiveSimSwapFee = waiveSimSwapFee;
            return this;
        }

        public OrderClientDTO.SimDetails build() {
            OrderClientDTO.SimDetails result = new OrderClientDTO.SimDetails();
            result.simType = this.simType;
            result.icc = this.icc;
            result.imsi = this.imsi;
            result.oldIcc = this.oldIcc;
            result.oldImsi = this.oldImsi;
            result.eid = this.eid;
            result.imei = this.imei;
            result.bindDeviceType = this.bindDeviceType;
            result.bindDeviceName = this.bindDeviceName;
            result.alternateSmdpFqdn = this.alternateSmdpFqdn;
            result.waiveSimSwapFee = this.waiveSimSwapFee;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * DocumentListBuilder used to build List<OrderClientDTO.Document>
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class DocumentListBuilder {
        private List<DocumentBuilder> documentBuilders;

        public DocumentListBuilder withDocumentBuilder(DocumentBuilder documentBuilder) {
            if (this.documentBuilders == null) {
                this.documentBuilders = new List<DocumentBuilder>();
            }

            this.documentBuilders.add(documentBuilder);
            return this;
        }

        public List<OrderClientDTO.Document> build() {
            if (this.documentBuilders == null) {
                return null;
            }

            List<OrderClientDTO.Document> result = new List<OrderClientDTO.Document>();

            for (DocumentBuilder builder : this.documentBuilders) {
                result.add(builder.build());
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * SplitPaymentPatchRequestBuilder used to build OrderClientDTO.SplitPaymentPatchRequest
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class SplitPaymentPatchRequestBuilder {
        private PaymentAmountBuilder totalPaymentAmountBuilder;
        private PaymentAmountBuilder upfrontPaymentAmountBuilder;
        private PaymentAmountBuilder downPaymentAmountBuilder;
        private Date numberOfInstallments;

        public SplitPaymentPatchRequestBuilder withTotalPaymentAmount(PaymentAmountBuilder totalPaymentAmountBuilder) {
            this.totalPaymentAmountBuilder = totalPaymentAmountBuilder;
            return this;
        }

        public SplitPaymentPatchRequestBuilder withUpfrontPaymentAmount(
            PaymentAmountBuilder upfrontPaymentAmountBuilder
        ) {
            this.upfrontPaymentAmountBuilder = upfrontPaymentAmountBuilder;
            return this;
        }

        public SplitPaymentPatchRequestBuilder withDownPaymentAmount(PaymentAmountBuilder downPaymentAmountBuilder) {
            this.downPaymentAmountBuilder = downPaymentAmountBuilder;
            return this;
        }

        public SplitPaymentPatchRequestBuilder withNumberOfInstallments(Date numberOfInstallments) {
            this.numberOfInstallments = numberOfInstallments;
            return this;
        }

        public OrderClientDTO.SplitPaymentPatchRequest build() {
            OrderClientDTO.SplitPaymentPatchRequest result = new OrderClientDTO.SplitPaymentPatchRequest();
            if (this.totalPaymentAmountBuilder != null) {
                result.totalPaymentAmount = this.totalPaymentAmountBuilder.build();
            }
            if (this.upfrontPaymentAmountBuilder != null) {
                result.upfrontPaymentAmount = this.upfrontPaymentAmountBuilder.build();
            }
            if (this.downPaymentAmountBuilder != null) {
                result.downPaymentAmount = this.downPaymentAmountBuilder.build();
            }
            result.numberOfInstallments = this.numberOfInstallments;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * SubscriptionUserBuilder used to build OrderClientDTO.SubscriptionUser
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class SubscriptionUserBuilder {
        private String firstName;
        private String lastName;
        private String email;
        private Date birthDay;
        private AddressBuilder addressBuilder;

        public SubscriptionUserBuilder withFirstName(String firstName) {
            this.firstName = firstName;
            return this;
        }

        public SubscriptionUserBuilder withLastName(String lastName) {
            this.lastName = lastName;
            return this;
        }

        public SubscriptionUserBuilder withAddressBuilder(AddressBuilder addressBuilder) {
            this.addressBuilder = addressBuilder;
            return this;
        }

        public SubscriptionUserBuilder withEmail(String email) {
            this.email = email;
            return this;
        }

        /**
         * BirthDate in format YYYY-MM-DD (according to ISO 8601).
         */
        public SubscriptionUserBuilder withBirthDate(Date birthDay) {
            this.birthDay = birthDay;

            return this;
        }

        public OrderClientDTO.SubscriptionUser build() {
            OrderClientDTO.SubscriptionUser result = new OrderClientDTO.SubscriptionUser();

            result.firstName = this.firstName;
            result.lastName = this.lastName;
            result.email = this.email;
            result.birthday = this.birthDay;

            if (this.addressBuilder != null) {
                result.address = this.addressBuilder.build();
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * TechnicianDetailsBuilder used to build OrderClientDTO.TechnicianDetails
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class TechnicianDetailsBuilder {
        private String installationAddress; //NO IDE
        private AmountBuilder technicianFeeAmountBuilder;
        private String technicianName;
        private String technicianNumber;
        private Date technicianVisitDate;

        public TechnicianDetailsBuilder withInstallationAddress(String installationAddress) {
            this.installationAddress = installationAddress;
            return this;
        }

        public TechnicianDetailsBuilder withTechnicianFeeAmountBuilder(AmountBuilder technicianFeeAmountBuilder) {
            this.technicianFeeAmountBuilder = technicianFeeAmountBuilder;
            return this;
        }

        public TechnicianDetailsBuilder withTechnicianName(String technicianName) {
            this.technicianName = technicianName;
            return this;
        }

        public TechnicianDetailsBuilder withTechnicianNumber(String technicianNumber) {
            this.technicianNumber = technicianNumber;
            return this;
        }

        public TechnicianDetailsBuilder withTechnicianVisitDate(Date technicianVisitDate) {
            this.technicianVisitDate = technicianVisitDate;
            return this;
        }

        public OrderClientDTO.TechnicianDetails build() {
            OrderClientDTO.TechnicianDetails result = new OrderClientDTO.TechnicianDetails();

            result.installationAddress = this.installationAddress;
            if (this.technicianFeeAmountBuilder != null) {
                result.technicianFee = this.technicianFeeAmountBuilder.build();
            }
            result.technicianName = this.technicianName;
            result.technicianNumber = this.technicianNumber;
            result.technicianVisitDate = this.technicianVisitDate;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * TelephoneNumberBuilder used to build OrderClientDTO.TelephoneNumber
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class TelephoneNumberBuilder {
        public String countryCode;
        public String areaCode;
        public String localNumber;

        /**
         * the actual phone number
         */
        public TelephoneNumberBuilder withPhoneNumber(String localNumber) {
            this.localNumber = localNumber;

            return this;
        }

        /**
         * local area code
         */
        public TelephoneNumberBuilder withAreaCode(String areaCode) {
            this.areaCode = areaCode;

            return this;
        }

        /**
         * country code like '45' for Denmark or '372' for Estonia
         */
        public TelephoneNumberBuilder withCountryCode(String countryCode) {
            this.countryCode = countryCode;

            return this;
        }

        public OrderClientDTO.TelephoneNumber build() {
            OrderClientDTO.TelephoneNumber result = new OrderClientDTO.TelephoneNumber();

            result.localNumber = this.localNumber;
            result.areaCode = this.areaCode;
            result.countryCode = this.countryCode;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * TimePeriodBuilder used to build OrderClientDTO.TimePeriod
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class TimePeriodBuilder {
        private Integer amount;
        private OrderClientDTOEnums.TimeUnit unit;

        public TimePeriodBuilder withAmount(Integer amount) {
            this.amount = amount;
            return this;
        }

        public TimePeriodBuilder withTimePeriod(OrderClientDTOEnums.TimeUnit unit) {
            this.unit = unit;
            return this;
        }

        public OrderClientDTO.TimePeriod build() {
            OrderClientDTO.TimePeriod result = new OrderClientDTO.TimePeriod();
            result.unit = this.unit;
            result.amount = this.amount;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * HardwareDeliveryListBuilder used to build List<OrderClientDTO.HardwareDelivery>
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class HardwareDeliveryListBuilder {
        private List<HardwareDeliveryBuilder> hardwareDeliveryBuilders;

        public HardwareDeliveryListBuilder withHardwareDeliveryBuilder(
            HardwareDeliveryBuilder hardwareDeliveryBuilder
        ) {
            if (this.hardwareDeliveryBuilders == null) {
                this.hardwareDeliveryBuilders = new List<HardwareDeliveryBuilder>();
            }
            this.hardwareDeliveryBuilders.add(hardwareDeliveryBuilder);
            return this;
        }

        public List<OrderClientDTO.HardwareDelivery> build() {
            if (this.hardwareDeliveryBuilders == null) {
                return null;
            }

            List<OrderClientDTO.HardwareDelivery> result = new List<OrderClientDTO.HardwareDelivery>();

            for (HardwareDeliveryBuilder builder : this.hardwareDeliveryBuilders) {
                result.add(builder.build());
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * NotificationRecipientListBuilder used to build List<OrderClientDTO.NotificationRecipient>
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class NotificationRecipientListBuilder {
        private List<NotificationRecipientBuilder> notificationRecipientBuilders;

        public NotificationRecipientListBuilder withNotificationRecipientBuilder(
            NotificationRecipientBuilder notificationRecipientBuilder
        ) {
            if (this.notificationRecipientBuilders == null) {
                this.notificationRecipientBuilders = new List<NotificationRecipientBuilder>();
            }

            this.notificationRecipientBuilders.add(notificationRecipientBuilder);

            return this;
        }

        public List<OrderClientDTO.NotificationRecipient> build() {
            if (this.notificationRecipientBuilders == null) {
                return null;
            }

            List<OrderClientDTO.NotificationRecipient> result = new List<OrderClientDTO.NotificationRecipient>();

            for (NotificationRecipientBuilder builder : this.notificationRecipientBuilders) {
                result.add(builder.build());
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderPartListBuilder used to build List<OrderClientDTO.OrderPart>
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrderPartListBuilder {
        private List<OrderPartBuilder> orderPartBuilders;

        public OrderPartListBuilder withOrderPartBuilder(OrderPartBuilder orderPartBuilder) {
            if (this.orderPartBuilders == null) {
                this.orderPartBuilders = new List<OrderPartBuilder>();
            }

            this.orderPartBuilders.add(orderPartBuilder);

            return this;
        }

        public List<OrderClientDTO.OrderPart> build() {
            if (this.orderPartBuilders == null) {
                return null;
            }

            List<OrderClientDTO.OrderPart> result = new List<OrderClientDTO.OrderPart>();

            for (OrderPartBuilder builder : this.orderPartBuilders) {
                result.add(builder.build());
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderPartReferenceListBuilder used to build List<OrderClientDTO.OrderPartReference>
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrderPartReferenceListBuilder {
        private List<OrderPartReferenceBuilder> orderPartReferenceBuilders;

        public OrderPartReferenceListBuilder withOrderPartReferenceBuilder(
            OrderPartReferenceBuilder orderPartReferenceBuilder
        ) {
            if (this.orderPartReferenceBuilders == null) {
                this.orderPartReferenceBuilders = new List<OrderPartReferenceBuilder>();
            }

            this.orderPartReferenceBuilders.add(orderPartReferenceBuilder);

            return this;
        }

        public List<OrderClientDTO.OrderPartReference> build() {
            if (this.orderPartReferenceBuilders == null) {
                return null;
            }

            List<OrderClientDTO.OrderPartReference> result = new List<OrderClientDTO.OrderPartReference>();

            for (OrderPartReferenceBuilder builder : this.orderPartReferenceBuilders) {
                result.add(builder.build());
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderItemListBuilder used to build List<OrderClientDTO.OrderItemList>
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrderItemListBuilder {
        private List<OrderItemBuilder> orderItemBuilders;

        public OrderItemListBuilder withOrderItemBuilder(OrderItemBuilder orderItemBuilder) {
            if (this.orderItemBuilders == null) {
                this.orderItemBuilders = new List<OrderItemBuilder>();
            }

            this.orderItemBuilders.add(orderItemBuilder);
            return this;
        }

        public List<OrderClientDTO.OrderItem> build() {
            if (this.orderItemBuilders == null) {
                return null;
            }

            List<OrderClientDTO.OrderItem> result = new List<OrderClientDTO.OrderItem>();

            for (OrderItemBuilder builder : this.orderItemBuilders) {
                result.add(builder.build());
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * SerialNumberListBuilder used to build List<OrderClientDTO.SerialNumber>
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class SerialNumberListBuilder {
        private List<SerialNumberBuilder> serialNumbersBuilders;

        public SerialNumberListBuilder withSerialNumberBuilder(SerialNumberBuilder serialNumberBuilder) {
            if (this.serialNumbersBuilders == null) {
                this.serialNumbersBuilders = new List<SerialNumberBuilder>();
            }

            this.serialNumbersBuilders.add(serialNumberBuilder);

            return this;
        }

        public List<OrderClientDTO.SerialNumber> build() {
            if (this.serialNumbersBuilders == null) {
                return null;
            }

            List<OrderClientDTO.SerialNumber> result = new List<OrderClientDTO.SerialNumber>();

            for (SerialNumberBuilder serialNumberBuilder : this.serialNumbersBuilders) {
                result.add(serialNumberBuilder.build());
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * HardwareDetailsBuilder used to build OrderClientDTO.HardwareDetails
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class HardwareDetailsBuilder {
        private String materialId;
        private OrderClientDTOEnums.HardwareType hardwareType;
        private String name;
        private SerialNumberListBuilder serialNumberListBuilder;
        private String packageType;

        /**
         * Name of hardware.
         */
        public HardwareDetailsBuilder withName(String name) {
            this.name = name;
            return this;
        }

        /**
         * Id of material.
         */
        public HardwareDetailsBuilder withMaterialId(String materialId) {
            this.materialId = materialId;
            return this;
        }

        public HardwareDetailsBuilder withHardwareType(OrderClientDTOEnums.HardwareType hardwareType) {
            this.hardwareType = hardwareType;
            return this;
        }

        /**
         * Type of package
         */
        public HardwareDetailsBuilder withPackageType(String packageType) {
            this.packageType = packageType;
            return this;
        }

        /**
         * Serial numbers.
         */
        public HardwareDetailsBuilder withSerialNumberListBuilder(SerialNumberListBuilder serialNumberListBuilder) {
            this.serialNumberListBuilder = serialNumberListBuilder;
            return this;
        }

        public OrderClientDTO.HardwareDetails build() {
            OrderClientDTO.HardwareDetails result = new OrderClientDTO.HardwareDetails();
            result.materialId = this.materialId;
            result.hardwareType = this.hardwareType;
            result.name = this.name;

            if (this.serialNumberListBuilder != null) {
                result.serialNumbers = this.serialNumberListBuilder.build();
            }

            result.packageType = this.packageType;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderEventDetailListBuilder used to build List<OrderClientDTO.OrderEventDetails>
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrderEventDetailListBuilder {
        private List<OrderEventDetailsBuilder> orderEventDetailsBuilders;

        public OrderEventDetailListBuilder withOrderEventDetailsBuilder(
            OrderEventDetailsBuilder orderEventDetailsBuilder
        ) {
            if (this.orderEventDetailsBuilders == null) {
                this.orderEventDetailsBuilders = new List<OrderEventDetailsBuilder>();
            }

            this.orderEventDetailsBuilders.add(orderEventDetailsBuilder);
            return this;
        }

        public List<OrderClientDTO.OrderEventDetails> build() {
            if (this.orderEventDetailsBuilders == null) {
                return null;
            }

            List<OrderClientDTO.OrderEventDetails> result = new List<OrderClientDTO.OrderEventDetails>();

            for (OrderEventDetailsBuilder builder : this.orderEventDetailsBuilders) {
                result.add(builder.build());
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * NetworkConfigurationListBuilder used to build List<OrderClientDTO.NetworkConfiguration>
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class NetworkConfigurationListBuilder {
        public List<NetworkConfigurationBuilder> networkConfigurationBuilders;

        public NetworkConfigurationListBuilder withNetworkConfigurationBuilder(
            NetworkConfigurationBuilder networkConfigurationBuilder
        ) {
            if (this.networkConfigurationBuilders == null) {
                this.networkConfigurationBuilders = new List<NetworkConfigurationBuilder>();
            }

            this.networkConfigurationBuilders.add(networkConfigurationBuilder);
            return this;
        }

        public List<OrderClientDTO.NetworkConfiguration> build() {
            if (this.networkConfigurationBuilders == null) {
                return null;
            }

            List<OrderClientDTO.NetworkConfiguration> result = new List<OrderClientDTO.NetworkConfiguration>();

            for (NetworkConfigurationBuilder builder : this.networkConfigurationBuilders) {
                result.add(builder.build());
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * ErrorParameterListBuilder used to build List<OrderClientDTO.ErrorParameter>
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class ErrorParameterListBuilder {
        public List<ErrorParameterBuilder> errorParams;

        public ErrorParameterListBuilder withErrorParameterBuilder(ErrorParameterBuilder errorParamsbuilder) {
            if (this.errorParams == null) {
                this.errorParams = new List<ErrorParameterBuilder>();
            }

            this.errorParams.add(errorParamsbuilder);
            return this;
        }

        public List<OrderClientDTO.ErrorParameter> build() {
            if (this.errorParams == null) {
                return null;
            }

            List<OrderClientDTO.ErrorParameter> result = new List<OrderClientDTO.ErrorParameter>();

            for (ErrorParameterBuilder builder : this.errorParams) {
                result.add(builder.build());
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    /**
     * OrderV10ListBuilder used to build List<OrderClientDTO.OrderV10>
     *
     *  Developer            Date            Description
     *  -----------------------------------------------------------------------------
     *  Niklas Hillgren      01/12/2025      Initial
     *
     * @author Niklas Hillgren
     * @version 1.0
     * @since 01/12/2025
     */
    public class OrderV10ListBuilder {
        public List<OrderV10Builder> orderV10Builders;

        public OrderV10ListBuilder withOrderV10Builder(OrderV10Builder orderV10Builder) {
            if (this.orderV10Builders == null) {
                this.orderV10Builders = new List<OrderV10Builder>();
            }

            this.orderV10Builders.add(orderV10Builder);
            return this;
        }

        public List<OrderClientDTO.OrderV10> build() {
            if (this.orderV10Builders == null) {
                return null;
            }

            List<OrderClientDTO.OrderV10> result = new List<OrderClientDTO.OrderV10>();

            for (OrderV10Builder builder : this.orderV10Builders) {
                result.add(builder.build());
            }

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }
}
