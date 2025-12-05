public without sharing class Activation_Create {
	private static final String NO_ACTIVATION_NEEDED = 'No activation needed';
	private static final String TYPE_NEW = 'New';
	private static final String TYPE_RENEW_EXISTING = 'Renew Existing';

	@InvocableMethod(label='Create activations' description='Creating activations for a Quote')
	public static void Activation_Create(List<RequestDAO> requestDAO) {
		List<Activation__c> activationCreateList = new List<Activation__c>();
		List<AggregateResult> quoteLines = new List<AggregateResult>();
		String caseId = '';
		List<Id> recordId = new List<Id>{requestDAO.get(0).recordId};
		Logger.logInfo('Activation_Create.Activation_Create: recordId ' + recordId);
		Map<String, Case> caseByProductType = mapCaseByProductType(requestDAO.get(0).cases);
		Logger.logInfo('Activation_Create.Activation_Create: caseByProductType ' + caseByProductType);
		
		try {
			List<SBQQ__Quote__c> quotes = [
				SELECT Id, SBQQ__Opportunity2__r.SBQQ__Renewal__c, SBQQ__Opportunity2__r.SBQQ__AmendedContract__c, SBQQ__Opportunity2__r.Case__c
				FROM SBQQ__Quote__c
				WHERE Id = :recordId
				LIMIT 1
			];
			caseId = quotes.get(0).SBQQ__Opportunity2__r.Case__c;
			Logger.logInfo('Activation_Create.Activation_Create: caseId ' + caseId);
			Logger.logInfo('Activation_Create.Activation_Create: Quote List ' + quotes.get(0));
			
			if (quotes.size() > 0) {
				for (AggregateResult quoteLine : [
					SELECT SBQQ__Product__r.Delivery_Product_Group__c, SBQQ__Quote__r.SBQQ__Opportunity2__r.Case__c
					FROM SBQQ__QuoteLine__c
					WHERE
						SBQQ__Quote__c = :recordId
						AND SBQQ__Product__r.Activation_Record_Type__c != :NO_ACTIVATION_NEEDED
						AND SBQQ__EffectiveQuantity__c > 0
					GROUP BY SBQQ__Product__r.Delivery_Product_Group__c, SBQQ__Quote__r.SBQQ__Opportunity2__r.Case__c
				]) {
					quoteLines.add(quoteLine);
				}
			}
			
			if (quoteLines.size() > 0) {
				Logger.logInfo('Activation_Create.Activation_Create: quoteLines.size() > 0');
				for (AggregateResult ql : quoteLines) {
					String caseProductType = String.valueOf(ql.get('Delivery_Product_Group__c'));	
					String caseType = caseByProductType.get(caseProductType).Type;			
					if(caseType == caseProductType) {
						activationCreateList.add(
							new Activation__c(
								Case__c = caseByProductType.get(caseProductType).Id,
								RecordTypeId = Schema.sObjectType.Activation__c.getRecordTypeInfosByName()
									.get(String.valueOf(ql.get('Delivery_Product_Group__c')) + ' activation')
									.getRecordTypeId(),
								Name = String.valueOf(ql.get('Delivery_Product_Group__c') + ' - New'),
								Type__c = TYPE_NEW
							)
						);
					}
				}
			}
			
			// Creating and executing batch (Activation_Create_Iterable)
			if (activationCreateList != null) {
				Logger.logInfo('Activation_Create.Activation_Create: activationCreateList ' + activationCreateList);
				insert activationCreateList;
				Activation_Create_Iterable ProcessBatch = new Activation_Create_Iterable();
				ProcessBatch.recordId = recordId;
				ID batchprocessid = Database.executeBatch(ProcessBatch);
			}

		} catch (Exception e) {
			Logger.logError('Activation_Create.Activation_Create: Error Occured while creating activations ', e);
			System.debug('### Error Occured while creating activations : ' + e.getMessage() + ' LineNumber: ' + e.getLineNumber());
			System_Log__c logerror = new System_Log__c(
				Origin__c = 'Apex',
				Error_Body__c = e.getMessage() + ' LineNumber: ' + e.getLineNumber(),
				Additional_Information__c = 'Activation_Create'
			);
			insert logerror;
		}
		
       	Logger.emit();
	}	
	
	private static Map<String, Case> mapCaseByProductType(List<Case> cases) {
		Map<String, Case> csByProductType = new Map<String, Case>();
		for(Case cs: cases) {
			csByProductType.put(cs.Type, cs);
		}
		return csByProductType;
	}

	public class RequestDAO {
		@InvocableVariable
		public String recordId; // The record ID of the Quote
		@InvocableVariable
		public List<Case> cases;
	}
}