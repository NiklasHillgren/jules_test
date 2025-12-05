/**
* @description Represents a generic reference to another entity, consisting of a type and a value.
*              This is typically used to link an order part to an account using its BAN.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial refactored version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public class Reference {
    /** @description The type of reference (e.g., 'BILLING_ACCOUNT_NUMBER'). */
    public String type;
    /** @description The value of the reference (e.g., the actual BAN). */
    public String value;

    /**
    * @description Parses a JSON stream into a Reference object.
    * @param parser The JSON parser.
    * @return A new Reference object.
    */
    public static Reference parse(System.JSONParser parser){
        Reference r = new Reference();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return r;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'type') r.type = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'value') r.value = JsonStreamingUtil.readStringToken(parser);
            else parser.skipChildren();
        }
        return r;
    }

    /**
    * @description Serializes the Reference object to a JSON string.
    * @param gen The JSON generator.
    */
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (type != null) { gen.writeStringField('type', type); }
        if (value != null) { gen.writeStringField('value', value); }
        gen.writeEndObject();
    }
}