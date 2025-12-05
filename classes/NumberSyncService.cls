/**
 * The NumberSyncService is responsible for synchronizing Fokus phone numbers with Salesforce.
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær         27/07/2025      Initial version
 *
 * @author Kenneth Houkjær
 * @date 27/07/2025
 */
public virtual class NumberSyncService {

    private NumberClient numberClient;
    private Set<String> openSeriesKeys;
 
    /**
     * @description Default constructor that initializes the NumberClient using the SingletonFactory.
     */
    public NumberSyncService() {
        this(SingletonFactory.getFactory());
        this.openSeriesKeys = new Set<String>();
    }

    /**
     * @description Private constructor for dependency injection.
     * @param singletonFactory The SingletonFactory instance to use for creating dependencies.
     */
    private NumberSyncService(SingletonFactory singletonFactory) {
        this.numberClient = (NumberClient) singletonFactory.getOrRegisterSingleton(
            NumberClient.class
        );
        this.openSeriesKeys = new Set<String>();
    }

    /**
     * @description Test-visible constructor for dependency injection during testing.
     * @param mockNumberClient The mock NumberClient instance to use.
     */
    @TestVisible
    private NumberSyncService(NumberClient mockNumberClient) {
        this.numberClient = mockNumberClient;
        this.openSeriesKeys = new Set<String>();
    }

    /**
     * @description Inner class to hold remote assignment data along with its parent Series Id.
     */
    public class RemoteAssignmentWrapper {
        @TestVisible public NumberClientResponseDTO.NumberData numberData;
        @TestVisible public Id parentSeriesId;

        /**
         * @description Constructor for the RemoteAssignmentWrapper class.
         * @param data The NumberClientResponseDTO.NumberData object.
         * @param seriesId The ID of the parent series.
         */
        public RemoteAssignmentWrapper(NumberClientResponseDTO.NumberData data, Id seriesId) {
            this.numberData = data;
            this.parentSeriesId = seriesId;
        }
    }

    /**
     * @description Wrapper method for the static call to make it mockable in tests.
     * @param params The parameters for the getNumberDetails call.
     * @return The response from the getNumberDetails call.
     */
    @TestVisible
    protected virtual NumberClientResponseDTO.NumberDetails callGetNumberDetails(NumberClientRequestDTO.NumberDetails params) {
        try{
            return numberClient.getNumberDetails(params);
        }
        catch(Exception e){
            Logger.logError(e);
        }

        return null;
    }

    /**
     * @description Method to get Account Phone Number Series records. Made virtual for potential test mocking.
     * @param acc The account to get the phone number series for.
     * @return A list of Account_Phone_Number_Series__c records.
     */
    @TestVisible
    protected virtual List<Account_Phone_Number_Series__c> getAllAccountPhoneNumberSeries(Account acc) {
       return AccountPhoneNumberSeriesSelector.getAllAccountPhoneNumberSeries(acc);
    }

    /**
     * @description Method to get OpenPhoneNumberSeries metadata. Made virtual for potential test mocking.
     * @return A list of OpenPhoneNumberSeries__mdt records.
     */
    @TestVisible
    protected virtual List<OpenPhoneNumberSeries__mdt> getOpenPhoneNumberSeriesMetadata() {
        return MetadataSelector.getOpenPhoneNumberSeries();
    }

    /**
     * @description Synchronizes assignments for a given account.
     * @param acc The account to synchronize assignments for.
     */
    public virtual void synchronizeAssignmentsForAccount(Account acc) {
        Map<String, Account_Phone_Number_Assignment__c> localAssignments = getLocalAssignments(acc);
        Map<String, RemoteAssignmentWrapper> remoteAssignments = getRemoteAssignments(acc); // Changed return type
        compareAndPrepareDML(localAssignments, remoteAssignments, acc); // Argument type changed
        
        Logger.emit();
    }
    
     /**
      * @description Synchronizes assignments for all accounts.
      */
    public void synchronizeAllAssignments() {
        Map<String, Account_Phone_Number_Assignment__c> localAssignments = getLocalAssignments(null);
        Map<String, RemoteAssignmentWrapper> remoteAssignments = getRemoteAssignments(null); // Changed return type
        compareAndPrepareDML(localAssignments, remoteAssignments, null); // Argument type changed
        
        Logger.emit();
    }

    /**
     * @description Gets the local assignments for a given account that are in use.
     * An assignment is considered "in use" if it is linked to an Activation via an Activation_Assignment_Junction__c record.
     * @param acc The account to get the local assignments for.
     * @return A map of local assignments, keyed by phone number.
     */
    private Map<String, Account_Phone_Number_Assignment__c> getLocalAssignments(Account acc) {
        List<Account_Phone_Number_Assignment__c> listOfAccountPhoneNumberAssignments = AccountPhoneNumberAssignmentSelector.getAssignments(acc);
        
        Map<String, Account_Phone_Number_Assignment__c> localAssignmentsMap = new Map<String, Account_Phone_Number_Assignment__c>();

        String logMessage = 'Found ' + listOfAccountPhoneNumberAssignments.size() + ' local assignments';
        if (acc != null) {
            logMessage += ' for account: ' + acc.Id;
        }
        Logger.logInfo(logMessage);

        for (Account_Phone_Number_Assignment__c assignment : listOfAccountPhoneNumberAssignments) {
            if (String.isNotBlank(assignment.Phone_Number__c)) {
                String phoneNumber = assignment.Phone_Number__c;
                if (phoneNumber.length() == 8) {
                    phoneNumber = '45' + phoneNumber;
                    Logger.logInfo('Local phone number ' + assignment.Phone_Number__c + ' has 8 digits, prepending with 45 to get ' + phoneNumber);
                }
                localAssignmentsMap.put(phoneNumber.toLowerCase(), assignment); // Key by lowercase phone number for case-insensitivity
                Logger.logInfo('Found new local number: ' + phoneNumber);
            }
        }
        return localAssignmentsMap;
    }

    /**
     * @description Gets the remote assignments for a given account.
     * @param acc The account to get the remote assignments for.
     * @return A map of remote assignments, keyed by phone number.
     */
    private Map<String, RemoteAssignmentWrapper> getRemoteAssignments(Account acc) {
        Map<String, RemoteAssignmentWrapper> remoteAssignmentsMap = new Map<String, RemoteAssignmentWrapper>();

        // 1. Get all Account Phone Number Series
        List<Account_Phone_Number_Series__c> allSeriesRecords = getAllAccountPhoneNumberSeries(acc);
        if (allSeriesRecords.isEmpty()) {
            Logger.logInfo('No Account_Phone_Number_Series__c records found. No remote assignments to fetch.');
            return remoteAssignmentsMap;
        }

        // 2. Get OpenPhoneNumberSeries metadata
        for (OpenPhoneNumberSeries__mdt opsMeta : getOpenPhoneNumberSeriesMetadata()) {
            // Create a unique key for comparison, e.g., "P_EKC"
             if (String.isNotBlank(opsMeta.number_group__c) && String.isNotBlank(opsMeta.number_location__c)) {
                this.openSeriesKeys.add(opsMeta.number_group__c.toUpperCase() + '_' + opsMeta.number_location__c.toUpperCase());
            }
        }
        Logger.logInfo('Open Series Keys from CMD: ' + this.openSeriesKeys);

        List<String> defaultStatuses = new List<String>{
            SFConstants.ASSIGNED_AVAILABLE,
            SFConstants.ASSIGNED_RESERVED,
            SFConstants.ASSIGNED_INUSE,
            SFConstants.ASSIGNED_SUSPENDED};

        List<String> openSeriesStatuses = new List<String>{SFConstants.ASSIGNED_RESERVED};

        // 3. Iterate through each Account_Phone_Number_Series__c record
        for (Account_Phone_Number_Series__c seriesRecord : allSeriesRecords) {
            String currentSeriesKey = '';
            if (String.isNotBlank(seriesRecord.Number_Group__c) && String.isNotBlank(seriesRecord.Number_Location__c)) {
                currentSeriesKey = seriesRecord.Number_Group__c.toUpperCase() + '_' + seriesRecord.Number_Location__c.toUpperCase();
            }

            boolean isSeriesOpen = openSeriesKeys.contains(currentSeriesKey);
            List<String> statusesToQuery = isSeriesOpen ? openSeriesStatuses : defaultStatuses;

            Logger.logInfo('Processing Series: ' + seriesRecord.Name +
                         ', Group: ' + seriesRecord.Number_Group__c +
                         ', Location: ' + seriesRecord.Number_Location__c +
                         ', IsOpen: ' + isSeriesOpen +
                         ', Statuses: ' + statusesToQuery);

            for (String status : statusesToQuery) {
                NumberClientRequestDTO.NumberDetails params = new NumberClientRequestDTO.NumberDetails();
                params.numberGroup = seriesRecord.Number_Group__c;
                params.numberLocation = seriesRecord.Number_Location__c;
                params.cvr = seriesRecord.CVR__c;
                logger.logInfo('seriesRecord.CVR__c in params is ' + seriesRecord.CVR__c);
                params.numberPattern = seriesRecord.Number_Pattern__c;

                params.numberStatus = status;
                
                Logger.logInfo('Calling getNumberDetails with ' +  params);
                NumberClientResponseDTO.NumberDetails details = callGetNumberDetails(params);
                Logger.logInfo('getNumberDetails returned ' + details);

                if (details != null && details.data != null) {
                    for (NumberClientResponseDTO.NumberData numberData : details.data) {
                        if (String.isNotBlank(numberData.Id)) {
                            Logger.logInfo('Found new remote number: ' + numberData.Id);
                            String remotePhoneNumber = numberData.Id;
                            if (remotePhoneNumber.length() == 8) {
                                remotePhoneNumber = '45' + remotePhoneNumber;
                                Logger.logInfo('Remote phone number ' + numberData.Id + ' has 8 digits, prepending with 45 to get ' + remotePhoneNumber);
                            }
                            // Key by lowercase phone number for case-insensitivity
                            remoteAssignmentsMap.put(
                                remotePhoneNumber.toLowerCase(),
                                new RemoteAssignmentWrapper(numberData, seriesRecord.Id)
                            );

                            Logger.logInfo('Adding remote assignment ' + numberData.Id + ' to map');
                            Logger.logInfo('seriesRecord.Id = ' + seriesRecord.Id);
                            Logger.logInfo('numberData ' + numberData);
                        }
                    }
                } else if (details != null && details.error != null) {
                    Logger.logInfo('Error fetching remote numbers for Series Name ' + seriesRecord.Name +
                                 ' (Group: ' + seriesRecord.Number_Group__c +
                                 ', Location: ' + seriesRecord.Number_Location__c +
                                 ') with status ' + status + ': ' + details.error.message);
                }
            }
        }
        return remoteAssignmentsMap;
    }

    /**
     * @description Compares the local and remote assignments and prepares the DML operations.
     * @param localAssignments A map of local assignments, keyed by phone number.
     * @param remoteAssignments A map of remote assignments, keyed by phone number.
     */
    private void compareAndPrepareDML(
        Map<String, Account_Phone_Number_Assignment__c> localAssignments,
        Map<String, RemoteAssignmentWrapper> remoteAssignments,
        Account acc
    ) {
        List<Account_Phone_Number_Assignment__c> toCreate = new List<Account_Phone_Number_Assignment__c>();
        List<Account_Phone_Number_Assignment__c> toUpdate = new List<Account_Phone_Number_Assignment__c>();
        List<Account_Phone_Number_Assignment__c> toDelete = new List<Account_Phone_Number_Assignment__c>();

        Set<String> localKeys = localAssignments.keySet();
        Set<String> remoteKeys = remoteAssignments.keySet();

        Set<String> keysToCreate = new Set<String>(remoteKeys);
        keysToCreate.removeAll(localKeys);

        Set<String> keysToUpdate = new Set<String>(remoteKeys);
        keysToUpdate.retainAll(localKeys);

        Set<String> keysToDelete = new Set<String>(localKeys);
        keysToDelete.removeAll(remoteKeys);

        Logger.logInfo('Assignments to create: ' + keysToCreate.size());
        Logger.logInfo('Assignments to update: ' + keysToUpdate.size());
        Logger.logInfo('Assignments to delete: ' + keysToDelete.size());

        // Before creating, check if any of these phone numbers already exist in the database
        if (!keysToCreate.isEmpty()) {
            Set<String> phoneNumbersToCreate = new Set<String>();
            for (String key : keysToCreate) {
                phoneNumbersToCreate.add(remoteAssignments.get(key).numberData.phoneNumber);
            }

            List<Account_Phone_Number_Assignment__c> existingAssignments = [
                SELECT Phone_Number__c FROM Account_Phone_Number_Assignment__c WHERE Phone_Number__c IN :phoneNumbersToCreate
            ];

            Set<String> existingPhoneNumbers = new Set<String>();
            for (Account_Phone_Number_Assignment__c existingAssignment : existingAssignments) {
                existingPhoneNumbers.add(existingAssignment.Phone_Number__c.toLowerCase());
            }

            Set<String> keysToCreateFiltered = new Set<String>();
            for (String key : keysToCreate) {
                String phoneNumber = remoteAssignments.get(key).numberData.phoneNumber.toLowerCase();
                if (existingPhoneNumbers.contains(phoneNumber)) {
                    Logger.logError('NumberSyncService', 'Attempted to create a duplicate phone number assignment for ' + phoneNumber + '. This number already exists in the system.');
                } else {
                    keysToCreateFiltered.add(key);
                }
            }
            keysToCreate = keysToCreateFiltered;
        }


        // Iterate through remote assignments to find new records
        for (String remoteKey : keysToCreate) {
            RemoteAssignmentWrapper wrapper = remoteAssignments.get(remoteKey);
            NumberClientResponseDTO.NumberData remoteData = wrapper.numberData;
            Id parentSeriesIdForRemote = wrapper.parentSeriesId;

            Account_Phone_Number_Assignment__c newAssignment = new Account_Phone_Number_Assignment__c();

            newAssignment.Phone_Number__c = remoteData.phoneNumber; // Store with original casing
            newAssignment.CTN_Number_Status__c = remoteData.numberStatus;
            newAssignment.Account_Phone_Number_Series__c = parentSeriesIdForRemote; // Set Master-Detail relationship
            newAssignment.Phone_Number_Reservation_Status__c = 'SUCCESS';

            if(acc != null) {
                newAssignment.Account__c = acc.Id;
            }
            
            toCreate.add(newAssignment);
            Logger.logInfo('Queued for creation: Phone=' + remoteData.phoneNumber + ', Status=' + remoteData.numberStatus + ', SeriesId=' + parentSeriesIdForRemote);
        }

        // Iterate through existing assignments to check for updates
        for (String key : keysToUpdate) {
            RemoteAssignmentWrapper wrapper = remoteAssignments.get(key);
            NumberClientResponseDTO.NumberData remoteData = wrapper.numberData;
            Account_Phone_Number_Assignment__c localRecord = localAssignments.get(key);
            
            boolean changed = false;

            // If the local assignment had an error, clear it and set status to success
            if (localRecord.Phone_Number_Reservation_Error__c != null) {
                localRecord.Phone_Number_Reservation_Error__c = null;
                localRecord.Phone_Number_Reservation_Status__c = 'SUCCESS';
                changed = true;
            }

            if (localRecord.CTN_Number_Status__c != remoteData.numberStatus) {
                localRecord.CTN_Number_Status__c = remoteData.numberStatus;
                changed = true;
            }

            if (changed) {
                toUpdate.add(localRecord);
                Logger.logInfo('Queued for update: Phone=' + localRecord.Phone_Number__c);
            }
        }

        // Iterate through local assignments to find records for deletion
        if (!keysToDelete.isEmpty()) {
            Set<Id> assignmentIdsToCheck = new Set<Id>();
            for (String key : keysToDelete) {
                assignmentIdsToCheck.add(localAssignments.get(key).Id);
            }

            List<Activation_Assignment_Junction__c> inUseJunctions = ActivationAssignmentJunctionSelector.getByAssignmentIds(assignmentIdsToCheck);
            Set<Id> inUseAssignmentIds = new Set<Id>();
            for (Activation_Assignment_Junction__c junction : inUseJunctions) {
                inUseAssignmentIds.add(junction.Account_Phone_Number_Assignment__c);
            }

            for (String localKey : keysToDelete) {
                Account_Phone_Number_Assignment__c assignmentToDelete = localAssignments.get(localKey);

                boolean isOpenSeriesReserved = false;
                if (assignmentToDelete.Account_Phone_Number_Series__c != null &&
                    assignmentToDelete.Account_Phone_Number_Series__r.Number_Group__c != null &&
                    assignmentToDelete.Account_Phone_Number_Series__r.Number_Location__c != null) {
                    
                    String seriesKey = assignmentToDelete.Account_Phone_Number_Series__r.Number_Group__c.toUpperCase() + '_' +
                                       assignmentToDelete.Account_Phone_Number_Series__r.Number_Location__c.toUpperCase();

                    if (this.openSeriesKeys.contains(seriesKey) && assignmentToDelete.CTN_Number_Status__c == 'AR') {
                        isOpenSeriesReserved = true;
                    }
                }
                
                boolean isInUse = inUseAssignmentIds.contains(assignmentToDelete.Id);

                if (isInUse) {
                    // New requirement: set an error
                    assignmentToDelete.Phone_Number_Reservation_Error__c = '[NSS001] Phone number is assigned to line but does not exist in the customer list of numbers';
                    toUpdate.add(assignmentToDelete);
                    Logger.logError('NumberSyncService', 'Assignment ' + assignmentToDelete.Phone_Number__c + ' is in use but not found remotely. Setting error.');
                }
                else if (isOpenSeriesReserved) {
                    // This rule remains: just preserve it, do nothing.
                    Logger.logInfo('Assignment ' + assignmentToDelete.Phone_Number__c + ' is an open series AR assignment and is preserved from deletion.');
                }
                else {
                    // Not in use and not open series AR, so delete it.
                    toDelete.add(assignmentToDelete);
                    Logger.logInfo('Queued for deletion: Phone=' + assignmentToDelete.Phone_Number__c + ', Id=' + assignmentToDelete.Id);
                }
            }
        }

        executeDMLOperations(toCreate, toUpdate, toDelete);
    }

    /**
     * @description Executes the DML operations.
     * @param toCreate A list of records to create.
     * @param toUpdate A list of records to update.
     * @param toDelete A list of records to delete.
     */
    private void executeDMLOperations(
        List<Account_Phone_Number_Assignment__c> toCreate,
        List<Account_Phone_Number_Assignment__c> toUpdate,
        List<Account_Phone_Number_Assignment__c> toDelete
    ) {
        // Placeholder for DML execution
        try {
            if (!toCreate.isEmpty()) {
                // TODO: Before insert, ensure required fields are populated or handle defaults
                DatabaseService dbs = new DatabaseService();
                dbs.insertRecords(toCreate);
                Logger.logInfo('Created ' + toCreate.size() + ' new assignments.');
            }
            if (!toUpdate.isEmpty()) {
                DatabaseService dbs = new DatabaseService();
                dbs.updateRecords(toUpdate);
                Logger.logInfo('Updated ' + toUpdate.size() + ' existing assignments.');
            }
            if (!toDelete.isEmpty()) {
                DatabaseService dbs = new DatabaseService();
                dbs.deleteRecords(toDelete);

                Logger.logInfo('Deleted ' + toDelete.size() + ' assignments.');
            }
        } catch (DmlException e) {
            // TODO: Implement robust error handling for DML failures
            system.debug('kk ' +  'DML Error: ' + e.getMessage());
            Logger.logError('NumberSyncService', 'DML Error: ' + e.getMessage());
        }
    }
}