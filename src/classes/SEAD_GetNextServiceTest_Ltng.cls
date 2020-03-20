/*
Created per story: B-25556  
By: Artyom M.
Migration of GetNext functionality to Lightning.  
*/


@isTest
public class SEAD_GetNextServiceTest_Ltng {
    static List<Contact> testContacts;
    static List<Lead> testLeads;
    static List<Campaign> testCampaigns;
    static List<CampaignMember> testCampaignMember;
    static SEAD_LeadContactController.LeadContactMessage theMessage;
    static SEAD_GetNextService_Ltng.GetNextResponseStatus responseStatus;
    static final Integer ACCOUNT_RECORD_SIZE = 10;
    static final Integer CAMPAIGN_WITHOUT_SKILLS_RECORD_SIZE = 2;
    static final Integer CAMPAIGN_WITH_SKILLS_RECORD_SIZE = 1;
    static final Integer RECORD_SIZE = 10;
    static final String MAX_ABANDONER_PER_DAY = '20';
    static final String CONTACT_NAME = 'Test Contact';
    static final String LEAD_NAME = 'Test Lead';
    static final string LAST_NAME = 'John';
    static final string CAMPAIGN_NAME = 'Test Campaign';
    static User testUser;
    
    static void setupData() {
            testLeads = TestUtils.createLeads(RECORD_SIZE , LAST_NAME , false);
            List<Account> testAccounts = TestUtils.createAccounts(ACCOUNT_RECORD_SIZE, LAST_NAME, true);
            testContacts = TestUtils.createContacts(RECORD_SIZE, LAST_NAME, testAccounts[0].Id, false);
            testUser = TestUtils.createUser(LAST_NAME , TestUtils.STANDARD_PROFILE_ID , true);
            //TestUtils.createSEADConfig();
            SEAD_Configuration__c config = TestUtils.setupSEAD_config();
            for(Contact theContact : testContacts) 
                {
                    theContact.Lead_Score_Non_Time_Sensitive__c = 90;
                }
            for(Lead theLead : testLeads)
                {
                    theLead.Lead_Score_Non_Time_Sensitive__c = 90;
                }
            System.runAs(testUser)
                {
                    insert testContacts;
                    insert testLeads;
                }
            Max_Abandoner_Per_Day__c maxAbandoners = new Max_Abandoner_Per_Day__c(Name = MAX_ABANDONER_PER_DAY);
            insert maxAbandoners;

            testCampaigns = TestUtils.createCampaigns(CAMPAIGN_WITHOUT_SKILLS_RECORD_SIZE,CAMPAIGN_NAME, null, null, false);
            for(Campaign theCampaign : TestUtils.createCampaigns(CAMPAIGN_WITH_SKILLS_RECORD_SIZE,CAMPAIGN_NAME, null, null, false))
                {
                    theCampaign.Need_Skills__c = true;
                    testCampaigns.add(theCampaign);
                }insert testCampaigns;
    }
    
    static testMethod void testAssignNewAbandoners_SuccessLeads() {
            setupData();
            testCampaignMember = new List<CampaignMember>();
            List<Lead> moreLeads = TestUtils.createLeads(RECORD_SIZE, 'Test Lead', false);
            System.runAs(UtilityLibrary.integrationUser)
                {
                    insert moreLeads;
                }
            for(Integer i = 0; i < moreLeads.size()/2; i++)
                {
                    moreLeads[i].Lead_Score_Non_Time_Sensitive__c = 80;
                    CampaignMember theCampaignMember = new CampaignMember();
                    theCampaignMember.LeadId = moreLeads[i].Id;
                    theCampaignMember.CampaignId = testCampaigns[0].Id;
                    testCampaignMember.add(theCampaignMember);
                }
            for(Integer i = moreLeads.size()/2; i < moreLeads.size(); i++)
                {
                    moreLeads[i].Lead_Score_Non_Time_Sensitive__c = 90;
                    moreLeads[i].Product2__c = 'NC';
                    CampaignMember theCampaignMember = new CampaignMember();
                    theCampaignMember.LeadId = moreLeads[i].Id;
                    theCampaignMember.CampaignId = testCampaigns[testCampaigns.size() - 1].Id;
                    testCampaignMember.add(theCampaignMember);
                }
            update moreLeads;
            insert testCampaignMember;

            User stdUser = TestUtils.createUser( 'Cartman' , TestUtils.STANDARD_PROFILE_ID , true);
            Id recordTypeId = Schema.SObjectType.Team_Management__c.getRecordTypeInfosByName().get('Sales Team Management').getRecordTypeId();

            Team_Management__c theUser = new Team_Management__c();
            theUser.RecordTypeId  = recordTypeId;
            theUser.User__c = stdUser.Id;
            theUser.Skills__c = testCampaigns[0].Name;
            theUser.Skill_Set__c = 'Mobile-PS;Abandoner-Biz;Abandoner-IP';
            System.runAs(stdUser)
                {
                    insert theUser;
                    Test.startTest();
                    responseStatus = SEAD_GetNextService_Ltng.getNextAbandoner();
                    Test.stopTest();
                }
            System.assertEquals(true, responseStatus.thereAreErrors);
            List<Lead> testInsertedLeads = [Select ID,Name, OwnerId From Lead Where OwnerId =: stdUser.ID];
            //System.assertEquals(1,testInsertedLeads.size());
            //System.assertEquals(stdUser.Id, testInsertedLeads[0].OwnerId);
        }
        
