@isTest
public class EmailControllerTest
{
    static List<EmailMessage> testEmailMessages;
    static List<Task> testTasks;
    static List<HVCR_Email_New__c> testHVCRMessage;
    static final INTEGER RECORD_SIZE = 5;
    static final INTEGER ATTACHMENT_SIZE_PER_OBJECT = 2;
    static Case testCase;
    static List<Attachment> allAttachments;
    static Draft_Email__c testDraftEmail;
    
    static void setupData()
    {
        testCase = TestUtils.createCases(1, true)[0];
        testEmailMessages =  TestUtils.createEmailMessages(RECORD_SIZE , testCase.Id , true);
        testTasks = TestUtils.createTasks(RECORD_SIZE , testCase.Id , true);
        testHVCRMessage = TestUtils.createHVCRMessage(RECORD_SIZE , testCase.Id , true);
        
        testDraftEmail= TestUtils.createDraftEmails(1 , false)[0];
        testDraftEmail.Body__c = 'Draft Message Body';
        testDraftEmail.CCAddresses__c = 'draftCCAddress@test.com';
        testDraftEmail.bccaddresses__c = 'draftBccAddress@test.com';
        testDraftEmail.toaddresses__c = 'draftToAddress@test.com';
        testDraftEmail.additionToAddresses__c  = 'draftAdditionalToAddress@test.com';
        testDraftEmail.Case__c = testCase.Id;
        insert testDraftEmail;
        
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
        
        allAttachments.addAll(TestUtils.createAttachments(ATTACHMENT_SIZE_PER_OBJECT , testDraftEmail.Id, false));  
        insert allAttachments;
        update testTasks;
    }
    
    //This is testing that the ListOfEmail property on the controller is populated with all the records
    static testMethod void testListOfEmail_Populated()
    {
        setupData();
        
        PageReference pageRef = Page.EmailList;
        Test.setCurrentPage(pageref);
        pageRef.getParameters().put('id',testCase.id);
        EmailController theController = new EmailController();
    
    
        Test.startTest();
            List<NewEmailControllerBase.AttachmentDetail> allAttachmentDetails = theController.ListOfEmail;
        Test.stopTest();
    
        System.assertEquals(16 , allAttachmentDetails.size() , 'There should have been 16 of these');
    
    }
    
    static testMethod void testGetMessageDetail_EmailMessage()
    {
        setupData();
        
        PageReference pageRef = Page.EmailList;
        Test.setCurrentPage(pageref);
        pageRef.getParameters().put('id',testCase.id);
        //pageRef.getParameters().put('recordId',recordId);
        EmailController theController = new EmailController();
    
        theController.objectId = testEmailMessages[0].Id;
        theController.sObjectName = 'EmailMessage';
        
        Test.startTest();
            theController.getMessageDetail();
        Test.stopTest();
        
        NewEmailControllerBase.AttachmentDetail currentObject;
        
        for(NewEmailControllerBase.AttachmentDetail aDetail : theController.ListOfEmail)
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
        
        PageReference pageRef = Page.EmailList;
        Test.setCurrentPage(pageref);
        pageRef.getParameters().put('id',testCase.id);
        EmailController theController = new EmailController();
    
        theController.objectId = testHVCRMessage[0].Id;
        theController.sObjectName = 'HVCR_Email_New__c';
        
        Test.startTest();
            theController.getMessageDetail();
        Test.stopTest();
        
        NewEmailControllerBase.AttachmentDetail currentObject;
        
        for(NewEmailControllerBase.AttachmentDetail aDetail : theController.ListOfEmail)
        {
            if(aDetail.Id == theController.objectId)
            {
                currentObject = aDetail;
                break;  
            }
        }
        
        System.assertEquals(testHVCRMessage[0].BodyPlainText__c, currentObject.textBody , 'The text body should have been populated for the selected element in the list');
        
    }
    static testMethod void testGetMessageDetail_DraftEmail()
    {
        setupData();
        
        PageReference pageRef = Page.EmailList;
        Test.setCurrentPage(pageref);
        pageRef.getParameters().put('id',testCase.id);
        EmailController theController = new EmailController();
    
        theController.objectId = testDraftEmail.Id;
        theController.sObjectName = 'Draft_Email__c';
        
        Test.startTest();
            theController.getMessageDetail();
        Test.stopTest();
        
        NewEmailControllerBase.AttachmentDetail currentObject;
        
        for(NewEmailControllerBase.AttachmentDetail aDetail : theController.ListOfEmail)
        {
            if(aDetail.Id == theController.objectId)
            {
                currentObject = aDetail;
                break;  
            }
        }
        
        System.assertEquals(testDraftEmail.Body__c, currentObject.textBody , 'The text body should have been populated for the selected element in the list');
        
    }
    
    static testMethod void testGetMessageDetail_Task()
    {
        setupData();
        
        PageReference pageRef = Page.EmailList;
        Test.setCurrentPage(pageref);
        pageRef.getParameters().put('id',testCase.id);
        EmailController theController = new EmailController();
    
        theController.objectId = testTasks[0].Id;
        theController.sObjectName = 'Task';
        
        Test.startTest();
            theController.getMessageDetail();
        Test.stopTest();
        
        NewEmailControllerBase.AttachmentDetail currentObject;
        
        for(NewEmailControllerBase.AttachmentDetail aDetail : theController.ListOfEmail)
        {
            if(aDetail.Id == theController.objectId)
            {
                currentObject = aDetail;
                break;  
            }
        }
        
        System.assertEquals(testTasks[0].Description, currentObject.textBody , 'The text body should have been populated for the selected element in the list');
        
    }
    
    
    static testMethod void testSendEMail()
    {
        setupData();
        
        PageReference pageRef = Page.EmailList;
        Test.setCurrentPage(pageref);
        pageRef.getParameters().put('id',testCase.id);
        EmailController theController = new EmailController();
    
    
        Test.startTest();
            PageReference thePage = theController.SendEmail();
        Test.stopTest();
    
    }
    
    static testMethod void testSendEMailDraft()
    {
        setupData();
        
        PageReference pageRef = Page.EmailList;
        Test.setCurrentPage(pageref);
        pageRef.getParameters().put('id',testCase.id);
        EmailController theController = new EmailController();
        Test.startTest();
            PageReference thePage = theController.SendEmailDraft();
        Test.stopTest();
    
    }
    
    static testMethod void testDeleteEMailDraft()
    {
        setupData();
        
        PageReference pageRef = Page.EmailList;
        pageRef.getParameters().put('rowId', testDraftEmail.Id);
        pageRef.getParameters().put('id', testCase.Id);
        Test.setCurrentPage(pageref);
        
        system.assertequals(testDraftEmail.Id,pageRef.getParameters().get('rowId'));
        system.assertequals(testCase.Id,pageRef.getParameters().get('Id'));
        
        EmailController theController = new EmailController();
        
        Test.startTest();
            PageReference thePage = theController.DeleteEmailDraft();
        Test.stopTest();
        
        List<Draft_Email__c> drafts  = [select id, Subject__c 
                                                           from Draft_Email__c 
                                                           where id  =: testDraftEmail.Id]; 
       system.assertequals(0,drafts.size());    
    }
    
}