public virtual class ParameterValidator {
    /**
     * Matces a string if it is a numeric value with no other characters and its length is no less than 8 digits and no more than 15 digits.
     */
    public static String REGEX_PHONE {
        get {
            return '^[0-9]{8,15}$';
        }
    }

    Map<String, Map<String, ParameterError>> mapOfErrors = new Map<String, Map<String, ParameterError>>();

    public virtual Boolean isValid(){
        return getListOfErrors().isEmpty();
    }

    /**
     * This method checks if the input is acceptable, or if the input is invalid.
     *
     * If an override for the response status code is provided and is greater than 0, it sets the
     * responseOverrideStatus to the provided override value.
     *
     * Invalid input -> Adds an error with the provided parameter name, reason, exception severity, and unique error identifier.
     *
     * Acceptable input ->  It removes any existing error with the same parameter name and unique error identifier.
     *
     * @param invalidInput Flag indicating if the input is invalid.
     * @param inputIsNull Flag indicating if the input is null.
     * @param acceptNull Flag indicating if null input is acceptable. TODO: Should this be acceptBlank?
     * @param parameterName The name of the parameter being validated.
     * @param exceptionSeverityName The severity level of the exception to be thrown (Only used in Account Services).
     * @param uniqueErrorIdentifier A unique identifier for the error.
     * @param reason The reason for the error, to be set in the ParameterError object if validation fails.
     * @param overrideResponseStatusCode An integer to override the response status code if validation fails.
     * @return The current instance of ParameterValidator for method chaining.
     */
    private ParameterValidator genericValidate(
        Boolean invalidInput,
        Boolean inputIsNull,
        Boolean acceptNull,
        String parameterName,
        String exceptionSeverityName,
        String uniqueErrorIdentifier,
        String reason
    ) {
        if ((inputIsNull && !acceptNull) || (invalidInput && !(inputIsNull && acceptNull))) {
            addError(new ParameterError(parameterName, reason, exceptionSeverityName, uniqueErrorIdentifier));
        } else {
            removeError(parameterName, uniqueErrorIdentifier);
        }

        return this;
    }

    /**
     * The phone must be between 8 and 15 digits long. Danish phone numbers should not start with a 1 or 0, foreign numbers should start with 00
     *
     * @param parameterName The name of the parameter.
     * @param phoneNumber The phone number to validate
     * @param acceptNull Flag indicating if null input is acceptable.
     * @return return ApiRequestValidator
     */
    public ParameterValidator validatePhoneNumberIsValid(String parameterName, String phoneNumber, Boolean acceptNull) {
        // Attempt to match pattern if number not null
        Boolean failedToFindValidPhoneNumber = true;
        if (phoneNumber != null) {
            String phoneRegex = ParameterValidator.REGEX_PHONE;
            Pattern MyPattern = Pattern.compile(phoneRegex);
            Matcher MyMatcher = MyPattern.matcher(phoneNumber);
            if (MyMatcher.matches()) {
                failedToFindValidPhoneNumber = false;
            }
        }
        return this.genericValidate(
            failedToFindValidPhoneNumber,
            phoneNumber == null,
            acceptNull,
            parameterName,
            null,
            'validatePhoneNumberIsValid' + '-' + parameterName,
            phoneNumber == null ? 'Input is not a valid phone number' : phoneNumber + ' is not a valid phone number.'
        );
    }

    /**
     * Returns a list of validation errors
     * @return return List<ApiRequestError>
     */
    public virtual List<ParameterError> getRequestErrors() {
        return getListOfErrors();
    }

    /**
     * Nulls the value of uniqueErrorIdentifier and exceptionSeverityName since these doesn't add any value for
     * externals. By nulling the values, they can later be removed from responsens with JSON suppress null.
     * @return Parameters Errors with uniqueErrorIdentifier and exceptionSeverityName nulled.
     */
    public List<ParameterError> getErrorsInExternalFormat() {
        List<ParameterError> errors = getListOfErrors();
        for (ParameterError currentParameterError : errors) {
            currentParameterError.uniqueErrorIdentifier = null;
            currentParameterError.exceptionSeverityName = null;
        }
        return errors;
    }

    public void clearRequestErrors() {
        mapOfErrors = new Map<String, Map<String, ParameterError>>();
    }

    public void removeError(ParameterError paramError) {
        removeError(paramError.parameterName, paramError.uniqueErrorIdentifier);
    }

    public void removeError(String parameterName, String uniqueErrorIdentifier) {
        if (mapOfErrors.containsKey(parameterName)) {
            Map<String, ParameterError> mapOfApiRequestErrors = mapOfErrors.get(parameterName);

            if (mapOfApiRequestErrors.containsKey(uniqueErrorIdentifier)) {
                mapOfApiRequestErrors.remove(uniqueErrorIdentifier);
            }

            if (mapOfApiRequestErrors.isEmpty()) {
                mapOfErrors.remove(parameterName);
            }
        }
    }

    /**
     * @param paramError E.g.,
     *  ApiRequestError paramError1 = new ApiRequestError(
     *               ConsentCapturedSourceType, //parameterName
     *               'The ConsentCapturedSourceType parameter is required', //reason
     *               null, //exceptionSeverityName
     *               'validateRequiredParameter-ConsentCapturedSourceType' //
     *
     *  ApiRequestError paramError2 = new ApiRequestError(
     *               consentCapturedSource, //parameterName
     *               'The consentCapturedSource parameter is required', //reason
     *               null, //exceptionSeverityName
     *               'validateRequiredParameter-consentCapturedSource' //uniqueErrorIdentifier
     *
     *  ApiRequestError paramError3 = new ApiRequestError(
     *               ConsentCapturedSourceType,
     *               'MM is not a valid picklist value',
     *               null,
     *               'validatePicklistValue-ConsentCapturedSourceType'));
     *
     *   When param1 is added, we do not find anything in the map and therefore add an entry
     *
     *   'ConsentCapturedSourceType', {'validateRequiredParameter-ConsentCapturedSourceType', param1}
     *
     *   When param3 is added, we find the previous entry for the ConsentCapturedSourceType
     *
     *   {'validateRequiredParameter-ConsentCapturedSourceType', param1}
     *
     *   We add an addition error
     *
     *   'ConsentCapturedSourceType', {'validatePicklistValue-ConsentCapturedSourceType', param3}
     *
     *   The collection of errors is now
     *
     *   'ConsentCapturedSourceType', [{'validateRequiredParameter-ConsentCapturedSourceType', param1}, {'validatePicklistValue-ConsentCapturedSourceType', param3}]
     *
     *   When param2 is added, we do not find anything in the map and add an addition entry
     *
     *   'consentCapturedSource', {'validateRequiredParameter-consentCapturedSource', param2}
     *
     *   The collection of errors is now
     *
     *   [{'ConsentCapturedSourceType', [{'validateRequiredParameter-ConsentCapturedSourceType', param1}, {'validatePicklistValue-ConsentCapturedSourceType', param3}]},
     *   {'consentCapturedSource', {'validateRequiredParameter-consentCapturedSource', param2}}]
     *
     *   If we remove param1, the collection is
     *
     *   [{'ConsentCapturedSourceType', [{'validatePicklistValue-ConsentCapturedSourceType', param3}]},
     *   {'consentCapturedSource', {'validateRequiredParameter-consentCapturedSource', param2}}]
     *
     *   If we remove param3, the collection is
     *
     *   [{'consentCapturedSource', {'validateRequiredParameter-consentCapturedSource', param2}}]
     */
    public void addError(ParameterError paramError) {
        // A parameter error collection entry already exist
        if (mapOfErrors.containsKey(paramError.parameterName)) {
            Map<String, ParameterError> mapOfApiRequestErrors = mapOfErrors.get(paramError.parameterName);

            // No previous detailed error has been added for the given validation
            if (!mapOfApiRequestErrors.containsKey(paramError.uniqueErrorIdentifier)) {
                mapOfApiRequestErrors.put(paramError.uniqueErrorIdentifier, paramError);
            }
            // A detailed error for the given validation already exist, update the error
            else {
                mapOfApiRequestErrors.get(paramError.uniqueErrorIdentifier).reason = paramError.reason;
            }
            // No parameter error collection exist, create one
        } else {
            Map<String, ParameterError> mapOfApiRequestErrors = new Map<String, ParameterError>();

            // Create a list of detailed errors related to the parameter
            mapOfApiRequestErrors.put(paramError.uniqueErrorIdentifier, paramError);
            mapOfErrors.put(paramError.parameterName, mapOfApiRequestErrors);
        }
    }

    /**
     * @return The first error from 'DatabaseSaveError' if it exists, otherwise null
     */
    public ParameterError getDatabaseApiRequestError() {
        return mapOfErrors.containsKey('DatabaseSaveError') ? mapOfErrors.get('DatabaseSaveError').values()[0] : null;
    }

    public List<ParameterError> getListOfErrors() {
        List<ParameterError> listOfApiRequestErrors = new List<ParameterError>();
        // Iterate over the values of the mapOfErrors, which are maps of errors and add all parameterErrors to the list
        for (Map<String, ParameterError> errors : mapOfErrors.values()) {
            listOfApiRequestErrors.addAll(errors.values());
        }
        return listOfApiRequestErrors;
    }

    /**
     * Takes a parameter/key and returns any errors on the given parameter, and null if no errors are found.
     *
     * @param parameter The parameter to check
     * @return Map of errors if any are found and else null.
     */
    public Map<String, ParameterError> getErrorsForParameter(String parameter) {
        for (String key : mapOfErrors.keySet()) {
            if (key.toUpperCase() == parameter.toUpperCase()) {
                return mapOfErrors.get(key);
            }
        }
        return null;
    }
}
