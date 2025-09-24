@IsTest
public class Activation_Create_IterableClass_Test {

    @IsTest
    static void querySelectorTest() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withProducts(2)
            .withStandardVoiceAndHomeOfficeProducts()
            .build();

        scenario.caseRecord.Quote__c = scenario.quote.Id;
        update scenario.caseRecord;
        
        List<Id> quoteIdsList = new List<Id>{ scenario.quote.Id };

        // Act
        Test.startTest();
        Activation_Create_Iterable ProcessBatch = new Activation_Create_Iterable();
        ProcessBatch.recordId = quoteIdsList;
        ID batchprocessid = Database.executeBatch(ProcessBatch);
        Test.stopTest();

        // Assert
        List<SBQQ__QuoteLine__c> updatedQuoteLines = [SELECT Id, Activation__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :scenario.quote.Id];
        for (SBQQ__QuoteLine__c ql : updatedQuoteLines) {
            Assert.isNotNull(ql.Activation__c, 'Activation should be populated on the quote line after the batch job runs.');
        }
    }
}