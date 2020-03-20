public with sharing class CampaignRuleController {
    
    public Campaign theCampaign{get;set;}
    public String entryInfix{get;set;}
    public String entryPostfix{get;set;}
    public String exitInfix{get;set;}
    public String exitPostfix{get;set;}

    public CampaignRuleController(ApexPages.StandardController stdController) {
        this.theCampaign = (Campaign)stdController.getRecord();
    }


    public List<Campaign_Rule__c> campaignRules
    {
        get
        {
            if(campaignRules == null)
            {
                if(theCampaign.Id != null)
                {
                    campaignRules = [SELECT Id , Rule_Id__c , Across_Orders__c , Base_Process__c , Base_Product_Line__c , Base_Product_Name__c , 
                    Child_Product_Name__c , Campaign__r.Name , RecordType.Name , Entry_Exit__c , Field_To_Evaluate__c , Field_Value__c , Has_Purchased__c,
                     Number_of_Days__c , Object__c , Status__c FROM Campaign_Rule__c WHERE Campaign__c = :theCampaign.Id];
                }
            }
            return campaignRules;
        }
        set;
    }

    public List<String> entryRuleIds
    {
        get
        {
            if(entryRuleIds == null)
            {
                entryRuleIds = new List<String>();
                for(Campaign_Rule__c theRule : campaignRules)
                {
                    if(theRule.Entry_Exit__c == 'Entry')
                    {
                        entryRuleIds.add(theRule.Rule_Id__c);
                    }
                }
            }
            
            return entryRuleIds;
        }
        set;
    }

    public List<String> exitRuleIds
    {
        get
        {
            if(exitRuleIds == null)
            {
                exitRuleIds = new List<String>();
                for(Campaign_Rule__c theRule : campaignRules)
                {
                    if(theRule.Entry_Exit__c == 'Exit')
                    {
                        exitRuleIds.add(theRule.Rule_Id__c);
                    }
                }
            }
            
            return exitRuleIds;
        }
        set;
    }

    public PageReference updateCampaignEntry()
    {
        theCampaign.Campaign_Entry_Formula__c = entryInfix;
        theCampaign.Postfix_Expression_Entry__c = entryPostfix;
        update theCampaign;
        return null;
    }

    public PageReference updateCampaignExit()
    {
        theCampaign.Campaign_Exit_Formula__c = exitInfix;
        theCampaign.Postfix_Expression_Exit__c = exitPostfix;
        update theCampaign;
        return null;
    }
}