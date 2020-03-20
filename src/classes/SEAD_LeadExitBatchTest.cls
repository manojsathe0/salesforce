/**
 * Created by jboles on 5/16/2017.
 */
 //Testing jenkins deploy B-19591
@isTest
public class SEAD_LeadExitBatchTest
{
    static SalesQA__c salesQAObj1, salesQAObj2, salesQAObj3, salesQAObj4;
    static Team_Management__c teamManage1, teamManage2, teamManage3, teamManage4, teamManage5, teamManage7, teamManage8, teamManage9;
    static SalesQARepRoles__c salesQARepRoleObj = new SalesQARepRoles__c();
    static Compliance_Review_Status__c compStatus = new Compliance_Review_Status__c();
    static User userTest, userTest2, userTest3, userTest4, userTest5, userTest6, userTest7;
    static Compliance_Review__c complianceReview = new Compliance_Review__c();
    static ID AdminProfileID = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1][0].id;
    static ID managerProfileID = [SELECT Id FROM Profile WHERE Name = 'Sales Manager' LIMIT 1][0].id;
    static ID userRoleID = [SELECT ID FROM UserRole WHERE Name = 'Sales Specialist'][0].Id;
    static ID userRoleIDLead = [SELECT ID FROM UserRole WHERE Name = 'Sales Lead'][0].Id;
    static ID salesManager;// = [SELECT Id FROM User WHERE UserRole.Name = 'Sales Management'][0].Id;
    static User rep4;// = [SELECT ID, Name FROM User WHERE UserRole.Name = 'Sales Lead'][0];

    static void setupData()
    {
        salesQARepRoleObj.Name = 'Sales Lead';
        insert salesQARepRoleObj;

        Set<String> repRoles = SalesQARepRoles__c.getAll().keySet();

        List<User> addUser = new List<User>();
        userTest = new User(FirstName='Testttt', LastName='SalesRep', UserName='arm54321@legalzoom.test', Email='test91@test.com', Alias='tester91',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='Arm54321@legalzoom',
                ProfileId = TestUtils.salesAgentProfileId, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest);
        userTest2 = new User(FirstName='TestSalesRep', LastName='SalesRep2', UserName='arm54@legalzoom.test', Email='test911@test.com', Alias='tester1',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm54@legalzoom',
                ProfileId = TestUtils.salesAgentProfileId, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest2);
        userTest3 = new User(FirstName='TestSalesRep3', LastName='SalesRep3', UserName='arm13@legalzoom.test', Email='test913@test.com', Alias='tester13',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm13@legalzoom',
                ProfileId = TestUtils.salesAgentProfileId, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest3);
        userTest4 = new User(FirstName='TestSalesRep4', LastName='SalesRep4', UserName='arm12@legalzoom.test', Email='test91@test.com', Alias='tester12',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm12@legalzoom',
                ProfileId = TestUtils.salesAgentProfileId, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest4);

        userTest5 = new User(FirstName='TestSalesRep5', LastName='SalesRep5', UserName='arm1255@legalzoom.test', Email='test9155@test.com', Alias='tester12',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm1255@legalzoom',
                ProfileId = AdminProfileID, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager, 
                Manager_Text__c ='TestSalesMang TestSalesMang'); // Padma @B-18481
        addUser.add(userTest5);

        userTest6 = new User(FirstName='TestSalesRep6', LastName='SalesRep6', UserName='arm1266@legalzoom.test', Email='test9166@test.com', Alias='tester66',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm1266@legalzoom',
                ProfileId = AdminProfileID, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);
        addUser.add(userTest6);

        userTest7 = new User(FirstName='TestSalesRep7', LastName='SalesRep7', UserName='arm1277@legalzoom.test', Email='test9177@test.com', Alias='tester77',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm1277@legalzoom',
                ProfileId = AdminProfileID, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = false, ManagerId = salesManager);
        addUser.add(userTest7);

        User salesMan= new User(FirstName='TestSalesMang', LastName='TestSalesMang', UserName='TestSalesMang@legalzoom.test', Email='TestSalesMang@test.com', Alias='sales77',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='TestSalesMang@legalzoom',
                ProfileId = managerProfileID, Division = 'Sales', UserRoleId = userRoleID, TimeZoneSidKey='America/New_York',isActive = true);


        rep4 = new User(FirstName='TestSalesRep8', LastName='SalesRep8', UserName='arm1233377@legalzoom.test', Email='test9177@test.com', Alias='tester78',
                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='arm1288@legalzoom',
                ProfileId = TestUtils.STANDARD_PROFILE_ID, Division = 'Sales', UserRoleId = userRoleIDLead, TimeZoneSidKey='America/New_York',isActive = true, ManagerId = salesManager);

        Lead incomingLead = new Lead();
        incomingLead.FKUser__c = '0';
        incomingLead.Tealium_Id__c = '123456789012345';
        incomingLead.Email = 'TestEmail@TestEmail.Test0';
        incomingLead.Phone = '4444444444';
        incomingLead.company = 'test';
        incomingLead.lastname = 'test';
        incomingLead.firstname = 'test2';
        incomingLead.Ownership_Date__c = datetime.now();
        
        // Padma @B-18481
        Lead incomingLead2 = new Lead();
     	incomingLead2.FKUser__c = '0';
        incomingLead2.Tealium_Id__c = '111112222233333';
        incomingLead2.Email = 'TestEmail@TestEmail.com';
        incomingLead2.Phone = '4444444444';
        incomingLead2.company = 'test';
        incomingLead2.lastname = 'test';
        incomingLead2.firstname = 'test2';
        incomingLead2.Ownership_Date__c = datetime.now();


        System.runAs(TestUtils.ADMIN_USER)
        {
            Id SalesTeamManagemntId = [SELECT Id FROM RecordType WHERE developername = 'Sales_Team_Management' AND SobjectType = 'Team_Management__c' LIMIT 1][0].Id;



            SEAD_Configuration__c config = new SEAD_Configuration__c();
            config.Name = 'Default';
            config.Lead_Days_from_Ownership__c = 0;

            insert config;

            insert addUser;
            insert salesMan;
            salesManager = salesMan.Id;

            List<Team_Management__c> addSaleRep = new List<Team_Management__c>();
            teamManage1 = new Team_Management__c();
            teamManage1.User__c = userTest.Id;
            teamManage1.Approval_Manager__c = salesManager;
            teamManage1.Manager__c = salesManager;
            teamManage1.Compliance_Status__c = 'Live';
            teamManage1.Compliance_RR__c = true;
            teamManage1.Pulled__c = false;
            addSaleRep.add(teamManage1);

            teamManage2 = new Team_Management__c();
            teamManage2.User__c = userTest2.Id;
            teamManage2.Approval_Manager__c = salesManager;
            teamManage2.Manager__c = salesManager;
            teamManage2.Compliance_Status__c = 'Live';
            teamManage2.Compliance_RR__c = true;
            teamManage2.Pulled__c = false;
            addSaleRep.add(teamManage2);

            teamManage3 = new Team_Management__c();
            teamManage3.User__c = userTest3.Id;
            teamManage3.Approval_Manager__c = salesManager;
            teamManage3.Manager__c = salesManager;
            teamManage3.Compliance_Status__c = 'Training';
            teamManage3.Compliance_RR__c = true;
            teamManage3.Pulled__c = false;
            teamManage3.RecordTypeId = SalesTeamManagemntId;

            addSaleRep.add(teamManage3);


            teamManage4 = new Team_Management__c();
            teamManage4.User__c = userTest6.Id;
            teamManage4.Approval_Manager__c = salesManager;
            teamManage4.Manager__c = salesManager;
            teamManage4.Compliance_Status__c = 'Live';
            teamManage4.Compliance_Round_Robin__c = true;
            teamManage4.Compliance_RR__c = true;
            teamManage4.Pulled__c = false;
            teamManage4.RecordTypeId =SalesTeamManagemntId;

            addSaleRep.add(teamManage4);

            teamManage5 = new Team_Management__c();
            teamManage5.User__c = userTest7.Id;
            teamManage5.Approval_Manager__c = salesManager;
            teamManage5.Manager__c = salesManager;
            teamManage5.Compliance_Status__c = 'Training';
            teamManage5.Compliance_RR__c = true;
            teamManage5.Pulled__c = false;
            teamManage5.RecordTypeId  =SalesTeamManagemntId;
            addSaleRep.add(teamManage5);


            insert addSaleRep;


            incomingLead.ownerid = userTest6.id;
            insert incomingLead;
            incomingLead.ownerid = userTest7.id;
            update incomingLead;
            //Padma @B-18481
            incomingLead2.ownerid=userTest5.id;
			insert incomingLead2;
        }

    }
    static testMethod void testLeadExitBatch()
    {

        setupData();

        Test.startTest();
        SEAD_LeadExitBatchSchedule myClass = new SEAD_LeadExitBatchSchedule ();
        String chron = '0 0 23 * * ?';
        system.schedule('Test Sched', chron, myClass);
        Test.stopTest();
        
        
        
    }
    
    //Padma @B-18481
    //this method is created to cover the code from the else statement of  OwnerId list comparision in the batch job
    static testMethod void testLeadExitBatch2()
    {
		
        setupData();
		Lead ld = [SELECT Id FROM Lead Where Tealium_Id__c = '111112222233333' LIMIT 1][0];
        delete ld;
        
        Test.startTest();
        SEAD_LeadExitBatchSchedule myClass = new SEAD_LeadExitBatchSchedule ();
        String chron = '0 0 23 * * ?';
        system.schedule('Test Sched', chron, myClass);
        Test.stopTest();
        
        
        
    }


}