/**
 * @author Kenneth Houkjær
 * @date 27/07/2024
 * @description Test for the Document Management Client
 */
@isTest
public with sharing class DocumentManagementClientTest {
    @IsTest
    private static void getDocument_WithExistingDocumentId_returnDocument() {
        //Assign
        String body = '{"id":"32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","href":"/document/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","type":"Contract_Summary","name":"Kontraktoversigt-PO353139913.pdf","lifecycleState":"active","creationDate":"2021-11-09T16:08:12+01:00","lastUpdate":"2021-11-10T09:48:12+01:00","documentCharacteristic":[{"name":"brand","value":"teliadk"},{"name":"cpr","value":"020192-1341"},{"name":"orderId","value":"PO353139913"},{"name":"internal","value":"false"}],"relatedParty":[],"attachment":[{"id":"32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","href":"/document/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce/attachment/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","name":"Kontraktoversigt-PO353139913.pdf","type":"Contract_Summary","mimeType":"application/pdf","url":"s3://telia-documentstore-dev/dev/teliadk/2021-11-09/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce"}],"category":[],"documentRelationship":[],"documentAttributes":{"type":"DefaultDocumentAttributes"},"signatureRequired":false,"signatureMissing":false,"uniqueSignatureRequired":false,"signed":false,"signatures":[]}';
        HttpResponseMock mockResponse = new HttpResponseMock(200, 'OK', body);
        Test.setMock(HttpCalloutMock.class, mockResponse);
        String documentId = '32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce';
        DocumentManagementClient client = new DocumentManagementClient();

        //Act
        Test.startTest();
        DocumentManagementClientResponseDTO.Document doc = client.getDocument(documentId, null);
        Test.stopTest();

        //Assert
        Assert.areEqual(
            doc.name,
            'Kontraktoversigt-PO353139913.pdf',
            'The name of the PDF should match the service response'
        );
    }

    @IsTest
    private static void getDocument_WithRandomDocumentId_throwException() {
        //Assign
        String body = '{"code":"BAD_REQUEST","reason":"Invalid document ID.; documentId: 32f9cbbe-fbc6-4de5-a2e4","message":"Bad request"}}';
        HttpResponseMock mockResponse = new HttpResponseMock(400, 'Bad Request', body);
        Test.setMock(HttpCalloutMock.class, mockResponse);

        String documentId = 'Document-Id-does-not-exist';
        DocumentManagementClient client = new DocumentManagementClient();

        //Act
        Test.startTest();
        HTTPException httpExp = null;

        try {
            DocumentManagementClientResponseDTO.Document doc = client.getDocument(documentId, null);
        } catch (HTTPException ex) {
            httpExp = ex;
        }
        Test.stopTest();
        
        //Assert
        Assert.isNotNull(httpExp, 'An exception is thrown');
        Assert.areEqual(httpExp.getMessage(), body, 'The response of an error request is parsed in the body.');
    }

    @IsTest
    private static void deleteDocument_WithRandomDocumentId_throwException() {
        //Assign
        String body = '{"code":"BAD_REQUEST","reason":"Invalid document ID.; documentId: 32f9cbbe-fbc6-4de5-a2e4","message":"Bad request"}}';
        HttpResponseMock mockResponse = new HttpResponseMock(404, 'Bad Request', body);
        Test.setMock(HttpCalloutMock.class, mockResponse);

        String documentId = '32f9cbbe-fbc6-4de5-a2e4';
        DocumentManagementClient client = new DocumentManagementClient();

        //Act
        Test.startTest();
        HTTPException httpExp = null;

        try {
            client.deleteDocument(documentId);
        } catch (HTTPException ex) {
            httpExp = ex;
        }
        Test.stopTest();
        
        //Assert
        Assert.isNotNull(httpExp, 'An exception is thrown');
        Assert.areEqual(httpExp.getMessage(), body, 'The response of an error request is parsed in the body.');
    }

    @IsTest
    private static void createDocument_WithValidDocument_returnsDocument(){
        //Assign
		String body = '{"id":"32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","href":"/document/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","type":"Contract_Summary","name":"Kontraktoversigt-PO353139913.pdf","lifecycleState":"active","creationDate":"2021-11-09T16:08:12+01:00","lastUpdate":"2021-11-10T09:48:12+01:00","documentCharacteristic":[{"name":"brand","value":"teliadk"},{"name":"cpr","value":"020192-1341"},{"name":"orderId","value":"PO353139913"},{"name":"internal","value":"false"}],"relatedParty":[],"attachment":[{"id":"32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","href":"/document/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce/attachment/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","name":"Kontraktoversigt-PO353139913.pdf","type":"Contract_Summary","mimeType":"application/pdf","url":"s3://telia-documentstore-dev/dev/teliadk/2021-11-09/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce"}],"category":[],"documentRelationship":[],"documentAttributes":{"type":"DefaultDocumentAttributes"},"signatureRequired":false,"signatureMissing":false,"uniqueSignatureRequired":false,"signed":false,"signatures":[]}';
        HttpResponseMock mockResponse = new HttpResponseMock(201, 'Created', body);
        
        Test.setMock(HttpCalloutMock.class, mockResponse);

        DocumentManagementClient client = new DocumentManagementClient();
        DocumentManagementClientRequestDTO.Document reqDoc = new DocumentManagementClientRequestDTO.Document();

        //Act
        Test.startTest();
        HTTPException httpExp = null;
		DocumentManagementClientResponseDTO.Document respDoc = null;
        
        try {
            respDoc = client.createDocument(reqDoc);
        } catch (HTTPException ex) {
            httpExp = ex;
        }
        Test.stopTest();
        
        //Assert
        Assert.isNull(httpExp, 'An exception was not thrown');
        Assert.areEqual(respDoc.id, '32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce', 'The response has the same Id.');
    }
    
    @IsTest
    private static void finalizeDocument_WithValidRequest_returns(){
        //Assign
        HttpResponseMock mockResponse = new HttpResponseMock(200, 'Ok', null);
        Test.setMock(HttpCalloutMock.class, mockResponse);

        DocumentManagementClient client = new DocumentManagementClient();
        DocumentManagementClientRequestDTO.FinalizeRequest finalizationRequest = new DocumentManagementClientRequestDTO.FinalizeRequest();
        finalizationRequest.brand = 'teliadk';
        finalizationRequest.orderId = 'orderId';
        finalizationRequest.validateSignatures = true;
        
        //Act
        Test.startTest();
        HTTPException httpExp = null;
        
        try {
            client.finalizeDocuments(finalizationRequest);
        } catch (HTTPException ex) {
            httpExp = ex;
        }
        Test.stopTest();
        
        //Assert
        Assert.isNull(httpExp, 'An exception was not thrown');
    }
    
    @IsTest
    private static void findDocuments_WithValidRequest_returns(){
		//Assign
        String body = '[{"id":"32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","href":"/document/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","type":"Contract_Summary","name":"Kontraktoversigt-PO353139913.pdf","lifecycleState":"active","creationDate":"2021-11-09T16:08:12+01:00","lastUpdate":"2021-11-10T09:48:12+01:00","documentCharacteristic":[{"name":"brand","value":"teliadk"},{"name":"cpr","value":"020192-1341"},{"name":"orderId","value":"PO353139913"},{"name":"internal","value":"false"}],"relatedParty":[],"attachment":[{"id":"32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","href":"/document/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce/attachment/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","name":"Kontraktoversigt-PO353139913.pdf","type":"Contract_Summary","mimeType":"application/pdf","url":"s3://telia-documentstore-dev/dev/teliadk/2021-11-09/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce"}],"category":[],"documentRelationship":[],"documentAttributes":{"type":"DefaultDocumentAttributes"},"signatureRequired":false,"signatureMissing":false,"uniqueSignatureRequired":false,"signed":false,"signatures":[]}]';

        HttpResponseMock mockResponse = new HttpResponseMock(200, 'Ok', body);
        Test.setMock(HttpCalloutMock.class, mockResponse);

        DocumentManagementClient client = new DocumentManagementClient();
        Map<Object, Object> parameters = new Map<Object, Object>();
        parameters.put(DocumentManagementClient.QUERY_FINDDOCUMENT.xfields, 'hello');
        
        //Act
        Test.startTest();
        HTTPException httpExp = null;
        List<DocumentManagementClientResponseDTO.Document> responseDocs;
        try {
            responseDocs = client.findDocuments(parameters);
        } catch (HTTPException ex) {
            httpExp = ex;
        }
        Test.stopTest();
        
        //Assert
        Assert.isNull(httpExp, 'An exception was not thrown');
        Assert.areEqual(responseDocs.get(0).id, '32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce', 'The response has the same Id.');
    }
    
    @IsTest
    private static void generateCreditNote_WithValidRequest_returns(){
        //Assign
        String body = '[{"id":"32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","href":"/document/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","type":"Contract_Summary","name":"Kontraktoversigt-PO353139913.pdf","lifecycleState":"active","creationDate":"2021-11-09T16:08:12+01:00","lastUpdate":"2021-11-10T09:48:12+01:00","documentCharacteristic":[{"name":"brand","value":"teliadk"},{"name":"cpr","value":"020192-1341"},{"name":"orderId","value":"PO353139913"},{"name":"internal","value":"false"}],"relatedParty":[],"attachment":[{"id":"32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","href":"/document/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce/attachment/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","name":"Kontraktoversigt-PO353139913.pdf","type":"Contract_Summary","mimeType":"application/pdf","url":"s3://telia-documentstore-dev/dev/teliadk/2021-11-09/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce"}],"category":[],"documentRelationship":[],"documentAttributes":{"type":"DefaultDocumentAttributes"},"signatureRequired":false,"signatureMissing":false,"uniqueSignatureRequired":false,"signed":false,"signatures":[]}]';

        HttpResponseMock mockResponse = new HttpResponseMock(200, 'Ok', body);
        Test.setMock(HttpCalloutMock.class, mockResponse);

        DocumentManagementClient client = new DocumentManagementClient();
        DocumentManagementClientRequestDTO.GenerateCreditNote generateCreditNote = new DocumentManagementClientRequestDTO.GenerateCreditNote();
        
        //Act
        Test.startTest();
        HTTPException httpExp = null;
        List<DocumentManagementClientResponseDTO.Document> responseDocs;
        try {
            responseDocs = client.generateCreditNote(generateCreditNote);
        } catch (HTTPException ex) {
            httpExp = ex;
        }
        Test.stopTest();
        
        //Assert
        Assert.isNull(httpExp, 'An exception was not thrown');
        Assert.areEqual(responseDocs.get(0).id, '32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce', 'The response has the same Id.');
    }
    
    @IsTest
    private static void updateOrderDocumentsSignatures_WithValidRequest_returns(){
        //Assign
        String body = '[{"id":"32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","href":"/document/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","type":"Contract_Summary","name":"Kontraktoversigt-PO353139913.pdf","lifecycleState":"active","creationDate":"2021-11-09T16:08:12+01:00","lastUpdate":"2021-11-10T09:48:12+01:00","documentCharacteristic":[{"name":"brand","value":"teliadk"},{"name":"cpr","value":"020192-1341"},{"name":"orderId","value":"PO353139913"},{"name":"internal","value":"false"}],"relatedParty":[],"attachment":[{"id":"32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","href":"/document/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce/attachment/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce","name":"Kontraktoversigt-PO353139913.pdf","type":"Contract_Summary","mimeType":"application/pdf","url":"s3://telia-documentstore-dev/dev/teliadk/2021-11-09/32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce"}],"category":[],"documentRelationship":[],"documentAttributes":{"type":"DefaultDocumentAttributes"},"signatureRequired":false,"signatureMissing":false,"uniqueSignatureRequired":false,"signed":false,"signatures":[]}]';
        HttpResponseMock mockResponse = new HttpResponseMock(200, 'Ok', body);
        Test.setMock(HttpCalloutMock.class, mockResponse);
        
        DocumentManagementClient client = new DocumentManagementClient();
        List<DocumentManagementClientRequestDTO.Signature> signatureUpdates = new List<DocumentManagementClientRequestDTO.Signature>();
            
        Map<Object, Object> parameters = new Map<Object, Object>();
        parameters.put(DocumentManagementClient.QUERY_UPDATEORDERDOCUMENTSSIGNATURES.xfields, 'hello');
        List<DocumentManagementClientResponseDTO.Document> responseDocs;
        
        //Act
        Test.startTest();
        HTTPException httpExp = null;
        try {
            responseDocs = client.updateOrderDocumentsSignatures(signatureUpdates, parameters);
        } catch (HTTPException ex) {
            httpExp = ex;
        }
        Test.stopTest();
        
		//Assert
        Assert.isNull(httpExp, 'An exception was not thrown');
        Assert.areEqual(responseDocs.get(0).id, '32f9cbbe-fbc6-4de5-a2e4-c5b40b3e15ce', 'The response has the same Id.');
    }
    
    @IsTest
    private static void validateDocumentSignatures_WithValidRequest_returns() {
        //Assign
        HttpResponseMock mockResponse = new HttpResponseMock(200, 'Ok', null);
        Test.setMock(HttpCalloutMock.class, mockResponse);
        
        DocumentManagementClient client = new DocumentManagementClient();
        DocumentManagementClientRequestDTO.ValidateRequest validateRequest = new DocumentManagementClientRequestDTO.ValidateRequest();
        
        //Act
        Test.startTest();
        HTTPException httpExp = null;
        try {
            client.validateDocumentSignatures(validateRequest);
        } catch (HTTPException ex) {
            httpExp = ex;
        }
        Test.stopTest();
        
		//Assert
		Assert.isNull(httpExp, 'An exception was not thrown');
    }
}