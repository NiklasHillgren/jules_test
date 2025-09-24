@IsTest
private class Activation_Create_Iterable_Test {

    private static final String CVR = '12345678';

    @IsTest
    static void querySelectorTest() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr(CVR)
            .build();

        List<Id> quoteIdsList = new List<Id>();
        quoteIdsList.add(scenario.quote.Id);

        Activation_Create_Iterable testedClass = new Activation_Create_Iterable();
        testedClass.recordId = quoteIdsList;

        // Act
        Database.querylocator returnedQuery = testedClass.start(null);

        // Assert
        String expectedQuery = 'SELECT Id,Activation_Record_Type__c,SBQQ__Quote__r.SBQQ__Opportunity2__r.Case__c,Additional_Quantity__c, SBQQ__RenewedSubscription__c,SBQQ__ProductOption__r.SBQQ__Feature__r.SBQQ__Category__c  from SBQQ__QuoteLine__c where SBQQ__Quote__c in :recordId and SBQQ__EffectiveQuantity__c >0 and Activation_Record_Type__c <>\'No activation needed\'';
        Assert.areEqual(expectedQuery, returnedQuery.getQuery(), 'The query returned by start method is wrong.');
    }

    @IsTest
    static void functionalityTest() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr(CVR)
            .build();

        List<Id> quoteIdsList = new List<Id>();
        quoteIdsList.add(scenario.quote.Id);

        Activation_Create_Iterable testedClass = new Activation_Create_Iterable();
        testedClass.recordId = quoteIdsList;

        Map<Id, SBQQ__QuoteLine__c> quoteLinesMap = new Map<Id, SBQQ__QuoteLine__c>([SELECT Id, Activation__c, SBQQ__Quote__r.SBQQ__Primary__c FROM SBQQ__QuoteLine__c]);

        // Act
        Test.startTest();
        Database.executeBatch(testedClass);
        Test.stopTest();

        // Assert
        Map<Id, SBQQ__QuoteLine__c> verificationQuoteLineMap = new Map<Id, SBQQ__QuoteLine__c>([SELECT Id, Activation__c FROM SBQQ__QuoteLine__c]);
        for (Id singleId : quoteLinesMap.keySet()) {
            if (quoteLinesMap.get(singleId).SBQQ__Quote__r.SBQQ__Primary__c) {
                System.assertNotEquals(quoteLinesMap.get(singleId).Activation__c, verificationQuoteLineMap.get(singleId).Activation__c, 'The Activation should be populated for Quote Lines from primary Quotes');
            } else {
                System.assertEquals(quoteLinesMap.get(singleId).Activation__c, verificationQuoteLineMap.get(singleId).Activation__c, 'The Activation should not be populated for Quote Lines from not primary Quotes');
            }
        }
    }
    
    @IsTest
    static void functionalityTest1() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr(CVR)
            .withQuoteLineDetails()
            .build();

        List<Id> quoteIdsList = new List<Id>();
        quoteIdsList.add(scenario.quote.Id);
        
        Activation_Create_Iterable testedClass = new Activation_Create_Iterable();
        testedClass.recordId = quoteIdsList;

        // Act
        Test.startTest();
        Database.executeBatch(testedClass);
        Test.stopTest();

        // Assert
        // No assertion was present in the original test, so we just ensure it runs without error.
        List<SBQQ__QuoteLine__c> updatedQuoteLines = [SELECT Id, Activation__c FROM SBQQ__QuoteLine__c WHERE Id = :scenario.quoteLines[0].Id];
        Assert.isNotNull(updatedQuoteLines[0].Activation__c, 'Activation should be filled in on the quote line.');
    }

    public class testException extends Exception {}

    @IsTest
    static void mailingTest() {
        // Arrange
        NorlysTestScenarios.newBuilder().withCvr(CVR).build();

        // Act & Assert
        // This test appears to be incomplete or just for code coverage of a catch block.
        // Replicating the original structure.
        try {
            throw new testException('The test Error moessage');
        } catch (Exception e) {
            Apex_Error_email_address__c Activation_line_Settings = new Apex_Error_email_address__c(
                Email_Address__c = 'test1@test.test'
            );
            Activation_Create_Iterable testedClass = new Activation_Create_Iterable();
        }
    }
}