/**
 * @description Provides an Aura-enabled Apex API for Lightning Web Components (LWC) to fetch
 *   a single EmailArchive__b Big Object record by its composite index.
 *   Returns a lightweight DTO (EmailArchiveRecordDTO) to decouple UI from BO schema.
 *
 * Key Points:
 * - Big Objects require equality filters on all index fields in order.
 * - Uses the project's Query fluent class to build and execute the query.
 * - Class runs with sharing to respect org data visibility.
 * 
 * -----------------------------------------------------------------------------
 * Developer                   Date                    Description
 * -----------------------------------------------------------------------------
 * @author Sergio Pedro        @since 2024-06-10.      @version 1.0
 * 
 * @group Email Management
 */
public with sharing class EmailArchiveViewerController {
    /**
     * EmailArchiveRecordDTO
     *
     * A data transfer object exposed to LWC for rendering EmailArchive__b data.
     * Only exposes fields needed by the UI to keep payload small.
     *
     * All properties are @AuraEnabled for serialization to LWC.
     */
    public class EmailArchiveRecordDTO {
        @AuraEnabled public String Id;
        @AuraEnabled public String AccountId;
        @AuraEnabled public String ParentId;
        @AuraEnabled public String Email_Message_Id;
        // Sample additional fields often useful to display; adjust to match your Big Object field API names
        @AuraEnabled public String Subject;
        @AuraEnabled public String FromAddress;
        @AuraEnabled public String ToAddress;
        @AuraEnabled public String CcAddress;
        @AuraEnabled public String BccAddress;
        @AuraEnabled public String Status;
        @AuraEnabled public String HtmlBody;
        @AuraEnabled public String TextBody;
        @AuraEnabled public String FirstOpenedDate;
        @AuraEnabled public String LastOpenedDate;
    }

    /**
     * getByCompositeIndex
     *
     * Retrieves a single EmailArchive__b record by its composite index:
     * (Account__c, ParentId__c, Email_Message_Id__c).
     *
     * Behavior:
     * - Validates that all three index parameters are provided; otherwise throws AuraHandledException.
     * - Builds the query with the project's Query fluent class, applying equality filters on all index fields.
     * - Returns a mapped DTO or null if no record is found.
     *
     * Caching:
     * - Marked cacheable=true to support LWC @wire usage. For non-cached reads, call imperatively from LWC.
     *
     * @param accountId      Index field 1: EmailArchive__b.Account__c
     * @param parentId       Index field 2: EmailArchive__b.ParentId__c
     * @param emailMessageId Index field 3: EmailArchive__b.Email_Message_Id__c
     * @return EmailArchiveRecordDTO populated with selected fields, or null when not found
     * @throws AuraHandledException if any parameter is blank
     */
    @AuraEnabled(cacheable=true)
    public static EmailArchiveRecordDTO getByCompositeIndex(String accountId, String parentId, String emailMessageId) {
        // Validate composite index parameters in order
        if (String.isBlank(accountId) || String.isBlank(parentId) || String.isBlank(emailMessageId)) {
            throw new AuraHandledException('All index parameters are required: accountId, parentId, emailMessageId.');
        }

        // Build query using the project's Query fluent class to ensure consistency
        Query archiverFinder = new Query(EmailArchive__b.SObjectType)
            .selectField('Id')
            .selectField('Account__c')
            .selectField('ParentId__c')
            .selectField('Email_Message_Id__c')
            .selectField('Subject__c')
            .selectField('FromAddress__c')
            .selectField('ToAddress__c')
            .selectField('CcAddress__c')
            .selectField('Status__c')
            .selectField('HTML_Body__c')
            .selectField('Text_Body__c')
            .selectField('FirstOpenedDate__c')
            .selectField('LastOpenedDate__c')
            .addConditionEq('Account__c', accountId)
            .addConditionEq('ParentId__c', parentId)
            .addConditionEq('Email_Message_Id__c', emailMessageId)
            .setLimit(1);

        // Execute query
        List<EmailArchive__b> archivedEmails = archiverFinder.run();
        if (archivedEmails.isEmpty()) {
            return null;
        }

        // Map first result to DTO
        EmailArchive__b archivedEmailRecord = (EmailArchive__b) archivedEmails[0];
        EmailArchiveRecordDTO dto = new EmailArchiveRecordDTO();
        dto.Id = (String) archivedEmailRecord.get('Id');
        dto.AccountId = (String) archivedEmailRecord.get('Account__c');
        dto.ParentId = (String) archivedEmailRecord.get('ParentId__c');
        dto.Email_Message_Id = (String) archivedEmailRecord.get('Email_Message_Id__c');
        dto.Subject = (String) archivedEmailRecord.get('Subject__c');
        dto.FromAddress = (String) archivedEmailRecord.get('FromAddress__c');
        dto.ToAddress = (String) archivedEmailRecord.get('ToAddress__c');
        dto.CcAddress = (String) archivedEmailRecord.get('CcAddress__c');
        dto.Status = (String) archivedEmailRecord.get('Status__c');
        dto.HtmlBody = (String) archivedEmailRecord.get('HTML_Body__c');
        dto.TextBody = (String) archivedEmailRecord.get('Text_Body__c');
        dto.LastOpenedDate = (String) archivedEmailRecord.get('LastOpenedDate__c');
        dto.FirstOpenedDate = (String) archivedEmailRecord.get('FirstOpenedDate__c');
        return dto;
    }
}