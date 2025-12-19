/**
 * @description Test class for ApexClassQueryResultDTO.
 */
@isTest
private class ApexClassQueryResultDTOTest {

    /**
     * @description Verifies that an instance of ApexClassQueryResultDTO serializes to the correct JSON format.
     */
    @isTest
    static void testSerialization() {
        String jsonInput = '{\n' +
        '    "size": 38,\n' +
        '    "totalSize": 38,\n' +
        '    "done": true,\n' +
        '    "queryLocator": null,\n' +
        '    "entityTypeName": "ApexClass",\n' +
        '    "records": [\n' +
        '        {\n' +
        '            "attributes": {\n' +
        '                "type": "ApexClass",\n' +
        '                "url": "/services/data/v59.0/tooling/sobjects/ApexClass/01p4H00000A4kfqQAB"\n' +
        '            },\n' +
        '            "Name": "GenericEventPostMock"\n' +
        '        }\n' +
        '    ]\n' +
        '}';

        ApexClassQueryResultDTO dto = (ApexClassQueryResultDTO) JSON.deserialize(jsonInput, ApexClassQueryResultDTO.class);

        System.assertEquals(38, dto.size);
        System.assertEquals(38, dto.totalSize);
        System.assertEquals(true, dto.done);
        System.assertEquals(null, dto.queryLocator);
        System.assertEquals("ApexClass", dto.entityTypeName);
        System.assertEquals(1, dto.records.size());
        System.assertEquals("ApexClass", dto.records[0].attributes.type);
        System.assertEquals("/services/data/v59.0/tooling/sobjects/ApexClass/01p4H00000A4kfqQAB", dto.records[0].attributes.url);
        System.assertEquals("GenericEventPostMock", dto.records[0].Name);

        String serializedJson = JSON.serialize(dto);
        ApexClassQueryResultDTO deserializedDto = (ApexClassQueryResultDTO) JSON.deserialize(serializedJson, ApexClassQueryResultDTO.class);

        System.assertEquals(dto.size, deserializedDto.size);
        System.assertEquals(dto.totalSize, deserializedDto.totalSize);
        System.assertEquals(dto.done, deserializedDto.done);
        System.assertEquals(dto.queryLocator, deserializedDto.queryLocator);
        System.assertEquals(dto.entityTypeName, deserializedDto.entityTypeName);
        System.assertEquals(dto.records.size(), deserializedDto.records.size());
        System.assertEquals(dto.records[0].attributes.type, deserializedDto.records[0].attributes.type);
        System.assertEquals(dto.records[0].attributes.url, deserializedDto.records[0].attributes.url);
        System.assertEquals(dto.records[0].Name, deserializedDto.records[0].Name);
    }
}
