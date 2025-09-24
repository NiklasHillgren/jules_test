@isTest
public with sharing class DocumentManagementUploadExecHandlerTest {
    private static Mock documentManagementServiceMock;
    private static DatabaseService dbService;

    public static void setupMocks(){
        documentManagementServiceMock = Mock.forType(DocumentManagementService.class);
 
        //Get the stub instances from the mocks
        DocumentManagementService documentManagementService = (DocumentManagementService) documentManagementServiceMock.stub;
        
        //DatabaseService has mocking internally
        dbService = new DatabaseService().mockDMLs();

        SingletonFactory factory = SingletonFactory.getFactory();
        factory.registerSingleton( DocumentManagementService.class, documentManagementService );
        factory.registerSingleton( DatabaseService.class, dbservice );
    }

    @IsTest
    public static void execute_withSuccess_setDocumentManagementStoreId() {
        // Arrange
        setupMocks();

        Id contentVersionId = DatabaseService.getFakeId(ContentVersion.SObjectType);
        String parametersJson = '{"contentVersionId": "'+contentVersionId+'"}';
        
        ContentVersion existingContentVersion = new ContentVersion(
            Id = contentVersionId,
            Title = 'Test Document',
            VersionData = Blob.valueOf('Test Content')
        );
        
        Account parentAccount = new Account(
            Id = DatabaseService.getFakeId(Account.SObjectType),
            Name = 'Test Account'
        );
        
        DocumentManagementClientResponseDTO.Document respDoc = new DocumentManagementClientResponseDTO.Document();
        respDoc.id = 'DOC-001';

        // Setup mock behaviors
        MethodSpy getContentVersion = documentManagementServiceMock.spyOn('getContentVersion');
        getContentVersion.whenCalledWith(existingContentVersion.Id).thenReturn(existingContentVersion);

        MethodSpy getParentAccount = documentManagementServiceMock.spyOn('getParentAccount');
        getParentAccount.whenCalledWith(Argument.any(), Argument.any()).thenReturn(parentAccount);

        MethodSpy createDocument = documentManagementServiceMock.spyOn('createDocument');
        createDocument.whenCalledWith(Argument.any()).thenReturn(respDoc);

        // Act
        Test.startTest();
        DocumentManagementUploadExecutorHandler handler = new DocumentManagementUploadExecutorHandler();
        handler.execute(new EventExecutor__e(Parameters__c = parametersJson, RetryCount__c = 3));
        Test.stopTest();

        // Assert
        Assert.areEqual('DOC-001',((ContentVersion) dbService.register.updated[0]).DocumentManagementStoreId__c, 'We have the right Id');
    }

    @IsTest
    public static void execute_withException_setDocumentManagementError() {
        // Arrange
        setupMocks();

        Id contentVersionId = DatabaseService.getFakeId(ContentVersion.SObjectType);

        String parametersJson = '{"contentVersionId": "'+contentVersionId+'"}';
        
        ContentVersion existingContentVersion = new ContentVersion(
            Id = contentVersionId,
            Title = 'Test Document',
            VersionData = Blob.valueOf('Test Content')
        );
        
        Account parentAccount = new Account(
            Id = DatabaseService.getFakeId(Account.SObjectType),
            Name = 'Test Account'
        );
        
        DocumentManagementClientResponseDTO.Document respDoc = new DocumentManagementClientResponseDTO.Document();
        respDoc.id = 'DOC-001';
            
        // Setup mock behaviors
        MethodSpy getContentVersion = documentManagementServiceMock.spyOn('getContentVersion');
        getContentVersion.whenCalledWith(existingContentVersion.Id).thenReturn(existingContentVersion);

        MethodSpy getParentAccount = documentManagementServiceMock.spyOn('getParentAccount');
        getParentAccount.whenCalledWith(Argument.any(), Argument.any()).thenReturn(parentAccount);

        MethodSpy createDocument = documentManagementServiceMock.spyOn('createDocument');
        createDocument.throwsException(new HTTPException('MY EXCEPTION'));

        DocumentManagementUploadExecutorHandler handler = new DocumentManagementUploadExecutorHandler();
           
        // Act
        Test.startTest();
        handler.execute(new EventExecutor__e(Parameters__c = parametersJson, RetryCount__c = 0));
        Test.stopTest();

        // Assert
        Assert.isTrue((((ContentVersion) dbService.register.updated[0]).DocumentManagementError__c).contains('MY EXCEPTION'), 'We update the contentversion with an exception');
    }
}