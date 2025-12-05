@isTest
public with sharing class NorlysAPIFacadeTest {
    @IsTest
    public static void doGet_successWithNorlysAPIHandler_return404() {
        // Arrange
        RestContext.response = new RestResponse();

        RestRequest req = new RestRequest();
        req.requestURI = '/api/tester';

        RestContext.request =  req;
        
        NorlysAPIFacade facade = new NorlysAPIFacade();
        // Act
        Test.startTest();
        RestResponse actualResponse = facade.doGet();
        Test.stopTest();
        
        // Assert
        Assert.areEqual(404, actualResponse.statusCode);
    }
    
    @IsTest
    public static void doGet_exception_returns500() {
        // Arrange
        RestContext.response = new RestResponse();

        RestRequest req = new RestRequest();
        req.requestURI = '/api/tester';
        req.addParameter('Exception', 'throws nullpointers');

        RestContext.request =  req;
        
        NorlysAPIFacade facade = new NorlysAPIFacade();
        // Act
        Test.startTest();
        RestResponse actualResponse = facade.doGet();
        Test.stopTest();
        
        // Assert
        Assert.areEqual(500, actualResponse.statusCode);
    }
    
    @IsTest
    public static void doPatch_successWithNorlysAPIHandler_return404() {
        // Arrange
        RestContext.response = new RestResponse();

        RestRequest req = new RestRequest();
        req.requestURI = '/api/tester';

        RestContext.request =  req;
        
        NorlysAPIFacade facade = new NorlysAPIFacade();
        // Act
        Test.startTest();
        RestResponse actualResponse = facade.doPatch();
        Test.stopTest();
        
        // Assert
        Assert.areEqual(404, actualResponse.statusCode);
    }
    
    @IsTest
    public static void doPatch_exception_returns500() {
        // Arrange
        RestContext.response = new RestResponse();

        RestRequest req = new RestRequest();
        req.requestURI = '/api/tester';
        req.addParameter('Exception', 'throws nullpointers');

        RestContext.request =  req;
        
        NorlysAPIFacade facade = new NorlysAPIFacade();
        // Act
        Test.startTest();
        RestResponse actualResponse = facade.doPatch();
        Test.stopTest();
        
        // Assert
        Assert.areEqual(500, actualResponse.statusCode);
    }
    
    @IsTest
    public static void doPost_successWithNorlysAPIHandler_return404() {
        // Arrange
        RestContext.response = new RestResponse();

        RestRequest req = new RestRequest();
        req.requestURI = '/api/tester';

        RestContext.request =  req;
        
        NorlysAPIFacade facade = new NorlysAPIFacade();
        // Act
        Test.startTest();
        RestResponse actualResponse = facade.doPost();
        Test.stopTest();
        
        // Assert
        Assert.areEqual(404, actualResponse.statusCode);
    }
    
    @IsTest
    public static void doPost_exception_returns500() {
        // Arrange
        RestContext.response = new RestResponse();

        RestRequest req = new RestRequest();
        req.requestURI = '/api/tester';
        req.addParameter('Exception', 'throws nullpointers');

        RestContext.request =  req;
        
        NorlysAPIFacade facade = new NorlysAPIFacade();
        // Act
        Test.startTest();
        RestResponse actualResponse = facade.doPost();
        Test.stopTest();
        
        // Assert
        Assert.areEqual(500, actualResponse.statusCode);
    }
    
    @IsTest
    public static void doPut_successWithNorlysAPIHandler_return404() {
        // Arrange
        RestContext.response = new RestResponse();

        RestRequest req = new RestRequest();
        req.requestURI = '/api/tester';

        RestContext.request =  req;
        
        NorlysAPIFacade facade = new NorlysAPIFacade();
        // Act
        Test.startTest();
        RestResponse actualResponse = facade.doPut();
        Test.stopTest();
        
        // Assert
        Assert.areEqual(404, actualResponse.statusCode);
    }
    
    @IsTest
    public static void doPut_exception_returns500() {
        // Arrange
        RestContext.response = new RestResponse();

        RestRequest req = new RestRequest();
        req.requestURI = '/api/tester';
        req.addParameter('Exception', 'throws nullpointers');

        RestContext.request =  req;
        
        NorlysAPIFacade facade = new NorlysAPIFacade();
        // Act
        Test.startTest();
        RestResponse actualResponse = facade.doPut();
        Test.stopTest();
        
        // Assert
        Assert.areEqual(500, actualResponse.statusCode);
    }
    
    @IsTest
    public static void doDelete_successWithNorlysAPIHandler_return404() {
        // Arrange
        RestContext.response = new RestResponse();

        RestRequest req = new RestRequest();
        req.requestURI = '/api/tester';

        RestContext.request =  req;
        
        NorlysAPIFacade facade = new NorlysAPIFacade();
        // Act
        Test.startTest();
        RestResponse actualResponse = facade.doDelete();
        Test.stopTest();
        
        // Assert
        Assert.areEqual(404, actualResponse.statusCode);
    }
    
    @IsTest
    public static void doDelete_exception_returns500() {
        // Arrange
        RestContext.response = new RestResponse();

        RestRequest req = new RestRequest();
        req.requestURI = '/api/tester';
        req.addParameter('Exception', 'throws nullpointers');

        RestContext.request =  req;
        
        NorlysAPIFacade facade = new NorlysAPIFacade();
        // Act
        Test.startTest();
        RestResponse actualResponse = facade.doDelete();
        Test.stopTest();
        
        // Assert
        Assert.areEqual(500, actualResponse.statusCode);
    }
}