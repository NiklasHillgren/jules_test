public with sharing class ContentVersionTriggerHandler extends TriggerHandler {
    private final DatabaseService dataBaseService;
    private final DocumentManagementService documentManagementService;
    private final EventExecutorService eventExecutorService;

    @TestVisible
    private Map<Id, ContentVersion> triggerNewMap;
    @TestVisible
    private Map<Id, ContentVersion> triggerOldMap;

    public ContentVersionTriggerHandler() {
        this(SingletonFactory.getFactory());
    }
    

    private ContentVersionTriggerHandler(SingletonFactory singletonFactory) {
        this.documentManagementService = (DocumentManagementService) singletonFactory.getOrRegisterSingleton(
            DocumentManagementService.class
        );
        
        this.eventExecutorService = (EventExecutorService) singletonFactory.getOrRegisterSingleton(EventExecutorService.class);

        this.dataBaseService = (DatabaseService) singletonFactory.getOrRegisterSingleton(DatabaseService.class);

        this.triggerNewMap = (Map<Id, ContentVersion>) Trigger.newMap;
        this.triggerOldMap = (Map<Id, ContentVersion>) Trigger.oldMap;
    }

    public override void afterInsert() {
        List<ContentVersion> contentVersionsForStorage = documentManagementService.prepareDocumentsForStorage(
            triggerNewMap.values()
        );

        //Set the fields DocumentManagementIsStored__c, DocumentManagementInitDate__c
        dataBaseService.updateRecords(contentVersionsForStorage);
    }

    public override void beforeUpdate() {
        //If the DocumentManagementIsStored__c and DocumentManagementInitDate__c are set/changed
        List<EventExecutor__e> contentVersionUploadExecutorHandlers = documentManagementService.getUploadExecutorHandlers(
            triggerNewMap,
            triggerOldMap
        );

        eventExecutorService.publishEvents(contentVersionUploadExecutorHandlers);
    }
}