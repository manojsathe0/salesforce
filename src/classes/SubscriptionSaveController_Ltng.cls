/*
Subscription Save application.
Created by Artyom M.
Per Story: B-24904
*/


public without sharing class SubscriptionSaveController {
    private final static List<String> activeSubscriptionStatuses = new List<String>{'Active','Active Won\'t Renew','Pending'};
    
    
    @AuraEnabled
    public static List<SubscriptionItemWrapper> getRelatetOrderItems(Id contactId) {
        List<SubscriptionItemWrapper> subscriptionItems = new List<SubscriptionItemWrapper>();
    	List<Order_Item__c> orderItemListToreturn = new List<Order_Item__c>();
    	List<Order__c> allOrders = [SELECT Id , Name,  (Select Id, Name, Product__r.Name , Subscription_Cancellation_Date__c , Subscription_Start_Date__c , 
                                                    LZ_Order_Item_ID__c , Order__c, Subscription_Status__c , Subscription_End_Date__c FROM Order_Items__r WHERE Subscription_Status__c IN :activeSubscriptionStatuses order by Subscription_Status__c asc) FROM Order__c WHERE Contact__c = :contactId];
		for(Order__c theOrder : allOrders) {
			for(Order_Item__c theItem : theOrder.Order_Items__r) {
				if(theItem.Subscription_Status__c != null) {
					//orderItemListToreturn.add(theItem);
					subscriptionItems.add(new SubscriptionItemWrapper(theItem.Subscription_Start_Date__c , theItem.Subscription_End_Date__c , theOrder.Name , theItem.Subscription_Status__c , theItem.Product__r.Name, theItem.Order__c , theItem.LZ_Order_Item_ID__c , theItem.Id ));
				}
        	}
        }
        System.debug('orderItemListToreturn' + subscriptionItems.size());
        for (SubscriptionItemWrapper s : subscriptionItems) {
            System.debug('Prod Name : ' + s.productName);
        }
		return subscriptionItems;
    }
    
    
    public class SubscriptionItemWrapper {
        @AuraEnabled public Boolean isSelected{get;set;}
        @AuraEnabled public String subscriptionStartDate{get;set;}
        @AuraEnabled public String subscriptionEndDate{get;set;}
        @AuraEnabled public String parentOrderNumber{get;set;}
        @AuraEnabled public String susbcriptionStatus{get;set;}
        @AuraEnabled public String productName{get;set;}
        @AuraEnabled public Id orderId{get;set;}
        @AuraEnabled public String lzOrderItemId{get;set;}
        @AuraEnabled public Id itemId{get;set;}
        @AuraEnabled public String cancellationReason{get; set;}
        
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
    @AuraEnabled
    public static List<String> getCancellationReasons() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Order360__c.Reason_for_cancellation__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        options.add('--None--'); 
        for( Schema.PicklistEntry value : pickListValues) {
        	options.add(value.getValue());
        }
        
        return options;
    }
    
    @AuraEnabled
    public static void doSubmit(Id contactId, String selected) {
    	
    	List<SubscriptionItemWrapper> listToSave = (List<SubscriptionItemWrapper>)JSON.deserialize(selected, List<SubscriptionItemWrapper>.class);
    	
    	
    	System.debug('submit: ' + contactId);
    	//selectedSubscriptions = selected;
    	//System.debug('selectedSubscriptions' + selectedSubscriptions.size());
    	Contact theContact = new Contact();
    	List<Task> theTasks = new List<Task>();
        Datetime startTime = system.now().addDays(-1);
		Datetime endTime = system.now();
    	try {
    		theContact = [SELECT ID, Genesys_Interaction_Id__c  FROM Contact WHERE ID =: contactId LIMIT 1];
    		System.debug('theContact: ' + theContact);
    	}
    	catch (QueryException e) {
    		System.debug('QueryException: ' + e.getMessage());
    	}

        System.debug('found contact');
        
        if(theContact != null && theContact.Genesys_Interaction_Id__c != null) {
        	try {
        		System.debug('Searching for task');
        		theTasks = [SELECT Id , Contact_Status__c , Lead_Status__c , Call_Type__C , Description , Inbound_Outbound__c FROM Task WHERE CallObject =: theContact.Genesys_Interaction_Id__c 
                                 AND (CreatedDate >=: startTime and CreatedDate <=: endTime) and createdById =: UserInfo.getUserId() and Subject != 'Case Activity' order by createdDate desc LIMIT 1];
        	}
        	catch (QueryException e) {
    			System.debug('QueryException: ' + e.getMessage());
    		}
        	
		System.debug('is there task?: ' + theTasks.size());	            
        }
        if (!theTasks.isEmpty()) {
        	System.debug('found task');
        	Task theQueriedTask = theTasks[0];
        	theQueriedTask.Status = 'Completed';
			theQueriedTask.ActivityDate = Date.today();
			theQueriedTask.Commission_Eligible__c = true;
			theQueriedTask.Contact_Status__c = 'Contacted/Spoke - Commission Eligible';
			theQueriedTask.Is_Subscription_Activity__c  = true;
			try {
				Update theQueriedTask;
			}
			catch (QueryException e) {
				System.debug('QueryException: ' + e.getMessage());
			}
			
			
			theContact.Contact_Status__c = theQueriedTask.Contact_Status__c;
			theContact.ownerId  = UserInfo.getUserId();
            
            try {
				update theContact;
			}
			catch (QueryException e) {
				System.debug('QueryException: ' + e.getMessage());
			}
            
			
			createOrder360Records(theQueriedTask, listToSave);
   
        }
        
        
    	
    }
    
    
    @AuraEnabled
    public static Boolean checkForCall(Id contactId) {
    	Contact theContact = new Contact();
    	List<Task> theTasks = new List<Task>();
        Datetime startTime = system.now().addDays(-1);
		Datetime endTime = system.now();
    	try {
    		theContact = [SELECT ID,Genesys_Interaction_Id__c  FROM Contact WHERE ID =: contactId LIMIT 1];
    	}
    	catch (QueryException e) {
    		
    	}

        
        if(theContact != null && theContact.Genesys_Interaction_Id__c != null) {
        	try {
        		theTasks = [SELECT Id , Contact_Status__c , Lead_Status__c , Call_Type__C , Description , Inbound_Outbound__c FROM Task WHERE CallObject =: theContact.Genesys_Interaction_Id__c 
                                 AND (CreatedDate >=: startTime and CreatedDate <=: endTime) and createdById =: UserInfo.getUserId() and Subject != 'Case Activity' order by createdDate desc LIMIT 1];
        	}
        	catch (QueryException e) {
    			
    		}
        	
			            
        }
        System.debug('checkForCall is ' + theTasks.isEmpty());
        if (theTasks.isEmpty()) {
        	return false;    
        }
        else {
            return true;
        }
        
        
        
    }
    @AuraEnabled
    public static void createOrder360Records(Task taskToUse, List<SubscriptionItemWrapper> selected) {
    	List<SubscriptionItemWrapper> selectedSubscriptions = new List<SubscriptionItemWrapper>();
    	selectedSubscriptions = selected;
    	System.debug('createOrder360Records');
    	System.debug('taskToUse.Id + ' + taskToUse.Id);
    	List<Order_Matching_Activity__c> oMAs = new List<Order_Matching_Activity__c>();
    	try {
    		oMAs = [SELECT Id FROM Order_Matching_Activity__c WHERE Activity_SFDC_Id__c = :taskToUse.Id];
    	}
    	catch(QueryException e) {
    		System.debug('QueryException: ' + e.getMessage());
    	}
        System.debug('oMAs = ' + oMAs.size());
        List<Order360__c> order360ToCreate = new List<Order360__c>();
        
        if (!oMAs.isEmpty()) {
        	System.debug('starting OMA');
        	System.debug('selectedSubscriptions size: ' + selectedSubscriptions.size());
        	System.debug('selectedSubscriptions first: ' + selectedSubscriptions[0]);
        	
        	for(Order_Matching_Activity__c matchingActivity : oMAs) {
        		System.debug('First loop');
	            for(SubscriptionSaveController.SubscriptionItemWrapper theItemWrapper : selectedSubscriptions) { 
	            	System.debug('creating 360');
	                order360ToCreate.add(new Order360__c(LZ_Order_Item_Id__c = theItemWrapper.lzOrderItemId, 
	                                                     Parent_Order_Item__c = theItemWrapper.itemId, 
	                                                     Order_Matching_Activity__c = matchingActivity.Id, 
	                                                     Order__c = theItemWrapper.orderId,
	                                                     Reason_for_cancellation__c = theItemWrapper.cancellationReason));
	            }
	        }
        
        }
      
        
      System.debug('order360ToCreate = ' + order360ToCreate.size());
       if(!order360ToCreate.isEmpty())
            insert order360ToCreate;
    }
    
}