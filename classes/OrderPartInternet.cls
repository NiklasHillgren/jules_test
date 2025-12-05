/**
* @description Represents a specific type of OrderPart for an Internet-related account. It extends
*              the base OrderPart and adds a channel-specific identifier.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial refactored version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public class OrderPartInternet extends OrderPart {
    /** @description A channel-specific identifier for this part of the order, typically the Salesforce Record ID of the Activation Line. */
    public String channelOrderPartId;

    /**
    * @description Parses a JSON stream into an OrderPartInternet object.
    * @param parser The JSON parser.
    * @return A new OrderPartInternet object.
    */
    public static OrderPartInternet parse(System.JSONParser parser){
        OrderPartInternet p = new OrderPartInternet();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return p;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'activity') p.activity = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'type') p.type = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'channelOrderPartId') p.channelOrderPartId = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'orderItems' && parser.getCurrentToken() == System.JSONToken.START_ARRAY){
                while(parser.nextToken() != System.JSONToken.END_ARRAY){
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) p.orderItems.add(OrderItem.parse(parser));
                    else parser.skipChildren();
                }
            } else if (f == 'orderParts' && parser.getCurrentToken() == System.JSONToken.START_ARRAY){
                while(parser.nextToken() != System.JSONToken.END_ARRAY){
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) p.orderParts.add(OrderPart.parse(parser));
                    else parser.skipChildren();
                }
            } else if (f == 'references' && parser.getCurrentToken() == System.JSONToken.START_ARRAY){
                while(parser.nextToken() != System.JSONToken.END_ARRAY){
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) p.references.add(Reference.parse(parser));
                    else parser.skipChildren();
                }
            } else parser.skipChildren();
        }
        return p;
    }

    /**
    * @description Serializes the OrderPartInternet object to a JSON string.
    * @param gen The JSON generator.
    */
    public override void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (activity != null){ gen.writeStringField('activity', activity);}
        if (type != null){ gen.writeStringField('type', type); }
        if (channelOrderPartId != null){ gen.writeStringField('channelOrderPartId', channelOrderPartId); }
        if (orderItems != null){ 
            gen.writeFieldName('orderItems'); 
            gen.writeStartArray(); 
            for (OrderItem it: orderItems) {
                it.serialize(gen); gen.writeEndArray(); 
            }
        }
        if (orderParts != null){ 
            gen.writeFieldName('orderParts'); 
            gen.writeStartArray(); 
            for (OrderPart op: orderParts) {
                op.serialize(gen); 
                gen.writeEndArray(); 
            }
        }
        if (references != null){ 
            gen.writeFieldName('references'); 
            gen.writeStartArray(); 
            for (Reference r: references) {
                r.serialize(gen); 
                gen.writeEndArray(); 
            }
        }
        gen.writeEndObject();
    }
}