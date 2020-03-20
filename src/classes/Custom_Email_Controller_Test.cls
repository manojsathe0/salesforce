@isTest 
public with sharing class Custom_Email_Controller_Test 
{
    static EmailMessage testEmailMessage;
    static Case testCase;
    static Case testLeadCase;
    static Contact testContact;
    static Account testAccount;
    static Lead testLead;
    static final Integer SIZE = 1;
    static final String ID = 'id';
    static final String RECORD_ID = 'recordId';
    static final String CUSTOM_EMAIL_ID = 'customemailid';
    static final String OBJECT_NAME = 'objectName';
    static final String OPTION = 'option';
    static HVCR_Email_New__c hvcrEmail;
    static Draft_Email__c testDraftEmail;
    
    static void setupData()
    {
        testLead = TestUtils.createLeads(SIZE, 'Test Lead',  false)[0];
        testLead.Email = 'testLead@testLead.com';
        insert testLead;
        testAccount = TestUtils.createAccounts(SIZE , 'Test Account', true)[0];
        testContact = TestUtils.createContacts( SIZE ,  'Buffet ', testAccount.Id , false)[0];
        testContact.Email = 'test1@test.test2';
        insert testContact;

        testCase = TestUtils.createCases( SIZE, false)[0];
        testCase.ContactId = testContact.Id;
        testCase.Email_Subject__c  = 'Test Subject';
        insert testCase;

        testLeadCase = TestUtils.createCases( SIZE, false)[0];
        testLeadCase.Email_Subject__c  = 'Test Subject';
        insert testLeadCase;

        testEmailMessage = TestUtils.createEmailMessages(SIZE , testCase.Id , false)[0];
        testEmailMessage.FromAddress = 'testFromAddress@test.com';
        testEmailMessage.Incoming = true;
        testEmailMessage.CcAddress = 'testCcAddress@test.com';
        testEmailMessage.BccAddress = 'testBccAddress@test.com';
        testEmailMessage.Subject = 'Test mail subject';
        insert testEmailMessage;
         
        hvcrEmail = TestUtils.createHVCRMessage(SIZE , testCase.Id , false)[0];
        hvcrEmail.FromAddressLong__c = 'testFromEmail@test.com';
        hvcrEmail.ToAddressesLong__c = 'testToEmail@test.com';
        hvcrEmail.CCAddressesLong__c = 'ccAddress@test.com';
        hvcrEmail.IsInbound__c = true;
        insert hvcrEmail;
        
        testDraftEmail= TestUtils.createDraftEmails(1 , false)[0];
        testDraftEmail.Body__c = 'Draft Message Body';
        testDraftEmail.CCAddresses__c = 'draftCCAddress@test.com';
        testDraftEmail.bccaddresses__c = 'draftBccAddress@test.com';
        testDraftEmail.toaddresses__c = 'draftToAddress@test.com';
        testDraftEmail.additionToAddresses__c  = 'draftAdditionalToAddress@test.com';
        testDraftEmail.Case__c = testCase.Id;
        testDraftEmail.Subject__c = 'Draft mail subject';
        insert testDraftEmail;
    }
    
    static testMethod void testEmailMessageLoaded_For_EmailMessage_Reply()
    {
        
        setupData();
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , testEmailMessage.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'EmailMessage');
        pageRef.getParameters().put(OPTION , 'reply');
        
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
              Custom_Email_Controller theController = new Custom_Email_Controller();
        Test.stopTest();
        
        //salesforce seems to convert the FromAddress field to lowercase implicitely ??
        System.assertEquals( testEmailMessage.FromAddress.toLowerCase() , theController.additionTo , 'From Address from the email should have been populated on To Address field for reply');
        
    }
    
    static testMethod void testEmailMessageLoaded_For_HVCREmail_Reply()
    {
        
        setupData();
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , hvcrEmail.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'HVCR_Email_New__c');
        pageRef.getParameters().put(OPTION , 'reply');
        
        Test.setCurrentPage(pageRef);
        
        
        Test.startTest();
             Custom_Email_Controller theController = new Custom_Email_Controller();
        Test.stopTest();
        
        System.assertEquals( hvcrEmail.FromAddressLong__c , theController.additionTo , 'From Address from the email should have been populated on To Address field for reply');
        
    }
    
    static testMethod void testEmailMessageLoaded_For_EmailMessage_ReplyAll()
    {
        
        setupData();
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , testEmailMessage.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'EmailMessage');
        pageRef.getParameters().put(OPTION , 'replyAll');
        testEmailMessage.ToAddress = 'test@test.test';
        testEmailMessage.HtmlBody = 'Hello there';
        
        Test.setCurrentPage(pageRef);
        
        
        Test.startTest();
             Custom_Email_Controller theController = new Custom_Email_Controller();
        Test.stopTest();
        
        System.assertEquals( testEmailMessage.CcAddress , theController.cc , 'CC Address should have been populated');
        
    }
    
    static testMethod void testEmailMessageLoaded_For_HVCREmail_ReplyAll()
    {
        
        setupData();
        hvcrEmail.CCAddressesLong__c = 'testCcAddress@test.com';
        hvcrEmail.BCCAddressesLong__c = 'testBccAddress@test.com';
        update hvcrEmail;
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , hvcrEmail.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'HVCR_Email_New__c');
        pageRef.getParameters().put(OPTION , 'replyAll');
        
        Test.setCurrentPage(pageRef);
        
        
        Test.startTest();
             Custom_Email_Controller theController = new Custom_Email_Controller();
        Test.stopTest();
        
        System.assertEquals( hvcrEmail.CCAddressesLong__c , theController.cc , 'CC Address should have been populated as this is reply all');
        
    }
    
    static testMethod void testEmailMessageLoaded_For_DraftEmail()
    {
        
        setupData();
        List<Attachment> draftEmailAttachments = TestUtils.createAttachments( 10 , testDraftEmail.Id, false);
        insert draftEmailAttachments;
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , testDraftEmail.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'Draft_Email__c');
        
        Test.setCurrentPage(pageRef);
        
        
        Test.startTest();
              Custom_Email_Controller theController = new Custom_Email_Controller();
        Test.stopTest();
        
        System.assertEquals(testDraftEmail.Body__c ,theController.templateDetails , 'Draft Email body should have been populated');
        
    }
    
    static testMethod void testSendEmailContact()
    {
        setupData();
        
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , testEmailMessage.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'EmailMessage');
        pageRef.getParameters().put(OPTION , 'reply');
        
        Test.setCurrentPage(pageRef);
        
        Custom_Email_Controller theController = new Custom_Email_Controller();
        theController.templateDetails = 'Test Template';
        Test.startTest();
            theController.sendemail();
        Test.stopTest();
        
    }

    static testMethod void testSendEmailLead()
    {
        setupData();
        
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testLeadCase.Id);
        pageRef.getParameters().put(RECORD_ID , testLead.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , testEmailMessage.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'EmailMessage');
        pageRef.getParameters().put(OPTION , 'reply');
        
        Test.setCurrentPage(pageRef);
        
        Custom_Email_Controller theController = new Custom_Email_Controller();
        theController.templateDetails = 'Test Template';
        Test.startTest();
            theController.sendemail();
        Test.stopTest();
        
    }
    
    static testMethod void testSendEmail_FromDraft_PlainTemplate()
    {
        setupData();
        List<Attachment> draftEmailAttachments = TestUtils.createAttachments( 10 , testDraftEmail.Id, false);
        insert draftEmailAttachments;
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , testDraftEmail.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'Draft_Email__c');
        
        Test.setCurrentPage(pageRef);
        
        Custom_Email_Controller theController = new Custom_Email_Controller();
        theController.templateDetails = 'Test Template';
        Test.startTest();
            theController.sendemail();
        Test.stopTest();
    }
    
    static testMethod void testSendEmail_FromDraft_HTMLTemplate()
    {
        setupData();
        List<Attachment> draftEmailAttachments = TestUtils.createAttachments( 10 , testDraftEmail.Id, false);
        insert draftEmailAttachments;
        testCase.ContactId = null;
        update testCase;
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , testDraftEmail.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'Draft_Email__c');
        
        Test.setCurrentPage(pageRef);
        
        Custom_Email_Controller theController = new Custom_Email_Controller();
        theController.templateDetails = '<html>Test Template</html>';
        Test.startTest();
            theController.sendemail();
        Test.stopTest();
    }
    
    static testMethod void testCancel()
    {
        setupData();
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , testEmailMessage.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'EmailMessage');
        pageRef.getParameters().put(OPTION , 'reply');
        
        Test.setCurrentPage(pageRef);
        
        Custom_Email_Controller theController = new Custom_Email_Controller();
        theController.templateDetails = 'Test Template';
        Test.startTest();
            theController.cancel();
        Test.stopTest();
    }
    
    static testMethod void testSaveDraft_ExistingDraft()
    {
        setupData();
        List<Attachment> draftEmailAttachments = TestUtils.createAttachments( 10 , testDraftEmail.Id, false);
        insert draftEmailAttachments;
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , testDraftEmail.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'Draft_Email__c');
        
        Test.setCurrentPage(pageRef);
        
        Custom_Email_Controller theController = new Custom_Email_Controller();
        theController.templateDetails = 'Test Template';
        Test.startTest();
            theController.savedraft();
        Test.stopTest();
        
        List<Draft_Email__c> updatedDraftEmails = [SELECT Id , Body__c FROM Draft_Email__c WHERE Id = :testDraftEmail.Id];
    
        System.assertEquals(1 , updatedDraftEmails.size() , '1 Draft Email should have been returned');
        System.assertEquals(theController.templateDetails , updatedDraftEmails[0].Body__c , 'Body  should have been updated in the Draft Email');
    }
    
    
    static testMethod void testSaveDraft_NewDraft()
    {
        setupData();
        delete [SELECT Id FROM Draft_Email__c];//deleting the draft email that was created in setup
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'Draft_Email__c');
        
        Test.setCurrentPage(pageRef);
        
        Custom_Email_Controller theController = new Custom_Email_Controller();
        theController.templateDetails = 'Test Template';
        Test.startTest();
            theController.savedraft();
        Test.stopTest();
        
        List<Draft_Email__c> updatedDraftEmails = [SELECT Id , Body__c FROM Draft_Email__c];
    
        System.assertEquals(1 , updatedDraftEmails.size() , '1 Draft Email should have been created');
        System.assertEquals(theController.templateDetails , updatedDraftEmails[0].Body__c , 'Body should have been updated in the Draft Email');
    }
    
    static testMethod void testRemoveAttachFile()
    {
        setupData();
        List<Attachment> draftEmailAttachments = TestUtils.createAttachments( 10 , testDraftEmail.Id, false);
        insert draftEmailAttachments;
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , testDraftEmail.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'Draft_Email__c');
        
        Test.setCurrentPage(pageRef);
        
        Custom_Email_Controller theController = new Custom_Email_Controller();
        theController.templateDetails = 'Test Template';
        Test.startTest();
            theController.attachmentToDelete = draftEmailAttachments[0].Id;//delete 1 attachment
            theController.removeAttachFile();
        Test.stopTest();
        
        List<Attachment> availableAttachments =  [SELECT Id FROM Attachment WHERE ParentId = : testDraftEmail.Id];
        System.assertEquals(9  , availableAttachments.size() , '9 Attachments should have been returned as 1 is deleted');
    }
    
    static testMethod void testGetEmailOptions()
    {
        setupData();
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , testDraftEmail.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'Draft_Email__c');
        
        Test.setCurrentPage(pageRef);
        
        Custom_Email_Controller theController = new Custom_Email_Controller();
        theController.templateDetails = 'Test Template';
        Test.startTest();
            List<SelectOption> emailOptions = theController.getemailsOptions();
        Test.stopTest();
    }
    
    static testMethod void testGetCaseNumber()
    {
        setupData();
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , testDraftEmail.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'Draft_Email__c');
        
        Test.setCurrentPage(pageRef);
        
        Custom_Email_Controller theController = new Custom_Email_Controller();
        Test.startTest();
            String caseNumber = theController.caseNumber;
        Test.stopTest();
        System.assertNotEquals(null , caseNumber ,'Case number should have been populated');
    }
    
    
    static testMethod void testPopulateTemplateDetails()
    {
               
        setupData();
        String templateCode = 'Test Template';
        Test.startTest();
            Custom_Email_Controller.TemplateWrapper theTemplateWrapper = Custom_Email_Controller.populateTemplateDetails(templateCode , testCase.Id);
        Test.stopTest();
        
        System.assertEquals('No Template Body to display.', theTemplateWrapper.templateBody ,'Right message should have been returned');
    }
    
        
    static testMethod void testEmailMessageLoaded_For_HVCREmail_Reply_WithShortAddress()
    {
        
        setupData();
        HVCR_Email_New__c  anotherHvcrEmail = TestUtils.createHVCRMessage(SIZE , testCase.Id , false)[0];
        anotherHvcrEmail.BCCAddresses__c = 'testbccAddress@test.com';
        anotherHvcrEmail.CCAddresses__c = 'testccAddress@test.com';
        anotherHvcrEmail.Body__c  = 'Test Body';
        anotherHvcrEmail.IsInbound__c = true;
        insert anotherHvcrEmail;
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , anotherHvcrEmail.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'HVCR_Email_New__c');
        pageRef.getParameters().put(OPTION , 'reply');
        
        Test.setCurrentPage(pageRef);
        
        
        Test.startTest();
             Custom_Email_Controller theController = new Custom_Email_Controller();
        Test.stopTest();
        
    }
    
    static testMethod void testEmailMessageLoaded_For_HVCREmail_ReplyAll_WithShortAddress()
    {
        
        setupData();
        HVCR_Email_New__c  anotherHvcrEmail = TestUtils.createHVCRMessage(SIZE , testCase.Id , false)[0];
        anotherHvcrEmail.BCCAddresses__c = 'testbccAddress@test.com';
        anotherHvcrEmail.CCAddresses__c = 'testccAddress@test.com';
        anotherHvcrEmail.Body__c  = 'Test Body';
        anotherHvcrEmail.IsInbound__c = true;
        insert anotherHvcrEmail;
        
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
        pageRef.getParameters().put(CUSTOM_EMAIL_ID , anotherHvcrEmail.Id);
        pageRef.getParameters().put(OBJECT_NAME , 'HVCR_Email_New__c');
        pageRef.getParameters().put(OPTION , 'reply');
        
        Test.setCurrentPage(pageRef);
        
        
        Test.startTest();
              Custom_Email_Controller theController = new Custom_Email_Controller();
        Test.stopTest();
        
        System.assertEquals( hvcrEmail.CCAddresses__c , theController.cc , 'CC Address should have been populated as this is reply all');
        
    }
    
   
    
    static testMethod void testPopulateTemplateDetailsById()
    {
        setupData();
        Test.startTest();
             Custom_Email_Controller.TemplateWrapper theTemplateWrapper = Custom_Email_Controller.populateTemplateDetailsById('testTemplateCode' , testCase.Id);
        Test.stopTest();
        System.assertEquals('No Template Body to display.', theTemplateWrapper.templateBody ,'Right message should have been returned');
    }
    
    static testMethod void testPopulateTemplateDetailsWithMergeFieldsById()
    {
        setupData();
        Test.startTest();
             Custom_Email_Controller.TemplateWrapper theTemplateWrapper = Custom_Email_Controller.populateTemplateDetailsWithMergeFieldsById('testTemplateCode' , testCase.Id);
        Test.stopTest();
        System.assertEquals('No Template Body to display.', theTemplateWrapper.templateBody ,'Right message should have been returned');
        
    }
    
    static testMethod void testGetSuggestedTemplateCode()
    {
        setupData();
        Test.startTest();
            List<EmailTemplate> emailtemplates = Custom_Email_Controller.getSuggestedTemplateCode('xxx123');
            System.assertEquals(0 , emailTemplates.size() , 'EmailTemplates size should have been zero');
        Test.stopTest();
        
    }

    static testMethod void testCompleteEmailSendTestWithAttachments()
    {
        setupData();
        PageReference pageRef = Page.Custom_Email;
        pageRef.getParameters().put(ID , testCase.Id);
        pageRef.getParameters().put(RECORD_ID , testContact.Id);
         
        Test.setCurrentPage(pageRef);
        //instanciate the controller
        Custom_Email_Controller theController = new Custom_Email_Controller();
        //set properties
        theController.tohid = testContact.Id; //Contact Id
        theController.templateDetails = 'Test Template';
        theController.additionTo = 'test2@test2.test';
        theController.cc = 'testcc@test.test';
        theController.bcc = 'testbcc@test.test';
        theController.subject = 'Test Subject';

        theController.firstThreeAttachments[0].Body = Blob.valueOf('First Attachment');
        theController.firstThreeAttachments[0].Name = 'First Attachment';
        theController.remainingAttachments[0].Body = Blob.valueOf('Reamining Attachment');
        theController.remainingAttachments[0].Name = 'Remaining Attachment';


        Test.startTest();
            theController.sendemail();
        Test.stopTest();

        List<EmailMessage> emailMessages = [SELECT Id , subject FROM EmailMessage WHERE ParentId = :testCase.Id];
        System.assertEquals(2, emailMessages.size(), '2 Email Messages should have been there.');
    }
}