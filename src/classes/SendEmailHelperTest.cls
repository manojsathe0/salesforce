@isTest
public with sharing class SendEmailHelperTest
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
       PageReference pageReference =  Page.NewEmailList;
	   pageReference.getParameters().put('objectName', OBJECT_NAME);
	   pageReference.getParameters().put('objectId', testEmaillMessage.Id);
	   
	   Test.setCurrentPage(pageReference);
	       
       Test.startTest();
       		PageReference pRef = SendEmailHelper.SendEmail('NewEmailList');
       Test.stopTest();
	 }
	 
	 static testmethod void testHVCRSendEmail()
	 {
  	   
  	   setupData();
       PageReference pageReference =  Page.NewEmailList;
	   pageReference.getParameters().put('objectName', HVCR_EMAIL_OBJECT);
	   pageReference.getParameters().put('objectId', hvcrEmailMessage.Id);
	   pageReference.getParameters().put('id', testCase.Id);
	   
	   Test.setCurrentPage(pageReference);
	       
       Test.startTest();
       		PageReference pRef = SendEmailHelper.SendEmail('NewEmailList');
       Test.stopTest();
	 }
}