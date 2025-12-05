public with sharing class UserSelector {
    public User getById(Id userId) {
        return (User) new Query(User.SObjectType)
            .selectFields(new List<String>{ 'ContactId', 'Contact.AccountId', 'Email', 'FederationIdentifier' })
            .addConditionEq(User.Fields.Id, userId)
            .setLimit(1)
            .fetch();
    }
}
