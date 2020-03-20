@isTest
public with sharing class MobileCampaignTest 
{
    static List<Lead> testLeads;
    static Integer SIZE = 200;
    public final static String BUSINESS_SERVICES = 'Business Services';
    static void setupData()
    {
        testLeads = TestUtils.createLeads(SIZE , 'Test Lead', false);
        for(Integer i = 0 ; i<SIZE ; ++i)
        {
            testLeads[i].Company = 'testEmail@test.test'+i;
            testLeads[i].LeadSource = 'Mobile';
            testLeads[i].Lead_Source_Detail__c = BUSINESS_SERVICES;
        }

    }
    
    static testMethod void testMobileCampaignWithLead_NoMatchWithContact_Entry()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        Test.startTest();
             insert testLeads;   
        Test.stopTest();
        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember WHERE LeadId IN :testLeads];
        System.assertEquals(SIZE , campaignMembers.size() , '200 CampaignMembers should have been created');
        
    }
    
    
    static testMethod void testMobileCampaignWithLead_MatchWithContact_Entry()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        List<Contact> testContacts = TestUtils.createContacts(SIZE/2 , 'Test Contact', null , false);
        for(Integer i = 0 ; i<SIZE/2; ++i)
        {
            testContacts[i].FkUser__c = i+'';
            testContacts[i].Email = 'testEmail@test.test'+i;
            testContacts[i].Contact_Type__c = 'Primary Contact'; 
           
        }
        insert testContacts;

        Test.startTest();
             insert testLeads;   
        Test.stopTest();
        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember WHERE ContactId IN :testContacts];
        System.assertEquals(SIZE/2 , campaignMembers.size() , '100 CampaignMembers should have been created');
        
    }
    
    static testMethod void testMobileCampaignWithLead_Exit()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        insert testLeads;

        for(Lead theLead : testLeads)
        {
            theLead.Lead_Call_Status__c = CampaignConstants.VM_FINAL;
        }

        Test.startTest();
            update testLeads;           
        Test.stopTest();
        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember WHERE Status = :CampaignConstants.REMOVED AND LeadId IN :testLeads];
        System.assertEquals(SIZE , campaignMembers.size() , '200 CampaignMembers should have been removed');
        
    }
    
    static testMethod void testMobileCampaignWithContact_Exit()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        List<Contact> testContacts = TestUtils.createContacts(SIZE , 'Test Contact', null , false);
        for(Integer i = 0 ; i<SIZE; ++i)
        {
            testContacts[i].FkUser__c = i+'';
            testContacts[i].Email = 'testEmail@test.test'+i;
            testContacts[i].Contact_Type__c = 'Primary Contact'; 
        }
        insert testContacts;
        insert testLeads;   

        for(Contact theContact : testContacts)
        {
            theContact.Contact_Status__c = CampaignConstants.VM_FINAL;
        }

        Test.startTest();
             update testContacts;
        Test.stopTest();
        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember WHERE Status =  :CampaignConstants.REMOVED AND ContactId IN :testContacts];
        System.assertEquals(SIZE , campaignMembers.size() , '200 CampaignMembers should have been removed');
        
    }
    
    static testMethod void testMobileCampaignWithContact_WithOrderPlaced_Exit()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        List<Contact> testContacts = TestUtils.createContacts(SIZE , 'Test Contact', null , false);
        for(Integer i = 0 ; i<SIZE; ++i)
        {
            testContacts[i].FkUser__c = i+'';
            testContacts[i].Email = 'testEmail@test.test'+i;
            testContacts[i].Contact_Type__c = 'Primary Contact'; 
        }
        insert testContacts;
        insert testLeads;
        List<Order__c> testOrders = new List<Order__c>();


        for(Contact theContact : testContacts)
        {
            Order__c theOrder = TestUtils.createOrders(1 , null , false)[0];
            theOrder.Contact__c = theContact.Id; 
            testOrders.add(theOrder);           
        }

        Test.startTest();
             insert testOrders;
        Test.stopTest();
        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember WHERE Status =  :CampaignConstants.ORDER_PLACED AND ContactId IN :testContacts];
        System.assertEquals(SIZE , campaignMembers.size() , '200 CampaignMembers should have been removed');
        
    }
    
    
}