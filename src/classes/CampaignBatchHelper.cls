public with sharing class CampaignBatchHelper 
{
	public CampaignBatchHelper() {
		
	}

	public static void processCampaigns(List<CampaignMember> campaignMembers)
	{
		Map<Id,Lead> leads = new Map<Id,Lead>();
        Map<Id,Contact> contacts = new Map<Id,Contact>();
        for(CampaignMember theMember : campaignMembers)
        {
        	if(theMember.LeadId != null)
        	{
        		leads.put(theMember.LeadId , new Lead(Id = theMember.LeadId));
        	}
        	else if(theMember.ContactId != null)
        	{
        		contacts.put(theMember.ContactId , new Contact(Id = theMember.ContactId));
        	}
        }
        if(!leads.isEmpty())
        {
        	LeadService.processForCampaignsExit(leads.values());
        }
        if(!contacts.isEmpty())
        {
        	ContactService.processForCampaignsExit(contacts.values());
        }
    }
}