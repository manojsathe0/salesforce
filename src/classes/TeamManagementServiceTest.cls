@isTest
public class TeamManagementServiceTest 
{
	final static Integer SIZE = 10;
	static List<Team_Management__c> testTeamManagements;
	static List<User> testUsers, testUserManager;
	final static String MANAGER_PROFILE_NAME = 'Sales - Management';
	final static String SALE_LEAD_ROLE_NAME = 'Sales Lead';
	final static String SALE_MANAGER_ROLE_NAME = 'Sales Manager';
	static User theManager, theApprovalManager, theAssistantManager, theLeadSupervisor;
	
	static void setupDataForPopulateUser()
	{
		//Create Sale Agent User
		testUsers = new List<User>();
		testUserManager = new List<User>();
		testTeamManagements = new List<Team_Management__c>();

		for(Integer i = 0; i<10 ;++i)
		{
			User testUser = TestUtils.createUser('Sangsom'+i, TestUtils.salesAgentProfileId , false);
			testUser.CommunityNickname = 'Sangsom'+i;//needs to be unique
	    	testUser.Alias = 'Sangsom'+i;
			testUsers.add(testUser);
			
		}
		System.runAs(TestUtils.ADMIN_USER)
		{
			insert testUsers;
		}
		
		//Create Manager
		theManager = new User(FirstName='Test', LastName='Manager', UserName='test_manager@test.test', Email='test_manager@test.com', Alias='tester91',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='test91',
                ProfileId = TestUtils.salesMgrProfileId, UserRoleId = managerRoleId(SALE_MANAGER_ROLE_NAME), TimeZoneSidKey='America/New_York',isActive = true );
		//Create Approval Manager
		theApprovalManager = new User(FirstName='Test', LastName='ApprovalManager', UserName='test_appmanager@test.test', Email='test_appmanager@test.com', Alias='tester92',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='test92',
                ProfileId = TestUtils.salesMgrProfileId, UserRoleId = managerRoleId(SALE_MANAGER_ROLE_NAME), TimeZoneSidKey='America/New_York',isActive = true );
		//Create Assistant Manager
		theAssistantManager = new User(FirstName='Test', LastName='AssistantManager', UserName='test_assistmanager@test.test', Email='test_assistmanager@test.com', Alias='tester93',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='test93',
                ProfileId = TestUtils.salesMgrProfileId, UserRoleId = managerRoleId(SALE_MANAGER_ROLE_NAME), TimeZoneSidKey='America/New_York',isActive = true );
		//Create Lead Supervisor
		theLeadSupervisor = new User(FirstName='Test', LastName='LeadSupervisor', UserName='test_leadsuper@test.test', Email='test_leadsuper@test.com', Alias='tester94',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='test94',
                ProfileId = TestUtils.salesMgrProfileId, UserRoleId = managerRoleId(SALE_LEAD_ROLE_NAME), TimeZoneSidKey='America/New_York',isActive = true );

		testUserManager.add(theManager);
		testUserManager.add(theApprovalManager);
		testUserManager.add(theAssistantManager);
		testUserManager.add(theLeadSupervisor);
		
		System.runAs(TestUtils.ADMIN_USER)
		{
			insert testUserManager;
		}
	}
	
	public static testMethod void TestInsertCheckTeamManagementUserDuplicateRecord_Positive()
	{
		setupDataForPopulateUser();
		List<Team_Management__c> tmListInsert = new List<Team_Management__c>();
		System.assertEquals(10, testUsers.size());
		for(Integer i = 0; i<SIZE ;++i)
		{
			Team_Management__c tmNew = new Team_Management__c();
			tmNew.User__c = testUsers[i].Id;
			if(i == 1)
			{
				tmNew.Approval_Manager__c = theApprovalManager.Id;
				tmNew.Manager__c = null;
				tmNew.Assistant_Manager__c = null;
				tmNew.Lead_Supervisor__c = null;
			}
			else
			{
				tmNew.Approval_Manager__c = theApprovalManager.Id;
				tmNew.Manager__c = theManager.Id;
				tmNew.Assistant_Manager__c = theAssistantManager.Id;
				tmNew.Lead_Supervisor__c = theLeadSupervisor.Id;
			}
			
			tmListInsert.add(tmNew);
		}
		System.runAs(theManager)
		{
			Test.startTest();
				insert tmListInsert;
			Test.stopTest();
		}
		
		Set<Id> tmID = new Set<Id>();
		for(Team_Management__c tm : tmListInsert)
		{
			tmID.add(tm.Id);
		}
		
		List<Team_Management__c> tmObject = [SELECT Id, User__c FROM Team_Management__c WHERE Id IN: tmID];
		System.assertEquals(10, tmObject.size());
	}
	
