@isTest
private class JsonExtractorTest {

    @isTest
    static void testExtractAttributes_PositiveCase() {
        String jsonString = '[ {' +
        '  "attributes" : {' +
        '    "type" : "Account",' +
        '    "url" : "/services/data/v65.0/sobjects/Account/001RR00000r0loWYAQ"' +
        '  },' +
        '  "Id" : "001RR00000r0loWYAQ",' +
        '  "Name" : "KM Kirurgi"' +
        '} ]';

        String expected = '"attributes" : {' +
        '    "type" : "Account",' +
        '    "url" : "/services/data/v65.0/sobjects/Account/001RR00000r0loWYAQ"' +
        '  }';

        // To make the test resilient to whitespace differences, we can remove all whitespace
        // from both the expected and actual strings before comparing them.
        String sanitizedExpected = expected.replaceAll('\\s', '');

        Test.startTest();
        String result = JsonExtractor.extractAttributes(jsonString);
        Test.stopTest();

        String sanitizedResult = result.replaceAll('\\s', '');


        System.assertEquals(sanitizedExpected, sanitizedResult, 'The extracted attributes object should match the expected object.');
    }

    @isTest
    static void testExtractAttributes_NegativeCase() {
        String jsonString = '[ {' +
        '  "Id" : "001RR00000r0loWYAQ",' +
        '  "Name" : "KM Kirurgi"' +
        '} ]';

        Test.startTest();
        String result = JsonExtractor.extractAttributes(jsonString);
        Test.stopTest();

        System.assertEquals(null, result, 'The result should be null when attributes are not found.');
    }
}
