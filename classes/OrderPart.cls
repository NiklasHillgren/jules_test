/**
* @description Represents a part of an order, which is a key component in the hierarchical structure
*              of the Order API payload. An OrderPart can contain OrderItems, other nested OrderParts,
*              and References. It serves as a base class for more specific parts like OrderPartInternet.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial refactored version.
*  Kenneth Houkjær      11/09/2025      Added nested orderParts list.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public virtual class OrderPart {
    /** @description The activity being performed on this part of the order (e.g., 'CREATE', 'CHANGE'). */
    public String activity;
    /** @description The type of entity this order part represents (e.g., 'ACCOUNT', 'SUBSCRIPTION'). */
    public String type;
    /** @description A list of individual items (products, services, fees) within this order part. */
    public List<OrderItem> orderItems;
    /** @description A list of nested order parts to create a hierarchical structure. */
    public List<OrderPart> orderParts;
    /** @description A list of references to other entities, like a Billing Account Number. */
    public List<Reference> references;
 
    /** @description A list of validation errors specific to this order part. */
    public List<ValidationErrors> validationErrors;

    /**
    * @description Default constructor, initializes lists.
    */
    public OrderPart(){
        orderItems = new List<OrderItem>();
        references = new List<Reference>();
        orderParts = new List<OrderPart>();
        validationErrors = new List<ValidationErrors>();
    }

    /**
    * @description Parses a JSON stream into a base OrderPart object.
    * @param parser The JSON parser.
    * @return A new OrderPart object.
    */
    public static OrderPart parse(System.JSONParser parser){
        OrderPart p = new OrderPart();
        if (parser.getCurrentToken() == null) { parser.nextToken(); }
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) { return p; }
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) { continue; }
            String f = parser.getText(); 
            parser.nextToken();
            if (f == 'activity') { p.activity = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'type') { p.type = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'orderItems' && parser.getCurrentToken() == System.JSONToken.START_ARRAY){
                while(parser.nextToken() != System.JSONToken.END_ARRAY){
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) { p.orderItems.add(OrderItem.parse(parser)); }
                    else { parser.skipChildren(); }
                }
            } else if (f == 'orderParts' && parser.getCurrentToken() == System.JSONToken.START_ARRAY){
                while(parser.nextToken() != System.JSONToken.END_ARRAY){
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) { p.orderParts.add(OrderPart.parse(parser)); }
                    else { parser.skipChildren(); }
                }
            } else if (f == 'references' && parser.getCurrentToken() == System.JSONToken.START_ARRAY){
                while(parser.nextToken() != System.JSONToken.END_ARRAY){
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) { p.references.add(Reference.parse(parser)); }
                    else { parser.skipChildren(); }
                }
            } else if (f == 'validationErrors' && parser.getCurrentToken() == System.JSONToken.START_ARRAY) {
                while(parser.nextToken() != System.JSONToken.END_ARRAY){
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) { p.validationErrors.add(ValidationErrors.parse(parser)); }
                    else { parser.skipChildren(); }
                }
            } else { parser.skipChildren(); }
        }
        return p;
    }

    /**
    * @description Serializes the OrderPart object to a JSON string. This method is virtual
    *              to allow subclasses to add their own fields.
    * @param gen The JSON generator.
    */
    public virtual void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (activity != null){ gen.writeStringField('activity', activity); }
        if (type != null){ gen.writeStringField('type', type); }
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
                op.serialize(gen); gen.writeEndArray(); 
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