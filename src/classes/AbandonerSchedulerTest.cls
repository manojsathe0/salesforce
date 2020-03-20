@isTest
private class AbandonerSchedulerTest 
{
   static testMethod void test_AbandonerScheduler() 
   {
   CampaignRulesSetup.setupCampaignWithRules();
    String CRON_EXP = '0 0 0 15 3 ? 2022';
    List<Campaign> testCampaigns = TestUtils.createCampaigns(10, 'test', null, null, false);
    for(Campaign theCampaign : testCampaigns)
    {
        theCampaign.Category__c = CampaignConstants.PRE_PURCHASE ;
    }
    insert testCampaigns;
     
    test.startTest();
      System.schedule('ScheduleApexClassTest', CRON_EXP, new AbandonerScheduler());
    test.stopTest();
    }
}