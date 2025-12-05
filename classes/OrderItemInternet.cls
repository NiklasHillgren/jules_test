/**
* @description Represents an OrderItem for an Internet subscription. It extends the base OrderItem
*              and adds fields specific to Fixed Net products, such as technical details and
*              activation date preferences.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial refactored version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public class OrderItemInternet extends OrderItem {
    /** @description A nested object containing the technical details of the fixed net connection. */
    public FixedNetDetail fixedNetDetails;
    /** @description The overall price details for the order. */
    public Price price;
    /** @description The customer's preferred date for service activation. */
    public Date preferredActivationDate;
    /** @description A flag to request As-Soon-As-Possible delivery for any related products. */
    public Boolean productDeliveryAsap;
    /** @description A charge code for transfers. */
    public String upTransferChargeCode;
    /** @description A discount code to be applied. */
    public String discountCode;
    
    public String feeId;
    public String feeType;
    public String displayName;
    public String label;
    public String billingCode;
    public String productGroup;
    public Boolean recurring;

    /**
    * @description Parses a JSON stream into an OrderItemInternet object.
    * @param parser The JSON parser.
    * @return A new OrderItemInternet object.
    */
    public static OrderItemInternet parse(System.JSONParser parser) { 
        OrderItemInternet it = new OrderItemInternet();
        if (parser.getCurrentToken() == null) { 
            parser.nextToken(); 
        }
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) { 
            return it; 
        }
        
        while(parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) { 
                continue; 
            }
            String f = parser.getText(); 
            parser.nextToken();

            // Base class fields
            if (f == 'activity') { it.activity = JsonStreamingUtil.readStringToken(parser); }
            
            else if (f == 'quantity') { it.quantity = JsonStreamingUtil.readIntegerToken(parser); }
            else if (f == 'offering' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { it.offering = Offering.parse(parser); }
            else if (f == 'price' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { it.price = Price.parse(parser); }
            // Subclass fields
            
            else if (f == 'fixedNetDetails' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { it.fixedNetDetails = FixedNetDetail.parse(parser); }
            else if (f == 'preferredActivationDate') { it.preferredActivationDate = JsonStreamingUtil.readDateToken(parser); }
            else if (f == 'productDeliveryAsap') { it.productDeliveryAsap = JsonStreamingUtil.readBooleanToken(parser); }
            else if (f == 'recurring') { it.recurring = JsonStreamingUtil.readBooleanToken(parser); }
            else if (f=='feeId') { it.feeId = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'feeType') { it.feeType = JsonStreamingUtil.readStringToken(parser); }            
            else if (f == 'displayName') { it.displayName = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'label') { it.label = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'billingCode') { it.billingCode = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'productGroup') { it.productGroup = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'discountCode') { it.discountCode = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'upTransferChargeCode') { it.upTransferChargeCode = JsonStreamingUtil.readStringToken(parser); }
            else { parser.skipChildren(); }
        }
        
        return it;
    }
    
    /**
    * @description Serializes the OrderItemInternet object to a JSON string.
    * @param gen The JSON generator.
    */
    public override void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        super.serialize(gen); // Serialize base class fields
        
        // Serialize subclass fields
        if (fixedNetDetails != null) { gen.writeFieldName('fixedNetDetails'); fixedNetDetails.serialize(gen); }
        if (preferredActivationDate != null) { gen.writeDateField('preferredActivationDate', preferredActivationDate); }
        if (productDeliveryAsap != null) { gen.writeBooleanField('productDeliveryAsap', productDeliveryAsap); }
        if (price != null) { gen.writeFieldName('price'); price.serialize(gen); }
        if (upTransferChargeCode != null) { gen.writeStringField('upTransferChargeCode', upTransferChargeCode); }
        if (discountCode != null) { gen.writeStringField('discountCode', discountCode); }
        
        if (feeId != null) { gen.writeStringField('feeId', feeId); }
        if (feeType != null) { gen.writeStringField('feeType', feeType); }
        if (displayName != null) { gen.writeStringField('displayName', displayName); }
        if (label != null) { gen.writeStringField('label', label); }
        if (billingCode != null) { gen.writeStringField('billingCode', billingCode); }
        if (productGroup != null) { gen.writeStringField('productGroup', productGroup); }
        if (recurring != null) { gen.writeBooleanField('recurring', recurring); }
        
        gen.writeEndObject();
    }
}