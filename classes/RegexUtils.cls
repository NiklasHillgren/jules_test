/**
 * @description Utility class for handling regular expressions.
 */
public class RegexUtils {

    /**
     * @description Finds matches in a string for a given regex pattern.
     * @param input The string to search for matches.
     * @return A Matcher object that contains the results of the search.
     */
    public static Matcher getMatcher(String input) {
        // Original regex: \s*\"attr\" *: *(\"(.*?)\"(,|\s|)|\s*\{(.*?)\}(,|\s|))
        // Transformed for Apex:
        String regex = '\\s*\\"attr\\"\\s*:\\s*(\\"(.*?)\\"(,|\\s|)|\\s*\\{(.*?)\\}(,|\\s|))';
        Pattern p = Pattern.compile(regex);
        return p.matcher(input);
    }

    /**
     * @description Removes the "attributes" key-value pair from a JSON string from a Salesforce query.
     * @param jsonString The JSON string to process.
     * @return The JSON string without the "attributes" key-value pair.
     */
    public static String removeAttribute(String jsonString) {
        // This regex finds the "attributes" key, its corresponding object value, and the trailing comma.
        String regex = '\\"attributes\\":\\{.*?\\},';
        return jsonString.replaceAll(regex, '');
    }
}
