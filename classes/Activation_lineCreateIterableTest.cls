@IsTest
public class Activation_lineCreateIterableTest {

    @IsTest
    static void testBatchCreatesActivationLines() {
        // Arrange
        Product2 customProduct = new Product2(
            Name = 'Test Address Product',
            ProductCode = '3122',
            address_required__c = true,
            Activation_Record_Type__c = 'Fiber',
            activate_with_other_products__c = false
        );

        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCustomProduct(customProduct, 3)
            .build();
        
        Address_line__c newAddressLine = new Address_line__c(
            Quote__c = scenario.quote.Id, 
            AdrProduct__c = customProduct.Id
        );
        insert newAddressLine;
        
        // The quote line is now created by the scenario builder, let's find it.
        SBQQ__QuoteLine__c newQL = null;
        for (SBQQ__QuoteLine__c ql : scenario.quoteLines) {
            if (ql.SBQQ__Product__c == customProduct.Id) {
                newQL = ql;
                break;
            }
        }
        Assert.isNotNull(newQL, 'The custom quote line should have been created by the scenario builder.');

        // The test requires this field to be set to true.
        newQL.Address_filled_on_activation_lines__c = true;
        update newQL;
        
        Activation_line_Create_Iterable processBatch = new Activation_line_Create_Iterable();
        processBatch.query = 'SELECT Id,Activation_Record_Type__c,Activation__c, SBQQ__Quote__r.SBQQ__BillingCity__c , ' +
            'SBQQ__Quote__r.SBQQ__BillingPostalCode__c, SBQQ__Quote__r.SBQQ__BillingStreet__c, SBQQ__Quote__c, SBQQ__Quantity__c , ' +
            'SBQQ__Quote__r.SBQQ__BillingCountry__c,SBQQ__Product__c, Additional_Quantity__c, ' +
            'SBQQ__ProductCode__c, Address_filled_on_activation_lines__c, SBQQ__SegmentIndex__c,' +
            ' SBQQ__Quote__r.SBQQ__Opportunity2__r.Case__c, SBQQ__Product__r.address_required__c,SBQQ__Quote__r.Account_Name__c, ' +
            ' SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__Renewal__c, SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__AmendedContract__c ' +
            ' from SBQQ__QuoteLine__c ' +
            ' where Activation_Record_Type__c <>\'No activation needed\'' +
            ' and SBQQ__EffectiveQuantity__c >0 and SBQQ__Quote__c =\'' + scenario.quote.Id + '\' and SBQQ__Product__r.activate_with_other_products__c = false' +
            ' order by SBQQ__Product__c desc';
        processBatch.recordId = String.valueOf(scenario.quote.Id);

        // Act
        Test.startTest();
        ID batchprocessid = Database.executeBatch(processBatch);
        Test.stopTest();

        // Assert
        List<Activation_Line__c> createdLines = [SELECT Id FROM Activation_Line__c WHERE Quote_Line__c = :newQL.Id];
        Assert.isFalse(createdLines.isEmpty(), 'Activation line should have been created for the new quote line.');
    }
}