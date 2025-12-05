/**
 * Selector class for the DocumentManagement namespace.
 *
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Niklas Hillgren      21/10/2025      Initial version
 *
 * @author Niklas Hillgren
 * @version 1.0
 * @since 21/10/2025
 */
public with sharing class DocumentManagementSelector {
    public Database.QueryLocator getContentDocumentAndContentVersionUploadedToStore(Datetime createdBefore) {
        Query idInSubquery = new Query(ContentVersion.SObjectType)
            .selectFields(ContentVersion.Fields.ContentDocumentId)
            .addConditionNotNull('DocumentManagementStoreId__c');

        return new Query(ContentDocument.SObjectType)
            .selectFields(ContentDocument.Fields.Id)
            .addSubquery('ContentVersions', new List<String>{ 'Id', 'DocumentManagementStoreId__c' })
            .addConditionLt('CreatedDate', createdBefore)
            .addConditionIn('Id', idInSubquery)
            .getQueryLocator();
    }

    public ContentVersion getContentVersion(Id contentVersionId) {
        Logger.logInfo(String.format('getContentVersion( {0} )', new List<Object>{ contentVersionId }));
        return (ContentVersion) new Query(ContentVersion.sObjectType)
            .selectFields(
                new List<Schema.SObjectField>{
                    ContentVersion.Fields.Id,
                    ContentVersion.Fields.VersionData,
                    ContentVersion.Fields.VersionNumber,
                    ContentVersion.Fields.ContentDocumentId,
                    ContentVersion.Fields.PathOnClient,
                    ContentVersion.Fields.Title
                }
            )
            .byId(contentVersionId)
            .fetch();
    }

    public List<ContentDocumentLink> getContentDocumentLinks(Set<Id> contentDocumentIds) {
        Logger.logInfo(String.format('getContentDocumentLinks( {0} )', new List<Object>{ contentDocumentIds }));
        return (List<ContentDocumentLink>) new Query(ContentDocumentLink.sObjectType)
            .selectFields(
                new List<Schema.SObjectField>{
                    ContentDocumentLink.Fields.Id,
                    ContentDocumentLink.Fields.LinkedEntityId,
                    ContentDocumentLink.Fields.ContentDocumentId,
                    ContentDocumentLink.Fields.SystemModstamp,
                    ContentDocumentLink.Fields.ShareType,
                    ContentDocumentLink.Fields.Visibility
                }
            )
            .addConditionIn(ContentDocumentLink.Fields.ContentDocumentId, contentDocumentIds)
            .orderBy(ContentDocumentLink.Fields.SystemModstamp)
            .fetchAll();
    }

    public porting__c getAccountByPortingId(Id portingId) {
        Logger.logInfo(String.format('getAccountByPortingId( {0} )', new List<Object>{ portingId }));

        return (porting__c) new Query(Porting__c.sObjectType)
            .selectFields(new List<String>{ 'Id', 'Account__r.Id', 'Account__r.Name' })
            .byId(portingId)
            .fetch();
    }

    public Competitor_Contract__c getAccountByCompetitorId(Id competitorId) {
        Logger.logInfo(String.format('getAccountByCompetitorId( {0} )', new List<Object>{ competitorId }));

        return (Competitor_Contract__c) new Query(Competitor_Contract__c.sObjectType)
            .selectFields(new List<String>{ 'Id', 'Account__r.Id', 'Account__r.Name' })
            .byId(competitorId)
            .fetch();
    }

    public List<ContentDocumentLink> getContentDocumentLinksByPowerOfAttorneyIds(List<Id> poaIds) {
        Logger.logInfo(String.format('getContentDocumentLinksByPowerOfAttorneyIds( {0} )', new List<Object>{ poaIds }));

        return (List<ContentDocumentLink>) new Query(ContentDocumentLink.sObjectType)
            .selectFields(
                new List<String>{
                    'LinkedEntityId',
                    'ContentDocument.LatestPublishedVersion.Id',
                    'ContentDocument.LatestPublishedVersion.CreatedDate',
                    'ContentDocument.LatestPublishedVersion.ContentDocumentId',
                    'ContentDocument.LatestPublishedVersion.DocumentManagementCompletedDate__c',
                    'ContentDocument.LatestPublishedVersion.DocumentManagementError__c',
                    'ContentDocument.LatestPublishedVersion.DocumentManagementInitDate__c',
                    'ContentDocument.LatestPublishedVersion.DocumentManagementStoreId__c'
                }
            )
            .addConditionIn('LinkedEntityId', poaIds)
            .orderBy('ContentDocument.LatestPublishedVersion.CreatedDate', 'DESC')
            .fetchAll();
    }
}
