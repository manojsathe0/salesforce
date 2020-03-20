/*
Batch class to collect Opps and reassign them to new owners as well as the Contacts to which they belong.
Created by: Artyom M.
Story: B-18815
*/

@isTest
public class SEAD_ContactOpportunityExitBatchTest {
    static ID userRoleID = [SELECT ID FROM UserRole WHERE Name = 'VP Customer Care'][0].Id;
    static List<Team_Management__c> tmRecords = new List<Team_Management__c>();
    static Team_Management__c teamManage1, teamManage2;
    static ID salesManager;
    static User userTest, userTest2;
    static List<Opportunity> testOpps;
    static List<User> addUser;
    static ID managerProfileID = [SELECT Id FROM Profile WHERE Name LIKE '%Sales Specialist%' LIMIT 1][0].id;
    
    static void setupData() {
        List<Profile> salesProfile = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Sales Specialist%' LIMIT 1];
        List<Profile> nonSalesProfile = [SELECT Id, Name FROM Profile WHERE (NOT Name LIKE '%Sales%') LIMIT 1];
        System.Debug(nonSalesProfile[0].Name);
        System.Debug(salesProfile[0].Name);
                if(!salesProfile.isEmpty())
                {
                    //salesAgentProfileId = 
                }
        addUser = new List<User>();
        userTest = new User(FirstName='Leaver', LastName='SalesRep', UserName='arm54321@legalzoom.test', Email='test91@legalzoom.com', Alias='tester91',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='Arm54321@legalzoom',
                ProfileId = nonSalesProfile[0].Id, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest);
        userTest2 = new User(FirstName='Reciever', LastName='SalesRep2', UserName='arm54@legalzoom.test', Email='test911@legalzoom.com', Alias='tester1',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm54@legalzoom',
                ProfileId = salesProfile[0].Id, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest2);
        
        User salesMan= new User(FirstName='TestSalesMang', LastName='TestSalesMang', UserName='TestSalesMang@legalzoom.test', Email='TestSalesMang@legalzoom.com', Alias='sales77',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='TestSalesMang@legalzoom',
                ProfileId = managerProfileID, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true);
        addUser.add(salesMan);
        
        System.runAs(TestUtils.ADMIN_USER) {
        	SEAD_Configuration__c config = new SEAD_Configuration__c();
            config.Name = 'Default';
            config.Lead_Days_from_Ownership__c = 0;     
	        config.Lead_New_Stage_Activity_Limit__c = 1;
	        config.Lead_Qualified_Stage_Activity_Limit__c = 2;
	        config.Lead_Validated_Stage_Activity_Minimum__c = 3;
	        config.Lead_Abandoner_Score__c = 1;
	        config.Lead_Chat_Score__c = 1;	        
	        config.Lead_Email_Score__c = 1;
	        config.Lead_Inbound_Score__c = 2;
	        config.Lead_Mobile_Score__c = 3;
	        config.Lead_Score_Initial__c = 3;
	        config.Lead_Social_Media_Score__c = 1;
	        config.Opp_Days_from_Ownership__c = 3;

            insert config;
        	
        	insert addUser;
        	
        	
        }
        
        
        System.Debug(userTest.Id);
        
            teamManage1 = new Team_Management__c();
            teamManage1.User__c = userTest.Id;
            teamManage1.Approval_Manager__c = salesManager;
            teamManage1.Manager__c = salesMan.Id;
            teamManage1.Compliance_Status__c = 'Live';
            teamManage1.Compliance_RR__c = true;
            teamManage1.Pulled__c = false;
            tmRecords.add(teamManage1);

            teamManage2 = new Team_Management__c();
            teamManage2.User__c = userTest2.Id;
            teamManage2.Approval_Manager__c = salesManager;
            teamManage2.Manager__c = salesMan.Id;
            teamManage2.Compliance_Status__c = 'Live';
            teamManage2.Compliance_RR__c = true;
            teamManage2.Pulled__c = false;
            tmRecords.add(teamManage2);
        insert tmRecords;
        
        List<Account> testAcc = TestUtils.createAccounts(1, 'Smith', false);
	 	testAcc[0].OwnerId = userTest.Id;
	 	insert testAcc;

		List<Contact> testCnt = TestUtils.createContacts(1, 'Smith', testAcc[0].Id, false);
		testCnt[0].OwnerId = userTest.Id;
		insert testCnt;
		
        testOpps = TestUtils.createOpportunities(2, 'Smith', false);
	 	for (Opportunity opp : testOpps) {
	 		opp.StageName = 'New';
	 		opp.Product2__c = 'LLC';
	 		opp.Ownership_Date__c = System.Now();
	 		opp.Contact__c = testCnt[0].Id;
	 		opp.AccountId = testAcc[0].Id;
            opp.OwnerId = userTest.Id;
	 	}
	 	insert testOpps;
	 	
	 	System.Debug('Leaving: ' + userTest.Id);
        System.Debug('Getting: ' + userTest2.Id);
   
    }
    
    static testMethod void ContactOpportunityExitBatch_Test() {
        setupData();
        
        Test.StartTest();
        /*
        SEAD_ContactOpportunityExitBatch theBatch = new SEAD_ContactOpportunityExitBatch();
     	Database.executeBatch(theBatch);
     	*/
     	
     	SEAD_ContactOpportunityExitBatchSchedule myClass = new SEAD_ContactOpportunityExitBatchSchedule();
        String chron = '0 0 23 * * ?';
        system.schedule('Test Sched', chron, myClass);
        
        List<Opportunity> opps = [SELECT Id, OwnerId FROM Opportunity];
     	for (Opportunity opp : opps) {
     		//System.assertEquals(opp.OwnerId, userTest2.Id, 'Opportunuity was not reassigned.');
     	}
     	
	    Test.StopTest();   
    }

}