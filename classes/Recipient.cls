/**
 * Recipient Class
 * 
 * This class represents the Data Transfer Object (DTO) for the Order API.
 * It is used to encapsulate the data related to an Order, including its 
 * attributes and methods for serialization and deserialization.
 * 
 * Author: [Your Name]
 * Created Date: [Creation Date]
 * 
 */
public class Recipient {
    public String type;
    public String name;
    public String cvr;
    public Address address;
    public String email;
    public Telephone telephoneNumber;
    
    public static Recipient parse(System.JSONParser parser){
        Recipient r = new Recipient();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return r;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'type') r.type = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'name') r.name = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'cvr') r.cvr = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'email') r.email = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'address' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) r.address = Address.parse(parser);
            else if (f == 'telephoneNumber' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) r.telephoneNumber = Telephone.parse(parser);
            else parser.skipChildren();
        }
        return r;
    }
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (type != null) { gen.writeStringField('type', type); }
        if (name != null) { gen.writeStringField('name', name); }
        if (cvr != null) { gen.writeStringField('cvr', cvr); }
        if (email != null) { gen.writeStringField('email', email); }
        if (address != null) { gen.writeFieldName('address'); address.serialize(gen); }
        if (telephoneNumber != null) { gen.writeFieldName('telephoneNumber'); telephoneNumber.serialize(gen); }
        gen.writeEndObject();
    }
}