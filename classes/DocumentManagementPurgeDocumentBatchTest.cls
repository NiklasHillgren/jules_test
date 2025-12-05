/**
 * Unit test class for DocumentManagementPurgeDocumentBatch class
 * 
 * This class provides test coverage for the Document Management Purge Batch implementation.
 * It use mock-based testing of external service interactions
 *
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Niklas Hillgren      21/10/2025      Initial version
 * 
 * @author Niklas Hillgren
 * @version 1.0
 * @since 21/10/2025
 */
@IsTest
public with sharing class DocumentManagementPurgeDocumentBatchTest {

    /**
     * Mock implementation of DocumentManagementClient interface
     */
    private static Mock documentManagementClientMock;


    private static DatabaseService dbService;

    /**
     * Sets up mock implementations for dependencies
     * 
     * Configures mock DocumentManagementClient and DatabaseService instances
     * and registers them with the SingletonFactory for dependency injection.
     */
    public static void setupMocks(){
        documentManagementClientMock = Mock.forType(DocumentManagementClient.class);

        DocumentManagementClient documentManagementClient = (DocumentManagementClient) documentManagementClientMock.stub;
        
        //DatabaseService has mocking internally
        dbService = new DatabaseService().mockDMLs();

        SingletonFactory factory = SingletonFactory.getFactory();
        factory.registerSingleton( DocumentManagementClient.class, documentManagementClient );
        factory.registerSingleton( DatabaseService.class, dbservice );
    }


    @IsTest
    public static void startBatch_withNullValues_executes(){
        //Not important
        DocumentManagementPurgeDocumentBatch b = new DocumentManagementPurgeDocumentBatch();
        b.startBatch(null);
        Assert.isTrue(true, 'We got here without issues');
    }

    @IsTest
    public static void executeBatchChunk_withNullValues_executes(){
        DocumentManagementPurgeDocumentBatch b = new DocumentManagementPurgeDocumentBatch();
        b.executeBatchChunk(null, null);
    }

    /**
     * Tests document deletion with valid documents
     * 
     * Validates that:
     * 1. Documents are properly processed
     * 2. Delete operations are called correctly
     * 3. Database updates are tracked appropriately
     */
    @IsTest
    public static void executeBatchChunk_withValidDocument_isDeleted(){
        //Arrange
        setupMocks();
        MethodSpy deleteDocumentSpy = documentManagementClientMock.spyOn('deleteDocument');
        
        DocumentManagementPurgeDocumentBatch b = new DocumentManagementPurgeDocumentBatch();

        String filesAsJSON = '[{"attributes":{"type":"ContentDocument","url":"/services/data/v63.0/sobjects/ContentDocument/069RR000007ZkYbYAK"},"Id":"069RR000007ZkYbYAK","ContentVersions":{"totalSize":2,"done":true,"records":[{"attributes":{"type":"ContentVersion","url":"/services/data/v63.0/sobjects/ContentVersion/068RR000007ZBXdYAO"},"Id":"068RR000007ZBXdYAO","DocumentManagementStoreId__c":"47ed67c9-f539-4c97-a3ac-c9858b0b6f64"},{"attributes":{"type":"ContentVersion","url":"/services/data/v63.0/sobjects/ContentVersion/068RR000007ZBhJYAW"},"Id":"068RR000007ZBhJYAW","DocumentManagementStoreId__c":"0f429271-16f0-4244-825c-caf33f42f4b5"}]}}]';
        List<ContentDocument> docs = (List<ContentDocument>) JSON.deserialize(filesAsJSON, List<ContentDocument>.class);

        //Act
        b.executeBatchChunk(null, docs);

        //Assert
        Expect.that(deleteDocumentSpy).hasBeenCalledTimes(2);
        Assert.areEqual(1, dbService.register.deletes.size(), 'We delete one contentdocument');
    }
    
    @IsTest
    public static void executeBatchChunk_with404Document_isDeleted(){
        //Arrange
        setupMocks();
        MethodSpy deleteDocumentSpy = documentManagementClientMock.spyOn('deleteDocument');
        deleteDocumentSpy.throwsException(new HTTPException('test exception', 404, '404'));

        DocumentManagementPurgeDocumentBatch b = new DocumentManagementPurgeDocumentBatch();

        String filesAsJSON = '[{"attributes":{"type":"ContentDocument","url":"/services/data/v63.0/sobjects/ContentDocument/069RR000007ZkYbYAK"},"Id":"069RR000007ZkYbYAK","ContentVersions":{"totalSize":2,"done":true,"records":[{"attributes":{"type":"ContentVersion","url":"/services/data/v63.0/sobjects/ContentVersion/068RR000007ZBXdYAO"},"Id":"068RR000007ZBXdYAO","DocumentManagementStoreId__c":"47ed67c9-f539-4c97-a3ac-c9858b0b6f64"},{"attributes":{"type":"ContentVersion","url":"/services/data/v63.0/sobjects/ContentVersion/068RR000007ZBhJYAW"},"Id":"068RR000007ZBhJYAW","DocumentManagementStoreId__c":"0f429271-16f0-4244-825c-caf33f42f4b5"}]}}]';
        List<ContentDocument> docs = (List<ContentDocument>) JSON.deserialize(filesAsJSON, List<ContentDocument>.class);

        //Act
        b.executeBatchChunk(null, docs);

        //Assert
        Expect.that(deleteDocumentSpy).hasBeenCalledTimes(2);
    }
    
    @IsTest
    public static void finishBatch_withNullValues_executes(){
        //Arrange
        DocumentManagementPurgeDocumentBatch b = new DocumentManagementPurgeDocumentBatch();

        //Act
        b.finishBatch(null);

        //Assert
        Assert.isTrue(true, 'We got here without issues');
    }
}