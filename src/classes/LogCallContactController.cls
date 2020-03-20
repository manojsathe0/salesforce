public without sharing class LogCallContactController {
 
    public Task theTask {get; set;}
    public String lastError {get; set;}
    ApexPages.StandardController theController;
    public Id contactId;
    public Contact theContact;
    public List<SubscriptionItemWrapper> selectedSubscriptions{get;set;}
    public Boolean isSaved{get;set;}
    public final static List<String> activeSubscriptionStatuses = new List<String>{'Active','Active Won\'t Renew','Pending'};
    public Boolean allowSubscriptionSave{get;set;}
    //padma @B-25752
    public Boolean getIsClassic() {
    	return (UserInfo.getUiThemeDisplayed() == 'Theme3');
    }
    public LogCallContactController(ApexPages.StandardController controller) 
    {
        theController = controller;
        theTask = new Task();
        contactId = theController.getRecord().Id;    
        lastError = '';
        system.debug(theTask);   
        lastError = '';
        isSaved = false;
        allowSubscriptionSave = false;
        List<Team_Management__c> teamManagements = [SELECT Id ,Allow_Subscription_Save__c  FROM Team_Management__c WHERE User__c = :UserInfo.getUserId()];    
        if(!teamManagements.isEmpty())
        {
            if(teamManagements[0].Allow_Subscription_Save__c)
                allowSubscriptionSave = true;
        }
    }
    
     public PageReference createTask()
     {
           selectedSubscriptions = new List<SubscriptionItemWrapper>();
           Boolean cancellationError = false;
           try 
           {
            
                Boolean isSubscriptinItemSelected = false;
                for(SubscriptionItemWrapper theWrapper: subscriptionItems)
                {
                    if(theWrapper.isSelected)
                    {
                        if(theWrapper.cancellationReason != '--None--')
                        {
                           isSubscriptinItemSelected = true;
                           selectedSubscriptions.add(theWrapper); 
                        }
                         else
                        {
                            cancellationError = true;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select the reason for cancellation'));
                            break;
                        }
                    }
                }
                
                if(!cancellationError)
                {        
                    if(theTask.Is_Subscription_Activity__c && !isSubscriptinItemSelected)
                    {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select at least one subscription'));
                            return null;
                    }
                    else if(isSubscriptinItemSelected && !theTask.Is_Subscription_Activity__c)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select if it is Subscription Save?'));
                        return null;
                    }
                    
                    theContact = [SELECT ID,Genesys_Interaction_Id__c  FROM Contact WHERE ID =: contactId LIMIT 1];
                    system.debug(theContact.Genesys_Interaction_Id__c);
                     
                    Datetime startTime = system.now().addDays(-1);
                    Datetime endTime = system.now();
                    List<Task> theTasks = new List<Task>();
                   
                    
                    if(theContact.Genesys_Interaction_Id__c != null)
                      theTasks = [SELECT Id , Contact_Status__c , Lead_Status__c , Call_Type__C , Description , Inbound_Outbound__c FROM Task WHERE CallObject =: theContact.Genesys_Interaction_Id__c 
                                 AND (CreatedDate >=: startTime and CreatedDate <=: endTime) and createdById =: UserInfo.getUserId() and Subject != 'Case Activity' order by createdDate desc LIMIT 1];
                    Task theQueriedTask;
                    if(theTasks.size() != 0)
                        theQueriedTask = theTasks[0];
                    system.debug(theQueriedTask);
                    if(theQueriedTask != null)
                    {
                        theQueriedTask.Status = 'Completed';
                        theQueriedTask.ActivityDate = Date.today();
                        theQueriedTask.WhoId = contactId;
                       
                       
                        theQueriedTask.RecordTypeId = salesTaskRecordTypeId;
                        theQueriedTask.RecordTypeId = LogCallContactController.salesTaskRecordTypeId;
                        theQueriedTask.Contact_Status__c = theTask.Contact_Status__c;
                        theQueriedTask.Lead_Status__c = theTask.Lead_Status__c;
                        theQueriedTask.Inbound_Outbound__c = theTask.Inbound_Outbound__c;
                        theQueriedTask.Description = theTask.Description;
                        theQueriedTask.Is_Subscription_Activity__c  = theTask.Is_Subscription_Activity__c;
                    
                        Update theQueriedTask;
                        
                        theContact.Contact_Status__c = theTask.Contact_Status__c;
                        theContact.Lead_Status__c = theTask.Lead_Status__c;
                        List<Task> tasks = [SELECT Id , Lead_Status__c , Commission_Eligible__c FROM Task WHERE Id = :theQueriedTask.Id];
                        if(!tasks.isEmpty())
                        {
                          if(tasks[0].Commission_Eligible__c)
                          {
                            theContact.ownerId  = UserInfo.getUserId();
                            theContact.Lead_Status__c = tasks[0].Lead_Status__c;
                            if(isSubscriptinItemSelected) 
                                createOrder360Records(tasks[0]);     
                          }
                                      
                        }
                        update theContact;
    
                        theTask = new Task();
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Activity Logged'));
                        isSaved = true;
                    }
                      else
                      {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot Log activity at this time.'));
                      }
                   
                }
            } 
            catch(System.Exception ex)
            {
               lastError = ex.getMessage();
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, lastError));
            }
        return null;
     }

    public static Id salesTaskRecordTypeId
    {
        get
        {
            if(salesTaskRecordTypeId == null)
            {
                List<RecordType> recordTypes = [SELECT Id , DeveloperName FROM RecordType WHERE sObjectType = 'Task' AND DeveloperName = 'Sales_Task'];
                if(!recordTypes.isEmpty())
                    salesTaskRecordTypeId = recordTypes[0].Id;
            }
            
            return salesTaskRecordTypeId;
        }
        set;
    }
    
   public PageReference createEmailTask()
   {
       selectedSubscriptions = new List<SubscriptionItemWrapper>();
       Boolean cancellationError = false;
       try 
       {
            Boolean isSubscriptinItemSelected = false;
            for(SubscriptionItemWrapper theWrapper: subscriptionItems)
            {
                if(theWrapper.isSelected)
                {
                    if(theWrapper.cancellationReason != '--None--')
                    {
                       isSubscriptinItemSelected = true;
                       selectedSubscriptions.add(theWrapper); 
                    }
                     else
                    {
                        cancellationError = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select the reason for cancellation'));
                        break;
                    }
                }
            }
            if(!cancellationError)
            {
                if(theTask.Is_Subscription_Activity__c && !isSubscriptinItemSelected)
                {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select at least one subscription'));
                        return null;
                }
                else if(isSubscriptinItemSelected && !theTask.Is_Subscription_Activity__c)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select if it is Subscription Save?'));
                    return null;
                }
                theTask.Status = 'Completed';
                theTask.ActivityDate = Date.today();
                theTask.WhoId = contactId;
                theTask.Subject = 'Activity Now';
                theTask.Type = 'Email';
               
                theTask.RecordTypeId = salesTaskRecordTypeId;
                insert theTask;
                
                //Workflow rules marks the task as commission eligible
                List<Task> queriedTasks = [SELECT Id , Commission_Eligible__c FROM Task WHERE Id= :theTask.Id];
                //only if it is commission eligble it can be subscription save?
                if(!queriedTasks.isEmpty() && queriedTasks[0].Commission_Eligible__c )
                {
                    
                     if(isSubscriptinItemSelected) 
                        createOrder360Records(theTask);
                }
                Contact theContact = new Contact(Id = contactId);
                theContact.Contact_Status__c = theTask.Contact_Status__c;
                theContact.Lead_Status__c = theTask.Lead_Status__c;
                List<Task> tasks = [SELECT Id , Lead_Status__c , Commission_Eligible__c FROM Task WHERE Id = :theTask.Id];
                if(!tasks.isEmpty())
                {
                  if(tasks[0].Commission_Eligible__c)
                  {
                    theContact.ownerId  = UserInfo.getUserId();
                    theContact.Lead_Status__c = tasks[0].Lead_Status__c;  
                  }
                              
                }
                update theContact;

                theTask = new Task();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Activity Logged'));
                isSaved = true;
           } 
        } catch(System.Exception ex){
           lastError = ex.getMessage();
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, lastError));
        }
        return null;
    }
    
    public List<SubscriptionItemWrapper> SubscriptionItems
    {
        get
        {
            system.debug('SubscriptionItems :'+SubscriptionItems);
            
            if(subscriptionItems == null)
            {
                
                subscriptionItems = new List<SubscriptionItemWrapper>();
                List<Order__c> allOrders = [SELECT Id , Name,  (Select Id , Product__r.Name , Subscription_Cancellation_Date__c , Subscription_Start_Date__c , 
                                                    LZ_Order_Item_ID__c , Order__c , Subscription_Status__c , Subscription_End_Date__c FROM Order_Items__r WHERE Subscription_Status__c IN :activeSubscriptionStatuses order by Subscription_Status__c asc) FROM Order__c WHERE Contact__c = :contactId];
               
                for(Order__c theOrder : allOrders)
                {
                    for(Order_Item__c theItem : theOrder.Order_Items__r)
                    {
                        if(theItem.Subscription_Status__c != null)
                        {
                            subscriptionItems.add(new SubscriptionItemWrapper(theItem.Subscription_Start_Date__c , theItem.Subscription_End_Date__c , theOrder.Name , theItem.Subscription_Status__c , theItem.Product__r.Name, theItem.Order__c , theItem.LZ_Order_Item_ID__c , theItem.Id ));
                        }
                    }
                }
               
            }
           
            return subscriptionItems;
        }
        set;
         
    }
    
    public void createOrder360Records(Task taskToUse)
    {
        List<Order_Matching_Activity__c> oMAs = [SELECT Id FROm Order_Matching_Activity__c WHERE Activity_SFDC_Id__c = :taskToUse.Id];
        List<Order360__c> order360ToCreate = new List<Order360__c>();
      
        for(Order_Matching_Activity__c matchingActivity : oMAs)
        {
            for(SubscriptionItemWrapper theItemWrapper : selectedSubscriptions)
            { 
                order360ToCreate.add(new Order360__c(LZ_Order_Item_Id__c = theItemWrapper.lzOrderItemId, 
                                                     Parent_Order_Item__c = theItemWrapper.itemId, 
                                                     Order_Matching_Activity__c = matchingActivity.Id, 
                                                     Order__c = theItemWrapper.orderId,
                                                     Reason_for_cancellation__c = theItemWrapper.cancellationReason));
            }
        }
        
      
       if(!order360ToCreate.isEmpty())
            insert order360ToCreate;
    }
    
    public class SubscriptionItemWrapper
    {
        
        
        public Boolean isSelected{get;set;}
        public String subscriptionStartDate{get;set;}
        public String subscriptionEndDate{get;set;}
        public String parentOrderNumber{get;set;}
        public String susbcriptionStatus{get;set;}
        public String productName{get;set;}
        public Id orderId{get;set;}
        public String lzOrderItemId{get;set;}
        public Id itemId{get;set;}
        public String cancellationReason{get; set;}
        
        public SubscriptionItemWrapper(DateTime theSubscriptionStartDate , DateTime theSubscriptionEndDate , String theParentOrderNumber , String theSusbcriptionStatus , String theProductName , Id theOrderId , String theLZOrderItemId , Id theItemId)
        {
            if(theSubscriptionStartDate != null)
            {
                subscriptionStartDate = (Date.newInstance(theSubscriptionStartDate.year() , theSubscriptionStartDate.month() , theSubscriptionStartDate.day())).format();
            }
            if(theSubscriptionEndDate!= null)
            {
                subscriptionEndDate = (Date.newInstance(theSubscriptionEndDate.year() , theSubscriptionEndDate.month() , theSubscriptionEndDate.day())).format();
            }
            parentOrderNumber = theParentOrderNumber;
            susbcriptionStatus = theSusbcriptionStatus;
            productName = theProductName;
            isSelected = false;
            orderId = theOrderId;
            lzOrderItemId = theLZOrderItemId;
            itemId = theItemId;
            
        } 
    }

    public List<selectOption> getCancellationReasons()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult fieldResult = Order360__c.Reason_for_cancellation__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        options.add(new selectOption('--None--','--None--')); 
        for( Schema.PicklistEntry value : pickListValues)
           {
              options.add(new SelectOption(value.getLabel(), value.getValue()));
           }       
        return options;
    }    
      
}