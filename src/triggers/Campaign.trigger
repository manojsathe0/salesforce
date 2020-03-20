trigger Campaign on Campaign (after insert)
{
	CampaignService.createCampaignMemberStatus(Trigger.new);
}