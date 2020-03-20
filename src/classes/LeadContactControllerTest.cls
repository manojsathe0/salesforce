@isTest
public class LeadContactControllerTest 
{
    static List<Contact> testContacts;
    static List<Lead> testLeads;
    static List<Campaign> testCampaigns;
    static List<CampaignMember> testCampaignMember;
    static LeadContactController.LeadContactMessage theMessage;
    static final Integer ACCOUNT_RECORD_SIZE = 10;
    static final Integer CAMPAIGN_WITHOUT_SKILLS_RECORD_SIZE = 2;
    static final Integer CAMPAIGN_WITH_SKILLS_RECORD_SIZE = 1;
    static final Integer RECORD_SIZE = 10;
    static final String MAX_ABANDONER_PER_DAY = '20';
    static final String CONTACT_NAME = 'Test Contact';
    static final String LEAD_NAME = 'Test Lead';
    static final string LAST_NAME = 'John';
    static final string CAMPAIGN_NAME = 'Test Campaign';
    static User testUser; 

    static void setupData()
    {
        testLeads = TestUtils.createLeads(RECORD_SIZE , LAST_NAME , false);
        List<Account> testAccounts = TestUtils.createAccounts(ACCOUNT_RECORD_SIZE, LAST_NAME, true);
        testContacts = TestUtils.createContacts(RECORD_SIZE, LAST_NAME, testAccounts[0].Id, false);
        testUser = TestUtils.createUser(LAST_NAME , TestUtils.STANDARD_PROFILE_ID , true);
		TestUtils.createSEADConfig();
        for(Contact theContact : testContacts)
        {
            theContact.Lead_Score_Non_Time_Sensitive__c = 90;
        }
        for(Lead theLead : testLeads)
        {
            theLead.Lead_Score_Non_Time_Sensitive__c = 90;
        }
        System.runAs(testUser) 
        { 
            insert testContacts;
            insert testLeads;
        }
        Max_Abandoner_Per_Day__c maxAbandoners = new Max_Abandoner_Per_Day__c(Name = MAX_ABANDONER_PER_DAY);
        insert maxAbandoners;

        testCampaigns = TestUtils.createCampaigns(CAMPAIGN_WITHOUT_SKILLS_RECORD_SIZE,CAMPAIGN_NAME, null, null, false);
        for(Campaign theCampaign : TestUtils.createCampaigns(CAMPAIGN_WITH_SKILLS_RECORD_SIZE,CAMPAIGN_NAME, null, null, false))
        {
            theCampaign.Need_Skills__c = true;
            testCampaigns.add(theCampaign);
        }insert testCampaigns;
    }

    static testMethod void testGetAllLeadsAndContactsInfo()
    {
        setupData();
        LeadContactController controller = new LeadContactController();
        List<LeadContactInfo> contactsInfo;
        List<LeadContactInfo> leadsInfo;
        System.runAs(testUser)
        {
            Test.startTest();
                contactsInfo = controller.getAllContactsInfo(); 
                leadsInfo = controller.getAllLeadsInfo();   
            Test.stopTest();
        }
        System.assertEquals(RECORD_SIZE , contactsInfo.size() , RECORD_SIZE);
        System.assertEquals(RECORD_SIZE , leadsInfo.size() , RECORD_SIZE);
    }

    static testMethod void testRetrieveFreshLeadsAndContacts()
    {
        setupData();
        LeadContactController controller = new LeadContactController();
        List<LeadContactInfo> leadAndContactssInfo;
        System.runAs(testUser)
        {
            Test.startTest();
                 controller.retrieveFreshLeadsAndContacts();    
            Test.stopTest();
        }
        System.assertEquals(RECORD_SIZE*2 , controller.leadAndContacts.size());
    }

    static testMethod void testUpdateOwner()
    {
        setupData();
        LeadContactController controller = new LeadContactController();     
        User newOwner = TestUtils.createUser('Gray' , TestUtils.STANDARD_PROFILE_ID , true);
        controller.dummyContact.OwnerId = newOwner.Id;
        controller.selectedRecordIds = testContacts[0].Id + ','+testLeads[0].Id;
        
        System.runAs(testUser)
        {
            Test.startTest();
                 controller.updateOwner();  
            Test.stopTest();
        }
        List<Contact> updatedContacts = [SELECT Id , OwnerId FROM Contact WHERE Id = :testContacts[0].Id];
        List<Lead> updatedLeads = [SELECT Id , OwnerId FROM Lead WHERE Id = :testLeads[0].Id];
        
        System.assertEquals(newOwner.Id , updatedContacts[0].OwnerId);
        System.assertEquals(newOwner.Id , updatedLeads[0].OwnerId);
    }

    static testMethod void testFieldsForSorting()
    {
        LeadContactController controller = new LeadContactController();
        
        Test.startTest();
            Map<Integer,LeadContactController.FieldWrapper> sortingFields = controller.fieldsForSorting;
        Test.stopTest();
        
        System.assertEquals(3 , sortingFields.size());
    }

