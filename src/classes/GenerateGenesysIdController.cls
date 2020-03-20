public with sharing class GenerateGenesysIdController
{    
         
    public PageReference generateId()
    {
        String theId =  ApexPages.currentPage().getParameters().get('id');
        if(theId != null && theId != '')
        {
            Task theTask = new Task();
            theTask.Subject = 'Voice-Inbound Dial';
            theTask.Type = 'Call';
            theTask.Inbound_Outbound__c = 'Inbound';
            theTask.Status = 'Completed';
            theTask.whoId = theId;
            insert theTask;
            theTask.CallObject = theTask.Id;
            update theTask;
           
                if(theId.startsWith('003'))
                {
                    Contact theContact = new Contact (Id = theId);
                    theContact.Genesys_Interaction_Id__c = theTask.CallObject;
                   
                    update theContact;
                }
                else if(theId.startsWith('00Q'))
                {
                    Lead theLead = new Lead(Id = theId);
                    theLead.Genesys_Interaction_Id__c = theTask.CallObject;
                   
                    update theLead;
                }
        }
        return null;
    }
}