	public static testMethod void TestInsertCheckTeamManagementUserDuplicateRecord_DuplicateInBulk_Negative()
	{
		setupDataForPopulateUser();
		List<Team_Management__c> tmListInsert = new List<Team_Management__c>();
		System.assertEquals(10, testUsers.size());
		
		
		for(Integer i = 0; i<SIZE ;++i)
		{
			Team_Management__c tmNew = new Team_Management__c();
			if(i == 1)
			{
				tmNew.User__c = testUsers[1].Id;
			}
			else if (i == 2)
			{
				tmNew.User__c = testUsers[1].Id;
			}
			else
			{
				tmNew.User__c = testUsers[i].Id;
			}
			tmNew.Approval_Manager__c = theApprovalManager.Id;
			tmNew.Manager__c = theManager.Id;
			tmNew.Assistant_Manager__c = theAssistantManager.Id;
			tmNew.Lead_Supervisor__c = theLeadSupervisor.Id;
			tmListInsert.add(tmNew);
		}
		System.runAs(theManager)
		{
			try
			{
				Test.startTest();
					insert tmListInsert;
				Test.stopTest();
			}
			catch (Exception ex)
			{
				Boolean expectedExceptionThrown = ex.getMessage().contains('Another new Team Management record has the same user.');
				System.AssertEquals(expectedExceptionThrown, true);
			}
		}
	}
	
	public static testMethod void TestInsertCheckTeamManagementUserDuplicateRecord_DuplicateInSystemBulk_Negative()
	{
		setupDataForPopulateUser();
		List<Team_Management__c> tmListInsert = new List<Team_Management__c>();
		System.assertEquals(10, testUsers.size());
		
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    	System.runAs ( thisUser ) 
    	{
			Team_Management__c tmNew1 = new Team_Management__c();
			tmNew1.User__c = testUsers[1].Id;
			tmNew1.Approval_Manager__c = theApprovalManager.Id;
			tmNew1.Manager__c = theManager.Id;
			tmNew1.Assistant_Manager__c = theAssistantManager.Id;
			tmNew1.Lead_Supervisor__c = theLeadSupervisor.Id;
			tmNew1.CreatedDate = System.today().addDays(-1);
			insert tmNew1;
    	}
    	
		for(Integer i = 0; i<SIZE ;++i)
		{
			Team_Management__c tmNew = new Team_Management__c();
			tmNew.User__c = testUsers[i].Id;
			tmNew.Approval_Manager__c = theApprovalManager.Id;
			tmNew.Manager__c = theManager.Id;
			tmNew.Assistant_Manager__c = theAssistantManager.Id;
			tmNew.Lead_Supervisor__c = theLeadSupervisor.Id;
			tmListInsert.add(tmNew);
		}
		System.runAs(theManager)
		{
			try
			{
				Test.startTest();
					insert tmListInsert;
				Test.stopTest();
			}
			catch (Exception ex)
			{
				Boolean expectedExceptionThrown = ex.getMessage().contains('already has a Team Management Record. Please update that record.');
				System.AssertEquals(expectedExceptionThrown, true);
			}
		}
	}
	
