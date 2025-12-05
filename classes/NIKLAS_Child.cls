public with sharing class NIKLAS_Child {
    private final DocumentManagementClient documentManagementClient;

    public NIKLAS_Child() {
        this(SingletonFactory.getFactory());
    }

    private NIKLAS_Child(SingletonFactory singletonFactory) {
        this.documentManagementClient = (DocumentManagementClient) singletonFactory.getOrRegisterSingleton(
            DocumentManagementClient.class
        );
    }

    public void makeCallout(){
        documentManagementClient.deleteDocument('123456789');
    }
}