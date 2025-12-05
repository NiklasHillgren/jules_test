public virtual with sharing class NIKLAS_Parent {
    /** THE FOLLOWING TWO CLASSES ARE GIVEN FROM YAML */
    public virtual class DataContainer  {
        public String data;
    }

    public class AdditionalDataContainer extends Datacontainer {
        public String phoneNumber;
    }

    public virtual class DataContainerBuilder extends ParameterValidator {
        // 1) Builder pattern support immutable/final.
        private String data; 

        public DataContainerBuilder withData(String data){
            this.data = data;
            return this;
        }

        public void setProperties(DataContainer c){
            c.data = this.data;
        }

        public virtual DataContainer build(){
            DataContainer result = new DataContainer();
            result.data = this.data;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }

    public class AdditionalDataContainerBuilder extends NIKLAS_Parent.DataContainerBuilder {
        private String phoneNumber;

        public AdditionalDataContainerBuilder withPhoneNumber(String phoneNumber){
            this.validatePhoneNumberIsValid('PHONE_NUBMER', phoneNumber, false);

            this.phoneNumber = phoneNumber;
            return this;
        }

        public override DataContainer build(){
            Logger.logInfo(String.format('getListOfErrors( {0} )', new List<Object>{ this.getListOfErrors() }));

            AdditionalDataContainer result = new AdditionalDataContainer();
            setProperties(result);
            result.phoneNumber = this.phoneNumber;

            Logger.logInfo(String.format('build( {0} )', new List<Object>{ result }));

            return result;
        }
    }
}