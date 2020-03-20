@isTest
public with sharing class CampaignMemberServiceTest {


    static List<CampaignMember> testCampaignMembers;
    static List<Contact> testContacts;
    static List<Lead> testLeads;
    final static Integer SIZE = 50;
    final static String REMOVED = 'Removed';

    static void setupData()
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

        testContacts = TestUtils.createContacts(SIZE , 'Test LastName' , null ,false);
        for(Integer i = 0 ; i< SIZE ; ++i)
        {
            testContacts[i].FkUser__c = i+'';
        }
        insert testContacts;

        testLeads = TestUtils.createLeads(SIZE , 'LeadName' , true);
        CampaignRulesSetup.setupCampaignWithRules();


    }

    static testMethod void testUnAssignLeadAndContacts_Contact_NoOwnerChange()
    {
        setupData();

        List<CampaignMember> firstCampaignMembers = new List<CampaignMember>();
        List<CampaignMember> secondCampaignMembers = new List<CampaignMember>();

        for(Contact theContact : testContacts)
        {
            CampaignMember firstCampaignMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.raOutboundCampaign.Id , theContact.Id , null , false)[0];
            CampaignMember secondCampaignMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.businessLicenseOutboundCampaign.Id , theContact.Id , null , false)[0];

            firstCampaignMembers.add(firstCampaignMember);
            secondCampaignMembers.add(secondCampaignMember);
        }
        insert firstCampaignMembers;
        insert secondCampaignMembers;

        User contactOwner = TestUtils.createUser('TestUser', TestUtils.STANDARD_PROFILE_ID , true);
        for(Contact theContact : testContacts)
        {
            theContact.OwnerId = contactOwner.Id;
        }
        update testContacts;

        for(CampaignMember theMember : secondCampaignMembers)
        {
            theMember.Status = REMOVED;
        }
        
        //User theUser = Campaignmemberservice.integrationUser;  //commented in accordance B-37996

        Test.startTest();
        update secondCampaignMembers;
        Test.stopTest();

        List<Contact> contacts = [SELECT Id , OwnerId FROM Contact WHERE Id IN :testContacts];
        System.assertEquals(SIZE , contacts.size() , '50 Contacts should have been returned');
        for(Contact theContact : contacts)
        {
            System.assertEquals(contactOwner.Id , theContact.OwnerId , 'Right owner Id should have been populated');
        }
    }

    static testMethod void testUnAssignLeadAndContacts_Contact_SetLastCampaign()
    {
        setupData();

        List<CampaignMember> firstCampaignMembers = new List<CampaignMember>();
        List<CampaignMember> secondCampaignMembers = new List<CampaignMember>();

        for(Contact theContact : testContacts)
        {
            CampaignMember firstCampaignMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.raOutboundCampaign.Id , theContact.Id , null , false)[0];
            firstCampaignMembers.add(firstCampaignMember);
            CampaignMember secondCampaignMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.businessLicenseOutboundCampaign.Id , theContact.Id , null , false)[0];
            secondCampaignMembers.add(secondCampaignMember);

        }
        insert secondCampaignMembers;

        insert firstCampaignMembers;

        for(CampaignMember theMember : secondCampaignMembers)
        {
            theMember.Status = REMOVED;
        }
        update secondCampaignMembers;

        for(CampaignMember theMember : firstCampaignMembers)
        {
            theMember.Status = REMOVED;
        }

        Test.startTest();
        update firstCampaignMembers;
        Test.stopTest();

        List<Contact> contacts = [SELECT Id , OwnerId , Sales_opportunity_latest_campaign__c FROM Contact WHERE Id IN :testContacts];
        System.assertEquals(SIZE , contacts.size() , '50 Contacts should have been returned');
        for(Contact theContact : contacts)
        {

            System.assertEquals(CampaignRulesSetup.raOutboundCampaign.Name, theContact.Sales_opportunity_latest_campaign__c, 'Campaign name should have been updated');

        }

    }

    static testMethod void testUnAssignLeadAndContacts_Lead_NoOwnerChange()
    {
        setupData();

        List<CampaignMember> firstCampaignMembers = new List<CampaignMember>();
        List<CampaignMember> secondCampaignMembers = new List<CampaignMember>();

        for(Lead theLead : testLeads)
        {
            CampaignMember firstCampaignMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.raOutboundCampaign.Id , null , theLead.Id  , false)[0];
            CampaignMember secondCampaignMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.businessLicenseOutboundCampaign.Id , null , theLead.Id , false)[0];
            firstCampaignMembers.add(firstCampaignMember);
            secondCampaignMembers.add(secondCampaignMember);
        }
        insert firstCampaignMembers;
        insert secondCampaignMembers;

        User leadOwner = TestUtils.createUser('TestUser', TestUtils.STANDARD_PROFILE_ID , true);
        for(Lead theLead : testLeads)
        {
            theLead.OwnerId = leadOwner.Id;
        }
        update testLeads;



        for(CampaignMember theMember : secondCampaignMembers)
        {
            theMember.Status = REMOVED;
        }

        Test.startTest();
        update secondCampaignMembers;
        Test.stopTest();

        List<Lead> leads = [SELECT Id , OwnerId FROM Lead WHERE Id IN :testLeads];
        System.assertEquals(SIZE , leads.size() , '50 Leads should have been returned');
        for(Lead theLead : leads)
        {
            System.assertEquals(leadOwner.Id , theLead.OwnerId , 'Right owner Id should have been populated');
        }
    }

    static testMethod void testUnAssignLeadAndContacts_SetLastCampaign()
    {
        setupData();

        List<CampaignMember> firstCampaignMembers = new List<CampaignMember>();
        List<CampaignMember> secondCampaignMembers = new List<CampaignMember>();

        for(Lead theLead : testLeads)
        {
            CampaignMember firstCampaignMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.raOutboundCampaign.Id , null , theLead.Id , false)[0];
            firstCampaignMembers.add(firstCampaignMember);
            CampaignMember secondCampaignMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.businessLicenseOutboundCampaign.Id , null , theLead.Id , false)[0];
            secondCampaignMembers.add(secondCampaignMember);

        }
        insert firstCampaignMembers;
        insert secondCampaignMembers;

        for(CampaignMember theMember : secondCampaignMembers)
        {
            theMember.Status = REMOVED;
        }

        update secondCampaignMembers;

        for(CampaignMember theMember : firstCampaignMembers)
        {
            theMember.Status = REMOVED;
        }

        Test.startTest();
        update firstCampaignMembers;
        Test.stopTest();

        List<Lead> leads = [SELECT Id , OwnerId FROM Lead WHERE Id IN :testLeads];
        System.assertEquals(SIZE , leads.size() , '50 Leads should have been returned');
    }

    static testMethod void testMobileCampaign_Lead_Exit_LeadScore()
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
        CampaignRulesSetup.setupCampaignWithRules();
        List<CampaignMember> mobileCampaignMembers = new List<CampaignMember>();
        testLeads = TestUtils.createLeads(SIZE , 'LeadName' , false);
        for(Lead theLead : testLeads)
            theLead.LeadSource = 'Mobile';

        insert testLeads;
        system.debug(testLeads);

        for(Lead theLead : testLeads)
        {
            CampaignMember mobileCampaignMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.mobileCampaign.Id , null , theLead.Id , false)[0];
            mobileCampaignMembers.add(mobileCampaignMember);
        }
        insert mobileCampaignMembers;

        //testing after adding to mobile campaign
        for(Lead theLead : [SELECT ID , Lead_Score_Mobile_time_since_creation__c , Last_Time_Added_to_Campaign__c , Lead_Score__c FROM Lead WHERE ID In: testLeads])
        {
            System.assertEquals(64 , theLead.Lead_Score_Mobile_time_since_creation__c);
            //system.assertEquals(64 ,theLead.Lead_Score__c,'Mobile score should be 64 as lead was just added to campaigmn');
        }

        for(CampaignMember theCampaignMember : mobileCampaignMembers)
        {
            theCampaignMember.Status = REMOVED;
        }
        update mobileCampaignMembers;

        //testing after removing from mobile campaign
        for(Lead theLead : [SELECT ID , Lead_Score_Mobile_time_since_creation__c , Last_Time_Added_to_Campaign__c , Lead_Score__c FROM Lead WHERE ID In: testLeads])
        {
            //system.assertEquals(0, theLead.Lead_Score__c , 'Mobile score should not count to lead score');
        }

    }

    static testMethod void testMobileCampaign_Contact_Exit_LeadScore()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        List<CampaignMember> mobileCampaignMembers = new List<CampaignMember>();
        testContacts = TestUtils.createContacts(SIZE , 'Test LastName' , null ,false);
        for(Contact theContact : testContacts)
        {
            theContact.LeadSource = 'Mobile';
            theContact.CreatedDate = system.now().addDays(-4);
        }
        insert testContacts;
        system.debug(testContacts);

        for(Contact theContact : testContacts)
        {
            CampaignMember mobileCampaignMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.mobileCampaign.Id , theContact.Id , null  , false)[0];
            mobileCampaignMembers.add(mobileCampaignMember);
        }
        insert mobileCampaignMembers;

        //testing after adding to mobile campaign
        for(Contact theContact : [SELECT ID , Lead_Score_Mobile_time_since_creation__c , Last_Time_Added_to_Campaign__c , Contact_Score__c FROM Contact WHERE ID In: testContacts])
        {
            //system.assertEquals(64,theContact.Contact_Score__c,'Mobile  score should be 64 as Contact was just added to campaign');
        }

        for(CampaignMember theCampaignMember : mobileCampaignMembers)
        {
            theCampaignMember.Status = REMOVED;
        }
        update mobileCampaignMembers;

        //testing after removing from mobile campaign
        for(Contact theContact : [SELECT ID , Lead_Score_Mobile_time_since_creation__c , Last_Time_Added_to_Campaign__c , Contact_Score__c FROM Contact WHERE ID In: testContacts])
        {
            //system.assertEquals(0, theContact.Contact_Score__c , 'Mobile score should not count to Contact score');
        }

    }

    static testMethod void testUpdateTealiumFlag_Contact()
    {

        List<CampaignMember> mobileCampaignMembers = new List<CampaignMember>();
        Contact theContact  = TestUtils.createContacts(1 , 'Test LastName' , null ,false)[0];
        insert theContact;
        User salesUser = TestUtils.createUser('TestSales' , TestUtils.salesAgentProfileId , true);
        theContact.OwnerId = salesUser.Id;
        update theContact;

        List<User> lzPKBUsers = [SELECT id FROM User WHERE Profile.Name = 'LZPKB Profile'];
        User siteUser;
        if(!lzPKBUsers.isEmpty())
            siteUser = lzPKBUsers[0];
        Test.startTest();
        System.runAs(siteUser)
        {
            CampaignRulesSetup.setupCampaignWithRules();
            CampaignMember abandonerCampaignMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.abandonerCampaign.Id , theContact.Id , null  , false)[0];
            insert abandonerCampaignMember;
        }
        Test.stopTest();


        Contact queriedContact = [SELECT ID , Updated_By_Tealium__c FROM Contact WHERE ID =: theContact.Id limit 1];
        System.assertEquals(true , queriedContact.Updated_By_Tealium__c , 'Should have been marked as true');

    }

}