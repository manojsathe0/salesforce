/*
Log a Call for Opps and Lead, Ltng version.
Created by Artyom M.
Per Story: B-25879

*/

@isTest
public class LogCallLeadOppControllerTest_Ltng {
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

                //ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
                //LogCallLeadController theController = new LogCallLeadController(sc);
                //(Id leadId, String contactStatus, String reasonForContact, String reasonForTransfer, String otherReason, String description)
                

                Test.startTest();
                	LogCallLeadOppController_Ltng.getContactStatusValues();
                	LogCallLeadOppController_Ltng.getReasonForContactValues();
                	LogCallLeadOppController_Ltng.getReasonForTransferValues();
                	LogCallLeadOppController_Ltng.createTaskLead(testLead.Id, 'contactStatus', 'reasonForContact', 'reasonForTransfer', 'otherReason', 'description');
                Test.stopTest();
            }
            List<Task> createdTasks = [SELECT Id , Subject FROM Task WHERE WhoId =:testLead.Id];
            System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
            List<Lead> leads = [SELECT Id , Status ,ownerId FROM Lead Where Id = :testLead.Id];
            System.assertEquals(1 , leads.size() , '1 Lead should have been returned');
            System.assertEquals(theUser.Id , leads[0].ownerId , 'Existing owner should be maintained as this is not commission Task');
            
        }
        
        static testMethod void testCreateTask() {
     	
	     	Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
	        Contact testContact = TestUtils.createContacts(1 , 'Test Contact' , testAccount.Id , false)[0];
	        testContact.Genesys_Interaction_Id__c = '998899';
	        insert testContact;
	        
	        System.Debug(testContact);
	        List<Opportunity> testOpps = TestUtils.createOpportunities(1, 'Smith', false);
			 	for (Opportunity opp : testOpps) {
			 		opp.StageName = 'New';
			 		opp.Product2__c = 'LLC';
			 		opp.Contact__c = testContact.Id;
			 		opp.AccountId = testAccount.Id;
			 	}
			 	try {
			 		insert testOpps;
			 	}
			 	catch (DMLException ex) {
			 		System.Debug('ERROR HERE: ' + ex.getMessage());
			 	}
			 	
			 	System.Debug(testOpps[0]);
			 	Task theTask = new Task();
	                    theTask.WhoId = testContact.Id;
	                    theTask.Description = 'Test Description';
	                    theTask.Reason_For_Contact__c = 'Transfer';
	                    theTask.Reason_For_Transfer__c = 'Test';
	                    theTask.CallObject = '998899';
	                    
	                    
	                    try {
			 		insert theTask;
			 	}
			 	catch (DMLException ex) {
			 		System.Debug('ERROR HERE: ' + ex.getMessage());
			 	}
			 	
				Id theId = testOpps[0].Id;
	                
	                Test.startTest(); 
	                try {
	                	 LogCallLeadOppController_Ltng.createTaskOpp(theId, 'contactStatus', 'reasonForContact', 'reasonForTransfer', 'otherReason', 'description');
	                
	                }
	                catch (Exception e) {
	                	
	                }
	               
	                Test.stopTest();
	        
	     }
    
}