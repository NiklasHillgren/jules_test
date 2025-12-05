public with sharing class NumberUpdActivationStatusQueueable implements Queueable {
    private Id activationId;
    private String activationStatus;

    public NumberUpdActivationStatusQueueable(Id activationId, String activationStatus) {
        this.activationId = activationId;
        this.activationStatus = activationStatus;
    }

    public void execute(QueueableContext context) {
        Activation__c activation = [
            SELECT Id, Phone_Number_Reservation_Status_Txt__c
            FROM Activation__c
            WHERE Id = :this.activationId
        ];

        if (activation != null) {
            activation.Phone_Number_Reservation_Status_Txt__c = this.activationStatus;
            update activation;
        }
    }
}