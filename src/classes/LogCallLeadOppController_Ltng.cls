/*
Log a Call for Opps and Lead, Ltng version.
Created by Artyom M.
Per Story: B-25879

*/
public without sharing class LogCallLeadOppController_Ltng {
	
	@AuraEnabled
	public static List<String> getContactStatusValues() {
		List<String> options = new List<String>();
		Schema.DescribeFieldResult fieldResult = Task.Contact_Status__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        options.add('--None--');
        /*
        for(Schema.PicklistEntry value : pickListValues) {
            options.add(value.getValue());
        }
        */
        options.add('Contacted/Spoke - Commission Eligible');
        options.add('VM - Left Voicemail Message');
        options.add('NM - No Voicemail Message Left');
        options.add('Contacted/Spoke - Ineligible');
        options.add('Chat - Commission Eligible');
        options.add('Email - Commission Eligible');
        options.add('Bad Number');
		options.add('SNE');
		options.add('Potential Equip Customer');
        
        return options;
	}
	
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
        options.add('Questionnaire Inquiries');
        options.add('Product/Service Overview');
        options.add('Pricing Questions/Quotes');
        options.add('Contacted/Spoke - Ineligible');
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
        options.add('Transfer to Sales-IP');
        options.add('Transfer to Sales-OB');
        options.add('Transfer to Sales-Chat');
        options.add('Transfer to PRT');
        options.add('Transfer to N-Able');        
        options.add('Transfer to LifePlan');
        
        return options;
	}
    @AuraEnabled
    public static String createTaskOpp(Id oppId, String contactStatus, String reasonForContact, String reasonForTransfer, String otherReason, String description) {
        //Task theTask;
        Id cntId;
        Opportunity theOpp;
        Contact theParentCnt;
        String lastError;
        Datetime startTime = system.now().addDays(-1);
        Datetime endTime = system.now();
            
        List<Task> theTasks = new List<Task>();
        try {
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
            theQueriedTask.Contact_Status__c = contactStatus;
            //theQueriedTask.Inbound_Outbound__c = theTask.Inbound_Outbound__c;
            theQueriedTask.Description = description;
            theQueriedTask.Reason_For_Contact__c = reasonForContact;

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

            update theQueriedTask;
    
            theOpp.Contact_Status__c = contactStatus;
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
            return 'Activity Logged';
          } 
          else
          {
              throw new AuraHandledException('Cannot Log activity at this time.');
          }
             
        } catch(System.Exception ex){
           lastError = ex.getMessage();
           throw new AuraHandledException(lastError + theTasks);
        }
    }
    @AuraEnabled
    public static String createTaskLead(Id leadId, String contactStatus, String reasonForContact, String reasonForTransfer, String otherReason, String description) {
        //Task theTask;
  		String lastError;
  		Lead theLead;
        Datetime startTime = system.now().addDays(-1);
        Datetime endTime = system.now();
        List<Task> theTasks = new List<Task>();
        try 
        {
            
            theLead = [SELECT ID,Genesys_Interaction_Id__c  FROM Lead WHERE ID =: leadId LIMIT 1];
            system.debug(theLead.Genesys_Interaction_Id__c);
            if(theLead.Genesys_Interaction_Id__c != null)
              theTasks = [SELECT Id, Contact_Status__c , Call_Type__C , Description , Inbound_Outbound__c FROM Task WHERE CallObject =: theLead.Genesys_Interaction_Id__c
                          AND (CreatedDate >=: startTime and CreatedDate <=: endTime)  AND Subject != 'Case Activity' AND createdById =: UserInfo.getUserId() order by createdDate desc LIMIT 1];
            Task theQueriedTask;
            if(theTasks.size() != 0)
                theQueriedTask = theTasks[0];
            system.debug(theQueriedTask);
          if(theQueriedTask != null)
          {
            theQueriedTask.Status = 'Completed';
            theQueriedTask.ActivityDate = Date.today();
            theQueriedTask.WhoId = leadId;
           
            theQueriedTask.RecordTypeId = LogCallContactController.salesTaskRecordTypeId;
            theQueriedTask.Contact_Status__c = contactStatus;
            //theQueriedTask.Inbound_Outbound__c = theTask.Inbound_Outbound__c;
            theQueriedTask.Description = description;
            theQueriedTask.Reason_For_Contact__c = reasonForContact;

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
    
            theLead.Lead_Call_Status__c = contactStatus;
            List<Task> tasks = [SELECT Id, Commission_Eligible__c FROM Task WHERE Id = :theQueriedTask.Id];
            if(!tasks.isEmpty())
            {
              if(tasks[0].Commission_Eligible__c)
              {
                theLead.ownerId  = UserInfo.getUserId();
              }
                          
            }
     
            update theLead;
            
            theQueriedTask = new Task();
            return 'Activity Logged';
          } 
          else
          {
              throw new AuraHandledException('Cannot Log activity at this time.');
          }
             
        } catch(System.Exception ex){
           lastError = ex.getMessage();
            throw new AuraHandledException(lastError + theLead.Genesys_Interaction_Id__c);
        }
    }
}