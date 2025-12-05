@IsTest
public with sharing class NiklasTest {
    public class OperaPastryMatchable implements Argument.Matchable {
        public Boolean matches(Object callArgument) {
            Pastry p = (Pastry) callArgument;
            return p.name == 'Opera';
        }

        public Boolean equals(Object obj) {
            return obj != null && obj instanceof OperaPastryMatchable;
        }
    }

    public void test (){
        
    }
}