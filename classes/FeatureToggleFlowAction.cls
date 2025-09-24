public with sharing class FeatureToggleFlowAction {

    @InvocableMethod(label='Check Feature Toggle' description='Checks if a feature is enabled by its name' category='Feature Toggles')
    public static List<Boolean> isFeatureEnabled(List<String> featureNames) {
        List<Boolean> results = new List<Boolean>();
        if (featureNames == null || featureNames.isEmpty()) {
            return results;
        }

        for (String featureName : featureNames) {
            results.add(FeatureToggleService.isFeatureEnabled(featureName));
        }
        
        return results;
    }
}