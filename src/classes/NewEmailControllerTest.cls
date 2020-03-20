@isTest
public class NewEmailControllerTest
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
	
	//This is testing that the ListOfEmail property on the controller is populated with all the records
	static testMethod void testListOfEmail_Populated()
	{
		setupData();
		
		PageReference pageRef = Page.NewEmailList;
		Test.setCurrentPage(pageref);
		ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
		NewEmailController theController = new NewEmailController(stdController);
	
	
		Test.startTest();
			List<EmailControllerBase.AttachmentDetail> allAttachmentDetails = theController.ListOfEmail;
		Test.stopTest();
	
		System.assertEquals(RECORD_SIZE * 3 , allAttachmentDetails.size() , 'There should have been 15 of these');
	
	}
	
	static testMethod void testGetMessageDetail_EmailMessage()
	{
		setupData();
		
		PageReference pageRef = Page.NewEmailList;
		Test.setCurrentPage(pageref);
		ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
		NewEmailController theController = new NewEmailController(stdController);
	
		theController.objectId = testEmailMessages[0].Id;
		theController.sObjectName = 'EmailMessage';
		
		Test.startTest();
			theController.getMessageDetail();
		Test.stopTest();
		
		EmailControllerBase.AttachmentDetail currentObject;
		
		for(EmailControllerBase.AttachmentDetail aDetail : theController.ListOfEmail)
		{
			if(aDetail.Id == theController.objectId)
			{
				currentObject = aDetail;
				break;	
			}
		}
		
		System.assertEquals(testEmailMessages[0].TextBody, currentObject.textBody , 'The text body should have been populated for the selected element in the list');
		
	}
	
	
	static testMethod void testGetMessageDetail_HVCRMEssage()
	{
		setupData();
		
		PageReference pageRef = Page.NewEmailList;
		Test.setCurrentPage(pageref);
		ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
		NewEmailController theController = new NewEmailController(stdController);
	
		theController.objectId = testHVCRMessage[0].Id;
		theController.sObjectName = 'HVCR_Email_New__c';
		
		Test.startTest();
			theController.getMessageDetail();
		Test.stopTest();
		
		EmailControllerBase.AttachmentDetail currentObject;
		
		for(EmailControllerBase.AttachmentDetail aDetail : theController.ListOfEmail)
		{
			if(aDetail.Id == theController.objectId)
			{
				currentObject = aDetail;
				break;	
			}
		}
		
		System.assertEquals(testHVCRMessage[0].BodyPlainText__c, currentObject.textBody , 'The text body should have been populated for the selected element in the list');
		
	}
	
	static testMethod void testGetMessageDetail_Task()
	{
		setupData();
		
		PageReference pageRef = Page.NewEmailList;
		Test.setCurrentPage(pageref);
		ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
		NewEmailController theController = new NewEmailController(stdController);
	
		theController.objectId = testTasks[0].Id;
		theController.sObjectName = 'Task';
		
		Test.startTest();
			theController.getMessageDetail();
		Test.stopTest();
		
		EmailControllerBase.AttachmentDetail currentObject;
		
		for(EmailControllerBase.AttachmentDetail aDetail : theController.ListOfEmail)
		{
			if(aDetail.Id == theController.objectId)
			{
				currentObject = aDetail;
				break;	
			}
		}
		
		System.assertEquals(testTasks[0].Description, currentObject.textBody , 'The text body should have been populated for the selected element in the list');
		
	}
	
}