/**
* @description Represents a parameter within a validation error, providing a target and a reason.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public class Parameter {
    /** @description The target or field the error relates to. */
    public String target;
    /** @description The reason for the error. */
    public String reason;

    public Parameter(String target, String reason) {
        this.target = target;
        this.reason = reason;
    }

    public static Parameter parse(System.JSONParser parser) {
        String target;
        String reason;

        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return null;

        while(parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();

            if (f == 'target') {
                target = parser.getText();
            } else if (f == 'reason') {
                reason = parser.getText();
            } else {
                parser.skipChildren();
            }
        }
        return new Parameter(target, reason);
    }
}