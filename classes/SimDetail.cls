/**
 * SimDetail Class
 * 
 * This class represents the Data Transfer Object (DTO) for the Order API.
 * It is used to encapsulate the data related to an Order, including its 
 * attributes and methods for serialization and deserialization.
 * 
 * Author: [Your Name]
 * Created Date: [Creation Date]
 * 
 */
public class SimDetail {
    public String simType;
    public Boolean waiveSimSwapFee;
    public String hardwareType;
    
    public static SimDetail parse(System.JSONParser parser){
        SimDetail s = new SimDetail();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return s;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'simType') s.simType = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'hardwareType') s.hardwareType = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'waiveSimSwapFee') s.waiveSimSwapFee = JsonStreamingUtil.readBooleanToken(parser);
            else parser.skipChildren();
        }
        return s;
    }
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (simType != null) { gen.writeStringField('simType', simType); }
        if (hardwareType != null) { gen.writeStringField('hardwareType', hardwareType); }
        if (waiveSimSwapFee != null) { gen.writeBooleanField('waiveSimSwapFee', waiveSimSwapFee); }
        gen.writeEndObject();
    }
}