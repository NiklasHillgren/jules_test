/**
 * ShippingDetail Class
 * 
 * This class represents the Data Transfer Object (DTO) for the Order API.
 * It is used to encapsulate the data related to an Order, including its 
 * attributes and methods for serialization and deserialization.
 * 
 * Author: [Your Name]
 * Created Date: [Creation Date]
 * 
 */
public class ShippingDetail {
    public Integer hardwareDeliveryId;
    public Integer toDeliverQuantity;
    public String erpTsProduct;
    public String tsfOffering;
    
    public static ShippingDetail parse(System.JSONParser parser){
        ShippingDetail s = new ShippingDetail();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return s;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'hardwareDeliveryId') s.hardwareDeliveryId = JsonStreamingUtil.readIntegerToken(parser);
            else if (f == 'toDeliverQuantity') s.toDeliverQuantity = JsonStreamingUtil.readIntegerToken(parser);
            else if (f == 'erpTsProduct') s.erpTsProduct = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'tsfOffering') s.tsfOffering = JsonStreamingUtil.readStringToken(parser);
            else parser.skipChildren();
        }
        return s;
    }
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (hardwareDeliveryId != null) { gen.writeNumberField('hardwareDeliveryId', hardwareDeliveryId); }
        if (toDeliverQuantity != null) { gen.writeNumberField('toDeliverQuantity', toDeliverQuantity); }
        if (erpTsProduct != null) { gen.writeStringField('erpTsProduct', erpTsProduct); }
        if (tsfOffering != null) { gen.writeStringField('tsfOffering', tsfOffering); }
        gen.writeEndObject();
    }
}