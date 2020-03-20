@isTest
private class EmailAttachmentCaseTest {
    
    static EmailMessage testEmailMessage;
    static Attachment testCaseAttachment;
    static Case testCase;
    static Draft_Email__c testDraftEmail;
    
    static final Integer SIZE = 1;
    final static Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
    
    static void setupData()
    {   
        testCase = TestUtils.createCases( SIZE, false)[0];
        testCase.Subject = 'Unit test Case Email case';
        testCase.Status = 'New';
        testCase.IsHasAttachment__c = true;
        insert testCase;
        
        testEmailMessage = TestUtils.createEmailMessages(SIZE, testCase.Id, false)[0];
        testEmailMessage.ParentId = testCase.Id;
        testEmailMessage.MessageDate = Date.today();
        testEmailMessage.TextBody = 'This is Unit test EmailMessage Negative case text'; 
        testEmailMessage.Subject = 'Test mail subject'; 
        insert testEmailMessage;
        
        testCaseAttachment = TestUtils.createAttachments(SIZE, testCase.Id, false)[0];
        testCaseAttachment.Name = 'Unit Test Attachment';
        testCaseAttachment.body = bodyBlob;
        insert testCaseAttachment;
        
    }
    static void setupDraftEmailData(){
        testCase = TestUtils.createCases( SIZE, false)[0];
        testCase.Subject = 'Unit test Case Email case';
        testCase.Status = 'New';
        testCase.IsHasAttachment__c = true;
        insert testCase;
        
        testDraftEmail = TestUtils.createDraftEmails(SIZE, false)[0];
        testDraftEmail.Case__c = testCase.Id;
        insert testDraftEmail;
        
        testCaseAttachment = TestUtils.createAttachments(SIZE, testDraftEmail.Id, false)[0];
        testCaseAttachment.Name = 'Unit Test Attachment';
        testCaseAttachment.body = bodyBlob;
        insert testCaseAttachment;
    }
    
    static void setupEmailMessageData()
    {   
        testCase = TestUtils.createCases( SIZE, false)[0];
        testCase.Subject = 'Unit test Case Email case';
        testCase.Status = 'New';
        testCase.IsHasAttachment__c = true;
        insert testCase;
        
        testEmailMessage = TestUtils.createEmailMessages(SIZE, testCase.Id, false)[0];
        testEmailMessage.ParentId = testCase.Id;
        testEmailMessage.MessageDate = Date.today();
        testEmailMessage.TextBody = 'This is Unit test EmailMessage case text'; 
        testEmailMessage.Subject = 'Test mail subject'; 
        insert testEmailMessage;
        
        testCaseAttachment = TestUtils.createAttachments(SIZE, testEmailMessage.Id, false)[0];
        testCaseAttachment.Name = 'Unit Test Attachment';
        testCaseAttachment.body = bodyBlob;
        insert testCaseAttachment;
        
    }

    static testMethod void testCaseEmail() {
        setupData();
        
        List<Attachment> attachments=[select id, name from Attachment where ParentId=:testCase.id];
        List<Case> cseList =[select id  from Case where Id=:testEmailMessage.ParentId];
        System.assertEquals(1, attachments.size());
        System.assertEquals(1, cseList.size());
        System.assertEquals(true, testCase.IsHasAttachment__c);
    }
    
    static testMethod void testSCC_BCCaseEmail_Positive() {
        Case cse = new Case();
        cse.Subject = 'Unit test SCC_BCCaseEmail case';
        cse.Status = 'New';
        cse.IsHasAttachment__c = true;
        
        insert cse;
        
        HVCR_Email_New__c hvcrEmail = TestUtils.createHVCRMessage(SIZE , cse.Id , false)[0];
        insert hvcrEmail;
        
        Attachment attach = new Attachment();
        attach.Name = 'Unit Test SCC_BCCaseEmail Attachment';
        attach.body = bodyBlob;
        attach.parentId = hvcrEmail.Id;

        Test.startTest();
            insert attach;
        Test.stopTest();
        
        List<HVCR_Email_New__c> scc_bccaseEmail = [select Id 
                                                  from HVCR_Email_New__c 
                                                  where Case__c =: cse.Id];
                                                  
        ID scc_bccaseEmailID = [SELECT Case__c FROM HVCR_Email_New__c WHERE Id =: attach.ParentId].Case__c;

        List<Attachment> attachments=[select id, ParentId
                                      from Attachment 
                                      where ParentId =: hvcrEmail.Id];
        List<Case> cseList = [select Id, IsHasAttachment__c 
                              from Case
                              where Id =: hvcrEmail.Case__c];                                                                         
        System.assertEquals(1, scc_bccaseEmail.size());
        System.assertEquals(cse.Id, scc_bccaseEmailID);
        System.assertEquals(1, attachments.size());
        System.assertEquals(1, cseList.size());
        for(Attachment a : attachments){
            ID attachID = a.ParentId;
            System.assertEquals(HVCR_Email_New__c.sObjectType, attachID.getSObjectType());
        }
        System.assertEquals(true, cse.IsHasAttachment__c);
    }
    
