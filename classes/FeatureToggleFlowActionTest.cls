@isTest
public class FeatureToggleFlowActionTest {
    static FeatureToggle__mdt createMockedFeatureToggle(String developerName, Boolean isEnabled){
 
        FeatureToggle__mdt toggle = new FeatureToggle__mdt();
        toggle.DeveloperName = developerName;
        toggle.MasterLabel = developerName;
        toggle.IsEnabled__c = isEnabled;
 
        return toggle;
    }

    @isTest
    static void testIsFeatureEnabled_whenFeatureIsEnabled_shouldReturnTrue() {
        // Arrange
        FeatureToggleService.clearCache();
        List<FeatureToggle__mdt> listOfMockedFeatureToggles = new List<FeatureToggle__mdt>();
        listOfMockedFeatureToggles.add(createMockedFeatureToggle('TestFeature', true));
        MetadataSelector.setMock(new MetadataSelectorMock(listOfMockedFeatureToggles));
        List<String> featureNames = new List<String>{'TestFeature'};
        
        // Act
        Test.startTest();
        List<Boolean> results = FeatureToggleFlowAction.isFeatureEnabled(featureNames);
        Test.stopTest();
        
        // Assert
        System.assertEquals(1, results.size(), 'Should return one result');
        System.assertEquals(true, results[0], 'The feature should be enabled');
    }

    @isTest
    static void testIsFeatureEnabled_whenFeatureIsDisabled_shouldReturnFalse() {
        // Arrange
        FeatureToggleService.clearCache();
        List<FeatureToggle__mdt> listOfMockedFeatureToggles = new List<FeatureToggle__mdt>();
        listOfMockedFeatureToggles.add(createMockedFeatureToggle('TestFeatureDisabled', false));
        MetadataSelector.setMock(new MetadataSelectorMock(listOfMockedFeatureToggles));
        List<String> featureNames = new List<String>{'TestFeatureDisabled'};

        // Act
        Test.startTest();
        List<Boolean> results = FeatureToggleFlowAction.isFeatureEnabled(featureNames);
        Test.stopTest();
        
        // Assert
        System.assertEquals(1, results.size(), 'Should return one result');
        System.assertEquals(false, results[0], 'The feature should be disabled');
    }

    @isTest
    static void testIsFeatureEnabled_whenToggleNotFound_shouldReturnFalse() {
        // Arrange
        FeatureToggleService.clearCache();
        List<String> featureNames = new List<String>{'NonExistentFeature'};
        
        // Act
        Test.startTest();
        List<Boolean> results = FeatureToggleFlowAction.isFeatureEnabled(featureNames);
        Test.stopTest();
        
        // Assert
        System.assertEquals(1, results.size(), 'Should return one result');
        System.assertEquals(false, results[0], 'The feature should be considered disabled if not found');
    }

    @isTest
    static void testIsFeatureEnabled_whenInputIsEmpty_shouldReturnEmptyList() {
        // Arrange
        FeatureToggleService.clearCache();

        // Act
        Test.startTest();
        List<Boolean> results = FeatureToggleFlowAction.isFeatureEnabled(new List<String>());
        Test.stopTest();
        
        // Assert
        System.assertEquals(0, results.size(), 'Should return an empty list for empty input');
    }

    @isTest
    static void testIsFeatureEnabled_whenInputIsNull_shouldReturnEmptyList() {
        // Arrange
        FeatureToggleService.clearCache();

        // Act
        Test.startTest();
        List<Boolean> results = FeatureToggleFlowAction.isFeatureEnabled(null);
        Test.stopTest();
        
        // Assert
        System.assert(results.isEmpty(), 'Should return an empty list for null input');
    }
}