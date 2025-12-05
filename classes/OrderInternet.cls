/**
 * OrderInternet Class
 * 
 * This class represents the Data Transfer Object (DTO) for the Order API.
 * It is used to encapsulate the data related to an Order, including its 
 * attributes and methods for serialization and deserialization.
 * 
 * Author: [Your Name]
 * Created Date: [Creation Date]
 * 
 */
public class OrderInternet extends Order {
    public String implementationCaseId;
    
    /** @description A list of flags that control order processing behavior. */
    public List<Flag> flags;
    public OrderInternet() {}

    public static OrderInternet parse(System.JSONParser parser){
        OrderInternet o = new OrderInternet();
        if (parser.getCurrentToken() == null) { parser.nextToken(); }
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) { return o; }
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) { continue; }
            String f = parser.getText(); parser.nextToken();

            // Base class fields
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
            // Subclass fields
            else if (f == 'implementationCaseId'){ o.implementationCaseId = JsonStreamingUtil.readStringToken(parser); }
            else { parser.skipChildren(); }
        }
        return o;
    }

    public override void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        super.serialize(gen);
        if (implementationCaseId != null){ gen.writeStringField('implementationCaseId', implementationCaseId); }
        if (flags != null){ 
            gen.writeFieldName('flags'); 
            gen.writeStartArray(); 
            for (Flag f: flags) { 
                f.serialize(gen); 
                gen.writeEndArray(); 
            }
        }
        gen.writeEndObject();
    }
}