@IsTest
public class Activation_line_CreateTest {

    @IsTest
    static void testBatchCreatesActivationLinesForVoiceAndHomeOffice() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withProducts(2)
            .withStandardVoiceAndHomeOfficeProducts()
            .build();

        scenario.caseRecord.Quote__c = scenario.quote.Id;
        update scenario.caseRecord;

        Activation_line_Create_Iterable testedClass = new Activation_line_Create_Iterable();
        testedClass.recordId = string.valueOf(scenario.quote.Id);
        testedClass.query =
            'SELECT Id,Activation_Record_Type__c,Activation__c, SBQQ__Quote__r.SBQQ__BillingCity__c , ' +
            'SBQQ__Quote__r.SBQQ__BillingPostalCode__c, SBQQ__Quote__r.SBQQ__BillingStreet__c, SBQQ__Quote__c, SBQQ__Quantity__c , ' +
            'SBQQ__Quote__r.SBQQ__BillingCountry__c,SBQQ__Product__c, Additional_Quantity__c, ' +
            'SBQQ__ProductCode__c, Address_filled_on_activation_lines__c, SBQQ__SegmentIndex__c,' +
            ' SBQQ__Quote__r.SBQQ__Opportunity2__r.Case__c, SBQQ__Product__r.address_required__c,SBQQ__Quote__r.Account_Name__c, ' +
            ' SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__Renewal__c, SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__AmendedContract__c ' +
            ' from SBQQ__QuoteLine__c ' +
            ' where Activation_Record_Type__c <>\'No activation needed\'' +
            ' and SBQQ__Quote__c =\'' +
            scenario.quote.Id +
            '\' and SBQQ__Product__r.activate_with_other_products__c = false' +
            ' order by SBQQ__Product__c desc';

        // Act
        Test.startTest();
        Database.executeBatch(testedClass);
        Test.stopTest();

        // Assert
        List<Activation_Line__c> createdLines = [SELECT Id FROM Activation_Line__c WHERE Quote_Line__c = :scenario.quoteLines[0].Id OR Quote_Line__c = :scenario.quoteLines[1].Id];
        Assert.areEqual(2, createdLines.size(), 'Activation lines should have been created for both the voice and home office products.');
    }
}