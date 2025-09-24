/**
 * @author Kenneth Houkjær
 * @date 27/07/2024
 * @description Test for the Document Management Service
 */
@isTest
public with sharing class DocumentManagementServiceTest {
    private static Mock documentManagementClientMock;
    private static DatabaseService databaseService;

    public static void setupMocks(){
        documentManagementClientMock = Mock.forType(DocumentManagementClient.class);
 
        //Get the stub instances from the mocks
        DocumentManagementClient documentManagementClient = (DocumentManagementClient) documentManagementClientMock.stub;
        
        //DatabaseService has mocking internally
        databaseService = new DatabaseService().mockDMLs();

        SingletonFactory factory = SingletonFactory.getFactory();
        factory.registerSingleton( DocumentManagementClient.class, documentManagementClient );
        factory.registerSingleton( DatabaseService.class, databaseService );
    }

    static Integer s_num = 1;

    public static String getFakeId(Schema.SObjectType sot) {
        String result = String.valueOf(s_num++);
        return sot.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }
    
    @IsTest
    static void prepareDocumentsForStorage_ContentVersionPublishedLocationIsPorting_isStored(){
        //It is not possible to set the VersionNumber without doing this serialization...
        String contentVersionAsString = '[{"attributes":{"type":"ContentVersion","url":"/services/data/v63.0/sobjects/ContentVersion/068RR000007EX4vYAG"},"Id":"068RR000007EX4vYAG","VersionNumber":"1","FirstPublishLocationId":"'+getFakeId(porting__c.SObjectType)+'"}]';
        List<ContentVersion> myList = (List<ContentVersion>) JSON.deserialize(contentVersionAsString, List<ContentVersion>.class);
        DocumentManagementService s = new DocumentManagementService();
        List<ContentVersion> cvs = s.prepareDocumentsForStorage(myList);
        Assert.areEqual(true, cvs.get(0).DocumentManagementIsStored__c);
    }
    
    @IsTest
    static void getUploadExecutorHandlers_ContentVersionIsStored_returnsExecutors(){
        //It is not possible to set the VersionNumber without doing this serialization...
        String oldContentVersionAsString = '[{"attributes":{"type":"ContentVersion","url":"/services/data/v63.0/sobjects/ContentVersion/068RR000007EX4vYAG"},"Id":"068RR000007EX4vYAG","VersionNumber":"1","DocumentManagementIsStored__c":"true","DocumentManagementInitDate__c":"2025-09-16T08:04:49.000+0000"}]';
        String newtentVersionAsString = '[{"attributes":{"type":"ContentVersion","url":"/services/data/v63.0/sobjects/ContentVersion/068RR000007EX4vYAG"},"Id":"068RR000007EX4vYAG","VersionNumber":"1","DocumentManagementIsStored__c":"true","DocumentManagementInitDate__c":"2025-09-16T08:05:49.000+0000"}]';
        List<ContentVersion> newList = (List<ContentVersion>) JSON.deserialize(oldContentVersionAsString, List<ContentVersion>.class);
        List<ContentVersion> oldList = (List<ContentVersion>) JSON.deserialize(newtentVersionAsString, List<ContentVersion>.class);
        
        Map<Id, ContentVersion> newMap = new Map<Id, ContentVersion>(newList);
        Map<Id, ContentVersion> oldMap = new Map<Id, ContentVersion>(oldList);
        

        DocumentManagementService s = new DocumentManagementService();
        List<EventExecutor__e> cvs = s.getUploadExecutorHandlers(newMap, oldMap);
        Assert.areEqual(false, cvs.isEmpty());
    }
    
    @IsTest
    static void findDocuments_existingDocuments_returnsDocuments() {
        //Arrange
        setupMocks();
        MethodSpy findDocuments = documentManagementClientMock.spyOn('findDocuments');
       
        List<DocumentManagementClientResponseDTO.Document> responseFromFindDocuments = new  List<DocumentManagementClientResponseDTO.Document>();
        DocumentManagementClientResponseDTO.Document doc = new DocumentManagementClientResponseDTO.Document();
        doc.id = '12345';
        responseFromFindDocuments.add(doc);

        findDocuments.whenCalledWith(Argument.any()).thenReturn(responseFromFindDocuments);


        Map<Object, Object> searchCriteria = new Map<Object, Object>();
        searchCriteria.put('brand', 'teliadk');

        DocumentManagementService docService = new DocumentManagementService();
        
        //Act
        Test.startTest();
        List<DocumentManagementClientResponseDTO.Document> documents = docService.findDocuments(searchCriteria);
        Test.stopTest();

        //Assert
        System.assertEquals(1, documents.size());
        System.assertEquals('12345', documents[0].id);
    }
}