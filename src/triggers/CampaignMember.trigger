trigger CampaignMember on CampaignMember (after update , after insert)
{
    if(Trigger.isUpdate)
    {
        CampaignMemberService.updateCampaignNameOnLeadAndContact(Trigger.newMap);
        CampaignMemberService.populateProductNameForEPBundelUpsell(Trigger.new);   
        if(UserInfo.getUserId() == CampaignMemberService.LZ_Site_User_ID)
        { 
            if(!CampaignMemberService.hasCampaignMemberLogicRun) 
                CampaignMemberService.updateLeadsOrContacts(Trigger.new);
        }
    }
    else if(Trigger.isInsert)
    {
        CampaignMemberService.updateCampaignNameOnLeadAndContact(Trigger.newMap);
        if(UserInfo.getUserId() == CampaignMemberService.LZ_Site_User_ID)
        {
            CampaignMemberService.updateLeadsOrContacts(Trigger.new);
        }
        CampaignMemberService.populateProductNameForEPBundelUpsell(Trigger.new);   
    }   
}