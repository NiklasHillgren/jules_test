/**
 * @author Kenneth Houkjær
 *
 * @auth
 * @date 25/07/2024
 * @description Client for the Document Management API
 */
public with sharing class DocumentManagementClient extends HTTPClient {
    /**
     * Named credential used for authentication with Salesforce APIs
     */
    private static final String NAMED_CREDENTIAL = 'Document_API';

    private static final String ENDPOINT_FIND_DOCUMENT = OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'endpointDocClientFindDoc'
    );

    private static final String ENDPOINT_CREATE_DOCUMENT = OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'endpointDocClientCreateDoc'
    );

    private static final String ENDPOINT_DOCUMENT_BY_ID = OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'endpointDocClientDocById'
    );

    private static final String ENDPOINT_CREDIT_NOTE = OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'endpointDocClientOrderCreditNote'
    );

    private static final String ENDPOINT_UPDATE_DOCUMENT_SIGNATURES = OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'endpointDocClientUpdateDocSignatures'
    );

    private static final String ENDPOINT_UPDATE_ORDER_DOCUMENTS_SIGNATURES = OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'endpointDocClientUpdateOrderDocSignature'
    );

    private static final String ENDPOINT_VALIDATE = OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'endpointDocClientValidate'
    );

    private static final String ENDPOINT_FINALIZE = OrgUtils.getCompanySettingsConfigurationValueByDeveloperName(
        'endpointDocClientFinalize'
    );

    /**
     * Constructor that initializes the DocumentClient with DocumentAPI named credential
     */
    public DocumentManagementClient() {
        super(NAMED_CREDENTIAL);
    }

    /**
     * Creates a 'Document'
     *
     * @param document  (required)
     * @return DocumentManagementClientResponseDTO.Document
     * @throws HttpException if fails to make the API call
     */
    public DocumentManagementClientResponseDTO.Document createDocument(
        DocumentManagementClientRequestDTO.Document documentToCreate
    ) {
        Logger.logInfo(String.format('createDocument( {0} )', new List<Object>{ documentToCreate }));

        String endpoint = ENDPOINT_CREATE_DOCUMENT;
        String body = JSON.serialize(documentToCreate);

        HttpResponse response = this.post(endpoint, body);
        handleHttpResponse(response);

        return getDocument(response.getBody());
    }

    /**
     *
     * Delete 'Document' object with given Id
     *
     * @param documentId  (required)
     * @throws HttpException if fails to make the API call
     */
    public void deleteDocument(String documentId) {
        Logger.logInfo(String.format('deleteDocument( {0} )', new List<Object>{ documentId }));

        String endpoint = String.format(ENDPOINT_DOCUMENT_BY_ID, new List<Object>{ documentId });

        HttpResponse response = del(endpoint);
        handleHttpResponse(response);
    }

    /**
     *
     * Finalize documents
     *
     * @param finalizeRequest  (required)
     * @throws HttpException if fails to make the API call
     */
    public void finalizeDocuments(DocumentManagementClientRequestDTO.FinalizeRequest finalizationRequest) {
        Logger.logInfo(String.format('finalizeDocuments( {0} )', new List<Object>{ finalizationRequest }));

        String endpoint = ENDPOINT_FINALIZE;
        String body = JSON.serialize(finalizationRequest);

        HttpResponse response = post(endpoint, body);
        handleHttpResponse(response);
    }

    /**
     *
     * Returns list 'Document' objects based on the given search criteria
     *
     * @param queryParams Map<QUERY_FINDDOCUMENT, Object>
     * @return List<DocumentManagementClientResponseDTO.Document>
     * @throws HttpException
     */
    public List<DocumentManagementClientResponseDTO.Document> findDocuments(Map<Object, Object> queryParams) {
        Logger.logInfo(String.format('findDocuments( {0} )', new List<Object>{ queryParams }));

        String endpoint = ENDPOINT_FIND_DOCUMENT;

        if (queryParams.containsKey(QUERY_FINDDOCUMENT.xfields)) {
            queryParams.put('x-fields', queryParams.get(QUERY_FINDDOCUMENT.xfields));
            queryParams.remove(QUERY_FINDDOCUMENT.xfields);
        }

        String query = makeQueryParams(queryParams);

        HttpResponse response = get(endpoint, query);
        handleHttpResponse(response);

        return getDocuments(response.getBody());
    }

    /**
     * Generate credit note for return order in SAP.
     *
     * If the creditInvoiceId is given in the request:
     *
     * API generates credit note document for given SAP credit invoice id. If OrderCreditNote for given creditInvoiceId already exists then API will return this existing document.
     *
     * If the creditInvoiceId is not given:
     *
     * API generates 0..N new credit note document(s) for returned HW items which do have credit invoice id but do not have related OrderCreditNote document with the same credit invoice id.
     *
     * Subsequent calls to generate credit note document will not return/generate any document if there are no new sap credit invoice ids on the order.
     *
     * If order received via order api contains hw in a state RETURN_APPROVED but without credit invoice id then API returns 404 error with the error code "SAP_CREDIT_INVOICE_NOT_READY" and
     * caller needs to repeat call later.
     *
     * If all OrderCreditNote documents were already generated then API returns 200 OK with empty list of the documents .
     *
     * If caller wants to return all credit note documents (and not only new documents) then he needs to set the flag "returnAllExistingCreditNotes" in the request to "true"
     *
     * @param generateCreditNoteRequest  (required)
     * @return List<DocumentManagementClientResponseDTO.Document>
     * @throws HTTPException
     */
    public List<DocumentManagementClientResponseDTO.Document> generateCreditNote(
        DocumentManagementClientRequestDTO.GenerateCreditNote generateCreditNote
    ) {
        Logger.logInfo(String.format('generateCreditNote( {0} )', new List<Object>{ generateCreditNote }));

        String endpoint = ENDPOINT_CREDIT_NOTE;
        String body = JSON.serialize(generateCreditNote);

        HttpResponse response = post(endpoint, body);
        handleHttpResponse(response);

        return getDocuments(response.getBody());
    }

    /**
     *
     * Returns 'Document' object with given Id or pdf attachment
     *
     * @param queryParams Map<QUERY_PARAMS_GETDOCUMENT, Object>
     * @return DocumentManagementClientResponseDTO.Document
     * @throws HTTPException
     */
    public DocumentManagementClientResponseDTO.Document getDocument(
        String documentId,
        Map<Object, Object> queryParams
    ) {
        Logger.logInfo(String.format('getDocument( {0}, {1} )', new List<Object>{ queryParams }));

        String endpoint = String.format(ENDPOINT_DOCUMENT_BY_ID, new List<Object>{ documentId });
        String query = makeQueryParams(queryParams);

        HttpResponse response = get(endpoint, query);
        handleHttpResponse(response);

        return getDocument(response.getBody());
    }

    /**
     *
     * Update document signatures
     *
     * @param documentId  (required)
     * @param updateSignatures List<DocumentManagementClientRequestDTO.Signature>
     * @return DocumentManagementClientResponseDTO.Document
     * @throws HTTPException, JSON
     */
    public DocumentManagementClientResponseDTO.Document updateDocumentSignatures(
        String documentId,
        List<DocumentManagementClientRequestDTO.Signature> updateSignatures
    ) {
        Logger.logInfo(
            String.format('updateDocumentSignatures( {0}, {1} )', new List<Object>{ documentId, updateSignatures })
        );

        String endpoint = String.format(ENDPOINT_UPDATE_DOCUMENT_SIGNATURES, new List<Object>{ documentId });
        String body = JSON.serialize(updateSignatures);

        HttpResponse response = put(endpoint, body);
        handleHttpResponse(response);

        return getDocument(response.getBody());
    }

    /**
     *
     * Update signatures on order documents.
     *
     * Documents with uniqueSignatureRequired: true are not updated.
     * These documents must to be sign one by one.
     *
     * Returns: list of documents with signatureRequired: true.
     *
     * @param queryParams Map<QUERY_UPDATEORDERDOCUMENTSSIGNATURES, Object>
     * @return List<DocumentManagementClientResponseDTO.Document>
     * @throws HTTPException if fails to make API call
     */
    public List<DocumentManagementClientResponseDTO.Document> updateOrderDocumentsSignatures(
        List<DocumentManagementClientRequestDTO.Signature> signatureUpdates,
        Map<Object, Object> queryParams
    ) {
        Logger.logInfo(
            String.format(
                'updateOrderDocumentsSignatures( {0}, {1} )',
                new List<Object>{ signatureUpdates, queryParams }
            )
        );

        if (queryParams.containsKey(QUERY_UPDATEORDERDOCUMENTSSIGNATURES.xfields)) {
            queryParams.put('x-fields', queryParams.get(QUERY_UPDATEORDERDOCUMENTSSIGNATURES.xfields));
            queryParams.remove(QUERY_UPDATEORDERDOCUMENTSSIGNATURES.xfields);
        }

        String endpoint = ENDPOINT_UPDATE_ORDER_DOCUMENTS_SIGNATURES;
        String query = makeQueryParams(queryParams);
        String body = JSON.serialize(signatureUpdates);

        HttpResponse response = put(endpoint, query, body);
        handleHttpResponse(response);

        return getDocuments(response.getBody());
    }

    /**
     * Validate documents signatures
     *
     * @param validateRequest  (required)
     * @throws HTTPException
     */
    public void validateDocumentSignatures(DocumentManagementClientRequestDTO.ValidateRequest validateRequest) {
        Logger.logInfo(String.format('validateDocumentSignatures( {0} )', new List<Object>{ validateRequest }));

        String endpoint = ENDPOINT_VALIDATE;
        String body = JSON.serialize(validateRequest);

        HttpResponse response = post(endpoint, body);
        handleHttpResponse(response);
    }

    /**
     * EVERYTHING BELOW HERE IS UTILIY STUFF
     */

    /**
     * Deserializes a JSON response into an array of document.
     * @param responseBody The JSON string to deserialize
     * @return Parsed NumberDetailResponse object
     */
    private List<DocumentManagementClientResponseDTO.Document> getDocuments(String responseBody) {
        return (List<DocumentManagementClientResponseDTO.Document>) System.JSON.deserialize(
            responseBody,
            List<DocumentManagementClientResponseDTO.Document>.class
        );
    }

    /**
     * Deserializes a JSON response into an array of document.
     * @param responseBody The JSON string to deserialize
     * @return Parsed NumberDetailResponse object
     */
    private DocumentManagementClientResponseDTO.Document getDocument(String responseBody) {
        return (DocumentManagementClientResponseDTO.Document) System.JSON.deserialize(
            responseBody,
            DocumentManagementClientResponseDTO.Document.class
        );
    }

    public enum QUERY_FINDDOCUMENT {
        brand,
        cvr,
        fields,
        categoryName,
        createdBefore,
        shoppingCartId,
        fetchDocumentManagerDocuments,
        uniqueSignatureRequired,
        type,
        xfields,
        signatureRequired,
        voucherId,
        outputFormat,
        signatureMissing,
        telephoneNumber,
        invoiceId,
        customerId,
        subscriberId,
        createdAfter,
        outputFileName,
        documentId,
        accountId,
        orderId,
        cpr,
        encryptionKey
    }

    public enum QUERY_GETDOCUMENT {
        outputFormat,
        encryptionKey
    }

    public enum QUERY_UPDATEORDERDOCUMENTSSIGNATURES {
        brand,
        shoppingCartId,
        type,
        xfields,
        orderId,
        fields
    }
}