public with sharing class EmailFunction {
    
    public static final String INTEGRATION_USER = 'Integration User';
    public static final String Start12am_End11pm_Schedule_Name = 'Start12am End11.45pm Schedule Record';
    public static final String SOBJECT_TYPE = 'Task';
    public static final String RECORDTYPE_DEVNAME = 'CC_Task';
    
    public void sendmail(String SUBJECT, String PLAIN_TEXT_BODY)
    {
        try{
            String toEmail = CaseService.EmailAddress;
            String[] toAddresses = new String[] {EmailAddress};
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject(SUBJECT);
            email.setPlainTextBody(PLAIN_TEXT_BODY);
            email.setToAddresses(toAddresses);
            Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
            
        }catch(Exception e){
            System.debug('Can not send email.');        
        }
        
    }
    
    public static String EmailAddress
    {
        get
        {
            if(EmailAddress == null)
            {
                Map<String,SalesforceTeamEmail__c> salesforceTeamEmails = SalesforceTeamEmail__c.getAll();
                if(!salesforceTeamEmails.isEmpty())
                {
                    EmailAddress = salesforceTeamEmails.get('Salesforce Team').Email__c;
                }
            }
            return EmailAddress;    
        }
    }
    
    public User emailFuncIntegrationUser
    {
        get
        {
            if(emailFuncIntegrationUser == null)
            {
                List<User> integrationUsers = [SELECT Id FROM User WHERE Name = :INTEGRATION_USER];
                if(!integrationUsers.isEmpty())
                {
                    emailFuncIntegrationUser = integrationUsers[0];
                }
            }
            
            return emailFuncIntegrationUser;
        }
        private set;
    }
    
    public static Id getRecordTypeId(String sObjectType, String developerName)
    {
        List<RecordType> recordTypes = [SELECT Id,Name,DeveloperName FROM RecordType WHERE sObjectType =: sObjectType AND DeveloperName =: developerName]; 
        Id recordTypeID;   
        if(!recordTypes.isEmpty())
        {
            recordTypeID = recordTypes[0].Id;
        }
        return recordTypeID;
    }
    
    public static Boolean checkLegallzoomEmail(String toAddresses)
    {
        Boolean isContainOtherEmail = false;
        if(toAddresses != '' && toAddresses != null)
        {
            String emailLegalzoom = '@legalzoom.com';
            List<String> toAddressesList = toAddresses.split(';');
            
            for(Integer i=0; i<toAddressesList.size(); i++)
            {
                if(!toAddressesList[i].contains(emailLegalzoom))
                {
                    //Update Respond Time
                    isContainOtherEmail = true;
                }
            }
        }
        else
        {
            return false;
        }
        return isContainOtherEmail;
    }
    
    public static void updateEmailToCaseTaskIncoming(String caseID)
    {
        List<Task> updateTaskList = new List<Task>();
        try
        {
            List<Task> taskList = [SELECT Id, Email_Responded_Time__c FROM Task WHERE WhatId =: caseID AND Email_Type__c = 'Incoming'];
            if(taskList.size() > 0)
            {
                for(Task task : taskList)
                {
                    if(task.Email_Responded_Time__c == null)
                    {
                        task.Email_Responded_Time__c = System.now();
                        updateTaskList.add(task);
                    }
                }
                update updateTaskList;
            }
        }
        catch(Exception ex)
        {
            System.debug('>>>>> updateEmailToCaseTaskIncoming Error Message : '+ex.getMessage());
        }
    }
    
    public static List<Task> createTask(String theSubject, String theDescription, String theEmailTemplateID, String theEmailTemplateName, String theEmailTemplateDeveloperName, String theEmailTemplateDescription, 
                                 String theEmailTemplateFolderId, String theFolderName, String theEmailType, DateTime theEmailRespondedTime, String theQueueName, String theEmailAction, String theParentID, String theWhoID, Boolean doInsert)
    {
        List<Task> createTaskList = new List<Task>();
        try
        {
            ID recordType_Task = EmailFunction.getRecordTypeId(SOBJECT_TYPE, RECORDTYPE_DEVNAME);
            String emailBody = '';
            //Email Body not over than 32000 characters
            if(theDescription != null)
            {
                //Remove HTML Tags
                emailBody = stripHTML(theDescription); 
                Long countChar_Body = emailBody.length();
                if(countChar_Body > 30000)
                {
                    emailBody = emailBody.substring(0, 30000);
                }
            }
            
            if(theEmailTemplateDescription != null)
            {
                Long countChar_Description = theEmailTemplateDescription.length();
                if(countChar_Description > 255)
                {
                    theEmailTemplateDescription = theEmailTemplateDescription.substring(0, 250);
                }
            }
            
            if(theWhoID!=null)
            {
                Task task = new Task (Type='Email',Status='Completed',Subject='Email:'+theSubject, Description = emailBody, Email_Template_ID__c = theEmailTemplateID, Email_Template__c = theEmailTemplateName ,
                                     Email_Template_Developer_Name__c = theEmailTemplateDeveloperName, Email_Template_Description__c = theEmailTemplateDescription , Email_Template_Folder_ID__c = theEmailTemplateFolderId , Email_Template_Folder_Name__c = theFolderName, 
                                     Email_Type__c = theEmailType , Email_Responded_Time__c = theEmailRespondedTime , CC_Queue__c = theQueueName , Email_Action__c = theEmailAction , WhatId = theParentID,ActivityDate=Date.today(),whoid=theWhoID);
                createTaskList.add(task);
            }
            else
            {
                Task task = new Task (Type='Email',Status='Completed',Subject='Email:'+theSubject , Description = emailBody, Email_Template_ID__c = theEmailTemplateID, Email_Template__c = theEmailTemplateName ,
                                     Email_Template_Developer_Name__c = theEmailTemplateDeveloperName, Email_Template_Description__c = theEmailTemplateDescription , Email_Template_Folder_ID__c = theEmailTemplateFolderId , Email_Template_Folder_Name__c = theFolderName,
                                     Email_Type__c = theEmailType , Email_Responded_Time__c = theEmailRespondedTime , CC_Queue__c = theQueueName , Email_Action__c = theEmailAction , WhatId = theParentID,ActivityDate=Date.today());
                createTaskList.add(task);
            }
            
            if(doInsert)
            {
                insert createTaskList;
            }
        }
        catch(Exception ex)
        {
            System.debug('>>>>> Error Message from create task : '+ ex.getMessage());
        }
        
        return createTaskList;
    }
    
    public static String stripHTML(String body)
    {
        String theBody = '';
        theBody = body.replaceAll('<[^>]+>',' ');
        theBody = theBody.replaceAll('&nbsp;',' '); 
        theBody = theBody.replaceAll('&#39;','\'');
        theBody = theBody.replaceAll('&ndash;',' - ');
        theBody = theBody.replaceAll('&copy;','©');
        
        return theBody;
    }
}