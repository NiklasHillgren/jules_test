public with sharing class OrderConstants {
    public static final String BRAND = OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'OrderConstantBrand'
    );
    
    public static final String CHANNEL = OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'OrderConstantChannel'
    );
    
    public static final String DEALER_CODE = OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'OrderConstantDealerCode'
    );
    
    public static final String DOCUMENT_URL = '<baseURL>/document/{0}/attachment/{1}';
}