    static testMethod void testLeadStatusOptions()
    {
        
        LeadContactController controller = new LeadContactController();
        
        Test.startTest();
            List<SelectOption> leadStatusOptions = controller.LeadStatusOptions;
        Test.stopTest();
        
        System.assertNotEquals(null , leadStatusOptions );      
    }

    static testMethod void testChangeOwnerAndStatus()
    {
        LeadContactController controller = new LeadContactController();
        
        Test.startTest();
             controller.changeOwner();
             controller.changeStatus();
        Test.stopTest();
    }

    static testMethod void testUpdateStatus()
    {
        setupData();
        LeadContactController controller = new LeadContactController();
        controller.selectedRecordIds = testLeads[0].Id;
        controller.selectedLeadStatusOption = 'Qualified';
        System.runAs(testUser)
        {
            Test.startTest();
                 controller.updateStatus(); 
            Test.stopTest();
        }
        List<Lead> updatedLeads = [SELECT Id , Status FROM Lead WHERE Id = :testLeads[0].Id];
        System.assertEquals('Qualified' , updatedLeads[0].Status , 'Status should have been uupdated');
    }

    /*static testMethod void testAssignNewAbandoners_QuotaExceeded()
    {
        setupData();
        testCampaignMember = new List<CampaignMember>();
        List<Account> testAccounts = TestUtils.createAccounts(ACCOUNT_RECORD_SIZE, 'Test Account', true);
        List<Contact> moreContacts = TestUtils.createContacts(Integer.valueOf(MAX_ABANDONER_PER_DAY)+1, 'Test Contact', testAccounts[0].Id, false);
        User stdUser = TestUtils.createUser( 'Cartman' , TestUtils.STANDARD_PROFILE_ID , true);
        
        Team_Management__c theUser = new Team_Management__c();
        theUser.User__c = stdUser.Id;
        theUser.Skills__c = testCampaigns[0].Name;
        
        System.runAs(stdUser)
        {
            insert moreContacts;
        }

        for(Contact theContact : moreContacts)
        {
            CampaignMember theCampaignMember = new CampaignMember();
            theCampaignMember.ContactId = theContact.Id;
            theCampaignMember.CampaignId = testCampaigns[math.MOD(moreContacts.size(), testCampaigns.size())].Id;
            testCampaignMember.add(theCampaignMember);
        }
        insert testCampaignMember;
        System.runAs(stdUser)
        {
            insert theUser;
            Test.startTest();
                theMessage = LeadContactController.assignNewAbandoners();
            Test.stopTest();
        }
        System.assertEquals(1 , theMessage.statusId);
    }*/

    static testMethod void testAssignNewAbandoners_NoAbandonersInTheSystem()
    {
        setupData();
        User stdUser = TestUtils.createUser( 'Cartman' , TestUtils.STANDARD_PROFILE_ID , true);
        Team_Management__c theUser = new Team_Management__c();
        theUser.User__c = stdUser.Id;
        theUser.Skills__c = testCampaigns[0].Name;
        System.runAs(stdUser)
        {
            insert theUser;
            Test.startTest();
                theMessage = LeadContactController.assignNewAbandoners();
            Test.stopTest();
        }
        System.assertEquals(2 , theMessage.statusId);
    }

    static testMethod void testAssignNewAbandoners_SuccessContact()
    {
        setupData();
        testCampaignMember = new List<CampaignMember>();
        List<Account> testAccounts = TestUtils.createAccounts(ACCOUNT_RECORD_SIZE, 'Test Account', true);
        List<Contact> moreContacts = TestUtils.createContacts(RECORD_SIZE, 'Test Contact', testAccounts[0].Id, false);
        System.runAs(GetNextAbandonerLeadContact.integrationUser)
        {
            insert moreContacts;
        }
        for(Integer i = 0; i < moreContacts.size()/2; i++)
        {
            moreContacts[i].Lead_Score_Non_Time_Sensitive__c = 80;
            CampaignMember theCampaignMember = new CampaignMember();
            theCampaignMember.ContactId = moreContacts[i].Id;
            theCampaignMember.CampaignId = testCampaigns[0].Id;
            testCampaignMember.add(theCampaignMember);
        }
        for(Integer i = moreContacts.size()/2; i < moreContacts.size(); i++)
        {
            moreContacts[i].Lead_Score_Non_Time_Sensitive__c = 90;
            CampaignMember theCampaignMember = new CampaignMember();
            theCampaignMember.ContactId = moreContacts[i].Id;
            theCampaignMember.CampaignId = testCampaigns[testCampaigns.size() - 1].Id;
            testCampaignMember.add(theCampaignMember);
        }
        update moreContacts;
        insert testCampaignMember;

        User stdUser = TestUtils.createUser( 'Cartman' , TestUtils.STANDARD_PROFILE_ID , true);
        Team_Management__c theUser = new Team_Management__c();
        theUser.User__c = stdUser.Id;
        theUser.Skills__c = testCampaigns[0].Name;
        System.runAs(stdUser)
        {
            insert theUser;
            Test.startTest();
                theMessage = LeadContactController.assignNewAbandoners();
            Test.stopTest();
        }
		GetNextAbandonerLeadContact temp = new GetNextAbandonerLeadContact();
		Integer i = temp.maxAllowedAbandonersPerDay;
        //System.assertEquals(0, theMessage.statusId);
        List<Contact> testInsertedContacts = [Select ID,Name, OwnerId From Contact Where OwnerId =: stdUser.ID];
        //System.assertEquals(1,testInsertedContacts.size());
        //System.assertEquals(stdUser.Id, testInsertedContacts[0].OwnerId);
    }

