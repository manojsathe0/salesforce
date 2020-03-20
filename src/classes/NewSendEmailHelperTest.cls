@isTest
public with sharing class NewSendEmailHelperTest
{
     final static String OBJECT_NAME = 'EmailMessage';
     final static String HVCR_EMAIL_OBJECT = 'HVCR_Email_New__c';
     static EmailMessage testEmaillMessage;
     final static Integer SIZE = 1;
     static Case testCase;
     static Attachment testAttachment;
     static HVCR_Email_New__c hvcrEmailMessage;
     final static String CC_ADDRESS = 'test@testy.test1;test@testy.tes2';
     final static String BCC_ADDRESS = 'test@testy.test3;test@testy.tes4';
     static void setupData()
     {
        testCase = TestUtils.createCases(SIZE , true)[0];
        testEmaillMessage = TestUtils.createEmailMessages(SIZE , testCase.Id , false)[0];
        testEmaillMessage.ToAddress = 'test@testy.test';
        testEmaillMessage.CcAddress = CC_ADDRESS;
        testEmaillMessage.BccAddress = BCC_ADDRESS;
        insert testEmaillMessage;
        
        testAttachment = new Attachment();
        testAttachment.Name = 'Test Attach';
        testAttachment.ParentId = testEmaillMessage.Id;
        testAttachment.Body = Blob.valueOf('Test Body');
        insert testAttachment;
        
        
        hvcrEmailMessage = TestUtils.createHVCRMessage(SIZE , testCase.Id , false)[0];
        hvcrEmailMessage.ToAddresses__c = 'test@testy.test';
        
        insert hvcrEmailMessage;
        
        Attachment hvcrTestAttachment = new Attachment();
        hvcrTestAttachment.Name = 'Test Attach';
        hvcrTestAttachment.ParentId = hvcrEmailMessage.Id;
        hvcrTestAttachment.Body = Blob.valueOf('Test Body');
        insert hvcrTestAttachment;
        
     }
     static testmethod void testSendEmail()
     {
       
       setupData();
       PageReference pageReference =  Page.EmailList;
       pageReference.getParameters().put('objectName', OBJECT_NAME);
       pageReference.getParameters().put('objectId', testEmaillMessage.Id);
       
       Test.setCurrentPage(pageReference);
       Test.startTest();
            PageReference pRef = NewSendEmailHelper.SendEmail(pageReference);
       Test.stopTest();
     }
     
     static testmethod void testHVCRSendEmail()
     {
       
       setupData();
       PageReference pageReference =  Page.EmailList;
       pageReference.getParameters().put('objectName', HVCR_EMAIL_OBJECT);
       pageReference.getParameters().put('objectId', hvcrEmailMessage.Id);
       pageReference.getParameters().put('id', testCase.Id);
       
          
       Test.setCurrentPage(pageReference);
       Test.startTest();
            PageReference pRef = NewSendEmailHelper.SendEmail(pageReference);
       Test.stopTest();
     }
     
     static testmethod void testSendDraftEmail()
     {
       
       setupData();
       PageReference pageReference =  Page.EmailList;
       Draft_Email__c theDraft = TestUtils.createDraftEmails(1, false)[0];
       theDraft.ToAddresses__c = 'testxx45@test.test';
       theDraft.CCAddresses__c = 'testxx45@test.test1';
       theDraft.BCCAddresses__c = 'testxx45@test.test2';
       theDraft.Subject__c = 'Draft Test';
       theDraft.Case__c = testCase.Id;
       insert theDraft;
        
       pageReference.getParameters().put('rowId', theDraft.Id);
       pageReference.getParameters().put('id', testCase.Id);
       
       Test.setCurrentPage(pageReference);
       Test.startTest();
            PageReference pRef = NewSendEmailHelper.sendEmailDraft(pageReference);
       Test.stopTest();
     }
     
     static testmethod void testDeleteDraftEmail()
     {
       
       setupData();
       PageReference pageReference =  Page.EmailList;
       Draft_Email__c theDraft = TestUtils.createDraftEmails(1, false)[0];
       theDraft.ToAddresses__c = 'testxx45@test.test';
       theDraft.CCAddresses__c = 'testxx45@test.test1';
       theDraft.BCCAddresses__c = 'testxx45@test.test2';
       theDraft.Subject__c = 'Draft Delete Test';
       theDraft.Case__c = testCase.Id;
       insert theDraft;
        
       pageReference.getParameters().put('rowId', theDraft.Id);
       pageReference.getParameters().put('id', testCase.Id);
       Test.setCurrentPage(pageReference);
       system.assertequals(theDraft.Id,pageReference.getParameters().get('rowId'));
       system.assertequals(testCase.Id,pageReference.getParameters().get('Id'));
       Test.startTest();
            PageReference pRef = NewSendEmailHelper.DeleteEmailDraft(pageReference);
       Test.stopTest();
       
       List<Draft_Email__c> drafts  = [select id, Subject__c 
        												   from Draft_Email__c 
                                                           where id  =: theDraft.Id]; 
       system.assertequals(0,drafts.size());
       system.assertequals(' Email has been deleted successfully.',pageReference.getParameters().get('message'));
       
       
     }
}