	public static testMethod void checkTeamManagementUserDuplicateRecord_Update_Positive()
	{
		setupDataForPopulateUser();
		List<Team_Management__c> tmListInsert = new List<Team_Management__c>();
		System.assertEquals(10, testUsers.size());
		
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    	System.runAs ( thisUser ) 
    	{
			for(Integer i = 0; i<SIZE ;++i)
			{
				Team_Management__c tmNew = new Team_Management__c();
				tmNew.User__c = testUsers[i].Id;
				tmNew.Approval_Manager__c = theApprovalManager.Id;
				tmNew.Manager__c = theManager.Id;
				tmNew.Assistant_Manager__c = theAssistantManager.Id;
				tmNew.Lead_Supervisor__c = theLeadSupervisor.Id;
				tmListInsert.add(tmNew);
			}
			insert tmListInsert;
    	}
    	List<Team_Management__c> tmOldList = [SELECT Id, User__c, User__r.Name, Approval_Manager__c, Manager__c, Assistant_Manager__c, Lead_Supervisor__c FROM Team_Management__c WHERE Id IN: tmListInsert];
    	System.assertEquals(10, tmOldList.size());
    	
    	//Create Manager
		User testManager = new User(FirstName='Test', LastName='Sangsom_Manager', UserName='test_sangsom_manager@test.test', Email='test_sangsom_manager@test.com', Alias='tester81',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='test81',
                ProfileId = TestUtils.salesMgrProfileId, UserRoleId = managerRoleId(SALE_MANAGER_ROLE_NAME), TimeZoneSidKey='America/New_York',isActive = true );
                
        System.runAs(TestUtils.ADMIN_USER)
		{
			insert testManager;
		}       
    	List<Team_Management__c> tmUpdateList = new List<Team_Management__c>();
		for(Team_Management__c tmUpdate : tmOldList)
		{
			if(tmUpdate.User__r.Name == 'Sangsom1')
			{
				tmUpdate.Approval_Manager__c = testManager.Id;
				tmUpdate.Manager__c = testManager.Id;
				tmUpdateList.add(tmUpdate);
			}
		}
		System.runAs(theManager)
		{
			Test.startTest();
				update tmUpdateList;
			Test.stopTest();
		}
		List<Team_Management__c> tmOldUpdateList = [SELECT Id, User__c, User__r.Name, Approval_Manager__c, Manager__c, Assistant_Manager__c, Lead_Supervisor__c FROM Team_Management__c WHERE Id IN: tmUpdateList];
        for(Team_Management__c tm : tmOldUpdateList)
		{
			System.assertEquals(testManager.Id, tm.Approval_Manager__c);
			System.assertEquals(testManager.Id, tm.Manager__c);
		}
	}
	
	public static testMethod void checkTeamManagementUserDuplicateRecord_UpdateSingleRecord_Positive()
	{
		setupDataForPopulateUser();
		
		List<User> tUserList = new List<User>();
		User testUser = TestUtils.createUser('Hong', TestUtils.salesAgentProfileId , false);
			testUser.CommunityNickname = 'Hong';//needs to be unique
	    	testUser.Alias = 'Hong';
	    	tUserList.add(testUser);
	    	
	    	//Create Manager
		User testManager = new User(FirstName='Test', LastName='Sangsom_Manager', UserName='test_sangsom_manager@test.test', Email='test_sangsom_manager@test.com', Alias='tester81',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='test81',
                ProfileId = TestUtils.salesMgrProfileId, UserRoleId = managerRoleId(SALE_MANAGER_ROLE_NAME), TimeZoneSidKey='America/New_York',isActive = true );
		tUserList.add(testManager);
		System.runAs(TestUtils.ADMIN_USER)
		{
			insert tUserList;
		}
		
		Team_Management__c tmNew = new Team_Management__c();
		tmNew.User__c = testUser.Id;
		tmNew.Approval_Manager__c = theApprovalManager.Id;
		tmNew.Manager__c = theManager.Id;
		tmNew.Assistant_Manager__c = theAssistantManager.Id;
		tmNew.Lead_Supervisor__c = theLeadSupervisor.Id;
		
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( testManager ) 
    	{
			insert tmNew;
    	}
        
    	List<Team_Management__c> tmUpdateList = new List<Team_Management__c>();
    	List<Team_Management__c> tmOldList = [SELECT Id, User__c, User__r.Name, Approval_Manager__c, Manager__c, Assistant_Manager__c, Lead_Supervisor__c FROM Team_Management__c WHERE Id =: tmNew.Id];
        for(Team_Management__c tm : tmOldList)
        {
            tm.Approval_Manager__c = testManager.Id;
    		tm.Manager__c = testManager.Id;
            tmUpdateList.add(tm);
        }

    	System.runAs(testManager)
		{
			Test.startTest();
				update tmUpdateList;
			Test.stopTest();
		}
		
		List<Team_Management__c> tmOldUpdateList = [SELECT Id, User__c, User__r.Name, Approval_Manager__c, Manager__c, Assistant_Manager__c, Lead_Supervisor__c FROM Team_Management__c WHERE Id =: tmUpdateList[0].Id];
        for(Team_Management__c tm : tmOldUpdateList)
		{
			System.assertEquals(testManager.Id, tm.Approval_Manager__c);
			System.assertEquals(testManager.Id, tm.Manager__c);
		}
	}
	
