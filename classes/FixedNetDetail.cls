/**
* @description Represents the technical details for a Fixed Net (broadband) subscription.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial refactored version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
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

    /**
    * @description Parses a JSON stream into a FixedNetDetail object.
    * @param parser The JSON parser.
    * @return A new FixedNetDetail object.
    */
    public static FixedNetDetail parse(System.JSONParser parser){
        FixedNetDetail d = new FixedNetDetail();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return d;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'fixedNetFlags' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) d.fixedNetFlags = FixedNetFlag.parse(parser);
            else if (f == 'installationAddress' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) d.installationAddress = Address.parse(parser);
            else if (f == 'speedDown') d.speedDown = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'speedUp') d.speedUp = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'doItYourselfInstallation') d.doItYourselfInstallation = JsonStreamingUtil.readBooleanToken(parser);
            else if (f == 'previousEmployerAdminEmail') d.previousEmployerAdminEmail = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'providerReuseOfAddress') d.providerReuseOfAddress = JsonStreamingUtil.readBooleanToken(parser);
            else if (f == 'vendor') d.vendor = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'vendorProductCode') d.vendorProductCode = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'vendorProductCatalogId') d.vendorProductCatalogId = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'lineConnectionStatus') d.lineConnectionStatus = JsonStreamingUtil.readStringToken(parser);
            else parser.skipChildren();
        }
        return d;
    }

    /**
    * @description Serializes the FixedNetDetail object to a JSON string.
    * @param gen The JSON generator.
    */
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (fixedNetFlags != null){ gen.writeFieldName('fixedNetFlags'); fixedNetFlags.serialize(gen); }
        if (installationAddress != null){ gen.writeFieldName('installationAddress'); installationAddress.serialize(gen); }
        if (speedDown != null) { gen.writeStringField('speedDown', speedDown); }
        if (speedUp != null) { gen.writeStringField('speedUp', speedUp); }
        if (doItYourselfInstallation != null) { gen.writeBooleanField('doItYourselfInstallation', doItYourselfInstallation); }
        if (providerReuseOfAddress != null) { gen.writeBooleanField('providerReuseOfAddress', doItYourselfInstallation); }
        if (previousEmployerAdminEmail != null) { gen.writeStringField('previousEmployerAdminEmail', previousEmployerAdminEmail); }
        if (vendor != null) { gen.writeStringField('vendor', vendor); }
        if (vendorProductCode != null) { gen.writeStringField('vendorProductCode', vendorProductCode); }
        if (vendorProductCatalogId != null) { gen.writeStringField('vendorProductCatalogId', vendorProductCatalogId); }
        if (lineConnectionStatus != null) { gen.writeStringField('lineConnectionStatus', lineConnectionStatus); }
        gen.writeEndObject();
    }
}