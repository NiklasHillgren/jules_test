@RestResource(urlMapping='/api/serviceOrdering/*')
global class OrderAPIGateway {
    private static final NorlysAPIFacade API_FACADE;

    static {
        SingletonFactory singleFactory = SingletonFactory.getFactory();
        OrderAPIGateway.API_FACADE = (NorlysAPIFacade) singleFactory.getOrRegisterSingleton(NorlysAPIFacade.class);
    }

    @HttpGet
    global static void doGet() {
        API_FACADE.doGet();
    }

    @HttpPatch
    global static void doPatch() {
        API_FACADE.doPatch();
    }

    @HttpPost
    global static void doPost() {
        API_FACADE.doPost();
    }

    @HttpPut
    global static void doPut() {
        API_FACADE.doPut();
    }

    @HttpDelete
    global static void doDelete() {
        API_FACADE.doDelete();
    }
}