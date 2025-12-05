public with sharing class OrderClientDTOEnums {
    public enum AccountControlOption {
        BLOCK,
        NO_BLOCK,
        SOFT_BLOCK,
        FORCE_BLOCK
    }

    public enum AccountItemBillingCycleEnum {
        MONTHLY,
        QUARTERLY
    }

    public enum AccountItemInvoiceTypeEnum {
        PDF_BY_EMAIL,
        PAPER_INVOICE,
        OIO
    }

    public enum AccountItemCategoryEnum {
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

    public enum AdditionalProductItemProductCategoryEnum {
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

    public enum AddressTypeEnum {
        DANISH_ADDRESS,
        UNSTRUCTURED_ADDRESS
    }

    public enum AmountCurrencyEnum {
        DKK
    }

    public enum ApplicationId {
        DOCUMENT_API,
        DIVA,
        POINT_OF_SALES,
        ENTERPRISE_SELF_SERVICE,
        DK_RPA_BLUEPRISM,
        SIMPLE_QUEUE_SERVICE
    }

    public enum Brand {
        teliadk,
        callme,
        mittele
    }

    public enum CreditEvaluationDetailsEmploymentTypeEnum {
        EMPLOYEE,
        HOMEMAKERS,
        RETIRED,
        SELF_EMPLOYED,
        STUDENT,
        UNEMPLOYED,
        OTHER,
        UNKNOWN
    }

    public enum CreditEvaluationDetailsResidentialStatusEnum {
        COOPERATIVE,
        CONDOMINIUM,
        LIVING_HOME,
        RENTING,
        OTHER
    }

    public enum DownPaymentPlanDownPaymentTypeEnum {
        MOBILE_AGREEMENT,
        CREDIT_AGREEMENT
    }

    public enum DownPaymentPlanCreditProviderEnum {
        CALL_ME,
        TELIA_DK,
        TELIA_FINANCE,
        RESURS
    }

    public enum FeeItemFeeTypeEnum {
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

    public enum HardwareDeliveryPreferredContactMethodEnum {
        PHONE,
        EMAIL
    }

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

    public enum NotificationRecipientRoleEnum {
        CUSTOMER,
        SALES_AGENT,
        SALES_MANAGER,
        EXTERNAL_SHIPPING_PARTNER
    }

    public enum OrderItemActivityEnum {
        CREATE,
        CHANGE,
        REMOVE,
        KEEP,
        BUYBACK
    }

    public enum OrderItemOriginEnum {
        CLIENT,
        SYSTEMVALUE
    }

    public enum OrderItemTypeEnum {
          ACCOUNT_ITEM,
          SUBSCRIPTION_ITEM,
          ADDITIONAL_PRODUCT_ITEM,
          HARDWARE_SWAP_ITEM,
          HARDWARE_PAYMENT_ITEM,
          FEE_ITEM,
          PORTING_DETAILS_ITEM,
          CALL_FORWARDING_ITEM,
          CALL_WAIT_ITEM,
          TERMINATION_ITEM,
          CHARGE_ITEM,
          CONSENT_ITEM,
          REACTIVATION_ITEM,
          SUSPENSION_ITEM,
          DISCOUNT_ITEM,
          REGRET_ITEM,
          CREDIT_WATCH_ITEM,
          SUBSCRIPTION_OWNER_CONTROL_ITEM,
          ACCOUNT_OWNER_CONTROL_ITEM,
          PAYMENT_METHOD_CHANGE_ITEM
    }

    public enum OrderPartTypeEnum {
        ACCOUNT,
        SUBSCRIPTION,
        HARDWARE
    }

    public enum OrderPartActivityEnum {
        CREATE,
        CHANGE,
        TERMINATE,
        SUSPEND,
        REACTIVATE
    }

    public enum OrderPartChangeTypesEnum {
        PRICEPLAN,
        HANDOVER,
        CALL_FORWARDING,
        SIMCARD,
        ADDITIONAL_PRODUCTS
    }

    public enum OrderPartReferenceTypeEnum {
        SUBSCRIPTION_TELEPHONE_NUMBER,
        SUBSCRIPTION_ID,
        BILLING_ACCOUNT_NUMBER,
        INTERNAL_CIRCUIT_ID,
        DOCUMENT_ID,
        DST_ORDER_ID,
        ORIGINAL_ORDER_ID
    }

    public enum OpEnum {
        ADD,
        REMOVE,
        REPLACE,
        MOVE,
        COPY
    }

    public enum OrderV10SegmentEnum {
        B2C,
        B2B
    }

    public enum PaymentAmountCurrencyEnum {
        DKK
    }

    public enum PaymentMethod {
        GIRO,
        CARD,
        MOBILE_PAY,
        PBS
    }

    public enum PaymentType {
        EXTERNAL_PAYMENT_SERVICE,
        INVOICE,
        SHOP
    }

    public enum ProcessingStatus {
        RECEIVED,
        SUBMITTED,
        PROCESSING,
        FAILED,
        CANCELLED,
        COMPLETED,
        DRAFT
    }

    public enum ShippingDetailsDeliveryStatusEnum {
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

    public enum SimDetailsSimTypeEnum {
        MAIN_HARDWARE_SIM,
        EXTRA_HARDWARE_SIM,
        MAIN_ELECTRONIC_SIM,
        EXTRA_ELECTRONIC_SIM
    }

    public enum SubscriptionControlOption {
        BLOCK,
        NO_BLOCK,
        ON_BAN
    }

    public enum SubscriptionItemTelephoneNumberCategoryEnum {
        MOBILE,
        FIXED,
        PBX,
        MISCELLANEOUS
    }

    public enum SubscriptionItemProductTypeEnum {
        MOBILE_VOICE,
        MOBILE_DATA,
        MOBILE_BROADBAND,
        BROADBAND_FIBER,
        BROADBAND_COAX,
        BROADBAND_DSL,
        FIXED_WIRELESS_ACCESS
    }

    public enum SubscriptionItemOfferingChangeTypeEnum {
        NEWVALUE,
        UPGRADE,
        PROLONGING
    }

    public enum SubscriptionItemPublishLevelEnum {
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

    public enum SubscriptionItemBillingSystemEnum {
        FOKUS,
        CERILLION,
        CCB,
        NAVIBILLING,
        NAVISION,
        SSP
    }

    public enum TerminationItemReasonCodeEnum {
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

    public enum TimeUnit {
        DAY,
        WEEK,
        MONTH,
        YEAR
    }
}