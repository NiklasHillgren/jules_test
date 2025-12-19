/**
 * @description Represents the structure of a query result from the Salesforce Tooling API for ApexClass objects.
 */
public class ApexClassQueryResultDTO {
    public Integer size;
    public Integer totalSize;
    public Boolean done;
    public Object queryLocator;
    public String entityTypeName;
    public List<Record> records;

    /**
     * @description Represents a single record in the query result.
     */
    public class Record {
        public Attributes attributes;
        public String Name;
    }

    /**
     * @description Represents the attributes of a record.
     */
    public class Attributes {
        public String type;
        public String url;
    }
}
