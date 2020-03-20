@isTest
public class NewLimitedEmailControllerTest 
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
		
		PageReference pageRef = Page.Email_Attachments_Page;
		Test.setCurrentPage(pageref);
		ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
		NewLimitedEmailController theController = new NewLimitedEmailController(stdController);
	
	
		Test.startTest();
			List<EmailControllerBase.AttachmentDetail> allAttachmentDetails = theController.ListOfEmail;
		Test.stopTest();
	
		System.assertEquals(RECORD_SIZE * 3 , allAttachmentDetails.size() , 'There should have been 15 of these');
	
	}
}