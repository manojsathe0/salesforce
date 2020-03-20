@isTest
private class PostPurchaseCampaignSchedulerTest {
   static testMethod void myUnitTest() {
   List<Campaign> testCampaigns = TestUtils.createCampaigns(10, 'test', null, null, false);
   for(Campaign theCampaign : testCampaigns)
   {
       theCampaign.Category__c = CampaignConstants.POST_PURCHASE;
   }
   insert testCampaigns;
        test.startTest();
    PostPurchaseCampaignScheduler scheduler= new PostPurchaseCampaignScheduler();
    String schedule = '0 0 23 * * ?';
    system.schedule('Post Purchase Campaign', schedule, scheduler);
    test.stopTest();
    }
}