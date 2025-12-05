/**
 * @description Batch job that archives EmailMessage records older than the configured number of years
 * into the EmailArchive__b big object; performs insert into big object and deletes originals
 * when delete permission is available.
 * -----------------------------------------------------------------------------
 * Developer                   Date                    Description
 * -----------------------------------------------------------------------------
 * @author Sergio Pedro        @since 2024-06-10.      @version 1.0
 * 
 * @group Email Management
 */
public with sharing class EmailArchiveBatchJob extends BatchJob {

    private static final String YEARS_TO_ARCHIVE_CONFIG = 'EmailArchiveYearsToKeep';

    /**
     * @description Query the Emails that should be archived based on their age
     * @param bc batch context
     * @return QueryLocator for batch processing
     */
    public override Database.QueryLocator startBatch(Database.BatchableContext bc) {

        Logger.logInfo('Starting Email Archive Batch Job');

        Query dataContext = new Query(EmailMessage.sObjectType).selectAllFields().selectField('CreatedBy.Name').selectField('LastModifiedBy.Name')
        .addConditionLe(EmailMessage.CreatedDate, Date.today().addYears((-1)*Integer.valueOf(OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(YEARS_TO_ARCHIVE_CONFIG))));

        return dataContext.getQueryLocator();
    }

    /**
     * @description Method to process each chunk of EmailMessage records for archiving
     * @param bc batch context
     * @param scope list of EmailMessage records to process
     */
    public override void executeBatchChunk(Database.BatchableContext bc, List<SObject> scope) {

        Logger.logInfo('Processing ' + scope.size() + ' email messages for archiving.');

        List<EmailMessage> emailMessages = (List<EmailMessage>)scope;

        List<EmailMessage> emailsToDelete = new List<EmailMessage>();
        List<EmailArchive__b> archivedEmails = new List<EmailArchive__b>();
        List<Database.SaveResult> insertResults;
        Map<Id,Id> accountIdsFromRelatedToFields = extractAccountIdsFromRelatedToFields(emailMessages);

        SavePoint transactionStart = Database.setSavePoint();
        try{
            for (EmailMessage email : emailMessages) {
                if((email.HtmlBody == null || email.HtmlBody.length() < 131072) && (email.TextBody == null || email.TextBody.length() < 131072)) {
                        
                    EmailArchive__b archivedEmail = new EmailArchive__b();
                    archivedEmail.Email_Message_Id__c = email.Id;
                    archivedEmail.Subject__c = email.Subject;
                    archivedEmail.CreatedDate__c = email.CreatedDate;
                    archivedEmail.FromAddress__c = email.FromAddress;
                    archivedEmail.ToAddress__c = email.ToAddress;
                    archivedEmail.ParentId__c = email.ParentId;
                    archivedEmail.RelatedRecordId__c = email.RelatedToId;
                    archivedEmail.RelatedRecord__c = '/' + email.RelatedToId;
                    archivedEmail.Status__c = email.Status;
                    archivedEmail.Text_Body__c = email.TextBody;
                    archivedEmail.Automation_Type__c = email.AutomationType;
                    archivedEmail.BccAddress__c = email.BccAddress;
                    archivedEmail.CCAddress__c = email.CcAddress;
                    archivedEmail.MessageDate__c = email.MessageDate;
                    archivedEmail.CreatedByName__c = email.CreatedBy.Name;
                    archivedEmail.Email_Link__c = URL.getOrgDomainUrl()+'/lightning/n/Archived_Email?c__emailmessageid='+email.Id+'&c__accountid='+accountIdsFromRelatedToFields.get(email.RelatedToId)+'&c__parentid='+email.ParentId;
                    archivedEmail.EmailSource__c = email.Source;
                    archivedEmail.FirstOpenedDate__c = email.FirstOpenedDate;
                    archivedEmail.LastOpenedDate__c = email.LastOpenedDate;
                    archivedEmail.FromAddress__c = email.FromAddress;
                    archivedEmail.IsExternallyVisible__c = email.IsExternallyVisible.toString();
                    archivedEmail.HasAttachments__c = email.HasAttachment.toString();
                    archivedEmail.Headers__c = email.Headers;
                    archivedEmail.HTML_Body__c = email.HtmlBody;
                    archivedEmail.Incoming__c = email.Incoming.toString();
                    archivedEmail.LastModifiedByName__c = email.LastModifiedBy.Name;
                    archivedEmail.LastModifiedDate__c = email.LastModifiedDate;
                    archivedEmail.Account__c = accountIdsFromRelatedToFields.get(email.RelatedToId);
                    archivedEmail.ToAddress__c = email.ToAddress;
                    archivedEmail.ValidatedFromAddress__c = email.ValidatedFromAddress;
                    archivedEmails.add(archivedEmail);
                } else {
                    Logger.logWarning('Skipping EmailMessage Id ' + email.Id + ' due to HTML Body size exceeding 131072 characters.');
                }
            }

            if(!Test.isRunningTest()){
                insertResults = Database.insertImmediate(archivedEmails);
            }
            for (Database.SaveResult dmlResult : insertResults) {
                if (!dmlResult.isSuccess()) {
                    for (Database.Error error : dmlResult.getErrors()) {
                        Logger.logError('Error archiving email: ' + error.getMessage());
                    }
                } else {
                    emailsToDelete.add(emailMessages[insertResults.indexOf(dmlResult)]);
                }
            }

            if (!emailsToDelete.isEmpty()) {
                if (Schema.sObjectType.EmailMessage.isDeletable()) {
                    delete emailsToDelete;
                    Logger.logInfo(emailsToDelete.size() + ' email messages archived successfully.');
                } else {
                    Logger.logWarning('Skipping deletion of ' + emailsToDelete.size() + ' EmailMessage records due to insufficient Delete permission.');
                }
            }
            Database.releaseSavePoint(transactionStart);
        } catch (Exception e) {
            Database.rollback(transactionStart);
            Logger.logError('Exception during email archiving: ' + e.getMessage());
            Logger.logError(e);
        }
    }

    /**
     * @description Log completion of the batch job
     * @param bc batch context
     */
    public override void finishBatch(Database.BatchableContext bc) {
        Logger.logInfo('Email Archive Batch Job completed.');
    }


    /**
     * Method to extract Account Ids from the RelatedToId fields of EmailMessage records
     * @param emails List of Emails to extract Account Ids from their RelatedToId fields
     * @return `Map<Id, Id>` Mapping of EmailMessage Ids to Account Ids
     */
    private Map<Id, Id> extractAccountIdsFromRelatedToFields(List<EmailMessage> emails) {
        Map<Schema.SObjectType,List<Id>> relatedToIdsMap = new Map<Schema.SObjectType,List<Id>>();
        Map<Id, Id> accountIdsMap = new Map<Id, Id>();
        Logger.logDebug('extractAccountIdsFromRelatedToFields invoked. Emails size: ' + (emails == null ? 0 : emails.size()));

        for (EmailMessage email : emails) {
            if (email.RelatedToId != null) {
                if(relatedToIdsMap.containsKey(email.RelatedToId.getSObjectType())) {
                    relatedToIdsMap.get(email.RelatedToId.getSObjectType()).add(email.RelatedToId);
                } else {
                    relatedToIdsMap.put(email.RelatedToId.getSObjectType(), new List<Id>{ email.RelatedToId });
                }
            }
        }
        Logger.logDebug('RelatedToId map sizes - relatedToIdsMap keys: ' + relatedToIdsMap.keySet().size());

        List<SObject> relatedRecords = new List<SObject>();
        for (Schema.SObjectType targetObject : relatedToIdsMap.keySet()) {
            relatedRecords.addAll(new Query(targetObject).selectAllFields()
            .addConditionIn('Id', relatedToIdsMap.get(targetObject))
            .run());
        }
        Logger.logDebug('Fetched related records count: ' + relatedRecords.size());
        

        for (SObject record : relatedRecords) {
            if(record instanceof Account) {
                accountIdsMap.put(record.Id, record.Id);
                continue;
            }
            for (String variable : record.getSObjectType().getDescribe().fields.getMap().keySet()) {
                Logger.logDebug('Record type: ' + record.getSObjectType().getDescribe().fields.getMap().keySet());
            }
            
            if (record.getSObjectType().getDescribe().fields.getMap().keySet().contains('accountid')) {
                Id accountId = (Id)record.get('accountid');
                if (accountId != null) {
                    accountIdsMap.put(record.Id, accountId);
                }
            }
        }
        Logger.logDebug('Resolved Account map size: ' + accountIdsMap.size());

        for (String variable : accountIdsMap.keySet()) {
            Logger.logDebug('Account Id in Map: ' + accountIdsMap.get(variable));
        }
        
        return accountIdsMap;
    }

}