/**
 * SELECTOR class for order namespace
 * 
 *  Developer            Date            Description
 *  -----------------------------------------------------------------------------
 *  Niklas Hillgren      22/10/2025      Initial version
 * 
 * @author Niklas Hillgren
 * @version 1.0
 * @since 22/10/2025
 */
public with sharing class OrderSelector {
    /**
     * Retrieves activation lines based on provided order IDs. 
     * The orderId matches ORDER_API_OrderId__c on the parent parent activation.
     * 
     * @description Queries Activation_Line__C records matching the specified order IDs
     *              Returns a list containing Id, Status__c, and Activation__r.ORDER_API_OrderId__c fields
     * 
     * @param orderIds Set of order IDs to filter activation lines by
     * @return List of Activation_Line__C records matching the provided order IDs
     */
    public List<Activation_Line__C> getActivationLinesByOrderIds(Set<String> orderIds) {
        return new Query(Activation_Line__C.SObjectType)
            .selectFields(new List<String>{ 'Id', 'Status__c', 'Activation__r.ORDER_API_OrderId__c' })
            .addConditionIn('Activation__r.ORDER_API_OrderId__c', orderIds)
            .fetchAll();
    }
}
