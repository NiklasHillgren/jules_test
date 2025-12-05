/**
 * CustomerClientResponseDTO represents a data transfer object structure for customer response data.
 * 
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Niklas Hillgren      28/10/2025      Initial
 * 
 * @author Niklas Hillgren
 * @version 1.0
 * @since 28/10/2025
 */
public with sharing class CustomerClientResponseDTO {
    public class GetCustomerResponse {
        public List<Customer> data;
    }

    public class Customer {
        public String id;
        public String accountId;
        public String status;
        public String activationDate;
        public String brand;
        public String createdBy;
        public Individual individual;
        public Organization organization;
        public CreditProfile creditProfile;
        public ContactDetails contactDetails;
        public BillingProfile billingProfile;
    }

    /**
     * Contains personal information for individual customers
     */
    public class Individual {
        public String title;
        public String firstName;
        public String middleName;
        public String lastName;
        public String birthDate;
        public String gender;
        public String maritalStatus;
        public String nationality;
        public Integer cpr;
        public String applicationId;
        public String createdBy;
        public String creationDate;
        public String lastUpdatedBy;
        public String lastUpdationDate;
    }

    /**
     * Contains organizational information for business customers
     */
    public class Organization {
        public String legalName;
        public String organizationName;
        public String cvr;
        public String createdBy;
        public String creationDate;
    }

    /**
     * Represents credit-related information for a customer
     */
    public class CreditProfile {
        public String riskRating;
        public String value;
        public String validFrom;
        public String validTo;
        public String applicationId;
        public String createdBy;
        public String creationDate;
    }

    /**
     * Container for various contact details
     */
    public class ContactDetails {
        public Address[] address;
        public EmailAddress[] emailAddress;
        public PhoneNumber[] phoneNumber;
    }

    /**
     * Represents a physical or mailing address
     */
    public class Address {
        public String type;
        public String houseNo;
        public String streetName;
        public String city;
        public String country;
        public String addressLine1;
        public String addressLine2;
        public String zip;
        public String floor;
        public String doorNo;
        public String landlordName;
        public String direction;
        public String houseLetter;
        public String validFrom;
        public String validTo;
        public String applicationId;
        public String createdBy;
        public String creationDate;
        public String lastUpdatedBy;
        public String lastUpdationDate;
    }


    /**
     * Represents an email address entry
     */
    public class EmailAddress {
        public String type;
        public String email;
        public boolean preferredContact;
        public String validFrom;
        public String validTo;
        public String applicationId;
        public String createdBy;
        public String creationDate;
        public String lastUpdatedBy;
        public String lastUpdationDate;
    }

    /**
     * Represents a phone number entry
     */
    public class PhoneNumber {
        public String type;
        public String phoneNumber; //This is number in payload!!
        public boolean preferredContact;
        public String validFrom;
        public String validTo;
        public String applicationId;
        public String createdBy;
        public String creationDate;
    }

    /**
     * Container for billing-related customer information
     */
    public class BillingProfile {
        public Individual individual;
        public Organization organization;
        public ContactDetails contactDetails;
    }
    
}