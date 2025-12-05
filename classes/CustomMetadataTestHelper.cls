/**
 * @description A utility class for creating Custom Metadata records in a test context.
 *              This class uses a dynamic DML approach to insert metadata records,
 *              which is necessary because custom metadata is not directly insertable
 *              in Apex tests.
 * @group SUnit
 */
@isTest
public class CustomMetadataTestHelper {
    /**
     * @description Creates and inserts a single Custom Metadata record.
     * @param metadataTypeName The API name of the Custom Metadata Type (e.g., 'APISettings__mdt').
     * @param fieldValues A map of field API names to their values.
     * @return The created SObject record.
     */
    public static SObject createCustomMetadata(String metadataTypeName, Map<String, Object> fieldValues) {
        // Get the SObjectType for the custom metadata
        SObjectType mdtType = Schema.getGlobalDescribe().get(metadataTypeName);
        if (mdtType == null) {
            throw new CustomMetadataTestException('Custom Metadata Type not found: ' + metadataTypeName);
        }

        // Create a new record
        SObject mdtRecord = mdtType.newSObject();

        // Populate the fields
        for (String fieldName : fieldValues.keySet()) {
            mdtRecord.put(fieldName, fieldValues.get(fieldName));
        }

        // Insert the record using dynamic DML
        List<SObject> recordsToInsert = new List<SObject>{ mdtRecord };
        List<Database.SaveResult> results = Database.insert(recordsToInsert, false);

        // Check for errors
        for (Database.SaveResult sr : results) {
            if (!sr.isSuccess()) {
                String errors = '';
                for(Database.Error err : sr.getErrors()) {
                    errors += err.getStatusCode() + ': ' + err.getMessage() + ' (' + String.join(err.getFields(), ',') + ')\n';
                }
                throw new CustomMetadataTestException('Failed to insert Custom Metadata record: ' + errors);
            }
        }

        return recordsToInsert[0];
    }

    public class CustomMetadataTestException extends Exception {}
}