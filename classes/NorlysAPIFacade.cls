public with sharing class NorlysAPIFacade {
    private static final Map<String, String> URL_TO_HANDLERCLASS;
    
    static {
        if (URL_TO_HANDLERCLASS == null) {
            URL_TO_HANDLERCLASS = new Map<String, String>();

            for(APIHandler_setting__mdt apiHandler : APIHandler_setting__mdt.getAll().values()){
                URL_TO_HANDLERCLASS.put(apiHandler.URLMapping__c, apiHandler.APIHandler__c);
            }
        }
    }

    public RestResponse doGet() {
        RestResponse resp = createDefaultRestResponse();

        try {
            Logger.logInfo('doGet()');
            NorlysAPIRequestResolver resolver = new NorlysAPIRequestResolver(RestContext.request);

            Long startExecution = System.now().getTime();
            resp = this.getHandler(resolver.apiName).doGet(resolver, resp);
            Long responseTime = System.now().getTime() - startExecution;
            Logger.logInfo(buildPayloadTitle(resp, RestContext.request, responseTime.toString(), resolver));
        } catch (NorlysAPIException ex){
            resp.statusCode = ex.statusCode;
            resp.responseBody = Blob.valueOf(ex.getMessage());
        } catch (Exception ex) {
            Logger.logError(ex);

            String jsonException = generateJSONFromException(ex);
            resp.statusCode = 500;
            resp.responseBody = Blob.valueOf(jsonException);
        } finally {
            Logger.emit();
        }

        return resp;
    }

    public RestResponse doPatch() {
        RestResponse resp = createDefaultRestResponse();

        try {
            Logger.logInfo('doPatch()');
            NorlysAPIRequestResolver resolver = new NorlysAPIRequestResolver(RestContext.request);

            Long startExecution = System.now().getTime();
            resp = this.getHandler(resolver.apiName).doPatch(resolver, resp);
            Long responseTime = System.now().getTime() - startExecution;

            Logger.logInfo(buildPayloadTitle(resp, RestContext.request, responseTime.toString(), resolver));
        } catch (NorlysAPIException ex){
            resp.statusCode = ex.statusCode;
            resp.responseBody = Blob.valueOf(ex.getMessage());
        } catch (Exception ex) {
            Logger.logError(ex);

            String jsonException = generateJSONFromException(ex);
            resp.statusCode = 500;
            resp.responseBody = Blob.valueOf(jsonException);
        } finally {
            Logger.emit();
        }

        return resp;
    }

    public RestResponse doPost() {
        RestResponse resp = createDefaultRestResponse();

        try {
            Logger.logInfo('doPost()');
            NorlysAPIRequestResolver resolver = new NorlysAPIRequestResolver(RestContext.request);

            Long startExecution = System.now().getTime();
            resp = this.getHandler(resolver.apiName).doPost(resolver, resp);
            Long responseTime = System.now().getTime() - startExecution;

            Logger.logInfo(buildPayloadTitle(resp, RestContext.request, responseTime.toString(), resolver));
        } catch (NorlysAPIException ex){
            resp.statusCode = ex.statusCode;
            resp.responseBody = Blob.valueOf(ex.getMessage());
        } catch (Exception ex) {
            Logger.logError(ex);

            String jsonException = generateJSONFromException(ex);
            resp.statusCode = 500;
            resp.responseBody = Blob.valueOf(jsonException);
        } finally {
            Logger.emit();
        }

        return resp;
    }

    public RestResponse doPut() {
        RestResponse resp = createDefaultRestResponse();

        try {
            Logger.logInfo('doPut()');
            NorlysAPIRequestResolver resolver = new NorlysAPIRequestResolver(RestContext.request);

            Long startExecution = System.now().getTime();
            resp = this.getHandler(resolver.apiName).doPut(resolver, resp);
            Long responseTime = System.now().getTime() - startExecution;

            Logger.logInfo(buildPayloadTitle(resp, RestContext.request, responseTime.toString(), resolver));
        } catch (NorlysAPIException ex){
            resp.statusCode = ex.statusCode;
            resp.responseBody = Blob.valueOf(ex.getMessage());
        } catch (Exception ex) {
            Logger.logError(ex);

            String jsonException = generateJSONFromException(ex);
            resp.statusCode = 500;
            resp.responseBody = Blob.valueOf(jsonException);
        } finally {
            Logger.emit();
        }

        return resp;
    }

    public RestResponse doDelete() {
        RestResponse resp = createDefaultRestResponse();

        try {
            Logger.logInfo('doDelete()');
            NorlysAPIRequestResolver resolver = new NorlysAPIRequestResolver(RestContext.request);

            Long startExecution = System.now().getTime();
            resp = this.getHandler(resolver.apiName).doDelete(resolver, resp);
            Long responseTime = System.now().getTime() - startExecution;

            Logger.logInfo(buildPayloadTitle(resp, RestContext.request, responseTime.toString(), resolver));
        } catch (NorlysAPIException ex){
            resp.statusCode = ex.statusCode;
            resp.responseBody = Blob.valueOf(ex.getMessage());
        } catch (Exception ex) {
            Logger.logError(ex);

            String jsonException = generateJSONFromException(ex);
            resp.statusCode = 500;
            resp.responseBody = Blob.valueOf(jsonException);
        } finally {
            Logger.emit();
        }

        return resp;
    }

    public NorlysAPIHandler getHandler(String apiName) {
        Logger.logInfo(String.format('getHandler({0})', new List<Object>{ apiName }));
        Type handlerType;

        if (!NorlysAPIFacade.URL_TO_HANDLERCLASS.containsKey(apiName)) {
            Logger.logInfo(
                String.format(
                    '{0} was not mapped in APIHandler_setting__mdt. NorlysAPIHandler will be used.',
                    new List<Object>{ apiName }
                )
            );
            
            return new NorlysAPIHandler();
        } else {
            handlerType = Type.forName(NorlysAPIFacade.URL_TO_HANDLERCLASS.get(apiName));
            Logger.logInfo(String.format('{0} was mapped to APIHandler {1}', new List<Object>{ apiName, handlerType } ));
        }

        return (NorlysAPIHandler) handlerType.newInstance();
    }

    private static String generateJSONFromException(Exception ex) {
        //Write the exception as JSON object to the Que_ErrorMessage__c field
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('exceptionType', ex.getTypeName());
        gen.writeStringField('message', ex.getMessage());
        gen.writeStringField('stackTrace', ex.getStackTraceString());
        gen.writeNumberField('lineNumber', ex.getLineNumber());
        gen.writeEndObject();

        String exceptionAsJSON = gen.getAsString();

        logger.logInfo(String.format('generateJSONFromException({0})', new List<Object>{ exceptionAsJSON }));

        return exceptionAsJSON;
    }

    private static RestResponse createDefaultRestResponse() {
        RestResponse resp = RestContext.response;
        resp.addHeader('Content-Type', 'application/json');
        return resp;
    }

    private static String buildPayloadTitle(
        RestResponse resp,
        RestRequest req,
        String responseTime,
        NorlysAPIRequestResolver resolver
    ) {
        JSONGenerator gen = JSON.createGenerator(false);

        gen.writeStartObject();
        gen.writeFieldName('HTTP_REQUEST');
        gen.writeStartObject();
        gen.writeStringField('requestMethod', resolver.httpMethod);
        gen.writeStringField('requestEndpoint', resolver.apiName);
        gen.writeStringField('requestParams', resolver.urlParams.toString());
        gen.writeStringField('responseStatusCode', resp.statusCode.toString());
        gen.writeStringField('runTime', responseTime);
        gen.writeEndObject();
        gen.writeEndObject();

        return gen.getAsString();
    }
}