/**
 * Created by jboles on 5/16/2017.
 */
@isTest
public class SEADUtilityLibraryTest
{
    static void setupDataSEAD()
    {
        SEAD_Configuration__c config = new SEAD_Configuration__c();
        config.Name = 'Default';
        config.Lead_New_Stage_Activity_Limit__c = 1;
        config.Lead_Qualified_Stage_Activity_Limit__c = 2;
        config.Lead_Validated_Stage_Activity_Minimum__c = 3;
        config.Lead_Abandoner_Score__c = 1;
        config.Lead_Chat_Score__c = 1;
        config.Lead_Days_from_Ownership__c = 2;
        config.Lead_Email_Score__c = 1;
        config.Lead_Inbound_Score__c = 2;
        config.Lead_Mobile_Score__c = 3;
        config.Lead_Score_Initial__c = 3;
        config.Lead_Social_Media_Score__c = 1;


        insert config;
    }
    
  
       
    
    @isTest static void testGetConfig()
    {
        setupDataSEAD();
        //set up custom setting date for scoring time and percentage
        SEAD_Configuration__c config = TestUtils.setupSEAD_config();
        SEAD_Configuration__c config1 = SEAD_ConfigurationController.getConfig();
        SEAD_ConfigurationController.updateConfig(config, false);
        SEAD_Scoring_Time__c scoretimeMIN =  new SEAD_Scoring_Time__c(Name='Questionnaire_0-15',Time_Type__c='Minutes', Record_Type__c='Questionnaire',Minimum__c=0,Maximum__c=15, Score__c=5); 
        insert scoretimeMIN;
        SEAD_Scoring_Time__c scoretimeHRS =  new SEAD_Scoring_Time__c(Name='Questionnaire_0-15',Time_Type__c='Hours', Record_Type__c='Questionnaire',Minimum__c=0,Maximum__c=15, Score__c=5); 
        insert scoretimeHRS;
        SEAD_Scoring_Percent__c scorepercent = new SEAD_Scoring_Percent__c(Name='Questionnaire_0-25', Record_Type__c='Questionnaire',Minimum__c=0, Maximum__c=25,Score__c=1);
        insert scorepercent;
        
        List<SEAD_Scoring_Time__c> scoringChildren = SEAD_ConfigurationController.getScoringChildren('Questionnaire', 'Lead');
        
        SEAD_Scoring_Time__c ST= SEAD_ConfigurationController.gettimeRecord(scoretimeMIN.Id);
        List<SEAD_Scoring_Percent__c> scoringpercent = SEAD_ConfigurationController.getpercentage('Questionnaire', 'Lead');
        
        SEAD_Scoring_Percent__c sp = SEAD_ConfigurationController.getpercentRecord(scorepercent.Id);
        
        SEAD_Scoring_Time__c SCC =  new SEAD_Scoring_Time__c(Name='Questionnaire_1-4',Time_Type__c='Hours', Record_Type__c='Questionnaire',Minimum__c=1,Maximum__c=4, Score__c=3);
        SEAD_ConfigurationController.saveconfigChild(SCC,'Questionnaire',null, 'Lead');
        SEAD_Scoring_Percent__c SCP = new SEAD_Scoring_Percent__c(Name='Questionnaire_25-50', Record_Type__c='Questionnaire',Minimum__c=25, Maximum__c=50,Score__c=2);
        SEAD_ConfigurationController.saveconfigPercent(SCP,'Questionnaire',null, 'Lead');
        
        SEAD_ConfigurationController.deleteconfigChild(scoretimeMIN.Id);
        SEAD_ConfigurationController.deleteconfigPercent(scorepercent.Id);
        
    }


   @isTest static void getProductLineToSkillMap()
    {
        Map<String, Set<String>> productLineToSkillMap = SEADUtilityLibrary.productLineToSkillMap;
    }

    //@Sai - B-40356
    @isTest static void test_updateConfig_OppOnBoard()
    {
        setupDataSEAD();
        //set up custom setting date for scoring time and percentage
        SEAD_Configuration__c config = TestUtils.setupSEAD_config();
        SEAD_Configuration__c config1 = SEAD_ConfigurationController.getConfig();
        SEAD_ConfigurationController.updateConfig(config, true);
    }

    //@Sai - B-40356
    @isTest static void test_getConfigByName()
    {
        setupDataSEAD();
        //set up custom setting date for scoring time and percentage
        SEAD_Configuration__c config = TestUtils.setupSEAD_config();
        SEAD_ConfigurationController.getConfigByName('Default');
    }
}