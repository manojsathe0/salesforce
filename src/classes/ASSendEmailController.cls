public with sharing class ASSendEmailController {
    
    public Account acc{get;set;}
    public List<Attachment> allAttachments{get; set;}
    private final static Integer NUM_OF_ATTACHMENTS = 20;
    
    public String fromEmail{get;set;}
    public String toEmail{get;set;}
    public String emailSubject{get;set;}
    public String emailBody{get;set;}  
    private Id attorneyAccountId;
    
    public String selectedEmailTemplate{get; set;}
    public String selectedContact{get;set;}
   
    public final static String EMAIL_TEMPLATE = 'AS Doc Sharing';
    public final static String FROM_EMAIL = 'advantagesupport@legalzoom.com'; 
    public final static String SELECT_EMAIL_MESSAGE = 'Please select at least one attachment';
    public final static String ATTACHMENT_OVER_10MB = 'Total attachment size is over the limit of 10MB.';
    
    public ASSendEmailController(ApexPages.StandardController stdController)
    {
        acc = (Account)stdController.getRecord();
        allAttachments = new List<Attachment>();
        initializeAttachment();
        //Initialization
        toEmail = '';
        acc = [SELECT id, Name FROM Account WHERE id =: acc.Id];        
        emailSubject = 'Sending documents on behalf of '+acc.Name;              
        selectedContact = 'SELECT';
        fromEmail = FROM_EMAIL;
        
        String query = 'select Id,Name,Subject,body from EmailTemplate WHERE Name =: EMAIL_TEMPLATE LIMIT 1';
        EmailTemplate et = database.query(query);            
        emailBody = et.body;
        selectedEmailTemplate = EMAIL_TEMPLATE;
            
    }
    
    private void initializeAttachment()
    {
        for(Integer i = 0 ; i<NUM_OF_ATTACHMENTS ;++i)
        {
            allAttachments.add(new Attachment());
        }
    }
      
    public List<SelectOption> getAvailableContacts(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('SELECT','--Select--'));   
        Id rtId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Plan Attorney').getRecordTypeId();
        List<Contact> conList = [SELECT id, Name, RecordTypeId, AccountId FROM Contact WHERE RecordTypeId =: rtId AND Inactive__c = false ORDER  BY Name LIMIT 999];
        for(Contact c : conList){
            options.add(new SelectOption(c.id,c.Name));
        }        
        return options;
    }
     /*
    * @auther : CloudTrigger
    * @date : 05/09/2012
    * @description : Apex method for sending mails
    * @parameters : Nothing
    * @returns : NULL PageReference
    */ 
    public PageReference sendEmails()
    {
    	PageReference pageReference = new PageReference('/'+acc.Id);
        pageReference.setRedirect(true);
        Savepoint sp;

        if((selectedContact == 'SELECT'))
        {
        	pageReference =  system.page.ASSendEmail;
        	pageReference.setRedirect(true);
 			pageReference.getParameters().put('id',acc.Id);
            pageReference.getParameters().put('message',' Failed to send Email.'+ 'Please Select the Attorney’s contact');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select the Attorney’s contact');
            ApexPages.addMessage(myMsg);
            return pageReference;        
        }
        
        
        List<Contact> contacts = [SELECT Id, Name, AccountId, Email FROM Contact WHERE Id =: selectedContact];
        toEmail = String.valueOf(contacts[0].Email);
        attorneyAccountId = contacts[0].AccountId;
        
        String[] toAddresses = new String[] {toEmail};
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        mail.setSaveAsActivity(true);
        mail.setSenderDisplayName('Advantage Support');  
        mail.setReplyTo('advantagesupport@legalzoom.com');
        mail.setSubject(emailSubject);
        mail.setBccSender(false);
        
        if((toAddresses.size() > 0) && (toAddresses != NULL))
        {
            mail.setToAddresses(toAddresses);        
        }        
        
        mail.setPlainTextBody(emailBody);
        mail.setUseSignature(false); 
                
        List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();        
        Boolean hasAttachment = false;
        for(Attachment  theAttachment : allAttachments)
        {       
            if(theAttachment.Body != null)
            {
                hasAttachment = true;
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(theAttachment.Name);
                efa.setBody(theAttachment.Body);
                efa.setContentType(theAttachment.ContentType);
                efaList.add(efa);
            }    
        }
        if(hasAttachment == false)
        {
        	pageReference =  system.page.ASSendEmail;
        	pageReference.setRedirect(true);
 			pageReference.getParameters().put('id',acc.Id);
            pageReference.getParameters().put('message',' Failed to send Email.'+SELECT_EMAIL_MESSAGE);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, SELECT_EMAIL_MESSAGE);
            ApexPages.addMessage(myMsg);
            return pageReference;  
        }       
            
        mail.setFileAttachments(efaList);                
        sp = Database.setSavepoint();
        
        try
        {   
            Messaging.SendEmailResult[] mailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
            if(mailResult[0].isSuccess())
            {              
                Case loggedCase  = logCase();
                Task createdActivity = logActivityHistory(loggedCase.Id);
                logEmailMessages(loggedCase.Id , createdActivity);
            }
        }
        catch(System.EmailException ex)
        {
        	pageReference =  system.page.ASSendEmail;
        	pageReference.setRedirect(true);
 			pageReference.getParameters().put('id',acc.Id);
 			pageReference.getParameters().put('message', ''+ATTACHMENT_OVER_10MB);
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + ex.getMessage());
            ApexPages.addMessage(myMsg);
        }                
        return pageReference;
    }
    
    public PageReference cancel()
    { 
        PageReference p = new PageReference('/'+acc.Id);
        p.setRedirect(true);                   
        return p;
    }  
        
    /*
    * @auther : CloudTrigger
    * @date : 05/09/2012
    * @description : Apex method for logging a Activity after mail sent to contact
    * @parameters : Nothing
    * @returns : Nothing
    */

    private Task logActivityHistory(Id whatId){      
                    
            Task t1 = new Task();
            t1.Subject = 'Email: '+emailSubject;
            t1.WhoId = selectedContact;
            t1.whatId = whatId;
            t1.Priority = 'Normal';
            t1.Description = 'From : '+ FROM_EMAIL + '\n' + 'To : '+toEmail + '\n'+ emailBody;
            t1.ActivityDate = Date.today();
            t1.Type = 'Email';
            t1.Status = 'Completed';
            insert t1;
        
            return t1;
    } 
    
     private void logEmailMessages(Id caseId , Task t1)
     {      
        EmailMessage theMessage = new EmailMessage();
        theMessage.ParentId = caseId;
        theMessage.ActivityId = t1.Id;
        theMessage.TextBody =  emailBody;
        theMessage.Subject = t1.Subject;
        theMessage.ToAddress = toEmail;
        theMessage.FromAddress = FROM_EMAIL;
        theMessage.Incoming = false;
        theMessage.MessageDate = Date.today();
        insertEmailMessage(theMessage);
     } 
    
    
     public void insertEmailMessage(EmailMessage emailMessage)
     {    
         emailMessage.Status = '3';
         insert emailMessage;            
         List<Attachment> attachmentsToInsert = new List<Attachment>(); 
         for(Attachment theAttachment: allAttachments )
         {  
             if(theAttachment.Body != null)
             {
                 theAttachment.ParentId=emailMessage.Id;
                 attachmentsToInsert.add(theAttachment);
             }
         } 
         
         insert attachmentsToInsert;
     }      
   
    /*
    * @auther : CloudTrigger
    * @date : 05/09/2012
    * @description : Apex method for loggin a Case record with reference to Account and Contact
    * @parameters : Nothing
    * @returns : Nothing
    */
    private Case logCase(){
        
        Case c = new Case();
        c.AccountId = attorneyAccountId;
        c.ContactId = selectedContact;
        c.Customer_Account__c = acc.Id;
        c.Subject = emailSubject;
        c.Description = emailBody;
        c.Origin = 'Attorney Doc Send';
        c.OwnerId = userinfo.getUserId();
        c.Status = 'Closed';
        insert c;
        return c;
    } 
    
      /*
    * @auther : CloudTrigger
    * @date : 05/09/2012
    * @description : Apex test method for testing this controller
    * @parameters : Nothing
    * @returns : Nothing
    */
    static testMethod void testSendEmailController(){
        
	    Account tAccountObject1 = new Account();
        tAccountObject1.name = 'Test Account 1';
        insert tAccountObject1;
        
        
        Contact tContactObject = new Contact();
        tContactObject.lastname = 'Test Contact';
        tContactObject.Email = 'test@mail.com';
        tContactObject.AccountId = tAccountObject1.Id;
        tContactObject.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Plan Attorney').getRecordTypeId();
        insert tContactObject;
        
        EmailTemplate tET  = [SELECT id, Name, Body, Subject FROM EmailTemplate WHERE IsActive = true LIMIT 1]; 
               
        PageReference testPage = Page.ASSendEmail;
        testPage.getParameters().put('id',tAccountObject1.id);
        Test.setCurrentPage(testPage); 
        
        Test.startTest();         
        ApexPages.StandardController sc = new ApexPages.standardController(tAccountObject1);
        ASSendEmailController SEC = new ASSendEmailController(sc);
        
        
        SEC.getAvailableContacts();
        SEC.selectedContact = tContactObject.Id;        
        
        SEC.toEmail = 'test@mail.com';        
        SEC.emailSubject = 'Test Subject';        
        SEC.sendEmails();
        
        SEC.toEmail = 'test@mail.com';
        SEC.selectedContact = 'SELECT';
        SEC.sendEmails();
        
        SEC.toEmail = 'test@mail.com';
        SEC.emailSubject = '';        
        SEC.sendEmails();
              
        SEC.toEmail = 'test@mail.com';        
        SEC.selectedEmailTemplate = tET.Id;
        SEC.sendEmails();
        
        SEC.toEmail = 'test@mail.com';
        SEC.selectedEmailTemplate = 'NONE';
        
              
        SEC.cancel();
        
        SEC.selectedContact = tContactObject.Id;  
        SEC.selectedEmailTemplate = tET.Id;
        sec.allAttachments[0].Name =  'test.txt';  
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');        
        sec.allAttachments[0].Body = bodyBlob;
        SEC.sendEmails();  
           
        Test.stopTest();        
    } 
   
}