public with sharing class AccountTest {
    
    @AuraEnabled
    public static string makeContactPrimary(Id AccountID, Id ContactId){
        Map<String, Object> data = new Map<String, Object>();
        try {
            if(Schema.sObjectType.Account.fields.Name.isAccessible()
            && Schema.sObjectType.Contact.fields.Name.isAccessible()
            && Schema.sObjectType.Contact.fields.PrimaryContact__c.isAccessible()
            && Schema.sObjectType.Contact.fields.PrimaryContact__c.isUpdateable() ){
                Account acc = [SELECT ID, Name, (SELECT ID, Name FROM Contacts WHERE ID !=: ContactId AND PrimaryContact__c = TRUE) FROM Account WHERE ID =: AccountID];
                Contact con = new Contact(Id = ContactId);
                con.PrimaryContact__C = TRUE;
                List<Contact> ContactsToUpdate = new List<Contact>();
                if(acc.Contacts.size() > 0){
                    for(Contact con1 : acc.Contacts){
                        con1.PrimaryContact__c = false;
                        ContactsToUpdate.add(con1);
                    }
                }
                ContactsToUpdate.add(con);
                update ContactsToUpdate;
                data.put('success', true);   
            }
            else{
                data.put('success', false);
                data.put('error', 'Not Accessible');
            }
        } catch (Exception e) {
            data.put('success', false);
            data.put('error', e.getMessage());
        }
        return JSON.serialize(data);
    }
    @AuraEnabled
    public static string getAccounts(){
        Map<String, Object> data = new Map<String, Object>();
        try {            
            if(Schema.sObjectType.Account.fields.Name.isAccessible()
            && Schema.sObjectType.Contact.fields.Name.isAccessible()
            && Schema.sObjectType.Contact.fields.PrimaryContact__c.isAccessible() ){
                List<Account> accounts = [SELECT ID, Name, (SELECT ID, Name, PrimaryContact__c FROM Contacts) FROM Account Limit 5];
                data.put('success', true);
                data.put('accounts', accounts);
            }
            else {
                data.put('success', false);
                data.put('error', 'Fields Not Accessible');
            }
        } catch (Exception e) {
            data.put('success', false);
            data.put('error', e.getMessage());
        }
        return JSON.serialize(data);
    }
}
