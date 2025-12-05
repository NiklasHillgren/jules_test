/**
 * OrderClientDTOBuilderTest is a class that test the Orderbuilder.cls
 *
 * For each inner class in OrderClientDTOBuilder there should be a test builder here.
 * 
 * The test is really simple and it ensure that some of properties are set correctly.
 *
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Niklas Hillgren      01/12/2025      Initial
 *
 * @author Niklas Hillgren
 * @version 1.0
 * @since 01/12/2025
 */
@isTest
public class OrderClientDTOBuilderTest {
    // Helper constants
    private static final Decimal TEST_AMOUNT = 100.00;
    private static final Decimal TEST_VAT = 20.00;
    private static final Decimal TEST_PERCENTAGE = 10.00;
    private static final String TEST_STRING = 'Test Value';
    private static final Date TEST_DATE = Date.today();

    @IsTest
    static void VTPX_SubscriptionsWith10Products() {
        OrderClientDTOBuilder.OrderV10Builder orderBuilder = new OrderClientDTOBuilder.OrderV10Builder();
        orderBuilder.withBrand(OrderClientDTOEnums.Brand.TELIADK)
            .withChannel('SALES_FORCE')
            .withDealerBuilder(new OrderClientDTOBuilder.DealerBuilder().withDealerCode('60301').withDealerName('Niklas'))
            .withOrderPartListBuilder(
                new OrderClientDTOBuilder.OrderPartListBuilder()
                    .withOrderPartBuilder(
                        new OrderClientDTOBuilder.OrderPartBuilder()
                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CHANGE)
                            .withId(0)
                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT)
                            .withOrderPartListBuilder(
                                new OrderClientDTOBuilder.OrderPartListBuilder()
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CREATE)
                                            .withId(0)
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION)
                                            .withOrderItemListBuilder(
                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                            .withTelephoneNumberBuilder(
                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                    .withPhoneNumber('********')
                                                                    .withAreaCode('45')
                                                            )
                                                            .withTelephoneNumberCategory(
                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                            )
                                                            .withNewOfferingBuilder(
                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                    .withPriceplan('CORFRI1TB')
                                                                    .withCampaign('COR1TB24')
                                                                //TODO MISSING productOfferingId
                                                            )
                                                            .withSubscriptionUserBuilder(
                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                    .withFirstName('**************')
                                                                    .withLastName('********')
                                                                    .withEmail('redacted.mailadress@example.com')
                                                                //TODO MISSING TYPE
                                                            )
                                                            .withPublishLevel(
                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                            )
                                                            .withProductDeliveryAsap(false)
                                                            .withId(0)
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                            )
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                            .withProductCode('TPSRAB6NP')
                                                            .withProductCategory(
                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.VAS
                                                            )
                                                            .withQuantity(1)
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                            )
                                                            .withId(0)
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                            .withProductCode('9047807')
                                                            .withProductCategory(
                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                            )
                                                            .withQuantity(1)
                                                            .withSimDetailsBuilder(
                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                    .withSimType(
                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_ELECTRONIC_SIM
                                                                    )
                                                                    .withIcc('89450401220312168545')
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                            )
                                                            .withId(0)
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.PortingDetailsItemBuilder()
                                                            .withDonorSimNumber('89450401220312170491')
                                                            .withPoaDocumentUrl(
                                                                'http://ms.prod.aws.telia.dk:9680/document/REDACTED/attachment/REDACTED'
                                                            )
                                                            .withPowerOfAttorneyManualHandling(true)
                                                            //TODO DOCUMENTID
                                                            .withEarliestPortingDate(Date.valueOf('2023-08-01'))
                                                            .withPortAfterCommitment(false)
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.PORTING_DETAILS_ITEM
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withId(0)
                                                    )
                                            )
                                    )
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CREATE)
                                            .withId(0)
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION)
                                            .withOrderItemListBuilder(
                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                            .withTelephoneNumberBuilder(
                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                    .withPhoneNumber('********')
                                                                    .withAreaCode('45')
                                                            )
                                                            .withTelephoneNumberCategory(
                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                            )
                                                            .withNewOfferingBuilder(
                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                    .withPriceplan('CORFRI1TB')
                                                                    .withCampaign('COR1TB24')
                                                                //TODO MISSING productOfferingId
                                                            )
                                                            .withSubscriptionUserBuilder(
                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                    .withFirstName('**************')
                                                                    .withLastName('********')
                                                                    .withEmail('redacted.mailadress@example.com')
                                                                //TODO MISSING TYPE
                                                            )
                                                            .withPublishLevel(
                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                            )
                                                            .withProductDeliveryAsap(false)
                                                            .withId(0)
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                            )
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                            .withProductCode('TPSRAB6NP')
                                                            .withProductCategory(
                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.VAS
                                                            )
                                                            .withQuantity(1)
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                            )
                                                            .withId(0)
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                            .withProductCode('9047807')
                                                            .withProductCategory(
                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                            )
                                                            .withQuantity(1)
                                                            .withSimDetailsBuilder(
                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                    .withSimType(
                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_ELECTRONIC_SIM
                                                                    )
                                                                    .withIcc('89450401220312168545')
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                            )
                                                            .withId(0)
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.PortingDetailsItemBuilder()
                                                            .withDonorSimNumber('89450401220312170491')
                                                            .withPoaDocumentUrl(
                                                                'http://ms.prod.aws.telia.dk:9680/document/REDACTED/attachment/REDACTED'
                                                            )
                                                            .withPowerOfAttorneyManualHandling(true)
                                                            //TODO DOCUMENTID
                                                            .withEarliestPortingDate(Date.valueOf('2023-08-01'))
                                                            .withPortAfterCommitment(false)
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.PORTING_DETAILS_ITEM
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withId(0)
                                                    )
                                            )
                                    )
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CREATE)
                                            .withId(0)
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION)
                                            .withOrderItemListBuilder(
                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                            .withTelephoneNumberBuilder(
                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                    .withPhoneNumber('********')
                                                                    .withAreaCode('45')
                                                            )
                                                            .withTelephoneNumberCategory(
                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                            )
                                                            .withNewOfferingBuilder(
                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                    .withPriceplan('CORFRI1TB')
                                                                    .withCampaign('COR1TB24')
                                                                //TODO MISSING productOfferingId
                                                            )
                                                            .withSubscriptionUserBuilder(
                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                    .withFirstName('**************')
                                                                    .withLastName('********')
                                                                    .withEmail('redacted.mailadress@example.com')
                                                                //TODO MISSING TYPE
                                                            )
                                                            .withPublishLevel(
                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                            )
                                                            .withProductDeliveryAsap(false)
                                                            .withId(0)
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                            )
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                            .withProductCode('TPSRAB6NP')
                                                            .withProductCategory(
                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.VAS
                                                            )
                                                            .withQuantity(1)
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                            )
                                                            .withId(0)
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                            .withProductCode('9047807')
                                                            .withProductCategory(
                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                            )
                                                            .withQuantity(1)
                                                            .withSimDetailsBuilder(
                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                    .withSimType(
                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_ELECTRONIC_SIM
                                                                    )
                                                                    .withIcc('89450401220312168545')
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                            )
                                                            .withId(0)
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.PortingDetailsItemBuilder()
                                                            .withDonorSimNumber('89450401220312170491')
                                                            .withPoaDocumentUrl(
                                                                'http://ms.prod.aws.telia.dk:9680/document/REDACTED/attachment/REDACTED'
                                                            )
                                                            .withPowerOfAttorneyManualHandling(true)
                                                            //TODO DOCUMENTID
                                                            .withEarliestPortingDate(Date.valueOf('2023-08-01'))
                                                            .withPortAfterCommitment(false)
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.PORTING_DETAILS_ITEM
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withId(0)
                                                    )
                                            )
                                    )
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CREATE)
                                            .withId(0)
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION)
                                            .withOrderItemListBuilder(
                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                            .withTelephoneNumberBuilder(
                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                    .withPhoneNumber('********')
                                                                    .withAreaCode('45')
                                                            )
                                                            .withTelephoneNumberCategory(
                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                            )
                                                            .withNewOfferingBuilder(
                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                    .withPriceplan('CORFRI1TB')
                                                                    .withCampaign('COR1TB24')
                                                                //TODO MISSING productOfferingId
                                                            )
                                                            .withSubscriptionUserBuilder(
                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                    .withFirstName('**************')
                                                                    .withLastName('********')
                                                                    .withEmail('redacted.mailadress@example.com')
                                                                //TODO MISSING TYPE
                                                            )
                                                            .withPublishLevel(
                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                            )
                                                            .withProductDeliveryAsap(false)
                                                            .withId(0)
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                            )
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                            .withProductCode('TPSRAB6NP')
                                                            .withProductCategory(
                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.VAS
                                                            )
                                                            .withQuantity(1)
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                            )
                                                            .withId(0)
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                            .withProductCode('9047807')
                                                            .withProductCategory(
                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                            )
                                                            .withQuantity(1)
                                                            .withSimDetailsBuilder(
                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                    .withSimType(
                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_ELECTRONIC_SIM
                                                                    )
                                                                    .withIcc('89450401220312168545')
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                            )
                                                            .withId(0)
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.PortingDetailsItemBuilder()
                                                            .withDonorSimNumber('89450401220312170491')
                                                            .withPoaDocumentUrl(
                                                                'http://ms.prod.aws.telia.dk:9680/document/REDACTED/attachment/REDACTED'
                                                            )
                                                            .withPowerOfAttorneyManualHandling(true)
                                                            //TODO DOCUMENTID
                                                            .withEarliestPortingDate(Date.valueOf('2023-08-01'))
                                                            .withPortAfterCommitment(false)
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.PORTING_DETAILS_ITEM
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withId(0)
                                                    )
                                            )
                                    )
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CREATE)
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT)
                                            .withOrderItemListBuilder(
                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AccountItemBuilder()
                                                            .withlegalPartyBuilder(
                                                                new OrderClientDTOBuilder.PersonBuilder()
                                                                    .withFirstName('Tuba Demir')
                                                                    .withLastName('van der Burg')
                                                                    .withBirthday(Date.valueOf('1981-01-12'))
                                                                    .withCpr('120181-3790')
                                                                    .withEmail('shirish.patil@teliacompany.com')
                                                                    .withTelephoneNumberBuilder(
                                                                        new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                            .withCountryCode('45')
                                                                            .withPhoneNumber('23232323')
                                                                    )
                                                                    .withAddressBuilder(
                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                            .withStreetName('Nordre Fasanvej')
                                                                            .withStreetNumber('33')
                                                                            .withStreetNumberSuffix('B')
                                                                            .withFloorNumber('04')
                                                                            .withCity('Frederiksberg')
                                                                            .withZipCode('2000')
                                                                            .withCountry('DNK')
                                                                    )
                                                                    .withType('PERSON')
                                                            )
                                                            .withBillingPartyBuilder(
                                                                new OrderClientDTOBuilder.PersonBuilder()
                                                                    .withFirstName('Tuba Demir')
                                                                    .withLastName('van der Burg')
                                                                    .withBirthday(Date.valueOf('1981-01-12'))
                                                                    .withCpr('120181-3790')
                                                                    .withEmail('shirish.patil@teliacompany.com')
                                                                    .withTelephoneNumberBuilder(
                                                                        new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                            .withCountryCode('45')
                                                                            .withPhoneNumber('23232323')
                                                                    )
                                                                    .withAddressBuilder(
                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                            .withStreetName('Nordre Fasanvej')
                                                                            .withStreetNumber('33')
                                                                            .withStreetNumberSuffix('B')
                                                                            .withFloorNumber('04')
                                                                            .withCity('Frederiksberg')
                                                                            .withZipCode('2000')
                                                                            .withCountry('DNK')
                                                                    )
                                                                    .withType('PERSON')
                                                            )
                                                            .withPaymentMethod(
                                                                OrderClientDTOEnums.PaymentMethod.GIRO
                                                            )
                                                            .withBillingCycle(
                                                                OrderClientDTOEnums.AccountItemBillingCycleEnum.MONTHLY
                                                            )
                                                            .withInvoiceType(
                                                                OrderClientDTOEnums.AccountItemInvoiceTypeEnum.PAPER_INVOICE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ACCOUNT_ITEM
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.FeeItemBuilder()
                                                            .withFeeType(
                                                                OrderClientDTOEnums.FeeItemFeeTypeEnum.ADMIN_FEE_GIRO
                                                            )
                                                            .withDisplayName('GIRO payment fee')
                                                            .withPriceAmountBuilder(
                                                                new OrderClientDTOBuilder.AmountBuilder()
                                                                    .withCatalogAmount(49)
                                                                    .withCatalogVat(9.8)
                                                                    .withCurrency(
                                                                        OrderClientDTOEnums.AmountCurrencyEnum.DKK
                                                                    )
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.FEE_ITEM
                                                            )
                                                    )
                                            )
                                            .withOrderPartListBuilder(
                                                new OrderClientDTOBuilder.OrderPartListBuilder()
                                                    .withOrderPartBuilder(
                                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                                            .withType(
                                                                OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderPartActivityEnum.CREATE
                                                            )
                                                            .withOrderItemListBuilder(
                                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                                    .withOrderItemBuilder(
                                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                                            .withTelephoneNumberBuilder(
                                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                                    .withPhoneNumber('27726643')
                                                                                    .withCountryCode('45')
                                                                            )
                                                                            .withTelephoneNumberCategory(
                                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                                            )
                                                                            .withTerminationPeriodBuilder(
                                                                                new OrderClientDTOBuilder.TimePeriodBuilder()
                                                                                    .withAmount(0)
                                                                                    .withTimePeriod(
                                                                                        OrderClientDTOEnums.TimeUnit.DAY
                                                                                    )
                                                                            )
                                                                            .withNewOfferingBuilder(
                                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                                    .withPriceplan('CHAMPEBA')
                                                                                    .withCampaign('CHAMPEBAS')
                                                                                //TODO MISSING productOfferingId
                                                                            )
                                                                            .withProductType(
                                                                                OrderClientDTOEnums.SubscriptionItemProductTypeEnum.MOBILE_VOICE
                                                                            )
                                                                            .withSubscriptionUserBuilder(
                                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                                    .withLastName('Havrlantova')
                                                                                    .withBirthDate(
                                                                                        Date.valueOf('1981-01-12')
                                                                                    )
                                                                                    .withEmail(
                                                                                        'miroslava.havrlantova@teliacompany.com'
                                                                                    )
                                                                                    .withAddressBuilder(
                                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                                            //TODO DANISH_ADDRESS_TYPE WAS ADDED?
                                                                                            .withStreetName('Rubyvej')
                                                                                            .withStreetNumber('8')
                                                                                            .withCity('Odense N')
                                                                                            .withZipCode('5270')
                                                                                            .withCountry('DNK')
                                                                                            .withCoName('Odense N')
                                                                                    )
                                                                            )
                                                                            .withPublishLevel(
                                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                                            )
                                                                            .withActivity(
                                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                                            )
                                                                            .withType(
                                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                                            )
                                                                    )
                                                                    .withOrderItemBuilder(
                                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                                            .withProductCategory(
                                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                                            )
                                                                            .withSimDetailsBuilder(
                                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                                    .withSimType(
                                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM
                                                                                    )
                                                                            )
                                                                            .withShippingDetailsBuilder(
                                                                                new OrderClientDTOBuilder.ShippingDetailsBuilder()
                                                                                    .withERPTSProduct('TSA1000159')
                                                                                    .withHardwareDeliveryId(1)
                                                                                    .withToDeliverQuantity(1)
                                                                                    .withTSFOffering('TSF1005448')
                                                                            )
                                                                            .withHardwareDetailsBuilder(
                                                                                new OrderClientDTOBuilder.HardwareDetailsBuilder()
                                                                                    .withHardwareType(
                                                                                        OrderClientDTOEnums.HardwareType.SIM
                                                                                    )
                                                                                    .withMaterialId('9064434')
                                                                                    .withName('micro SIM')
                                                                            )
                                                                            .withQuantity(1)
                                                                            .withActivity(
                                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                                            )
                                                                            .withType(
                                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                                            )
                                                                    )
                                                            )
                                                    )
                                            )
                                    )
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CREATE)
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT)
                                            .withOrderItemListBuilder(
                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AccountItemBuilder()
                                                            .withlegalPartyBuilder(
                                                                new OrderClientDTOBuilder.PersonBuilder()
                                                                    .withFirstName('Tuba Demir')
                                                                    .withLastName('van der Burg')
                                                                    .withBirthday(Date.valueOf('1981-01-12'))
                                                                    .withCpr('120181-3790')
                                                                    .withEmail('shirish.patil@teliacompany.com')
                                                                    .withTelephoneNumberBuilder(
                                                                        new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                            .withCountryCode('45')
                                                                            .withPhoneNumber('23232323')
                                                                    )
                                                                    .withAddressBuilder(
                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                            .withStreetName('Nordre Fasanvej')
                                                                            .withStreetNumber('33')
                                                                            .withStreetNumberSuffix('B')
                                                                            .withFloorNumber('04')
                                                                            .withCity('Frederiksberg')
                                                                            .withZipCode('2000')
                                                                            .withCountry('DNK')
                                                                    )
                                                                    .withType('PERSON')
                                                            )
                                                            .withBillingPartyBuilder(
                                                                new OrderClientDTOBuilder.PersonBuilder()
                                                                    .withFirstName('Tuba Demir')
                                                                    .withLastName('van der Burg')
                                                                    .withBirthday(Date.valueOf('1981-01-12'))
                                                                    .withCpr('120181-3790')
                                                                    .withEmail('shirish.patil@teliacompany.com')
                                                                    .withTelephoneNumberBuilder(
                                                                        new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                            .withCountryCode('45')
                                                                            .withPhoneNumber('23232323')
                                                                    )
                                                                    .withAddressBuilder(
                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                            .withStreetName('Nordre Fasanvej')
                                                                            .withStreetNumber('33')
                                                                            .withStreetNumberSuffix('B')
                                                                            .withFloorNumber('04')
                                                                            .withCity('Frederiksberg')
                                                                            .withZipCode('2000')
                                                                            .withCountry('DNK')
                                                                    )
                                                                    .withType('PERSON')
                                                            )
                                                            .withPaymentMethod(
                                                                OrderClientDTOEnums.PaymentMethod.GIRO
                                                            )
                                                            .withBillingCycle(
                                                                OrderClientDTOEnums.AccountItemBillingCycleEnum.MONTHLY
                                                            )
                                                            .withInvoiceType(
                                                                OrderClientDTOEnums.AccountItemInvoiceTypeEnum.PAPER_INVOICE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ACCOUNT_ITEM
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.FeeItemBuilder()
                                                            .withFeeType(
                                                                OrderClientDTOEnums.FeeItemFeeTypeEnum.ADMIN_FEE_GIRO
                                                            )
                                                            .withDisplayName('GIRO payment fee')
                                                            .withPriceAmountBuilder(
                                                                new OrderClientDTOBuilder.AmountBuilder()
                                                                    .withCatalogAmount(49)
                                                                    .withCatalogVat(9.8)
                                                                    .withCurrency(
                                                                        OrderClientDTOEnums.AmountCurrencyEnum.DKK
                                                                    )
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.FEE_ITEM
                                                            )
                                                    )
                                            )
                                            .withOrderPartListBuilder(
                                                new OrderClientDTOBuilder.OrderPartListBuilder()
                                                    .withOrderPartBuilder(
                                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                                            .withType(
                                                                OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderPartActivityEnum.CREATE
                                                            )
                                                            .withOrderItemListBuilder(
                                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                                    .withOrderItemBuilder(
                                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                                            .withTelephoneNumberBuilder(
                                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                                    .withPhoneNumber('27726643')
                                                                                    .withCountryCode('45')
                                                                            )
                                                                            .withTelephoneNumberCategory(
                                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                                            )
                                                                            .withTerminationPeriodBuilder(
                                                                                new OrderClientDTOBuilder.TimePeriodBuilder()
                                                                                    .withAmount(0)
                                                                                    .withTimePeriod(
                                                                                        OrderClientDTOEnums.TimeUnit.DAY
                                                                                    )
                                                                            )
                                                                            .withNewOfferingBuilder(
                                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                                    .withPriceplan('CHAMPEBA')
                                                                                    .withCampaign('CHAMPEBAS')
                                                                                //TODO MISSING productOfferingId
                                                                            )
                                                                            .withProductType(
                                                                                OrderClientDTOEnums.SubscriptionItemProductTypeEnum.MOBILE_VOICE
                                                                            )
                                                                            .withSubscriptionUserBuilder(
                                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                                    .withLastName('Havrlantova')
                                                                                    .withBirthDate(
                                                                                        Date.valueOf('1981-01-12')
                                                                                    )
                                                                                    .withEmail(
                                                                                        'miroslava.havrlantova@teliacompany.com'
                                                                                    )
                                                                                    .withAddressBuilder(
                                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                                            //TODO DANISH_ADDRESS_TYPE WAS ADDED?
                                                                                            .withStreetName('Rubyvej')
                                                                                            .withStreetNumber('8')
                                                                                            .withCity('Odense N')
                                                                                            .withZipCode('5270')
                                                                                            .withCountry('DNK')
                                                                                            .withCoName('Odense N')
                                                                                    )
                                                                            )
                                                                            .withPublishLevel(
                                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                                            )
                                                                            .withActivity(
                                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                                            )
                                                                            .withType(
                                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                                            )
                                                                    )
                                                                    .withOrderItemBuilder(
                                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                                            .withProductCategory(
                                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                                            )
                                                                            .withSimDetailsBuilder(
                                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                                    .withSimType(
                                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM
                                                                                    )
                                                                            )
                                                                            .withShippingDetailsBuilder(
                                                                                new OrderClientDTOBuilder.ShippingDetailsBuilder()
                                                                                    .withERPTSProduct('TSA1000159')
                                                                                    .withHardwareDeliveryId(1)
                                                                                    .withToDeliverQuantity(1)
                                                                                    .withTSFOffering('TSF1005448')
                                                                            )
                                                                            .withHardwareDetailsBuilder(
                                                                                new OrderClientDTOBuilder.HardwareDetailsBuilder()
                                                                                    .withHardwareType(
                                                                                        OrderClientDTOEnums.HardwareType.SIM
                                                                                    )
                                                                                    .withMaterialId('9064434')
                                                                                    .withName('micro SIM')
                                                                            )
                                                                            .withQuantity(1)
                                                                            .withActivity(
                                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                                            )
                                                                            .withType(
                                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                                            )
                                                                    )
                                                            )
                                                    )
                                            )
                                    )
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CREATE)
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT)
                                            .withOrderItemListBuilder(
                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AccountItemBuilder()
                                                            .withlegalPartyBuilder(
                                                                new OrderClientDTOBuilder.PersonBuilder()
                                                                    .withFirstName('Tuba Demir')
                                                                    .withLastName('van der Burg')
                                                                    .withBirthday(Date.valueOf('1981-01-12'))
                                                                    .withCpr('120181-3790')
                                                                    .withEmail('shirish.patil@teliacompany.com')
                                                                    .withTelephoneNumberBuilder(
                                                                        new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                            .withCountryCode('45')
                                                                            .withPhoneNumber('23232323')
                                                                    )
                                                                    .withAddressBuilder(
                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                            .withStreetName('Nordre Fasanvej')
                                                                            .withStreetNumber('33')
                                                                            .withStreetNumberSuffix('B')
                                                                            .withFloorNumber('04')
                                                                            .withCity('Frederiksberg')
                                                                            .withZipCode('2000')
                                                                            .withCountry('DNK')
                                                                    )
                                                                    .withType('PERSON')
                                                            )
                                                            .withBillingPartyBuilder(
                                                                new OrderClientDTOBuilder.PersonBuilder()
                                                                    .withFirstName('Tuba Demir')
                                                                    .withLastName('van der Burg')
                                                                    .withBirthday(Date.valueOf('1981-01-12'))
                                                                    .withCpr('120181-3790')
                                                                    .withEmail('shirish.patil@teliacompany.com')
                                                                    .withTelephoneNumberBuilder(
                                                                        new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                            .withCountryCode('45')
                                                                            .withPhoneNumber('23232323')
                                                                    )
                                                                    .withAddressBuilder(
                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                            .withStreetName('Nordre Fasanvej')
                                                                            .withStreetNumber('33')
                                                                            .withStreetNumberSuffix('B')
                                                                            .withFloorNumber('04')
                                                                            .withCity('Frederiksberg')
                                                                            .withZipCode('2000')
                                                                            .withCountry('DNK')
                                                                    )
                                                                    .withType('PERSON')
                                                            )
                                                            .withPaymentMethod(
                                                                OrderClientDTOEnums.PaymentMethod.GIRO
                                                            )
                                                            .withBillingCycle(
                                                                OrderClientDTOEnums.AccountItemBillingCycleEnum.MONTHLY
                                                            )
                                                            .withInvoiceType(
                                                                OrderClientDTOEnums.AccountItemInvoiceTypeEnum.PAPER_INVOICE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ACCOUNT_ITEM
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.FeeItemBuilder()
                                                            .withFeeType(
                                                                OrderClientDTOEnums.FeeItemFeeTypeEnum.ADMIN_FEE_GIRO
                                                            )
                                                            .withDisplayName('GIRO payment fee')
                                                            .withPriceAmountBuilder(
                                                                new OrderClientDTOBuilder.AmountBuilder()
                                                                    .withCatalogAmount(49)
                                                                    .withCatalogVat(9.8)
                                                                    .withCurrency(
                                                                        OrderClientDTOEnums.AmountCurrencyEnum.DKK
                                                                    )
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.FEE_ITEM
                                                            )
                                                    )
                                            )
                                            .withOrderPartListBuilder(
                                                new OrderClientDTOBuilder.OrderPartListBuilder()
                                                    .withOrderPartBuilder(
                                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                                            .withType(
                                                                OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderPartActivityEnum.CREATE
                                                            )
                                                            .withOrderItemListBuilder(
                                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                                    .withOrderItemBuilder(
                                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                                            .withTelephoneNumberBuilder(
                                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                                    .withPhoneNumber('27726643')
                                                                                    .withCountryCode('45')
                                                                            )
                                                                            .withTelephoneNumberCategory(
                                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                                            )
                                                                            .withTerminationPeriodBuilder(
                                                                                new OrderClientDTOBuilder.TimePeriodBuilder()
                                                                                    .withAmount(0)
                                                                                    .withTimePeriod(
                                                                                        OrderClientDTOEnums.TimeUnit.DAY
                                                                                    )
                                                                            )
                                                                            .withNewOfferingBuilder(
                                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                                    .withPriceplan('CHAMPEBA')
                                                                                    .withCampaign('CHAMPEBAS')
                                                                                //TODO MISSING productOfferingId
                                                                            )
                                                                            .withProductType(
                                                                                OrderClientDTOEnums.SubscriptionItemProductTypeEnum.MOBILE_VOICE
                                                                            )
                                                                            .withSubscriptionUserBuilder(
                                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                                    .withLastName('Havrlantova')
                                                                                    .withBirthDate(
                                                                                        Date.valueOf('1981-01-12')
                                                                                    )
                                                                                    .withEmail(
                                                                                        'miroslava.havrlantova@teliacompany.com'
                                                                                    )
                                                                                    .withAddressBuilder(
                                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                                            //TODO DANISH_ADDRESS_TYPE WAS ADDED?
                                                                                            .withStreetName('Rubyvej')
                                                                                            .withStreetNumber('8')
                                                                                            .withCity('Odense N')
                                                                                            .withZipCode('5270')
                                                                                            .withCountry('DNK')
                                                                                            .withCoName('Odense N')
                                                                                    )
                                                                            )
                                                                            .withPublishLevel(
                                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                                            )
                                                                            .withActivity(
                                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                                            )
                                                                            .withType(
                                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                                            )
                                                                    )
                                                                    .withOrderItemBuilder(
                                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                                            .withProductCategory(
                                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                                            )
                                                                            .withSimDetailsBuilder(
                                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                                    .withSimType(
                                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM
                                                                                    )
                                                                            )
                                                                            .withShippingDetailsBuilder(
                                                                                new OrderClientDTOBuilder.ShippingDetailsBuilder()
                                                                                    .withERPTSProduct('TSA1000159')
                                                                                    .withHardwareDeliveryId(1)
                                                                                    .withToDeliverQuantity(1)
                                                                                    .withTSFOffering('TSF1005448')
                                                                            )
                                                                            .withHardwareDetailsBuilder(
                                                                                new OrderClientDTOBuilder.HardwareDetailsBuilder()
                                                                                    .withHardwareType(
                                                                                        OrderClientDTOEnums.HardwareType.SIM
                                                                                    )
                                                                                    .withMaterialId('9064434')
                                                                                    .withName('micro SIM')
                                                                            )
                                                                            .withQuantity(1)
                                                                            .withActivity(
                                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                                            )
                                                                            .withType(
                                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                                            )
                                                                    )
                                                            )
                                                    )
                                            )
                                    )
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CHANGE)
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT)
                                            .withOrderPartReferenceListBuilder(
                                                new OrderClientDTOBuilder.OrderPartReferenceListBuilder()
                                                    .withOrderPartReferenceBuilder(
                                                        new OrderClientDTOBuilder.OrderPartReferenceBuilder()
                                                            .withType(
                                                                OrderClientDTOEnums.OrderPartReferenceTypeEnum.BILLING_ACCOUNT_NUMBER
                                                            )
                                                            .withValue('460372212')
                                                    )
                                            )
                                            .withOrderPartListBuilder(
                                                new OrderClientDTOBuilder.OrderPartListBuilder()
                                                    .withOrderPartBuilder(
                                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                                            .withOrderItemListBuilder(
                                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                                    .withOrderItemBuilder(
                                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                                            .withNewOfferingBuilder(
                                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                                    .withCampaign('CHAMPEBAS')
                                                                                    .withPriceplan('CHAMPEBA')
                                                                            )
                                                                            .withProductType(
                                                                                OrderClientDTOEnums.SubscriptionItemProductTypeEnum.MOBILE_VOICE
                                                                            )
                                                                            .withPublishLevel(
                                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                                            )
                                                                            .withSubscriptionUserBuilder(
                                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                                    .withAddressBuilder(
                                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                                            .withStreetName('Rubyvej')
                                                                                            .withStreetNumber('8')
                                                                                            .withZipCode('5270')
                                                                                            .withCity('Odense N')
                                                                                            .withCoName('Odense N')
                                                                                            .withCountry('DNK')
                                                                                    )
                                                                                    .withBirthDate(
                                                                                        Date.valueOf('1987-08-08')
                                                                                    )
                                                                                    .withEmail(
                                                                                        'miroslava.havrlantova@teliacompany.com'
                                                                                    )
                                                                                    .withFirstName('Mirka')
                                                                                    .withLastName('Havrlantova')
                                                                            )
                                                                            .withTelephoneNumberCategory(
                                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                                            )
                                                                            .withTelephoneNumberBuilder(
                                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                                    .withCountryCode('45')
                                                                                    .withPhoneNumber('28968332')
                                                                            )
                                                                            .withActivity(
                                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                                            )
                                                                            .withType(
                                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                                            )
                                                                    )
                                                                    .withOrderItemBuilder(
                                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                                            .withProductCategory(
                                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                                            )
                                                                            .withSimDetailsBuilder(
                                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                                    .withSimType(
                                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM
                                                                                    )
                                                                            )
                                                                            .withShippingDetailsBuilder(
                                                                                new OrderClientDTOBuilder.ShippingDetailsBuilder()
                                                                                    .withERPTSProduct('TSA1000159')
                                                                                    .withHardwareDeliveryId(1)
                                                                                    .withToDeliverQuantity(1)
                                                                                    .withTSFOffering('TSF1005448')
                                                                            )
                                                                            .withHardwareDetailsBuilder(
                                                                                new OrderClientDTOBuilder.HardwareDetailsBuilder()
                                                                                    .withHardwareType(
                                                                                        OrderClientDTOEnums.HardwareType.SIM
                                                                                    )
                                                                                    .withMaterialId('9064434')
                                                                                    .withName('micro SIM')
                                                                            )
                                                                            .withQuantity(1)
                                                                            .withActivity(
                                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                                            )
                                                                            .withType(
                                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                                            )
                                                                    )
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderPartActivityEnum.CREATE
                                                            )
                                                    )
                                            )
                                    )
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CHANGE)
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT)
                                            .withOrderPartReferenceListBuilder(
                                                new OrderClientDTOBuilder.OrderPartReferenceListBuilder()
                                                    .withOrderPartReferenceBuilder(
                                                        new OrderClientDTOBuilder.OrderPartReferenceBuilder()
                                                            .withType(
                                                                OrderClientDTOEnums.OrderPartReferenceTypeEnum.BILLING_ACCOUNT_NUMBER
                                                            )
                                                            .withValue('460372212')
                                                    )
                                            )
                                            .withOrderPartListBuilder(
                                                new OrderClientDTOBuilder.OrderPartListBuilder()
                                                    .withOrderPartBuilder(
                                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                                            .withOrderItemListBuilder(
                                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                                    .withOrderItemBuilder(
                                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                                            .withNewOfferingBuilder(
                                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                                    .withCampaign('CHAMPEBAS')
                                                                                    .withPriceplan('CHAMPEBA')
                                                                            )
                                                                            .withProductType(
                                                                                OrderClientDTOEnums.SubscriptionItemProductTypeEnum.MOBILE_VOICE
                                                                            )
                                                                            .withPublishLevel(
                                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                                            )
                                                                            .withSubscriptionUserBuilder(
                                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                                    .withAddressBuilder(
                                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                                            .withStreetName('Rubyvej')
                                                                                            .withStreetNumber('8')
                                                                                            .withZipCode('5270')
                                                                                            .withCity('Odense N')
                                                                                            .withCoName('Odense N')
                                                                                            .withCountry('DNK')
                                                                                    )
                                                                                    .withBirthDate(
                                                                                        Date.valueOf('1987-08-08')
                                                                                    )
                                                                                    .withEmail(
                                                                                        'miroslava.havrlantova@teliacompany.com'
                                                                                    )
                                                                                    .withFirstName('Mirka')
                                                                                    .withLastName('Havrlantova')
                                                                            )
                                                                            .withTelephoneNumberCategory(
                                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                                            )
                                                                            .withTelephoneNumberBuilder(
                                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                                    .withCountryCode('45')
                                                                                    .withPhoneNumber('28968332')
                                                                            )
                                                                            .withActivity(
                                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                                            )
                                                                            .withType(
                                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                                            )
                                                                    )
                                                                    .withOrderItemBuilder(
                                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                                            .withProductCategory(
                                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                                            )
                                                                            .withSimDetailsBuilder(
                                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                                    .withSimType(
                                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM
                                                                                    )
                                                                            )
                                                                            .withShippingDetailsBuilder(
                                                                                new OrderClientDTOBuilder.ShippingDetailsBuilder()
                                                                                    .withERPTSProduct('TSA1000159')
                                                                                    .withHardwareDeliveryId(1)
                                                                                    .withToDeliverQuantity(1)
                                                                                    .withTSFOffering('TSF1005448')
                                                                            )
                                                                            .withHardwareDetailsBuilder(
                                                                                new OrderClientDTOBuilder.HardwareDetailsBuilder()
                                                                                    .withHardwareType(
                                                                                        OrderClientDTOEnums.HardwareType.SIM
                                                                                    )
                                                                                    .withMaterialId('9064434')
                                                                                    .withName('micro SIM')
                                                                            )
                                                                            .withQuantity(1)
                                                                            .withActivity(
                                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                                            )
                                                                            .withType(
                                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                                            )
                                                                    )
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderPartActivityEnum.CREATE
                                                            )
                                                    )
                                            )
                                    )
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CHANGE)
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT)
                                            .withOrderPartReferenceListBuilder(
                                                new OrderClientDTOBuilder.OrderPartReferenceListBuilder()
                                                    .withOrderPartReferenceBuilder(
                                                        new OrderClientDTOBuilder.OrderPartReferenceBuilder()
                                                            .withType(
                                                                OrderClientDTOEnums.OrderPartReferenceTypeEnum.BILLING_ACCOUNT_NUMBER
                                                            )
                                                            .withValue('460372212')
                                                    )
                                            )
                                            .withOrderPartListBuilder(
                                                new OrderClientDTOBuilder.OrderPartListBuilder()
                                                    .withOrderPartBuilder(
                                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                                            .withOrderItemListBuilder(
                                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                                    .withOrderItemBuilder(
                                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                                            .withNewOfferingBuilder(
                                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                                    .withCampaign('CHAMPEBAS')
                                                                                    .withPriceplan('CHAMPEBA')
                                                                            )
                                                                            .withProductType(
                                                                                OrderClientDTOEnums.SubscriptionItemProductTypeEnum.MOBILE_VOICE
                                                                            )
                                                                            .withPublishLevel(
                                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                                            )
                                                                            .withSubscriptionUserBuilder(
                                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                                    .withAddressBuilder(
                                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                                            .withStreetName('Rubyvej')
                                                                                            .withStreetNumber('8')
                                                                                            .withZipCode('5270')
                                                                                            .withCity('Odense N')
                                                                                            .withCoName('Odense N')
                                                                                            .withCountry('DNK')
                                                                                    )
                                                                                    .withBirthDate(
                                                                                        Date.valueOf('1987-08-08')
                                                                                    )
                                                                                    .withEmail(
                                                                                        'miroslava.havrlantova@teliacompany.com'
                                                                                    )
                                                                                    .withFirstName('Mirka')
                                                                                    .withLastName('Havrlantova')
                                                                            )
                                                                            .withTelephoneNumberCategory(
                                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                                            )
                                                                            .withTelephoneNumberBuilder(
                                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                                    .withCountryCode('45')
                                                                                    .withPhoneNumber('28968332')
                                                                            )
                                                                            .withActivity(
                                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                                            )
                                                                            .withType(
                                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                                            )
                                                                    )
                                                                    .withOrderItemBuilder(
                                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                                            .withProductCategory(
                                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                                            )
                                                                            .withSimDetailsBuilder(
                                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                                    .withSimType(
                                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM
                                                                                    )
                                                                            )
                                                                            .withShippingDetailsBuilder(
                                                                                new OrderClientDTOBuilder.ShippingDetailsBuilder()
                                                                                    .withERPTSProduct('TSA1000159')
                                                                                    .withHardwareDeliveryId(1)
                                                                                    .withToDeliverQuantity(1)
                                                                                    .withTSFOffering('TSF1005448')
                                                                            )
                                                                            .withHardwareDetailsBuilder(
                                                                                new OrderClientDTOBuilder.HardwareDetailsBuilder()
                                                                                    .withHardwareType(
                                                                                        OrderClientDTOEnums.HardwareType.SIM
                                                                                    )
                                                                                    .withMaterialId('9064434')
                                                                                    .withName('micro SIM')
                                                                            )
                                                                            .withQuantity(1)
                                                                            .withActivity(
                                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                                            )
                                                                            .withType(
                                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                                            )
                                                                    )
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderPartActivityEnum.CREATE
                                                            )
                                                    )
                                            )
                                    )
                            )
                    )
            )
            .withSegment(OrderClientDTOEnums.OrderV10SegmentEnum.B2B)
            .withCreatedBy('redacted.mailadress@example.com');

        OrderClientDTO.OrderV10 order = orderBuilder.build();
    }

    @IsTest
    static void VTPX_SubscriptionActivationWithNumberPorting() {
        OrderClientDTOBuilder.OrderV10Builder orderBuilder = new OrderClientDTOBuilder.OrderV10Builder();
        orderBuilder.withBrand(OrderClientDTOEnums.Brand.TELIADK)
            .withChannel('SALES_FORCE')
            .withDealerBuilder(new OrderClientDTOBuilder.DealerBuilder().withDealerCode('60301').withDealerName('Niklas'))
            .withOrderPartListBuilder(
                new OrderClientDTOBuilder.OrderPartListBuilder()
                    .withOrderPartBuilder(
                        new OrderClientDTOBuilder.OrderPartBuilder()
                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CHANGE)
                            .withId(0)
                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT)
                            .withOrderPartListBuilder(
                                new OrderClientDTOBuilder.OrderPartListBuilder()
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CREATE)
                                            .withId(0)
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION)
                                            .withOrderItemListBuilder(
                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                            .withTelephoneNumberBuilder(
                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                    .withPhoneNumber('********')
                                                                    .withAreaCode('45')
                                                            )
                                                            .withTelephoneNumberCategory(
                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                            )
                                                            .withNewOfferingBuilder(
                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                    .withPriceplan('CORFRI1TB')
                                                                    .withCampaign('COR1TB24')
                                                                //TODO MISSING productOfferingId
                                                            )
                                                            .withSubscriptionUserBuilder(
                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                    .withFirstName('**************')
                                                                    .withLastName('********')
                                                                    .withEmail('redacted.mailadress@example.com')
                                                                //TODO MISSING TYPE
                                                            )
                                                            .withPublishLevel(
                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                            )
                                                            .withProductDeliveryAsap(false)
                                                            .withId(0)
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                            )
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                            .withProductCode('TPSRAB6NP')
                                                            .withProductCategory(
                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.VAS
                                                            )
                                                            .withQuantity(1)
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                            )
                                                            .withId(0)
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                            .withProductCode('9047807')
                                                            .withProductCategory(
                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                            )
                                                            .withQuantity(1)
                                                            .withSimDetailsBuilder(
                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                    .withSimType(
                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_ELECTRONIC_SIM
                                                                    )
                                                                    .withIcc('89450401220312168545')
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                            )
                                                            .withId(0)
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.PortingDetailsItemBuilder()
                                                            .withDonorSimNumber('89450401220312170491')
                                                            .withPoaDocumentUrl(
                                                                'http://ms.prod.aws.telia.dk:9680/document/REDACTED/attachment/REDACTED'
                                                            )
                                                            .withPowerOfAttorneyManualHandling(true)
                                                            //TODO DOCUMENTID
                                                            .withEarliestPortingDate(Date.valueOf('2023-08-01'))
                                                            .withPortAfterCommitment(false)
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.PORTING_DETAILS_ITEM
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withId(0)
                                                    )
                                            )
                                    )
                            )
                    )
            )
            .withSegment(OrderClientDTOEnums.OrderV10SegmentEnum.B2B)
            .withCreatedBy('redacted.mailadress@example.com');

        OrderClientDTO.OrderV10 order = orderBuilder.build();

        Assert.areEqual(order.createdBy, 'redacted.mailadress@example.com');
        Assert.areEqual(
            order.orderParts.get(0).orderParts.get(0).orderItems.get(0).type,
            OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
        );
    }

    @IsTest
    static void VTPX_SubscriptionForNewNumber() {
        OrderClientDTOBuilder.OrderV10Builder orderBuilder = new OrderClientDTOBuilder.OrderV10Builder();
        orderBuilder.withBrand(OrderClientDTOEnums.Brand.TELIADK)
            .withChannel('WEBSHOP')
            .withSegment(OrderClientDTOEnums.OrderV10SegmentEnum.B2C)
            .withDealerBuilder(new OrderClientDTOBuilder.DealerBuilder().withDealerCode('2306'))
            .withHardwareDeliveryListBuilder(
                new OrderClientDTOBuilder.HardwareDeliveryListBuilder()
                    .withHardwareDeliveryBuilder(
                        new OrderClientDTOBuilder.HardwareDeliveryBuilder()
                            .withDeliveryMethod('POST')
                            .withId(1)
                            .withPreferredContactMethod(
                                OrderClientDTOEnums.HardwareDeliveryPreferredContactMethodEnum.PHONE
                            )
                            .withBillingPartyRoleBuilder(
                                new OrderClientDTOBuilder.PersonBuilder()
                                    .withFirstName('Rasmus')
                                    .withLastName('Haas')
                                    .withEmail('markus.z.wallen@teliacompany.com')
                                    .withTelephoneNumberBuilder(
                                        new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                            .withCountryCode('45')
                                            .withPhoneNumber('88776655')
                                    )
                                    .withAddressBuilder(
                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                            //TODO DANISH_ADDRESS_TYPE WAS ADDED?
                                            .withStreetName('Rubyvej')
                                            .withStreetNumber('8')
                                            .withStreetNumberSuffix('B')
                                            .withFloorNumber('1')
                                            .withDoorNumber('3')
                                            .withCity('Odense N')
                                            .withZipCode('5270')
                                            .withCountry('DNK')
                                    )
                                    .withType('PERSON')
                            )
                            .withRecipientPartyRoleBuilder(
                                new OrderClientDTOBuilder.PersonBuilder()
                                    .withFirstName('Rasmus')
                                    .withLastName('Haas')
                                    .withEmail('markus.z.wallen@teliacompany.com')
                                    .withTelephoneNumberBuilder(
                                        new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                            .withCountryCode('45')
                                            .withPhoneNumber('88776655')
                                    )
                                    .withAddressBuilder(
                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                            //TODO DANISH_ADDRESS_TYPE WAS ADDED?
                                            .withStreetName('Rubyvej')
                                            .withStreetNumber('8')
                                            .withStreetNumberSuffix('B')
                                            .withFloorNumber('1')
                                            .withDoorNumber('3')
                                            .withCity('Odense N')
                                            .withZipCode('5270')
                                            .withCountry('DNK')
                                    )
                                    .withType('PERSON')
                            )
                            .withDeliveryPriceAmountBuilder(
                                new OrderClientDTOBuilder.AmountBuilder()
                                    .withCurrency(OrderClientDTOEnums.AmountCurrencyEnum.DKK)
                                    .withAmount(0)
                                    .withVAT(0)
                            )
                    )
            )
            .withOrdererPartyRoleBuilder(
                new OrderClientDTOBuilder.PersonBuilder()
                    .withCpr('070593-4134')
                    .withFirstName('Rasmus')
                    .withLastName('Haas')
                    .withEmail('markus.z.wallen@teliacompany.com')
                    .withTelephoneNumberBuilder(
                        new OrderClientDTOBuilder.TelephoneNumberBuilder().withCountryCode('45').withPhoneNumber('88776655')
                    )
                    .withAddressBuilder(
                        new OrderClientDTOBuilder.DanishAddressBuilder()
                            //TODO DANISH_ADDRESS_TYPE WAS ADDED?
                            .withStreetName('Rubyvej')
                            .withStreetNumber('8')
                            .withStreetNumberSuffix('B')
                            .withFloorNumber('1')
                            .withDoorNumber('3')
                            .withCity('Odense N')
                            .withZipCode('5270')
                            .withCountry('DNK')
                    )
                    .withType('PERSON')
            )
            .withOrderPartListBuilder(
                new OrderClientDTOBuilder.OrderPartListBuilder()
                    .withOrderPartBuilder(
                        new OrderClientDTOBuilder.OrderPartBuilder()
                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CREATE)
                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT)
                            .withOrderItemListBuilder(
                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                    .withOrderItemBuilder(
                                        new OrderClientDTOBuilder.AccountItemBuilder()
                                            .withlegalPartyBuilder(
                                                new OrderClientDTOBuilder.PersonBuilder()
                                                    .withFirstName('Tuba Demir')
                                                    .withLastName('van der Burg')
                                                    .withBirthday(Date.valueOf('1981-01-12'))
                                                    .withCpr('120181-3790')
                                                    .withEmail('shirish.patil@teliacompany.com')
                                                    .withTelephoneNumberBuilder(
                                                        new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                            .withCountryCode('45')
                                                            .withPhoneNumber('23232323')
                                                    )
                                                    .withAddressBuilder(
                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                            .withStreetName('Nordre Fasanvej')
                                                            .withStreetNumber('33')
                                                            .withStreetNumberSuffix('B')
                                                            .withFloorNumber('04')
                                                            .withCity('Frederiksberg')
                                                            .withZipCode('2000')
                                                            .withCountry('DNK')
                                                    )
                                                    .withType('PERSON')
                                            )
                                            .withBillingPartyBuilder(
                                                new OrderClientDTOBuilder.PersonBuilder()
                                                    .withFirstName('Tuba Demir')
                                                    .withLastName('van der Burg')
                                                    .withBirthday(Date.valueOf('1981-01-12'))
                                                    .withCpr('120181-3790')
                                                    .withEmail('shirish.patil@teliacompany.com')
                                                    .withTelephoneNumberBuilder(
                                                        new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                            .withCountryCode('45')
                                                            .withPhoneNumber('23232323')
                                                    )
                                                    .withAddressBuilder(
                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                            .withStreetName('Nordre Fasanvej')
                                                            .withStreetNumber('33')
                                                            .withStreetNumberSuffix('B')
                                                            .withFloorNumber('04')
                                                            .withCity('Frederiksberg')
                                                            .withZipCode('2000')
                                                            .withCountry('DNK')
                                                    )
                                                    .withType('PERSON')
                                            )
                                            .withPaymentMethod(OrderClientDTOEnums.PaymentMethod.GIRO)
                                            .withBillingCycle(
                                                OrderClientDTOEnums.AccountItemBillingCycleEnum.MONTHLY
                                            )
                                            .withInvoiceType(
                                                OrderClientDTOEnums.AccountItemInvoiceTypeEnum.PAPER_INVOICE
                                            )
                                            .withType(OrderClientDTOEnums.OrderItemTypeEnum.ACCOUNT_ITEM)
                                            .withActivity(OrderClientDTOEnums.OrderItemActivityEnum.CREATE)
                                    )
                                    .withOrderItemBuilder(
                                        new OrderClientDTOBuilder.FeeItemBuilder()
                                            .withFeeType(OrderClientDTOEnums.FeeItemFeeTypeEnum.ADMIN_FEE_GIRO)
                                            .withDisplayName('GIRO payment fee')
                                            .withPriceAmountBuilder(
                                                new OrderClientDTOBuilder.AmountBuilder()
                                                    .withCatalogAmount(49)
                                                    .withCatalogVat(9.8)
                                                    .withCurrency(OrderClientDTOEnums.AmountCurrencyEnum.DKK)
                                            )
                                            .withActivity(OrderClientDTOEnums.OrderItemActivityEnum.CREATE)
                                            .withType(OrderClientDTOEnums.OrderItemTypeEnum.FEE_ITEM)
                                    )
                            )
                            .withOrderPartListBuilder(
                                new OrderClientDTOBuilder.OrderPartListBuilder()
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION)
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CREATE)
                                            .withOrderItemListBuilder(
                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                            .withTelephoneNumberBuilder(
                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                    .withPhoneNumber('27726643')
                                                                    .withCountryCode('45')
                                                            )
                                                            .withTelephoneNumberCategory(
                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                            )
                                                            .withTerminationPeriodBuilder(
                                                                new OrderClientDTOBuilder.TimePeriodBuilder()
                                                                    .withAmount(0)
                                                                    .withTimePeriod(
                                                                        OrderClientDTOEnums.TimeUnit.DAY
                                                                    )
                                                            )
                                                            .withNewOfferingBuilder(
                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                    .withPriceplan('CHAMPEBA')
                                                                    .withCampaign('CHAMPEBAS')
                                                                //TODO MISSING productOfferingId
                                                            )
                                                            .withProductType(
                                                                OrderClientDTOEnums.SubscriptionItemProductTypeEnum.MOBILE_VOICE
                                                            )
                                                            .withSubscriptionUserBuilder(
                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                    .withLastName('Havrlantova')
                                                                    .withBirthDate(Date.valueOf('1981-01-12'))
                                                                    .withEmail('miroslava.havrlantova@teliacompany.com')
                                                                    .withAddressBuilder(
                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                            //TODO DANISH_ADDRESS_TYPE WAS ADDED?
                                                                            .withStreetName('Rubyvej')
                                                                            .withStreetNumber('8')
                                                                            .withCity('Odense N')
                                                                            .withZipCode('5270')
                                                                            .withCountry('DNK')
                                                                            .withCoName('Odense N')
                                                                    )
                                                            )
                                                            .withPublishLevel(
                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                            )
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                            .withProductCategory(
                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                            )
                                                            .withSimDetailsBuilder(
                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                    .withSimType(
                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM
                                                                    )
                                                            )
                                                            .withShippingDetailsBuilder(
                                                                new OrderClientDTOBuilder.ShippingDetailsBuilder()
                                                                    .withERPTSProduct('TSA1000159')
                                                                    .withHardwareDeliveryId(1)
                                                                    .withToDeliverQuantity(1)
                                                                    .withTSFOffering('TSF1005448')
                                                            )
                                                            .withHardwareDetailsBuilder(
                                                                new OrderClientDTOBuilder.HardwareDetailsBuilder()
                                                                    .withHardwareType(
                                                                        OrderClientDTOEnums.HardwareType.SIM
                                                                    )
                                                                    .withMaterialId('9064434')
                                                                    .withName('micro SIM')
                                                            )
                                                            .withQuantity(1)
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                            )
                                                    )
                                            )
                                    )
                            )
                    )
            );

        OrderClientDTO.OrderV10 order = orderBuilder.build();

        Assert.areEqual(
            order.orderParts.get(0).orderParts.get(0).orderItems.get(0).type,
            OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
        );
    }

    @IsTest
    static void VTPX_SubscriptionWithPhysicalSim() {
        OrderClientDTOBuilder.OrderV10Builder orderBuilder = new OrderClientDTOBuilder.OrderV10Builder();
        orderBuilder.withChannel('SALES_FORCE')
            .withDealerBuilder(new OrderClientDTOBuilder.DealerBuilder().withDealerCode('2306'))
            .withHardwareDeliveryListBuilder(
                new OrderClientDTOBuilder.HardwareDeliveryListBuilder()
                    .withHardwareDeliveryBuilder(
                        new OrderClientDTOBuilder.HardwareDeliveryBuilder()
                            .withDeliveryMethod('POST')
                            .withId(1)
                            .withPreferredContactMethod(
                                OrderClientDTOEnums.HardwareDeliveryPreferredContactMethodEnum.PHONE
                            )
                            .withRecipientPartyRoleBuilder(
                                new OrderClientDTOBuilder.OrganizationBuilder()
                                    .withCvr('12077611')
                                    .withName('TestChildCompany')
                                    .withEmail('test@telia.dk')
                                    .withTelephoneNumberBuilder(
                                        new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                            .withPhoneNumber('88776655')
                                            .withCountryCode('45')
                                    )
                                    .withAddressBuilder(
                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                            //TODO DANISH_ADDRESS_TYPE WAS ADDED?
                                            .withStreetName('Rubyvej')
                                            .withDirection('tv')
                                            .withStreetNumber('8')
                                            .withStreetNumberSuffix('B')
                                            .withFloorNumber('1')
                                            .withDoorNumber('3')
                                            .withZipCode('5270')
                                            .withAttention('Janne Jensen')
                                            .withCity('Odense N')
                                    )
                                    .withType('ORGANIZATION')
                            )
                    )
            )
            .withOrderPartListBuilder(
                new OrderClientDTOBuilder.OrderPartListBuilder()
                    .withOrderPartBuilder(
                        new OrderClientDTOBuilder.OrderPartBuilder()
                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CHANGE)
                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT)
                            .withOrderPartReferenceListBuilder(
                                new OrderClientDTOBuilder.OrderPartReferenceListBuilder()
                                    .withOrderPartReferenceBuilder(
                                        new OrderClientDTOBuilder.OrderPartReferenceBuilder()
                                            .withType(
                                                OrderClientDTOEnums.OrderPartReferenceTypeEnum.BILLING_ACCOUNT_NUMBER
                                            )
                                            .withValue('460372212')
                                    )
                            )
                            .withOrderPartListBuilder(
                                new OrderClientDTOBuilder.OrderPartListBuilder()
                                    .withOrderPartBuilder(
                                        new OrderClientDTOBuilder.OrderPartBuilder()
                                            .withOrderItemListBuilder(
                                                new OrderClientDTOBuilder.OrderItemListBuilder()
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.SubscriptionItemBuilder()
                                                            .withNewOfferingBuilder(
                                                                new OrderClientDTOBuilder.OfferingBuilder()
                                                                    .withCampaign('CHAMPEBAS')
                                                                    .withPriceplan('CHAMPEBA')
                                                            )
                                                            .withProductType(
                                                                OrderClientDTOEnums.SubscriptionItemProductTypeEnum.MOBILE_VOICE
                                                            )
                                                            .withPublishLevel(
                                                                OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ALL_INFORMATION_PROVIDED
                                                            )
                                                            .withSubscriptionUserBuilder(
                                                                new OrderClientDTOBuilder.SubscriptionUserBuilder()
                                                                    .withAddressBuilder(
                                                                        new OrderClientDTOBuilder.DanishAddressBuilder()
                                                                            .withStreetName('Rubyvej')
                                                                            .withStreetNumber('8')
                                                                            .withZipCode('5270')
                                                                            .withCity('Odense N')
                                                                            .withCoName('Odense N')
                                                                            .withCountry('DNK')
                                                                    )
                                                                    .withBirthDate(Date.valueOf('1987-08-08'))
                                                                    .withEmail('miroslava.havrlantova@teliacompany.com')
                                                                    .withFirstName('Mirka')
                                                                    .withLastName('Havrlantova')
                                                            )
                                                            .withTelephoneNumberCategory(
                                                                OrderClientDTOEnums.SubscriptionItemTelephoneNumberCategoryEnum.MOBILE
                                                            )
                                                            .withTelephoneNumberBuilder(
                                                                new OrderClientDTOBuilder.TelephoneNumberBuilder()
                                                                    .withCountryCode('45')
                                                                    .withPhoneNumber('28968332')
                                                            )
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
                                                            )
                                                    )
                                                    .withOrderItemBuilder(
                                                        new OrderClientDTOBuilder.AdditionalProductItemBuilder()
                                                            .withProductCategory(
                                                                OrderClientDTOEnums.AdditionalProductItemProductCategoryEnum.SIM
                                                            )
                                                            .withSimDetailsBuilder(
                                                                new OrderClientDTOBuilder.SimDetailsBuilder()
                                                                    .withSimType(
                                                                        OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM
                                                                    )
                                                            )
                                                            .withShippingDetailsBuilder(
                                                                new OrderClientDTOBuilder.ShippingDetailsBuilder()
                                                                    .withERPTSProduct('TSA1000159')
                                                                    .withHardwareDeliveryId(1)
                                                                    .withToDeliverQuantity(1)
                                                                    .withTSFOffering('TSF1005448')
                                                            )
                                                            .withHardwareDetailsBuilder(
                                                                new OrderClientDTOBuilder.HardwareDetailsBuilder()
                                                                    .withHardwareType(
                                                                        OrderClientDTOEnums.HardwareType.SIM
                                                                    )
                                                                    .withMaterialId('9064434')
                                                                    .withName('micro SIM')
                                                            )
                                                            .withQuantity(1)
                                                            .withActivity(
                                                                OrderClientDTOEnums.OrderItemActivityEnum.CREATE
                                                            )
                                                            .withType(
                                                                OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM
                                                            )
                                                    )
                                            )
                                            .withType(OrderClientDTOEnums.OrderPartTypeEnum.SUBSCRIPTION)
                                            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CREATE)
                                    )
                            )
                    )
            );

        OrderClientDTO.OrderV10 order = orderBuilder.build();

        Assert.areEqual(
            order.orderParts.get(0).orderParts.get(0).orderItems.get(0).type,
            OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM
        );
    }

    // Test builder pattern initialization
    @isTest
    static void testBaseAddressBuilderInitialization() {
        OrderClientDTOBuilder.AddressBuilder baseBuilder = new OrderClientDTOBuilder.AddressBuilder();
        Assert.isTrue(baseBuilder != null, 'Base builder should not be null');
    }

    // Test fluent interface methods
    @isTest
    static void testFluentInterfaceMethods() {
        OrderClientDTOBuilder.AddressBuilder builder = new OrderClientDTOBuilder.AddressBuilder()
            .withCoName('Test Company')
            .withCity('San Francisco')
            .withZipCode('94101')
            .withCountry('USA')
            .withAttention('John Doe');

        OrderClientDTO.Address address = builder.build();

        Assert.areEqual('Test Company', address.coName, 'Company name should match');
        Assert.areEqual('San Francisco', address.city, 'City should match');
        Assert.areEqual('94101', address.zipCode, 'Zip code should match');
        Assert.areEqual('USA', address.country, 'Country should match');
        Assert.areEqual('John Doe', address.attention, 'Attention should match');
    }

    // Test OrderClientDTOBuilder.UnstructuredAddressBuilder
    @isTest
    static void testUnstructuredAddressBuilder() {
        OrderClientDTOBuilder.UnstructuredAddressBuilder unstructuredBuilder = new OrderClientDTOBuilder.UnstructuredAddressBuilder()
            .withAddress1('123 Main St')
            .withAddress2('Suite 456')
            .withAddress3('Building A');

        OrderClientDTO.UnstructuredAddress unstructuredAddress = (OrderClientDTO.UnstructuredAddress) unstructuredBuilder.build();

        Assert.areEqual(
            OrderClientDTOEnums.AddressTypeEnum.UNSTRUCTURED_ADDRESS,
            unstructuredAddress.addressType,
            'Address type should be UNSTRUCTURED'
        );
        Assert.areEqual('123 Main St', unstructuredAddress.address1, 'Address line 1 should match');
        Assert.areEqual('Suite 456', unstructuredAddress.address2, 'Address line 2 should match');
        Assert.areEqual('Building A', unstructuredAddress.address3, 'Address line 3 should match');
    }

    // Test DanishAddressBuilder
    @isTest
    static void testDanishAddressBuilder() {
        OrderClientDTOBuilder.DanishAddressBuilder danishBuilder = new OrderClientDTOBuilder.DanishAddressBuilder()
            .withStreetName('Øster Voldgade')
            .withStreetNumber('4')
            .withFloorNumber('3')
            .withDoorNumber('th')
            .withDirection('N')
            .withLocality('København K')
            .withStreetNumberSuffix('b');

        OrderClientDTO.DanishAddress danishAddress = (OrderClientDTO.DanishAddress) danishBuilder.build();

        Assert.areEqual(
            OrderClientDTOEnums.AddressTypeEnum.DANISH_ADDRESS,
            danishAddress.addressType,
            'Address type should be DANISH'
        );
        Assert.areEqual('Øster Voldgade', danishAddress.streetName, 'Street name should match');
        Assert.areEqual('4', danishAddress.streetNumber, 'Street number should match');
        Assert.areEqual('3', danishAddress.floorNumber, 'Floor number should match');
        Assert.areEqual('th', danishAddress.doorNumber, 'Door number should match');
        Assert.areEqual('N', danishAddress.direction, 'Direction should match');
        Assert.areEqual('København K', danishAddress.locality, 'Locality should match');
    }

    // Test builder chain validation
    @isTest
    static void testBuilderChainValidation() {
        OrderClientDTOBuilder.AddressBuilder builder = new OrderClientDTOBuilder.AddressBuilder();

        // Verify fluent interface maintains state
        String testValue = 'Test Value';
        builder.withCoName(testValue);
        OrderClientDTO.Address address = builder.build();
        Assert.areEqual(testValue, address.coName, 'Builder chain should maintain state');
    }

    // Test null handling
    @isTest
    static void testNullHandling() {
        OrderClientDTOBuilder.AddressBuilder builder = new OrderClientDTOBuilder.AddressBuilder();
        OrderClientDTO.Address address = builder.build();

        // Verify no NullPointerException occurs
        Assert.isTrue(address != null, 'Address should not be null');
    }

    // Test AmountBuilder
    @isTest
    static void testAmountBuilder() {
        OrderClientDTOBuilder.AmountBuilder builder = new OrderClientDTOBuilder.AmountBuilder()
            .withAmount(TEST_AMOUNT)
            .withVAT(TEST_VAT)
            .withCurrency(OrderClientDTOEnums.AmountCurrencyEnum.DKK)
            .withCatalogAmount(TEST_AMOUNT)
            .withCatalogVat(TEST_VAT);

        OrderClientDTO.Amount amount = builder.build();

        Assert.areEqual(TEST_AMOUNT, amount.amount);
        Assert.areEqual(TEST_VAT, amount.vat);
        Assert.areEqual(OrderClientDTOEnums.AmountCurrencyEnum.DKK, amount.currency_x);
        Assert.areEqual(TEST_AMOUNT, amount.catalogAmount);
        Assert.areEqual(TEST_VAT, amount.catalogVat);
        Assert.isNull(amount.discount);
    }

    @isTest
    static void testAmountBuilderWithDiscount() {
        OrderClientDTOBuilder.DiscountBuilder discountBuilder = new OrderClientDTOBuilder.DiscountBuilder()
            .withAmount(TEST_AMOUNT)
            .withPercentage(TEST_PERCENTAGE)
            .withComment(TEST_STRING);

        OrderClientDTOBuilder.AmountBuilder builder = new OrderClientDTOBuilder.AmountBuilder()
            .withAmount(TEST_AMOUNT)
            .withVAT(TEST_VAT)
            .withCurrency(OrderClientDTOEnums.AmountCurrencyEnum.DKK)
            .withCatalogAmount(TEST_AMOUNT)
            .withCatalogVat(TEST_VAT)
            .withDiscountBuilder(discountBuilder);

        OrderClientDTO.Amount amount = builder.build();

        Assert.areEqual(TEST_AMOUNT, amount.amount);
        Assert.areEqual(TEST_VAT, amount.vat);
        Assert.areEqual(OrderClientDTOEnums.AmountCurrencyEnum.DKK, amount.currency_x);
        Assert.areEqual(TEST_AMOUNT, amount.catalogAmount);
        Assert.areEqual(TEST_VAT, amount.catalogVat);
        Assert.isNotNull(amount.discount);
    }

    // Test BankBuilder
    @isTest
    static void testBankBuilder() {
        OrderClientDTOBuilder.BankBuilder builder = new OrderClientDTOBuilder.BankBuilder()
            .withAccountNumber(TEST_STRING)
            .withBranch(TEST_STRING)
            .withName(TEST_STRING);

        OrderClientDTO.Bank bank = builder.build();

        Assert.areEqual(TEST_STRING, bank.accountNumber);
        Assert.areEqual(TEST_STRING, bank.branch);
        Assert.areEqual(TEST_STRING, bank.name);
    }

    // Test BankAccountBuilder
    @isTest
    static void testBankAccountBuilder() {
        OrderClientDTOBuilder.BankAccountBuilder builder = new OrderClientDTOBuilder.BankAccountBuilder()
            .withBankName(TEST_STRING)
            .withBankBranchCode(TEST_STRING)
            .withAccountNumber(TEST_STRING);

        OrderClientDTO.BankAccount account = builder.build();

        Assert.areEqual(TEST_STRING, account.bankName);
        Assert.areEqual(TEST_STRING, account.bankBranchCode);
        Assert.areEqual(TEST_STRING, account.accountNumber);
    }

    // Test ChangeActivationDateOrderPatchBuilder
    @isTest
    static void testChangeActivationDateOrderPatchBuilder() {
        OrderClientDTOBuilder.ChangeActivationDateOrderPatchBuilder builder = new OrderClientDTOBuilder.ChangeActivationDateOrderPatchBuilder()
            .withNewActivationDate(TEST_DATE)
            .withTeliaCircuitId(TEST_STRING);

        OrderClientDTO.ChangeActivationDateOrderPatch patch = builder.build();

        Assert.areEqual(TEST_DATE, patch.newActivationDate);
        Assert.areEqual(TEST_STRING, patch.teliaCircuitId);
    }

    // Test ConsentBuilder
    @isTest
    static void testConsentBuilder() {
        OrderClientDTOBuilder.PhysicalIdentificationBuilder physicalBuilder = new OrderClientDTOBuilder.PhysicalIdentificationBuilder(); // Assuming this exists

        OrderClientDTOBuilder.ConsentBuilder builder = new OrderClientDTOBuilder.ConsentBuilder()
            .withWrittenConsentGiven(true)
            .withConsentByIdPhysicalIdentificationBuilder(physicalBuilder);

        OrderClientDTO.Consent myConsent = builder.build();

        Assert.areEqual(true, myConsent.writtenConsentGiven);
        Assert.isNotNull(myConsent.consentById);
    }

    // Test CreditCardBuilder
    @isTest
    static void testCreditCardBuilder() {
        OrderClientDTOBuilder.CreditCardBuilder builder = new OrderClientDTOBuilder.CreditCardBuilder()
            .withName(TEST_STRING)
            .withMaskedPan(TEST_STRING)
            .withToken(TEST_STRING)
            .withExpirationDate(TEST_DATE);

        OrderClientDTO.CreditCard card = builder.build();

        Assert.areEqual(TEST_STRING, card.name);
        Assert.areEqual(TEST_STRING, card.maskedPan);
        Assert.areEqual(TEST_STRING, card.token);
        Assert.areEqual(TEST_DATE, card.expirationDate);
    }

    // Test CreditEvaluationDetailsBuilder
    @isTest
    static void testCreditEvaluationDetailsBuilder() {
        OrderClientDTOBuilder.CreditEvaluationDetailsBuilder builder = new OrderClientDTOBuilder.CreditEvaluationDetailsBuilder()
            .withEmploymentType(OrderClientDTOEnums.CreditEvaluationDetailsEmploymentTypeEnum.EMPLOYEE)
            .withResidentialStatus(OrderClientDTOEnums.CreditEvaluationDetailsResidentialStatusEnum.RENTING)
            .withPaymentMethod(OrderClientDTOEnums.PaymentMethod.CARD)
            .withCreditLimit(TEST_AMOUNT)
            .withCreditClass(TEST_STRING);

        OrderClientDTO.CreditEvaluationDetails details = builder.build();

        Assert.areEqual(
            OrderClientDTOEnums.CreditEvaluationDetailsEmploymentTypeEnum.EMPLOYEE,
            details.employmentType
        );
        Assert.areEqual(
            OrderClientDTOEnums.CreditEvaluationDetailsResidentialStatusEnum.RENTING,
            details.residentialStatus
        );
        Assert.areEqual(OrderClientDTOEnums.PaymentMethod.CARD, details.paymentMethod);
        Assert.areEqual(TEST_AMOUNT, details.creditLimit);
        Assert.areEqual(TEST_STRING, details.creditClass);
    }

    // Test DealerBuilder
    @isTest
    static void testDealerBuilder() {
        OrderClientDTOBuilder.DealerBuilder builder = new OrderClientDTOBuilder.DealerBuilder()
            .withDealerName(TEST_STRING)
            .withDealerCode(TEST_STRING)
            .withSalesAgentCode(TEST_STRING)
            .withSalesAgentName(TEST_STRING)
            .withPosDealerId(TEST_STRING)
            .withPosSalesAgentId(TEST_STRING);

        OrderClientDTO.Dealer dealer = builder.build();

        Assert.areEqual(TEST_STRING, dealer.dealerName);
        Assert.areEqual(TEST_STRING, dealer.dealerCode);
        Assert.areEqual(TEST_STRING, dealer.salesAgentCode);
        Assert.areEqual(TEST_STRING, dealer.salesAgentName);
        Assert.areEqual(TEST_STRING, dealer.posDealerId);
        Assert.areEqual(TEST_STRING, dealer.posSalesAgentId);
    }

    // Test DiscountBuilder
    @isTest
    static void testDiscountBuilder() {
        OrderClientDTOBuilder.DiscountBuilder builder = new OrderClientDTOBuilder.DiscountBuilder()
            .withAmount(TEST_AMOUNT)
            .withVAT(TEST_VAT)
            .withPercentage(TEST_PERCENTAGE)
            .withComment(TEST_STRING)
            .withReason(TEST_STRING);

        OrderClientDTO.Discount discount = builder.build();

        Assert.areEqual(TEST_AMOUNT, discount.amount);
        Assert.areEqual(TEST_VAT, discount.vat);
        Assert.areEqual(TEST_PERCENTAGE, discount.percentage);
        Assert.areEqual(TEST_STRING, discount.comment);
        Assert.areEqual(TEST_STRING, discount.reason);
    }

    @isTest
    static void testDocumentBuilder() {
        OrderClientDTOBuilder.DocumentBuilder builder = new OrderClientDTOBuilder.DocumentBuilder()
            .withDocumentType(TEST_STRING)
            .withUrl(TEST_STRING);

        OrderClientDTO.Document doc = builder.build();

        Assert.areEqual(TEST_STRING, doc.documentType);
        Assert.areEqual(TEST_STRING, doc.url);
    }

    @isTest
    static void testDownPaymentPlanBuilder() {
        // Arrange
        OrderClientDTOBuilder.PaymentAmountBuilder mockDownPaymentAmount = new OrderClientDTOBuilder.PaymentAmountBuilder();
        OrderClientDTOBuilder.PaymentAmountBuilder mockInstallmentAmount = new OrderClientDTOBuilder.PaymentAmountBuilder();

        // Act
        OrderClientDTOBuilder.DownPaymentPlanBuilder builder = new OrderClientDTOBuilder.DownPaymentPlanBuilder()
            .withDownPaymentType(OrderClientDTOEnums.DownPaymentPlanDownPaymentTypeEnum.CREDIT_AGREEMENT)
            .withCreditProvider(OrderClientDTOEnums.DownPaymentPlanCreditProviderEnum.TELIA_DK)
            .withDownPaymentAmountBuilder(mockDownPaymentAmount)
            .withInstallmentAmountBuilder(mockInstallmentAmount)
            .withNumberOfInstallments(12);

        OrderClientDTO.DownPaymentPlan plan = builder.build();

        // Assert
        Assert.areEqual(
            OrderClientDTOEnums.DownPaymentPlanDownPaymentTypeEnum.CREDIT_AGREEMENT,
            plan.downPaymentType
        );
        Assert.areEqual(OrderClientDTOEnums.DownPaymentPlanCreditProviderEnum.TELIA_DK, plan.creditProvider);
        Assert.areEqual(12, plan.numberOfInstallments);
        Assert.areNotEqual(null, plan.downPaymentAmount);
        Assert.areNotEqual(null, plan.installmentAmount);
    }

    @isTest
    static void testErrorContentBuilder() {
        // Arrange
        OrderClientDTOBuilder.ErrorParameterListBuilder mockParams = new OrderClientDTOBuilder.ErrorParameterListBuilder();
        mockParams.withErrorParameterBuilder(new OrderClientDTOBuilder.ErrorParameterBuilder());

        // Act
        OrderClientDTOBuilder.ErrorContentBuilder builder = new OrderClientDTOBuilder.ErrorContentBuilder()
            .withCode('ERROR_001')
            .withMessage('Test Error Message')
            .withErrorParameterListBuilder(mockParams);

        OrderClientDTO.ErrorContent errorContent = builder.build();

        // Assert
        Assert.areEqual('ERROR_001', errorContent.code);
        Assert.areEqual('Test Error Message', errorContent.message);
        Assert.areNotEqual(null, errorContent.parameters);
    }

    @isTest
    static void testErrorResponseBuilder() {
        // Act
        OrderClientDTOBuilder.ErrorResponseBuilder builder = new OrderClientDTOBuilder.ErrorResponseBuilder()
            .withErrorContentBuilder(new OrderClientDTOBuilder.ErrorContentBuilder());

        OrderClientDTO.ErrorResponse response = builder.build();

        // Assert
        Assert.areNotEqual(null, response.error);
    }

    @isTest
    static void testFixedNetDetailsBuilder() {
        // Arrange
        OrderClientDTOBuilder.NetworkConfigurationListBuilder mockNetworkConfig = new OrderClientDTOBuilder.NetworkConfigurationListBuilder();
        mockNetworkConfig.withNetworkConfigurationBuilder(new OrderClientDTOBuilder.NetworkConfigurationBuilder());
        OrderClientDTOBuilder.OrderEventDetailListBuilder mockEvents = new OrderClientDTOBuilder.OrderEventDetailListBuilder();
        mockEvents.withOrderEventDetailsBuilder(new OrderClientDTOBuilder.OrderEventDetailsBuilder());
        OrderClientDTOBuilder.InstallationAddressBuilder mockInstallationAddr = new OrderClientDTOBuilder.InstallationAddressBuilder();
        OrderClientDTOBuilder.InstallationAddressBuilder mockAccessPointAddr = new OrderClientDTOBuilder.InstallationAddressBuilder();
        OrderClientDTOBuilder.FixedNetFlagsBuilder mockFlags = new OrderClientDTOBuilder.FixedNetFlagsBuilder();

        // Act
        OrderClientDTOBuilder.FixedNetDetailsBuilder builder = new OrderClientDTOBuilder.FixedNetDetailsBuilder()
            .withNetworkConfigurationListBuilder(mockNetworkConfig)
            .withEventsOrderEventDetailListBuilder(mockEvents)
            .withFixedNetFlagsBuilder(mockFlags)
            .withInstallationAddressBuilder(mockInstallationAddr)
            .withIastMileAccessPointAddressBuilder(mockAccessPointAddr)
            .withProviderAoCustomerRefNumber('withProviderAoCustomerRefNumber')
            .withDiggingDistance(50)
            .withSpeedProduct('100MB')
            .withTechnicalProduct('FTTH')
            .withSpeedDown('speedDown')
            .withSpeedUp('speedUp')
            .withAccessType('accessType')
            .withDslTechnologyType('dslTechnologyType')
            .withPreviousTdcCircuitId('previousTdcCircuitId')
            .withDestinationTdcCircuitId('destinationTdcCircuitId')
            .withPreviousLinePhoneNumber('previousLinePhoneNumber')
            .withDestinationLinePhoneNumber('destinationLinePhoneNumber')
            .withIpAddressType('ipAddressType')
            .withCpeMode('cpeMode')
            .withDslType('dslType')
            .withSla('sla')
            .withAddExtraBeChannel('addExtraBeChannel')
            .withAllowRedColor('addExtraBeChannel')
            .withFlowType('flowType')
            .withDoItYourselfInstallation('doItYourselfInstallation')
            .withDoItYourselfContactName('doItYourselfContactName')
            .withDoItYourselfContactNumber('doItYourselfContactNumber')
            .withProviderReuseOfAddress('providerReuseOfAddress')
            .withCurrentProviderName('currentProviderName')
            .withAoCustomerReference('aoCustomerReference')
            .withVendor('vendor')
            .withVendorProductCode('VendorProductCode')
            .withCustomerProductId('customerProductId')
            .withExistingVendorProductCode('existingVendorProductCode')
            .withPackageId('withPackageId')
            .withVendorProductCatalogId('withVendorProductCatalogId');

        OrderClientDTO.FixedNetDetails details = builder.build();

        // Assert
        Assert.areNotEqual(null, details.networkConfiguration);
        Assert.areNotEqual(null, details.events);
        Assert.areNotEqual(null, details.fixedNetFlags);
        Assert.areNotEqual(null, details.installationAddress);
        Assert.areNotEqual(null, details.lastMileAccessPointAddress);
        Assert.areEqual(50, details.diggingDistance);
        Assert.areEqual('100MB', details.speedProduct);
        Assert.areEqual('FTTH', details.technicalProduct);
    }

    @isTest
    static void testFixedNetFlagsBuilder() {
        // Act
        OrderClientDTOBuilder.FixedNetFlagsBuilder builder = new OrderClientDTOBuilder.FixedNetFlagsBuilder()
            .withSkipStateEvent(true)
            .withSkipCpeTechnician(false)
            .withSkipIp(true)
            .withSkipInvoice(false)
            .withHasInstallationTypeConflict(false)
            .withManualChangeProvider(true)
            .withCoaxDifferentProvider(true)
            .withDiggingNeeded(true)
            .withManualOrdering(false)
            .withMoveToDifferentAddress(true)
            .withLineTakeOver(true)
            .withActiveBlockingLinePresent(true)
            .withActiveLineTerminated(true)
            .withPlugPresentPositiveValidation(true)
            .withPlugPresentPositiveValidation(true)
            .withProviderChangeAccountNumberMissing(false)
            .withCustomerRequestsChangeProvider(true);

        OrderClientDTO.FixedNetFlags flags = builder.build();

        // Assert
        Assert.isTrue(flags.skipStateEvent);
        Assert.isFalse(flags.skipCpeTechnician);
        Assert.isTrue(flags.skipIp);
        Assert.isFalse(flags.skipInvoice);
    }

    @isTest
    static void testForwardingSettingBuilder() {
        // Act
        OrderClientDTOBuilder.ForwardingSettingBuilder builder = new OrderClientDTOBuilder.ForwardingSettingBuilder()
            .withEnabled(true)
            .withTargetNumber('+1234567890');

        OrderClientDTO.ForwardingSetting setting = builder.build();

        // Assert
        Assert.isTrue(setting.enabled);
        Assert.areEqual('+1234567890', setting.targetNumber);
    }

    @isTest
    static void testHardwareDeliveryBuilder() {
        // Arrange
        OrderClientDTOBuilder.PartyRoleBuilder mockRecipient = new OrderClientDTOBuilder.PartyRoleBuilder();
        OrderClientDTOBuilder.PartyRoleBuilder mockBilling = new OrderClientDTOBuilder.PartyRoleBuilder();
        OrderClientDTOBuilder.AmountBuilder mockDeliveryPrice = new OrderClientDTOBuilder.AmountBuilder();

        // Act
        OrderClientDTOBuilder.HardwareDeliveryBuilder builder = new OrderClientDTOBuilder.HardwareDeliveryBuilder()
            .withId(1)
            .withRecipientPartyRoleBuilder(mockRecipient)
            .withBillingPartyRoleBuilder(mockBilling)
            .withDeliveryMethod('STANDARD')
            .withDeliveryPriceAmountBuilder(mockDeliveryPrice)
            .withPreferredContactMethod(OrderClientDTOEnums.HardwareDeliveryPreferredContactMethodEnum.EMAIL)
            .withDispatchDate(DateTime.now())
            .withPreferredSendDate(DateTime.now().addDays(7));

        OrderClientDTO.HardwareDelivery delivery = builder.build();

        // Assert
        Assert.areEqual(1, delivery.id);
        Assert.areNotEqual(null, delivery.recipientParty);
        Assert.areNotEqual(null, delivery.billingParty);
        Assert.areEqual('STANDARD', delivery.deliveryMethod);
        Assert.areNotEqual(null, delivery.deliveryPrice);
        Assert.areEqual(
            OrderClientDTOEnums.HardwareDeliveryPreferredContactMethodEnum.EMAIL,
            delivery.preferredContactMethod
        );
    }

    @isTest
    static void testBuildersWithNullValues() {
        // Test DownPaymentPlanBuilder with null values
        OrderClientDTOBuilder.DownPaymentPlanBuilder dpBuilder = new OrderClientDTOBuilder.DownPaymentPlanBuilder()
            .withDownPaymentType(null)
            .withCreditProvider(null)
            .withNumberOfInstallments(null);

        OrderClientDTO.DownPaymentPlan dpPlan = dpBuilder.build();
        Assert.isNull(dpPlan.downPaymentType);
        Assert.isNull(dpPlan.creditProvider);
        Assert.isNull(dpPlan.numberOfInstallments);

        // Test ErrorContentBuilder with null values
        OrderClientDTOBuilder.ErrorContentBuilder ecBuilder = new OrderClientDTOBuilder.ErrorContentBuilder()
            .withCode(null)
            .withMessage(null)
            .withErrorParameterListBuilder(null);

        OrderClientDTO.ErrorContent ec = ecBuilder.build();
        Assert.isNull(ec.code);
        Assert.isNull(ec.message);
        Assert.isNull(ec.parameters);
    }

    @isTest
    public static void testHardwarePaymentConfigurationPatchBuilder() {
        // Create builders needed for testing
        OrderClientDTOBuilder.PaymentAmountBuilder totalAmountBuilder = new OrderClientDTOBuilder.PaymentAmountBuilder()
            .withAmount(1000.00)
            .withCurrency(OrderClientDTOEnums.PaymentAmountCurrencyEnum.DKK);

        OrderClientDTOBuilder.PaymentAmountBuilder upfrontAmountBuilder = new OrderClientDTOBuilder.PaymentAmountBuilder()
            .withAmount(500.00)
            .withCurrency(OrderClientDTOEnums.PaymentAmountCurrencyEnum.DKK);

        OrderClientDTOBuilder.PaymentAmountBuilder downAmountBuilder = new OrderClientDTOBuilder.PaymentAmountBuilder()
            .withAmount(300.00)
            .withCurrency(OrderClientDTOEnums.PaymentAmountCurrencyEnum.DKK);

        OrderClientDTOBuilder.DiscountBuilder discountBuilder = new OrderClientDTOBuilder.DiscountBuilder().withPercentage(10.0);

        // Create builder instance and set all properties
        OrderClientDTOBuilder.HardwarePaymentConfigurationPatchBuilder builder = new OrderClientDTOBuilder.HardwarePaymentConfigurationPatchBuilder()
            .withPaymentType(OrderClientDTOEnums.PaymentType.EXTERNAL_PAYMENT_SERVICE)
            .withTotalPaymentAmount(totalAmountBuilder)
            .withUpfrontPaymentAmount(upfrontAmountBuilder)
            .withDownPaymentAmount(downAmountBuilder)
            .withDiscount(discountBuilder)
            .withNumberOfInstallments(12);

        // Build the configuration
        OrderClientDTO.HardwarePaymentConfigurationPatch config = builder.build();

        // Verify all properties
        Assert.areEqual(
            OrderClientDTOEnums.PaymentType.EXTERNAL_PAYMENT_SERVICE,
            config.paymentType,
            'Payment Type should match'
        );
        Assert.areEqual(
            totalAmountBuilder.build().amount,
            config.totalPayment.amount,
            'Total Payment Amount should match'
        );
        Assert.areEqual(
            upfrontAmountBuilder.build().amount,
            config.upfrontPayment.amount,
            'Upfront Payment Amount should match'
        );
        Assert.areEqual(
            downAmountBuilder.build().amount,
            config.downPayment.amount,
            'Down Payment Amount should match'
        );
        Assert.areEqual(discountBuilder.build().amount, config.discount.amount, 'Discount should match');
        Assert.areEqual(12, config.numberOfInstallments, 'Number of Installments should match');
    }

    @isTest
    public static void testHomeOfficeOrderPatchBuilder() {
        OrderClientDTOBuilder.PersonBuilder legalPartyBuilder = (OrderClientDTOBuilder.PersonBuilder) new OrderClientDTOBuilder.PersonBuilder()
            .withFirstName('John')
            .withLastName('Doe')
            .withEmail('john@doe.com');

        OrderClientDTOBuilder.PersonBuilder billingPartyBuilder = (OrderClientDTOBuilder.PersonBuilder) new OrderClientDTOBuilder.PersonBuilder()
            .withFirstName('Jane')
            .withLastName('Smith')
            .withEmail('jane@smith.com');

        OrderClientDTOBuilder.InstallationAddressBuilder installationAddressBuilder = new OrderClientDTOBuilder.InstallationAddressBuilder()
            .withPostalAddressBuilder(new OrderClientDTOBuilder.AddressBuilder())
            .withStreetCode('STREET123')
            .withMunicipalityCode('MUN123')
            .withSiteId('SITE123')
            .withKvh('KVH123')
            .withKvhx('KVHX123')
            .withAddressRefId('ADDR123');

        OrderClientDTOBuilder.PersonBuilder recipientPartyBuilder = (OrderClientDTOBuilder.PersonBuilder) new OrderClientDTOBuilder.PersonBuilder()
            .withFirstName('Bob')
            .withLastName('Johnson')
            .withEmail('bob@johnson.com');

        OrderClientDTOBuilder.HomeOfficeOrderPatchBuilder builder = new OrderClientDTOBuilder.HomeOfficeOrderPatchBuilder()
            .withLegalParty(legalPartyBuilder)
            .withBillingParty(billingPartyBuilder)
            .withInstallationAddress(installationAddressBuilder)
            .withRecipientParty(recipientPartyBuilder)
            .withVendor('VENDOR123')
            .withEmployeeId('EMP123');

        OrderClientDTO.HomeOfficeOrderPatch orderPatch = builder.build();

        Assert.areEqual(legalPartyBuilder.build().email, orderPatch.legalParty.email, 'Legal Party should match');
        Assert.areEqual(billingPartyBuilder.build().email, orderPatch.billingParty.email, 'Billing Party should match');
        Assert.areEqual(
            installationAddressBuilder.build().kvhx,
            orderPatch.installationAddress.kvhx,
            'Installation Address should match'
        );
        Assert.areEqual(
            recipientPartyBuilder.build().email,
            orderPatch.recipientParty.email,
            'Recipient Party should match'
        );
        Assert.areEqual('VENDOR123', orderPatch.vendor, 'Vendor should match');
        Assert.areEqual('EMP123', orderPatch.employeeId, 'Employee Id should match');
    }

    @isTest
    public static void testInstallationAddressBuilder() {
        OrderClientDTOBuilder.InstallationAddressBuilder builder = new OrderClientDTOBuilder.InstallationAddressBuilder()
            .withPostalAddressBuilder(new OrderClientDTOBuilder.AddressBuilder().withCity('CITY'))
            .withStreetCode('STREET456')
            .withMunicipalityCode('MUN456')
            .withSiteId('SITE456')
            .withKvh('KVH456')
            .withKvhx('KVHX456')
            .withAddressRefId('ADDR456');

        OrderClientDTO.InstallationAddress address = builder.build();

        Assert.areEqual('CITY', address.postalAddress.CITY, 'Postal Address should match');
        Assert.areEqual('STREET456', address.streetCode, 'Street Code should match');
        Assert.areEqual('MUN456', address.municipalityCode, 'Municipality Code should match');
        Assert.areEqual('SITE456', address.siteId, 'Site Id should match');
        Assert.areEqual('KVH456', address.kvh, 'Kvh should match');
        Assert.areEqual('KVHX456', address.kvhx, 'Kvhx should match');
        Assert.areEqual('ADDR456', address.addressRefId, 'Address Ref Id should match');
    }

    @isTest
    public static void testIpConfigurationBuilder() {
        OrderClientDTOBuilder.IpConfigurationBuilder builder = new OrderClientDTOBuilder.IpConfigurationBuilder()
            .withIp('192.168.1.1')
            .withNetmask('255.255.255.0')
            .withDefaultGateway('192.168.1.254');

        OrderClientDTO.IpConfiguration config = builder.build();

        Assert.areEqual('192.168.1.1', config.ip, 'IP should match');
        Assert.areEqual('255.255.255.0', config.netmask, 'Netmask should match');
        Assert.areEqual('192.168.1.254', config.defaultGateway, 'Default Gateway should match');
    }

    @isTest
    public static void testMarketingConsentBuilder() {
        OrderClientDTOBuilder.MarketingConsentBuilder builder = new OrderClientDTOBuilder.MarketingConsentBuilder()
            .withLeadSourceId('LEAD123')
            .withDirectMarketing(true)
            .withTracking(false)
            .withUrl('https://example.com');

        OrderClientDTO.MarketingConsents consent = builder.build();

        Assert.areEqual('LEAD123', consent.leadSourceId, 'Lead Source Id should match');
        Assert.isTrue(consent.directMarketing, 'Direct Marketing should be true');
        Assert.isFalse(consent.tracking, 'Tracking should be false');
        Assert.areEqual('https://example.com', consent.url, 'URL should match');
    }

    @isTest
    static void testNetworkConfigurationBuilder_BasicProperties() {
        OrderClientDTOBuilder.NetworkConfigurationBuilder builder = new OrderClientDTOBuilder.NetworkConfigurationBuilder()
            .withCpeName('Test_CPE')
            .withQosProfileName('Standard_QoS')
            .withVrfName('Default_VRF')
            .withVpnInstance('vpn')
            .withPppMultilinkGroup('PppM')
            .withIpHelper('iphelp')
            .withRoutingProtocol('RoutingStuff')
            .withAsNumber('asNumber')
            .withTimeslots('timeSlots')
            .withInternetPorts('internetPorts')
            .withCpeSerial('withCpeSerial')
            .withMobileDialerIp('withMobileDialerIp')
            .withMobileCpeSerial('withMobileCpeSerial')
            .withMobileNetworkIp('withMobileNetworkIp')
            .withMobileNetworkNetmask('withMobileNetworkNetmask')
            .withProactivity('withProactivity')
            .withProactivityPhone('withProactivityPhone')
            .withLinkIpNetworkNetmask('withLinkIpNetworkNetmask')
            .withLinkIpNetworkIp('withLinkIpNetworkIp')
            .withLanIpAddressIp('withLanIpAddressIp')
            .withLanIpAddressNetmask('withLanIpAddressNetmask')
            .withLanIpAddressHsrip('withLanIpAddressHsrip')
            .withDhcpAddressRange('withDhcpAddressRange')
            .withDhcpLeaseTime('withDhcpLeaseTime')
            .withDhcpDomainName('withDhcpDomainName')
            .withDhcpWinsPrimary('withDhcpWinsPrimary')
            .withDhcpWinsSecondary('withDhcpWinsSecondary')
            .withDhcpDnsPrimary('withDhcpDnsPrimary')
            .withDhcpDnsSecondary('withDhcpDnsSecondary')
            .withSnmpCommunity('withSnmpCommunity');

        OrderClientDTO.NetworkConfiguration config = builder.build();

        Assert.areEqual('Test_CPE', config.cpeName);
        Assert.areEqual('Standard_QoS', config.qosProfileName);
        Assert.areEqual('Default_VRF', config.vrfName);
    }

    @isTest
    static void testNetworkConfigurationBuilder_NetworkProperties() {
        OrderClientDTOBuilder.NetworkConfigurationBuilder builder = new OrderClientDTOBuilder.NetworkConfigurationBuilder()
            .withLinkIpNetworkIp('192.168.1.1')
            .withLinkIpNetworkNetmask('255.255.255.0')
            .withLanIpAddressIp('10.0.0.1')
            .withLanIpAddressNetmask('255.255.255.0');

        OrderClientDTO.NetworkConfiguration config = builder.build();

        Assert.areEqual('192.168.1.1', config.linkIpNetworkIp);
        Assert.areEqual('255.255.255.0', config.linkIpNetworkNetmask);
        Assert.areEqual('10.0.0.1', config.lanIpAddressIp);
        Assert.areEqual('255.255.255.0', config.lanIpAddressNetmask);
    }

    @isTest
    static void testErrorParameterBuilder() {
        OrderClientDTOBuilder.ErrorParameterBuilder builder = new OrderClientDTOBuilder.ErrorParameterBuilder();

        builder.withName('name');
        builder.withValue('value');

        OrderClientDTO.ErrorParameter result = builder.build();

        Assert.areEqual('name', result.name);
        Assert.areEqual('value', result.value);
    }

    @isTest
    static void testNetworkConfigurationBuilder_DHCPProperties() {
        OrderClientDTOBuilder.NetworkConfigurationBuilder builder = new OrderClientDTOBuilder.NetworkConfigurationBuilder()
            .withDhcpAddressRange('192.168.1.100-192.168.1.200')
            .withDhcpLeaseTime('86400')
            .withDhcpDomainName('test.local')
            .withDhcpWinsPrimary('192.168.1.10')
            .withDhcpWinsSecondary('192.168.1.11');

        OrderClientDTO.NetworkConfiguration config = builder.build();

        Assert.areEqual('192.168.1.100-192.168.1.200', config.dhcpAddressRange);
        Assert.areEqual('86400', config.dhcpLeaseTime);
        Assert.areEqual('test.local', config.dhcpDomainName);
        Assert.areEqual('192.168.1.10', config.dhcpWinsPrimary);
        Assert.areEqual('192.168.1.11', config.dhcpWinsSecondary);
    }

    @isTest
    static void testNoAnswerForwardingSettingBuilder() {
        OrderClientDTOBuilder.NoAnswerForwardingSettingBuilder builder = new OrderClientDTOBuilder.NoAnswerForwardingSettingBuilder()
            .withEnabled(true)
            .withTargetNumber('+1234567890')
            .withDelay(30);

        OrderClientDTO.NoAnswerForwardingSetting setting = builder.build();

        Assert.isTrue(setting.enabled);
        Assert.areEqual('+1234567890', setting.targetNumber);
        Assert.areEqual(30, setting.delay);
    }

    @isTest
    static void testNotificationRecipientBuilder() {
        OrderClientDTOBuilder.NotificationRecipientBuilder builder = new OrderClientDTOBuilder.NotificationRecipientBuilder()
            .withRole(OrderClientDTOEnums.NotificationRecipientRoleEnum.CUSTOMER)
            .withEmail('test@example.com')
            .withTelephoneNumber('+9876543210');

        OrderClientDTO.NotificationRecipient recipient = builder.build();

        Assert.areEqual(OrderClientDTOEnums.NotificationRecipientRoleEnum.CUSTOMER, recipient.role);
        Assert.areEqual('test@example.com', recipient.email);
        Assert.areEqual('+9876543210', recipient.telephoneNumber);
    }

    @isTest
    static void testOfferingBuilder() {
        OrderClientDTOBuilder.AmountBuilder amountBuilder = new OrderClientDTOBuilder.AmountBuilder()
            .withCurrency(OrderClientDTOEnums.AmountCurrencyEnum.DKK)
            .withAmount(99.99);

        OrderClientDTOBuilder.OfferingBuilder builder = new OrderClientDTOBuilder.OfferingBuilder()
            .withPriceplan('Premium')
            .withCampaign('Summer_Sale')
            .withDiscount('10%')
            .withName('Basic Plan')
            .withBindingPeriod('12')
            .withProductOfferingId('withProductOfferingId')
            .withMonthlyPriceAmountBuilder(amountBuilder);

        OrderClientDTO.Offering offering = builder.build();

        Assert.areEqual('Premium', offering.priceplan);
        Assert.areEqual('Summer_Sale', offering.campaign);
        Assert.areEqual('10%', offering.discount);
        Assert.areEqual('Basic Plan', offering.name);
        Assert.areEqual('12', offering.bindingPeriod);
    }

    @isTest
    static void testBuilderChain() {
        OrderClientDTOBuilder.NetworkConfigurationBuilder builder = new OrderClientDTOBuilder.NetworkConfigurationBuilder()
            .withCpeName('Test_CPE')
            .withQosProfileName('Standard_QoS');

        // Verify chain works correctly
        Assert.isTrue(builder.withVrfName('Default_VRF') == builder);

        OrderClientDTO.NetworkConfiguration config = builder.build();
        Assert.areEqual('Test_CPE', config.cpeName);
        Assert.areEqual('Standard_QoS', config.qosProfileName);
        Assert.areEqual('Default_VRF', config.vrfName);
    }

    @isTest
    static void testNullValues() {
        OrderClientDTOBuilder.NetworkConfigurationBuilder builder = new OrderClientDTOBuilder.NetworkConfigurationBuilder()
            .withCpeName(null)
            .withQosProfileName('');

        OrderClientDTO.NetworkConfiguration config = builder.build();

        Assert.isTrue(config.cpeName == null);
        Assert.areEqual('', config.qosProfileName);
    }

    // OrderAdditionalInfoPatchBuilder Tests
    @isTest
    static void testOrderAdditionalInfoPatchBuilder() {
        String expectedMemo = 'Test Memo';

        OrderClientDTOBuilder.OrderAdditionalInfoPatchBuilder builder = new OrderClientDTOBuilder.OrderAdditionalInfoPatchBuilder()
            .withOrderMemo(expectedMemo);

        OrderClientDTO.OrderAdditionalInfoPatch result = builder.build();

        Assert.areEqual(expectedMemo, result.orderMemo);
    }

    @isTest
    static void testOrderAdditionalInfoPatchBuilder_NullInput() {
        OrderClientDTOBuilder.OrderAdditionalInfoPatchBuilder builder = new OrderClientDTOBuilder.OrderAdditionalInfoPatchBuilder()
            .withOrderMemo(null);

        OrderClientDTO.OrderAdditionalInfoPatch result = builder.build();

        Assert.isNull(result.orderMemo);
    }

    // OrderApprovalBuilder Tests
    @isTest
    static void testOrderApprovalBuilder() {
        String expectedComment = 'Test Comment';
        String expectedIp = '192.168.1.1';

        OrderClientDTOBuilder.OrderApprovalBuilder builder = new OrderClientDTOBuilder.OrderApprovalBuilder()
            .withApprovalComment(expectedComment)
            .withApprovalIp(expectedIp);

        OrderClientDTO.OrderApproval result = builder.build();

        Assert.areEqual(expectedComment, result.approvalComment);
        Assert.areEqual(expectedIp, result.approvalIp);
    }

    @isTest
    static void testOrderApprovalBuilder_NullInputs() {
        OrderClientDTOBuilder.OrderApprovalBuilder builder = new OrderClientDTOBuilder.OrderApprovalBuilder()
            .withApprovalComment(null)
            .withApprovalIp(null);

        OrderClientDTO.OrderApproval result = builder.build();

        Assert.isNull(result.approvalComment);
        Assert.isNull(result.approvalIp);
    }

    // OrderEventDetailsBuilder Tests
    @isTest
    static void testOrderEventDetailsBuilder_Full() {
        String category = 'Installation';
        String description = 'New Installation';
        Date startDate = Date.today();
        Date expectedCompletionDate = startDate.addDays(30);
        Integer id = 123;
        String purchaseOrderId = 'PO001';
        String state = 'Pending';

        OrderClientDTOBuilder.OrderEventDetailsBuilder builder = new OrderClientDTOBuilder.OrderEventDetailsBuilder()
            .withCategory(category)
            .withDescription(description)
            .withExpectedCompletionDate(expectedCompletionDate)
            .withId(id)
            .withStartDate(startDate)
            .withPurchaseOrderId(purchaseOrderId)
            .withState(state)
            .withTechnicianDetailsBuilder(
                new OrderClientDTOBuilder.TechnicianDetailsBuilder()
                    .withTechnicianName('Test')
                    .withTechnicianNumber('1234')
                    .withInstallationAddress('withInstallationAddress')
                    .withTechnicianVisitDate(Date.today().addDays(30))
            );

        OrderClientDTO.OrderEventDetails result = builder.build();

        Assert.areEqual(category, result.category);
        Assert.areEqual(description, result.description);
        Assert.areEqual(expectedCompletionDate, result.expectedCompletionDate);
        Assert.areEqual(id, result.id);
        Assert.areEqual(startDate, result.startDate);
        Assert.areEqual(purchaseOrderId, result.purchaseOrderId);
        Assert.areEqual(state, result.state);
        Assert.areNotEqual(null, result.technicianDetails);
    }

    @isTest
    static void testOrderEventDetailsBuilder_NoTechnician() {
        String category = 'Installation';

        OrderClientDTOBuilder.OrderEventDetailsBuilder builder = new OrderClientDTOBuilder.OrderEventDetailsBuilder()
            .withCategory(category);

        OrderClientDTO.OrderEventDetails result = builder.build();

        Assert.areEqual(category, result.category);
        Assert.isNull(result.technicianDetails);
    }

    @isTest
    static void testOrderFlagsBuilder() {
        Boolean expectedOrderConfirmed = true;
        Boolean expectedTermsAccepted = false;

        OrderClientDTOBuilder.OrderFlagsBuilder builder = new OrderClientDTOBuilder.OrderFlagsBuilder()
            .withOrderConfirmed(expectedOrderConfirmed)
            .withTermsAccepted(expectedTermsAccepted);

        OrderClientDTO.OrderFlags result = builder.build();

        Assert.areEqual(expectedOrderConfirmed, result.orderConfirmed);
        Assert.areEqual(expectedTermsAccepted, result.termsAccepted);
    }

    @isTest
    static void testShippingDetailsBuilder() {
        OrderClientDTOBuilder.ShippingDetailsBuilder builder = new OrderClientDTOBuilder.ShippingDetailsBuilder();
        builder.withToDeliverQuantity(5)
            .withTSFOffering('tsfOffering')
            .withERPTSProduct('erpTsProduct')
            .withHardwareDeliveryId(15)
            .withUserName('userName')
            .withUserId('userId')
            .withDepartment('department')
            .withTrackAndTraceNumber('trackAndTraceNumber')
            .withTrackAndTraceURL('trackAndTraceURL');

        OrderClientDTO.ShippingDetails details = builder.build();

        Assert.areEqual('tsfOffering', details.tsfOffering);
        Assert.areEqual('erpTsProduct', details.erpTsProduct);
        Assert.areEqual(15, details.hardwareDeliveryId);
    }

    @isTest
    static void testSerialNumberBuilder() {
        OrderClientDTOBuilder.SerialNumberBuilder builder = new OrderClientDTOBuilder.SerialNumberBuilder();
        builder.withType('type');
        builder.withValue('value');

        OrderClientDTO.SerialNumber serial = builder.build();

        Assert.areEqual('type', serial.type);
        Assert.areEqual('value', serial.value);
    }

    @isTest
    static void testPhysicalIdentificationBuilder() {
        OrderClientDTOBuilder.PhysicalIdentificationBuilder pysId = new OrderClientDTOBuilder.PhysicalIdentificationBuilder();
        pysId.withType('type');
        pysId.withValue('value');

        OrderClientDTO.PhysicalIdentification result = pysId.build();

        Assert.areEqual('type', result.type);
        Assert.areEqual('value', result.value);
    }

    @isTest
    static void testPilPaymentBuilder() {
        OrderClientDTOBuilder.PilPaymentBuilder builder = new OrderClientDTOBuilder.PilPaymentBuilder();

        builder.withPaymentId('paymentId');
        builder.withUpdatedAt(Date.today());
        builder.withTotalAmount(10);
        builder.withTotalVat(10);
        builder.withPaymentRoundingError(12);

        OrderClientDTO.PilPayment result = builder.build();

        Assert.areEqual('paymentId', result.paymentId);
    }

    @isTest
    static void testReturnDetailsBuilder() {
        OrderClientDTOBuilder.ReturnDetailsBuilder builder = new OrderClientDTOBuilder.ReturnDetailsBuilder();
        builder.withReturnQuantity(15);
        builder.withCreditInvoiceNumber('withCreditInvoiceNumber');
        builder.withCreditInvoiceDate(Date.today());

        OrderClientDTO.ReturnDetails returns = builder.build();

        Assert.areEqual(15, returns.returnQuantity);
    }

    @isTest
    static void testSimDetailsBuilder() {
        OrderClientDTOBuilder.SimDetailsBuilder builder = new OrderClientDTOBuilder.SimDetailsBuilder();

        builder.withSimType(OrderClientDTOEnums.SimDetailsSimTypeEnum.MAIN_HARDWARE_SIM);
        builder.withIcc('icc');
        builder.withImsi('imsi');
        builder.withOldIcc('oldIcc');
        builder.withOldImsi('oldImsi');
        builder.withEid('eid');
        builder.withImei('imei');
        builder.withBindDeviceType('bindDeviceType');
        builder.withBindDeviceName('bindDeviceName');
        builder.withAlternateSmdpFqdn('alternateSmdpFqdn');
        builder.withWaiveSimSwapFee(true);

        OrderClientDTO.SimDetails simDetails = builder.build();

        Assert.areEqual('icc', simDetails.icc);
        Assert.areEqual('imsi', simDetails.imsi);
        Assert.areEqual('oldIcc', simDetails.oldIcc);
        Assert.areEqual('oldImsi', simDetails.oldImsi);
        Assert.areEqual('eid', simDetails.eid);
        Assert.areEqual('imei', simDetails.imei);
        Assert.areEqual('bindDeviceType', simDetails.bindDeviceType);
        Assert.areEqual('bindDeviceName', simDetails.bindDeviceName);
        Assert.areEqual('alternateSmdpFqdn', simDetails.alternateSmdpFqdn);
        Assert.areEqual(true, simDetails.waiveSimSwapFee);
    }

    @isTest
    static void testSubscriptionUserBuilder() {
        OrderClientDTOBuilder.SubscriptionUserBuilder builder = new OrderClientDTOBuilder.SubscriptionUserBuilder();
        builder.withFirstName('withFirstName');
        builder.withLastName('withLastName');
        builder.withEmail('withEmail');
        builder.withBirthDate(Date.today());

        OrderClientDTO.SubscriptionUser subUser = builder.build();

        Assert.areEqual('withFirstName', subUser.firstName);
        Assert.areEqual('withLastName', subUser.lastName);
        Assert.areEqual('withEmail', subUser.email);
    }

    @isTest
    static void testOrderFlagsBuilder_AllProperties() {
        OrderClientDTOBuilder.OrderFlagsBuilder builder = new OrderClientDTOBuilder.OrderFlagsBuilder()
            .withOrderConfirmed(true)
            .withTermsAccepted(false)
            .withCprCheckFailed(true)
            .withCreditCheckFailed(false)
            .withNeedsConfirmation(true)
            .withMembershipCheck(false)
            .withDirty(true)
            .withDoCommunication(false)
            .withDoLogistics(true)
            .withAddCharge(false)
            .withPosFlow(true)
            .withHomeOfficeOrder(false)
            .withCreateDraftOrder(true)
            .withManualSigning(false)
            .withSimOnly(true)
            .withHasUpfrontPayment(false)
            .withTfFinancingNeeded(true)
            .withPhysicalIdPreidentified(false)
            .withShopSales(true)
            .withOrderExpired(false)
            .withNewDivaFlow(true)
            .withIsSubOrder(false);

        OrderClientDTO.OrderFlags result = builder.build();

        Assert.isTrue(result.orderConfirmed);
        Assert.isFalse(result.termsAccepted);
        Assert.isTrue(result.cprCheckFailed);
        Assert.isFalse(result.creditCheckFailed);
        Assert.isTrue(result.needsConfirmation);
        Assert.isFalse(result.membershipCheck);
        Assert.isTrue(result.dirty);
        Assert.isFalse(result.doCommunication);
        Assert.isTrue(result.doLogistics);
        Assert.isFalse(result.addCharge);
        Assert.isTrue(result.posFlow);
        Assert.isFalse(result.homeOfficeOrder);
        Assert.isTrue(result.createDraftOrder);
        Assert.isFalse(result.manualSigning);
        Assert.isTrue(result.simOnly);
        Assert.isFalse(result.hasUpfrontPayment);
        Assert.isTrue(result.tfFinancingNeeded);
        Assert.isFalse(result.physicalIdPreidentified);
        Assert.isTrue(result.shopSales);
        Assert.isFalse(result.orderExpired);
        Assert.isTrue(result.newDivaFlow);
        Assert.isFalse(result.isSubOrder);
    }

    @isTest
    static void testOrderItemBuilderBasicProperties() {
        // Create builder instance
        OrderClientDTOBuilder.OrderItemBuilder builder = new OrderClientDTOBuilder.OrderItemBuilder();

        // Set properties
        OrderClientDTOEnums.OrderItemTypeEnum testType = OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM;
        String testChannelId = 'TEST_CHANNEL_ID';
        Integer testId = 123;
        OrderClientDTOEnums.OrderItemOriginEnum testOrigin = OrderClientDTOEnums.OrderItemOriginEnum.CLIENT;
        OrderClientDTOEnums.OrderItemActivityEnum testActivity = OrderClientDTOEnums.OrderItemActivityEnum.CREATE;

        // Build object
        builder.withType(testType)
            .withChannelOrderItemId(testChannelId)
            .withId(testId)
            .withOrigin(testOrigin)
            .withActivity(testActivity);

        // Get built object
        OrderClientDTO.OrderItem result = builder.build();

        // Verify properties
        Assert.areEqual(testType, result.type, 'Type should match');
        Assert.areEqual(testChannelId, result.channelOrderItemId, 'Channel ID should match');
        Assert.areEqual(testId, result.id, 'ID should match');
        Assert.areEqual(testOrigin, result.origin, 'Origin should match');
        Assert.areEqual(testActivity, result.activity, 'Activity should match');
    }

    @isTest
    static void testCreditWatchItemBuilder() {
        OrderClientDTOBuilder.CreditWatchItemBuilder builder = new OrderClientDTOBuilder.CreditWatchItemBuilder();

        Decimal amount = 100.00;
        Boolean waiveFees = true;
        Date expirationDate = Date.today().addDays(30);

        OrderClientDTO.CreditWatchItem result = (OrderClientDTO.CreditWatchItem) builder
            .withAmount(amount)
            .withWaiveFees(waiveFees)
            .withExpirationDate(expirationDate)
            .build();

        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.CREDIT_WATCH_ITEM,
            result.type,
            'Type should be CREDIT_WATCH_ITEM'
        );
        Assert.areEqual(amount, result.amount, 'Amount should match');
        Assert.areEqual(waiveFees, result.waiveFees, 'Waive fees should match');
        Assert.areEqual(expirationDate, result.expirationDate, 'Expiration date should match');
    }

    @isTest
    static void testDiscountItemBuilder() {
        OrderClientDTOBuilder.DiscountItemBuilder builder = new OrderClientDTOBuilder.DiscountItemBuilder();

        String discountCode = 'TEST_DISCOUNT';
        String reason = 'Test Reason';

        OrderClientDTO.DiscountItem result = (OrderClientDTO.DiscountItem) builder.withDiscountCode(discountCode)
            .withReason(reason)
            .build();

        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.DISCOUNT_ITEM,
            result.type,
            'Type should be DISCOUNT_ITEM'
        );
        Assert.areEqual(discountCode, result.discountCode, 'Discount code should match');
        Assert.areEqual(reason, result.reason, 'Reason should match');
    }

    @isTest
    static void testFeeItemBuilder() {
        OrderClientDTOBuilder.FeeItemBuilder builder = new OrderClientDTOBuilder.FeeItemBuilder();

        OrderClientDTOEnums.FeeItemFeeTypeEnum feeType = OrderClientDTOEnums.FeeItemFeeTypeEnum.ACT_FEE;
        String billingCode = 'TEST_FEE';
        String displayName = 'Test Fee';
        Boolean waived = false;

        OrderClientDTO.FeeItem result = (OrderClientDTO.FeeItem) builder
            .withFeeType(feeType)
            .withBillingCode(billingCode)
            .withDisplayName(displayName)
            .withFeeType(waived)
            .withRecurring(true)
            .build();

        Assert.areEqual(OrderClientDTOEnums.OrderItemTypeEnum.FEE_ITEM, result.type, 'Type should be FEE_ITEM');
        Assert.areEqual(feeType, result.feeType, 'Fee type should match');
        Assert.areEqual(billingCode, result.billingCode, 'Billing code should match');
        Assert.areEqual(displayName, result.displayName, 'Display name should match');
        Assert.areEqual(waived, result.waived, 'Waived flag should match');
    }

    @isTest
    static void testHardwarePaymentItemBuilder() {
        OrderClientDTOBuilder.HardwarePaymentItemBuilder builder = new OrderClientDTOBuilder.HardwarePaymentItemBuilder();

        OrderClientDTOEnums.PaymentType paymentType = OrderClientDTOEnums.PaymentType.INVOICE;
        String purchaseId = 'TEST_PURCHASE';

        OrderClientDTO.HardwarePaymentItem result = (OrderClientDTO.HardwarePaymentItem) builder
            .withPaymentType(paymentType)
            .withPurchaseId(purchaseId)
            .build();

        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.HARDWARE_PAYMENT_ITEM,
            result.type,
            'Type should be HARDWARE_PAYMENT_ITEM'
        );
        Assert.areEqual(paymentType, result.paymentType, 'Payment type should match');
        Assert.areEqual(purchaseId, result.purchaseId, 'Purchase ID should match');
    }

    @isTest
    static void testHardwareSwapItemBuilder() {
        OrderClientDTOBuilder.HardwareSwapItemBuilder builder = new OrderClientDTOBuilder.HardwareSwapItemBuilder();

        String shippingStatus = 'IN_TRANSIT';
        String oldSerialNumber = 'ABC123';

        OrderClientDTO.HardwareSwapItem result = (OrderClientDTO.HardwareSwapItem) builder
            .withShippingStatus(shippingStatus)
            .withOldSerialNumber(oldSerialNumber)
            .build();

        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.HARDWARE_SWAP_ITEM,
            result.type,
            'Type should be HARDWARE_SWAP_ITEM'
        );
        Assert.areEqual(shippingStatus, result.shippingStatus, 'Shipping status should match');
        Assert.areEqual(oldSerialNumber, result.oldSerialNumber, 'Old serial number should match');
    }

    @isTest
    static void testCallForwardingItemBuilder() {
        OrderClientDTOBuilder.CallForwardingItemBuilder builder = new OrderClientDTOBuilder.CallForwardingItemBuilder();

        OrderClientDTOBuilder.ForwardingSettingBuilder forwardingBuilder = new OrderClientDTOBuilder.ForwardingSettingBuilder();

        OrderClientDTO.CallForwardingItem result = (OrderClientDTO.CallForwardingItem) builder.withAllForwardingSettingBuilder(
                forwardingBuilder
            )
            .build();

        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.CALL_FORWARDING_ITEM,
            result.type,
            'Type should be CALL_FORWARDING_ITEM'
        );
        Assert.areNotEqual(null, result.all, 'Forwarding settings should not be null');
    }

    @isTest
    static void testChargeItemBuilder() {
        OrderClientDTOBuilder.ChargeItemBuilder builder = new OrderClientDTOBuilder.ChargeItemBuilder();

        String chargeCode = 'TEST_CHARGE';
        String description = 'Test Charge';

        OrderClientDTO.ChargeItem result = (OrderClientDTO.ChargeItem) builder.withChargeCode(chargeCode)
            .withDescription(description)
            .build();

        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.CHARGE_ITEM,
            result.type,
            'Type should be CHARGE_ITEM'
        );
        Assert.areEqual(chargeCode, result.chargeCode, 'Charge code should match');
        Assert.areEqual(description, result.description, 'Description should match');
    }

    @isTest
    static void testConsentItemBuilder() {
        OrderClientDTOBuilder.ConsentItemBuilder builder = new OrderClientDTOBuilder.ConsentItemBuilder();

        String consentId = 'TEST_CONSENT';
        Integer version = 1;
        String state = 'ACTIVE';

        OrderClientDTO.ConsentItem result = (OrderClientDTO.ConsentItem) builder
            .withConsentId(consentId)
            .withVersion(version)
            .withState(state)
            .build();

        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.CONSENT_ITEM,
            result.type,
            'Type should be CONSENT_ITEM'
        );
        Assert.areEqual(consentId, result.consentId, 'Consent ID should match');
        Assert.areEqual(version, result.version, 'Version should match');
        Assert.areEqual(state, result.state, 'State should match');
    }

    @isTest
    static void testAccountItemBuilder() {
        OrderClientDTOBuilder.AccountItemBuilder builder = new OrderClientDTOBuilder.AccountItemBuilder();

        String billingAccountNumber = '123456789';
        OrderClientDTOEnums.AccountItemBillingCycleEnum billingCycle = OrderClientDTOEnums.AccountItemBillingCycleEnum.QUARTERLY;
        OrderClientDTOEnums.AccountItemInvoiceTypeEnum invoiceType = OrderClientDTOEnums.AccountItemInvoiceTypeEnum.PAPER_INVOICE;

        OrderClientDTO.AccountItem result = (OrderClientDTO.AccountItem) builder
            .withBillingAccountNumber(billingAccountNumber)
            .withBillingCycle(billingCycle)
            .withInvoiceType(invoiceType)
            .build();

        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.ACCOUNT_ITEM,
            result.type,
            'Type should be ACCOUNT_ITEM'
        );
        Assert.areEqual(billingAccountNumber, result.billingAccountNumber, 'Billing account number should match');
        Assert.areEqual(billingCycle, result.billingCycle, 'Billing cycle should match');
        Assert.areEqual(invoiceType, result.invoiceType, 'Invoice type should match');
    }

    @isTest
    static void testAdditionalProductItemBuilder() {
        OrderClientDTOBuilder.AdditionalProductItemBuilder builder = new OrderClientDTOBuilder.AdditionalProductItemBuilder();

        String productCode = 'TEST_PRODUCT';
        String productName = 'Test Product';
        OrderClientDTOBuilder.AmountBuilder priceAmountBuilder = new OrderClientDTOBuilder.AmountBuilder();

        OrderClientDTO.AdditionalProductItem result = (OrderClientDTO.AdditionalProductItem) builder
            .withProductCode(productCode)
            .withProductName(productName)
            .withUnitPriceAmountBuilder(priceAmountBuilder)
            .build();

        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.ADDITIONAL_PRODUCT_ITEM,
            result.type,
            'Type should be ADDITIONAL_PRODUCT_ITEM'
        );
        Assert.areEqual(productCode, result.productCode, 'Product code should match');
        Assert.areEqual(productName, result.productName, 'Product name should match');
        Assert.areNotEqual(null, result.unitPrice, 'Unit price should not be null');
    }

    @isTest
    static void testPaymentMethodChangeItemBuilder() {
        // Arrange
        OrderClientDTOBuilder.PaymentMethodDetailBuilder mockPaymentDetailBuilder = new OrderClientDTOBuilder.PaymentMethodDetailBuilder();

        // Act
        OrderClientDTOBuilder.PaymentMethodChangeItemBuilder builder = new OrderClientDTOBuilder.PaymentMethodChangeItemBuilder()
            .withPaymentMethodDetailBuilder(mockPaymentDetailBuilder)
            .withReasonCode('TEST_REASON')
            .withMemoText('Test Memo');

        OrderClientDTO.PaymentMethodChangeItem result = (OrderClientDTO.PaymentMethodChangeItem) builder.build();

        // Assert
        Assert.areNotEqual(null, result, 'Result should not be null');
        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.PAYMENT_METHOD_CHANGE_ITEM,
            result.type,
            'Incorrect order item type'
        );
        Assert.areEqual('TEST_REASON', result.reasonCode, 'Incorrect reason code');
        Assert.areEqual('Test Memo', result.memoText, 'Incorrect memo text');
        Assert.areNotEqual(null, result.paymentMethodDetail, 'Payment method detail should not be null');
    }

    @isTest
    static void testPortingDetailsItemBuilder() {
        // Arrange
        OrderClientDTOBuilder.ConsentBuilder mockConsentBuilder = new OrderClientDTOBuilder.ConsentBuilder();

        // Act
        OrderClientDTOBuilder.PortingDetailsItemBuilder builder = new OrderClientDTOBuilder.PortingDetailsItemBuilder()
            .withNetworkOperatorId('TEST_OPERATOR')
            .withDonorSimNumber('1234567890')
            .withDigitalPoaAllowed(true)
            .withPowerOfAttorneyManualHandling(false)
            .withEarliestPortingDate(Date.today())
            .withActualPortingDate(Date.today().addDays(1))
            .withDonorConsentBuilder(mockConsentBuilder);

        OrderClientDTO.PortingDetailsItem result = (OrderClientDTO.PortingDetailsItem) builder.build();

        // Assert
        Assert.areNotEqual(null, result, 'Result should not be null');
        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.PORTING_DETAILS_ITEM,
            result.type,
            'Incorrect order item type'
        );
        Assert.areEqual('TEST_OPERATOR', result.networkOperatorId, 'Incorrect network operator ID');
        Assert.areEqual(true, result.digitalPoaAllowed, 'Incorrect digital POA allowed flag');
        Assert.areNotEqual(null, result.donorConsent, 'Donor consent should not be null');
    }

    @isTest
    static void testReactivationItemBuilder() {
        // Act
        OrderClientDTOBuilder.ReactivationItemBuilder builder = new OrderClientDTOBuilder.ReactivationItemBuilder()
            .withReason('Test Reason');

        OrderClientDTO.ReactivationItem result = (OrderClientDTO.ReactivationItem) builder.build();

        // Assert
        Assert.areNotEqual(null, result, 'Result should not be null');
        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.REACTIVATION_ITEM,
            result.type,
            'Incorrect order item type'
        );
        Assert.areEqual('Test Reason', result.reason, 'Incorrect reason');
    }

    @isTest
    static void testRegretItemBuilder() {
        // Act
        OrderClientDTOBuilder.RegretItemBuilder builder = new OrderClientDTOBuilder.RegretItemBuilder();
        builder.withEffectiveDate(Date.today());

        OrderClientDTO.RegretItem result = (OrderClientDTO.RegretItem) builder.build();

        // Assert
        Assert.areNotEqual(null, result, 'Result should not be null');
        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.REGRET_ITEM,
            result.type,
            'Incorrect order item type'
        );
        Assert.areEqual(Date.today(), result.effectiveDate, 'Incorrect effective date');
    }

    @isTest
    static void testSubscriptionItemBuilder() {
        // Arrange
        OrderClientDTOBuilder.AmountBuilder mockAmountBuilder = new OrderClientDTOBuilder.AmountBuilder();
        OrderClientDTOBuilder.SubscriptionUserBuilder mockUserBuilder = new OrderClientDTOBuilder.SubscriptionUserBuilder();

        // Act
        OrderClientDTOBuilder.SubscriptionItemBuilder builder = new OrderClientDTOBuilder.SubscriptionItemBuilder()
            .withPublishLevel(OrderClientDTOEnums.SubscriptionItemPublishLevelEnum.ADDRESS_AND_EMAIL)
            .withLabel('Test Label')
            .withSecret(false)
            .withProductDeliveryAsap(true)
            .withRecurringPriceBuilder(mockAmountBuilder)
            .withSubscriptionUserBuilder(mockUserBuilder);

        OrderClientDTO.SubscriptionItem result = (OrderClientDTO.SubscriptionItem) builder.build();

        // Assert
        Assert.areNotEqual(null, result, 'Result should not be null');
        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.SUBSCRIPTION_ITEM,
            result.type,
            'Incorrect order item type'
        );
        Assert.areEqual(false, result.secret, 'Incorrect secret flag');
        Assert.areEqual(true, result.productDeliveryAsap, 'Incorrect delivery ASAP flag');
        Assert.areNotEqual(null, result.recurringPrice, 'Recurring price should not be null');
        Assert.areNotEqual(null, result.subscriptionUser, 'Subscription user should not be null');
    }

    @isTest
    static void testSuspensionItemBuilder() {
        // Act
        OrderClientDTOBuilder.SuspensionItemBuilder builder = new OrderClientDTOBuilder.SuspensionItemBuilder().withReason('Test Reason');

        OrderClientDTO.SuspensionItem result = (OrderClientDTO.SuspensionItem) builder.build();

        // Assert
        Assert.areNotEqual(null, result, 'Result should not be null');
        Assert.areEqual(
            OrderClientDTOEnums.OrderItemTypeEnum.SUSPENSION_ITEM,
            result.type,
            'Incorrect order item type'
        );
        Assert.areEqual('Test Reason', result.reason, 'Incorrect reason');
    }

    @isTest
    static void testTerminationItemBuilder_BasicFlow() {
        // Arrange
        Date testDate = Date.today();
        OrderClientDTOEnums.TerminationItemReasonCodeEnum reason = OrderClientDTOEnums.TerminationItemReasonCodeEnum.CANCELLATION;

        // Act
        OrderClientDTOBuilder.TerminationItemBuilder builder = new OrderClientDTOBuilder.TerminationItemBuilder()
            .withEffectiveDate(testDate)
            .withReasonCode(reason)
            .withRetention(true)
            .withWaiveTerminationFees(false)
            .withShouldTransferToDifferentPool(true)
            .withShouldReReserve(false);

        OrderClientDTO.TerminationItem result = (OrderClientDTO.TerminationItem) builder.build();

        // Assert
        Assert.areEqual(OrderClientDTOEnums.OrderItemTypeEnum.TERMINATION_ITEM, result.type);
        Assert.areEqual(testDate, result.effectiveDate);
        Assert.areEqual(reason, result.reasonCode);
        Assert.areEqual(true, result.retention);
        Assert.areEqual(false, result.waiveTerminationFees);
        Assert.areEqual(true, result.shouldTransferToDifferentPool);
        Assert.areEqual(false, result.shouldReReserve);
    }

    @isTest
    static void testTerminationItemBuilder_NullValues() {
        // Act
        OrderClientDTOBuilder.TerminationItemBuilder builder = new OrderClientDTOBuilder.TerminationItemBuilder()
            .withEffectiveDate(null)
            .withReasonCode(null)
            .withRetention(null)
            .withWaiveTerminationFees(null)
            .withShouldTransferToDifferentPool(null)
            .withShouldReReserve(null);

        OrderClientDTO.TerminationItem result = (OrderClientDTO.TerminationItem) builder.build();

        // Assert
        Assert.isTrue(result != null);
        Assert.areEqual(OrderClientDTOEnums.OrderItemTypeEnum.TERMINATION_ITEM, result.type);
        Assert.isTrue(result.effectiveDate == null);
        Assert.isTrue(result.reasonCode == null);
        Assert.isTrue(result.retention == null);
        Assert.isTrue(result.waiveTerminationFees == null);
        Assert.isTrue(result.shouldTransferToDifferentPool == null);
        Assert.isTrue(result.shouldReReserve == null);
    }

    @isTest
    static void testOrderPartBuilder_BasicFlow() {
        // Arrange
        OrderClientDTOBuilder.OrderPartBuilder builder = new OrderClientDTOBuilder.OrderPartBuilder()
            .withType(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT)
            .withActivity(OrderClientDTOEnums.OrderPartActivityEnum.CHANGE)
            .withChangeType(OrderClientDTOEnums.OrderPartChangeTypesEnum.CALL_FORWARDING)
            .withProcessingStatus(OrderClientDTOEnums.ProcessingStatus.COMPLETED)
            .withId(1)
            .withChannelOrderPartId('TEST001')
            .withSplitOrderId('SPLIT001')
            .withTaskUrl('https://test.url');

        // Act
        OrderClientDTO.OrderPart result = builder.build();

        // Assert
        Assert.areEqual(OrderClientDTOEnums.OrderPartTypeEnum.ACCOUNT, result.type);
        Assert.areEqual(OrderClientDTOEnums.OrderPartActivityEnum.CHANGE, result.activity);
        Assert.areEqual(OrderClientDTOEnums.ProcessingStatus.COMPLETED, result.processingStatus);
        Assert.areEqual(1, result.id);
        Assert.areEqual('TEST001', result.channelOrderPartId);
        Assert.areEqual('SPLIT001', result.splitOrderId);
        Assert.areEqual('https://test.url', result.taskUrl);
    }

    @isTest
    static void testOrderPartBuilder_ChangeTypesCollection() {
        // Arrange
        List<OrderClientDTOEnums.OrderPartChangeTypesEnum> expectedChanges = new List<OrderClientDTOEnums.OrderPartChangeTypesEnum>{
            OrderClientDTOEnums.OrderPartChangeTypesEnum.ADDITIONAL_PRODUCTS,
            OrderClientDTOEnums.OrderPartChangeTypesEnum.CALL_FORWARDING,
            OrderClientDTOEnums.OrderPartChangeTypesEnum.PRICEPLAN
        };

        // Act
        OrderClientDTOBuilder.OrderPartBuilder builder = new OrderClientDTOBuilder.OrderPartBuilder()
            .withChangeType(OrderClientDTOEnums.OrderPartChangeTypesEnum.ADDITIONAL_PRODUCTS)
            .withChangeType(OrderClientDTOEnums.OrderPartChangeTypesEnum.CALL_FORWARDING)
            .withChangeType(OrderClientDTOEnums.OrderPartChangeTypesEnum.PRICEPLAN);

        OrderClientDTO.OrderPart result = builder.build();

        // Assert
        Assert.areEqual(expectedChanges, result.changeTypes);
    }

    @isTest
    static void testOrderPartBuilder_NullValues() {
        // Act
        OrderClientDTO.OrderPart result = new OrderClientDTOBuilder.OrderPartBuilder()
            .withType(null)
            .withActivity(null)
            .withProcessingStatus(null)
            .build();

        // Assert
        Assert.isTrue(result != null);
        Assert.isTrue(result.type == null);
        Assert.isTrue(result.activity == null);
        Assert.isTrue(result.processingStatus == null);
        Assert.isTrue(result.changeTypes == null);
    }

    @isTest
    static void testOrderPartReferenceBuilder() {
        // Test valid construction

        OrderClientDTOBuilder.OrderPartReferenceBuilder referenceBuilder = new OrderClientDTOBuilder.OrderPartReferenceBuilder();

        OrderCLientDTO.OrderPartReference reference = referenceBuilder.withType(
                OrderClientDTOEnums.OrderPartReferenceTypeEnum.ORIGINAL_ORDER_ID
            )
            .withValue('TEST123')
            .build();

        Assert.areEqual(OrderClientDTOEnums.OrderPartReferenceTypeEnum.ORIGINAL_ORDER_ID, reference.type);
        Assert.areEqual('TEST123', reference.value);

        // Test null values
        reference = new OrderClientDTOBuilder.OrderPartReferenceBuilder().withType(null).withValue(null).build();

        Assert.isNull(reference.type);
        Assert.isNull(reference.value);
    }

    @isTest
    static void testOrderPatchRequestBuilder() {
        // Test valid construction
        OrderClientDTO.OrderPatchRequest request = new OrderClientDTOBuilder.OrderPatchRequestBuilder()
            .withOperation(OrderClientDTOEnums.OpEnum.ADD)
            .withPath('/test/path')
            .withValue('testValue')
            .withFromValue('fromValue')
            .build();

        Assert.areEqual(OrderClientDTOEnums.OpEnum.ADD, request.op);
        Assert.areEqual('/test/path', request.path);
        Assert.areEqual('testValue', request.value);
        Assert.areEqual('fromValue', request.from_x);

        // Test null values
        request = new OrderClientDTOBuilder.OrderPatchRequestBuilder()
            .withOperation(null)
            .withPath(null)
            .withValue(null)
            .withFromValue(null)
            .build();

        Assert.isNull(request.op);
        Assert.isNull(request.path);
        Assert.isNull(request.value);
        Assert.isNull(request.from_x);
    }

    @isTest
    static void testOrderSourceBuilder() {
        // Test valid construction
        OrderClientDTO.OrderSource source = new OrderClientDTOBuilder.OrderSourceBuilder()
            .withIpAddress('192.168.1.1')
            .withPort(8080)
            .withCaptureTimeStamp(System.now())
            .build();

        Assert.areEqual('192.168.1.1', source.ipAddress);
        Assert.areEqual(8080, source.port);
        Assert.areNotEqual(null, source.captureTimeStamp);

        // Test null values
        source = new OrderClientDTOBuilder.OrderSourceBuilder()
            .withIpAddress(null)
            .withPort(null)
            .withCaptureTimeStamp(null)
            .build();

        Assert.isNull(source.ipAddress);
        Assert.isNull(source.port);
        Assert.isNull(source.captureTimeStamp);
    }

    @isTest
    static void testOrderV10Builder_BasicFields() {
        // Test basic fields
        OrderClientDTO.OrderV10 order = new OrderClientDTOBuilder.OrderV10Builder()
            .withId('ID001')
            .withOrderId('ORD001')
            .withParentOrderId('PORD001')
            .withChannelOrderReference('CHREF001')
            .withImplementationCaseId('CASE001')
            .withBpmOrderId('BPM001')
            .withNoosOrderId('NOOS001')
            .withMitIdVerificationToken('MIT001')
            .withBatchId('BAT001')
            .withBrand(OrderClientDTOEnums.Brand.CALLME)
            .withChannel('CHANNEL_1')
            .withSegment(OrderClientDTOEnums.OrderV10SegmentEnum.B2B)
            .withCreatedDate(System.now())
            .withCompletedDate(System.now())
            .withCreatedBy('USER001')
            .withProcessingStatus(OrderClientDTOEnums.ProcessingStatus.CANCELLED)
            .withProcessingStatusDetail('DETAILS')
            .withHasValidationErrors(false)
            .withTaskUrl('http://task.url')
            .withConfirmationUrl('http://confirm.url')
            .withDocumentsUrl('http://docs.url')
            .withPaymentId('PAY001')
            .withContextId(123)
            .build();

        Assert.areEqual('ID001', order.id);
        Assert.areEqual('ORD001', order.orderId);
        Assert.areEqual('PORD001', order.parentOrderId);
        Assert.areEqual('CHREF001', order.channelOrderReference);
        Assert.areEqual('CASE001', order.implementationCaseId);
        Assert.areEqual('BPM001', order.bpmOrderId);
        Assert.areEqual('NOOS001', order.noosOrderId);
        Assert.areEqual('MIT001', order.mitIdVerificationToken);
        Assert.areEqual('BAT001', order.batchId);
        Assert.areEqual(OrderClientDTOEnums.Brand.CALLME, order.brand);
        Assert.areEqual('CHANNEL_1', order.channel);
        Assert.areEqual(OrderClientDTOEnums.OrderV10SegmentEnum.B2B, order.segment);
        Assert.areNotEqual(null, order.createdDate);
        Assert.areNotEqual(null, order.completedDate);
        Assert.areEqual('USER001', order.createdBy);
        Assert.areEqual(OrderClientDTOEnums.ProcessingStatus.CANCELLED, order.processingStatus);
        Assert.areEqual('DETAILS', order.processingStatusDetail);
        Assert.isFalse(order.hasValidationErrors);
        Assert.areEqual('http://task.url', order.taskUrl);
        Assert.areEqual('http://confirm.url', order.confirmationUrl);
        Assert.areEqual('http://docs.url', order.documentsUrl);
        Assert.areEqual('PAY001', order.paymentId);
        Assert.areEqual(123, order.contextId);
    }

    @isTest
    static void testOrderV10Builder_CompositeBuilders() {
        // Test composite builders
        OrderClientDTO.OrderV10 order = new OrderClientDTOBuilder.OrderV10Builder()
            .withOrderSourceBuilder(
                new OrderClientDTOBuilder.OrderSourceBuilder()
                    .withIpAddress('192.168.1.1')
                    .withPort(8080)
                    .withCaptureTimeStamp(System.now())
            )
            .withDealerBuilder(new OrderClientDTOBuilder.DealerBuilder().withDealerName('Test Dealer'))
            .build();

        Assert.isNotNull(order.orderSource);
        Assert.areEqual('192.168.1.1', order.orderSource.ipAddress);
        Assert.areEqual(8080, order.orderSource.port);
        Assert.isNotNull(order.dealer);
        Assert.areEqual('Test Dealer', order.dealer.dealerName);
    }

    @isTest
    static void testOrderV10Builder_NullValues() {
        // Test null values
        OrderClientDTO.OrderV10 order = new OrderClientDTOBuilder.OrderV10Builder().withValidationErrors(null).build();

        Assert.isNull(order.validationErrors);

        // Test builder chaining with null values
        order = new OrderClientDTOBuilder.OrderV10Builder()
            .withCreditEvaluationDetailsBuilder(null)
            .withNotificationRecipientListBuilder(null)
            .withFlagsBuilder(null)
            .withOrdererPartyRoleBuilder(null)
            .build();

        Assert.isNull(order.creditEvaluationDetails);
        Assert.isNull(order.notificationRecipients);
        Assert.isNull(order.flags);
        Assert.isNull(order.orderer);
    }

    @isTest
    static void testTimePeriodBuilder() {
        OrderClientDTOBuilder.TimePeriodBuilder t = new OrderClientDTOBuilder.TimePeriodBuilder();

        t.withAmount(100);
        t.withTimePeriod(OrderClientDTOEnums.TimeUnit.DAY);

        OrderClientDTO.TimePeriod p = t.build();
        Assert.areEqual(100, p.amount);
        Assert.areEqual(OrderClientDTOEnums.TimeUnit.DAY, p.unit);
    }

    @isTest
    static void testHardwareDetailsBuilder() {
        OrderClientDTOBuilder.HardwareDetailsBuilder b = new OrderClientDTOBuilder.HardwareDetailsBuilder();

        b.withMaterialId('materialId');
        b.withName('name');
        b.withPackageType('packageType');

        OrderClientDTO.HardwareDetails d = b.build();

        Assert.areEqual('name', d.name);
        Assert.areEqual('materialId', d.materialId);
        Assert.areEqual('packageType', d.packageType);
    }

    @isTest
    static void TelephoneNumberBuilder() {
        OrderClientDTOBuilder.TelephoneNumberBuilder b = new OrderClientDTOBuilder.TelephoneNumberBuilder();
        b.withPhoneNumber('withPhoneNumber');
        b.withCountryCode('withCountryCode');
        b.withAreaCode('withAreaCode');

        OrderClientDTO.TelephoneNumber tel = b.build();
        Assert.areEqual('withPhoneNumber', tel.localNumber);
        Assert.areEqual('withCountryCode', tel.countryCode);
        Assert.areEqual('withAreaCode', tel.areaCode);
    }
}