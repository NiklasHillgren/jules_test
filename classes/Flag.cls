/**
* @description Represents a set of boolean flags that control order processing behavior. This DTO
*              consolidates various flags from the legacy DAOs into a single class.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial refactored version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
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

    /**
    * @description Parses a JSON stream into a Flag object.
    * @param parser The JSON parser.
    * @return A new Flag object.
    */
    public static Flag parse(System.JSONParser parser){
        Flag f = new Flag();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return f;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String fld = parser.getText(); parser.nextToken();
            if (fld == 'needsConfirmation') f.needsConfirmation = JsonStreamingUtil.readBooleanToken(parser);
            else if (fld == 'consentAccepted') f.consentAccepted = JsonStreamingUtil.readBooleanToken(parser);
            else if (fld == 'termsAccepted') f.termsAccepted = JsonStreamingUtil.readBooleanToken(parser);
            else if (fld == 'homeOfficeOrder') f.homeOfficeOrder = JsonStreamingUtil.readBooleanToken(parser);
            else if (fld == 'dirty') f.dirty = JsonStreamingUtil.readBooleanToken(parser);
            else parser.skipChildren();
        }
        return f;
    }

    /**
    * @description Serializes the Flag object to a JSON string.
    * @param gen The JSON generator.
    */
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (needsConfirmation != null) gen.writeBooleanField('needsConfirmation', needsConfirmation);
        if (consentAccepted != null) gen.writeBooleanField('consentAccepted', consentAccepted);
        if (termsAccepted != null) gen.writeBooleanField('termsAccepted', termsAccepted);
        if (homeOfficeOrder != null) gen.writeBooleanField('homeOfficeOrder', homeOfficeOrder);
        if (dirty != null) gen.writeBooleanField('dirty', dirty);
        gen.writeEndObject();
    }
}