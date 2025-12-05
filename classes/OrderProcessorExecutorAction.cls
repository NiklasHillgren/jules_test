/**
 * @description Invocable action to process and register orders based on Case IDs.
 * 
 *  -----------------------------------------------------------------------------
 *  Developer               Date            Description
 *  -----------------------------------------------------------------------------
 *  Kirstine Nielsen        2025-10-28      Initial version
 * 
 * @author Kirstine Nielsen
 * @version 1.0 - Initial version
 * @since 2025-10-28
 */
public with sharing class OrderProcessorExecutorAction {

    @InvocableMethod(label='Order process and register' description='Order process and register')
    public static List<OutputVariables> orderProcessAndRegister(List<InputVariables> inputVariables) {
		List<OutputVariables> outputVarsList = new List<OutputVariables>();
        List<EventExecutor__e> eventExecutors = new List<EventExecutor__e>();

        // who is the running user
        Id userId = UserInfo.getUserId();

        // bulkification from flow         
        for (InputVariables inputVars : inputVariables) {
            Logger.logInfo('OrderProcessorExecutorAction orderProcessAndRegister, inputVars.caseId: ' + inputVars.caseId);

            OrderProcessorExecutorHandler.Parameters params = new OrderProcessorExecutorHandler.Parameters();
            params.caseId = inputVars.caseId;
            params.invoicedByUserId = userId;

            // Create event executor and add to the list
            eventExecutors.add(createEventExecutor(params));

            OutputVariables outputVars = new OutputVariables();
            outputVars.isSuccess = true;
            outputVarsList.add(outputVars);
        }

        // Publish the events to the Salesforce event bus.
        EventBus.publish(eventExecutors);

        Logger.logInfo('OrderProcessorExecutorAction orderProcessAndRegister, outputVars.size(): ' + outputVarsList.size());
        Logger.logInfo('OrderProcessorExecutorAction orderProcessAndRegister, Events published successfully.');
        Logger.emit();
        
		// Output
		return outputVarsList;
	}

    private static EventExecutor__e createEventExecutor(OrderProcessorExecutorHandler.Parameters params) {
        EventExecutor__e eventExecutor = new EventExecutor__e();
        eventExecutor.Executor__c = 'OrderProcessorExecutorHandler';  // TODO this will be your event eventExecutor handler, change when we agree on a good name for it        
        // Serialize parameters to JSON and assign to event
        eventExecutor.Parameters__c = JSON.serialize(params);
        // eventExecutor.Parameters__c = JSON.serialize(new Map<String, Object>{ 'caseId' => 'inputVars.caseId' });
        return eventExecutor;
    }

	public class InputVariables {
		@InvocableVariable
		public Id caseId;
	}

	public class OutputVariables {
		@InvocableVariable
        public Boolean isSuccess;
	}
}