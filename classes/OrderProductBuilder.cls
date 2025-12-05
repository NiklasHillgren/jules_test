/**
 * @description 
 * Interface for building Order Parts for Product Orders.
 * 
 *  -----------------------------------------------------------------------------
 *  Developer                   Date            Description
 *  -----------------------------------------------------------------------------
 *  Kirstine Nielsen            2025-11-20      Initial version
 * 
 * @author Kirstine Nielsen
 * @version 1.0 - Initial version
 * @since 2025-11-20
 */
public interface OrderProductBuilder {
    // method signature
    OrderBuilder.OrderPartBuilder createProductOrderPartBuilder(
        Integer hardwareDeliveryId,
        Activation_line__c activationLine
    );

    // method signature
    OrderBuilder.HardwareDeliveryBuilder createHardwareDeliveryBuilder(
        Activation_line__c activationLine
    );
}