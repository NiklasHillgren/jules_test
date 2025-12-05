/**
* @description Represents a physical address. This DTO consolidates fields from the legacy
*              Address and InstallationAddress DAOs to represent both postal and installation addresses.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial refactored version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public class Address {
    /** @description The name of the street. */
    public String streetName;
    /** @description The house number on the street. */
    public String streetNumber;
    /** @description The suffix for the house number (e.g., 'A', 'B'). */
    public String streetNumberSuffix;
    /** @description The floor number. */
    public String floorNumber;
    /** @description The door number or apartment number. */
    public String doorNumber;
    /** @description The direction of the door (e.g., 'tv', 'th'). */
    public String direction;
    /** @description The city name. */
    public String city;
    /** @description The postal zip code. */
    public String zipCode;
    /** @description The country, typically in 3-letter ISO format (e.g., 'DNK'). */
    public String country;
    /** @description The official municipality code. */
    public String municipalityCode;
    /** @description The official street code. */
    public String attention;
    /** @description A reference ID for the address from an external system. */
    public String coName;

    /**
    * @description Parses a JSON stream into an Address object.
    * @param parser The JSON parser.
    * @return A new Address object.
    */
    public static Address parse(System.JSONParser parser){
        Address a = new Address();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return a;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'streetName') a.streetName = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'streetNumber') a.streetNumber = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'streetNumberSuffix') a.streetNumberSuffix = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'floorNumber') a.floorNumber = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'doorNumber') a.doorNumber = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'direction') a.direction = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'city') a.city = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'zipCode') a.zipCode = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'country') a.country = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'municipalityCode') a.municipalityCode = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'attention') a.attention = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'coName') a.coName = JsonStreamingUtil.readStringToken(parser);
            else parser.skipChildren();
        }
        return a;
    }

    /**
    * @description Serializes the Address object to a JSON string.
    * @param gen The JSON generator.
    */
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (streetName != null) { gen.writeStringField('streetName', streetName); }
        if (streetNumber != null) { gen.writeStringField('streetNumber', streetNumber); }
        if (streetNumberSuffix != null) { gen.writeStringField('streetNumberSuffix', streetNumberSuffix); }
        if (floorNumber != null) { gen.writeStringField('floorNumber', floorNumber); }
        if (doorNumber != null) { gen.writeStringField('doorNumber', doorNumber); }
        if (direction != null) { gen.writeStringField('direction', direction); }
        if (city != null) { gen.writeStringField('city', city); }
        if (zipCode != null) { gen.writeStringField('zipCode', zipCode); }
        if (country != null) { gen.writeStringField('country', country); }
        if (municipalityCode != null) { gen.writeStringField('municipalityCode', municipalityCode); } 
        if (attention != null) { gen.writeStringField('attention', attention); }
        if (coName != null) { gen.writeStringField('coName', coName); }
        gen.writeEndObject();
    }
}