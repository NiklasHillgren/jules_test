public with sharing class OrderService {
    private Account acc;
    private Map<Id, List<ContentDocumentLink>> powerOfAttorneyIdToContentDocumentLink;

    private final UserSelector userSelector;
    private final DocumentManagementSelector documentSelector;

    public OrderService() {
        this(SingletonFactory.getFactory());
    }

    private OrderService(SingletonFactory singletonFactory) {
        this.userSelector = (UserSelector) singletonFactory.getOrRegisterSingleton(UserSelector.class);
        this.documentSelector = (DocumentManagementSelector) singletonFactory.getOrRegisterSingleton(DocumentManagementSelector.class);
    }

    public void getAccount(String caseId) {
        this.acc = AccountSelector.getAccountByCaseId(caseId);
    }

    public Account getAccount() {
        return this.acc;
    }

    public void getPowerOfAttorneyDocuments(List<Activation_Line__c> activationLines) {
        List<Id> poaIds = SObjectCollectionUtil.of(activationLines)
            .pluckIds(Activation_Line__c.Power_of_Attorney_record__c);

        List<ContentDocumentLink> files = this.documentSelector.getContentDocumentLinksByPowerOfAttorneyIds(poaIds);

        this.powerOfAttorneyIdToContentDocumentLink = SObjectCollectionUtil.of(files)
            .groupByIds(ContentDocumentLink.LinkedEntityId);
    }

    public String getPoaDocumentIdByActivationLine(Activation_Line__c line) {
        List<ContentDocumentLink> myFiles = powerOfAttorneyIdToContentDocumentLink.get(
            line.Power_of_Attorney_record__c
        );

        if (!myFiles.isEmpty()) {
            ContentDocumentLink contentDocumentLink = myFiles.get(0);

            return contentDocumentLink.ContentDocument.LatestPublishedVersion.DocumentManagementStoreId__c;
        }

        return null;
    }

    public String getPoaDocumentURLByActivationLine(Activation_Line__c line) {
        List<ContentDocumentLink> myFiles = powerOfAttorneyIdToContentDocumentLink.get(
            line.Power_of_Attorney_record__c
        );

        if (!myFiles.isEmpty()) {
            ContentDocumentLink contentDocumentLink = myFiles.get(0);

            if (contentDocumentLink.ContentDocument.LatestPublishedVersion.DocumentManagementStoreId__c != null) {
                return String.format(
                    OrderConstants.DOCUMENT_URL,
                    new List<String>{
                        contentDocumentLink.ContentDocument.LatestPublishedVersion.DocumentManagementStoreId__c,
                        contentDocumentLink.ContentDocument.LatestPublishedVersion.Id
                    }
                );
            }
        }

        return null;
    }

    public OrderClientDTOEnums.Brand getBrand() {
        return OrderClientDTOEnums.Brand.valueOf(OrderConstants.BRAND);
    }

    /**
     * Retrieves the email of a User based on the provided User Id.
     *
     * This method performs a SOQL query to fetch the User record and returns
     * the value of the Email field. If no matching User is found null is returned
     *
     * @param userId  The Id of the User whose email should be retrieved.
     *
     * @return String
     *         The User's email, or null string if not found.
     */
    public String getInvoicedByEmail(Id userId) {
        String returnedEmail;

        if (userId != null) {
            User myUser = userSelector.getById(userId);

            if (myUser != null) {
                returnedEmail = myUser.Email;
            }
        }

        return returnedEmail;
    }

    /**
     * @description
     * Retrieves a list of Telia Product IDs corresponding to the true VAS fields
     * on the provided Activation_Line__c record.
     * @param activationLine  The Activation_Line__c record to check for true VAS fields.
     * @return List<String>
     *         A list of Telia Product IDs for the true VAS fields.
     */
    public List<String> getProductApiTeliaProductIdsForTrueVasFields(Activation_line__c activationLine) {
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

            // Check if it's true
            if (value == true) {
                teliaProductIds.add(getTeliaProductIdViaVasFieldApiName(mobileVasFieldApiName));
            }
        }
        return teliaProductIds;
    }

    /**
     * @description
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
}
