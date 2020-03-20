public with sharing class USPTOHandlerHelper 
{
    
    public final static String SIGNATURE_BASE_URL = 'http://teas.uspto.gov/submit250/sign.service?id=';
    public final static String PRIMARY_CONTACT = 'Primary Contact';
    public final static String AUTHORIZED_CONTACT = 'Authorized Contact';
    public final static String TM_FILING = 'IP Trademark Filing';
    
    private List<EmailTemplate> emailTemplateSnippets;
    public List<EmailMessage> emailMessagesToCreate;
    public List<Task> tasksToCreate;
    

    public USPTOHandlerHelper()
    {
        emailTemplateSnippets = new List<EmailTemplate>();
        emailMessagesToCreate = new List<EmailMessage>();
        tasksToCreate = new List<Task>();
        
    }

    public  Map<String, Id> getUserOrderNumberToContact(Set<String> userOrderNumbers , Map<String,Order__c> userOrderNumberToOrder)
    {
        Map<String,Id> userOrderNumberToContactId = new Map<String,Id>();
        List<Order__c> orders = [SELECT Id , Contact__c , Contact_Name__c , OrderID__c , Contact_Email__c , User_Order_ID__c  FROM Order__c WHERE User_Order_ID__c IN :userOrderNumbers];
        for(Order__c theOrder : orders)
        {
            userOrderNumberToOrder.put(theOrder.User_Order_ID__c , theOrder);
            if(theOrder.Contact__c != null)
                userOrderNumberToContactId.put(theOrder.User_Order_ID__c , theOrder.Contact__c);
        }
        return userOrderNumberToContactId;
    }

 


    public Map<String,Boolean> sendEmailToCustomer(Map<String,Order__c> userOrderNumberToOrder ,Map<String,USPTOEmailWrapper> userOrderNumberToFirstUSPTOEmailWrappers)
    {
        Map<String,Boolean> userOrderNumberToDeliveryStatus = new Map<String,Boolean>();
        System.debug('userOrderNumberToFirstUSPTOEmailWrappers '+userOrderNumberToFirstUSPTOEmailWrappers);
        if(userOrderNumberToFirstUSPTOEmailWrappers.size() < 10)
        {
            emailTemplateSnippets = [SELECT name,subject,folderid,body FROM EmailTemplate WHERE folder.name='Variable'];
            for(String userOrderNumber : userOrderNumberToFirstUSPTOEmailWrappers.keySet())
            {
                if(userOrderNumberToOrder.containsKey(userOrderNumber))
                {
                    Order__c theOrder = userOrderNumberToOrder.get(userOrderNumber);
                    USPTOEmailWrapper theUSPTOEmailWrapper = userOrderNumberToFirstUSPTOEmailWrappers.get(userOrderNumber);
                    System.debug('USPTO Email Wrapper '+theUSPTOEmailWrapper);
                    if(theUSPTOEmailWrapper.USPTOUniqueId != null)
                    {
                        String signatureURL = SIGNATURE_BASE_URL+theUSPTOEmailWrapper.USPTOUniqueId;
                        
                        System.debug('Contact Email '+theOrder.Contact_Email__c);
                        if(theOrder.Contact_Email__c != null)
                        {
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            String[] toAddresses = new String[] {theOrder.Contact_Email__c}; 
                            
                            mail.setToAddresses(toAddresses);
                             
                            mail.setReplyTo('tmfiling@legalzoom.com');
                    
                            List<OrgWideEmailAddress> org = [Select Id, DisplayName From OrgWideEmailAddress where DisplayName = 'LegalZoom Support'];
                            for(OrgWideEmailAddress m :org)
                            {
                                    mail.setOrgWideEmailAddressId(m.Id);
                            }

                            String subject;
                            if(theUSPTOEmailWrapper.trademarkName != null)
                                subject = 'SIGNATURE REQUIRED: LegalZoom Order# '+theOrder.OrderID__c+' '+theUSPTOEmailWrapper.trademarkName; 
                            else
                                subject = 'SIGNATURE REQUIRED: LegalZoom Order# '+theOrder.OrderID__c;
                            
                            mail.setSubject(subject);

                            String emailBody = getParsedEmailMessage(theOrder.Contact_Name__c , theOrder.Contact_Email__c , signatureURL);
                            
                            mail.setHtmlBody(emailBody);

                            List<Messaging.SendEmailResult> emailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            
                            for(Messaging.SendEmailResult emailResult : emailResults)
                            {
                                if(emailResult.isSuccess())
                                {
                                    userOrderNumberToDeliveryStatus.put(theOrder.User_Order_ID__c , emailResult.isSuccess());
                                    emailMessagesToCreate.add(getEmailMessage(subject , emailBody , theOrder.Contact_Email__c , theUSPTOEmailWrapper.caseId));
                                    tasksToCreate.add(getTaskToCreate(subject , theUSPTOEmailWrapper.caseId));
                                }
                        
                            }
                        }
                    }
                }
    
            }
        }
            return userOrderNumberToDeliveryStatus;
        
    }


    public String TMESigRequestTemplateHTML
    {
        get {
            if(TMESigRequestTemplateHTML == null) {
                if(TMESigRequestTemplateRecord != null) {           
                    TMESigRequestTemplateHTML = TMESigRequestTemplateRecord.HtmlValue;
                }
                else {
                    TMESigRequestTemplateHTML = '';
                }
            }
            return TMESigRequestTemplateHTML;
        }
        set;
    }


    public EmailTemplate TMESigRequestTemplateRecord
    {
        get {
            if(TMESigRequestTemplateRecord == null) {
                List<EmailTemplate> et = [SELECT Id , Body , Description , HtmlValue FROM EmailTemplate WHERE DeveloperName = 'TM_Esig_Request'];
                if(!et.isEmpty()) {
                    TMESigRequestTemplateRecord = et[0];
                }
            }
            return TMESigRequestTemplateRecord;
        }
        set;
    }


    public String getParsedEmailMessage(String contactName  , String contactEmail , String signatureURL)
    {
        String theTemplate;
        theTemplate = TMESigRequestTemplateHTML;
        signatureURL = '<a href=\"'+SignatureURL+'\">'+SignatureURL+'</a>';   
           
        if(contactName != null && contactName != '')
            theTemplate = theTemplate.replaceAll('\\{'+'!Contact.FirstName'+'\\}',contactName);
        if(signatureURL != null && signatureURL != '')
            theTemplate = theTemplate.replaceAll('\\{'+'!SignatureURL'+'\\}',signatureURL);
        if(contactEmail != null && contactEmail != '')
            theTemplate = theTemplate.replaceAll('\\{'+'!Contact.Email'+'\\}',contactEmail);
           
        String mergeFieldPopulatedTemplate = populateUserMergeFields(theTemplate);
        return mergeFieldPopulatedTemplate;
    }   


    public String populateUserMergeFields(String theTemplate)
    {
        if(theTemplate != null && theTemplate != '')
        {
           
            if(!emailTemplateSnippets.isEmpty())
            {           
                for(EmailTemplate e:emailTemplateSnippets)
                {                 
                    if(e.name!=null && e.body!=null) 
                    {                              
                        theTemplate = theTemplate.replaceAll('\\{' + '!' + e.name + '\\}',''+e.body);
                    }
                }  
            }
        }
       
        return theTemplate;
    }

    public List<EmailMessage> getUSPTOEmailMessages(Map<Id,EmailMessage> emailMessages)
    {
        Map<Id,List<Id>> caseIdToEmailMessageId = new Map<Id,List<Id>>();
        for(EmailMessage theMessage : emailMessages.values())
        {
            
            System.debug('Message Parent Id '+theMessage.parentId);
            System.debug('Message Incoming '+theMessage.Incoming);
            
                if(!caseIdToEmailMessageId.containsKey(theMessage.ParentId))
                    caseIdToEmailMessageId.put(theMessage.ParentId , new List<Id>());
                caseIdToEmailMessageId.get(theMessage.ParentId).add(theMessage.Id);
            
        }

        System.debug('Case Id to EmailMessageId '+caseIdToEmailMessageId);
        Map<Id,Case> theCases = new Map<Id,Case>([SELECT Id , Queue__c from Case WHERE Id IN :caseIdToEmailMessageId.keySet()]);
        System.debug('THE CASES '+theCases);
        List<EmailMessage> emailMessagesToConsider = new List<EmailMessage>();
        for(Id caseId : caseIdToEmailMessageId.keySet())
        {
            for(Id emailMessageId : caseIdToEmailMessageId.get(caseId))
            {
                Case theCase = theCases.get(caseId);
                if(theCase.Queue__c == TM_FILING)
                {
                    emailMessagesToConsider.add(emailMessages.get(emailMessageId)); 
                }   
            }
            
        }
        return emailMessagesToConsider;             

    }

    public Map<String,Case> getExistingUSPTOUniqueIdToCase(Set<String> usptoUniqueIds)
    {
        Map<String,List<Case>> usptoIdToCases = new Map<String,List<Case>>();
        Date fourteenDaysAgo = Date.today().addDays(-14);
        //Ideally there should be only 1 case per USPTO_Id
        for(Case theCase : [SELECT Id,USPTO_Id__c FROM Case WHERE USPTO_Id__c IN :usptoUniqueIds AND CreatedDate >= :fourteenDaysAgo])
        {
            System.debug('THE CASE '+theCase);
            if(!usptoIdToCases.containsKey(theCase.USPTO_Id__c))
                usptoIdToCases.put(theCase.USPTO_Id__c , new List<Case>());
            usptoIdToCases.get(theCase.USPTO_Id__c).add(theCase);
        }
        System.debug('USPTO Id To Cases '+usptoIdToCases);
        Map<String,Case> usptoIdToOneCase = new Map<String,Case>();
        for(String usptoId : usptoIdToCases.keySet())
        {
            if(usptoIdTocases.get(usptoId).size() == 1)
            {

                usptoIdToOneCase.put(usptoId , usptoIdTocases.get(usptoId)[0]);     
            }
        }
        return usptoIdToOneCase;
    }

    public Map<String,Case> getExistingTrademarkNameToCase(Set<String> trademarkNames)
    {
        
        Map<String,Case> trademarkNameToOneCase = new Map<String,Case>();
        Date fourteenDaysAgo = Date.today().addDays(-14);
        
        for(Case theCase : [SELECT Id,Trademark_name__c FROM Case WHERE Trademark_name__c IN :trademarkNames AND CreatedDate >= :fourteenDaysAgo ORDER BY CreatedDate DESC])
        {
            System.debug('THE CASE '+theCase);
            if(!trademarkNameToOneCase.containsKey(theCase.Trademark_name__c))
                trademarkNameToOneCase.put(theCase.Trademark_name__c , theCase);
        }
                
        return trademarkNameToOneCase;
    }

    public String getThreadId(Id theCaseId)
    {
        if(theCaseId != null)
        {
            String caseId = theCaseId;
            String orgId = UserInfo.getOrganizationId();
            String threadId = '[ ref:'+orgId.substring(0,4)+orgId.substring(11,15)+'.'+caseId.substring(0,4)+caseId.substring(10,15)+':ref ]';
            return  threadId;
        }
        return null;
    }

    private EmailMessage getEmailMessage(String subject , String emailBody , String toAddress , Id parentId )
    {
         EmailMessage theEmailMessage = new EmailMessage(status='3',subject=subject,htmlbody=emailBody,toaddress=toAddress,fromname='LegalZoom Support',MessageDate=Datetime.now(),ParentId=parentId,fromaddress='support@legalzoom.com');        
         return theEmailMessage;
    } 


    private Task getTaskToCreate(String subject , Id paretnId)
    {
        Task theTask = new Task (Type='Email',Status='Completed', Subject='Email:'+subject ,WhatId = paretnId , ActivityDate=Date.today());
        return theTask;
    }

}