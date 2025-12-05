/**
* @description Represents the offering details for a product, such as its price plan and any associated campaign.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial refactored version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public class Offering {
    /** @description The code for the price plan associated with the offering. */
    public String priceplan;
    /** @description The code for the campaign associated with the offering. */
    public String campaign;
    /** @description A unique identifier for the product offering. */
    public String productOfferingId;

    /**
    * @description Parses a JSON stream into an Offering object.
    * @param parser The JSON parser.
    * @return A new Offering object.
    */
    public static Offering parse(System.JSONParser parser){
        Offering o = new Offering();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return o;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'priceplan') o.priceplan = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'campaign') o.campaign = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'productOfferingId') o.productOfferingId = JsonStreamingUtil.readStringToken(parser);
            else parser.skipChildren();
        }
        return o;
    }

    /**
    * @description Serializes the Offering object to a JSON string.
    * @param gen The JSON generator.
    */
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        gen.writeStringField('priceplan', priceplan);
        gen.writeStringField('campaign', campaign);
        gen.writeStringField('productOfferingId', productOfferingId);
        gen.writeEndObject();
    }
}