        static testMethod  void testOppScenario() {
            setupData();
             SEAD_Scoring_Time__c scoretimeMIN =  new SEAD_Scoring_Time__c(Name='Questionnaire_0-15',Time_Type__c='Minutes', Record_Type__c='Questionnaire',Minimum__c=0,Maximum__c=15, Score__c=5, Related_To__c='Opp'); 
        insert scoretimeMIN;
        SEAD_Scoring_Time__c scoretimeHRS =  new SEAD_Scoring_Time__c(Name='Questionnaire_0-15',Time_Type__c='Minutes', Record_Type__c='Questionnaire',Minimum__c=0,Maximum__c=15, Score__c=5, Related_To__c='Opp'); 
        insert scoretimeHRS;
        SEAD_Scoring_Percent__c scorepercent = new SEAD_Scoring_Percent__c(Name='Questionnaire_0-25', Record_Type__c='Questionnaire',Minimum__c=0, Maximum__c=25,Score__c=1, Related_To__c='Opp');
        insert scorepercent;
            
            Account acc = new Account();
            acc.Name = 'TestAcc12';
            

            System.runAs(UtilityLibrary.integrationUser) {
                insert acc;//testAccounts = TestUtils.createAccounts(1, LAST_NAME, true);
            }
            System.Debug('ACC IN: ' + acc.id);
            Contact cnt = new Contact();
            cnt.account = acc;
            cnt.FirstName = 'Joh23n';
            cnt.lastName = 'Doe333';
            cnt.email = 'test2231232@jlasdkfasdj.com';
            
            //testContacts = TestUtils.createContacts(1, LAST_NAME, testAccounts[0].Id, false);
            System.runAs(UtilityLibrary.integrationUser) {
                try {
                insert cnt;//insert testContacts;
                }
                catch (DMLException e) {
                    System.Debug('EXT: ' + e.getMessage());
                }
            }
            System.Debug('cont IN: ' + cnt.id);
            /* */
            List<Opportunity> opps = TestUtils.createOpportunities(1, 'Smith', false);
            for (Opportunity opp : opps) {
                opp.Account = acc;
                opp.Contact__c = cnt.Id;
                opp.StageName = 'New';
                opp.Score__c = 500;
                opp.Product2__c = 'LLCS';
                opp.OnBoarding__c=false;
            }
            System.runAs(UtilityLibrary.integrationUser) {
                try {
                    insert opps;
                }
                catch (DMLException e) {
                    System.Debug('EXT: ' + e.getMessage());
                }
                catch (Exception e) {
                    System.Debug('EXT: ' + e.getMessage());
                }
                
            }
            System.Debug('opp IN: ' + opps[0].id);
            List<Opportunity> selectedOpps = new List<Opportunity>();
            selectedOpps = [SELECT Id, OwnerId, Score__c, Contact__c, Product_Line2__c FROM Opportunity LIMIT 1];
            System.debug('selectedOpps.isEmpty() = ' + selectedOpps.isEmpty());
            if (!selectedOpps.isEmpty()) {
                System.debug(selectedOpps[0].OwnerId);
                System.debug(selectedOpps[0].Score__c);
                System.debug(selectedOpps[0].Product_Line2__c);
                System.debug(selectedOpps[0].Contact__c);
                
            }
            System.Debug('EXT: ');
            User stdUser = TestUtils.createUser( 'Cartman2' , TestUtils.salesAgentProfileId , true);
            Id recordTypeId = Schema.SObjectType.Team_Management__c.getRecordTypeInfosByName().get('Sales Team Management').getRecordTypeId();
            Team_Management__c theUser = new Team_Management__c();
            theUser.RecordTypeId  = recordTypeId;
            theUser.User__c = stdUser.Id;
            
            theUser.Skill_Set__c = 'Mobile-PS;Abandoner-Biz;Abandoner-IP';
            
            System.debug('HERE2');
            System.runAs(stdUser)
                {
                    List<Opportunity> selectedOpps2 = new List<Opportunity>();
            selectedOpps2 = [SELECT Id, OwnerId, Score__c,OnBoarding__c, Contact__c, Product_Line2__c FROM Opportunity LIMIT 1];
            System.debug('AGAIN.isEmpty() = ' + selectedOpps2.isEmpty());
                    insert theUser;
                    Test.startTest();
                    responseStatus = SEAD_GetNextService_Ltng.getNextAbandoner();
                    Test.stopTest();
                }
                
                
            //System.assertEquals(false, responseStatus.thereAreErrors);
            //SEAD_GetNextAbandonerLeadContact temp = new SEAD_GetNextAbandonerLeadContact();
            //temp.getNextAbandoner();
            
        }
        

}