	public static testMethod void checkTeamManagementUserDuplicateRecord_UpdateSingleRecord_Negative()
	{
		setupDataForPopulateUser();
		
		List<User> tUserList = new List<User>();
		User testUser1 = TestUtils.createUser('Hong', TestUtils.salesAgentProfileId , false);
			testUser1.CommunityNickname = 'Hong';//needs to be unique
	    	testUser1.Alias = 'Hong';
	    	tUserList.add(testUser1);
	    	
	    User testUser2 = TestUtils.createUser('Thong', TestUtils.salesAgentProfileId , false);
			testUser2.CommunityNickname = 'Thong';//needs to be unique
	    	testUser2.Alias = 'Thong';
	    	tUserList.add(testUser2);
	    	
	    	//Create Manager
		User testManager = new User(FirstName='Test', LastName='Sangsom_Manager', UserName='test_sangsom_manager@test.test', Email='test_sangsom_manager@test.com', Alias='tester81',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='test81',
                ProfileId = TestUtils.salesMgrProfileId, UserRoleId = managerRoleId(SALE_MANAGER_ROLE_NAME), TimeZoneSidKey='America/New_York',isActive = true );
		tUserList.add(testManager);
		System.runAs(TestUtils.ADMIN_USER)
		{
			insert tUserList;
		}
		
		List<Team_Management__c> tmList = new List<Team_Management__c>();
		Team_Management__c tmNew1 = new Team_Management__c();
		tmNew1.User__c = testUser1.Id;
		tmNew1.Approval_Manager__c = theApprovalManager.Id;
		tmNew1.Manager__c = theManager.Id;
		tmNew1.Assistant_Manager__c = theAssistantManager.Id;
		tmNew1.Lead_Supervisor__c = theLeadSupervisor.Id;
		tmList.add(tmNew1);
		
		Team_Management__c tmNew2 = new Team_Management__c();
		tmNew2.User__c = testUser2.Id;
		tmNew2.Approval_Manager__c = theApprovalManager.Id;
		tmNew2.Manager__c = theManager.Id;
		tmNew2.Assistant_Manager__c = theAssistantManager.Id;
		tmNew2.Lead_Supervisor__c = theLeadSupervisor.Id;
		tmList.add(tmNew2);
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( testManager ) 
    	{
			insert tmList;
    	}
    	
        List<Team_Management__c> tmUpdateList = new List<Team_Management__c>();
    	List<Team_Management__c> tmOldList = [SELECT Id, User__c, User__r.Name, Approval_Manager__c, Manager__c, Assistant_Manager__c, Lead_Supervisor__c FROM Team_Management__c WHERE Id =: tmNew2.Id];
		
        for(Team_Management__c tm : tmOldList)
        {
            tm.Approval_Manager__c = null;
            tm.Manager__c = null;
            tm.Assistant_Manager__c = null;
            tm.Lead_Supervisor__c = null;
            tmUpdateList.add(tm);
        }
    	
    	System.runAs(testManager)
		{
			Test.startTest();
				update tmUpdateList;
			Test.stopTest();
		}
		
		User oldUserUpdate = [SELECT Id, Name, User.ManagerId, User.Assistant_Manager_Text__c, User.Lead_Supervisor_Text__c, User.Manager_Text__c FROM User WHERE Id =: tmUpdateList[0].User__c];
		System.assertEquals(null, oldUserUpdate.ManagerId);
		System.assertEquals(null, oldUserUpdate.Assistant_Manager_Text__c);
		System.assertEquals(null, oldUserUpdate.Lead_Supervisor_Text__c);
		System.assertEquals(null, oldUserUpdate.Manager_Text__c);
	}
	
