public with sharing class VerifyCallController {
    
    public Task theTask {get; set;}
    public String lastError {get; set;}
    ApexPages.StandardController theController;
    Id contactId;
    public String customerId{get;set;}
    public String callId{get;set;}
    public Boolean isCallVerified{get;set;}
    public List<IADMessage> iadMessages{get;set;}
    
    public VerifyCallController (ApexPages.StandardController controller) 
    {
        isCallVerified = false;
        theController = controller;
        contactId = theController.getRecord().Id;       
        lastError = '';
        populateGenesysTask();
        iadMessages = new List<IADMessage>();
        
      
    }
   
     
     public PageReference verifyCustomer()
     {
       iadMessages.clear();
       try 
       {
            populateGenesysTask();
            if(theTask != null)
            {
                theTask.Is_Customer_Verified__c = true;
                theTask.Date_Time_Customer_Verification__c = DateTime.now();
                update theTask;
                isCallVerified = true;
                
            }    
            else
            {
              
               iadMessages.add(IADMessageFactory.createMessage('error' , 'Can\'t verify Call.No Activity Found'));                   
            }
        }
        catch(System.Exception ex){
           lastError = ex.getMessage();
          
           iadMessages.add(IADMessageFactory.createMessage('error' , lastError));                   
        }
        return null;
        
    }
    
    public void populateGenesysTask()
    {
        List<Contact> contacts = [SELECT Id, Genesys_Interaction_Id__c, FkUser__c FROM Contact WHERE Id =:contactId];
        customerId = contacts[0].FkUser__c;
        Datetime startTime = system.now().addHours(-2);
        Datetime endTime = system.now();
        if(contacts[0].Genesys_Interaction_Id__c != null && contacts[0].Genesys_Interaction_Id__c != '')
        { 
            
            List<Task> theTasks = [SELECT Id ,Is_Customer_Verified__c , CallObject   FROM Task WHERE CallObject = :contacts[0].Genesys_Interaction_Id__c
            AND (CreatedDate >=: startTime and CreatedDate <=: endTime) AND Subject != 'Case Activity' order by createddate desc];
            if(!theTasks.isEmpty())
            {
                theTask = theTasks[0];
                callId = theTasks[0].CallObject;
                for(Task theTask : theTasks)
                {
                    if(theTask.Is_Customer_Verified__c)
                        isCallVerified = true;        
                }
            }
        } 
    }  
    
      
}