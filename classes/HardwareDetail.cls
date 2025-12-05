/**
 * HardwareDetail Class
 * 
 * This class represents the Data Transfer Object (DTO) for the Order API.
 * It is used to encapsulate the data related to an Order, including its 
 * attributes and methods for serialization and deserialization.
 * 
 * Author: [Your Name]
 * Created Date: [Creation Date]
 * 
 */
public class HardwareDetail {
    public String materialId;
    public String hardwareType;
    public String name;
    public static HardwareDetail parse(System.JSONParser parser){
        HardwareDetail h = new HardwareDetail();
        if (parser.getCurrentToken() == null) { parser.nextToken(); }
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) { return h; }
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) { continue; }
            String f = parser.getText(); 
            parser.nextToken();
            if (f == 'materialId') { h.materialId = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'hardwareType') { h.hardwareType = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'name') { h.name = JsonStreamingUtil.readStringToken(parser); }
            else parser.skipChildren();
        }
        return h;
    }
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (materialId != null) { gen.writeStringField('materialId', materialId); }
        if (materialId != null) { gen.writeStringField('hardwareType', hardwareType); }
        if (materialId != null) { gen.writeStringField('name', name); }
        gen.writeEndObject();
    }
}