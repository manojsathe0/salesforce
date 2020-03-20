@isTest
public with sharing class TMSCampaignTest 
{
  static List<Lead> testLeads;
  static Integer SIZE = 200;
  public static void setupData()
  {
    testLeads = TestUtils.createLeads(SIZE , 'Test Lead', false); 
    for(Integer i = 0 ; i<SIZE ; ++i)
    {
      testLeads[i].Email = 'testEmail@test.test'+i;
      testLeads[i].Campaign__c = 'TMS';
    }

  }
  
  static testMethod void testTMSCampaignWithLead()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        Test.startTest();
           insert testLeads;   
        Test.stopTest();
        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember WHERE LeadId IN :testLeads];
        System.assertEquals(SIZE , campaignMembers.size() , '200 CampaignMembers should have been created');
        
    }

    static testMethod void testTMSCampaignWithLead_Exit()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        insert testLeads;  
        Test.startTest();
            Database.ExecuteBatch(new TMSCampaignExitBatch());
        Test.stopTest();
        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember WHERE LeadId IN :testLeads And Status =: CampaignConstants.REMOVED];
        System.assertEquals(SIZE , campaignMembers.size() , '200 CampaignMembers should have been created');
        
    }
      
}