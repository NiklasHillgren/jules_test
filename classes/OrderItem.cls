/**
* @description Represents a single item within an OrderPart. This is a versatile DTO that can represent
*              a subscription, a fee, a discount, or an account-level item. It serves as a base class
*              for more specific item types like OrderItemInternet.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial refactored version.
*  Kenneth Houkjær      11/09/2025      Added fields for Root BAN creation.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public virtual class OrderItem {
    /** @description The type of order item (e.g., 'SUBSCRIPTION_ITEM', 'ACCOUNT_ITEM', 'DISCOUNT_ITEM'). */
    public String type;
    /** @description The activity being performed (e.g., 'CREATE', 'CHANGE'). */
    public String activity;
    /** @description The specific code or ID for the product. */
    public String productCode;
    /** @description The quantity of the product/service. */
    public Integer quantity;
    /** @description The offering details, such as price plan and campaign. */
    public Offering offering;
    /** @description The legal party associated with this item, particularly for account creation. */
    public Party legalParty;
   
    
	public Boolean productDeliveryAsap;
    /** @description The desired invoice method (e.g., 'PDF_BY_EMAIL'). */
    public String invoiceType;
    /** @description The billing frequency (e.g., 'MONTHLY'). */
    public String billingCycle;
    /** @description The category of the product (e.g., 'VIP_TML_ROOT'). */
    public String category;
        /** @description The category of the product (e.g., 'VIP_TML_ROOT'). */
    public String paymentMethod;

    /** @description A list of validation errors specific to this order item. */
    public List<ValidationErrors> validationErrors;

    /**
    * @description Default constructor, initializes lists.
    */
    public OrderItem(){ validationErrors = new List<ValidationErrors>(); }

    /**
    * @description Parses a JSON stream into a base OrderItem object.
    * @param parser The JSON parser.
    * @return A new OrderItem object.
    */
    public static OrderItem parse(System.JSONParser parser){
        OrderItem it = new OrderItem();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return null;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'type') {it.type = JsonStreamingUtil.readStringToken(parser);}
            else if (f == 'activity') {it.activity = JsonStreamingUtil.readStringToken(parser);}
            else if (f == 'productCode') {it.productCode = JsonStreamingUtil.readStringToken(parser);}
        	else if (f == 'quantity') {it.quantity = JsonStreamingUtil.readIntegerToken(parser);}
    		else if (f == 'newOffering' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) {it.offering = Offering.parse(parser);}
			else if (f == 'legalParty' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) {it.legalParty = Party.parse(parser);}
			else if (f == 'productDeliveryAsap') {it.productDeliveryAsap = JsonStreamingUtil.readBooleanToken(parser);}
			else if (f == 'invoiceType') {it.invoiceType = JsonStreamingUtil.readStringToken(parser);}
			else if (f == 'billingCycle') {it.billingCycle = JsonStreamingUtil.readStringToken(parser);}
			else if (f == 'paymentMethod') {it.paymentMethod = JsonStreamingUtil.readStringToken(parser);}
			else if (f == 'productCategory') {it.category = JsonStreamingUtil.readStringToken(parser);}
            else if (f == 'validationErrors' && parser.getCurrentToken() == System.JSONToken.START_ARRAY) {
                while(parser.nextToken() != System.JSONToken.END_ARRAY){
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) { it.validationErrors.add(ValidationErrors.parse(parser)); }
                    else parser.skipChildren();
                }
            }
			else {parser.skipChildren();}
        }
        return it;
    }

    /**
    * @description Serializes the OrderItem object to a JSON string.
    * @param gen The JSON generator.
    */
    public virtual void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (type != null) { gen.writeStringField('type', type); }
        if (activity != null) { gen.writeStringField('activity', activity); }
        if (productCode != null) { gen.writeStringField('productCode', productCode); }
        if (quantity != null) { gen.writeNumberField('quantity', quantity); }
        if (offering != null){ gen.writeFieldName('newOffering'); offering.serialize(gen); }
        if (legalParty != null){ gen.writeFieldName('legalParty'); legalParty.serialize(gen); }
        
        if (invoiceType != null) { gen.writeStringField('invoiceType', invoiceType); }
        if (billingCycle != null) { gen.writeStringField('billingCycle', billingCycle); }
        if (paymentMethod != null) { gen.writeStringField('paymentMethod', paymentMethod); }
        if (category != null) { gen.writeStringField('productCategory', category); }
        gen.writeEndObject();
    }
}