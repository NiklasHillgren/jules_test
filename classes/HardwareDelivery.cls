/**
 * HardwareDelivery Class
 * 
 * This class represents the Data Transfer Object (DTO) for the Order API.
 * It is used to encapsulate the data related to an Order, including its 
 * attributes and methods for serialization and deserialization.
 * 
 * Author: [Your Name]
 * Created Date: [Creation Date]
 * 
 */
public class HardwareDelivery {
    public Integer id;
    public String deliveryMethod;
    public String preferredContactMethod;
    public Recipient recipient;
    public Price deliveryPrice;
    public Party billingParty;
    
    public static HardwareDelivery parse(System.JSONParser parser){
        HardwareDelivery h = new HardwareDelivery();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return h;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'id') h.id = JsonStreamingUtil.readIntegerToken(parser);
            else if (f == 'deliveryMethod') h.deliveryMethod = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'preferredContactMethod') h.preferredContactMethod = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'recipient' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) h.recipient = Recipient.parse(parser);
            else if (f == 'deliveryPrice' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) h.deliveryPrice = Price.parse(parser);
            else if (f == 'billingParty' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) h.billingParty = Party.parse(parser);
            else parser.skipChildren();
        }
        return h;
    }
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (id != null) gen.writeNumberField('id', id);
        if (deliveryMethod != null) { gen.writeStringField('deliveryMethod', deliveryMethod); }
        if (preferredContactMethod != null) { gen.writeStringField('preferredContactMethod', preferredContactMethod); }
        if (recipient != null){ gen.writeFieldName('recipient'); recipient.serialize(gen); }
        if (deliveryPrice != null){ gen.writeFieldName('deliveryPrice'); deliveryPrice.serialize(gen); }
        if (billingParty != null){ gen.writeFieldName('billingParty'); billingParty.serialize(gen); }
        gen.writeEndObject();
    }
}