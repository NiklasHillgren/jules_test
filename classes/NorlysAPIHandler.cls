public virtual class NorlysAPIHandler {
    public static final String BASIC_RESPONSE = '[{"errorCode" : "NOT_FOUND",  "message" : "Could not find a match for URL"}]';

    public NorlysAPIHandler(){
    }

    public virtual RestResponse doDelete(NorlysAPIRequestResolver resolver, RestResponse resp) {
        Logger.logInfo(String.format('doDelete({0})', new List<Object>{resolver}));

        return getResponse(resp);
    }

    public virtual RestResponse doGet(NorlysAPIRequestResolver resolver, RestResponse resp) {
        Logger.logInfo(String.format('doGet({0})', new List<Object>{resolver}));

        return getResponse(resp);
    }
    
    public virtual RestResponse doPatch(NorlysAPIRequestResolver resolver, RestResponse resp) {
        Logger.logInfo(String.format('doPatch({0})', new List<Object>{resolver}));

        return getResponse(resp);
    }

    public virtual RestResponse doPost(NorlysAPIRequestResolver resolver, RestResponse resp) {
        Logger.logInfo(String.format('doPost({0})', new List<Object>{resolver}));

        return getResponse(resp);
    }

    public virtual RestResponse doPut(NorlysAPIRequestResolver resolver, RestResponse resp) {
        Logger.logInfo(String.format('doPut({0})', new List<Object>{resolver}));
        
        return getResponse(resp);
    }

    private RestResponse getResponse(RestResponse resp) {
        resp.statusCode = 404;
        resp.responseBody = Blob.valueOf( BASIC_RESPONSE );
        
        return resp;
    }

    // Helper method to parse JSON responses
    protected Object parseRequest(String json, Type targetType) {
        try {
            return System.JSON.deserialize(json, targetType);
        } catch (System.JSONException e) {
            NorlysAPIException ex = new NorlysAPIException(e.getMessage());
            ex.statusCode = 400;
            throw ex;
        }
    }
}