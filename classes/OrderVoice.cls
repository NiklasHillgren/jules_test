/**
 * OrderVoice Class
 * 
 * This class represents the Data Transfer Object (DTO) for the Order API.
 * It is used to encapsulate the data related to an Order, including its 
 * attributes and methods for serialization and deserialization.
 * 
 * Author: [Your Name]
 * Created Date: [Creation Date]
 * 
 */
public class OrderVoice extends Order {
    public String createdBy;
    public List<HardwareDelivery> hardwareDeliveries;
    
    public OrderVoice(){ 
        hardwareDeliveries = new List<HardwareDelivery>(); 
    }
    
    public static OrderVoice parse(System.JSONParser parser){
        OrderVoice o = new OrderVoice();
        if (parser.getCurrentToken() == null) { parser.nextToken(); }
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) { return o; }
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) { continue; }
            
            String f = parser.getText(); 
            parser.nextToken();
            
            if (f == 'brand') { o.brand = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'channel') { o.channel = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'segment') { o.segment = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'dealer' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { o.dealer = Dealer.parse(parser); }
            else if (f == 'orderer' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { o.orderer = Party.parse(parser); }
            else if (f == 'orderParts' && parser.getCurrentToken() == System.JSONToken.START_ARRAY){
                while(parser.nextToken() != System.JSONToken.END_ARRAY){
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) { o.orderParts.add(OrderPart.parse(parser)); }
                    else parser.skipChildren();
                }
            }
            else if (f == 'createdBy') { o.createdBy = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'hardwareDeliveries' && parser.getCurrentToken() == System.JSONToken.START_ARRAY) {
                while(parser.nextToken() != System.JSONToken.END_ARRAY){
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) { o.hardwareDeliveries.add(HardwareDelivery.parse(parser)); }
                    else parser.skipChildren();
                }
            } 
            else if (f == 'orderer' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { o.orderer = Party.parse(parser); }
            else { parser.skipChildren(); }
        }
        return o;
    }
    public override void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        super.serialize(gen);
        if (dealer != null) { gen.writeStringField('createdBy', createdBy); }
        if (hardwareDeliveries != null) { 
            gen.writeFieldName('hardwareDeliveries'); 
            gen.writeStartArray(); 
            for (HardwareDelivery h: hardwareDeliveries) { 
                h.serialize(gen); 
                gen.writeEndArray(); 
            }
        }
        gen.writeEndObject();
    }
}