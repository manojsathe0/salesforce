@isTest
private class MobileCampaignExitSchedulerTest 
{
  static List<Lead> testLeads;
  static Integer SIZE = 20; 
  static void setupData()
    {
      testLeads = TestUtils.createLeads(SIZE , 'Test Lead', false);
      for(Integer i = 0 ; i<SIZE ; ++i)
      {
          testLeads[i].Company = 'testEmail@test.test'+i;
          testLeads[i].LeadSource = 'Mobile';
          testLeads[i].Lead_Source_Detail__c = MobileCampaignTest.BUSINESS_SERVICES;
      }

    } 

   static testMethod void test_MobileCampaignExitScheduler() 
   { 
    CampaignRulesSetup.setupCampaignWithRules();
    setupData();
    String CRON_EXP = '0 0 0 15 3 ? 2022';
    List<Campaign> testCampaigns = TestUtils.createCampaigns(10, 'test', null, null, false);
    for(Campaign theCampaign : testCampaigns)
    {
        theCampaign.Category__c = CampaignConstants.PRE_PURCHASE ;
    }
    insert testCampaigns;
     
    test.startTest();
      System.schedule('ScheduleApexClassTest', CRON_EXP, new MobileCampaignExitScheduler());
    test.stopTest();
    }
}