public with sharing class SendEmailHelper
{
	 final static String SUPPORT_DISPLAY_NAME = 'LegalZoom Support';
	
       
        public static String threadIdSearch
        {
	        get{   
	             if(threadIdSearch == null)
	             {
	             	String orgId = UserInfo.getOrganizationId();
	             	String caseId = ApexPages.currentPage().getParameters().get('Id');
	             	String threadIdSearch = orgId.substring(0,4)+
	                orgId.substring(11,15)+'.'+
	                caseId.substring(0,4)+
	                caseId.substring(10,15);
	                return  threadIdSearch;
	              }
	              else
	              {
	                 return threadIdSearch;
	              }          
	         }
	          private set;
        }
        
        
        public static String threadId
        {
	        get
	        {   
	             if(threadId == null)
	             {
	             	String orgId = UserInfo.getOrganizationId();
	             	String caseId = ApexPages.currentPage().getParameters().get('Id');
	             	String threadId = '[ ref:'+orgId.substring(0,4)+
	                orgId.substring(11,15)+'.'+
	                caseId.substring(0,4)+
	                caseId.substring(10,15)+':ref ]';
	                return  threadId;
	              }
	              else
	              {
	                  return threadId;
	              }          
	         }
	          private set;
        }
        
	
	public static PageReference SendEmail(String pageToReturn)
	{
			
		   PageReference pageReference;
		   if(pageToReturn == 'NewEmailList')	  
           		pageReference =  system.page.NewEmailList;
           else if (pageToReturn == 'NewLimitedEmailList')
           		pageReference =  system.page.NewLimitedEmailList;
           		
           pageReference.setRedirect(true);
           pageReference.getParameters().put('id',ApexPages.currentPage().getParameters().get('Id'));
           String objectName = Apexpages.currentPage().getParameters().get('objectName');
           String objectId = Apexpages.currentPage().getParameters().get('objectId');
           
           EmailMessage emailForSave = null;
           HVCR_Email_New__c BCCaseEmailForSave = null;
           List<Messaging.EmailFileAttachment> efas = new List<Messaging.EmailFileAttachment>();
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	            
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
	                        if(null != E.TextBody){
	                            mail.setPlainTextBody(E.TextBody);
	                        }
	                        if(null != E.HtmlBody){
	                            mail.setHtmlBody(E.HtmlBody);
	                        }
	                        mail.setFileAttachments(efas);
	                        emailForSave = E;
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
                    
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            if (results[0].isSuccess())
            {
                   if(efas.size() > 0){
                        pageReference.getParameters().put('message',' Email has been resent successfully with attachments.');
                   }else{
                    pageReference.getParameters().put('message',' Email has been resent successfully .');
                   }
                   if(emailForSave != null){
                       insertEmailMessage(emailForSave,attforsave,pageReference);
                   }
                   if(BCCaseEmailForSave !=null){
                        insertBCCaseEmail(BCCaseEmailForSave,attforsave,pageReference);
                   }                 
             }
             else
              {
             	 List<Messaging.SendEmailError> theErrors = results[0].getErrors();
             	  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Failed to resend Email.' +theErrors[0].Message));
              }
          	
          }
          catch(System.EmailException ex )
          {
     		  system.debug('============== email exception caught!!!============='+ex.getMessage());
              pageReference.getParameters().put('messagefail',' Failed to resend Email.');
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Failed to resend Email.'));
        	}
       return pageReference;
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
            Task task = new Task (Type='Email',Status='Completed',Subject= 'Email: '+e.Subject,WhatId=e.ParentId,ActivityDate=Date.today());
            insert task; 
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
        
            Task task = new Task (Type='Email',Status='Completed',Subject= 'Email: '+s.Subject__c,WhatId=s.Case__c,ActivityDate=Date.today());
            insert task; 
        } catch (System.DmlException ex) {
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                // Process exception here 
                pageReference.getParameters().put('messagefail',' Failed to resend Email.'+ex.getDmlMessage(i));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Failed to resend Email.'+ex.getDmlMessage(i)));
                System.debug(ex.getDmlMessage(i)); 
            }
        } 
   }
   
}