/**
* @description This Invocable Apex class creates a new Root BAN (Billing Account Number) by calling the Order API.
*              It is responsible for orchestrating the process of building the request,
*              sending it via HTTP, and processing the response. The actual creation of the
*              request payload is delegated to the `OrderFactory` class.
*  -----------------------------------------------------------------------------
*  Developer            Date            Description
*  -----------------------------------------------------------------------------
*  Mujahid              25/01/2023      Initial version.
*  Kenneth Houkjær      11/09/2025      Refactored to use OrderFactory for request creation.
*  Kenneth Houkjær      11/09/2025      Refactored response handling to use new DTO model.
*
* @author Kenneth Houkjær
* @date 2025-09-11
*/
public with sharing class RootBanServiceAction {

	private static final String ADDITIONAL_INFO = 'RootBanServiceAction';
	private static final String ORIGIN = 'Apex';

	@InvocableMethod(label='Create Root Ban (New)' description='Create Root Ban Record in Fokus using new refactored logic.')
	public static List<RootBanResult> createRootBan(List<Request> requests) {
		List<RootBanResult> rootBanResults = new List<RootBanResult>();
		try {
			// Get API settings and auth token
			APISettings__mdt api = MetadataSelector.getAPISettings('OrderAPIHomeOfficeSettings');
			String token = AuthorizationWrapper.getAPIToken(api);
			Map<String, String> headers = new Map<String, String>{ 'Authorization' => 'Bearer ' + token, 'Content-Type' => 'application/json' };

			// Use the factory to create the Order DTO
            OrderFactory.RootBanRequest factoryRequest = new OrderFactory.RootBanRequest();
            factoryRequest.inputAccount = requests.get(0).inputAccount;
            factoryRequest.inputOppoty = requests.get(0).inputOppoty;
            factoryRequest.companyName = requests.get(0).companyName;
            factoryRequest.billingAtt = requests.get(0).billingAtt;
            factoryRequest.email = requests.get(0).email;
            factoryRequest.streetName = requests.get(0).streetName;
            factoryRequest.streetNumber = requests.get(0).streetNumber;
            factoryRequest.postalCode = requests.get(0).postalCode;
            factoryRequest.city = requests.get(0).city;
            factoryRequest.country = requests.get(0).country;
            factoryRequest.BanType = requests.get(0).BanType;
			Order order = OrderFactory.createRootBanOrder(factoryRequest);

            // Serialize the DTO to a JSON request body
            System.JSONGenerator gen = JSON.createGenerator(true);
            order.serialize(gen);
            String body = gen.getAsString();
			
			// Perform HTTP callout
			String endpoint = api.API_PartialEndPoint__c + '/orders';
			Logger.logDebug('body = ' + body);
			HttpResponse resp = HttpWrapper.post(endpoint, body, headers);
			Logger.logDebug('resp = ' + resp);
			Order result = OrderFactory.parse(resp.getBody());
			Logger.logDebug('result = ' + result);
			
			// Process response
			RootBanResult rootBanResult = new RootBanResult();
			rootBanResult.hasErrors = result.hasValidationErrors;

			if (result.hasValidationErrors) {
				Logger.logDebug('result.hasValidationErrors = ' + result.hasValidationErrors);
				saveErrors(result);
				rootBanResult.errors = Label.Create_BAN_Error_Message;
				rootBanResult.billingAccountNumber = null;
			} else {
                // Navigate the new DTO structure to find the BAN
				String banNumber = result.orderParts[0].orderItems[0].billingAccountNumber;
				rootBanResult.billingAccountNumber = Decimal.valueOf(banNumber);
			}

			rootBanResults.add(rootBanResult);
			return rootBanResults;

		} catch (Exception ex) {
			Logger.logError('RootbanServiceAction', ex);
			System_Log__c exceptionLog = new System_Log__c(Origin__c = ORIGIN, Error_Body__c = ex.getMessage(), Additional_Information__c = ADDITIONAL_INFO);
			insert exceptionLog;
			return new List<RootBanResult>{ createErrorResult() };
		} finally {
			Logger.emit();
		}
	}

	private static RootBanResult createErrorResult() {
		RootBanResult errorResult = new RootBanResult();
		errorResult.billingAccountNumber = null;
		errorResult.errors = Label.Create_BAN_Error_Message;
		errorResult.hasErrors = true;
		return errorResult;
	}

	private static void saveErrors(Order data) {
		String serverErrors = '';
		if (data.validationErrors != null) {
			serverErrors += getErrors(data.validationErrors) + '\n';
		}
		if (data.orderParts != null && !data.orderParts.isEmpty()) {
            OrderPart rootPart = data.orderParts[0];
            if(rootPart.validationErrors != null) {
			    serverErrors += getErrors(rootPart.validationErrors) + '\n';
		    }
            if (rootPart.orderItems != null && !rootPart.orderItems.isEmpty() && rootPart.orderItems[0].validationErrors != null) {
                serverErrors += getErrors(rootPart.orderItems[0].validationErrors) + '\n';
            }
        }

		System_Log__c errorLog = new System_Log__c(Origin__c = ORIGIN, Error_Body__c = serverErrors, Additional_Information__c = ADDITIONAL_INFO);
		insert errorLog;
	}

	private static String getErrors(List<ValidationErrors> validationErrors) {
		String rootBanErrors = '';
		for (ValidationErrors error : validationErrors) {
			for (Parameter param : error.parameters) {
				rootBanErrors += error.errorCode + ' : ' + param.reason + '\n';
			}
		}
		return rootBanErrors;
	}

	public class Request {
		@InvocableVariable
		public Account inputAccount;
		@InvocableVariable
		public Opportunity inputOppoty;
		@InvocableVariable
		public String companyName;
		@InvocableVariable
		public String billingAtt;
		@InvocableVariable
		public String email;
		@InvocableVariable
		public String streetName;
		@InvocableVariable
		public String streetNumber;
		@InvocableVariable
		public String postalCode;
		@InvocableVariable
		public String city;
		@InvocableVariable
		public String country;
		@InvocableVariable
		public String BanType;
	}

	public class RootBanResult {
		@InvocableVariable
		public Decimal billingAccountNumber;
		@InvocableVariable
		public Boolean hasErrors;
		@InvocableVariable
		public String errors;
	}
}