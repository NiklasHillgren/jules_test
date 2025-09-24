@isTest
public class Activation_checkTest {
    
    @isTest
    static void testActivationCheck() {
        // Arrange
        Map<String, Object> activationLineCustomizations = new Map<String, Object>{
            'VAS_HBOBTB4__c' => true,
            'VAS_M2M_Data__c' => 'M2M5MB',
            'Funktionsnr__c' => 'Mobile',
            'Invoice_Email__c' => 'tuba@tuba.com',
            'Not_to_Activation__c' => false,
            'Phone_no_Status__c' => 'Nyt nummer',
            'Mobile_no__c' => '12345678',
            'BAN__c' => '1',
            'Billing_Street_and_no__c' => 'Holmbladsgade 139',
            'Billing_Postal_Code__c' => '12',
            'Billing_Name__c' => 'aaa',
            'Billing_City__c' => 'CP',
            'First_name__c' => 'FirstName',
            'PoA__c' => '1',
            'Last_name__c' => 'Lastname',
            'Email_address__c' => 'tuba@tuba.com',
            'EAN_number__c' => 12,
            'Delivery_Email__c' => 'tuba@tuba.com',
            'Ekstra_Data_SIM_number__c' => '33333333333',
            'Existing_SIM_number__c' => '222222222',
            'Phone_no__c' => '28270857',
            'Actual_delivery_date__c' => Date.newInstance(2020, 1, 1),
            'Invoice_Type__c' => 'PDF',
            'Delivery_Street_and_number__c' => 'Holmbladsgade 139',
            'Delivery_Att__c' => 'Att:',
            'Number_Porting_End_of_Commitment__c' => true,
            'Touchpoint_Receptionist__c' => true,
            'Touchpoint_Bruger__c' => true,
            'Touchpoint_Statistik__c' => true,
            'Touchpoint_Softphone__c' => true,
            'VAS_SIMBTB2__c' => true,
            'VAS_SIMBTB11__c' => true
        };

        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr('12345678')
            .withProducts(5)
            .withCaseRootBan('232312345')
            .withFokusCampaignAndDiscount()
            .withQuoteLineDiscount(5)
            .withActivationLineCustomizations(activationLineCustomizations)
            .build();
        
        // Act
        Test.startTest();
        
        List<Id> actIds = new List<Id>();
        for (Activation__c act : scenario.activations) {
            actIds.add(act.Id);
        }
        
        Activation_check_details.Activation(new List<String>{ scenario.caseRecord.Id });
        
        ApexPages.StandardController controller2 = new ApexPages.StandardController(scenario.caseRecord);
        Activation_check_details testActivationCheck = new Activation_check_details(controller2);
        testActivationCheck.Activation_Check();

        Activation_check testActivation = new Activation_check();
        testActivation.ActivationLineAvailability(scenario.activations[0].Id);
        testActivation.QuoteAvailability(scenario.activations[0].Id);
        
        list<id> recordId = new List<Id>();
        recordId.add(scenario.activations[0].Id);
        Activation_check.PortalEntryValidation(recordId);
        
        Test.stopTest();

        // Assert
        Case updatedCase = [SELECT Case_Activation_Check_Result__c FROM Case WHERE Id = :scenario.caseRecord.Id LIMIT 1];
        // System.assertNotEquals(updatedCase.Case_Activation_Check_Result__c, null, 'Case activation check results have been updated');
    }

	@IsTest
    private static void testMissingTeliaINSIGHTEMailContact() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withCvr('12345678')
            .build();
        
        scenario.account.Customer_has_Touchpoint__c = true;
        update scenario.account;

        scenario.activations[0].UC_Activation_Date__c = Date.today();
        update scenario.activations[0];

        Product2 product = new Product2(ProductAPI_Telia_Product_Id__c = 'TINSIGH', Name = 'Product');
        insert product;

        Activation_line__c testActivationLine = new Activation_line__c(
            Activation__c = scenario.activations[0].Id,
            Manual_Product__c = product.Id,
            Telia_INSIGHT_e_mail_contact__c = null
        );
        insert testActivationLine;

        // Act
        Test.startTest();
        String activationResultText = '';
        Activation_check_details.validateActivation(scenario.activations[0], activationResultText);
        Test.stopTest();

        // Assert
        Case cs = [SELECT Case_Activation_Check_Result__c FROM Case WHERE Id = :scenario.caseRecord.Id];
        System.assert(cs.Case_Activation_Check_Result__c.contains('Required field missing on Activation Line: Telia INSIGHT e-mail contact'));
    }

    @IsTest
    private static void testValidateActivationIncorrectFunktionsnr() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withCvr('78787878')
            .build();
        
        scenario.account.Customer_has_Touchpoint__c = true;
        update scenario.account;

        Product2 testProduct = new Product2(Name = 'Touchpoint Fastnetnummer', Product_Group__c = 'Touchpoint');
        insert testProduct;

        Activation_line__c testActivationLine = new Activation_line__c(
            Case__c = scenario.caseRecord.Id,
            Activation__c = scenario.activations[0].Id,
            Manual_Product__c = testProduct.Id,
            Funktionsnr__c = 'Mobile'
        );
        insert testActivationLine;

        // Act
        Test.startTest();
        Activation_check_details.validateActivation(new Activation__c(Case__c = scenario.caseRecord.Id), '');
        Test.stopTest();

        // Assert
        Case cs = [SELECT Case_Activation_Check_Result__c FROM Case WHERE Id = :scenario.caseRecord.Id];
        System.assert(cs.Case_Activation_Check_Result__c.contains('Please select the correct value for Funktionsnr'));
    }

    @IsTest
    private static void testValidateActivation() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario = NorlysTestScenarios.newBuilder()
            .withCvr('12345678')
            .build();
        
        scenario.account.Customer_has_Touchpoint__c = true;
        update scenario.account;

        Product2 product1 = new Product2(ProductCode = 'TestProductCode1', Name = 'Product 1');
        insert product1;
        Product2 product2 = new Product2(ProductCode = 'TestProductCode2', Name = 'Product 2');
        insert product2;

        Activation_line__c activationLine1 = new Activation_line__c(
            Manual_Product__c = product1.Id,
            Phone_no_Status__c = 'Nummer skal porteres',
            Activation__c = scenario.activations[0].Id
        );
        insert activationLine1;
        Activation_line__c activationLine2 = new Activation_line__c(
            Manual_Product__c = product2.Id,
            Phone_no_Status__c = 'Nummer skal porteres',
            Number_Porting_End_of_Commitment__c = true,
            Activation__c = scenario.activations[0].Id
        );
        insert activationLine2;

        // Act
        Test.startTest();
        Activation_check_details.validateActivation(scenario.activations[0], '');
        Test.stopTest();

        // Assert
        Case cs = [SELECT Case_Activation_Check_Result__c FROM Case WHERE Id = :scenario.caseRecord.Id];
        System.assert(cs.Case_Activation_Check_Result__c.contains('Required field missing on Activation Line'));
    }
}