/**
* @description Represents the billing party for an order, used specifically in the Root BAN creation flow.
*              It has a slightly different structure from other Party DTOs, particularly in its
*              telephone number representation.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public class BillingParty {
    /** @description The type of party, typically 'ORGANIZATION' for a Root BAN. */
    public String type;
    /** @description The telephone number, containing only a country code for this specific DTO. */
    public TelephoneNumberCCode telephoneNumber;
    /** @description The legal name of the organization. */
    public String name;
    /** @description The CVR (company registration) number of the organization. */
    public String cvr;
    /** @description An optional label for the billing party. */
    public String label;
    /** @description The address of the billing party. */
    public Address address;

    /**
    * @description Represents a telephone number with only a country code, for use within the BillingParty DTO.
    */
    public class TelephoneNumberCCode {
        /** @description The international country code. */
        public String countryCode;
        
        /**
        * @description Serializes the TelephoneNumberCCode object to a JSON string.
        * @param gen The JSON generator.
        */
        public void serialize(System.JSONGenerator gen){
            gen.writeStartObject();
            gen.writeStringField('countryCode', countryCode);
            gen.writeEndObject();
        }
    }

    /**
    * @description Serializes the BillingParty object to a JSON string.
    * @param gen The JSON generator.
    */
    public void serialize(System.JSONGenerator gen){
        gen.writeStartObject();
        gen.writeStringField('type', type);
        if(telephoneNumber != null) {
            gen.writeFieldName('telephoneNumber');
            telephoneNumber.serialize(gen);
        }
        gen.writeStringField('name', name);
        gen.writeStringField('cvr', cvr);
        gen.writeStringField('label', label);
        if(address != null) {
            gen.writeFieldName('address');
            address.serialize(gen);
        }
        gen.writeEndObject();
    }
}