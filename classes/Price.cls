/**
 * Price Class
 * 
 * This class represents the Data Transfer Object (DTO) for the Order API.
 * It is used to encapsulate the data related to an Order, including its 
 * attributes and methods for serialization and deserialization.
 * 
 * Author: [Your Name]
 * Created Date: [Creation Date]
 * 
 */
public class Price {
    public String priceCurrency;
    public Decimal amount;
    public Decimal vat;
    public static Price parse(System.JSONParser parser){
        Price p = new Price();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return p;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'currency') p.priceCurrency = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'amount') p.amount = JsonStreamingUtil.readDecimalToken(parser);
            else if (f == 'vat') p.vat = JsonStreamingUtil.readDecimalToken(parser);
            else parser.skipChildren();
        }
        return p;
    }
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (priceCurrency != null) { gen.writeStringField('currency', priceCurrency); }
        if (amount != null) { gen.writeNumberField('amount', amount); }
        if (vat != null) { gen.writeNumberField('vat', vat); }
        gen.writeEndObject();
    }
}