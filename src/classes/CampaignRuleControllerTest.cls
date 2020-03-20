@isTest
public class CampaignRuleControllerTest
{
    static List<Campaign_Rule__c> testCampaignRules;
    static List<Campaign> testCampaigns;
    final static Integer SIZE = 1;
    final static String CAMPAIGN_NAME = 'Test Campaign';
    final static String POSTFIX_ENTRY = '12&3&';
    final static String POSTFIX_EXIT = '12|3|';
    final static String GENERAL_RULE = 'General_Rule';
    final static String PRODUCT_RULE = 'Product_Rule';
    
    static void setupData()
    {

        testCampaigns = TestUtils.createCampaigns(SIZE , CAMPAIGN_NAME , POSTFIX_ENTRY , POSTFIX_EXIT , true);
        testCampaignRules = new List<Campaign_Rule__c>();
        for(Integer i = 1 ; i<= 3 ;++i)
        {
            Campaign_Rule__c theRule = TestUtils.createCampaignRules(SIZE , testCampaigns[0].Id, null , i+'', false)[0];
            theRule.Entry_Exit__c = 'Entry';
            theRule.RecordTypeId = CampaignRuleService.developerNameToRecordTypeIds.get(GENERAL_RULE);
            testCampaignRules.add(theRule);
        }

        for(Integer i = 1 ; i<= 3 ;++i)
        {
            Campaign_Rule__c theRule = TestUtils.createCampaignRules(SIZE , testCampaigns[0].Id, null , i+'', false)[0];
            theRule.Entry_Exit__c = 'Exit';
            theRule.RecordTypeId = CampaignRuleService.developerNameToRecordTypeIds.get(GENERAL_RULE);
            testCampaignRules.add(theRule);
        }
        insert testCampaignRules;
    }
    
    static testmethod void testCampaignRules()
    {
        setupData();
        ApexPages.StandardController sc = new ApexPages.standardController(testCampaigns[0]);
        CampaignRuleController theController = new CampaignRuleController(sc);
        theController.entryInfix = '1';
        theController.entryPostfix = '2';
        theController.exitInfix = '3';
        theController.exitPostfix = '4';
        
        List<Campaign_Rule__c> campaignRules = theController.campaignRules;
        
        List<String> entryRuleIds = theController.entryRuleIds;
        List<String> exitRuleIds = theController.exitRuleIds;
        
        theController.updateCampaignEntry();
        theController.updateCampaignExit();
        
        
        system.assertEquals(theController.theCampaign.Campaign_Entry_Formula__c, theController.entryInfix);
        system.assertEquals(theController.theCampaign.Postfix_Expression_Entry__c, theController.entryPostfix);
        system.assertEquals(theController.theCampaign.Campaign_Exit_Formula__c, theController.exitInfix);
        system.assertEquals(theController.theCampaign.Postfix_Expression_Exit__c, theController.exitPostfix);
    }
}