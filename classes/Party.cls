/**
* @description Represents a party involved in an order, which can be a person or an organization.
*              This base class is intended for representing a person and can be extended for other
*              party types, such as OrganizationParty.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial refactored version.
*  Kenneth Houkjær      11/09/2025      Made serializable and parsable for inheritance.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public virtual class Party {
    /** @description The first name of the person. */
    public String firstName;
    /** @description The last name of the person. */
    public String lastName;
    /** @description The type of party (e.g., 'PERSON', 'ORGANIZATION'). */
    public String type;
    /** @description The email address of the party. */
    public String email;
    public String cvr;
    public String cpr;
    public String birthDate;
    /** @description The address of the party. */
    public Address address;
    /** @description The telephone number of the party. */
    public Telephone telephoneNumber;


    /**
    * @description Parses a JSON stream into a base Party object.
    * @param parser The JSON parser.
    * @return A new Party object.
    */
    public static Party parse(System.JSONParser parser){
        Party p = new Party();
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return null;
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();
            if (f == 'firstName') p.firstName = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'lastName') p.lastName = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'type') p.type = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'cvr') p.cvr = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'cpr') p.cpr = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'birthDate') p.birthDate = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'email') p.email = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'address' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) p.address = Address.parse(parser);
            else if (f == 'telephoneNumber' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) p.telephoneNumber = Telephone.parse(parser);
            else parser.skipChildren();
        }
        return p;
    }

    /**
    * @description Serializes the Party object to a JSON string.
    * @param gen The JSON generator.
    */
    public virtual void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        if (firstName != null) { gen.writeStringField('firstName', firstName); }
        if (lastName != null) { gen.writeStringField('lastName', lastName); }
        if (type != null) { gen.writeStringField('type', type); }
        if (email != null) { gen.writeStringField('email', email); }
        if (cvr != null) { gen.writeStringField('cvr', cvr); }
        if (cpr != null) { gen.writeStringField('cpr', cpr); }
        if (birthDate != null) { gen.writeStringField('birthDate', birthDate); }
        if (address != null) { gen.writeFieldName('address'); address.serialize(gen); }
        if (telephoneNumber != null) { gen.writeFieldName('telephoneNumber'); telephoneNumber.serialize(gen); }
        gen.writeEndObject();
    }
}