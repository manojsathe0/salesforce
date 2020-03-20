global without sharing virtual class Custom_Email_Controller 
{
    public Integer attmnt{get;set;}
    public String relate{get;set;}  
    public String objectname;
   
    public string editMode{get;set;}
    public string mode{get;set;}
    public transient String emails { get; set; }
    public String to{get;set;}
    public String tohid{get;set;}
    public String namehid{get;set;}
    public String additionTo { get; set; }
    public String cc { get; set; }
    public String bcc { get; set; } 
    public String subject { get; set; }
    public String body { get; set;}
    public String fileRemove{get; set;}
    public String templateCode {get;set;}
    public String templateDetails {get; set;}
    public String id {get;set;}
    public String recordId {get;set;}
    public String textData{get; set;}
    public String option{get;set;}
    public String originalEmailBody{get;set;}
    public String selectedTemplateId{get;set;}
    
    public  List<Attachment> firstThreeAttachments{get;set;}
    public  List<Attachment> remainingAttachments{get;set;}
    public  List<Attachment> draftAttachments{get;set;}
    
    public Id attachmentToDelete{get;set;}
    public String strURL{get;set;} 
    public List<Case> theCases;
    
    public Id caseId{get;set;} 
    
    public Case theCase{get;set;}
    public String templateAttachmentIds{get;set;}
    
    public String snippetCode{get;set;}
    public String selectedSnippetId{get;set;}
    public String snippetAttachmentIds{get;set;}
    
    public String emailTemplateID{get;set;}
    public String emailTemplateName{get;set;}
    public String emailTemplateDeveloperName{get;set;}
    public String emailTemplateBodyText{get;set;}
    public String emailTemplateDescription{get;set;}
    public String emailTemplateFolderId{get;set;}
    public String threadId{get;set;}
    public String threadIdSearch{get;set;}
        
    public  String caseNumber
    {  
        get
        {
            String id =  ApexPages.currentPage().getParameters().get('id');    
            if(caseNumber == null)
            {      
                List<Case> ca = [Select CaseNumber From Case where Id =:id ];      
                for(Case c :ca)
                {        
                    caseNumber = c.CaseNumber;      
                }      
                return caseNumber;    
            }
            else
            {      
                return caseNumber;     
            }  
        }  
        private set;
    }
   
        
    @RemoteAction
    global static TemplateWrapper populateTemplateDetails(String templateCode , String theCaseId)
    {
        String escapedTemplateCode = String.escapeSingleQuotes(templateCode);
        TemplateWrapper theTemplateWrapper;
        List<EmailTemplate> emailTemplates = [SELECT Id , Body , Name , DeveloperName , FolderId , Description , HtmlValue FROM EmailTemplate WHERE Description =: templateCode];
        if(!emailTemplates.isEmpty()){
            String templateBody = MergeFieldParser.parseMergeFields(emailTemplates[0].HtmlValue , theCaseId);
            List<Attachment> attachments = [SELECT Id , Name FROM Attachment WHERE ParentId = :emailTemplates[0].Id];
            theTemplateWrapper = new TemplateWrapper(templateBody ,attachments , emailTemplates[0].Id , emailTemplates[0].Name , emailTemplates[0].DeveloperName , emailTemplates[0].Description , emailTemplates[0].FolderId);
        }
        else{   
            theTemplateWrapper = new TemplateWrapper('No Template Body to display.',null,null,null,null,null,null);
        }
        
        return theTemplateWrapper;
    }
    
    @RemoteAction
    global static TemplateWrapper populateTemplateDetailsById(String templateId , String theCaseId)
    {
        TemplateWrapper theTemplateWrapper;
        
        List<EmailTemplate> emailTemplates = [SELECT Id , Body , Name , DeveloperName , FolderId , Description , HtmlValue FROM EmailTemplate WHERE Id =: templateId];
        if(!emailTemplates.isEmpty()){
            String templateBody = emailTemplates[0].HtmlValue;
            List<Attachment> attachments = [SELECT Id , Name FROM Attachment WHERE ParentId = :templateId];
            theTemplateWrapper = new TemplateWrapper(templateBody , attachments , emailTemplates[0].Id , emailTemplates[0].Name , emailTemplates[0].DeveloperName , emailTemplates[0].Description , emailTemplates[0].FolderId);
        }
        else{   
            theTemplateWrapper = new TemplateWrapper('No Template Body to display.',null,null,null,null,null,null);
        }
        
        return theTemplateWrapper;
    }
    
    @RemoteAction
    global static TemplateWrapper populateTemplateDetailsWithMergeFieldsById(String templateId , String theCaseId)
    {
        TemplateWrapper theTemplateWrapper;
        List<EmailTemplate> emailTemplates = [SELECT Id , Body , Name , DeveloperName , FolderId , Description , HtmlValue FROM EmailTemplate WHERE Id =: templateId];
        if(!emailTemplates.isEmpty()){
            String templateBody = MergeFieldParser.parseMergeFields(emailTemplates[0].HtmlValue , theCaseId);
            List<Attachment> attachments = [SELECT Id , Name FROM Attachment WHERE ParentId = :templateId];
            theTemplateWrapper = new TemplateWrapper(templateBody , attachments , emailTemplates[0].Id , emailTemplates[0].Name , emailTemplates[0].DeveloperName , emailTemplates[0].Description , emailTemplates[0].FolderId);
        }
        else{   
            theTemplateWrapper = new TemplateWrapper('No Template Body to display.',null,null,null,null,null,null);
        }
        
        return theTemplateWrapper;
    }
    
       
    @RemoteAction
    global static List<EmailTemplate> getSuggestedTemplateCode(String searchTerm)
    {
        String theQuery = 'Select Id, Name, Description from EmailTemplate where IsActive = true AND FolderId NOT IN '+populateFolderIdsToExclude()+' AND (Description like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' OR Name like \'%' + String.escapeSingleQuotes(searchTerm) +'%\')';
        List<EmailTemplate> emailTemplates = Database.query(theQuery);
        return emailTemplates;
    }

    @RemoteAction
    global static List<EmailTemplate> getSuggestedSnippetCode(String searchTerm)
    {
        String theQuery = 'Select Id, Name, Description from EmailTemplate where IsActive = true AND FolderId = \'00lG0000001InuC\' AND (Description like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' OR Name like \'%' + String.escapeSingleQuotes(searchTerm) +'%\')';
        List<EmailTemplate> emailTemplates = Database.query(theQuery);
        return emailTemplates;
    }
    
    public static String populateFolderIdsToExclude()
    {
        String folderIdsToExclude = '';
        for(Id folderId : Lookup_Template_Dialog_Controller.emailTemplatesFoldersIdToExclude)
        {
            folderIdsToExclude += '\''+folderId+'\',';
        }
        if(folderIdsToExclude != '')
        {
            folderIdsToExclude = '('+folderIdsToExclude.subString(0, folderIdsToExclude.length()-1)+')';
        }
        if(folderIdsToExclude == '')
            folderIdsToExclude = '(\'\')';
        return folderIdsToExclude;
    }
    
    public String theSubjectPrefix
    {
        get
        {
            if(theSubjectPrefix == null)
            {
                List<Email_Subject__c> emailSubjects = Email_Subject__c.getall().values();
                if(!emailSubjects.isEmpty())
                {
                    theSubjectPrefix = emailSubjects[0].Subject__c;
                }
            }
            return theSubjectPrefix;
        }
        
        set;
    }
    
    public List<Attachment> createAttachments(Integer size)
    {
        List<Attachment> attachments = new List<Attachment>();
        
        for(Integer i =0 ; i<size ; ++i)
        {
            attachments.add(new Attachment());
        }
        
        return attachments;
    }
    public void populateThreadId(String theId)
    {
      if(theId != null && theId != '')
      {
          Case theCase = [SELECT Id , Case_Thread_Id__c FROM Case WHERE Id = :theId limit 1];
          if(theCase != null)
          {
              threadId = ' [ '+theCase.Case_Thread_Id__c+' ] ';
              threadIdSearch = theCase.Case_Thread_Id__c;
          }
      }
    }
    global Custom_Email_Controller() 
    {
        threadId = '';
        threadIdSearch = '';
        firstThreeAttachments = createAttachments(3);
        remainingAttachments = createAttachments(17);
        draftAttachments = new List<Attachment>();
        strURL = 'https://' + ApexPages.currentPage().getHeaders().get('Host') + '/servlet/servlet.FileDownload?file='; 
        
        templateDetails = '';
        attmnt=0;
       
        id = ApexPages.currentPage().getParameters().get('id');
        populateThreadId(id);
        if(Apexpages.currentPage().getparameters().get('recordId') != null)
            recordId = Apexpages.currentPage().getparameters().get('recordId');
        Lead theLead;
        system.debug(recordId);
        if(recordId.length() != 0)
        {
            if(SendToCustomEmailController.findObjectName(recordId) == SendToCustomEmailController.LEAD)
            {
                theLead = [Select Id , Name , Email From Lead WHERE Id =: recordId];
                objectname = 'Lead';
            }
            else if(SendToCustomEmailController.findObjectName(recordId) == SendToCustomEmailController.CONTACT)
                      {
                        objectname = 'Contact';
                      }  
        }
       // Id opportunityId = ApexPages.currentPage().getParameters().get('opportunityId');
        List<Account> nn =null;
        List<Contact> cc2=null; 
        String acc = '';
        List<Case> theCases = [SELECT Id ,Email_Subject__c, AccountId ,ContactId , SuppliedEmail , SuppliedName ,  order_number__c , subject , Contact.Email, Contact.Name,CaseNumber FROM Case WHERE Id = :id];
        system.debug(theCases);
        String theEmail  = '';
        subject  = '';
        additionTo = '';
        if(!theCases.isEmpty())
        {
            
            theCase = theCases[0];
            caseId= theCases[0].Id;
            if(theCases[0].order_number__c != null)
            {
               subject = theSubjectPrefix + ' '+ theCases[0].Email_Subject__c;
            }
            else if(theCases[0].Email_Subject__c != null)
            {
                subject = theCases[0].Email_Subject__c;
            }
            if(theCases[0].Contact != null)
            {
                theEmail = theCases[0].Contact.Email;
                if(theEmail != '' && theEmail != null)
                {
                    to = theCases[0].Contact.Name+' ('+theEmail+')';
                }
                else
                {
                    to = theCases[0].Contact.Name;
                }
                
                tohid = theCases[0].ContactId;
            }
            else if(theLead != null)
                 {
                    system.debug(theLead);
                    theEmail = theLead.Email;
                     if(theEmail != '' && theEmail != null)
                     {
                        to = theLead.Name+' ('+theEmail+')';
                     }
                     else
                     {
                        to = theLead.Name;
                     }
                     tohid = theLead.Id;
                 }
                 else if(theCases[0].Contact == null && theLead == null )
                 {
                    theEmail = theCases[0].SuppliedEmail;
                    if(theCases[0].SuppliedEmail !='' && theCases[0].SuppliedEmail!= null)
                    {
                        to = theCases[0].SuppliedName + '('+ theCases[0].SuppliedEmail+')';
                    }
                 }
        }
       Map<String,String> currentPageParameters = ApexPages.currentPage().getParameters();
       id customemailid = currentPageParameters.get('customemailid');
       String objectName  = '';
       if(customemailid != null && currentPageParameters.containsKey('option'))
       {
                option = currentPageParameters.get('option');
                objectName = currentPageParameters.get('objectname');
                if(option == 'reply' || option == 'replyAll')
                {
                    putDataToFormForReply(customemailid , theEmail , objectName);                   
                }
       }
       else if(customemailid != null)
       {
            putdatatoform(customemailid);
            editMode = 'edit';      
       }
       else
       {
            editMode = 'new';
       }
          
    } 
    
    public void putDataToFormForReply(Id emailId , String contactEmail , String objectName)
    {
        if(objectName  == 'EmailMessage'){
            List<EmailMessage> emailMessages = [SELECT Id , Subject ,BccAddress , CcAddress ,FromAddress ,ToAddress , HtmlBody , TextBody ,Incoming FROM EmailMessage WHERE Id =:emailId];
            
            if(!emailMessages.isEmpty()){
                
                if(emailMessages[0].Incoming)
                {
                    if(emailMessages[0].FromAddress != contactEmail)
                    {
                        additionTo = emailMessages[0].FromAddress+';';
                    }
                }
                emails = 'LegalZoom Support';
                if(option == 'replyAll')
                {
                      cc = emailMessages[0].CcAddress;
                      bcc = emailMessages[0].BccAddress;
                      if(emailMessages[0].ToAddress != null)
                      {
                            List<String> toAddresses = emailMessages[0].ToAddress.split(';');
                            for(String theToAddress : toAddresses)
                            {
                                if(theToAddress != contactEmail)
                                {
                                    additionTo += theToAddress+';';
                                }
                            }
                       }
                      
                }
                if(additionTo != '')
                    additionTo = additionTo.subString(0,additionTo.length()-1);
                subject = 'Re: ' + emailMessages[0].Subject;
                if(emailMessages[0].HtmlBody !=null)
                {
                    originalEmailBody =  emailMessages[0].HtmlBody;
                    originalEmailBody = originalEmailBody.replaceAll('font-size', '');
                    originalEmailBody = originalEmailBody.replaceAll('</script>', '');
                    originalEmailBody = originalEmailBody.replaceAll('<script', '');
                }
                else
                {
                    originalEmailBody = emailMessages[0].TextBody;
                }
            }
        }
        else if(objectName == 'HVCR_Email_New__c')
        {
            List<HVCR_Email_New__c> customMessages = new List<HVCR_Email_New__c>([SELECT  SystemModstamp, isDraft__c, ToAddresses__c, Subject__c, Status__c,
                                                                                                ToAddressesLong__c,CCAddressesLong__c,BCCAddressesLong__c,ReplyToAddressLong__c,FromAddressLong__c,
                                                                                                SentDate__c, ReplyToAddress__c, IsSent__c, IsRepliable__c, IsRead__c,
                                                                                                IsInbound__c, FromAddress__c, Contact__c, Case__c, CCAddresses__c, Body__c,
                                                                                                BodyPlainText__c,  BCCAddresses__c, Name, LastModifiedDate, LastModifiedById,
                                                                                                IsDeleted, Id, CreatedDate,CreatedById  FROM HVCR_Email_New__c  WHERE Id = :emailId]);                                                                                                               
              if(!customMessages.isEmpty()){
                 HVCR_Email_New__c theMessage = customMessages[0];
                 String fromAddress = '';
                 
                 if(null != theMessage.FromAddressLong__c){
                       fromAddress = theMessage.FromAddressLong__c;     
                 }
                 else if(null!= theMessage.FromAddress__c)
                 {
                        fromAddress = theMessage.FromAddress__c;
                 }
                 
                 if(theMessage.IsInbound__c){
                    if(fromAddress != contactEmail)
                    {
                        additionTo = fromAddress;
                    }
                 }
                emails = 'LegalZoom Support';
                if(option == 'replyAll'){
                    if(null != theMessage.CCAddresses__c){
                       cc = theMessage.CCAddresses__c;
                    }
                    else if(null != theMessage.CCAddressesLong__c)
                    {
                        cc = theMessage.CCAddressesLong__c;   
                    }
                    if(null != theMessage.BCCAddresses__c)
                    {
                       bcc = theMessage.BCCAddresses__c;
                    }else if(null != theMessage.BCCAddressesLong__c)
                    {
                         bcc =  theMessage.BCCAddressesLong__c;   
                    }
                }
                subject = 'Re: ' + theMessage.Subject__c;
                if(theMessage.Body__c !=null)
                {
                    originalEmailBody =  theMessage.Body__c;
                    originalEmailBody = originalEmailBody.replaceAll('font-size', '');
                    originalEmailBody = originalEmailBody.replaceAll('</script>', '');
                    originalEmailBody = originalEmailBody.replaceAll('<script', '');
                }
                else
                {
                    originalEmailBody = theMessage.BodyPlainText__c;
                }
          }
        
        }
    }
    
    public void putdatatoform(id customemailid)
    {
        list<Draft_Email__c> messages = new list<Draft_Email__c>([select id, toaddresses__c,ToAddressesName__c, subject__c,fromaddress__c, contact__c, case__c, ccaddresses__c, body__c,
                                                                                            bodytext__c, bccaddresses__c, name, lastmodifieddate, lastmodifiedbyid,
                                                                                            isdeleted, createddate,createdbyid,additionToAddresses__c, (select id, name, createddate,contenttype from attachments limit 75) from Draft_Email__c where (id = :customemailid ) order by createddate desc limit 1]);
        for(Draft_Email__c e:messages) {   
                    list<attachment> att = e.attachments;
                    if(e.bodytext__c != null){
                        templateDetails = e.bodytext__c;
                    }else  if(e.body__c != null){
                        templateDetails = e.body__c;
                    }
                    if(e.ccaddresses__c != null){
                        cc = e.ccaddresses__c;
                    }
                    if(e.subject__c != null){
                        subject = e.subject__c;
                    }
                    if(e.bccaddresses__c != null){
                        bcc = e.bccaddresses__c;
                    }                   
                    if(e.additionToAddresses__c != null){
                        additionto = e.additionToAddresses__c;
                    }
                    if(e.toaddressesname__c != null){
                        to = e.toaddressesname__c; 
                    }else if(e.toaddresses__c != null){                    
                        to = e.toaddresses__c; 
                    }
                    if(!e.attachments.isEmpty())
                    {
                        draftAttachments.addAll(e.attachments);
                    }
                }
    }
    
    
    public PageReference sendemail() {
        PageReference pageReference = Page.EmailList;
        pageReference.setRedirect(true);
        Savepoint sp;
        Draft_Email__c customEmailMessgage ;
        Id id = ApexPages.currentPage().getParameters().get('id');
        pageReference.getParameters().put('id',id);
        pageReference.getParameters().put('recordId',recordId);
        String tofirstname='';
        String tolastname='';
        String userfirstname='';
        String userlastname='';
        String title='';
        String companyname='';
        String address='';
        String phone='';
        String extension='';
        String folderName = '';
        String retrievedEmail = '';
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        List<Case> queriedCase = new List<Case>();
        
        Id whoid=null;
        system.debug( 'print toaddresses');
        system.debug(objectname);
        if(objectname == '' || objectname == null) 
        {
             queriedCase = [Select SuppliedEmail, SuppliedName, Id From Case Where Id =:id Limit 1];
            if(!queriedCase.isEmpty())
            {
                tofirstname = ''+queriedCase[0].SuppliedName;
                whoid = queriedCase[0].Id;
                retrievedEmail = queriedCase[0].SuppliedEmail;
            }
        }
        if(objectname == 'Lead')
        {
            leadList = [Select Name, LastName, Id, FirstName,Email From Lead where Id = :tohid Limit 1];
            if(!leadList.isEmpty())
            {
                tofirstname = ''+leadList[0].FirstName;
                tolastname = ''+leadList[0].LastName;
                whoid = leadList[0].Id;
                retrievedEmail = leadList[0].Email;
            }   
        }   
        if(objectname == 'Contact')
        {
            contactList = [Select Name, LastName, Id, FirstName, Email From Contact where Id =:tohid Limit 1];
            if(!contactList.isEmpty()){
                tofirstname = ''+contactList[0].FirstName;
                tolastname = ''+contactList[0].LastName;
                whoid = contactList[0].Id;
                retrievedEmail = contactList[0].Email;
            }
        }
        
        
        
        //start merge field
        //String sbody = templateDetails;     
        String sbody = '';
        String emailBody = templateDetails;
        if(emailBody == null)
            emailBody = '';
        String parsedEmailBody = MergeFieldParser.parseMergeFields(emailBody , id);
         
        if(null != parsedEmailBody && !parsedEmailBody.contains(threadIdSearch)){
            parsedEmailBody += threadId;
            sbody = ''+parsedEmailBody;
        }
        else
        {
            sbody = ''+parsedEmailBody;
        }
        
      //End Merge Field
      try 
      {
            List<Attachment> emailTemplateAttachments = new List<Attachment>();
            List<String> toAddresses = new List<String>();
            List<String> ccAddresses = new List<String>();
            List<String> bccAddresses = new List<String>();
            String stoaddress='';
            if(!contactList.isEmpty() || !leadList.isEmpty() || !queriedCase.isEmpty())
            {
                 if(additionTo != '' && additionTo != null)
                 {
                    additionTo = additionTo.replaceAll(',',';');
                    if(retrievedEmail != null && retrievedEmail != '')
                    {
                        stoaddress = retrievedEmail+';'+additionTo;
                        toAddresses=(retrievedEmail+';'+additionTo+';').split(';');
                    }
                    else
                    {
                        stoaddress = additionTo;
                        toAddresses=(additionTo).split(';');
                    }
                 }
                 else
                 {
                     if(retrievedEmail != null && retrievedEmail != '')
                     {
                            stoaddress = retrievedEmail;
                            toAddresses=(retrievedEmail+';').split(';');
                     }
                 }
            }
            else
            {
                toAddresses=(additionTo+';').split(';');
                stoaddress= additionTo;
            }
            if(cc != null && cc != '')
                cc = cc.replaceAll(',',';');
            if(bcc != null && bcc != '')
                bcc = bcc.replaceAll(',',';');
                
            ccAddresses=(cc+';').split(';');
            bccAddresses=(bcc+';').split(';');
           
            ID sID=Apexpages.currentPage().getParameters().get('id');        
            sp = Database.setSavepoint();    
            EmailMessage em=null;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             mail.setToAddresses(toAddresses);
             mail.setCcAddresses(ccAddresses);
             mail.setBccAddresses(bccAddresses);
         
             if(null != subject && !subject.contains(threadIdSearch)){
                subject += threadId;
                mail.setSubject(''+subject);
             }else{
                mail.setSubject(''+subject);
             }                    
         
             if(null != sbody && !sbody.contains(threadIdSearch)){
                sbody += threadId;
                mail.setHtmlBody(''+sbody);
             }else{
                mail.setHtmlBody(''+sbody);
             }
            if(!contactList.isEmpty() || !leadList.isEmpty()){
                if(sbody.indexOf('<html')==-1 && sbody.indexOf('<div')==-1 && sbody.indexOf('&nbsp;')==-1 && sbody.indexOf('<br/>')==-1 && sbody.indexOf('<table')==-1 && sbody.indexOf('<p>')==-1){                   
                    em = new EmailMessage(status='3',subject=subject,textbody=sbody,toaddress=stoaddress,fromname=emails,ccaddress=cc,bccaddress=bcc,MessageDate=Datetime.now(),ParentId=sID,fromaddress='support@legalzoom.com');        
                    insert em;
                }else{
                    em = new EmailMessage(status='3',subject=subject,htmlbody=sbody,textbody=emailTemplateBodyText,toaddress=stoaddress, fromname=emails, ccaddress=cc,bccaddress=bcc,MessageDate=Datetime.now(),ParentId=sID,fromaddress='support@legalzoom.com');        
                    insert em;
                }
            }
            else{
                if(sbody.indexOf('<html')==-1 && sbody.indexOf('<div')==-1 && sbody.indexOf('&nbsp;')==-1 && sbody.indexOf('<br/>')==-1 && sbody.indexOf('<table')==-1 && sbody.indexOf('<p>')==-1){                   
                    em = new EmailMessage(status='3',subject=subject,textbody=sbody,toaddress=additionTo,fromname=emails,ccaddress=cc,bccaddress=bcc,MessageDate=Datetime.now(),ParentId=sID,fromaddress='support@legalzoom.com');        
                    insert em;
                }else{
                    em = new EmailMessage(status='3',subject=subject,htmlbody=sbody,textbody=emailTemplateBodyText,toaddress=additionTo,fromname=emails,ccaddress=cc,bccaddress=bcc,MessageDate=Datetime.now(),ParentId=sID,fromaddress='support@legalzoom.com');        
                    insert em;
                }
            }
            if(em != null)
            {
                List<Attachment> attachmentsToInsert = new List<Attachment>();
                for(Attachment theAttachment : firstThreeAttachments)
                {
                    if(theAttachment.Body != null)
                    {
                        theAttachment.ParentId = em.Id;
                        attachmentsToInsert.add(theAttachment);
                    }
                }
                for(Attachment theAttachment : remainingAttachments)
                {
                    if(theAttachment.Body != null)
                    {
                        
                        theAttachment.ParentId = em.Id;
                        attachmentsToInsert.add(theAttachment);
                    }
                }
                
                //insert EmailTemplate Attachments
                emailTemplateAttachments = getAttachments();
                for(Attachment theAttachment : emailTemplateAttachments)
                {
                    if(theAttachment.Body != null)
                    {
                        theAttachment.ParentId = em.Id;
                        attachmentsToInsert.add(theAttachment);
                    }
                }
                insert attachmentsToInsert;
            }
            
           
            List<Attachment> attm = new List<Attachment>();
            List<Attachment> attachMentsFromDraft = new List<Attachment>();
            Id customemailid = apexpages.currentpage().getparameters().get('customemailid');
            //Draft Email
            List<Draft_Email__c> draftEmail = new List<Draft_Email__c>();
            
            if(editMode != null && editMode.equals('edit') &&  customemailid != null && option != 'reply' && option != 'replyAll')
            {
                if(
                    (customemailid != null) && (emailTemplateID == '' || emailTemplateID == null) && (emailTemplateName == '' || emailTemplateName == null) && 
                    (emailTemplateDescription == '' || emailTemplateDescription == null) && (emailTemplateDeveloperName == '' || emailTemplateDescription == null) &&
                    (emailTemplateFolderId == '' || emailTemplateFolderId == null)
                  )
                {
                    draftEmail = [SELECT Id, Body__c, Email_Template_ID__c, Email_Template__c, Email_Template_Developer_Name__c, Email_Template_Description__c, Email_Template_Folder_ID__c, Email_Template_Folder_Name__c FROM Draft_Email__c WHERE Id =:customemailid limit 1];
                    if(draftEmail.size() > 0)
                    {
                        emailTemplateID = draftEmail[0].Email_Template_ID__c;
                        emailTemplateName = draftEmail[0].Email_Template__c;
                        emailTemplateDeveloperName = draftEmail[0].Email_Template_Developer_Name__c;
                        emailTemplateDescription = draftEmail[0].Email_Template_Description__c;
                        emailTemplateFolderId = draftEmail[0].Email_Template_Folder_ID__c;
                        folderName = draftEmail[0].Email_Template_Folder_Name__c;
                    }
                }
                customEmailMessgage = [select id from Draft_Email__c where id =:customemailid limit 1];
                if(customEmailMessgage  != null  )
                {
                    List<Attachment> theAttachments  = [select name,body from attachment where parentid=:customEmailMessgage.Id];    
                    
                    if(!theAttachments.isEmpty()){
                        for(Integer x=0;x<theAttachments.size();x++){
                            Attachment attachment = new Attachment(ParentId=em.Id,Name=theAttachments[x].name,Body=theAttachments[x].body);
                            attachMentsFromDraft.add(attachment);
                        }
                    }
                    
                    insert attachMentsFromDraft;
                }
            }
            if(em != null){
                attm = [select name,body from attachment where parentid=:em.Id];              
            }
           
              List<OrgWideEmailAddress> org = [Select Id, DisplayName From OrgWideEmailAddress where DisplayName =:emails];
                         for(OrgWideEmailAddress m :org){
                                mail.setOrgWideEmailAddressId(m.Id);
                         }
             if(!attm.isEmpty()){
                List<Messaging.EmailFileAttachment> efas = new List<Messaging.EmailFileAttachment>();
                for (Integer x=0; x < attm.size(); x++){
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();                    
                    efa.setFileName(attm[x].name);
                    efa.setBody(attm[x].body);
                    efas.add(efa);                    
                }                   
                              
                mail.setFileAttachments(efas);
              }
             
            mail.setUseSignature(false);              
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            if (results[0].isSuccess())
            {
                if(folderName == '' || folderName == null)
                {
                    folderName = getEmailTemplateFolderName();
                }
                
                String queueName = '';
                String emailAction = '';
                List<Case> caseList = [SELECT Id, Queue__c FROM Case WHERE Id =: sID]; 
                if(caseList.size() > 0)
                {
                    queueName = caseList[0].Queue__c;
                }
                if(option != '' || option != null)
                {
                    if(option == 'reply' || option == 'replyAll')
                    {
                        emailAction = 'Reply';
                    }
                    else if(option == '' || option == null)
                    {
                        emailAction = 'Compose Email';
                    }
                }
                
                EmailFunction.createTask(subject, sbody, emailTemplateID, emailTemplateName, emailTemplateDeveloperName, emailTemplateDescription, emailTemplateFolderId, folderName, 'Outgoing', null, queueName, emailAction, sID, whoid, true);
                EmailFunction.updateEmailToCaseTaskIncoming(sId);
                
                if(editMode != null && editMode.equals('edit') && customEmailMessgage != null)
                {
                    delete customEmailMessgage;                                         
                }
                pageReference.getParameters().put('message',' Email has been sent successfully.'); 
                pageReference.getParameters().put('recordId',recordId);
            }
            else
            {
                List<Messaging.SendEmailError> theErrors = results[0].getErrors();
                Database.rollback(sp);
                pageReference =  system.page.Custom_Email;
                pageReference.setRedirect(true);
                pageReference.getParameters().put('id',id);
                pageReference.getParameters().put('recordId',recordId);
                pageReference.getParameters().put('customEmailId',Apexpages.currentPage().getParameters().get('customEmailId'));    
                pageReference.getParameters().put('message',' Failed to send Email.'+theErrors[0].Message);
            }
                    
         }
         catch(System.Exception ex ){
            
                     pageReference =  system.page.Custom_Email;
                     pageReference.setRedirect(true);
                     pageReference.getParameters().put('id',id);
                     pageReference.getParameters().put('recordId',recordId);
                     pageReference.getParameters().put('customEmailId',Apexpages.currentPage().getParameters().get('customEmailId'));    
                     pageReference.getParameters().put('message',' Failed to send Email.CustomemailId ='+Apexpages.currentPage().getParameters().get('customEmailId')+' Case Id '+id+ex.getMessage());
                     Database.rollback(sp);
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Failed to send Email.'+ex.getMessage()));
         }
         return pageReference;
    }
    
    public String getEmailTemplateFolderName()
    {
        String folderName;
        List<Folder> folderList = [SELECT Name FROM Folder WHERE Id =: emailTemplateFolderId]; 
        if(folderList.size() > 0)
        {
            folderName = folderList[0].Name;
        }
        return folderName;
    }
    
    public List<Messaging.EmailFileAttachment> getEmailTemplateAttachmentsAsEmailFile(List<Attachment> theAttachments)
    {
        List<Messaging.EmailFileAttachment> efas = new List<Messaging.EmailFileAttachment>();
        for(Attachment theAttachment :  theAttachments)
        {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();                    
            efa.setFileName(theAttachment.Name);
            efa.setBody(theAttachment.Body);
            efas.add(efa); 
        }
        return efas;
    }
    
    public List<Attachment> getAttachments()
    {
        List<Attachment> attachmentsToReturn = new List<Attachment>();
        List<String> theTemplateAttachmentIds = new List<String>();
        List<String> theSnippetAttachmentIds = new List<String>();
        Set<Id> templateattachmentIdsSet = new Set<Id>();
        Set<Id> snippetAttachmentIdsSet = new Set<Id>();

        if(templateAttachmentIds != '' && templateAttachmentIds != null)
        {
            theTemplateAttachmentIds = templateAttachmentIds.split(',');
            for(String theId : theTemplateAttachmentIds)
            {
                templateattachmentIdsSet.add(theId);
            }
        }
        if(snippetAttachmentIds != '' && snippetCode != null)
        {
            theSnippetAttachmentIds = snippetAttachmentIds.split(',');
            for(String theId : theSnippetAttachmentIds)
            {
                snippetAttachmentIdsSet.add(theId);
            }

        }
        Set<Id> allAttachmentIds = new Set<Id>();
        allAttachmentIds.addAll(templateattachmentIdsSet);
        allAttachmentIds.addAll(snippetAttachmentIdsSet);

        if(!allAttachmentIds.isEmpty())
        {
            for(Attachment theAttachment : [SELECT Id,Name,Body FROM Attachment WHERE Id IN :allAttachmentIds])
            {
                Attachment newAttachment = new Attachment();
                newAttachment.Name = theAttachment.Name;
                newAttachment.Body = theAttachment.Body;
                attachmentsToReturn.add(newAttachment);
            }
        }
        
        return attachmentsToReturn;
    }
    
    private List<SelectOption> emailsOptions = null;
    public List<SelectOption> getemailsOptions()
    {
          if (emailsOptions != null)return emailsOptions;     
          emailsOptions = new List<SelectOption>();
         try 
         {            
                for(OrgWideEmailAddress emails : [
                    Select Id, Address From OrgWideEmailAddress 
                ]) 
                emailsOptions.add(new SelectOption('LegalZoom Support', 'LegalZoom Support'));
            } 
            catch (System.DmlException dmlException)
            {
              //  addExceptionMessage(dmlException);
            }
      return emailsOptions;
    } 
    
    public pagereference cancel()
    {
        PageReference pageReference =  new PageReference('/'+ApexPages.currentPage().getParameters().get('Id'));
        pageReference.setRedirect(true);
        return pageReference;
    }
    
    public Pagereference savedraft()
    {
            Pagereference pagereference = Page.EmailList;
            pagereference.setredirect(true);  
            id customemailid = apexpages.currentpage().getparameters().get('customemailid');
            Id id = ApexPages.currentPage().getParameters().get('id');
             if(ApexPages.currentPage().getParameters().containsKey('recordId'))
                if(ApexPages.currentPage().getParameters().get('recordId') != '' && ApexPages.currentPage().getParameters().get('recordId')!= null)
                    Id recordId = ApexPages.currentPage().getParameters().get('recordId');
            body = templateDetails;
            String tofirstname='';
            String tolastname='';                    
            String email = '';
            String contactId = '';
            List<Case> theCase;
            List<Lead> theLeads;
            List<Contact> con;
            if(recordId != null && recordId != '')
            {
                if(SendToCustomEmailController.findObjectName(recordId) == SendToCustomEmailController.LEAD)
                 {
                    theLeads = [Select Id, LastName, FirstName, Email From Lead Where Id =:tohid Limit 1];
                    if(!theLeads.isEmpty())
                    {
                        tofirstname = theLeads[0].FirstName;
                        tolastname = theLeads[0].LastName;
                        email = theLeads[0].Email;
                    }
                 }
                 if(SendToCustomEmailController.findObjectName(recordId) == SendToCustomEmailController.CONTACT)
                 {
                    con = [Select Name, LastName, Id, FirstName, Email From Contact where Id =:tohid Limit 1];
                    if(!con.isEmpty())
                    {
                        tofirstname = con[0].FirstName;
                        tolastname = con[0].LastName;
                        email = con[0].Email;
                        contactId = con[0].Id;
                    }
    
                 }
              }
              else
                if(recordId == null || recordId == '')
                 {
                    theCase = [Select Id, SuppliedEmail From Case Where Id =: id];
                    if(!theCase.isEmpty())
                    {
                        email = theCase[0].SuppliedEmail;
                    }
                 }
            /*boolean cfa = checkAttachmentHasMore3M(bodyFileList,fileNameList);
            if(cfa){ return null; }
            */
            if(emailTemplateDescription != null)
            {
                Long countChar_Description = emailTemplateDescription.length();
                if(countChar_Description > 255)
                {
                    emailTemplateDescription = emailTemplateDescription.substring(0, 250);
                }
            }
            if(editMode != null && editMode.equals('edit')){
                id sid = apexpages.currentpage().getparameters().get('id');        
                Draft_Email__c customEmailMessgage = [select id from Draft_Email__c where id =:customemailid limit 1];
                customEmailMessgage.BCCAddresses__c = bcc;               
                customEmailMessgage.ToAddressesName__c = to;
                customEmailMessgage.Subject__c = subject;
                customEmailMessgage.CCAddresses__c = cc;    
                customEmailMessgage.AdditionToAddresses__c = additionTo;
                customEmailMessgage.Email_Template_ID__c = emailTemplateID;
                customEmailMessgage.Email_Template__c = emailTemplateName;
                customEmailMessgage.Email_Template_Developer_Name__c = emailTemplateDeveloperName;
                customEmailMessgage.Email_Template_Description__c = emailTemplateDescription;
                customEmailMessgage.Email_Template_Folder_ID__c  = emailTemplateFolderId;
                customEmailMessgage.Email_Template_Folder_Name__c = getEmailTemplateFolderName();
                customEmailMessgage.ToAddresses__c = email;
                                   
                if(body.indexOf('<html')!=-1 && body.indexOf('<div')!=-1 && body.indexOf('&nbsp;')!=-1 && body.indexOf('<br/>')!=-1 && body.indexOf('<table')!=-1 && body.indexOf('<p>')!=-1){
                    customEmailMessgage.BodyText__c = body;
                    customEmailMessgage.Body__c = null;
                }else{
                    customEmailMessgage.Body__c = body;
                    customEmailMessgage.BodyText__c = null;
                }                
                update customEmailMessgage;
                List<Attachment> attachmentsToInsert = new List<Attachment>();
                for(Attachment theAttachment : firstThreeAttachments)
                {
                    if(theAttachment.Body != null)
                    {
                        theAttachment.ParentId = customEmailMessgage.Id;
                        attachmentsToInsert.add(theAttachment);
                    }
                }
                for(Attachment theAttachment : remainingAttachments)
                {
                    if(theAttachment.Body != null)
                    {
                        theAttachment.ParentId = customEmailMessgage.Id;
                        attachmentsToInsert.add(theAttachment);
                    }
                }
                //for Email tenplate Attachments
                for(Attachment theAttachment : getAttachments())
                {
                    if(theAttachment.Body != null)
                    {
                        theAttachment.ParentId = customEmailMessgage.Id;
                        attachmentsToInsert.add(theAttachment);
                    }
                }
                
                insert attachmentsToInsert;
                pageReference.getParameters().put('id',id);
                pageReference.getParameters().put('recordId',recordId);
                pageReference.getParameters().put('message',' Draft Email Saved.');                                
        }else 
        {
            if(templateDetails==null || templateDetails==''){
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,'please enter the body in the from field box to draft an email.'));        
            }
            try {
                id sid = apexpages.currentpage().getparameters().get('id');        
                Draft_Email__c bccaseemail;
                if(templateDetails.indexOf('<html')!=-1 && templateDetails.indexOf('<div')!=-1 && templateDetails.indexOf('&nbsp;')!=-1 && templateDetails.indexOf('<br/>')!=-1 && templateDetails.indexOf('<table')!=-1 && templateDetails.indexOf('<p>')!=-1){                     
                        bccaseemail = new Draft_Email__c(subject__c=subject, bodytext__c=templateDetails, toaddresses__c=email,ToAddressesName__c = to,ccaddresses__c=cc,
                                                        bccaddresses__c=bcc,case__c=sid,AdditionToAddresses__c=additionTo,
                                                        Email_Template_ID__c = emailTemplateID, Email_Template__c = emailTemplateName , Email_Template_Developer_Name__c = emailTemplateDeveloperName, Email_Template_Description__c = emailTemplateDescription , Email_Template_Folder_ID__c = emailTemplateFolderId , Email_Template_Folder_Name__c = getEmailTemplateFolderName());  
                    if(contactId != '' && contactId != null){
                        bccaseemail.Contact__c = contactId;
                    }
                }
                else
                {
                        bccaseemail = new Draft_Email__c(subject__c=subject, body__c=templateDetails, toaddresses__c=email,ToAddressesName__c = to,ccaddresses__c=cc,
                                                        bccaddresses__c=bcc,case__c=sid,AdditionToAddresses__c=additionTo, 
                                                        Email_Template_ID__c = emailTemplateID, Email_Template__c = emailTemplateName , Email_Template_Developer_Name__c = emailTemplateDeveloperName, Email_Template_Description__c = emailTemplateDescription , Email_Template_Folder_ID__c = emailTemplateFolderId , Email_Template_Folder_Name__c = getEmailTemplateFolderName());  
                        if(contactId != '' && contactId != null){
                            bccaseemail.Contact__c = contactId;}
                
                }
                insert bccaseemail;
                List<Attachment> attachmentsToInsert = new List<Attachment>();
                for(Attachment theAttachment : firstThreeAttachments)
                {
                    if(theAttachment.Body != null)
                    {
                        theAttachment.ParentId = bccaseemail.Id;
                        attachmentsToInsert.add(theAttachment);
                    }
                }
                for(Attachment theAttachment : remainingAttachments)
                {
                    if(theAttachment.Body != null)
                    {
                        
                        theAttachment.ParentId = bccaseemail.Id;
                        attachmentsToInsert.add(theAttachment);
                    }
                }
                //for Email Template Attachments
                for(Attachment theAttachment : getAttachments())
                {
                    if(theAttachment.Body != null)
                    {
                        theAttachment.ParentId = bccaseemail.Id;
                        attachmentsToInsert.add(theAttachment);
                    }
                }
                
                insert attachmentsToInsert;
                                                
                pageReference.getParameters().put('id',id);
                pageReference.getParameters().put('recordId',recordId);
                pageReference.getParameters().put('message',' Draft Email Saved.');
             }
             catch(system.exception ex )
             {
                pageReference =  system.page.Custom_Email;
                pageReference.getParameters().put('id',id);
                pageReference.getParameters().put('recordId',recordId);
                pageReference.getParameters().put('message',' Failed to send Email.'+ex.getMessage());
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,  'failed to draft email.'+ex.getmessage()));
                return null;
             }       
        }  
        return pagereference ;
     }
     
     public PageReference removeAttachFile()
     {
        PageReference pageReference =  system.page.custom_email;      
        pagereference.setredirect(true);  
        id customemailid = apexpages.currentpage().getparameters().get('customemailid');
        id id = apexpages.currentpage().getparameters().get('id');
        if(attachmentToDelete != null)
        {
            attachment attm = [select ParentId,name,body from attachment where Id =:attachmentToDelete];  
            if(attm != null){
                delete attm;}
        }
        pageReference.getParameters().put('customEmailId',customemailid);
        pageReference.getParameters().put('id',id);  
        pageReference.getParameters().put('recordId',recordId);
        return pageReference;
    }
    
    global class TemplateWrapper
    {
        public String templateBody{get;set;}
        public String templateID{get;set;}
        public String templateName{get;set;}
        public String templateDeveloperName{get;set;}
        public String templateDescription{get;set;}
        public String templateFolderId{get;set;}
        public List<Attachment> attachments{get;set;}
        
        public TemplateWrapper(String theBody , List<Attachment> theAttachments, String theTemplateID, String theTemplateName, String theTemplateDeveloperName, String theTemplateDescription, String theTemplateFolderId)
        {
            templateBody = theBody;
            attachments = theAttachments;
            templateID = theTemplateID;
            templateName = theTemplateName;
            templateDeveloperName = theTemplateDeveloperName;
            templateDescription = theTemplateDescription;
            templateFolderId = theTemplateFolderId;
        }
    }
}