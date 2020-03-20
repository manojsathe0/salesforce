@isTest
public class LogCallLeadControllerTest {
    
    static final String CONTACT_STATUS = 'Contacted/Spoke';
    static final String COMMISSION_CONTACT_STATUS = 'Contacted/Spoke - Commission Eligible';

    //static final String LEAD_STATUS = 'Order Placed';
    static final String QUALIFIED_INTERESTED = 'Qualified (Interested)';

    static void setupDataSEAD()
        {
            SEAD_Configuration__c config = new SEAD_Configuration__c();
            config.Name = 'Default';
            config.Lead_New_Stage_Activity_Limit__c = 1;
            config.Lead_Qualified_Stage_Activity_Limit__c = 2;
            config.Lead_Validated_Stage_Activity_Minimum__c = 3;
            config.Lead_Abandoner_Score__c = 1;
            config.Lead_Chat_Score__c = 1;
            config.Lead_Days_from_Ownership__c = 2;
            config.Lead_Email_Score__c = 1;
            config.Lead_Inbound_Score__c = 2;
            config.Lead_Mobile_Score__c = 3;
            config.Lead_Score_Initial__c = 3;
            config.Lead_Social_Media_Score__c = 1;


            insert config;
        }
    
    static testMethod void testCreateTask_TestEmail()
    {
            setupDataSEAD();
            Lead testLead = TestUtils.createLeads(1 , 'Test LastName' , false)[0];
            testLead.Genesys_Interaction_Id__c = '998899';
            insert testLead;
           
            ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
            LogCallLeadController theController = new LogCallLeadController(sc);
            PageReference pageRef = Page.LogCallLead;
            pageRef.getParameters().put('id', String.valueOf(testLead.Id));
            Test.setCurrentPage(pageRef);

            Test.startTest();
                theController.theTask.Contact_Status__c = CONTACT_STATUS;
                theController.createEmailTask();
            Test.stopTest();

            List<Task> createdTasks = [SELECT Id , Subject FROM Task WHERE WhoId =:testLead.Id];
            System.assertEquals('Activity Now' , createdTasks[0].Subject , 'Right subject should have been populated');
            List<Lead> leads = [SELECT Id , Lead_Call_Status__c FROM Lead Where Id = :testLead.Id];
            System.assertEquals(1 , leads.size() , '1 Lead should have been returned');
            System.assertEquals(CONTACT_STATUS , leads[0].Lead_Call_Status__c , 'Right Call status should have been populated');
        }
        
        static testMethod void testCreateTask_LeadStatus()
        {
			setupDataSEAD();
            User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , false);
            Lead testLead = TestUtils.createLeads(1 , 'Test LastName' , false)[0];
            System.runAs(theUser)
            {
                testLead.Genesys_Interaction_Id__c = '998899';
                insert testLead;
                Task theTask = new Task();
                theTask.WhoId = testLead.Id;
                theTask.Description = 'Test Description';
                theTask.CallObject = '998899';
                insert theTask; 

                ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
                LogCallLeadController theController = new LogCallLeadController(sc);
                PageReference pageRef = Page.LogCallLead;
                pageRef.getParameters().put('id', String.valueOf(testLead.Id));
                Test.setCurrentPage(pageRef);
                Test.startTest();
                        theController.theTask.Call_Type__c = 'Inbound';
                        theController.theTask.Contact_Status__c = CONTACT_STATUS;
                        theController.theTask.Description = 'Test';
                        theController.createTask(); 
                Test.stopTest();
            }
            List<Task> createdTasks = [SELECT Id , Subject FROM Task WHERE WhoId =:testLead.Id];
            System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
            List<Lead> leads = [SELECT Id , Status ,ownerId FROM Lead Where Id = :testLead.Id];
            System.assertEquals(1 , leads.size() , '1 Lead should have been returned');
            System.assertEquals(theUser.Id , leads[0].ownerId , 'Existing owner should be maintained as this is not commission Task');
        }

        static testMethod void testCreateCommissionTask()
        {
			setupDataSEAD();
            User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , false);
            Lead testLead = TestUtils.createLeads(1 , 'Test LastName' , false)[0];
            System.runAs(theUser)
            {
                testLead.Genesys_Interaction_Id__c = '998899';
                insert testLead;
                
                Task theTask = new Task();
                theTask.WhoId = testLead.Id;
                theTask.Description = 'Test Description';
                theTask.CallObject = '998899';
                insert theTask;

                ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
                LogCallLeadController theController = new LogCallLeadController(sc);
                PageReference pageRef = Page.LogCallLead;
                pageRef.getParameters().put('id', String.valueOf(testLead.Id));
                Test.setCurrentPage(pageRef);
                Test.startTest();
                        theController.theTask.Contact_Status__c = COMMISSION_CONTACT_STATUS;
                        theController.createTask(); 
                Test.stopTest();
            }

            List<Task> createdTasks = [SELECT Id , Subject FROM Task WHERE WhoId =:testLead.Id];
            System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
           
            List<Lead> leads = [SELECT Id , Status , ownerId FROM Lead Where Id = :testLead.Id];
            System.assertEquals(1 , leads.size() , '1 Lead should have been returned');
            System.assertEquals(theUser.Id , leads[0].ownerId , 'Right owner Id should have been populated.Lead should have been assigned to user as this is commission Task');
        }
}