     static testMethod void testDraftEmail()
    {
        setupDraftEmailData();
        
        List<Draft_Email__c> draftEmailList = [select Id, Case__c 
                                               from Draft_Email__c 
                                               where Case__c =: testCase.Id];
                                               
        ID draft_email = [SELECT Case__c FROM Draft_Email__c WHERE Id =: testCaseAttachment.ParentId].Case__c;
                                            
        List<Attachment> draftEmailAttachments=[select id, ParentId 
                                      from Attachment 
                                      where ParentId =: testDraftEmail.Id];                                 
                                            
        List<Case> cseDraftEmailList = [select Id, IsHasAttachment__c 
                              from Case
                              where Id =: testDraftEmail.Case__c];                                  
                                            
        System.assertEquals(1, draftEmailList.size());
        System.assertEquals(testCase.Id, draft_email);
        System.assertEquals(1, cseDraftEmailList.size());
        System.assertEquals(1, draftEmailAttachments.size());
        System.assertEquals(true, testCase.IsHasAttachment__c);

    }
    
    static testMethod void testEmailMessageCaseEmail_Positive() {
        setupEmailMessageData();  
  
        List<EmailMessage> emailMessList = [select Id 
                                            from EmailMessage 
                                            where ParentId =: testCase.Id AND HasAttachment =: true];
                                            
        boolean hasAttach = [SELECT HasAttachment FROM EmailMessage WHERE ParentId =: testCase.Id].HasAttachment;                                    
                                            
        List<Attachment> attachments=[select Id, ParentID 
                                      from Attachment 
                                      where ParentId =: testEmailMessage.Id];                                 
                                            
        List<Case> cseList = [select Id, IsHasAttachment__c 
                              from Case
                              where Id =: testEmailMessage.ParentId];                                   
                                            
        System.assertEquals(1, emailMessList.size());
        System.assertEquals(1, cseList.size());
        System.assertEquals(1, attachments.size());
        System.assertEquals(true, testCase.IsHasAttachment__c);
        System.assertEquals(true, hasAttach);
    }
    
    static testMethod void testEmailMessageCaseEmail_Negative() {
        Case cseEmailMessage = new Case();
        cseEmailMessage.Subject = 'Unit test EmailMessage Negative case';
        cseEmailMessage.Status = 'New';
        cseEmailMessage.IsHasAttachment__c = false;
        
        insert cseEmailMessage;
        
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.ParentId = cseEmailMessage.Id;
        emailMessage.MessageDate = Date.today();
        emailMessage.Subject = 'Test mail subject';
        
        Test.startTest();
            insert emailMessage;
        Test.stopTest();
        
        List<EmailMessage> emailMessList = [select Id, HasAttachment
                                            from EmailMessage 
                                            where ParentId =: cseEmailMessage.Id];
                                            
        boolean hasAttach = [SELECT HasAttachment FROM EmailMessage WHERE ParentId =: cseEmailMessage.Id].HasAttachment;
                                            
        List<Attachment> attachments=[select Id, ParentId
                                      from Attachment 
                                      where ParentId =: emailMessage.Id];                                 
                                            
        List<Case> cseEmailMessageList = [select Id 
                              from Case
                              where Id =: emailMessage.ParentId];                                   
                                            
        System.assertEquals(1, emailMessList.size());
        System.assertEquals(1, cseEmailMessageList.size());
        System.assertEquals(0, attachments.size());
        System.assertEquals(false, cseEmailMessage.IsHasAttachment__c);
        System.assertEquals(false, hasAttach);
    }
}