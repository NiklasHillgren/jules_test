public with sharing class NorlysAPIRequestResolver {
    private final String apiBase = '/api/';
    public String apiName { get; private set; }
    public String httpMethod { get; private set; }
    public String requestBody { get; private set; }
    public Map<String, String> urlParams { get; private set; }

    public NorlysAPIRequestResolver(RestRequest req) {
        LOGGER.logInfo(String.format('NorlysAPIRequestResolver({0})', new List<Object>{ req }));

        this.RequestBody = req.requestBody != null ? req.requestBody.toString() : null;
        this.urlParams = req.params != null ? req.params : new Map<String, String>();
        this.httpMethod = req.httpMethod != null ? req.httpMethod : 'HTTP method missing';
        this.ApiName = String.isBlank(req.requestURI) ? req.requestURI : req.requestURI.remove(apiBase);
        
        //This is used to fake an exception
        if(Test.isRunningTest() && urlParams.containsKey('Exception')){
            String s ;
            s.charat(5);
        }
    }
}