	public static testMethod void checkTeamManagementUserDuplicateRecord_UpdateSingleRecord_DupInSystem_Negative()
	{
		setupDataForPopulateUser();
		
		List<User> tUserList = new List<User>();
		User testUser1 = TestUtils.createUser('Hong', TestUtils.salesAgentProfileId , false);
			testUser1.CommunityNickname = 'Hong';//needs to be unique
	    	testUser1.Alias = 'Hong';
	    	tUserList.add(testUser1);
	    	
	    User testUser2 = TestUtils.createUser('Thong', TestUtils.salesAgentProfileId , false);
			testUser2.CommunityNickname = 'Thong';//needs to be unique
	    	testUser2.Alias = 'Thong';
	    	tUserList.add(testUser2);
	    	
	    	//Create Manager
		User testManager = new User(FirstName='Test', LastName='Sangsom_Manager', UserName='test_sangsom_manager@test.test', Email='test_sangsom_manager@test.com', Alias='tester81',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='test81',
                ProfileId = TestUtils.salesMgrProfileId, UserRoleId = managerRoleId(SALE_MANAGER_ROLE_NAME), TimeZoneSidKey='America/New_York',isActive = true );
		tUserList.add(testManager);
		System.runAs(TestUtils.ADMIN_USER)
		{
			insert tUserList;
		}
		
		List<Team_Management__c> tmList = new List<Team_Management__c>();
		Team_Management__c tmNew1 = new Team_Management__c();
		tmNew1.User__c = testUser1.Id;
		tmNew1.Approval_Manager__c = theApprovalManager.Id;
		tmNew1.Manager__c = theManager.Id;
		tmNew1.Assistant_Manager__c = theAssistantManager.Id;
		tmNew1.Lead_Supervisor__c = theLeadSupervisor.Id;
		tmList.add(tmNew1);
		
		Team_Management__c tmNew2 = new Team_Management__c();
		tmNew2.User__c = testUser2.Id;
		tmNew2.Approval_Manager__c = theApprovalManager.Id;
		tmNew2.Manager__c = theManager.Id;
		tmNew2.Assistant_Manager__c = theAssistantManager.Id;
		tmNew2.Lead_Supervisor__c = theLeadSupervisor.Id;
		tmList.add(tmNew2);
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( testManager ) 
    	{
			insert tmList;
    	}
    	
        List<Team_Management__c> tmUpdateList = new List<Team_Management__c>();
    	List<Team_Management__c> tmOldList = [SELECT Id, User__c, User__r.Name, Approval_Manager__c, Manager__c, Assistant_Manager__c, Lead_Supervisor__c FROM Team_Management__c WHERE Id =: tmNew2.Id];
        for(Team_Management__c tm : tmOldList)
        {
            tm.User__c = testUser1.Id;
            tm.Approval_Manager__c = testManager.Id;
            tm.Manager__c = testManager.Id;
            tmUpdateList.add(tm);
        }

    	System.runAs(testManager)
		{
			try
			{
				Test.startTest();
					update tmUpdateList;
				Test.stopTest();
			}
			catch(System.DmlException dmlEX)
			{
				Boolean expectedExceptionThrown = dmlEX.getMessage().contains('already has a Team Management Record. Please update that record.');
				System.AssertEquals(expectedExceptionThrown, true);
			}
		}
	}
	
