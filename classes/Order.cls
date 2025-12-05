/**
 * @description Represents the top-level Order Data Transfer Object (DTO) for the Order API.
 *              This class serves as the base for different order types (e.g., Internet, Voice) and
 *              contains the common fields and serialization/deserialization logic for an order.
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær      11/09/2025      Initial refactored version.
 *  Kenneth Houkjær      11/09/2025      Added 'channel' and 'segment' fields.
 *  Kenneth Houkjær      11/09/2025      Added 'orderer' field for Root BAN creation.
 *
 * @author Kenneth Houkjær
 * @date 2025-09-11
 */
public virtual class Order {
    /** @description The brand context for the order (e.g., 'TDC'). */
    public String brand;
    /** @description The sales channel through which the order was placed (e.g., 'B2B'). */
    public String channel;
    /** @description The customer segment (e.g., 'B2B'). */
    public String segment;
    /** @description The dealer associated with the order. */
    public Dealer dealer;
    /** @description The party placing the order, especially for Root BAN creation. */
    public Party orderer;
    /** @description A list of order parts, which form the hierarchical structure of the order. */
    public List<OrderPart> orderParts;
    /** @description Indicates if the response contains validation errors. */
    public Boolean hasValidationErrors;
    /** @description A list of validation errors. */
    public List<ValidationErrors> validationErrors;

    /**
     * @description Default constructor, initializes lists.
     */
    public Order() {
        orderParts = new List<OrderPart>();
        validationErrors = new List<ValidationErrors>();
    }

    /**
     * @description Parses a JSON stream into a base Order object.
     * @param parser The JSON parser.
     * @return A new Order object.
     */
    public static Order parse(System.JSONParser parser) {
        Order o = new Order();
        if (parser.getCurrentToken() == null)
            parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT)
            return null;
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME)
                continue;
            String f = parser.getText();
            parser.nextToken();
            if (f == 'brand')
                o.brand = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'channel')
                o.channel = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'segment')
                o.segment = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'dealer' && parser.getCurrentToken() == System.JSONToken.START_OBJECT)
                o.dealer = Dealer.parse(parser);
            else if (f == 'orderer' && parser.getCurrentToken() == System.JSONToken.START_OBJECT)
                o.orderer = Party.parse(parser);
            else if (f == 'orderParts' && parser.getCurrentToken() == System.JSONToken.START_ARRAY) {
                while (parser.nextToken() != System.JSONToken.END_ARRAY) {
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT)
                        o.orderParts.add(OrderPart.parse(parser));
                    else
                        parser.skipChildren();
                }
            } else if (f == 'hasValidationErrors') {
                o.hasValidationErrors = parser.getBooleanValue();
            } else if (f == 'validationErrors' && parser.getCurrentToken() == System.JSONToken.START_ARRAY) {
                while (parser.nextToken() != System.JSONToken.END_ARRAY) {
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT)
                        o.validationErrors.add(ValidationErrors.parse(parser));
                    else
                        parser.skipChildren();
                }
            } else
                parser.skipChildren();
        }
        return o;
    }

    /**
     * @description Serializes the Order object to a JSON string.
     * @param gen The JSON generator.
     */
    public virtual void serialize(System.JSONGenerator gen) {
        gen.writeStartObject();
        if (brand != null) {
            gen.writeStringField('brand', brand);
        }
        if (channel != null) {
            gen.writeStringField('channel', channel);
        }
        if (segment != null) {
            gen.writeStringField('segment', segment);
        }
        if (dealer != null) {
            gen.writeFieldName('dealer');
            dealer.serialize(gen);
        }
        if (orderer != null) {
            gen.writeFieldName('orderer');
            orderer.serialize(gen);
        }
        if (orderParts != null) {
            gen.writeFieldName('orderParts');
            gen.writeStartArray();
            for (OrderPart p : orderParts) {
                p.serialize(gen);
            }
            gen.writeEndArray(); //Niklas moved down one line
        }
        gen.writeEndObject();
    }
}