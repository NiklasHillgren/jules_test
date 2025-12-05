public with sharing class OAST_PRO_CLIENT extends HTTPClient {
    private static final String NAMED_CREDENTIAL = 'OAST_PRO';


    public OAST_PRO_CLIENT() {
        super(NAMED_CREDENTIAL);
    }

    public void getstuff(){
        this.get('');
    }

    public void postStuff(String body){
        this.post('', body);
    }
}