trigger Contact on Contact (before delete , before insert , after insert , before update , after update) 
{
    if(Trigger.isBefore && Trigger.isDelete)
        PreventAttorneyContactDeletionService.preventAttorenyContactDeletion(Trigger.Old);
    else if(Trigger.isBefore && Trigger.isUpdate)
    {
        ContactService.populateInitialProduct(Trigger.new);
        List<Contact> contactWithNoAccounts = new List<Contact>();
        for(Contact theContact : Trigger.new)
        {
            if(theContact.AccountId == null && theContact.FKUser__c != null)
            {
                contactWithNoAccounts.add(theContact);
            }
        }
        ContactManagerController.preventUpdateContact(Trigger.newMap,Trigger.oldMap,null, 'update');
        ContactService.createAccounts(contactWithNoAccounts);
        ContactService.populateTealiumChanges(Trigger.oldMap, Trigger.newMap);
    }
    else if(Trigger.isBefore && Trigger.isInsert)
    {
        ContactService.populateInitialProduct(Trigger.new);
        ContactService.updateCustomerLoginFromContact(Trigger.new);
       
        List<Contact> contactWithNoAccounts = new List<Contact>();
        for(Contact theContact : Trigger.new)
        {
            if(theContact.HomePhone != null){
                theContact.HomePhone = PhoneFormatter.formatPhone(theContact.HomePhone);
            }
            if(theContact.AccountId == null && theContact.FKUser__c != null)
            {
                contactWithNoAccounts.add(theContact);
            }
            
        }
         ContactService.createAccounts(contactWithNoAccounts);
         
        ContactManagerController.preventUpdateContact(null,null,Trigger.new , 'insert');
        

    }
    else if(Trigger.isAfter && Trigger.isInsert)
    {
        DuplicateChecker.findMatchingLeadsByContacts(Trigger.new);
        ContactService.ContactCustomerLoginAssociation(Trigger.newMap,Trigger.oldMap);// Added for Story - B39269
    }
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        ContactService.processContactByContactStatus(Trigger.oldMap , Trigger.newMap);
        
        ContactService.checkIfPhoneNumberChanged(Trigger.oldMap, Trigger.new);
       // contactService.closeopportunitiesdnc(Trigger.new);
         DNCController_ltng.closeopportunitiesdnc(Trigger.new);
         ContactService.ContactCustomerLoginAssociation(Trigger.newMap,Trigger.oldMap);// Added for Story - B39269
    
    }

    
}