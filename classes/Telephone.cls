/**
* @description Represents a telephone number, including the country code and local number.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial refactored version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public class Telephone {
    /** @description The international country code (e.g., '45' for Denmark). */
    public String countryCode;
    /** @description The local part of the telephone number. */
    public String localNumber;

    /**
    * @description Parses a JSON stream into a Telephone object.
    * @param parser The JSON parser.
    * @return A new Telephone object.
    */
    public static Telephone parse(System.JSONParser parser){
        Telephone t = new Telephone();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return t;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'countryCode') { t.countryCode = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'localNumber') { t.localNumber = JsonStreamingUtil.readStringToken(parser); }
            else parser.skipChildren();
        }
        return t;
    }

    /**
    * @description Serializes the Telephone object to a JSON string.
    * @param gen The JSON generator.
    */
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (countryCode != null) { gen.writeStringField('countryCode', countryCode); }
        if (localNumber != null) { gen.writeStringField('localNumber', localNumber); }
        gen.writeEndObject();
    }
}