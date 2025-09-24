@IsTest
public with sharing class ContentVersionTriggerHandlerTest {
    private static DatabaseService databaseService;
    private static Mock documentManagementServiceMock;
    private static Mock eventExecutorServiceMock;

    public static void setupMocks(){
        documentManagementServiceMock = Mock.forType(DocumentManagementService.class);
        eventExecutorServiceMock = Mock.forType(EventExecutorService.class);

        //Get the stub instances from the mocks
        DocumentManagementService documentManagementService = (DocumentManagementService) documentManagementServiceMock.stub;
        EventExecutorService eventExecutorService = (EventExecutorService) eventExecutorServiceMock.stub;

        //DatabaseService has mocking internally
        databaseService = new DatabaseService().mockDMLs();

        SingletonFactory factory = SingletonFactory.getFactory();
        factory.registerSingleton( DocumentManagementService.class, documentManagementService );
        factory.registerSingleton( EventExecutorService.class, eventExecutorService );
        factory.registerSingleton( DatabaseService.class, databaseService );
    }

    static Integer s_num = 1;

    public static String getFakeId(Schema.SObjectType sot) {
        String result = String.valueOf(s_num++);
        return sot.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }

    @IsTest
    public static void newContentVersion_DocumentManagementIsStored_IsFalse(){
        ContentVersion cv = new ContentVersion();
        cv.title = 'testing';
        cv.PathOnClient = 'testing.pdf';
        cv.VersionData = Blob.valueof('JVBERi0xLjAKMSAwIG9iajw8L1BhZ2VzIDIgMCBSPj5lbmRvYmogMiAwIG9iajw8L0tpZHNbMyAw\nIFJdL0NvdW50IDE+PmVuZG9iaiAzIDAgb2JqPDwvTWVkaWFCb3hbMCAwIDMgM10+PmVuZG9iagp0\ncmFpbGVyPDwvUm9vdCAxIDAgUj4+Cg==');

        ContentVersion cv2 = new ContentVersion();
        cv2.title = 'testing_2';
        cv2.PathOnClient = 'testing_2.pdf';
        cv2.VersionData = Blob.valueof('JVBERi0xLjAKMSAwIG9iajw8L1BhZ2VzIDIgMCBSPj5lbmRvYmogMiAwIG9iajw8L0tpZHNbMyAw\nIFJdL0NvdW50IDE+PmVuZG9iaiAzIDAgb2JqPDwvTWVkaWFCb3hbMCAwIDMgM10+PmVuZG9iagp0\ncmFpbGVyPDwvUm9vdCAxIDAgUj4+Cg==');

        insert new List<ContentVersion>{ cv, cv2};

        Assert.isFalse(cv.DocumentManagementIsStored__c);
    }

    @IsTest
    public static void newContentVersion_DocumentManagementIsStored_IsTrue(){
        setupMocks();

        ContentVersionTriggerHandler conVersionTriggerHandler = new ContentVersionTriggerHandler();
        conVersionTriggerHandler.triggerNewMap = new Map<Id, ContentVersion>();
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'testing2';
        cv.PathOnClient = 'testing.pdf';
        cv.VersionData = Blob.valueof('JVBERi0xLjAKMSAwIG9iajw8L1BhZ2VzIDIgMCBSPj5lbmRvYmogMiAwIG9iajw8L0tpZHNbMyAw\nIFJdL0NvdW50IDE+PmVuZG9iaiAzIDAgb2JqPDwvTWVkaWFCb3hbMCAwIDMgM10+PmVuZG9iagp0\ncmFpbGVyPDwvUm9vdCAxIDAgUj4+Cg==');
        cv.Id = getFakeId(ContentVersion.SObjectType);
        conVersionTriggerHandler.triggerNewMap.put(cv.Id, cv);

        //Faking response
        ContentVersion preperedContentVersion = new ContentVersion();
        preperedContentVersion.Id = cv.Id;
        preperedContentVersion.DocumentManagementIsStored__c = true;
        preperedContentVersion.DocumentManagementInitDate__c = System.now();
        MethodSpy contractAPIDataFetchSpy = documentManagementServiceMock.spyOn('prepareDocumentsForStorage');
        contractAPIDataFetchSpy.whenCalledWith(Argument.any()).thenReturn(new List<ContentVersion>{preperedContentVersion});

        Test.startTest();
		conVersionTriggerHandler.afterInsert();
        Test.stopTest();

        Assert.areEqual(1, databaseService.register.updates.size(),'We update the CV with isStored.');
        ContentVersion cvUpdated = (ContentVersion) databaseService.register.updates[0].dmlRows[0];

        Assert.areEqual(cvUpdated.DocumentManagementInitDate__c, preperedContentVersion.DocumentManagementInitDate__c);
    }

    @IsTest
    public static void newContentVersion_beforeUpdate_publishEvents(){
        setupMocks();

        ContentVersionTriggerHandler conVersionTriggerHandler = new ContentVersionTriggerHandler();
        conVersionTriggerHandler.triggerNewMap = new Map<Id, ContentVersion>();
        conVersionTriggerHandler.triggerOldMap = new Map<Id, ContentVersion>();
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'testing2';
        cv.PathOnClient = 'testing.pdf';
        cv.VersionData = Blob.valueof('JVBERi0xLjAKMSAwIG9iajw8L1BhZ2VzIDIgMCBSPj5lbmRvYmogMiAwIG9iajw8L0tpZHNbMyAw\nIFJdL0NvdW50IDE+PmVuZG9iaiAzIDAgb2JqPDwvTWVkaWFCb3hbMCAwIDMgM10+PmVuZG9iagp0\ncmFpbGVyPDwvUm9vdCAxIDAgUj4+Cg==');
        cv.Id = getFakeId(ContentVersion.SObjectType);
        cv.DocumentManagementInitDate__c = System.now();
        cv.DocumentManagementIsStored__c = true;
        conVersionTriggerHandler.triggerNewMap.put(cv.Id, cv);
        
        //Faking response
        ContentVersion preperedContentVersion = new ContentVersion();
        preperedContentVersion.Id = cv.Id;
        preperedContentVersion.DocumentManagementIsStored__c = true;
        preperedContentVersion.DocumentManagementInitDate__c = null;
        conVersionTriggerHandler.triggerOldMap.put(cv.Id, cv);
        
        MethodSpy getUploadExecutorHandlersSpy = documentManagementServiceMock.spyOn('getUploadExecutorHandlers');
        List<EventExecutor__e> executors = new List<EventExecutor__e>{new EventExecutor__e(Executor__c = 'DocumentManagementUploadExecutorHandler')};
        getUploadExecutorHandlersSpy.whenCalledWith(Argument.any(), Argument.any()).thenReturn(executors);

        MethodSpy publishEventSpy = eventExecutorServiceMock.spyOn('publishEvents');
        publishEventSpy.whenCalledWith(Argument.any()).thenReturn(new List<Database.SaveResult>());
        
        Test.startTest();
		conVersionTriggerHandler.beforeUpdate();
        Test.stopTest();
        
        Expect.that(publishEventSpy).hasBeenCalledWith(executors);
    }
}