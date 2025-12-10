/**
 * @description A utility class to extract specific parts of a JSON string using regular expressions.
 */
public class JsonExtractor {

    /**
     * @description Extracts the "attributes" JSON object from a given JSON string.
     * @param jsonString The JSON string to parse.
     * @return The "attributes" object as a string, or null if not found.
     */
    public static String extractAttributes(String jsonString) {
        // Use the (?s) flag to enable "dotall" mode, allowing '.' to match newline characters.
        String regex = '(?s)"attributes"\\s*:\\s*\\{.*?\\}';

        Pattern p = Pattern.compile(regex);
        Matcher m = p.matcher(jsonString);

        if (m.find()) {
            return m.group(0);
        } else {
            return null;
        }
    }
}
