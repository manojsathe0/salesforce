trigger CampaignRule on Campaign_Rule__c (before insert , before update , before delete) 
{
	if(Trigger.isBefore)
	{
		if(Trigger.isInsert)
		{
			CampaignRuleService.preventDuplicateRule(Trigger.new);
			CampaignRuleService.preventOnlyOneProductFieldPerCampaignRule(Trigger.new);
		}
		if(Trigger.isUpdate)
		{
			List<Campaign_Rule__c> campaignRules = CampaignRuleService.getCampaignRulesToConsiderForRuleId(Trigger.newMap, Trigger.oldMap);
			if(!campaignRules.isEmpty())
				CampaignRuleService.preventDuplicateRule(campaignRules);
			CampaignRuleService.preventOnlyOneProductFieldPerCampaignRule(Trigger.new);
		}
		if(Trigger.isDelete)
		{
			CampaignRuleService.preventReferencedRuleDeletion(Trigger.oldMap);
		}
		
	}

}