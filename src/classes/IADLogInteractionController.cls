public with sharing class IADLogInteractionController
{
    
    public Contact theContact{get;set;}
    public Task theTask {get; set;}
    public Id theId;
    public Boolean isTransfer{get;set;}
    public List<IADMessage> iadMessages{get;set;}
    final static String TRANSFER = 'Transfer';
    public final static String Other = 'Other';
    public Integer logInteractionDays{get;set;}
    public IADLogInteractionController(ApexPages.StandardController stdController) 
    {
        theId  = stdController.getId();
        theTask = new Task();
        iadMessages = new List<IADMessage>();
        logInteractionDays = Integer.valueOf(UtilityLibrary.getConfig().Log_Interaction_Days_Threshold__c);
    }
    
    
    public PageReference logInteraction()
    {
        iadMessages.clear(); //clear the message
        if(theTask.Reason_For_Contact__c == TRANSFER  && theTask.Reason_For_Transfer__c == null)
        {       
            theTask.Reason_For_Transfer__c.addError('Required : You must enter a value');
            return null;
        }
        else if(theTask.Reason_For_Contact__c != TRANSFER)
        {
            theTask.Reason_For_Transfer__c = null;
        }
        
        if(theTask.Reason_For_Contact__c == OTHER &&  (theTask.Description == '' || theTask.Description == null))
        {
            iadMessages.add(IADMessageFactory.createMessage('error' , 'Required : You must add comments')); 
            return null;
        }
        Datetime startTime = system.now().addDays(logInteractionDays);
        Datetime endTime = system.now();
        List<Task> theTasks = new List<Task>();
        theContact = [SELECT ID,Genesys_Interaction_Id__c  FROM Contact WHERE Id = :theId LIMIT 1];
        if(theContact.Genesys_Interaction_Id__c != null)
          theTasks = [SELECT Id , Description , Reason_For_Contact__c FROM Task WHERE CallObject =: theContact.Genesys_Interaction_Id__c 
                     AND (CreatedDate >=: startTime and CreatedDate <=: endTime) AND Subject != 'Case Activity' order by createdDate desc LIMIT 1];
        Task theQueriedTask;
        if(theTasks.size() != 0)
        {
        
            theQueriedTask = theTasks[0];
            theQueriedTask.Status = 'Completed';
            theQueriedTask.ActivityDate = Date.today();
            theQueriedTask.WhoId = theContact.Id;
            theQueriedTask.Reason_For_Contact__c = theTask.Reason_For_Contact__c;
            theQueriedTask.Description = theTask.Description;
            theQueriedTask.Reason_For_Transfer__c = theTask.Reason_For_Transfer__c;
            try
            {
                update theQueriedTask;
                             
                iadMessages.add(IADMessageFactory.createMessage('success' , 'Interaction Logged!!'));    
                theTask = new Task();
            }
            catch(DMLEXception dmlEx)
            {
                if(UtilityLibrary.sendEmail)
                    SendExceptionEmail.sendExceptionEmail(dmlEx , 'IAD Exception');
                 iadMessages.add(IADMessageFactory.createMessage('error' , 'Failed Logging Interaction!!'));    
                
            }
        }
        else
        {
            
             iadMessages.add(IADMessageFactory.createMessage('error' , 'No Interaction Available!!'));    
            
        }        
        return null;
    }
    
    public PageReference checIsTransfer()
    {
        isTransfer = false;
        if(theTask.Reason_For_Contact__c == 'Transfer')
            isTransfer = true;
        return null;
    }
    
}