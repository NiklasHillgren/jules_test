/**
 * OrderItemVoice Class
 * 
 * This class represents the Data Transfer Object (DTO) for the Order API.
 * It is used to encapsulate the data related to an Order, including its 
 * attributes and methods for serialization and deserialization.
 * 
 * Author: [Your Name]
 * Created Date: [Creation Date]
 * 
 */
public class OrderItemVoice extends OrderItem {
    public Integer id;
    public String publishLevel;
    public Telephone telephoneNumber;
    public String telephoneNumberCategory;
    public String donorSimNumber;
    public String poaDocumentUrl;
    public String poaDocumentId;
    public Boolean powerOfAttorneyManualHandling;
    public String earliestPortingDate;
    public Party subscriptionUser;
    public HardwareDetail hardwareDetail;
    public SimDetail simDetail;
    public ShippingDetail shippingDetail;
    /** @description The type of product. */
    public String productType;
    /** @description The billing party for this item, used in Root BAN creation. */
    public Party billingParty;
    public TerminationPeriod terminationPeriod;
    
    public static OrderItemVoice parse(System.JSONParser parser){
        OrderItemVoice it = new OrderItemVoice();
        if (parser.getCurrentToken() == null) { parser.nextToken(); }
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) { return it; }
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) { continue; }
            String f = parser.getText(); 
            parser.nextToken();
            if (f == 'telephoneNumber' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { it.telephoneNumber = Telephone.parse(parser); }
            else if (f == 'id') { it.id = JsonStreamingUtil.readIntegerToken(parser); }
            else if (f == 'publishLevel') { it.publishLevel = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'telephoneNumberCategory') { it.telephoneNumberCategory = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'donorSimNumber') { it.donorSimNumber = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'poaDocumentUrl') { it.poaDocumentUrl = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'poaDocumentId') { it.poaDocumentId = JsonStreamingUtil.readStringToken(parser); }
            else if (f == 'powerOfAttorneyManualHandling') { it.powerOfAttorneyManualHandling = JsonStreamingUtil.readBooleanToken(parser); }
            else if (f == 'earliestPortingDate') { it.earliestPortingDate = JsonStreamingUtil.readStringToken(parser); }
            
            else if (f == 'subscriptionUser' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { it.subscriptionUser = Party.parse(parser); }
            else if (f == 'hardwareDetail' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { it.hardwareDetail = HardwareDetail.parse(parser); }
            else if (f == 'productType') { it.productType = JsonStreamingUtil.readStringToken(parser); }
            
            else if (f == 'billingParty' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { it.billingParty = Party.parse(parser); }
            else if (f == 'simDetail' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { it.simDetail = SimDetail.parse(parser); }
            else if (f == 'shippingDetail' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { it.shippingDetail = ShippingDetail.parse(parser); }
            else if (f == 'terminationPeriod' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) { it.terminationPeriod = TerminationPeriod.parse(parser); }
            else {
                // fallback to base parsing for other fields
                parser.skipChildren();
            }
        }
        return it;
    }
    public override void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (productType != null) { gen.writeStringField('productType', productType); }
        if (telephoneNumber != null){ gen.writeFieldName('telephoneNumber'); telephoneNumber.serialize(gen); }
        if (billingParty != null){ gen.writeFieldName('billingParty'); billingParty.serialize(gen); }
        if (simDetail != null){ gen.writeFieldName('simDetail'); simDetail.serialize(gen); }
        if (shippingDetail != null){ gen.writeFieldName('shippingDetail'); shippingDetail.serialize(gen); }
        if (terminationPeriod != null){ gen.writeFieldName('terminationPeriod'); terminationPeriod.serialize(gen); }
        
        if (id != null) { gen.writeNumberField('id', id); }
        if (publishLevel != null) { gen.writeStringField('publishLevel', publishLevel); }
        if (telephoneNumberCategory != null) { gen.writeStringField('telephoneNumberCategory', telephoneNumberCategory); }
        if (donorSimNumber != null) { gen.writeStringField('donorSimNumber', donorSimNumber); }
        if (poaDocumentUrl != null) { gen.writeStringField('poaDocumentUrl', poaDocumentUrl); }
        if (poaDocumentId != null) { gen.writeStringField('poaDocumentId', poaDocumentId); }
        if (powerOfAttorneyManualHandling != null) { gen.writeBooleanField('powerOfAttorneyManualHandling', powerOfAttorneyManualHandling); }
        if (earliestPortingDate != null) { gen.writeStringField('earliestPortingDate', earliestPortingDate); }
        if (subscriptionUser != null){ gen.writeFieldName('subscriptionUser'); subscriptionUser.serialize(gen); }
        if (hardwareDetail != null){ gen.writeFieldName('hardwareDetail'); hardwareDetail.serialize(gen); }
        
        gen.writeEndObject();
    }
}