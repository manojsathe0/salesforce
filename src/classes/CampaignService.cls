public with sharing class CampaignService 
{
	public final static Map<String,Integer> campaignMemberStatuses = new Map<String,Integer>{'Added' => 3 , 'Sales Activity' => 4,'Order Placed' => 5,'Removed' =>6};
	public CampaignService() 
	{
		
	}

	public static void createCampaignMemberStatus(List<Campaign> campaigns)
	{
		List<CampaignMemberStatus> statusToCreate = new List<CampaignMemberStatus>();
		for(Campaign theCampaign : campaigns)
		{
			
			for(String memberStatus : campaignMemberStatuses.keySet())
			{
				
				CampaignMemberStatus theMemberStatus = new CampaignMemberStatus();
				theMemberStatus.campaignId = theCampaign.Id;
				theMemberStatus.Label = memberStatus;
				
				if(memberStatus == 'Added')
				{
					theMemberStatus.IsDefault = true;
					theMemberStatus.SortOrder = campaignMemberStatuses.get(memberStatus);
					
				}
				else
				{
					theMemberStatus.IsDefault = false ;
					theMemberStatus.SortOrder = campaignMemberStatuses.get(memberStatus);
				}
				statusToCreate.add(theMemberStatus);
			}

		}
		if(!statusToCreate.isEmpty())
			insert statusToCreate;
	}
}