/**
 * Dealer Class
 * 
 * This class represents the Data Transfer Object (DTO) for the Order API.
 * It is used to encapsulate the data related to an Order, including its 
 * attributes and methods for serialization and deserialization.
 * 
 * Author: [Your Name]
 * Created Date: [Creation Date]
 * 
 */
public class Dealer {
    public String dealerCode;
    public static Dealer parse(System.JSONParser parser){
        Dealer d = new Dealer();
        if (parser.getCurrentToken() == null) { parser.nextToken(); }
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) { return d; }
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) { continue; }
            String f = parser.getText(); 
            parser.nextToken();
            if (f == 'dealerCode') { d.dealerCode = JsonStreamingUtil.readStringToken(parser); }
            else { parser.skipChildren(); }
        }
        return d;
    }
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if(dealerCode != null) { gen.writeStringField('dealerCode', dealerCode); }
        gen.writeEndObject();
    }
}