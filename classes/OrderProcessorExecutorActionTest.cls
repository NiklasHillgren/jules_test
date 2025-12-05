@IsTest
public class OrderProcessorExecutorActionTest {
    
    @IsTest
    static void testOrderProcessAndRegister() {

        // --- Test data ---
        Case c = new Case(Status = 'New', Origin = 'Phone');
        insert c;

        System.debug('c.Id: ' + c.Id);

        OrderProcessorExecutorAction.InputVariables iv =
            new OrderProcessorExecutorAction.InputVariables();
        iv.caseId = c.Id;

        List<OrderProcessorExecutorAction.InputVariables> inputList =
            new List<OrderProcessorExecutorAction.InputVariables>{ iv };


        // --- Execute ---
        Test.startTest();
        List<OrderProcessorExecutorAction.OutputVariables> result =
            OrderProcessorExecutorAction.orderProcessAndRegister(inputList);
        Test.stopTest();


        // --- Assert returned output ---
        Assert.areEqual(1, result.size(), 'Expected one output row');
        Assert.isTrue(result[0].isSuccess, 'Expected success = true');

Test.getEventBus();
    }

}