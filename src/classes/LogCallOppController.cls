public without sharing class LogCallOppController {
  final static String QUALIFIED_INTERESTED = 'Qualified - Interested';
  public Task theTask {get; set;}
  public String lastError {get; set;}
  ApexPages.StandardController theController;
  
  public Id oppId;
  public Id cntId;
  public Opportunity theOpp;
  public Contact theParentCnt;
  public LogCallOppController(ApexPages.StandardController controller)  {
  	System.Debug('LogCallOppController STARTED');
    theController = controller;
    theTask = new Task();
    oppId = theController.getRecord().Id;    
    lastError = '';
    system.debug(theTask);   
    lastError = '';
    
  }
  
   public PageReference createTask() {
       try {
            Datetime startTime = system.now().addDays(-1);
            Datetime endTime = system.now();
            
            List<Task> theTasks = new List<Task>();
            
            theOpp = [SELECT ID, Contact__c FROM Opportunity WHERE ID =: oppId LIMIT 1];
            System.Debug('theOpp = ' + theOpp);
            theParentCnt = [SELECT Id, Genesys_Interaction_Id__c FROM Contact WHERE Id = :theOpp.Contact__c];
            cntId = theParentCnt.Id;
            system.debug(theParentCnt);
            
            if(theParentCnt.Genesys_Interaction_Id__c != null) {
            	theTasks = [SELECT Id, Contact_Status__c , Call_Type__C , Description , Inbound_Outbound__c FROM Task WHERE CallObject =: theParentCnt.Genesys_Interaction_Id__c
                          AND (CreatedDate >=: startTime and CreatedDate <=: endTime)  AND Subject != 'Case Activity' AND createdById =: UserInfo.getUserId() order by createdDate desc LIMIT 1];
            }
              
            Task theQueriedTask;
            if(theTasks.size() != 0)
                theQueriedTask = theTasks[0];
            system.debug(theQueriedTask);
          if(theQueriedTask != null)
          {
            theQueriedTask.Status = 'Completed';
            theQueriedTask.ActivityDate = Date.today();
            theQueriedTask.WhoId = theParentCnt.Id;
            theQueriedTask.WhatId = oppId;
           
            theQueriedTask.RecordTypeId = LogCallContactController.salesTaskRecordTypeId;
            theQueriedTask.Contact_Status__c = theTask.Contact_Status__c;
            theQueriedTask.Inbound_Outbound__c = theTask.Inbound_Outbound__c;
            theQueriedTask.Description = theTask.Description;
            theQueriedTask.Reason_For_Contact__c = theTask.Reason_For_Contact__c;

			if (theQueriedTask.Reason_For_Contact__c == 'Transfer') {
				theQueriedTask.Other_Reason__c = null;
				theQueriedTask.Reason_For_Transfer__c = theTask.Reason_For_Transfer__c;
			}
			else
			if (theQueriedTask.Reason_For_Contact__c == 'Other') {
				theQueriedTask.Reason_For_Transfer__c = null;
				theQueriedTask.Other_Reason__c = theTask.Other_Reason__c;
			}
			else {
				theQueriedTask.Other_Reason__c = null;
				theQueriedTask.Reason_For_Transfer__c = null;
			}

            update theQueriedTask;
    
            theOpp.Contact_Status__c = theTask.Contact_Status__c;
            List<Task> tasks = [SELECT Id, Commission_Eligible__c FROM Task WHERE Id = :theQueriedTask.Id];
            if(!tasks.isEmpty())
            {
              if(tasks[0].Commission_Eligible__c)
              {
                theOpp.ownerId  = UserInfo.getUserId();
              }
                          
            }
     
            update theOpp;
            
            theQueriedTask = new Task();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Activity Logged'));
          } 
          else
          {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot Log activity at this time.'));
          }
             
        } catch(System.Exception ex){
           lastError = ex.getMessage();
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, lastError));
        }
         return null;
      }

    public PageReference createEmailTask() {
       try {
            theTask.Status = 'Completed';
            theTask.ActivityDate = Date.today();
            theTask.WhoId = cntId;
            theTask.WhatId = oppId;
            theTask.Subject = 'Activity Now';
            theTask.Type = 'Email';
            theTask.RecordTypeId = LogCallContactController.salesTaskRecordTypeId;
            insert theTask;
    
            Opportunity  theOpp = new Opportunity(Id = oppId);
            theOpp.Contact_Status__c = theTask.Contact_Status__c;

            List<Task> tasks = [SELECT Id, Commission_Eligible__c FROM Task WHERE Id = :theTask.Id];
            if(!tasks.isEmpty())
            {
              if(tasks[0].Commission_Eligible__c)
              {
                theOpp.ownerId  = UserInfo.getUserId();
              }
                          
            }
            
            update theOpp;
            
            theTask = new Task();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Activity Logged'));
            
        } catch(System.Exception ex){
           lastError = ex.getMessage();
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, lastError));
        }
        return null;
     }    
}