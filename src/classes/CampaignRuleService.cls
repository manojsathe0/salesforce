public with sharing class CampaignRuleService 
{
    
    public final static String ENTRY = 'Entry';
    public final static String THE_EXIT = 'Exit';
    public final static String THE_MESSAGE = 'Can\'t delete the rule that is referenced in the formula.First remove it from the formula and then delete it.';
    public final static String PRODUCT_RULE_MESSAGE = 'You can populate only one product field per Rule';
    public final static String DUPLICATE_RULE_MESSAGE = 'There is already a rule with that rule Id';
    
    public static List<Campaign_Rule__c> getCampaignRulesToConsiderForRuleId(Map<Id,Campaign_Rule__c> newCampaignRules , Map<Id,Campaign_Rule__c> oldCampaignRules)
    {
        List<Campaign_Rule__c> campaignRulesToReturn = new List<Campaign_Rule__c>();
        for(Campaign_Rule__c newRule : newCampaignRules.values())
        {
            Campaign_Rule__c oldRule = oldCampaignRules.get(newRule.Id);
            if(newRule.Rule_Id__c != oldRule.Rule_Id__c)
            {
                campaignRulesToReturn.add(newRule);
            }
        }
        return campaignRulesToReturn;
    }   

    public static void preventDuplicateRule(List<Campaign_Rule__c> campaignRules)
    {
        

        Set<Id> campaignIds = new Set<Id>();

        for(Campaign_Rule__c theRule : campaignRules)
        {
            if(theRule.Campaign__c != null)
            {
                campaignIds.add(theRule.Campaign__c);
            }
        }

        Map<Id,Campaign> allCampaigns = new Map<Id,Campaign>([SELECT Id , (SELECT Id , Rule_Id__c , Entry_Exit__c FROM Campaign_Rules__r) FROM Campaign WHERE Id IN :campaignIds]);
        
        Map<Id,Map<String,Set<String>>> campaignIdsToRule = new Map<Id,Map<String,Set<String>>>();
        
        
        if(!allCampaigns.isEmpty())
        {
            
            for(Campaign theCampaign : allCampaigns.values())
            {
                Map<String,Set<String>>  entryExitToSetOfRuleIds = new Map<String,Set<String>>();
                for(Campaign_Rule__c theRule : theCampaign.Campaign_Rules__r)
                {
                    if(theRule.Entry_Exit__c == ENTRY)
                    {
                        if(!entryExitToSetOfRuleIds.containsKey(ENTRY))
                            entryExitToSetOfRuleIds.put(ENTRY, new Set<String>());
                        entryExitToSetOfRuleIds.get(ENTRY).add(theRule.Rule_Id__c);
                    }
                    else if(theRule.Entry_Exit__c == THE_EXIT)
                    {
                        if(!entryExitToSetOfRuleIds.containsKey(THE_EXIT))
                            entryExitToSetOfRuleIds.put(THE_EXIT, new Set<String>());
                        entryExitToSetOfRuleIds.get(THE_EXIT).add(theRule.Rule_Id__c);  
                    }
                }
                campaignIdsToRule.put(theCampaign.Id , entryExitToSetOfRuleIds);
            }
        }

        for(Campaign_Rule__c theRule : campaignRules)
        {
            if(allCampaigns.containsKey(theRule.Campaign__c))
            {

                if(campaignIdsToRule.containsKey(theRule.Campaign__c))
                {
                    Map<String,Set<String>> entryExitToSetOfRuleIds = campaignIdsToRule.get(theRule.Campaign__c);
                    if(theRule.Entry_Exit__c == ENTRY)
                    {
                        if(entryExitToSetOfRuleIds.containsKey(ENTRY))
                        {
                            if(entryExitToSetOfRuleIds.get(ENTRY).contains(theRule.Rule_Id__c))
                            {
                                theRule.addError(DUPLICATE_RULE_MESSAGE);
                            }
                        }
                    }
                    else if(theRule.Entry_Exit__c == THE_EXIT)
                    {
                        if(entryExitToSetOfRuleIds.containsKey(THE_EXIT))
                        {
                            if(entryExitToSetOfRuleIds.get(THE_EXIT).contains(theRule.Rule_Id__c))
                            {
                                theRule.addError(DUPLICATE_RULE_MESSAGE);
                            }
                        }
                    }   
                }
                
                
            }
        }   
    }

    public static void preventOnlyOneProductFieldPerCampaignRule(List<Campaign_Rule__c> campaignRules)
    {
        
        for(Campaign_Rule__c theRule : campaignRules)
        {
            Integer i = 0;
            if(theRule.Base_Process__c != null)
            {
                ++i;
            }
            if(theRule.Base_Product_Line__c != null)
            {
                ++i;
            }
            if(theRule.Base_Product_Name__c != null)
            {
                ++i;
            }
            if(theRule.Child_Product_Name__c != null)
            {
                ++i;
            }
            if(i >1)
                theRule.addError(PRODUCT_RULE_MESSAGE);
        }
    }

    public static void preventReferencedRuleDeletion(Map<Id,Campaign_Rule__c> campaignRules)
    {
        for(Campaign_Rule__c theRule : [SELECT Id , Campaign__r.Postfix_Expression_Entry__c , Campaign__r.Postfix_Expression_Exit__c , Rule_Id__c FROM Campaign_Rule__c WHERE Id IN : campaignRules.values()])
        {
            if(theRule.Campaign__r.Postfix_Expression_Entry__c != null)
            {
                if(theRule.Campaign__r.Postfix_Expression_Entry__c.contains(theRule.Rule_Id__c))
                {
                    campaignRules.get(theRule.Id).addError(THE_MESSAGE);
                }
            }

            if(theRule.Campaign__r.Postfix_Expression_Exit__c != null)
            {
                if(theRule.Campaign__r.Postfix_Expression_Exit__c.contains(theRule.Rule_Id__c))
                {
                    campaignRules.get(theRule.Id).addError(THE_MESSAGE);
                }
            }
        }
    }


    public static Map<String,Id> developerNameToRecordTypeIds
    {
        get
        {
            if(developerNameToRecordTypeIds == null)
            {
                List<RecordType> recordTypes = [SELECT Id,Name,DeveloperName FROM RecordType WHERE sObjectType = 'Campaign_Rule__c'];    
                developerNameToRecordTypeIds = new Map<String,Id>();
                if(!recordTypes.isEmpty())
                {
                    for(RecordType theRecordType : recordTypes)
                    {
                        developerNameToRecordTypeIds.put(theRecordType.DeveloperName , theRecordType.Id);
                    }
                }
            }
            
            return developerNameToRecordTypeIds;
        }
        set;
    }


    
}