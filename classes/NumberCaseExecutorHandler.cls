/**
 * @description The NumberCaseExecutorHandler class is responsible for handling the assignment of phone numbers to activation lines.
 *              This is done asynchronously via a Platform Event to avoid lock contention on the parent Case record.
 *              The process is batched to handle large volumes of activation lines gracefully.
 *
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær      13/08/2025      Initial version.
 *  Kenneth Houkjær      30/08/2025      Refactored to use Query framework and added detailed documentation.
 *  Kenneth Houkjær      30/08/2025      Updated error handling and record update logic.
 *  Kenneth Houkjær      30/08/2025      Conditional INPROGRESS status update and junction user population.
 *
 * @author Kenneth Houkjær
 * @date 22/08/2025
 */
public with sharing class NumberCaseExecutorHandler implements IEventExecutableHandler, Database.AllowsCallouts {
    public static NumberCaseExecutorActionCaller actionCaller {
        get {
            if (actionCaller == null) {
                actionCaller = new NumberCaseExecutorActionCaller();
            }
            return actionCaller;
        }
        set;
    }

    private final NumberClient numberClient;
    private final DatabaseService databaseService;
    private static final Integer BATCH_SIZE = 10;
    private boolean hasMoreLines = false;

    /**
     * @description Default constructor that initializes the NumberClient and DatabaseService using the SingletonFactory.
     *              This follows the dependency injection pattern to allow for mocking in test contexts.
     */
    public NumberCaseExecutorHandler() {
        this(SingletonFactory.getFactory());
    }

    /**
     * @description Private constructor for dependency injection, used by the default constructor.
     * @param singletonFactory The SingletonFactory instance to use for creating dependencies.
     */
    private NumberCaseExecutorHandler(SingletonFactory singletonFactory) {
        this.numberClient = (NumberClient) singletonFactory.getOrRegisterSingleton(NumberClient.class);
        this.databaseService = (DatabaseService) singletonFactory.getOrRegisterSingleton(DatabaseService.class);
    }

    /**
     * @description Test-visible constructor for dependency injection during testing. This allows for direct
     *              injection of mock services, isolating the handler from external systems and database operations.
     * @param numberClient The mock NumberClient instance to use.
     * @param databaseService The mock DatabaseService instance to use.
     */
    @TestVisible
    private NumberCaseExecutorHandler(NumberClient numberClient, DatabaseService databaseService) {
        this.numberClient = numberClient;
        this.databaseService = databaseService;
    }

    /**
     * @description This is the main execution method called by the event bus framework when a corresponding
     *              EventExecutor__e event is received. It orchestrates the batch processing of number assignments.
     * @param event The platform event that triggered this handler.
     */
    public void execute(EventExecutor__e event) {
        Logger.logInfo('NumberCaseExecutorHandler: ' + String.format('execute( {0} )', new List<Object>{ event }));
        
        // 1. Parse and validate the parameters from the event payload.
        Parameters params = getParameters(event.Parameters__c);
        Id caseId = params.CaseId;
        Logger.logInfo('NumberCaseExecutorHandler.execute: Parsed CaseId: ' + caseId);

        // 2. Identify the next batch of activation lines that need a number assigned.
        LineProcessingInfo processingInfo = getMapOfActivationLineIdToAssignmentId(caseId);
        Logger.logInfo('NumberCaseExecutorHandler.execute: processingInfo.mapOfActivationLineIdToAssignmentId size: ' + processingInfo.mapOfActivationLineIdToAssignmentId.size());
        Logger.logInfo('NumberCaseExecutorHandler.execute: processingInfo.linesToError size: ' + processingInfo.linesToError.size());

        List<Id> activationLineIds = new List<Id>(processingInfo.mapOfActivationLineIdToAssignmentId.keySet());

        if(activationLineIds.isEmpty() && processingInfo.linesToError.isEmpty()) {
            Logger.logInfo('NumberCaseExecutorHandler - No more activation lines needing numbers were found for this case. Updating final status.');
            updateFinalActivationStatus(caseId, params);
            Logger.emit();
            return;
        }

        // 3. Prepare the batch to be processed.
        Integer toSize = BATCH_SIZE > (activationLineIds.size() - 1) ? activationLineIds.size() : BATCH_SIZE;
        Map<Id, String> batchToProcess = new Map<Id, String>();
        for (Integer i = 0; i < toSize && !activationLineIds.isEmpty(); i++) {
            Id activationLineId = activationLineIds.remove(0);
            batchToProcess.put(activationLineId, processingInfo.mapOfActivationLineIdToAssignmentId.get(activationLineId));
        }
        
        Logger.logInfo('NumberCaseExecutorHandler: processing batch ' + batchToProcess);
        Logger.logInfo('NumberCaseExecutorHandler: processing batch size ' + batchToProcess.size());

        // 4. Process the batch.
        Logger.logInfo('NumberCaseExecutorHandler.execute: Calling processBatch.');
        processBatch(batchToProcess, processingInfo.linesToError);

        Logger.logInfo('NumberCaseExecutorHandler: hasmorelines ' + hasMoreLines);
       
        // 5. If there are more lines to process, re-publish the event to handle the next batch.
        if (hasMoreLines) {  
            Logger.logInfo('NumberCaseExecutorHandler.execute: More lines to process, publishing new event.');
            publishExecutor(caseId, params.retryCount);
        } else {
            Logger.logInfo('No more lines, setting activation status');
            updateFinalActivationStatus(caseId, params);
        }

        Logger.emit();
    }

    private void updateFinalActivationStatus(Id caseId, Parameters params) {
        // Check for failed lines to determine if a retry is needed.
        List<Activation_line__c> errorLines = new Query('Activation_line__c')
            .selectFields(new List<String>{'Id'})
            .addConditionEq('Activation__r.Case__c', caseId)
            .addConditionEq('phone_no_status__c', 'Nyt nummer')
            .addConditionEq('Phone_Number_Reservation_Status__c', 'ERROR')
            .setLimit(1)
            .run();

        if (!errorLines.isEmpty()) {
            Integer currentRetryCount = params.retryCount == null ? 0 : params.retryCount;
            if (currentRetryCount < 5) {
                Logger.logInfo('Errors found on case. Initiating retry #' + (currentRetryCount + 1) + ' for CaseId: ' + caseId);
                
                NumberCaseExecutorAction.InputVariables newVars = new NumberCaseExecutorAction.InputVariables();
                newVars.caseId = caseId;
                newVars.retryCount = currentRetryCount + 1;

                List<NumberCaseExecutorAction.InputVariables> requests = new List<NumberCaseExecutorAction.InputVariables>();
                requests.add(newVars);

                // Re-invoke the action to start the process over for the failed lines.
                actionCaller.callAssignNumbers(requests);
                
                // Stop further processing in this thread. The new action will take over.
                return;
            } else {
                Logger.logError('Errors found on case, but max retries reached for CaseId: ' + caseId);
            }
        }

        Logger.logInfo('DEBUG: Entering updateFinalActivationStatus for CaseId: ' + caseId);

        // Step 1: Query all relevant activation lines for the case.
        List<Activation_line__c> linesForStatusCheck = new Query('Activation_line__c')
            .selectFields(new List<String>{'Id', 'Activation__c', 'Phone_Number_Reservation_Status__c'})
            .addConditionEq('Activation__r.Case__c', caseId)
            .addConditionEq('phone_no_status__c', 'Nyt nummer')
            .run();

        Logger.logInfo('DEBUG: Found ' + linesForStatusCheck.size() + ' lines for status check.');
        if (linesForStatusCheck.isEmpty()) {
            Logger.logInfo('DEBUG: No lines found, exiting updateFinalActivationStatus.');
            return; // No lines to process, so no status to update.
        }

        // Step 2: Aggregate status for each parent Activation.
        Map<Id, String> finalStatusByActivationId = new Map<Id, String>();
        Map<Id, List<String>> statusesByActivationId = new Map<Id, List<String>>();

        for (Activation_line__c line : linesForStatusCheck) {
            if (!statusesByActivationId.containsKey(line.Activation__c)) {
                statusesByActivationId.put(line.Activation__c, new List<String>());
            }
            statusesByActivationId.get(line.Activation__c).add(line.Phone_Number_Reservation_Status__c);
        }

        for (Id activationId : statusesByActivationId.keySet()) {
            List<String> statuses = statusesByActivationId.get(activationId);
            String finalStatus = 'SUCCESS'; // Assume success unless proven otherwise.

            if (statuses.contains('ERROR') || statuses.contains('INPROGRESS') || statuses.contains(null)) {
                Logger.logInfo('Setting act. status to error');
                finalStatus = 'ERROR';
            }
            finalStatusByActivationId.put(activationId, finalStatus);
        }
        
        Logger.logInfo('DEBUG: Final statuses to be set: ' + finalStatusByActivationId);

        // Step 3: Update the parent Activation records.
        if (!finalStatusByActivationId.isEmpty()) {
            List<Activation__c> activationsToUpdate = new List<Activation__c>();
            for (Id activationId : finalStatusByActivationId.keySet()) {
                activationsToUpdate.add(new Activation__c(
                    Id = activationId,
                    Phone_Number_Reservation_Status_Txt__c = finalStatusByActivationId.get(activationId)
                ));
            }
            Logger.logInfo('DEBUG: Preparing to update activations: ' + activationsToUpdate);
            databaseService.updateRecords(activationsToUpdate);
            Logger.logInfo('DEBUG: Update call completed.');
        }
    }

    /**
     * @description Processes a single batch of activation lines. For each line, it reserves a phone number
     *              via an external API and updates the corresponding Activation Line and Phone Number Assignment records.
     *              The method handles both success and error scenarios for each line and performs all DML operations
     *              at the end to ensure bulkification. It includes a compensating transaction to un-reserve numbers
     *              if the final DML fails.
     * @param batchActivationLineIdToAssignmentId A map of activation line Ids to their corresponding assignment Ids.
     */
    private void processBatch(Map<Id, String> batchActivationLineIdToAssignmentId, List<Activation_line__c> initialErrorLines) {
        Logger.logInfo('NumberCaseExecutorHandler.processBatch: Starting batch processing.');
        Logger.logInfo('NumberCaseExecutorHandler.processBatch: batch size: ' + batchActivationLineIdToAssignmentId.size());
        Logger.logInfo('NumberCaseExecutorHandler.processBatch: initialErrorLines size: ' + initialErrorLines.size());

        Map<Id, Account_Phone_Number_Assignment__c>  assignmentsMap;
        Map<Id, Activation_Line__c>  activationLineMap;

        try {
            // Fetch all necessary records for the batch in bulk.
            assignmentsMap = getAssignmentsMap(batchActivationLineIdToAssignmentId);
            activationLineMap = getActivationLineMap(batchActivationLineIdToAssignmentId);
            Logger.logInfo('NumberCaseExecutorHandler.processBatch: Fetched ' + assignmentsMap.size() + ' assignments and ' + activationLineMap.size() + ' activation lines.');
        } 
        catch (QueryException ex) {
            Logger.logError('SOQL Error: ' + ex.getMessage());
            throw new NumberCaseExecutorHandlerException('SQOL Error finding assignment: ' + ex.getMessage());
        }
        
        List<Activation_line__c> activationLinesToUpdate = new List<Activation_line__c>();
        List<Account_Phone_Number_Assignment__c> assignmentsToUpdate = new List<Account_Phone_Number_Assignment__c>();
        List<Activation_Assignment_Junction__c> junctionsToInsert = new List<Activation_Assignment_Junction__c>();
        List<Activation_line__c> linesWithError = new List<Activation_line__c>();
        
        // Iterate through each activation line in the batch.
        for(Id activationLineId : batchActivationLineIdToAssignmentId.keySet()){
            Logger.logInfo('NumberCaseExecutorHandler.processBatch: Processing line: ' + activationLineId);
            String assignmentId = batchActivationLineIdToAssignmentId.get(activationLineId);
            
            Activation_line__c activationLine = activationLineMap.get(activationLineId);
            Account_Phone_Number_Assignment__c assignment = assignmentsMap.get(assignmentId);
            Boolean success = false;

            try{
                // Only reserve the number if it hasn't been reserved already.
                if(assignment.CTN_Number_Status__c != SFConstants.ASSIGNED_RESERVED) {
                    Logger.logInfo('NumberCaseExecutorHandler fixed series number being used ' + assignment.Phone_Number__c);
                    Logger.logInfo('NumberCaseExecutorHandler reserving number : ' + assignment.Phone_Number__c);

                    // Make a callout to the external NumberClient to reserve the phone number.
                    NumberClientResponseDTO.NumberDetail numberReservationResponse = numberClient.reserveNumberDetailByMsisdnAndCVR(
                        assignment.Phone_Number__c, 
                        assignment.Account__r.Cvr__c, 
                        assignment.Account_Phone_Number_Series__r?.Product_Type__c);
               
                    // Handle the response from the NumberClient.
                    if (numberReservationResponse.data != null && numberReservationResponse.data.id != null) {
                        activationLine = setMobileNumberOnActivationLine(activationLine, this.stripCountryCodeFromPhoneNumber(numberReservationResponse.data.id));
                        assignment = setSuccessOnAssignment(assignment, activationLine);
                        success = true;
                    } else {
                        // If the response is not as expected, log and record the error.
                        String errorMessage = String.format('[NCEH001] Error reserving number in FOKUS - numberReservationResponse( {0} ) response was not expected.', new List<Object>{ numberReservationResponse });
                        Logger.logInfo(errorMessage);
                        activationLine = setNumberReservationErrorOnActivationLine(activationLine, errorMessage);
                        assignment = setNumberReservationErrorOnAssignment(assignment, errorMessage);
                        linesWithError.add(activationLine);
                    }
                } 
                else { 
                    // If the number is from an open series, it's already considered reserved.
                    Logger.logInfo('NumberCaseExecutorHandler open series number being used ' + assignment.Phone_Number__c);
                    activationLine = setMobileNumberOnActivationLine(activationLine, this.stripCountryCodeFromPhoneNumber(assignment.Phone_Number__c));
                    assignment = setSuccessOnAssignment(assignment, activationLine);
                    success = true;
                }
            } catch (Exception ex) {
                // Handle any other unexpected exceptions, including callout failures.
                String errorMessage = '[NCEH002] The number was not reserved, please rerun reserve numbers - ' + ex.getMessage();
                activationLine = setNumberReservationErrorOnActivationLine(activationLine, errorMessage);
                assignment = setNumberReservationErrorOnAssignment(assignment, errorMessage);
                linesWithError.add(activationLine);
            }
            
            // If the reservation was successful, create a junction record to link the line and the assignment.
             if (success) {
                junctionsToInsert.add(new Activation_Assignment_Junction__c(
                    Activation_line__c = activationLine.Id,
                    Account_Phone_Number_Assignment__c = assignment.Id
                ));
                Logger.logInfo('NumberCaseExecutoerHandler junctionsToInsert ' + junctionsToInsert);
                Logger.logInfo('NumberCaseExecutoerHandler junctionsToInsert.size() ' + junctionsToInsert.size());
            }

            // Add the modified records to lists for a final bulk DML update.
            activationLinesToUpdate.add(activationLine);
            assignmentsToUpdate.add(assignment);
        }

        // Add initial error lines to the list to be updated
        activationLinesToUpdate.addAll(initialErrorLines);
        linesWithError.addAll(initialErrorLines);

        // Sort activation lines to prevent deadlocks when multiple activations are processed simultaneously.
        activationLinesToUpdate.sort(new ActivationLineComparator());
        
        // Collect assignments that were successfully reserved to handle potential rollbacks.
        List<Account_Phone_Number_Assignment__c> successfullyReservedAssignments = new List<Account_Phone_Number_Assignment__c>();
        for (Account_Phone_Number_Assignment__c assignment : assignmentsToUpdate) {
            if (assignment.Phone_Number_Reservation_Status__c == 'SUCCESS') {
                successfullyReservedAssignments.add(assignment);
            }
        }

        try {
            // Perform all DML operations in a single transaction.
            Logger.logInfo('NumberCaseExecutorHandler.processBatch: Preparing to perform DML operations.');
            Logger.logInfo('NumberCaseExecutorHandler.processBatch: activationLinesToUpdate size: ' + activationLinesToUpdate.size());
            Logger.logInfo('NumberCaseExecutorHandler.processBatch: assignmentsToUpdate size: ' + assignmentsToUpdate.size());
            Logger.logInfo('NumberCaseExecutorHandler.processBatch: junctionsToInsert size: ' + junctionsToInsert.size());
            databaseService.allOrNone(true).updateRecords(activationLinesToUpdate);
            databaseService.allOrNone(true).updateRecords(assignmentsToUpdate);
            databaseService.allOrNone(true).insertRecords(junctionsToInsert);
            Logger.logInfo('NumberCaseExecutorHandler.processBatch: DML operations successful. Calling handleProcessingErrors.');
            handleProcessingErrors(linesWithError);
        } catch (DmlException ex) {
            // If DML fails, log a specific error message. Do not re-throw the exception,
            // as this would cause the Platform Event to be retried, which is not the desired behavior.
            // The failed records will not be updated and will be picked up in a subsequent run if necessary.
            String errorMessage = 'A DML Exception occured, the number was not reserved, please rerun reserve numbers - ' + ex.getMessage();
            Logger.logError(errorMessage);

            // If DML fails, perform a compensating transaction to un-reserve the numbers from the external system.
            for (Account_Phone_Number_Assignment__c assignment : successfullyReservedAssignments) {
                if (assignment.Account_Phone_Number_Series__r.Number_Group__c != SFConstants.DEFAULT_OPENSERIES_PRODUCTGROUP &&
                    assignment.Account_Phone_Number_Series__r.Number_Location__c != SFConstants.DEFAULT_OPENSERIES_NUMBERLOCATION &&
                    assignment.Account_Phone_Number_Series__r.Product_Type__c != SFConstants.DEFAULT_OPENSERIES_PRODUCTTYPE) {
                    try {
                        numberClient.unreserveNumberDetailByMsisdn(assignment.Phone_Number__c);
                    } catch (Exception unreserveException) {
                        Logger.logError('[NCEH003] Failed to un-reserve number ' + assignment.Phone_Number__c + ' in compensating transaction: ' + unreserveException.getMessage());
                    }
                }
            }
        }

        logger.emit();
    }

    /**
     * @description Comparator to sort Activation Lines based on their parent Activation Id.
     *              This helps prevent deadlocks during DML operations when processing lines from different activations.
     */
    private class ActivationLineComparator implements Comparator<Activation_line__c> {
        public Integer compare(Activation_line__c al1, Activation_line__c al2) {
            if (al1.Activation__c == al2.Activation__c) {
                return 0;
            }
            if (al1.Activation__c > al2.Activation__c) {
                return 1;
            }
            return -1;
        }
    }

    /**
     * @description Utility method to strip the Danish country code (+45) from a phone number.
     * @param phoneNumber The phone number to strip.
     * @return The phone number without the country code.
     */
    private String stripCountryCodeFromPhoneNumber(string phoneNumber){
        if(phoneNumber != null && phoneNumber.length() == 10){
            return phoneNumber.substring(2, phoneNumber.length());
        }
        return phoneNumber;  
    } 
    
    /**
     * @description Helper method to populate an Activation Line with error details.
     * @param activationLine The Activation Line to update.
     * @param errorMessage The error message to set.
     * @return The updated Activation Line record.
     */
    private Activation_line__c setNumberReservationErrorOnActivationLine(Activation_line__c activationLine, String errorMessage) {
        activationLine.Phone_Number_Reservation_Status__c = 'ERROR';
        activationLine.Phone_Number_Reservation_Error__c = errorMessage;
        activationLine.Mobile_No__c = null;
        return activationLine;
    }

    /**
     * @description Helper method to populate an Account Phone Number Assignment with error details.
     * @param assignment The Assignment to update.
     * @param errorMessage The error message to set.
     * @return The updated Assignment record.
     */
    private Account_Phone_Number_Assignment__c setNumberReservationErrorOnAssignment(Account_Phone_Number_Assignment__c assignment, String errorMessage) {
        assignment.Phone_Number_Reservation_Status__c = 'ERROR';
        assignment.Phone_Number_Reservation_Error__c = errorMessage;
        return assignment;
    }
    
    /**
     * @description Helper method to populate an Activation Line with success details.
     * @param activationLine The Activation Line to update.
     * @param phoneNumber The phone number that was successfully assigned.
     * @return The updated Activation Line record.
     */
    private Activation_line__c setMobileNumberOnActivationLine(Activation_line__c activationLine, String phoneNumber) {
        activationLine.Phone_Number_Reservation_Status__c = 'SUCCESS';
        activationLine.Phone_Number_Reservation_Error__c = null;
        activationLine.Mobile_No__c = phoneNumber;
        return activationLine;
    }

    /**
     * @description Helper method to populate an Account Phone Number Assignment with success details.
     *              This method now only updates the reservation status and error fields as requested.
     * @param assignment The Assignment to update.
     * @param activationLine The Activation Line that the number was assigned to.
     * @return The updated Assignment record.
     */
    @TestVisible
    private Account_Phone_Number_Assignment__c setSuccessOnAssignment(Account_Phone_Number_Assignment__c assignment, Activation_Line__c activationLine) {
        if (assignment == null) {
            return null;
        }
        assignment.Phone_Number_Reservation_Status__c = 'SUCCESS';
        assignment.Phone_Number_Reservation_Error__c = null;
        assignment.CTN_Number_Status__c = SFConstants.ASSIGNED_RESERVED;
        return assignment;
    }
    
    /**
     * @description Fetches and returns a map of Account Phone Number Assignments for the given batch.
     * @param mapOfActivationLineIdToAssignementId A map containing the assignment Ids to fetch.
     * @return A map of Assignment Id to the corresponding Account_Phone_Number_Assignment__c record.
     */
    private Map<Id, Account_Phone_Number_Assignment__c> getAssignmentsMap(Map<Id, String> mapOfActivationLineIdToAssignementId) {
        List<String> assignmentIds = mapOfActivationLineIdToAssignementId.values();
        List<Account_Phone_Number_Assignment__c> assignments = new Query('Account_Phone_Number_Assignment__c')
            .selectFields(new List<String>{
                'Id',
                'Account__c',
                'Account_Phone_Number_Series__c',
                'Phone_Number__c',
                'Phone_Number_Reservation_Status__c',
                'Phone_Number_Reservation_Error__c',
                'CTN_Number_Status__c',
                'Account__r.cvr__c',
                'Account_Phone_Number_Series__r.Product_Type__c',
                'Account_Phone_Number_Series__r.Number_Group__c',
                'Account_Phone_Number_Series__r.Number_Location__c',
                'Activation_Line__c'
            })
            .addConditionIn('Id', assignmentIds)
            .run();
        return new Map<Id, Account_Phone_Number_Assignment__c>(assignments);
    }

    /**
     * @description Fetches and returns a map of Activation Lines for the given batch.
     * @param mapOfActivationLineIdToAssignementId A map containing the activation line Ids to fetch.
     * @return A map of Activation Line Id to the corresponding Activation_Line__c record.
     */
    private Map<Id, Activation_Line__c> getActivationLineMap(Map<Id, String> mapOfActivationLineIdToAssignementId) {
        Set<Id> activationLineIds = mapOfActivationLineIdToAssignementId.keySet();
        List<Activation_Line__c> activationLines = new Query('Activation_Line__c')
            .selectFields(new List<String>{
                'Id',
                'first_Name__c',
                'last_Name__c',
                'email__c',
                'Phone_Number_Reservation_Status__c',
                'Phone_Number_Reservation_Error__c',
                'Mobile_No__c',
                'Activation__c'
            })
            .addConditionIn('Id', new List<Id>(activationLineIds))
            .run();
        return new Map<Id, Activation_Line__c>(activationLines);
    }

    /**
     * @description Identifies the next batch of activation lines that require a number and pairs them
     *              with available phone number assignments. This method now checks for available assignments
     *              before locking the activation lines with an 'INPROGRESS' status.
     * @param caseId The Id of the parent Case.
     * @return A map where the key is the Activation Line Id and the value is the corresponding Account Phone Number Assignment Id.
     */
    private LineProcessingInfo getMapOfActivationLineIdToAssignmentId(Id caseId) {
        Logger.logInfo('NumberCaseExecutorHandler.getMapOfActivationLineIdToAssignmentId: Starting for CaseId: ' + caseId);
        LineProcessingInfo processingInfo = new LineProcessingInfo();

        // 1. Get the next set of activation lines that need a number.
        List<Activation_line__c> linesNeedingNumbers = getActivationLinesNeedingNewNumber(caseId, BATCH_SIZE);
        Logger.logInfo('NumberCaseExecutorHandler.getMapOfActivationLineIdToAssignmentId: Found ' + linesNeedingNumbers.size() + ' lines needing numbers.');

        if (linesNeedingNumbers.isEmpty()) {
            Logger.logInfo('NumberCaseExecutorHandler.getMapOfActivationLineIdToAssignmentId: No lines needing numbers, returning empty info.');
            return processingInfo;
        }

        // 2. Determine if there are more lines to process in a subsequent batch.
        hasMoreLines = linesNeedingNumbers.size() > BATCH_SIZE;
        Logger.logInfo('NumberCaseExecutorHandler.getMapOfActivationLineIdToAssignmentId: hasMoreLines: ' + hasMoreLines);
        if (hasMoreLines) {
            linesNeedingNumbers.remove(linesNeedingNumbers.size() - 1);
        }
        Integer toSize = linesNeedingNumbers.size();

        // 3. Collect explicitly requested phone numbers from the activation lines.
        List<String> requestedNumbers = new List<String>();
        for (Activation_line__c line : linesNeedingNumbers) {
            if (String.isNotBlank(line.mobile_no__c)) {
                requestedNumbers.add(line.mobile_no__c);
            }
        }

        // 4. Get available phone numbers from the service.
        Id activationId = linesNeedingNumbers.get(0).Activation__r.Id;
        Map<String, Account_Phone_Number_Assignment__c> availableAssignmentsMap = AccountPhoneNumberAssignmentService.getUnusedAssignmentsForActivation(activationId, toSize, requestedNumbers);

        // 5. Separate filler assignments.
        List<Account_Phone_Number_Assignment__c> fillerAssignments = new List<Account_Phone_Number_Assignment__c>();
        Set<String> requestedNumbersSet = new Set<String>(requestedNumbers);
        for (String phoneNumber : availableAssignmentsMap.keySet()) {
            if (!requestedNumbersSet.contains(phoneNumber)) {
                fillerAssignments.add(availableAssignmentsMap.get(phoneNumber));
            }
        }

        // 6. Pair activation lines with assignments.
        Logger.logInfo('NumberCaseExecutorHandler.getMapOfActivationLineIdToAssignmentId: Pairing ' + linesNeedingNumbers.size() + ' lines with assignments.');
        for (Activation_line__c line : linesNeedingNumbers) {
            Account_Phone_Number_Assignment__c assignedNumber = null;

            if (String.isNotBlank(line.mobile_no__c) && availableAssignmentsMap.containsKey(line.mobile_no__c)) {
                assignedNumber = availableAssignmentsMap.get(line.mobile_no__c);
                Logger.logInfo('NumberCaseExecutorHandler.getMapOfActivationLineIdToAssignmentId: Matched requested number for line ' + line.Id);
            } else if (!fillerAssignments.isEmpty()) {
                assignedNumber = fillerAssignments.remove(0);
                Logger.logInfo('NumberCaseExecutorHandler.getMapOfActivationLineIdToAssignmentId: Used a filler number for line ' + line.Id);
            }

            if (assignedNumber != null) {
                line.Phone_Number_Reservation_Status__c = SFConstants.INPROGRESS; // Set in memory
                processingInfo.mapOfActivationLineIdToAssignmentId.put(line.Id, assignedNumber.Id);
            } else {
                Logger.logInfo('NumberCaseExecutorHandler.getMapOfActivationLineIdToAssignmentId: No assignment found for line ' + line.Id + '. Marking for error.');
                processingInfo.linesToError.add(setNumberReservationErrorOnActivationLine(line, '[NCEH004] Not enough available numbers'));
            }
        }

        Logger.logInfo('NumberCaseExecutorHandler.getMapOfActivationLineIdToAssignmentId: Finished pairing. Returning processingInfo.');
        return processingInfo;
    }

    /**
     * @description Retrieves a list of activation lines that need a new phone number.
     *              It filters for lines that are requesting a 'New Number', do not have a mobile number yet,
     *              and are not already in a terminal or in-progress state.
     * @param caseId The Id of the parent Case.
     * @param numberOfLinesToRetrieve The maximum number of lines to retrieve (the batch size).
     * @return A list of Activation_Line__c records.
     */
    private List<Activation_line__c> getActivationLinesNeedingNewNumber(Id caseId, Integer numberOfLinesToRetrieve){
        List<String> fieldsToQuery = new List<String>{
            'Id', 'Activation__r.Id', 'first_Name__c', 'last_Name__c', 'email__c', 'Mobile_no__c'
        };
       
        // Query for activation lines that are ready to be processed.
        // We query for BATCH_SIZE + 1 to determine if there are more records to process in a subsequent batch.
        return new Query('Activation_line__c')
            .selectFields(fieldsToQuery)
            .addConditionEq('Activation__r.Case__c', caseId)
            .addConditionEq('phone_no_status__c', 'Nyt nummer')    
            .addConditionNotEq('Phone_Number_Reservation_Status__c', 'SUCCESS')
            .addConditionNotEq('Phone_Number_Reservation_Status__c', 'ERROR')
            .setLimit(numberOfLinesToRetrieve + 1)
            .run();
    }

    /**
     * @description Publishes a new EventExecutor__e event to continue processing in a new transaction.
     *              This is used to handle subsequent batches of activation lines.
     * @param caseId The Id of the Case to be processed in the next transaction.
     */
    private void publishExecutor(Id caseId, Integer retryCount){
        EventExecutor__e executor = new EventExecutor__e();
        
        executor.Executor__c = SFConstants.NUMBER_CASE_EXECUTOR_HANDLER;
                
        NumberCaseExecutorHandler.parameters params = new NumberCaseExecutorHandler.parameters();
        params.CaseId = caseId;
        params.retryCount = retryCount;
        executor.Parameters__c = JSON.serialize(params);
        EventBus.publish(executor);
    }

    /**
     * @description Parses and validates the JSON parameters from the event payload.
     * @param parameters The JSON string to parse.
     * @return A populated Parameters object.
     * @throws NumberCaseExecutorHandlerException if the parameters are null or invalid.
     */
    @testvisible
    private Parameters getParameters(String parameters) {
        Logger.logInfo('NumberCaseExecutorHandler : parameters ' + String.format('parseParameters( {0} )', new List<Object>{ parameters }));

        if (parameters == null) {
            throw new NumberCaseExecutorHandlerException('parameters cannot be null.');
        }
        
        try{
            Parameters params = (Parameters) System.JSON.deserialize(parameters, NumberCaseExecutorHandler.Parameters.class);

            if (params.CaseId == null)  {
                throw new NumberCaseExecutorHandlerException(
                    'CaseId cannot be null'
                );
            } 
            
            return params;
        }catch(Exception ex){
            Logger.logInfo(ex);
            throw new NumberCaseExecutorHandlerException('Failed to parse parameters: ' + ex.getMessage());
        }
    }
    
    private void handleProcessingErrors(List<Activation_line__c> linesWithError) {
        if (linesWithError.isEmpty()) {
            return;
        }

        Map<Id, Set<String>> errorsByActivationId = new Map<Id, Set<String>>();
        Pattern errorCodePattern = Pattern.compile('\\[(NCE[A-Z]\\d{3})\\]');

        for (Activation_line__c line : linesWithError) {
            if (String.isNotBlank(line.Phone_Number_Reservation_Error__c)) {
                Matcher m = errorCodePattern.matcher(line.Phone_Number_Reservation_Error__c);
                if (m.find()) {
                    String errorCode = m.group(1);
                    if (!errorsByActivationId.containsKey(line.Activation__c)) {
                        errorsByActivationId.put(line.Activation__c, new Set<String>());
                    }
                    errorsByActivationId.get(line.Activation__c).add(errorCode);
                }
            }
        }

        if (errorsByActivationId.isEmpty()) {
            return;
        }

        List<Activation__c> activationsToUpdate = new Query('Activation__c')
            .selectFields(new List<String>{'Id', 'Activation_Line_Error_Code__c', 'Phone_Number_Reservation_Status_Txt__c'})
            .addConditionIn('Id', new List<Id>(errorsByActivationId.keySet()))
            .run();

        for (Activation__c act : activationsToUpdate) {
            Set<String> newCodes = errorsByActivationId.get(act.Id);
            if (newCodes != null) {
                for (String code : newCodes) {
                    act.Activation_Line_Error_Code__c = appendErrorCode(act.Activation_Line_Error_Code__c, code);
                }
            }
        }
        databaseService.updateRecords(activationsToUpdate);
    }

    private static String appendErrorCode(String existingCodes, String newCode) {
        if (String.isBlank(existingCodes)) {
            return newCode;
        }

        Set<String> codes = new Set<String>(existingCodes.split(','));
        codes.add(newCode);

        return String.join(new List<String>(codes), ',');
    }

    /**
     * @description Custom exception for the NumberCaseExecutorHandler class to provide specific error handling.
     */
    public class NumberCaseExecutorHandlerException extends Exception {}
    
    /**
     * @description Inner class to define the structure of the parameters expected in the event payload.
     */
    public class Parameters {
        public Id CaseId;
        public Integer retryCount;
    }

    /**
     * @description A wrapper class to hold the information about lines to be processed and lines that have initial errors.
     */
    private class LineProcessingInfo {
        public Map<Id, Id> mapOfActivationLineIdToAssignmentId;
        public List<Activation_line__c> linesToError;

        public LineProcessingInfo() {
            this.mapOfActivationLineIdToAssignmentId = new Map<Id, Id>();
            this.linesToError = new List<Activation_line__c>();
        }
    }
}