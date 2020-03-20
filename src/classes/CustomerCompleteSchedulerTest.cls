@isTest
public class CustomerCompleteSchedulerTest
{
	
   static testMethod void myUnitTest() {
   List<Campaign> testCampaigns = TestUtils.createCampaigns(10, 'test', null, null, false);
   for(Campaign theCampaign : testCampaigns)
   {
       theCampaign.Category__c = CampaignConstants.CUSTOMER_COMPLETE;
   }
   insert testCampaigns;
    test.startTest();
	CustomerCompleteScheduler scheduler= new CustomerCompleteScheduler();
	String schedule = '0 0 23 * * ?';
	system.schedule('Customer Complete Campaign', schedule, scheduler);
	test.stopTest();
    	
}
}