@isTest
private class RegexUtilsTest {

    @isTest
    static void testStringAttribute() {
        String input = '{"attr": "value"}';
        Matcher m = RegexUtils.getMatcher(input);
        System.assertEquals(true, m.find(), 'Should find a match for string attribute');
        System.assertEquals('"attr": "value"', m.group(0).trim());
    }

    @isTest
    static void testObjectAttribute() {
        String input = '{"attr": {"key": "value"}}';
        Matcher m = RegexUtils.getMatcher(input);
        System.assertEquals(true, m.find(), 'Should find a match for object attribute');
        System.assertEquals('"attr": {"key": "value"}', m.group(0).trim());
    }

    @isTest
    static void testNoMatch() {
        String input = '{"other_attr": "value"}';
        Matcher m = RegexUtils.getMatcher(input);
        System.assertEquals(false, m.find(), 'Should not find a match');
    }

    @isTest
    static void testStringAttributeWithComma() {
        String input = '{"attr": "value", "another_attr": "another_value"}';
        Matcher m = RegexUtils.getMatcher(input);
        System.assertEquals(true, m.find(), 'Should find a match for string attribute with comma');
        System.assertEquals('"attr": "value",', m.group(0).trim());
    }

    @isTest
    static void testObjectAttributeWithComma() {
        String input = '{"attr": {"key": "value"}, "another_attr": "another_value"}';
        Matcher m = RegexUtils.getMatcher(input);
        System.assertEquals(true, m.find(), 'Should find a match for object attribute with comma');
        System.assertEquals('"attr": {"key": "value"},', m.group(0).trim());
    }
}
