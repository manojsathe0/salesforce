@isTest
public with sharing class CampaignServiceTest 
{
	 
	static  testMethod void testCampaignMemberStatusAdded()
	{
		
		Campaign testCampaign;
		Test.startTest();
			testCampaign = TestUtils.createCampaigns(1 , 'My Campaign' , null , null , true)[0];
		Test.stopTest();
		
		Set<String> memberStatuses = new Set<String>();
		for(CampaignMemberStatus theStatus : [SELECT Id , Label FROM CampaignMemberStatus WHERE campaignId = :testCampaign.Id])
		{
			memberStatuses.add(theStatus.Label);
		}
		System.assert(memberStatuses.containsAll(CampaignService.campaignMemberStatuses.keySet()) , 'All Member Status should have been populated');
	}
}