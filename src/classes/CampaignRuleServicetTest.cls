@isTest
public class CampaignRuleServicetTest 
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

    static testMethod void testDuplicateRule_Entry_OnInsert()
    {
        setupData();

        Campaign_Rule__c duplicateRule = TestUtils.createCampaignRules(SIZE , testCampaigns[0].Id , null , '1', false)[0];
        duplicateRule.Entry_Exit__c = 'Entry';
        duplicateRule.RecordTypeId = CampaignRuleService.developerNameToRecordTypeIds.get(GENERAL_RULE);
        Boolean exceptionOccured = false;
        Test.startTest();
            try
            {
                insert duplicateRule;
            }
            catch(DMlException dmlEx)
            {
                exceptionOccured = true;
                System.assert(dmlEx.getMessage().contains(CampaignRuleService.DUPLICATE_RULE_MESSAGE) , 'Duplicate meesage should have been displayed.');
            }
        Test.stopTest();
        System.assert(exceptionOccured , 'Exception should have occured');
    }

    static testMethod void testPreventReferencedRuleDeletion()
    {
        setupData();
        Boolean exceptionOccured = false;
        Test.startTest();
            try
            {
                delete testCampaignRules[0];
            }
            catch(DMLException dmlEx)
            {
                exceptionOccured = true;
                System.assert(dmlEx.getMessage().contains(CampaignRuleService.THE_MESSAGE) , 'Prevent Deletion Message should have been displayed');
            }
        Test.stopTest();
        System.assert(exceptionOccured , 'Exception should have occured');
    }

    static testMethod void testPreventOnlyOneProductFieldPerCampaignRule()
    {
        setupData();

        Campaign_Rule__c productRule = TestUtils.createCampaignRules(SIZE , testCampaigns[0].Id , null , '4', false)[0];
        productRule.RecordTypeId = CampaignRuleService.developerNameToRecordTypeIds.get(PRODUCT_RULE);
        productRule.Base_Process__c = 'Test Process';
        productRule.Base_Product_Name__c = 'Test Product Name';
        Boolean exceptionOccured = false;
        Test.startTest();
            try
            {
                insert productRule;
            }
            catch(DMLException dmlEx)
            {
                exceptionOccured = true;
                System.assert(dmlEx.getMessage().contains(CampaignRuleService.PRODUCT_RULE_MESSAGE) , 'Product Rule Message should have been displayed');
            }
        Test.stopTest();
        System.assert(exceptionOccured , 'Exception should have occured');
    }

    static testMethod void testDuplicateRule_Entry_OnUpdate()
    {
        setupData();

        testCampaignRules[2].Rule_Id__c = '1';//changing Rule Id 2 to Rule Id 1 which already exists. 
        Boolean exceptionOccured = false;
        Test.startTest();
            try
            {
                update testCampaignRules[2];
            }
            catch(DMlException dmlEx)
            {
                exceptionOccured = true;
                System.assert(dmlEx.getMessage().contains(CampaignRuleService.DUPLICATE_RULE_MESSAGE) , 'Duplicate meesage should have been displayed.');
            }
        Test.stopTest();
        System.assert(exceptionOccured , 'Exception should have occured');
    }
}