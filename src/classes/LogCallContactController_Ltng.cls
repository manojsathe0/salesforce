/*
Log a Call for Opps and Lead, Ltng version.
Created by Artyom M.
Per Story: B-25879

*/

public without sharing class LogCallContactController_Ltng {
	
	@AuraEnabled
	public static List<String> getReasonForContactValues() {
		List<String> options = new List<String>();
		Schema.DescribeFieldResult fieldResult = Task.Reason_For_Contact__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        options.add('--None--'); 
        /*
        for(Schema.PicklistEntry value : pickListValues) {
            options.add(value.getValue());
        }
        */
        options.add('Transfer');
        options.add('Other');
        return options;
	}
	
    @AuraEnabled
	public static List<String> getReasonForTransferValues() {
		List<String> options = new List<String>();
		Schema.DescribeFieldResult fieldResult = Task.Reason_For_Transfer__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        options.add('--None--');
        /*
        for(Schema.PicklistEntry value : pickListValues) {
            options.add(value.getValue());
        }
        */
        options.add('Transfer to CC');
        options.add('Transfer to Hybrid');
        options.add('Transfer to SET');
        options.add('Transfer to PRT');
        options.add('Transfer to N-Able');
        options.add('Transfer to LifePlan');
        return options;
	}
	
	@AuraEnabled
	public static String createTask(Id contactId, String reasonForContact, String reasonForTransfer, String otherReason, String description) {
		String lastError;
        Boolean cancellationError = false;
        Datetime startTime = system.now().addDays(-1);
        Datetime endTime = system.now();
        List<Task> theTasks = new List<Task>();
        Contact theContact;
        try {
           	theContact = [SELECT ID, Genesys_Interaction_Id__c  FROM Contact WHERE ID =: contactId LIMIT 1];
            system.debug(theContact.Genesys_Interaction_Id__c);
                    
			if(theContact.Genesys_Interaction_Id__c != null) {
				theTasks = [SELECT Id , Contact_Status__c , Lead_Status__c , Call_Type__C , Description , Inbound_Outbound__c FROM Task WHERE CallObject =: theContact.Genesys_Interaction_Id__c 
                                 AND (CreatedDate >=: startTime and CreatedDate <=: endTime) and createdById =: UserInfo.getUserId() and Subject != 'Case Activity' order by createdDate desc LIMIT 1];
			}
                      
			Task theQueriedTask;
            if(theTasks.size() != 0) {
            	theQueriedTask = theTasks[0];
            }

			system.debug(theQueriedTask);
            if(theQueriedTask != null) {
            	theQueriedTask.Status = 'Completed';
                theQueriedTask.ActivityDate = Date.today();
                theQueriedTask.WhoId = contactId;
                        
                //theTask.Reason_For_Contact__c = theTask.Reason_For_Contact_Cnt__c;
                //theTask.Reason_For_Transfer__c = theTask.Reason_For_Transfer_Cnt__c;
                        
                theQueriedTask.Reason_For_Contact__c = reasonForContact;
                        
                       

                theQueriedTask.RecordTypeId = LogCallContactControllerPilot.salesTaskRecordTypeId;
                        
				theQueriedTask.Description = description;
                        
                    	
                if (theQueriedTask.Reason_For_Contact__c == 'Transfer') {
					theQueriedTask.Other_Reason__c = null;
					theQueriedTask.Reason_For_Transfer__c = reasonForTransfer;
				}
				else
				if (theQueriedTask.Reason_For_Contact__c == 'Other') {
					theQueriedTask.Reason_For_Transfer__c = null;
					theQueriedTask.Other_Reason__c = otherReason;
				}
				else {
					theQueriedTask.Other_Reason__c = null;
					theQueriedTask.Reason_For_Transfer__c = null;
				}
                    	
                    	
                Update theQueriedTask;
                        

    
				return 'Activity Logged';

                        
			}
            else {
            	throw new AuraHandledException('Cannot Log activity at this time.');
			}
                

       
               
                       
                
		} 
        catch(System.Exception ex) {
			lastError = ex.getMessage();
            throw new AuraHandledException(lastError + ' ' + theTasks);
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
    
}