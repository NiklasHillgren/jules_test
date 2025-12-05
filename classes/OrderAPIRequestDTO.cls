public with sharing class OrderAPIRequestDTO {
    public class OrderStatus {
        public String caseId;
        public List<Order> orders;
    }
    
    public class Order {
        public String orderId;
        public String status;
        public String statusMessage;
    }
}