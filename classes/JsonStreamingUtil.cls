/**
 * JsonStreamingUtil is a utility class designed to facilitate the reading of various data types 
 * from a JSON stream using the System.JSONParser in Apex.
 *
 * This class provides static methods to read and convert JSON tokens into their respective 
 * Apex data types, including String, Integer, Decimal, and Boolean. Each method handles 
 * null values and exceptions gracefully, returning null when the token is null or when 
 * conversion fails.
 *
 * Methods:
 * - readStringToken(System.JSONParser parser): Reads a string token from the JSON parser.
 * - readIntegerToken(System.JSONParser parser): Reads an integer token from the JSON parser.
 * - readDecimalToken(System.JSONParser parser): Reads a decimal token from the JSON parser.
 * - readBooleanToken(System.JSONParser parser): Reads a boolean token from the JSON parser.
 *
 * Usage:
 * This class can be used in any Apex code that requires parsing JSON data, enabling 
 * developers to easily extract and convert values from JSON structures.
 */
public class JsonStreamingUtil {
    public static String readStringToken(System.JSONParser parser) {
        if (parser.getCurrentToken() == System.JSONToken.VALUE_NULL) return null;
        return parser.getText();
    }
    public static Integer readIntegerToken(System.JSONParser parser) {
        if (parser.getCurrentToken() == System.JSONToken.VALUE_NULL) return null;
        try { return Integer.valueOf(parser.getText()); } catch(Exception e) { return null; }
    }
    public static Decimal readDecimalToken(System.JSONParser parser) {
        if (parser.getCurrentToken() == System.JSONToken.VALUE_NULL) return null;
        try { return Decimal.valueOf(parser.getText()); } catch(Exception e) { return null; }
    }
    public static Boolean readBooleanToken(System.JSONParser parser) {
        if (parser.getCurrentToken() == System.JSONToken.VALUE_NULL) return null;
        if (parser.getCurrentToken() == System.JSONToken.VALUE_TRUE) return true;
        if (parser.getCurrentToken() == System.JSONToken.VALUE_FALSE) return false;
        try { return Boolean.valueOf(parser.getText()); } catch(Exception e) { return null; }
    }
    public static Date readDateToken(System.JSONParser parser) {
        if (parser.getCurrentToken() == System.JSONToken.VALUE_NULL) return null;
        try { return (Date)JSON.deserialize('"' + parser.getText() + '"', Date.class); } catch(Exception e) { return null; }
    }
}