	public static testMethod void checkTeamManagementUserDuplicateRecord_UpdateSingleRecord_ComplianceReview_Positive()
	{
		setupDataForPopulateUser();
		
		List<User> tUserList = new List<User>();
		User testUser1 = TestUtils.createUser('Hong', TestUtils.salesAgentProfileId , false);
		testUser1.CommunityNickname = 'Hong';//needs to be unique
    	testUser1.Alias = 'Hong';
    	tUserList.add(testUser1);
	    	
	    //Create Manager
		User testManager = new User(FirstName='Test', LastName='Sangsom_Manager', UserName='test_sangsom_manager@test.test', Email='test_sangsom_manager@test.com', Alias='tester81',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='test81',
                ProfileId = TestUtils.salesMgrProfileId, UserRoleId = managerRoleId(SALE_MANAGER_ROLE_NAME), TimeZoneSidKey='America/New_York',isActive = true );
		tUserList.add(testManager);
		System.runAs(TestUtils.ADMIN_USER)
		{
			insert tUserList;
		}
		
		Team_Management__c tmNew1 = new Team_Management__c();
		tmNew1.User__c = testUser1.Id;
		tmNew1.Approval_Manager__c = theApprovalManager.Id;
		tmNew1.Manager__c = theManager.Id;
		tmNew1.Assistant_Manager__c = theAssistantManager.Id;
		tmNew1.Lead_Supervisor__c = theLeadSupervisor.Id;
		
		System.runAs ( testManager ) 
    	{
			insert tmNew1;
    	}
    	
        List<Team_Management__c> tmUpdateList = new List<Team_Management__c>();
    	List<Team_Management__c> tmOldList = [SELECT Id, User__c, User__r.Name, Approval_Manager__c, Manager__c, Assistant_Manager__c, Lead_Supervisor__c FROM Team_Management__c WHERE Id =: tmNew1.Id];
        for(Team_Management__c tm : tmOldList)
        {
            tm.Manager__c = testManager.Id;
            tmUpdateList.add(tm);
        }

    	System.runAs(testManager)
		{
			try
			{
				Test.startTest();
					update tmUpdateList;
				Test.stopTest();
			}
			catch(System.DmlException dmlEX)
			{
				Boolean expectedExceptionThrown = dmlEX.getMessage().contains('already has a Team Management Record. Please update that record.');
				System.AssertEquals(expectedExceptionThrown, true);
			}
		}
		
		List<User> userList = [SELECT User.Manager_Text__c FROM User WHERE Id =: tmUpdateList[0].User__c];
		String testManagerName = testManager.FirstName+' '+testManager.LastName;
		System.assertEquals(userList[0].Manager_Text__c, testManagerName);
	}
	
	public static testMethod void checkTeamManagementUserDuplicateRecord_UpdateSingleRecord_ComplianceReview_Negative()
	{
		setupDataForPopulateUser();
		
		List<User> tUserList = new List<User>();
		User testUser1 = TestUtils.createUser('Hong', TestUtils.salesAgentProfileId , false);
		testUser1.CommunityNickname = 'Hong';//needs to be unique
    	testUser1.Alias = 'Hong';
    	tUserList.add(testUser1);
	    	
	    //Create Manager
		User testManager = new User(FirstName='Test', LastName='Sangsom_Manager', UserName='test_sangsom_manager@test.test', Email='test_sangsom_manager@test.com', Alias='tester81',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='test81',
                ProfileId = TestUtils.salesMgrProfileId, UserRoleId = managerRoleId(SALE_MANAGER_ROLE_NAME), TimeZoneSidKey='America/New_York',isActive = true );
		tUserList.add(testManager);
		System.runAs(TestUtils.ADMIN_USER)
		{
			insert tUserList;
		}
		
		Team_Management__c tmNew1 = new Team_Management__c();
		tmNew1.User__c = testUser1.Id;
		tmNew1.Approval_Manager__c = theApprovalManager.Id;
		tmNew1.Manager__c = theManager.Id;
		tmNew1.Assistant_Manager__c = theAssistantManager.Id;
		tmNew1.Lead_Supervisor__c = theLeadSupervisor.Id;
		
		System.runAs ( testManager ) 
    	{
			insert tmNew1;
    	}
    	
        List<Team_Management__c> tmUpdateList = new List<Team_Management__c>();
    	List<Team_Management__c> tmOldList = [SELECT Id, User__c, User__r.Name, Approval_Manager__c, Manager__c, Assistant_Manager__c, Lead_Supervisor__c, Compliance_Round_Robin__c, Pulled__c FROM Team_Management__c WHERE Id =: tmNew1.Id];
        for(Team_Management__c tm : tmOldList)
        {
            tm.Compliance_Round_Robin__c = true;
            tmUpdateList.add(tm);
        }

    	System.runAs(testManager)
		{
			try
			{
				Test.startTest();
					update tmUpdateList;
				Test.stopTest();
			}
			catch(System.DmlException dmlEX)
			{
				Boolean expectedExceptionThrown = dmlEX.getMessage().contains('already has a Team Management Record. Please update that record.');
				System.AssertEquals(expectedExceptionThrown, true);
			}
		}
		
		List<User> userList = [SELECT User.Manager_Text__c FROM User WHERE Id =: tmUpdateList[0].User__c];
		String testManagerName = testManager.FirstName+' '+testManager.LastName;
		System.assertNotEquals(userList[0].Manager_Text__c, testManagerName);
	}
	
