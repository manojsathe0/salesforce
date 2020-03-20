public with sharing class DisplayPrimaryContactController {
    
    private final Contact cont;

    public Id primaryContactId{get;set;}
    public String contactId{get;set;}
    public List<IADMessage> iadMessages{get;set;}
    public String interactionId{get;set;}

    public DisplayPrimaryContactController(ApexPages.StandardController stdController) {
        
        iadMessages = new List<IADMessage>();
        this.cont = (Contact)stdController.getRecord();
        contactId = cont.Id;
        if(contactId != null)
        {
            List<Contact> contacts = [SELECT FkUser__c , Genesys_Interaction_Id__c FROM Contact WHERE Id = :contactId];
            if(!contacts.isEmpty() && contacts[0].FkUser__c != null)
            {
                List<Customer_Login__c> customerLogins = [SELECT Id , Primary_Contact__c FROM Customer_Login__c WHERE Customer_ID__c = :contacts[0].FkUser__c];
                if(!customerLogins.isEmpty())
                {
                    primaryContactId = customerLogins[0].Primary_Contact__c;
                    if(contacts[0].Genesys_Interaction_Id__c != null)
                    {
                        interactionId = contacts[0].Genesys_Interaction_Id__c;
                        
                    }
                    else
                    {
                        iadMessages.add(IADMessageFactory.createMessage('error' , 'Genesys Activity Not Found')); 
                    }
                }
                else
                {
                      iadMessages.add(IADMessageFactory.createMessage('error' , 'Can\'t find Primary Contact'));  
                }
            }
            else
            {
                 iadMessages.add(IADMessageFactory.createMessage('error' , 'Can\'t find Customer Login Id (FKUser) on Authorized Contact'));
            }
        }
    }


    public void transferTask()
    {
        Datetime startTime = system.now().addHours(-2);
        Datetime endTime = system.now();
        List<Task> tasks = [SELECT Id FROM Task WHERE whoId = :contactId AND CallObject = :interactionId  AND (CreatedDate >=: startTime and 
        				   CreatedDate <=: endTime) AND Subject != 'Case Activity' order by createddate desc];
        Savepoint sp = Database.setSavepoint();
        if(!tasks.isEmpty())
        {
            try
            {
                
                tasks[0].whoId = primaryContactId;
                update tasks;
                Contact theContact = new Contact(Id = primaryContactId , Genesys_Interaction_Id__c = interactionId);
                update theContact;
            }
            catch(DmlException dmlEx)
            {
                 Database.rollback(sp);
                 iadMessages.add(IADMessageFactory.createMessage('error' , 'Failed associating Genesys Activity to Primary Contact'));
            }

        }
    }


    public void openPrimaryContact()
    {
        if(primaryContactId != null && interactionId != null)
            transferTask();
    }
}