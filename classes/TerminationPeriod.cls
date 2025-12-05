/**
 * TerminationPeriod Class
 * 
 * This class represents the Data Transfer Object (DTO) for the Order API.
 * It is used to encapsulate the data related to an Order, including its 
 * attributes and methods for serialization and deserialization.
 * 
 * Author: [Your Name]
 * Created Date: [Creation Date]
 * 
 */
public class TerminationPeriod {
    public Integer amount;
    public String unit;
    public static TerminationPeriod parse(System.JSONParser parser){
        TerminationPeriod t = new TerminationPeriod();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return t;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'amount') t.amount = JsonStreamingUtil.readIntegerToken(parser);
            else if (f == 'unit') t.unit = JsonStreamingUtil.readStringToken(parser);
            else parser.skipChildren();
        }
        return t;
    }
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (amount != null) { gen.writeNumberField('amount', amount); }
        if (unit != null) { gen.writeStringField('unit', unit); }
        gen.writeEndObject();
    }
}