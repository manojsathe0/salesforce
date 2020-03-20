public with sharing class POREmailSender 
{
    final static String PROBLEM_WITH_ORDER = 'Problem with Order';
    final static String SUPPORT_EMAIL = 'support@legalzoom.com';
    final static String SUPPORT_DISPLAY = 'LegalZoom Support';
    Map<String,String> variableToTemplateBody = new Map<String,String>();
    List<MailWrapper> mailWrappers = new List<MailWrapper>();
    public POREmailSender() 
    {
            
    }

    public void sendEmailsToCustomer(List<Case> cases)
    {
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
        Map<Id,Case> casesWithNeededFields = new Map<Id,Case>([SELECT Id , Product2__c, Contact.Firstname , Contact.Email , Order_Number__c , contactId  FROM Case WHERE Id IN :cases]);
        List<OrgWideEmailAddress> org = [Select Id, DisplayName , Address From OrgWideEmailAddress where DisplayName =:SUPPORT_DISPLAY];
        List<String> processNames = new List<String>();
        for(Case theCase : cases)
        {
            if(theCase.Product2__c != null)
                processNames.add(theCase.Product2__c);
        }
        Map<String,EmailTemplate> productNameToEmailTemplate = getProductnameToEmailTemplate(processNames);
        variableToTemplateBody  = getVariableToTemplateBody();
        String orgId = UserInfo.getOrganizationId();
        for(Case theCase : casesWithNeededFields.values())
        {
            
           
            if(theCase.Contact.Email != null && productNameToEmailTemplate.get(theCase.Product2__c) != null)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            
                List<String> sendTo = new List<String>();
                sendTo.add(theCase.Contact.Email);
                mail.setToAddresses(sendTo);
                mail.setReplyTo(SUPPORT_EMAIL);
                for(OrgWideEmailAddress m :org)
                    mail.setOrgWideEmailAddressId(m.Id);
                                
                String theCaseId = theCase.Id;
                
                String threadIdSearch = orgId.substring(0,4)+
                orgId.substring(9,15)+'.'+
                theCaseId.substring(0,4)+
                theCaseId.substring(10,15);
                String threadId = '[ ref:'+threadIdSearch+':ref ]';
                          
                       
                String subject = PROBLEM_WITH_ORDER +'- '+theCase.Order_Number__c;
                subject += threadId;
                                    
                mail.setSubject(subject);
                String emailWithMergeFields = getEmailWithMergeFields(productNameToEmailTemplate.get(theCase.Product2__c).HtmlValue , theCase.Contact.Firstname , theCase.Order_Number__c , theCase.Contact.Email);
                emailWithMergeFields += threadId;
                    
                mail.setHtmlBody(emailWithMergeFields);
                mail.setUseSignature(false);
                mails.add(mail);
                MailWrapper theMailWrapper = new MailWrapper(emailWithMergeFields , theCase.Id , subject , theCase.Contact.Email , theCase.contactId);
                mailWrappers.add(theMailWrapper);
            }
            
        }
        
                
        Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        insertEmailMessageAndTask(mailWrappers);

    }
    

    public Map<String,EmailTemplate> getProductnameToEmailTemplate(List<String> processNames)
    {

        Map<String,EmailTemplate> productNameToEmailTemplate = new Map<String,EmailTemplate>();
        Map<String,String> productToTemplateName = new Map<String,String>();
        for (POR_case_routing_queues__c productToQueueMap : [SELECT Name , Template_DeveloperName__c FROM POR_case_routing_queues__c WHERE Name IN :processNames])
        {
            productToTemplateName.put(productToQueueMap.Name,productToQueueMap.Template_DeveloperName__c);
        }
        Map<String,EmailTemplate> developerNameToEmailTemplate = new Map<String,EmailTemplate>();
        for(EmailTemplate theTemplate : [SELECT Id , DeveloperName , HtmlValue FROM EmailTemplate WHERE DeveloperName IN :productToTemplateName.values()])
        {
            developerNameToEmailTemplate.put(theTemplate.DeveloperName , theTemplate);
        }
        for(String productName : productToTemplateName.keySet())
        {
            if(developerNameToEmailTemplate.containsKey(productToTemplateName.get(productName)))
            {
                productNameToEmailTemplate.put(productName , developerNameToEmailTemplate.get(productToTemplateName.get(productName)));
            }
        }

        return productNameToEmailTemplate;
    }



    

    public String getEmailWithMergeFields(String htmlBody , String firstName , String orderNumber , String contactEmail)
    {
        
        if(htmlBody != null)
        {
           
         
            for(String theVariable : variableToTemplateBody.keySet())
            {
                htmlBody = htmlBody.replaceAll('\\{'+'!'+theVariable+'\\}',''+variableToTemplateBody.get(theVariable));    
            } 
             htmlBody = htmlBody.replaceAll('(?i)'+'\\{'+'!Contact.FirstName'+'\\}',firstName == null?'':firstName);
             htmlBody = htmlBody.replaceAll('(?i)'+'\\{'+'!Contact.Email'+'\\}',contactEmail == null?'':contactEmail);
               
             htmlBody = htmlBody.replaceAll('(?i)'+'\\{'+'!orderNumber'+'\\}',orderNumber == null?'':orderNumber);  
         }   
        
             

        return htmlBody ; 

    }
    
    public Map<String,String> getVariableToTemplateBody()
    {
        List<EmailTemplate> emtList = [select name,subject,folderid,body from emailtemplate where folder.name='Variable'];
        Map<String,String> variableTemplateToEmailBody = new Map<String,String>();
        if(!emtList.isEmpty())
        {
            for(EmailTemplate e:emtList)
            {   
                if(e.name!=null && e.body!=null)
                {            
                    variableTemplateToEmailBody .put(e.name , e.body);
                }
            }
        }
        return variableTemplateToEmailBody;
    }

    public void insertEmailMessageAndTask(List<MailWrapper> mailWrappers)
    {
        List<EmailMessage> emailMessagesToCreate = new List<EmailMessage>();
        for(MailWrapper theMailWrapper : mailWrappers)
        {
            EmailMessage theEmailMessage = new EmailMessage(status='3',subject=theMailWrapper.subject ,textbody= theMailWrapper.htmlBody,toaddress=theMailWrapper.toAddress,
                fromname=SUPPORT_DISPLAY,MessageDate=Datetime.now(),ParentId= theMailWrapper .caseId,fromaddress= SUPPORT_EMAIL);        
            emailMessagesToCreate.add(theEmailMessage);            
        }

        insert emailMessagesToCreate;
        List<Task> tasksToCreate = new List<Task>();
        for(MailWrapper theMailWrapper : mailWrappers)
        {
           List<Task> tasks =  EmailFunction.createTask(theMailWrapper.subject , theMailWrapper.htmlBody, null , null , null , null , null , null , null , null , null, null , theMailWrapper.caseId , theMailWrapper.contactId , false);
           tasksToCreate.addAll(tasks); 
        }
        insert tasksToCreate;
        
    }

    public class MailWrapper
    {
        public String htmlBody{get;set;}
        public Id caseId{get;set;}
        public String subject{get;set;}
        public String toAddress{get;set;}
        public Id contactId{get;set;}

        public MailWrapper(String theHtmlBody , Id theCaseId , String theSubject , String theToAddress , Id theContactId)
        {
          htmlBody = theHtmlBody;
          caseId = theCaseId;
          subject = theSubject;
          toAddress = theToAddress; 
          contactId = theContactId;
        }
    }
    
   

}