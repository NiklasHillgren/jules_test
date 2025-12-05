/**
* @description Represents a set of boolean flags specific to a Fixed Net (broadband) connection.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial refactored version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
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

    /**
    * @description Parses a JSON stream into a FixedNetFlag object.
    * @param parser The JSON parser.
    * @return A new FixedNetFlag object.
    */
    public static FixedNetFlag parse(System.JSONParser parser){
        FixedNetFlag f = new FixedNetFlag();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return f;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String fld = parser.getText(); parser.nextToken();
            if (fld == 'customerRequestsChangeProvider') f.customerRequestsChangeProvider = JsonStreamingUtil.readBooleanToken(parser);
            else if (fld == 'diggingNeeded') f.diggingNeeded = JsonStreamingUtil.readBooleanToken(parser);
            else if (fld == 'plugPresentPositiveValidation') f.plugPresentPositiveValidation = JsonStreamingUtil.readBooleanToken(parser);
            else if (fld == 'activeBlockingLinePresent') f.activeBlockingLinePresent = JsonStreamingUtil.readBooleanToken(parser);
            else if (fld == 'plugTechnicianRequired') f.plugTechnicianRequired = JsonStreamingUtil.readBooleanToken(parser);
            else parser.skipChildren();
        }
        return f;
    }

    /**
    * @description Serializes the FixedNetFlag object to a JSON string.
    * @param gen The JSON generator.
    */
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (customerRequestsChangeProvider != null) { gen.writeBooleanField('customerRequestsChangeProvider', customerRequestsChangeProvider); }
        if (diggingNeeded != null) { gen.writeBooleanField('diggingNeeded', diggingNeeded); }
        if (plugPresentPositiveValidation != null) { gen.writeBooleanField('plugPresentPositiveValidation', plugPresentPositiveValidation); }
        if (activeBlockingLinePresent != null) { gen.writeBooleanField('activeBlockingLinePresent', activeBlockingLinePresent); }
        if (plugTechnicianRequired != null) { gen.writeBooleanField('plugTechnicianRequired', plugTechnicianRequired); }
        gen.writeEndObject();
    }
}