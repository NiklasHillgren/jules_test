/**
 * The NumberSeriesRefreshActionTest class is responsible for testing the NumberSeriesRefreshAction class.
 *  -----------------------------------------------------------------------------
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Kenneth Houkjær         27/07/2025      Initial version
 *
 * @author Kenneth Houkjær
 * @date 27/07/2025
 */
/**
 * @description
 *  Test class for the NumberSeriesRefreshAction, using the SUnit framework.
 * @group SUnit
 */
@isTest
private class NumberSeriesRefreshActionTest {

    /**
     * @description Tests that the refreshPhoneNumberSeries action correctly processes multiple accounts.
     */
    @isTest
    static void refreshPhoneNumberSeries_twoAccounts_returnsTwoOutputs() {
        // Arrange
        NorlysTestScenarios.ScenarioResult scenario1 = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withCvr('12345678')
            .withoutCaseAndActivations()
            .build();
        
        NorlysTestScenarios.ScenarioResult scenario2 = NorlysTestScenarios.newBuilder()
            .forNumberCaseHandling()
            .withCvr('87654321')
            .withoutCaseAndActivations()
            .build();
            
        List<Account> testAccounts = new List<Account>{ scenario1.account, scenario2.account };
        
        List<NumberSeriesRefreshAction.InputVariables> inputVariablesList = new List<NumberSeriesRefreshAction.InputVariables>();
        for (Account testAccount : testAccounts) {
            NumberSeriesRefreshAction.InputVariables inputVariables = new NumberSeriesRefreshAction.InputVariables();
            inputVariables.inputAccount = testAccount;
            inputVariablesList.add(inputVariables);
        }

        // Act
        Test.startTest();
        List<NumberSeriesRefreshAction.OutputVariables> outputVariablesListResult = NumberSeriesRefreshAction.refreshPhoneNumberSeries(inputVariablesList);
        Test.stopTest();

        // Assert
        Assert.areEqual(
            2, 
            outputVariablesListResult.size(), 
            'The action should return an output variable for each input account.'
        );
    }
}