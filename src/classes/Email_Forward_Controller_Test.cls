@isTest 
public with sharing class Email_Forward_Controller_Test 
{
	static EmailMessage testEmailMessage;
	static Case testCase;
	static Contact testContact;
	static Account testAccount;
	static final Integer SIZE = 1;
	static final String ID = 'id';
	static final String CUSTOM_EMAIL_ID = 'customemailid';
	static final String OBJECT_NAME = 'objectName';
	static final String OPTION = 'option';
	static HVCR_Email_New__c hvcrEmail;
	static Draft_Email__c testDraftEmail;
	
	static void setupData()
	{
		testAccount = TestUtils.createAccounts(SIZE , 'Test Account', true)[0];
		testContact = TestUtils.createContacts( SIZE ,  'Buffet ', testAccount.Id , true)[0];
		testCase = TestUtils.createCases( SIZE, false)[0];
		testCase.ContactId = testContact.Id;
		testCase.Email_Subject__c  = 'Test Subject';
		insert testCase;
		
		testEmailMessage = TestUtils.createEmailMessages(SIZE , testCase.Id , false)[0];
		testEmailMessage.FromAddress = 'testFromAddress@test.com';
		testEmailMessage.Incoming = true;
		testEmailMessage.CcAddress = 'testCcAddress@test.com';
		testEmailMessage.BccAddress = 'testBccAddress@test.com';
		testEmailMessage.HtmlBody = 'Test Body';
		
		insert testEmailMessage;
		
		hvcrEmail = TestUtils.createHVCRMessage(SIZE , testCase.Id , false)[0];
		hvcrEmail.FromAddressLong__c = 'testFromEmail@test.com';
		hvcrEmail.ToAddressesLong__c = 'testToEmail@test.com';
		hvcrEmail.IsInbound__c = true;
		hvcrEmail.Body__c = 'Test Body';
		insert hvcrEmail;
		
		testDraftEmail= TestUtils.createDraftEmails(1 , false)[0];
		testDraftEmail.Body__c = 'Draft Message Body';
		testDraftEmail.CCAddresses__c = 'draftCCAddress@test.com';
		testDraftEmail.bccaddresses__c = 'draftBccAddress@test.com';
		testDraftEmail.toaddresses__c = 'draftToAddress@test.com';
		testDraftEmail.additionToAddresses__c  = 'draftAdditionalToAddress@test.com';
		testDraftEmail.Case__c = testCase.Id;
		insert testDraftEmail;
	}
	
	static testMethod void testForwardEmailFor_EmailMessage()
	{
		setupData();
		List<Attachment> draftEmailAttachments = TestUtils.createAttachments( 10 , testEmailMessage.Id, false);
		insert draftEmailAttachments;
		
		PageReference pageRef = Page.Email_Forward_Page;
		pageRef.getParameters().put(ID , testCase.Id);
		pageRef.getParameters().put('value' , testEmailMessage.Id);
		pageRef.getParameters().put('objectName' , 'EmailMessage');
		Test.setCurrentPage(pageRef);
		Test.startTest();
			Email_Forward_Controller theController = new Email_Forward_Controller();
			theController.sendEmail();
		Test.stopTest();
	}
	
	static testMethod void testForwardEmailFor_HVCRMessage()
	{
		setupData();
		List<Attachment> draftEmailAttachments = TestUtils.createAttachments( 10 , hvcrEmail.Id, false);
		insert draftEmailAttachments;
		
		PageReference pageRef = Page.Email_Forward_Page;
		pageRef.getParameters().put(ID , testCase.Id);
		pageRef.getParameters().put('value' , hvcrEmail.Id);
		pageRef.getParameters().put('objectName' , 'HVCR_Email_New__c');
		Test.setCurrentPage(pageRef);
		Test.startTest();
			Email_Forward_Controller theController = new Email_Forward_Controller();
			theController.tohid = testContact.Id;
			theController.sendEmail();
		Test.stopTest();
	}
	
	static testMethod void testMethods()
	{
		setupData();
		List<Attachment> draftEmailAttachments = TestUtils.createAttachments( 10 , hvcrEmail.Id, false);
		insert draftEmailAttachments;
				
		PageReference pageRef = Page.Email_Forward_Page;
		pageRef.getParameters().put(ID , testCase.Id);
		pageRef.getParameters().put('value' , hvcrEmail.Id);
		pageRef.getParameters().put('objectName' , 'HVCR_Email_New__c');
		Test.setCurrentPage(pageRef);
		Email_Forward_Controller theController = new Email_Forward_Controller();
		
		Test.startTest();
			theController.ClearResult();
			theController.Cancel();
			theController.sendAndClose();
			List<Email_Forward_Controller.FileDetail> files = theController.attfile;
			List<SelectOption> selectOptions = theController.getemailsOptions();
		Test.stopTest();
	}
}