	public static testMethod void checkTeamManagementUserDuplicateRecord_UpdateSingleRecord_DupInBulk_Negative()
	{
		setupDataForPopulateUser();
		
		List<User> tUserList = new List<User>();
		User testUser1 = TestUtils.createUser('Hong', TestUtils.salesAgentProfileId , false);
			testUser1.CommunityNickname = 'Hong';//needs to be unique
	    	testUser1.Alias = 'Hong';
	    	tUserList.add(testUser1);
	    	
	    User testUser2 = TestUtils.createUser('Thong', TestUtils.salesAgentProfileId , false);
			testUser2.CommunityNickname = 'Thong';//needs to be unique
	    	testUser2.Alias = 'Thong';
	    	tUserList.add(testUser2);
	    	
	    User testUser3 = TestUtils.createUser('Chang', TestUtils.salesAgentProfileId , false);
			testUser3.CommunityNickname = 'Chang';//needs to be unique
	    	testUser3.Alias = 'Chang';
	    	tUserList.add(testUser3);
	    	
	    	//Create Manager
		User testManager = new User(FirstName='Test', LastName='Sangsom_Manager', UserName='test_sangsom_manager@test.test', Email='test_sangsom_manager@test.com', Alias='tester81',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='test81',
                ProfileId = TestUtils.salesMgrProfileId, UserRoleId = managerRoleId(SALE_MANAGER_ROLE_NAME), TimeZoneSidKey='America/New_York',isActive = true );
		tUserList.add(testManager);
		System.runAs(TestUtils.ADMIN_USER)
		{
			insert tUserList;
		}
		
		List<Team_Management__c> tmList = new List<Team_Management__c>();
		Team_Management__c tmNew1 = new Team_Management__c();
		tmNew1.User__c = testUser1.Id;
		tmNew1.Approval_Manager__c = theApprovalManager.Id;
		tmNew1.Manager__c = theManager.Id;
		tmNew1.Assistant_Manager__c = theAssistantManager.Id;
		tmNew1.Lead_Supervisor__c = theLeadSupervisor.Id;
		tmList.add(tmNew1);
		
		Team_Management__c tmNew2 = new Team_Management__c();
		tmNew2.User__c = testUser2.Id;
		tmNew2.Approval_Manager__c = theApprovalManager.Id;
		tmNew2.Manager__c = theManager.Id;
		tmNew2.Assistant_Manager__c = theAssistantManager.Id;
		tmNew2.Lead_Supervisor__c = theLeadSupervisor.Id;
		tmList.add(tmNew2);
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( testManager ) 
    	{
			insert tmList;
    	}
    	
    	List<Team_Management__c> updateTMList = new List<Team_Management__c>();
    	List<Team_Management__c> tmOld = [SELECT Id, User__c, User__r.Name, Approval_Manager__c, Manager__c, Assistant_Manager__c, Lead_Supervisor__c FROM Team_Management__c WHERE Id IN: tmList];
    	for(Team_Management__c tm: tmOld)
    	{
			tm.User__c = testUser3.Id;
    		tm.Approval_Manager__c = testManager.Id;
    		tm.Manager__c = testManager.Id;
    		updateTMList.add(tm);
    	}
    	
    	System.runAs(testManager)
		{
			try
			{
				Test.startTest();
					update updateTMList;
				Test.stopTest();
			}
			catch(System.DmlException dmlEX)
			{
				Boolean expectedExceptionThrown = dmlEX.getMessage().contains('Another new Team Management record has the same user.');
				System.AssertEquals(expectedExceptionThrown, true);
			}
			
		}
	}
	
	public static Id managerProfileId 
	{
		get
		{
			if(managerProfileId == null)
			{
				List<Profile> managerProfile = [SELECT Id FROM Profile WHERE Name = : MANAGER_PROFILE_NAME LIMIT 1];
				if(!managerProfile.isEmpty())
				{
					managerProfileId = managerProfile[0].Id;
				}
			}
			
			return managerProfileId;
		}
	}
	
	public static Id managerRoleId(String managerRoleName) 
	{
		Id roleId;
		if(managerRoleName != null)
		{
			List<UserRole> managerRole = [SELECT Id FROM UserRole WHERE Name = : managerRoleName LIMIT 1];
			if(!managerRole.isEmpty())
			{
				roleId = managerRole[0].Id;
			}
		}
		return roleId;
		
	}
}