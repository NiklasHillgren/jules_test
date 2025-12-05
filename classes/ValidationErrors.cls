/**
* @description Represents a validation error from the API, containing an error code and a list of parameters.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Kenneth Houkjær      11/09/2025      Initial version.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public class ValidationErrors {
    /** @description The code for the validation error. */
    public String errorCode;
    /** @description A list of parameters providing more detail about the error. */
    public List<Parameter> parameters;

    public ValidationErrors(String errorCode, List<Parameter> parameters) {
        this.errorCode = errorCode;
        this.parameters = parameters;
    }

    public static ValidationErrors parse(System.JSONParser parser) {
        String errorCode;
        List<Parameter> parameters = new List<Parameter>();

        if (parser.getCurrentToken() == null) parser.nextToken();
        if (parser.getCurrentToken() != System.JSONToken.START_OBJECT) return null;

        while(parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() != System.JSONToken.FIELD_NAME) continue;
            String f = parser.getText(); parser.nextToken();

            if (f == 'errorCode') {
                errorCode = parser.getText();
            } else if (f == 'parameters' && parser.getCurrentToken() == System.JSONToken.START_ARRAY) {
                while(parser.nextToken() != System.JSONToken.END_ARRAY) {
                    if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) {
                        parameters.add(Parameter.parse(parser));
                    }
                }
            } else {
                parser.skipChildren();
            }
        }
        return new ValidationErrors(errorCode, parameters);
    }
}