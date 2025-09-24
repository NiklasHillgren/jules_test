public with sharing class DocumentManagementClientResponseDTO {
    /**
     * Document
     */
    public class Document {
        /**
         * Identifier of an instance of the document. Required to be unique within the document type.  Used in URIs as the identifier for specific instances of a type.
         * @return id
         */
        public String id { get; set; }

        /**
         * The URI for the object itself.
         * @return href
         */
        public String href { get; set; }

        /**
         * Name of the document type
         * @return type
         */
        public String type { get; set; }

        /**
         * A string used to give a name to the document
         * @return name
         */
        public String name { get; set; }

        /**
         * free-text description of the document
         * @return description
         */
        public String description { get; set; }

        /**
         * The life cycle state of the document.
         * @return lifecycleState
         */
        public String lifecycleState { get; set; }

        /**
         * A particular form or variety of an artefact that is different from others or from the original. The form represents differences in properties that characterize an artefact, that are not enough to warrant creating a new artefact
         * @return version
         */
        public String version { get; set; }

        /**
         * The date and time the document was created. A date and time formatted in compliance with the ISO8601 standard must be used.
         * @return creationDate
         */
        public Datetime creationDate { get; set; }

        /**
         * The date and time the document was last modified. A date and time formatted in compliance with the ISO8601 standard must be used.
         * @return lastUpdate
         */
        public Datetime lastUpdate { get; set; }

        /**
         * Get documentCharacteristic
         * @return documentCharacteristic
         */
        public List<DocumentCharacteristic> documentCharacteristic { get; set; }

        /**
         * Get relatedParty
         * @return relatedParty
         */
        public List<RelatedPartyRef> relatedParty { get; set; }

        /**
         * Get documentSpecification
         * @return documentSpecification
         */
        public DocumentSpecification documentSpecification { get; set; }

        /**
         * Get attachment
         * @return attachment
         */
        public List<Attachment> attachment { get; set; }

        /**
         * Get category
         * @return category
         */
        public List<CategoryRef> category { get; set; }

        /**
         * Get documentRelationship
         * @return documentRelationship
         */
        public List<DocumentRelationship> documentRelationship { get; set; }

        /**
         * Get relatedObject
         * @return relatedObject
         */
        public RelatedObject relatedObject { get; set; }

        /**
         * Get documentAttributes
         * @return documentAttributes
         */
        public DocumentAttributes documentAttributes { get; set; }

        /**
         * Get signatureRequired
         * @return signatureRequired
         */
        public Boolean signatureRequired { get; set; }

        /**
         * Get signatureMissing
         * @return signatureMissing
         */
        public Boolean signatureMissing { get; set; }

        /**
         * Get uniqueSignatureRequired
         * @return uniqueSignatureRequired
         */
        public Boolean uniqueSignatureRequired { get; set; }

        /**
         * Get signed
         * @return signed
         */
        public Boolean signed { get; set; }

        /**
         * Get signatures
         * @return signatures
         */
        public List<Signature> signatures { get; set; }
    }

    /**
     * is a list of name value pairs that define the document characteristics.
     *
     */
    public class DocumentCharacteristic {
        /**
         * name of the characteristic
         * @return name
         */
        public String name { get; set; }

        /**
         * Get value
         * @return value
         */
        public String value { get; set; }
    }

    public class RelatedPartyRef {
        /**
         * Unique identifier of a related party
         * @return id
         */
        public String id { get; set; }

        /**
         * Reference of the related party, could be a party reference or a party role reference
         * @return href
         */
        public String href { get; set; }

        /**
         * Role of the related party.
         * @return role
         */
        public String role { get; set; }

        /**
         * Name of the related party
         * @return name
         */
        public String name { get; set; }

        /**
         * Get validFor
         * @return validFor
         */
        public TimePeriod validFor { get; set; }
    }

    /**
     * Category reference.
     * The category resource is used to group product offerings, service and resource candidates in logical containers.
     * Categories can contain other categories and/or product offerings, resource or service candidates.
     */
    public class CategoryRef {
        /**
         * Unique reference of the category
         * @return id
         */
        public String id { get; set; }

        /**
         * Unique reference of the category
         * @return href
         */
        public String href { get; set; }

        /**
         * Category version
         * @return version
         */
        public String version { get; set; }

        /**
         * Name of the category
         * @return name
         */
        public String name { get; set; }
    }

    /**
     * SignatureValue
     */
    public class SignatureValue {
        /**
         * Get image
         * @return image
         */
        public Blob image { get; set; }

        /**
         * Get text
         * @return text
         */
        public String text { get; set; }
    }

    /**
     * Signature
     */
    public class Signature {
        /**
         * Get name
         * @return name
         */
        public String name { get; set; }

        /**
         * Get signatureHolder
         * @return signatureHolder
         */
        public String signatureHolder { get; set; }

        /**
         * Get required
         * @return required
         */
        public Boolean required { get; set; }

        /**
         * Get signed
         * @return signed
         */
        public Boolean signed { get; set; }

        /**
         * Get signedDate
         * @return signedDate
         */
        public Datetime signedDate { get; set; }

        /**
         * Get value
         * @return value
         */
        public SignatureValue value { get; set; }
    }

    /**
     * DocumentRef
     */
    public class DocumentRef {
        /**
         * Identifier of the document
         * @return id
         */
        public String id { get; set; }

        /**
         * The URI for the object itself.
         * @return href
         */
        public String href { get; set; }
    }

    /**
     * Another document that is related to the current document.
     *
     */
    public class DocumentRelationship {
        /**
         * a string, Type of relationship: e.g "related"
         * @return type
         */
        public String type { get; set; }

        /**
         * Get document
         * @return document
         */
        public DocumentRef document { get; set; }
    }

    /**
     * A document specification reference.
     */
    public class DocumentSpecification {
        /**
         * Identifier of the DocumentSpecification
         * @return id
         */
        public String id { get; set; }

        /**
         * A Name of the DocumentSpecification
         * @return name
         */
        public String name { get; set; }

        /**
         * A version of the DocumentSpecification.
         * @return version
         */
        public String version { get; set; }

        /**
         * The URI for the object itself.
         * @return href
         */
        public String href { get; set; }

        /**
         * URL of the Document Specification
         * @return url
         */
        public String url { get; set; }
    }


    /**
     * A base / value business entity used to represent a period of time between two timepoints.
     */
    public class TimePeriod {
        /**
         * An instant of time, starting at the TimePeriod
         * @return startDateTime
         */
        public Datetime startDateTime { get; set; }

        /**
         * An instant of time, ending at the TimePeriod.
         * @return endDateTime
         */
        public Datetime endDateTime { get; set; }
    }

    /**
     * Defines objects linked with trouble ticket.
     */
    public class RelatedObject {
        /**
         * Consequence of the ticket on the related object (for instance disputed, adjusted...)
         * @return involvement
         */
        public String involvement { get; set; }

        /**
         * Reference of object
         * @return reference
         */
        public String reference { get; set; }
    }

    /**
     * DocumentAttributes
     */
    public class DocumentAttributes {
        /**
         * Type of additional attributes
         * @return type
         */
        public String type { get; set; }
    }

}