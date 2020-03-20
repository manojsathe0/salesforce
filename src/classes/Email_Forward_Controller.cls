public without sharing virtual class Email_Forward_Controller 
{
    public ApexPages.StandardController controller {set;get;}
    public Email_Forward_Controller(ApexPages.StandardController controller){}
    public String objectName{get;set;}
    public final static String LEGALZOOM_SUPPORT = 'LegalZoom Support';
    public String threadId{get;set;}
    public String threadIdSearch{get;set;} 
    
    public Email_Forward_Controller() {
        threadId = '';
        threadIdSearch = '';
        id = Apexpages.currentPage().getParameters().get('id'); 
        populateThreadId(id);
        objectName = Apexpages.currentPage().getParameters().get('objectname');
        init();
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
    
    public  String caseNumber
    {
        get
        { 
            if(caseNumber == null)
            {
                List<Case> ca = [Select CaseNumber From Case where Id =:id ];
                for(Case c :ca){
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
    public  Id id{get;set;}
    public String page
    {
        get
        {
            if(page == null)
            {
                page = Apexpages.currentPage().getParameters().get('page');
                return page;
            }
            else
            {
                return page;
            }
        }
        private set;
    }
    public  PageReference savePage
    {
        get
        {
            if(savePage == null)
            {
                if( page != null)
                {
                   savePage = new Pagereference('/apex/'+Apexpages.currentPage().getParameters().get('page'));
                   Id recordId = Apexpages.currentPage().getParameters().get('recordId');
                   savePage.getParameters().put('id',id);
                   savePage.getParameters().put('recordId',recordId);

                }
                else
                {
                   savePage = new Pagereference('/'+id);
                }
                return savePage;
            }
            else
            {
                return savePage;
            }
        }
        private set;
    }
    public  String additionTo { get; set; }
    public  String to { get; set;}
    public  String tohid { get; set; }
    public  String cc { get; set; }
    public  String bcc { get; set; }
    public  String subject { get; set; }
    public  String htmlBody { get; set;}
    public class FileDetail
    {
        public String link{get;set;}
        public String name{get;set;}
        public String size{get;set;}            
    }
    public transient String emails { get; set; }
    public class ContactDetail
    {
        public  String name{get;set;}
        public  String loginId{get;set;}
        public  String phone{get;set;}
        public  String email{get;set;}
        public  String alias{get;set;}
    }
    
   
    public  List<FileDetail> attfile 
    {
        get{
            if(attfile == null){
                attfile = new List<FileDetail>();
                id value = Apexpages.currentPage().getParameters().get('value');
                for(Attachment a : [select Id,SystemModstamp, ParentId, OwnerId, Name, LastModifiedDate, LastModifiedById, IsPrivate, IsDeleted,Description,
                                 CreatedDate, CreatedById, ContentType, BodyLength from Attachment where ParentId = :value limit 75]){
                                FileDetail file = new FileDetail();
                                file.name = a.Name;
                                Decimal  size = a.BodyLength; 
                                if(size < 1000000){ 
                                    size = size.Divide(1000,0); 
                                    file.size = size+'KB';
                                }else{
                                    size = size.Divide(1000000,0);
                                    file.size = size+'MB';
                                }
                                attfile.add(file);
                }
                return attfile;
            }else{
                return attfile;
            }
        }
        private set;
      }
    private List<SelectOption> emailsOptions = null;
             public List<SelectOption> getemailsOptions() 
             {
                if (emailsOptions != null)
                    return emailsOptions;         
                emailsOptions = new List<SelectOption>();
             try {            
                    for(OrgWideEmailAddress emails : [Select Id,DisplayName, Address From OrgWideEmailAddress]) 
                         emailsOptions.add(new SelectOption('support@legalzoom.com', 'LegalZoom Support'));
                } catch (System.DmlException dmlException) {
                  //  addExceptionMessage(dmlException);
                }
                return emailsOptions;
            }
            
     
        public void init()
        {
            id value = Apexpages.currentPage().getParameters().get('value');
            if(objectName == 'EmailMessage')
            {
            List<EmailMessage> messages = new List<EmailMessage>([SELECT ToAddress, TextBody, SystemModstamp, Subject, Status, ParentId, MessageDate, LastModifiedDate, LastModifiedById, IsDeleted, Incoming, Id, HtmlBody, Headers, HasAttachment, FromName, FromAddress, CreatedDate, CreatedById, CcAddress, BccAddress, ActivityId 
                                                                       FROM EmailMessage WHERE (Id = :value) LIMIT 75]);  
                                                                       
                     for(EmailMessage E:messages) {
                                 if(null != E.CcAddress){
                                 cc = E.CcAddress;
                                 }
                                 if(null != E.BccAddress){
                                 bcc= E.BccAddress;
                                 }
                            if(E.Subject != null){
                                subject = 'FW:'+E.Subject;
                            }else{
                                subject = 'FW:';
                            }
                               htmlBody = '<br/>'+'<br/>'+'--------------- Original Message ---------------'+'<br/>';
                               system.debug(E.ToAddress);
                               htmlBody += to == null?'':'To: '+E.ToAddress+'<br/>';
                               htmlBody += cc == null?'':'Cc: '+cc+'<br/>';
                               htmlBody += bcc == null?'':'Bcc: '+bcc+'<br/>';
                               htmlbody += E.Subject == null?'':'Subject: '+E.Subject+'<br/>'+'<br/>';
                                if(E.HtmlBody != null){
                                    htmlBody += E.HtmlBody;
                                }else{
                                    htmlBody += E.textbody;
                                }
                     }
                }
                else if(objectName == 'HVCR_Email_New__c')
                { //Case Custom email
                    List<HVCR_Email_New__c> customMessages = new List<HVCR_Email_New__c>([SELECT  SystemModstamp, isDraft__c, ToAddresses__c, Subject__c, Status__c,
                                                                                                    ToAddressesLong__c,CCAddressesLong__c,BCCAddressesLong__c,ReplyToAddressLong__c,FromAddressLong__c,
                                                                                                    SentDate__c, ReplyToAddress__c, IsSent__c, IsRepliable__c, IsRead__c,
                                                                                                    IsInbound__c, FromAddress__c, Contact__c, Case__c, CCAddresses__c, Body__c,
                                                                                                    BodyPlainText__c,  BCCAddresses__c, Name, LastModifiedDate, LastModifiedById,
                                                                                                    IsDeleted, Id, CreatedDate,CreatedById  FROM HVCR_Email_New__c  WHERE (Id = :value) LIMIT 75]);                  
                      for(HVCR_Email_New__c E:customMessages) {
                         
                           if(E.CCAddresses__c != null || E.CCAddressesLong__c != null){
                             cc = E.CCAddresses__c != null?E.CCAddresses__c:E.CCAddressesLong__c; 
                           }
                           if(E.BCCAddresses__c != null || E.BCCAddressesLong__c != null){
                             bcc= E.BCCAddresses__c != null?E.BCCAddresses__c:E.BCCAddressesLong__c; 
                           }
                           if(E.Subject__c != null){
                                subject = 'FW:'+E.Subject__c;
                            }else{
                                subject = 'FW:';
                            }
                              htmlBody = '<br/>'+'<br/>'+'--------------- Original Message ---------------'+'<br/>';
                              htmlBody += E.ToAddresses__c == null?'To: '+E.ToAddressesLong__c+'<br/>':'To: '+E.ToAddresses__c+'<br/>';
                              htmlBody += cc == null?'':'Cc: '+cc+'<br/>';
                              htmlBody += bcc == null?'':'Bcc: '+bcc+'<br/>';
                              htmlbody += E.Subject__c == null?'':'Subject: '+E.Subject__c+'<br/>'+'<br/>';  
                              if(E.body__c != null){
                                htmlBody += E.body__c;
                              }else{
                                htmlBody += E.BodyPlainText__c;
                              }
                      }
                  }
            }
    
    public PageReference ClearResult(){
        PageReference pageReference =  system.Page.Lookup_To_Dialog;
        pageReference.setRedirect(true);
        id = Apexpages.currentPage().getParameters().get('id');
       // searchR = null;
        return pageReference;
    }
    public PageReference Cancel(){
        PageReference pageReference =  savePage;
        pageReference.setRedirect(true);
        return pageReference;
    }
    public Id value{
        get{
            if(value == null){
                value = Apexpages.currentPage().getParameters().get('value');
                return value;
            }else{ 
                return value;
            }
        }
        public set;
    }
    public void sendAndClose(){
        
        sendemail();
        Case ca = [SELECT Status FROM Case WHERE Id =: id];
        ca.Status = 'Closed';
        try{
        update ca;
        }catch(DmlException e){
            
        }
    }
        
        public PageReference ForwardEmail()
        {
            return null;
        }
       public PageReference sendemail() 
       {
        PageReference pageReference = System.Page.EmailList;
        pageReference.setRedirect(true);
        Savepoint sp;
        Id recordId;
        Id id = ApexPages.currentPage().getParameters().get('id');
        if(ApexPages.currentPage().getParameters().containsKey('recordId'))
                if(ApexPages.currentPage().getParameters().get('recordId') != '' && ApexPages.currentPage().getParameters().get('recordId')!= null)
                    recordId = ApexPages.currentPage().getParameters().get('recordId');
        pageReference.getParameters().put('id',id);
        String tofirstname='';
        String tolastname='';
        String userfirstname='';
        String userlastname='';
        String title='';
        String companyname='';
        String address='';
        String phone='';
        String extension='';
        String toAddress_Forward='';
        List<Contact> contactList = [Select Name, LastName, Id, FirstName, Email From Contact where Id =:tohid Limit 1];
        Id whoid=null;
        if(!contactList.isEmpty()){
            tofirstname = ''+contactList[0].FirstName;
            tolastname = ''+contactList[0].LastName;
            whoid = contactList[0].Id;
        }
        String sbody = htmlBody;
        emails = 'LegalZoom Support';
      try 
      {
            List<String> toAddresses = new List<String>();
            List<String> ccAddresses = new List<String>();
            List<String> bccAddresses = new List<String>();
            String stoaddress='';
            if(!contactList.isEmpty()){
                 if(additionTo != '' && additionTo != null){
                    additionTo = additionTo.replaceAll(',',';');
                    stoaddress = contactList[0].email+';'+additionTo;
                    toAddresses=(contactList[0].email+';'+additionTo+';').split(';');
                 }
                 else
                 {
                    stoaddress = contactList[0].email;
                    toAddresses=(contactList[0].email+';').split(';');
                 }
            }
            else{
                toAddresses=(additionTo+';').split(';');
                stoaddress= additionTo;
            }
            if(cc != null && cc != '')
                cc= cc.replaceAll(',',';');
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
            if(!contactList.isEmpty()){
                if(sbody.indexOf('<html')==-1 && sbody.indexOf('<div')==-1 && sbody.indexOf('&nbsp;')==-1 && sbody.indexOf('<br/>')==-1 && sbody.indexOf('<table')==-1 && sbody.indexOf('<p>')==-1){                   
                    em = new EmailMessage(status='3',subject=subject,textbody=sbody,toaddress=stoaddress,fromname = LEGALZOOM_SUPPORT,ccaddress=cc,bccaddress=bcc,MessageDate=Datetime.now(),ParentId=sID,fromaddress='support@legalzoom.com');        
                    insert em;
                }else{
                    em = new EmailMessage(status='3',subject=subject,htmlbody=sbody,toaddress=stoaddress,fromname = LEGALZOOM_SUPPORT,ccaddress=cc,bccaddress=bcc,MessageDate=Datetime.now(),ParentId=sID,fromaddress='support@legalzoom.com');        
                    insert em;
                }
            }
            else{
                if(sbody.indexOf('<html')==-1 && sbody.indexOf('<div')==-1 && sbody.indexOf('&nbsp;')==-1 && sbody.indexOf('<br/>')==-1 && sbody.indexOf('<table')==-1 && sbody.indexOf('<p>')==-1){                   
                    em = new EmailMessage(status='3',subject=subject,textbody=sbody,toaddress=additionTo,fromname = LEGALZOOM_SUPPORT,ccaddress=cc,bccaddress=bcc,MessageDate=Datetime.now(),ParentId=sID,fromaddress='support@legalzoom.com');        
                    insert em;
                }else{
                    em = new EmailMessage(status='3',subject=subject,htmlbody=sbody,toaddress=additionTo,fromname = LEGALZOOM_SUPPORT,ccaddress=cc,bccaddress=bcc,MessageDate=Datetime.now(),ParentId=sID,fromaddress='support@legalzoom.com');        
                    insert em;
                }
            }
            
            
              List<Attachment> attforsave = new List<Attachment>();
             for(Attachment a : [select Id,SystemModstamp, ParentId, OwnerId, Name, LastModifiedDate, LastModifiedById, IsPrivate, IsDeleted,Description,
                                 CreatedDate, CreatedById, ContentType, BodyLength, Body from Attachment where ParentId = :value limit 75])
                          
                 {
                     Attachment theAttachment = new Attachment(ParentId=em.Id,Name=a.name,Body=a.body);
                     attforsave.add(theAttachment);
                 }
                 
                insert attForSave;
                if(!attforsave.isEmpty())
                {
                    List<Messaging.EmailFileAttachment> efas = new List<Messaging.EmailFileAttachment>();
                    for (Integer x=0; x < attForSave.size(); x++)
                    {
                        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();                    
                        efa.setFileName(attForSave[x].name);
                        efa.setBody(attForSave[x].body);
                        efas.add(efa);                    
                    }                   
                    mail.setFileAttachments(efas);
                }       
             
              List<OrgWideEmailAddress> org = [Select Id, DisplayName From OrgWideEmailAddress where DisplayName =:emails];
                         for(OrgWideEmailAddress m :org){
                                mail.setOrgWideEmailAddressId(m.Id);
                         }
            
             
            mail.setUseSignature(false);               
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            if (results[0].isSuccess())
            {
                String queueName = '';
                List<Case> caseList = [SELECT Id, Queue__c FROM Case WHERE Id =: sID]; 
                if(caseList.size() > 0)
                {
                    queueName = caseList[0].Queue__c;
                }
                
                if(!contactList.isEmpty())
                {
                    toAddress_Forward = stoaddress;
                }
                else
                {
                    toAddress_Forward = additionTo;
                }

                EmailFunction.createTask(subject, sbody, null, null, null, null, null, null, 'Outgoing', null, queueName, 'Forward', sID, whoid, true);
                //Update Task Incoming
                Boolean isContainOtherEmail = EmailFunction.checkLegallzoomEmail(toAddress_Forward);
                if(isContainOtherEmail == true)
                {
                    EmailFunction.updateEmailToCaseTaskIncoming(sID);
                }
                
                pageReference.getParameters().put('message',' Email has been sent successfully.'); 
                pageReference.getParameters().put('recordId',recordId);
            }
            else{
                Database.rollback(sp);
                pageReference =  system.page.Email_Forward_Page;
                pageReference.getParameters().put('id',id);
                pageReference.getParameters().put('recordId',recordId);
                pageReference.getParameters().put('value',value);
                pageReference.getParameters().put('page',page);
                pageReference.getParameters().put('option','forward');
                pageReference.getParameters().put('objectName', objectName);
                
                pageReference.getParameters().put('message',' Failed to send Email.');
            }
                    
         }
         catch(System.Exception ex ){
                     Database.rollback(sp);
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Failed to forward an Email.'+ex.getMessage()));
         }
         return pageReference;
    }

}