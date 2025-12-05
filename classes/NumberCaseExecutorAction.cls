/**
 * The NumberCaseExecutorAction class is an invocable action that assigns numbers to activation lines based on a case.
 * It is used in a flow to process a case and publish an event to handle the assignment.
 * It also performs pre-checks to validate requested numbers and resets transient errors.
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær      14/08/2025      Initial version with documentation.
 *  Kenneth Houkjær      30/08/2025      Added number validation and refactored to use Query framework.
 *
 * @author Kenneth Houkjær
 * @date 14/08/2025
 */
public with sharing class NumberCaseExecutorAction {
    public static NumberSyncService NumberSyncService {
        get {
            if (NumberSyncService == null) {
                NumberSyncService = (NumberSyncService)SingletonFactory.getFactory().getOrRegisterSingleton(NumberSyncService.class);
            }
            return NumberSyncService;
        }
        set; // Allows for dependency injection in tests
    }

    /**
     * @description This method is the main entry point called from a flow. It prepares and triggers the asynchronous
     *              number assignment process for a given case. It first validates any pre-requested mobile numbers
     *              and resets previous errors on activation lines before publishing an event to be handled by the
     *              NumberCaseExecutorHandler.
     * @param inputVariables A list of input variables from the flow, containing the case Id.
     * @return A list of output variables containing the published event and a success flag.
     */
	@InvocableMethod(category='Number' label='Assign Numbers To ActivationLines Related to Case' description='Uses available assignment numbers to set phonenumber on activation lines.')
    public static List<OutputVariables> assignNumbersToActivationLinesRelatedToCase(List<InputVariables> inputVariables) {        
        OutputVariables output = new OutputVariables();
        
        try{
            InputVariables vars = inputVariables.get(0);

            // Synchronize the assignments for the account before any validation.
            // Case k = [SELECT AccountId FROM Case WHERE Id = :vars.caseId];
            // if (k.AccountId != null) {
            //     Account acc = [SELECT Id, CVR__c FROM Account WHERE Id = :k.AccountId];
            //     Logger.logInfo('NumberCaseExecutorAction refreshing numbers');
            //     NumberSyncService.synchronizeAssignmentsForAccount(acc);
            //     Logger.logInfo('NumberCaseExecutorAction done refreshing numbers');
            // }

            // Set parent activations to INPROGRESS to provide immediate feedback.
            setInProgressOnActivations(vars.caseId);

            Logger.logInfo('NumberCaseExecutorAction done with setInProgressOnActivations');

            // Reset any previous, transient errors on activation lines to allow them to be re-processed.
            getAndResetErrorOnActivationLinesNeedingNewNumber(vars.caseId);

            Logger.logInfo('NumberCaseExecutorAction done with getAndResetErrorOnActivationLinesNeedingNewNumber');

            // Before processing, first validate any numbers that have been specifically requested on the activation lines.
            // This prevents errors downstream if the requested number is not valid for the customer.
            handleValidationErrors(ValidateExistenceOfRequestedNumbers(vars.caseId));

            Logger.logInfo('NumberCaseExecutorAction done with ValidateExistenceOfRequestedNumbers');

            // If validation resulted in all lines being in an error state, set parent status to ERROR and stop.
            List<Activation_line__c> linesLeftToProcess = new Query('Activation_line__c')
                .selectFields(new List<String>{'Id'})
                .addConditionEq('activation__r.case__c', vars.caseId)
                .addConditionEq('phone_no_status__c', 'Nyt nummer')
                .addConditionNotEq('Phone_Number_Reservation_Status__c', 'SUCCESS')
                .addConditionNotEq('Phone_Number_Reservation_Status__c', 'ERROR')
                .setLimit(1)
                .run();

            if (linesLeftToProcess.isEmpty()) {
                // If there are no lines left to process, we need to determine if this is because all lines
                // are already in a SUCCESS state, or if they are in an ERROR state (e.g. from validation).
                List<Activation_line__c> allLines = new Query('Activation_line__c')
                    .selectFields(new List<String>{'Id', 'Phone_Number_Reservation_Status__c', 'Activation__c'})
                    .addConditionEq('activation__r.case__c', vars.caseId)
                    .addConditionEq('phone_no_status__c', 'Nyt nummer')
                    .run();

                if (allLines.isEmpty()) {
                    // No relevant lines found, so we can exit.
                    output.isSuccess = true;
                    return new List<OutputVariables>{output};
                }

                Boolean allSuccess = true;
                for (Activation_line__c line : allLines) {
                    if (line.Phone_Number_Reservation_Status__c != 'SUCCESS') {
                        allSuccess = false;
                        break;
                    }
                }

                // This block specifically handles the case where all lines are already SUCCESS.
                if (allSuccess) {
                    Id activationId = allLines[0].Activation__c;

                    // KIRSTINE outcomment this since this in theory is redundant because INPROGRESS is set in the very top
                    // // As per requirement, set parent to INPROGRESS first for visibility.
                    // Activation__c parentActivation = new Activation__c(Id = activationId, Phone_Number_Reservation_Status_Txt__c = 'INPROGRESS');
                    // Logger.logInfo('action setting act to inprogress');
                    // update parentActivation;

                    // Then, set the final status to SUCCESS.
                    //parentActivation = new Activation__c(Id = activationId, Phone_Number_Reservation_Status_Txt__c = 'SUCCESS');
                    //update parentActivation;
                     // Then, enqueue a job to set the final status to SUCCESS in a separate transaction.
                    System.enqueueJob(new NumberUpdActivationStatusQueueable(activationId, 'SUCCESS'));
                    
                    output.isSuccess = true;
                    Logger.emit();
                    return new List<OutputVariables>{output};
                } else {
                    // If not all lines are SUCCESS, it means some are in an ERROR state from validation.
                    // In this case, we set the parent status to ERROR.
                    List<Activation__c> activationsToUpdate = new Query('Activation__c')
                        .selectFields(new List<String>{'Id', 'Phone_Number_Reservation_Status_Txt__c'})
                        .addConditionEq('Case__c', vars.caseId)
                        .run();

                    // KIRSTINE outcomment this for loop and the update, because this won't be detected since in same 
                    // as when the Activation is set to INPROGRESS
                    // for (Activation__c act : activationsToUpdate) {
                    //     Logger.logInfo('action setting act to error');
                    //     act.Phone_Number_Reservation_Status_Txt__c = 'ERROR';
                    // }
                    // update activationsToUpdate;
                    System.enqueueJob(new NumberUpdActivationStatusQueueable(activationsToUpdate.get(0).Id, 'ERROR'));

                    
                    output.isSuccess = true; // Still considered a success from the action's perspective
                    Logger.emit();
                    return new List<OutputVariables>{output};
                }
            }

            // Set all eligible lines to INPROGRESS before starting the async process.
            setInProgressOnEligibleActivationLines(vars.caseId);

            // Prepare the event for the asynchronous handler.
            EventExecutor__e executor = new EventExecutor__e();
            executor.Executor__c = SFConstants.NUMBER_CASE_EXECUTOR_HANDLER;
            
            // Serialize the case Id and retry count as parameters for the handler.
            NumberCaseExecutorHandler.parameters params = new NumberCaseExecutorHandler.parameters();
            params.CaseId = vars.caseId;
            // Default to 0 if not provided.
            params.retryCount = vars.retryCount == null ? 0 : vars.retryCount;
            executor.Parameters__c = JSON.serialize(params);

            Logger.logInfo('NumberCaseExecutorAction.assignNumbersToActivationLinesRelatedToCase: params ' + params);
            Logger.logInfo('NumberCaseExecutorAction.assignNumbersToActivationLinesRelatedToCase: publishing event executor ' + executor);
            
            // Publish the event to the Salesforce event bus.
            EventBus.publish(executor);

            output.publishedEvent = executor;
            output.isSuccess = true;

            Logger.emit();
        }catch(Exception ex){
            Logger.logError(ex);
            Logger.emit();
            throw ex;
        }
        
        return new List<OutputVariables>{output};
    }

    /**
     * @description Validates activation lines where a specific mobile number has been requested.
     *              It checks if the requested number exists in the customer's available number assignments.
     *              If the number does not exist, the activation line is marked with a specific error.
     *              This check is performed only for lines that are requesting a new number ('Nyt nummer')
     *              and are not already in a 'SUCCESS' or 'INPROGRESS' state.
     * @param caseId The Id of the parent Case whose activation lines are to be validated.
     */
    private static Map<Id, String> ValidateExistenceOfRequestedNumbers(Id caseId){
        Map<Id, String> errorsFound = new Map<Id, String>();
        // Find all activation lines for the given case that have a requested mobile number,
        // are for a 'New Number', and are not already processed or in progress.
        List<Activation_line__c> linesToValidate = new Query('Activation_line__c')
            .selectFields(new List<String>{'Id', 'mobile_no__c'})
            .addConditionEq('activation__r.case__c', caseId)
            .addConditionNotNull('mobile_no__c')
            .addConditionEq('phone_no_status__c', 'Nyt nummer')
            .addConditionNotEq('Phone_Number_Reservation_Status__c', 'SUCCESS')
            .run();

        if(linesToValidate.isEmpty()){
            return errorsFound;
        }

        // Collect all the unique mobile numbers that need to be checked.
        Set<String> mobileNumbers = new Set<String>();
        for(Activation_line__c line : linesToValidate){
            mobileNumbers.add(line.mobile_no__c);
        }

        // Query for all Account Phone Number Assignments that match the requested mobile numbers.
        Set<String> existingMobileNumbers = new Set<String>();
        List<Account_Phone_Number_Assignment__c> assignments = new Query('Account_Phone_Number_Assignment__c')
            .selectField('Phone_Number__c')
            .addConditionIn('Phone_Number__c', new List<String>(mobileNumbers))
            .run();
        for(Account_Phone_Number_Assignment__c assignment : assignments){
            existingMobileNumbers.add(assignment.Phone_Number__c);
        }

        // Identify the activation lines where the requested number does not exist.
        for(Activation_line__c line : linesToValidate){
            if(!existingMobileNumbers.contains(line.mobile_no__c)){
                errorsFound.put(line.Id, 'NCEA001');
            }
        }
        return errorsFound;
    }

    /**
     * @description Resets the error status on activation lines that previously failed.
     *              This allows them to be re-processed in the current run. It specifically excludes
     *              lines that failed because the requested mobile number was invalid, as this is
     *              considered a permanent, data-related error that requires manual intervention.
     * @param caseId The Id of the parent Case whose activation lines are to be checked.
     */
     private static void getAndResetErrorOnActivationLinesNeedingNewNumber(Id caseId){
        // Find all activation lines for the case that are in an 'ERROR' or 'ADDED' state.
        List<Activation_line__c> activationLinesWithErrors = new Query('Activation_line__c')
            .selectFields(new List<String>{'Id', 'Activation__c', 'Phone_Number_Reservation_Status__c', 'Phone_Number_Reservation_Error__c'})
            .addConditionEq('activation__r.case__c', caseId)
            .addConditionIn('Phone_Number_Reservation_Status__c', new List<String>{'ERROR', 'ADDED'})
            .run();

        if (activationLinesWithErrors.isEmpty()) {
            Logger.logInfo('NumberCaseExecutorAction found no activationLineWithErrors to reset');
            return;
        }

        // Clear the status on the lines themselves
        for(Activation_line__c line : activationLinesWithErrors){
            line.Phone_Number_Reservation_Status__c = null;
            line.Phone_Number_Reservation_Error__c = '';
        }
        update activationLinesWithErrors;

        Logger.logInfo('NumberCaseExecutorAction updated activationLinesWithErrors');

        // Also clear the error code on the parent Activations
        Set<Id> activationIds = new Set<Id>();
        for (Activation_line__c line : activationLinesWithErrors) {
            activationIds.add(line.Activation__c);
        }

        if (!activationIds.isEmpty()) {
            List<Activation__c> activationsToUpdate = new Query('Activation__c')
                .selectFields(new List<String>{'Id', 'Activation_Line_Error_Code__c', 'Phone_Number_Reservation_Status_Txt__c'})
                .addConditionIn('Id', new List<Id>(activationIds))
                .run();

            for (Activation__c act : activationsToUpdate) {
                act.Activation_Line_Error_Code__c = '';
                act.Phone_Number_Reservation_Status_Txt__c = 'INPROGRESS';
            }
            update activationsToUpdate;
        }

        Logger.logInfo('NumberCaseExecutorAction.getAndResetErrorOnActivationLinesNeedingNewNumber reset ' + activationLinesWithErrors.size() + ' activation lines and their parent activations.');
        Logger.emit();
    }
 
    /**
     * @description Defines the input variables for the Invocable Method.
     */
    public class InputVariables {
        /**
         * @description The ID of the Case to be processed.
         */
        @InvocableVariable
        public Id caseId;

        @InvocableVariable
        public Integer retryCount;
    }

    /**
     * @description Defines the output variables for the Invocable Method.
     */
    public class OutputVariables {
        /**
         * @description The event that was published to the event bus.
         */
        @InvocableVariable
        public EventExecutor__e publishedEvent;
        
        /**
         * @description A boolean flag indicating whether the action was successful in publishing the event.
         */
        @InvocableVariable
        public Boolean isSuccess = false;
    }

    private static void setInProgressOnEligibleActivationLines(Id caseId) {
        List<Activation_line__c> linesToProgress = new Query('Activation_line__c')
            .selectFields(new List<String>{'Id', 'Phone_Number_Reservation_Status__c'})
            .addConditionEq('activation__r.case__c', caseId)
            .addConditionEq('phone_no_status__c', 'Nyt nummer')
            .addConditionNotEq('Phone_Number_Reservation_Status__c', 'SUCCESS')
            .addConditionNotEq('Phone_Number_Reservation_Status__c', 'ERROR')
            .addConditionNotEq('Phone_Number_Reservation_Status__c', 'INPROGRESS')
            .run();

        if (linesToProgress.isEmpty()) {
            return;
        }

        for (Activation_line__c line : linesToProgress) {
            line.Phone_Number_Reservation_Status__c = 'INPROGRESS';
        }

        update linesToProgress;
        Logger.logInfo('NumberCaseExecutorAction.setInProgressOnEligibleActivationLines set ' + linesToProgress.size() + ' lines to INPROGRESS.');
        Logger.emit();
    }

    private static void handleValidationErrors(Map<Id, String> errors) {
        if (errors.isEmpty()) {
            return;
        }

        Map<Id, Set<String>> errorsByActivationId = new Map<Id, Set<String>>();
        List<Activation_line__c> linesToUpdate = new Query('Activation_line__c')
            .selectFields(new List<String>{'Id', 'Activation__c'})
            .addConditionIn('Id', new List<Id>(errors.keySet()))
            .run();

        for (Activation_line__c line : linesToUpdate) {
            line.Phone_Number_Reservation_Status__c = 'ERROR';
            line.Phone_Number_Reservation_Error__c = '[NCEA001] Requested mobile number does not exist in the customer number series, please refresh';

            if (!errorsByActivationId.containsKey(line.Activation__c)) {
                errorsByActivationId.put(line.Activation__c, new Set<String>());
            }
            errorsByActivationId.get(line.Activation__c).add(errors.get(line.Id));
        }
        update linesToUpdate;

        List<Activation__c> activationsToUpdate = new Query('Activation__c')
            .selectFields(new List<String>{'Id', 'Activation_Line_Error_Code__c'})
            .addConditionIn('Id', new List<Id>(errorsByActivationId.keySet()))
            .run();

        for (Activation__c act : activationsToUpdate) {
            Set<String> newCodes = errorsByActivationId.get(act.Id);
            for (String code : newCodes) {
                act.Activation_Line_Error_Code__c = appendErrorCode(act.Activation_Line_Error_Code__c, code);
            }
        }
        update activationsToUpdate;
    }

    private static String appendErrorCode(String existingCodes, String newCode) {
        if (String.isBlank(existingCodes)) {
            return newCode;
        }

        Set<String> codes = new Set<String>(existingCodes.split(','));
        codes.add(newCode);

        return String.join(new List<String>(codes), ',');
    }

    private static void setInProgressOnActivations(Id caseId) {
        // List<Activation__c> activationsToUpdate = new Query('Activation__c')
        //     .selectFields(new List<String>{'Id', 'Phone_Number_Reservation_Status_Txt__c'})
        //     .addConditionEq('Case__c', caseId)
        //     .addConditionNotEq('Phone_Number_Reservation_Status_Txt__c', 'INPROGRESS')
        //     .run();
         List<Activation__c> activationsToUpdate = new Query('Activation__c')
            .selectFields(new List<String>{'Id', 'Phone_Number_Reservation_Status_Txt__c'})
            .addConditionEq('Case__c', caseId)
            .run();


        if (activationsToUpdate.isEmpty()) {
            return;
        }

        for (Activation__c act : activationsToUpdate) {
            act.Phone_Number_Reservation_Status_Txt__c = 'INPROGRESS';
        }
        update activationsToUpdate;

        Logger.logInfo('NumberCaseExecutorAction.setInProgressOnActivations set ' + activationsToUpdate.size() + ' activations to INPROGRESS.');
        Logger.emit();
    }
}