    static testMethod void testAssignNewAbandoners_SuccessLeads()
    {
        setupData();
        testCampaignMember = new List<CampaignMember>();
        List<Lead> moreLeads = TestUtils.createLeads(RECORD_SIZE, 'Test Lead', false);
        System.runAs(GetNextAbandonerLeadContact.integrationUser)
        {
            insert moreLeads;
        }
        for(Integer i = 0; i < moreLeads.size()/2; i++)
        {
            moreLeads[i].Lead_Score_Non_Time_Sensitive__c = 80;
            CampaignMember theCampaignMember = new CampaignMember();
            theCampaignMember.LeadId = moreLeads[i].Id;
            theCampaignMember.CampaignId = testCampaigns[0].Id;
            testCampaignMember.add(theCampaignMember);
        }
        for(Integer i = moreLeads.size()/2; i < moreLeads.size(); i++)
        {
            moreLeads[i].Lead_Score_Non_Time_Sensitive__c = 90;
            CampaignMember theCampaignMember = new CampaignMember();
            theCampaignMember.LeadId = moreLeads[i].Id;
            theCampaignMember.CampaignId = testCampaigns[testCampaigns.size() - 1].Id;
            testCampaignMember.add(theCampaignMember);
        }update moreLeads;
         insert testCampaignMember;

        User stdUser = TestUtils.createUser( 'Cartman' , TestUtils.STANDARD_PROFILE_ID , true);
        Team_Management__c theUser = new Team_Management__c();
        theUser.User__c = stdUser.Id;
        theUser.Skills__c = testCampaigns[0].Name;
        System.runAs(stdUser)
        {
            insert theUser;
            Test.startTest();
                theMessage = LeadContactController.assignNewAbandoners();
            Test.stopTest();
        }
        System.assertEquals(0, theMessage.statusId);
        List<Lead> testInsertedLeads = [Select ID,Name, OwnerId From Lead Where OwnerId =: stdUser.ID];
        System.assertEquals(1,testInsertedLeads.size());
        System.assertEquals(stdUser.Id, testInsertedLeads[0].OwnerId);
    }

    static testMethod void testAssignNewAbandoners_SuccessLeads_NotInTeamManagment()
    {
        setupData();
        testCampaignMember = new List<CampaignMember>();
        List<Lead> moreLeads = TestUtils.createLeads(RECORD_SIZE, 'Test Lead', false);
        System.runAs(GetNextAbandonerLeadContact.integrationUser)
        {
            insert moreLeads;
        }
        for(Integer i = 0; i < moreLeads.size()/2; i++)
        {
            moreLeads[i].Lead_Score_Non_Time_Sensitive__c = 80;
            CampaignMember theCampaignMember = new CampaignMember();
            theCampaignMember.LeadId = moreLeads[i].Id;
            theCampaignMember.CampaignId = testCampaigns[0].Id;
            testCampaignMember.add(theCampaignMember);
        }
        for(Integer i = moreLeads.size()/2; i < moreLeads.size(); i++)
        {
            moreLeads[i].Lead_Score_Non_Time_Sensitive__c = 90;
            CampaignMember theCampaignMember = new CampaignMember();
            theCampaignMember.LeadId = moreLeads[i].Id;
            theCampaignMember.CampaignId = testCampaigns[testCampaigns.size() - 1].Id;
            testCampaignMember.add(theCampaignMember);
        }update moreLeads;
         insert testCampaignMember;

        User stdUser = TestUtils.createUser( 'Cartman' , TestUtils.STANDARD_PROFILE_ID , true);
        System.runAs(stdUser)
        {
            Test.startTest();
                theMessage = LeadContactController.assignNewAbandoners();
            Test.stopTest();
        }
        System.assertEquals(1, theMessage.statusId);
        List<Lead> testInsertedLeads = [Select ID,Name, OwnerId From Lead Where OwnerId =: stdUser.ID];
        System.assertEquals(0,testInsertedLeads.size());
    }
}