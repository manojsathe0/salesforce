@isTest
public class LimitedEmailControllerTest 
{
	static List<EmailMessage> testEmailMessages;
	static List<Task> testTasks;
	static List<HVCR_Email_New__c> testHVCRMessage;
	static final INTEGER RECORD_SIZE = 5;
	static final INTEGER ATTACHMENT_SIZE_PER_OBJECT = 2;
	static Case testCase;
	static List<Attachment> allAttachments;
	static void setupData()
	{
		testCase = TestUtils.createCases(1, true)[0];
		testEmailMessages =  TestUtils.createEmailMessages(RECORD_SIZE , testCase.Id , true);
		testTasks = TestUtils.createTasks(RECORD_SIZE , testCase.Id , true);
		testHVCRMessage = TestUtils.createHVCRMessage(RECORD_SIZE , testCase.Id , true);
		
		
		allAttachments = new List<Attachment>();
		
		for(EmailMessage eMessage : testEmailMessages)
		{
			allAttachments.addAll(TestUtils.createAttachments(ATTACHMENT_SIZE_PER_OBJECT , eMessage.Id, false));	
		}
		
		for(Integer i = 0; i<testTasks.size() ; ++i)
		{
			testTasks[i].Legacy_Id__c  = '12345'+i; //only the task with legacy id is pulled back.Hence setting.
			allAttachments.addAll(TestUtils.createAttachments(ATTACHMENT_SIZE_PER_OBJECT , testTasks[i].Id, false));	
		}
		
		for(HVCR_Email_New__c hvcrMessage : testHVCRMessage )
		{
			allAttachments.addAll(TestUtils.createAttachments(ATTACHMENT_SIZE_PER_OBJECT , hvcrMessage.Id, false));	
		}
		
		insert allAttachments;
		update testTasks;
	}
	
	
	static testMethod void testListOfEmail_Populated()
	{
		setupData();
		
		PageReference pageRef = Page.LimitedEmailList;
		Test.setCurrentPage(pageref);
		ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
		LimitedEmailController theController = new LimitedEmailController(stdController);
	
	
		Test.startTest();
			List<NewEmailControllerBase.AttachmentDetail> allAttachmentDetails = theController.ListOfEmail;
		Test.stopTest();
	
		System.assertEquals(RECORD_SIZE * 3 , allAttachmentDetails.size() , 'There should have been 15 of these');
	
	}
	
	static testMethod void testSendEMail()
	{
		setupData();
		
		PageReference pageRef = Page.LimitedEmailList;
		Test.setCurrentPage(pageref);
		ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
		LimitedEmailController theController = new LimitedEmailController(stdController);
	
	
		Test.startTest();
			PageReference thePage = theController.SendEmail();
		Test.stopTest();
	
	}
	
	static testMethod void testSendEMailDraft()
	{
		setupData();
		
		PageReference pageRef = Page.LimitedEmailList;
		Test.setCurrentPage(pageref);
		ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
		LimitedEmailController theController = new LimitedEmailController(stdController);
		Test.startTest();
			PageReference thePage = theController.SendEmailDraft();
		Test.stopTest();
	
	}
	
	static testMethod void testDeleteEMailDraft()
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
        PageReference pageRef = Page.EmailList;
        pageRef.getParameters().put('rowId', theDraft.Id);
        pageRef.getParameters().put('id', testCase.Id);
        Test.setCurrentPage(pageref);
        
        system.assertequals(theDraft.Id,pageRef.getParameters().get('rowId'));
        system.assertequals(testCase.Id,pageRef.getParameters().get('Id'));
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        LimitedEmailController theController = new LimitedEmailController(stdController);
        
        Test.startTest();
            PageReference thePage = theController.DeleteEmailDraft();
        Test.stopTest();
        
        List<Draft_Email__c> drafts  = [select id, Subject__c 
                                                           from Draft_Email__c 
                                                           where id  =: theDraft.Id]; 
       system.assertequals(0,drafts.size());    
	
	}
}