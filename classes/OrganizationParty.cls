/**
* @description Represents a party that is an organization, extending the base Party class.
*              It includes fields for the organization's name and CVR number, and is used
*              for the 'orderer' and 'legalParty' in the Root BAN creation flow.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public class OrganizationParty extends Party {
    /** @description The legal name of the organization. */
    public String name;
    /** @description The CVR (company registration) number of the organization. */
    public String cvr;

    /**
    * @description Parses a JSON stream into an OrganizationParty object. This method handles
    *              both base Party fields and the organization-specific fields.
    * @param parser The JSON parser.
    * @return A new OrganizationParty object.
    */
    public static OrganizationParty parse(System.JSONParser parser) {
        OrganizationParty orgParty = new OrganizationParty();
        
        // This is not ideal, but it's the only way with this pattern
        // to parse the full object in the subclass.
        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return orgParty;

        while(parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();

            // Base class fields
            if (f == 'firstName') orgParty.firstName = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'lastName') orgParty.lastName = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'type') orgParty.type = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'email') orgParty.email = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'address' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) orgParty.address = Address.parse(parser);
            else if (f == 'telephoneNumber' && parser.getCurrentToken() == System.JSONToken.START_OBJECT) orgParty.telephoneNumber = Telephone.parse(parser);
            
            // Subclass fields
            else if (f == 'name') orgParty.name = JsonStreamingUtil.readStringToken(parser);
            else if (f == 'cvr') orgParty.cvr = JsonStreamingUtil.readStringToken(parser);
            
            else { parser.skipChildren(); }
        }
        return orgParty;
    }

    /**
    * @description Serializes the OrganizationParty object to a JSON string, including fields
    *              from the base Party class.
    * @param gen The JSON generator.
    */
    public override void serialize(System.JSONGenerator gen) {
        gen.writeStartObject();
        super.serializeCommon(gen);
        
        // Subclass fields
        gen.writeStringField('name', name);
        gen.writeStringField('cvr', cvr);
        gen.writeEndObject();
    }
}