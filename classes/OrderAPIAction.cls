/**
* @description This Invocable Apex class sends activation line orders to the Order API.
*              It is responsible for orchestrating the process of building the request,
*              sending it via HTTP, and processing the response. The actual creation of the
*              request payload is delegated to the `OrderFactory` class.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Mujahid              06/03/2023      Initial version.
*  Kenneth Houkjær      11/09/2025      Refactored to use OrderFactory for request creation.
*  Kenneth Houkjær      11/09/2025      Refactored response handling to use new DTO model.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public with sharing class OrderAPIAction {

	private static List<System_Log__c> errorsList = new List<System_Log__c>();

    // Constants for response handling and logging
	private static final String PROCESSING_STATUS_RECEIVED = 'RECEIVED';
	private static final String STATUS_PENDING = 'Pending fulfilment';
	private static final String STATUS_FAILED = 'Fulfilment failed';
	private static final String ERROR_ORIGIN = 'Apex';
	private static final String ERROR_ADDITIONAL_INFO = 'OrderAPIAction';
    private static final String ERROR_FIELDS = ' Fields that affected this error: ';
	private static final String ERROR_LINE_TXT = 'Error on line : ';
	private static final String ERROR_MSG_TXT = '. Error message:  ';
	private static final String AUTHORIZATION_TXT = 'Authorization';
	private static final String CONTENT_TYPE_TXT = 'Content-Type';
	private static final String CONTENT_TYPE_VALUE = 'application/json';
	private static final String BEARER_TXT = 'Bearer ';
	private static final String ENDPOINT_BASE = '/accounts/';
	private static final String ENDPOINT_PATH = '/orders';

	@InvocableMethod(label='Create Home Office Order (New)' description='Create New Home Office Order in Fokus using new refactored logic.')
	public static List<Result> createOrder(List<Request> requests) {
		System.debug('createOrder called');
		try {
			// Get API settings and auth token
			APISettings__mdt api = MetadataSelector.getAPISettings('OrderAPIHomeOfficeSettings');
			String token = AuthorizationWrapper.getAPIToken(api);
			Map<String, String> headers = new Map<String, String>{ AUTHORIZATION_TXT => BEARER_TXT + token, CONTENT_TYPE_TXT => CONTENT_TYPE_VALUE };
			
            List<Activation_line__c> activationLines = requests.get(0).activationLines;
            String caseId = activationLines.get(0).Case__c;
			Map<String, Order> ordersByBan = OrderFactory.createOrdersFromActivationLines(activationLines, caseId);

            Map<String, String> requestBodiesByBAN = new Map<String, String>();
            for(String ban : ordersByBan.keySet()) {
                System.JSONGenerator gen = JSON.createGenerator(true);
                ordersByBan.get(ban).serialize(gen);
                requestBodiesByBAN.put(ban, gen.getAsString());
            }
			
			System.debug(LoggingLevel.INFO, 'requestBodiesByBAN = ' + requestBodiesByBAN);
			List<Order> responses = new List<Order>();

			// Perform HTTP callouts
			for (String ban : requestBodiesByBAN.keySet()) {
				String endpoint = api.API_PartialEndPoint__c + ENDPOINT_BASE + ban + ENDPOINT_PATH;
				HttpResponse resp = HttpWrapper.post(endpoint, requestBodiesByBAN.get(ban), headers);

                // Process responses
				if (resp.getStatusCode() == 201 || resp.getStatusCode() == 200) {
                    // Use the factory to parse the response
					Order result = OrderFactory.parse(resp.getBody());
					if (result != null) {
						if (result.hasValidationErrors) {
							errorsList.add(saveErrors(result));
						} else {
							responses.add(result);
						}
					} else {
                        errorsList.add(createErrorLog('Failed to parse response body: ' + resp.getBody()));
                    }
				} else if (resp.getStatusCode() == 400 || resp.getStatusCode() == 504) {
					ErrorResult errorResult = (ErrorResult) JSON.deserialize(resp.getBody(), ErrorResult.class);
					String errorMsg = errorResult.error.code + ' : ' + errorResult.error.message;
					errorsList.add(createErrorLog(errorMsg));
				} else {
					errorsList.add(createErrorLog(Label.API_Exception_Flow_Message));
				}
			}

			// Handle results and errors
			if (errorsList.size() > 0) {
				return createErrorResult(requests.get(0).activationLines);
			} else {
				updateResults(createResultsToUpdate(responses, requests));
			}
			return null;

		} catch (Exception ex) {
			String errorMsg = ERROR_LINE_TXT + ex.getLineNumber() + ERROR_MSG_TXT + ex.getMessage();
			errorsList.add(createErrorLog(errorMsg));
			return createErrorResult(requests.get(0).activationLines);
		} finally {
			if (!errorsList.isEmpty()) {
                insert errorsList;
            }
		}
	}

    @TestVisible
	private static System_Log__c createErrorLog(String errorMsg) {
		System_Log__c errorLog = new System_Log__c(Origin__c = ERROR_ORIGIN, Error_Body__c = errorMsg, Additional_Information__c = ERROR_ADDITIONAL_INFO);
		return errorLog;
	}

	@TestVisible
	private static List<Result> createErrorResult(List<Activation_line__c> activationLines) {
		Result errorResult = new Result();
		errorResult.hasError = true;
		errorResult.errorMessage = Label.API_Exception_Flow_Message;
		return new List<Result>{ errorResult };
	}

	@TestVisible
    private static System_Log__c saveErrors(Order data) {
        String errors = '';
        if (data.validationErrors != null) {
            errors += getErrors(data.validationErrors) + '\n';
        }
        if (data.orderParts != null && !data.orderParts.isEmpty()) {
            OrderPart rootPart = data.orderParts.get(0);
            if (rootPart.validationErrors != null) {
                errors += getErrors(rootPart.validationErrors) + '\n';
            }
            if (rootPart.orderParts != null && !rootPart.orderParts.isEmpty()) {
                OrderPart accountPart = rootPart.orderParts.get(0);
                 if (accountPart.orderItems != null && !accountPart.orderItems.isEmpty() && accountPart.orderItems.get(0).validationErrors != null) {
                    errors += getErrors(accountPart.orderItems.get(0).validationErrors) + '\n';
                }
            }
        }
        return createErrorLog(errors);
    }

	@TestVisible
	private static String getErrors(List<ValidationErrors> validationErrors) {
		String orderErrors = '';
		for (ValidationErrors error : validationErrors) {
			for (Parameter param : error.parameters) {
				orderErrors += error.errorCode + ' : ' + param.reason + '\n';
			}
		}
		return orderErrors;
	}

	@TestVisible
	private static void updateResults(List<Activation_line__c> activationLines) {
		System.debug('updateResults called');
		Database.SaveResult[] srList = Database.update(activationLines, false);
		for (Database.SaveResult sr : srList) {
			if (!sr.isSuccess()) {
				System.debug('sr = ' + sr);
				for (Database.Error err : sr.getErrors()) {
					System.debug('err = ' + err);
					String errorMsg = err.getStatusCode() + ': ' + err.getMessage() + ', ' + ERROR_FIELDS + err.getFields();
					errorsList.add(createErrorLog(errorMsg));
				}
			}
		}
	}

	@TestVisible
	private static List<Activation_line__c> createResultsToUpdate(List<Order> responses, List<Request> requests) {
		Map<string, OrderPart> successAccountsByActivationId = new Map<String, OrderPart>();
		Map<string, OrderPart> failAccountsByActivationId = new Map<String, OrderPart>();
		List<Activation_line__c> activationLinesReqs = requests.get(0).activationLines;
		
		for (Order res : responses) {
            if (res != null && res.orderParts != null && !res.orderParts.isEmpty() && res.orderParts.get(0).orderParts != null) {
                List<OrderPart> accountOrderParts = res.orderParts.get(0).orderParts;
                for (OrderPart account : accountOrderParts) {
                    OrderPartInternet internetPart = (OrderPartInternet)account;
                    String activationId = internetPart.channelOrderPartId;
                    if (account.processingStatus == PROCESSING_STATUS_RECEIVED && account.splitOrderId != null) {
                        successAccountsByActivationId.put(activationId, account);
                    } else {
                        failAccountsByActivationId.put(activationId, account);
                    }
                }
            }
		}

		for (Activation_line__c actLine : activationLinesReqs) {
			if (successAccountsByActivationId.containsKey(actLine.Id)) {
                OrderPart account = successAccountsByActivationId.get(actLine.Id);
				actLine.Home_Office_Activation_Accepted__c = true;
				actLine.Home_Office_Request_Activation__c = true;
				actLine.Status__c = STATUS_PENDING;
				actLine.Home_Office_Requested_Activation_Date__c = Date.today();
				actLine.Home_Office_Order_Id__c = account.splitOrderId;
			}
			if (failAccountsByActivationId.containsKey(actLine.Id)) {
				actLine.Home_Office_Activation_Accepted__c = false;
				actLine.Status__c = STATUS_FAILED;
				actLine.Home_Office_Request_Activation__c = false;
				actLine.Home_Office_Requested_Activation_Date__c = null;
				actLine.Home_Office_Order_Id__c = null;
			}
			activationLinesReqs.add(actLine);
		}

		return activationLinesReqs;
	}
    
	public class Request {
		@InvocableVariable
		public List<Activation_line__c> activationLines;
		@InvocableVariable
		public Account account;
	}

	public class Result {
		@InvocableVariable
		public Boolean hasError;
		@InvocableVariable
		public String errorMessage;
	}

	public class ErrorResult {
		public ErrorResultBody error;
	}

	public class ErrorResultBody {
		public String code;
		public String message;
	}
}