/**
 * @description This service class acts as a wrapper around the static NumberCaseExecutorAction invocable method.
 *              It allows for dependency injection and mocking in test contexts, enabling tests to verify
 *              that the action is called without actually executing it.
 */
public virtual class NumberCaseExecutorActionCaller {
    /**
     * @description Calls the static invocable method in NumberCaseExecutorAction. This method is virtual
     *              so it can be overridden in test classes.
     * @param requests The list of requests to pass to the action.
     */
    public virtual void callAssignNumbers(List<NumberCaseExecutorAction.InputVariables> requests) {
        NumberCaseExecutorAction.assignNumbersToActivationLinesRelatedToCase(requests);
    }
}