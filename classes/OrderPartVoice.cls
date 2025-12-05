/**
 * OrderPartVoice Class
 * 
 * This class represents the Data Transfer Object (DTO) for the Order API.
 * It is used to encapsulate the data related to an Order, including its 
 * attributes and methods for serialization and deserialization.
 * 
 * Author: [Your Name]
 * Created Date: [Creation Date]
 * 
 */
public class OrderPartVoice extends OrderPart {
    public String orderPartVoiceId;
    
    public static OrderPartVoice parse(System.JSONParser parser){
        OrderPartVoice p = new OrderPartVoice();
        if (parser.getCurrentToken() == null) { parser.nextToken(); }
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) { return p; }
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) { continue; }
            String f = parser.getText(); 
            parser.nextToken();
            if (f == 'id') { p.orderPartVoiceId = JsonStreamingUtil.readStringToken(parser); }
            else parser.skipChildren();
        }
        return p;
    }
    public override void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        super.serialize(gen);
        if(orderPartVoiceId != null) { gen.writeStringField('id', orderPartVoiceId); }
        gen.writeEndObject();
    }
}