public without sharing class NewSendEmailHelper
{
     public static String threadId = '';
     public static String threadIdSearch = '';
          
     final static String SUPPORT_DISPLAY_NAME = 'LegalZoom Support';
       
        
    public static void populateThreadId(String caseId)
    {
           if(caseId != null && caseId != '' && caseId.startsWith('500'))
           {
               Case theCase = [SELECT Id , Case_Thread_Id__c FROM Case WHERE Id = :caseId limit 1];
               if(theCase != null)
               {
                 threadId = ' [ '+theCase.Case_Thread_Id__c+' ] ';
                 threadIdSearch = theCase.Case_Thread_Id__c;
               }
           }
    }    
    
    public static PageReference SendEmail(PageReference pageToReturn)
    {
            
           pageToReturn.setRedirect(true);
           
           pageToReturn.getParameters().put('id',ApexPages.currentPage().getParameters().get('Id'));
           String caseId = ApexPages.currentPage().getParameters().get('Id');
           populateThreadId(caseId);
           
          
           pageToReturn.getParameters().put('recordId',ApexPages.currentPage().getParameters().get('recordId'));
           String objectName = Apexpages.currentPage().getParameters().get('objectName');
           String objectId = Apexpages.currentPage().getParameters().get('objectId');
                     
           EmailMessage emailForSave = null;
           HVCR_Email_New__c BCCaseEmailForSave = null;
           List<Messaging.EmailFileAttachment> efas = new List<Messaging.EmailFileAttachment>();
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           Boolean buildMail = false;                                                               
           List<Attachment> attforsave = new List<Attachment>();
              
           try
           {
           if(objectName == 'EmailMessage')
           {
                
                 List<EmailMessage> messages = new List<EmailMessage>([SELECT ToAddress, TextBody, SystemModstamp, Subject, Status, ParentId, MessageDate, LastModifiedDate, LastModifiedById, IsDeleted, Incoming, Id, HtmlBody, Headers, HasAttachment, FromName, FromAddress, CreatedDate, CreatedById, CcAddress, BccAddress, ActivityId 
                                                                       FROM EmailMessage WHERE Id = :objectId]);                                                              
                 if(messages.size() > 0)
                 { // Case Standard Email
                     
                    for(EmailMessage E : messages)
                     {
                      if(E.ToAddress != 'tmfiling@legalzoom.com')                                              
                      {  
                         buildMail = true;
                         if (E.HasAttachment)
                         {
                            for(Attachment a : [select Id,SystemModstamp, ParentId, OwnerId, Name, LastModifiedDate, LastModifiedById, IsPrivate, IsDeleted,Description,
                                 CreatedDate, CreatedById, ContentType, BodyLength, Body from Attachment where ParentId = :objectId]){
                                 Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                                 efa.setFileName(a.Name);
                                 efa.setBody(a.body);
                                 efas.add(efa);
                                 attforsave.add(a);
                            }
                         }
                            List<String> tolist =new List<String>();
                            List<String> cclist =new List<String>();
                            List<String> bclist =new List<String>();
                            if(null != E.FromAddress){
                                List<OrgWideEmailAddress> org = [Select Id, DisplayName,Address From OrgWideEmailAddress where DisplayName =:SUPPORT_DISPLAY_NAME];
                                if(!org.isEmpty())
                                    mail.setOrgWideEmailAddressId(org[0].Id);                               
                            }
                            if(null != E.ToAddress){
                                List<String> temp = E.ToAddress.split(';');
                                tolist.addAll(temp); 
                                mail.setToAddresses(tolist);
                            }
                            if(null != E.CcAddress){
                                List<String> temp = E.CcAddress.split(';');
                                cclist.addAll(temp);
                                mail.setCcAddresses(cclist);
                            }
                            if(null != E.BccAddress){
                                List<String> temp = E.BccAddress.split(';');
                                bclist.addAll(temp);
                                mail.setBccAddresses(bclist);
                            }
                            mail.setSubject(E.Subject);
                            if(null != E.TextBody || null != E.HtmlBody)
                            {
                                if(null != E.TextBody){
                                    mail.setPlainTextBody(E.TextBody);
                                }
                                if(null != E.HtmlBody){
                                    mail.setHtmlBody(E.HtmlBody);
                                }
                            }
                            else
                            {
                                mail.setPlainTextBody(' ');
                            }
                            mail.setFileAttachments(efas);
                            emailForSave = E;
                         }
                     
                     else if(E.ToAddress == 'tmfiling@legalzoom.com')                               
                     {
                        // send out an email with all the debug information
                        List<Messaging.SingleEmailMessage> debugmails =  new List<Messaging.SingleEmailMessage>();
                        Messaging.SingleEmailMessage debugmail = new Messaging.SingleEmailMessage();
                        List<string> toaddress = new list<string>();
                        toaddress.add('salesforceteam@legalzoom.com');
                        debugmail.setToAddresses(toaddress);
                        debugmail.setSenderDisplayName('Liquid Mangoose Resend Button');
                        debugmail.setSubject('Resend Button Functionality Log');
                        string body = 'Below is the Log.' + '<br>';
                        body +=  'Id :' + E.id + '<br>';
                        body +=  'Object Id :' + objectId + '<br>';
                        body +=  'Actual Email Message :' + E + '<br>';
                        debugmail.setHtmlBody(body);
                        debugmails.add(debugmail);
                        List<Messaging.SendEmailResult> results = Messaging.sendEmail(debugmails);
                        system.debug(results);
                        
                     }
                   }
               }
           
           }
           
           else if(objectName == 'HVCR_Email_New__c')
           {
                List<HVCR_Email_New__c> customMessages = new List<HVCR_Email_New__c>([SELECT  SystemModstamp, isDraft__c, ToAddresses__c, Subject__c, Status__c,
                                                                                                ToAddressesLong__c,CCAddressesLong__c,BCCAddressesLong__c,ReplyToAddressLong__c,FromAddressLong__c,
                                                                                                SentDate__c, ReplyToAddress__c, IsSent__c, IsRepliable__c, IsRead__c,
                                                                                                IsInbound__c, FromAddress__c, Contact__c, Case__c, CCAddresses__c, Body__c,
                                                                                                BodyPlainText__c, BCCAddresses__c, Name, LastModifiedDate, LastModifiedById,
                                                                                                IsDeleted, Id, CreatedDate,CreatedById  FROM HVCR_Email_New__c  WHERE Id = :objectId]);                  
                  for(HVCR_Email_New__c E:customMessages)
                  {
                      for(Attachment a : [select Id,SystemModstamp, ParentId, OwnerId, Name, LastModifiedDate, LastModifiedById, IsPrivate, IsDeleted,Description,
                             CreatedDate, CreatedById, ContentType, BodyLength, Body from Attachment where ParentId = :objectId]){
                         Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                         efa.setFileName(a.Name);
                         efa.setBody(a.body);
                         efas.add(efa);
                         attforsave.add(a);
                      }
                    
                    List<String> tolist =new List<String>();
                    List<String> cclist =new List<String>();
                    List<String> bclist =new List<String>();
                    List<String> rtlist =new List<String>();
                    if(null != E.FromAddress__c){
                            List<OrgWideEmailAddress> org = [Select Id, DisplayName , Address From OrgWideEmailAddress where DisplayName =:SUPPORT_DISPLAY_NAME];
                            for(OrgWideEmailAddress m :org){
                                mail.setOrgWideEmailAddressId(m.Id);
                            } 
                     }else{
                        if(null != E.FromAddressLong__c){
                            List<OrgWideEmailAddress> org = [Select Id, DisplayName , Address From OrgWideEmailAddress where DisplayName =:SUPPORT_DISPLAY_NAME];
                            for(OrgWideEmailAddress m :org){
                                mail.setOrgWideEmailAddressId(m.Id);
                            }
                        }
                     }
                    if(null != E.ToAddresses__c){
                        tolist.addAll(E.ToAddresses__c.split(';'));
                        mail.setToAddresses(tolist);
                    }else{
                        if(null!= E.ToAddressesLong__c){
                             tolist.addAll(E.ToAddressesLong__c.split(';'));
                            mail.setToAddresses(tolist);
                        }
                    }
                    if(null != E.CCAddresses__c){
                        cclist.addAll(E.CCAddresses__c.split(';'));
                        mail.setCcAddresses(cclist);
                    }else{
                        if(null != E.CCAddressesLong__c){
                            cclist.addAll(E.CCAddressesLong__c.split(';'));
                            mail.setCcAddresses(cclist);
                        }
                    }
                    if(null != E.BCCAddresses__c){
                        bclist.addAll(E.BCCAddresses__c.split(';'));
                        mail.setBccAddresses(bclist);
                    }else{
                        if(null != E.BCCAddressesLong__c){
                              bclist.addAll(E.BCCAddressesLong__c.split(';'));
                             mail.setBccAddresses(bclist);
                        }
                    }
                    if(null != E.ReplyToAddress__c){
                        E.ReplyToAddress__c = E.ReplyToAddress__c.replaceAll(';','');
                        mail.setReplyTo(E.ReplyToAddress__c);
                    }else{
                        if(null != E.ReplyToAddressLong__c){
                            E.ReplyToAddressLong__c = E.ReplyToAddressLong__c.replaceAll(';','');
                            mail.setReplyTo(E.ReplyToAddressLong__c);
                        }
                    }
                    if(null != E.Subject__c && !E.Subject__c.contains(threadIdSearch)){
                        E.Subject__c += threadId;
                        mail.setSubject(E.Subject__c);
                    }else{
                        mail.setSubject(E.Subject__c);
                    }
                    if( null != E.BodyPlainText__c && !E.BodyPlainText__c.contains(threadIdSearch)){
                         E.BodyPlainText__c += threadId;
                         mail.setPlainTextBody(E.BodyPlainText__c);
                    }else{
                        if(null != E.BodyPlainText__c){
                        mail.setPlainTextBody(E.BodyPlainText__c);
                        }else{
                              mail.setPlainTextBody('');
                        }
                    }
                    if(null != E.Body__c && !E.Body__c.contains(threadIdSearch)){
                        E.Body__c += threadId;
                        mail.setHtmlBody(E.Body__c);
                    }else{
                        mail.setHtmlBody(E.Body__c);
                    }
                    mail.setFileAttachments(efas);
                    BCCaseEmailForSave = E;
                  }
           }
          //Case Custom email
             if(buildmail)  //added this to prevent 'attempt to de-reference a null' object error.                          
             {       
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            if (results[0].isSuccess())
            {
                   if(efas.size() > 0){
                        pageToReturn.getParameters().put('message',' Email has been resent successfully with attachments.');
                   }else{
                    pageToReturn.getParameters().put('message',' Email has been resent successfully.');
                   }
                   if(emailForSave != null){
                       insertEmailMessage(emailForSave,attforsave,pageToReturn);
                   }
                   if(BCCaseEmailForSave !=null){
                        insertBCCaseEmail(BCCaseEmailForSave,attforsave,pageToReturn);
                   }                 
             }
             else
              {
                 List<Messaging.SendEmailError> theErrors = results[0].getErrors();
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  ' Failed to resend Email.' +theErrors[0].Message));
              }
             }
             else                                                                                                   
             {
                 pageToReturn.getParameters().put('messagefail',' Opps, Something went wrong. Please refresh the page and try again.');
             }
            
          }
          catch(System.EmailException ex )
          {
              system.debug('============== email exception caught!!!============='+ex.getMessage());
              pageToReturn.getParameters().put('messagefail',' Failed to resend Email.'+ex.getMessage());
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Failed to resend Email.'+ex.getMessage()));
            }
       return pageToReturn;
   }    
    //For List All Page
    
  public static void insertEmailMessage(EmailMessage e,List<Attachment> attforsave,PageReference pageReference ) {

    try {       
            EmailMessage emailMessage = new EmailMessage(ToAddress=e.ToAddress,TextBody= e.TextBody,Subject= 'Resend: '+e.Subject,Status= e.Status,ParentId=e.ParentId,MessageDate=Datetime.now(),Incoming= e.Incoming,HtmlBody= e.HtmlBody,Headers= e.Headers,FromName= e.FromName,FromAddress= e.FromAddress,CcAddress= e.CcAddress,BccAddress= e.BccAddress,ActivityId= e.ActivityId);        
            insert emailMessage;
            List<Attachment> attachmentsToSave = new List<Attachment>();
            for(Attachment a: attforsave ){
                Attachment attachment = new Attachment(ParentId=emailMessage.Id,Name= a.Name,Description= a.Description,ContentType= a.ContentType,Body= a.Body);
                attachmentsToSave.add(attachment);
            }
            insert attachmentsToSave;
            String queueName = '';
            List<Case> caseList = [SELECT Id, Queue__c, ContactId 
                                   FROM Case 
                                   WHERE Id =: e.ParentId limit 1]; 
            if(caseList.size() > 0)
            {
                queueName = caseList[0].Queue__c;
            }
            
            String emailBody = '';
            if(e.HtmlBody != null)
            {
                emailBody = e.HtmlBody;
            }
            else if(e.TextBody != null)
            {
                emailBody = e.TextBody;
            }

            //Resend Function
            EmailFunction.createTask(e.Subject, emailBody, null, null, null, null, null, null, 'Outgoing', null, queueName, 'Resend', e.ParentId, null, true);    
            //Update Task Incoming
            Boolean isContainOtherEmail = EmailFunction.checkLegallzoomEmail(e.ToAddress);
            if(isContainOtherEmail == true)
            {
                EmailFunction.updateEmailToCaseTaskIncoming(e.ParentId);
            }                
        } catch (System.DmlException ex) {
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                // Process exception here 
                pageReference.getParameters().put('messagefail',' Failed to resend Email.'+ex.getDmlMessage(i));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Failed to resend Email.'+ex.getDmlMessage(i)));
                System.debug(ex.getDmlMessage(i)); 
            }
        } 
   }
   
    public static void insertBCCaseEmail(HVCR_Email_New__c s,List<Attachment> attforsave,PageReference pageReference ) {
      
      try {        
            HVCR_Email_New__c emailMessage = new HVCR_Email_New__c(isDraft__c= s.isDraft__c,ToAddressesLong__c=s.ToAddressesLong__c,ReplyToAddressLong__c= s.ReplyToAddressLong__c,
                                                                         FromAddressLong__c= s.FromAddressLong__c,CCAddressesLong__c= s.CCAddressesLong__c,BCCAddressesLong__c= s.BCCAddressesLong__c,
                                                                         ToAddresses__c= s.ToAddresses__c,Subject__c= 'Resend: '+s.Subject__c,Status__c= s.Status__c,
                                                                         SentDate__c= Datetime.now(),ReplyToAddress__c= s.ReplyToAddress__c,IsSent__c= s.IsSent__c,
                                                                         IsRepliable__c= s.IsRepliable__c,IsRead__c= s.IsRead__c,IsInbound__c= s.IsInbound__c,
                                                                         FromAddress__c= s.FromAddress__c,Contact__c= s.Contact__c,Case__c= s.Case__c,
                                                                         CCAddresses__c= s.CCAddresses__c,Body__c= s.Body__c,BodyPlainText__c= s.BodyPlainText__c,
                                                                         BCCAddresses__c= s.BCCAddresses__c,Name= s.Name,LastModifiedDate= Datetime.now(),
                                                                         LastModifiedById= s.LastModifiedById,CreatedDate= Datetime.now(),CreatedById= s.CreatedById);                
            insert emailMessage;
            List<Attachment> attachmentsToSave = new List<Attachment>();
            for(Attachment a: attforsave ){
                  Attachment attachment = new Attachment(ParentId=emailMessage.Id,Name= a.Name,IsPrivate= a.IsPrivate,Description= a.Description,ContentType= a.ContentType,Body= a.Body);
                  attachmentsToSave.add(attachment);
            }
            insert attachmentsToSave;
          
            EmailFunction.createTask(s.Subject__c, null, null, null, null, null, null, null, null, null, null, null, s.Case__c, null, true);
          
        } catch (System.DmlException ex) {
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                // Process exception here 
                pageReference.getParameters().put('messagefail',' Failed to resend Email.'+ex.getDmlMessage(i));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Failed to resend Email.'+ex.getDmlMessage(i)));
                System.debug(ex.getDmlMessage(i)); 
            }
        } 
   }
   
    public static PageReference sendEmailDraft(PageReference pageToReturn)
    {
               
        String caseId = ApexPages.currentPage().getParameters().get('Id');
        populateThreadId(caseId);
           
        
        pageToReturn.getParameters().put('id',ApexPages.currentPage().getParameters().get('Id')); 
        pageToReturn.getParameters().put('recordId',ApexPages.currentPage().getParameters().get('recordId'));   
        pageToReturn.setRedirect(true);
        Id customerEmailId = Apexpages.currentPage().getParameters().get('rowId');
        String subject = null;
        String emailToAddresses = '';
        String emailTemplateID = '';
        String emailTemplateName = '';
        String emailTemplateDeveloperName = '';
        String emailTemplateDescription = '';
        String emailTemplateFolderID = '';
        String emailTemplateFolderName = '';
        
        if(customerEmailId != null)
        {
            List<Attachment> attm = new List<Attachment>();
           
            List<Draft_Email__c> draftEmailMessgages  = [select id,Subject__c,Body__c, Case__c,CCAddresses__c,FromAddress__c,BCCAddresses__c,ToAddresses__c,AdditionToAddresses__c,Contact__c, 
                                                                Email_Template_ID__c , Email_Template__c , Email_Template_Developer_Name__c , Email_Template_Description__c , Email_Template_Folder_ID__c , Email_Template_Folder_Name__c 
                                                        from Draft_Email__c 
                                                        where id =:customerEmailId limit 1];
            if(!draftEmailMessgages.isEmpty())
            {
                emailTemplateID = draftEmailMessgages[0].Email_Template_ID__c;
                emailTemplateName = draftEmailMessgages[0].Email_Template__c;
                emailTemplateDeveloperName = draftEmailMessgages[0].Email_Template_Developer_Name__c;
                emailTemplateDescription = draftEmailMessgages[0].Email_Template_Description__c;
                emailTemplateFolderID = draftEmailMessgages[0].Email_Template_Folder_ID__c;
                emailTemplateFolderName = draftEmailMessgages[0].Email_Template_Folder_Name__c;
                
                Draft_Email__c draftEmailMessgage = draftEmailMessgages[0];
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                subject = draftEmailMessgage.Subject__c;
                
                String allToEmails = '';
                if(draftEmailMessgage.AdditionToAddresses__c != null && draftEmailMessgage.ToAddresses__c != null)
                {
                     allToEmails = draftEmailMessgage.ToAddresses__c + ';'+draftEmailMessgage.AdditionToAddresses__c;
                     String toEmails = allToEmails.replaceAll(',',';');
                     mail.setToAddresses(toEmails.split(';'));
                }
                else
                {
                    allToEmails = draftEmailMessgage.ToAddresses__c != null ? draftEmailMessgage.ToAddresses__c :draftEmailMessgage.AdditionToAddresses__c; 
                    String toEmails = allToEmails.replaceAll(',',';');
                    mail.setToAddresses(toEmails.split(';'));
                }
                
                
                if(draftEmailMessgage.CCAddresses__c != null)
                {
                    String ccAddress = draftEmailMessgage.CCAddresses__c.replaceAll(',',';');
                    mail.setCcAddresses(ccAddress.split(';'));
                }
                if(draftEmailMessgage.BCCAddresses__c != null)
                {
                    String bCCAddress = draftEmailMessgage.BCCAddresses__c.replaceAll(',',';');
                    mail.setBccAddresses(bCCAddress.split(';'));
                }
                if(null != subject && !subject.contains(threadIdSearch))
                {
                    subject += threadId;
                    mail.setSubject(''+subject);
                }
                else
                {
                    mail.setSubject(''+subject);
                }                    
                
                String emailBody = draftEmailMessgage.Body__c;
                if(emailBody == null)
                    emailBody = '';
                String parsedEmailBody = MergeFieldParser.parseMergeFields(emailBody , draftEmailMessgage.Case__c);
                mail.setHtmlBody(parsedEmailBody);
                 
                if(null != parsedEmailBody && !parsedEmailBody.contains(threadIdSearch))
                {
                    parsedEmailBody += threadId;
                    mail.setHtmlBody(''+parsedEmailBody);
                }
                else
                {
                    mail.setHtmlBody(''+parsedEmailBody);
                }
                
               List<OrgWideEmailAddress> org = [Select Id, DisplayName , Address From OrgWideEmailAddress where DisplayName =:SUPPORT_DISPLAY_NAME];
                            for(OrgWideEmailAddress m :org){
                                mail.setOrgWideEmailAddressId(m.Id);
                            }
                            
                attm = [select name,body from attachment where parentid=:draftEmailMessgage.Id]; 
                if(attm != null && !attm.isEmpty())
                {
                    List<Messaging.EmailFileAttachment> efas = new List<Messaging.EmailFileAttachment>();
                    for (integer x=0; x < attm.size(); x++)
                    {
                        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();                    
                        efa.setFileName(attm[x].name);
                        efa.setBody(attm[x].body);
                        efas.add(efa);                    
                    }                   
                    mail.setFileAttachments(efas);
                }
                
                try
                {
                    mail.setUseSignature(false);
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    if (results[0].isSuccess())
                    {
                        pageToReturn.getParameters().put('message',' Email has been sent successfully.');
                        EmailMessage stdEmailMessage = new EmailMessage();
                        stdEmailMessage.BccAddress = draftEmailMessgage.BCCAddresses__c;
                        stdEmailMessage.CcAddress = draftEmailMessgage.CCAddresses__c;
                        stdEmailMessage.Subject = subject;
                        
                        
                         if(draftEmailMessgage.AdditionToAddresses__c != null && draftEmailMessgage.ToAddresses__c != null)
                         {
                            stdEmailMessage.ToAddress = draftEmailMessgage.ToAddresses__c + ';'+draftEmailMessgage.AdditionToAddresses__c;
                            emailToAddresses = draftEmailMessgage.ToAddresses__c + ';'+draftEmailMessgage.AdditionToAddresses__c;
                         }
                         else if(draftEmailMessgage.AdditionToAddresses__c != null)
                         {
                            stdEmailMessage.ToAddress = draftEmailMessgage.AdditionToAddresses__c;
                            emailToAddresses = draftEmailMessgage.AdditionToAddresses__c;
                         }
                         else if(draftEmailMessgage.ToAddresses__c != null)
                         {
                            
                            stdEmailMessage.ToAddress = draftEmailMessgage.ToAddresses__c;
                            emailToAddresses = draftEmailMessgage.ToAddresses__c;
                         }
                        
                        stdEmailMessage.HtmlBody = parsedEmailBody;
                        stdEmailMessage.Status = '3';
                        stdEmailMessage.FromAddress = 'support@legalzoom.com';
                        stdEmailMessage.FromName = SUPPORT_DISPLAY_NAME;
                        stdEmailMessage.ParentId = draftEmailMessgage.Case__c;
                        stdEmailMessage.MessageDate= Datetime.now();

                        insert stdEmailMessage;
                        
                        List<Attachment> emailMessageAttachmentsToCreate = new List<Attachment>();
                        for(Attachment theAttachment : attm)
                        {
                            Attachment newAttachment = new Attachment();
                            newAttachment.Name = theAttachment.Name;
                            newAttachment.Body = theAttachment.Body;
                            newAttachment.ParentId = stdEmailMessage.Id;
                            emailMessageAttachmentsToCreate.add(newAttachment); 
                        }
                        
                        insert emailMessageAttachmentsToCreate;
                        String queueName;
                        List<Case> caseList = [SELECT Id, Queue__c FROM Case WHERE Id =: draftEmailMessgage.Case__c]; 
                        if(caseList.size() > 0)
                        {
                            queueName = caseList[0].Queue__c;
                        }   
                        //Send Function
                        EmailFunction.createTask(subject, parsedEmailBody, emailTemplateID, emailTemplateName, emailTemplateDeveloperName, emailTemplateDescription, emailTemplateFolderId, emailTemplateFolderName, 'Outgoing', null, queueName, 'Send', draftEmailMessgage.Case__c, draftEmailMessgage.Contact__c, true);

                        //Update Task Incoming
                        Boolean isContainOtherEmail = EmailFunction.checkLegallzoomEmail(emailToAddresses);
                        if(isContainOtherEmail == true)
                        {
                            EmailFunction.updateEmailToCaseTaskIncoming(draftEmailMessgage.Case__c);
                        }
                        delete draftEmailMessgage;
                    
                    }
                    else
                    {
                         List<Messaging.SendEmailError> theErrors = results[0].getErrors();
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Failed to send Email.' +theErrors[0].Message));
                    }
            
                }
                catch(Exception ex )
                {
                      pageToReturn.getParameters().put('messagefail',' Failed to send Email.'+ex.getMessage());
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Failed to send Email.'+ex.getMessage()));
                }
            }
        } 
    
        return pageToReturn;
    }
    
    // new method to delete the saved draft(Created by : vishnu).
     public static PageReference DeleteEmailDraft(PageReference pageToReturn)
      {
        pageToReturn.getParameters().put('id',ApexPages.currentPage().getParameters().get('Id')); 
        pageToReturn.getParameters().put('recordId',ApexPages.currentPage().getParameters().get('recordId'));   
        pageToReturn.setRedirect(true);
        Id customerEmailId = Apexpages.currentPage().getParameters().get('rowId');
        
        List<Draft_Email__c> draftEmailMessages  = [select id 
                                                           from Draft_Email__c 
                                                           where id =:customerEmailId 
                                                           limit 1];
          try{
            if(draftEmailMessages.size() != 0)
            {
              delete draftEmailMessages;
              pageToReturn.getParameters().put('message',' Email has been deleted successfully.');
            }
            
          }
           catch(Exception ex)                                             
           {
               pageToReturn.getParameters().put('Deletefail',' Failed to Delete Email.'+ex.getMessage());
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Failed to delete Email.'+ex.getMessage()));
             }                                                       
         return pageToReturn;
      }
}