@isTest
public  class AbandonerCampaignMemberBatchTest
{
    static void setupData()
    {

    }

    static testMethod void testPostPurchaseCampaignBatchWithPostPurchase()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        Test.startTest();
            AbandonerCampaignMemberBatch theBatch = new AbandonerCampaignMemberBatch();
            Database.executeBatch(theBatch , 50);
        Test.stopTest();
        
    }

}