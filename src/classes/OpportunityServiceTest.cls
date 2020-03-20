/*
OpportunityService class test coverage. Created on 10/20/2017
Author: Artyom M.
Story: B-22376 
Story - B-38758
*/
@isTest
public with sharing class OpportunityServiceTest {
	 static testMethod void test_ensureNoDuplicateOppsUnderSameContact() {
	 	
	 	List<Account> testAcc = TestUtils.createAccounts(1, 'Smith', true);
	 	List<Contact> testCnt = TestUtils.createContacts(1, 'Smith', testAcc[0].Id, true);
	 	
	 	List<Opportunity> testOpps = TestUtils.createOpportunities(2, 'Smith', false);
	 	
	 	
	 	for (Opportunity opp : testOpps) {
	 		opp.StageName = 'New';
	 		opp.Product2__c = 'LLC';
	 		opp.Contact__c = testCnt[0].Id;
	 		opp.AccountId = testAcc[0].Id;
	 		opp.Updated_By_Tealium__c = true;
	 		opp.OptIn_Opportunity__c = false;
	 		
	 	}
	 	insert testOpps[0];
	 	List<Profile> salesProfiles = [SELECT Id, Name FROM Profile WHERE Name LIKE 'Sales%'];
        Set<Id> salesProfileIdsSet = new Set <Id>();
        for (Profile pf : salesProfiles) {
            salesProfileIdsSet.add(pf.Id);
            
        }
        List<User> userList = [SELECT Id FROM User WHERE isActive = true AND ProfileId IN :salesProfileIdsSet LIMIT 1];
	 	User salesUsr = userList[0];
	 	
	 	
	 	System.runAs(salesUsr) {
	 		try {
	 			insert testOpps[1];	
	 		}
	 		catch (DmlException e) {
	 			System.assert(e.getMessage().contains(OpportunityService.DUP_ERROR_MSG));
	 		}
	 		testOpps[1].Product2__c = 'LAP';
	 		try {
	 			insert testOpps[1];	
	 		}
	 		catch (DmlException e) {
	 			System.assert(!e.getMessage().contains(OpportunityService.DUP_ERROR_MSG));
	 		}
	 		
	 		testOpps[1].Product2__c = 'LLC';
	 		try {
	 			update testOpps[1];	
	 		}
	 		catch (DmlException e) {
	 			System.Debug(e.getMessage());
	 			System.assert(e.getMessage().contains(OpportunityService.DUP_ERROR_MSG));
	 		}
	 	}
	 	
		
	 }
	 
	 /*
    Test Populate Opp score functionality based on Custom Settings data
    Created By: Artyom M.
    Per Stories: B-18405, B-18411
    */
    
	static testmethod void populateOppScoretest(){
        SEAD_Configuration__c config = TestUtils.setupSEAD_config();

        SEAD_Scoring_Time__c scoretimeMIN =  new SEAD_Scoring_Time__c(Name='Questionnaire_0-15',Time_Type__c='Minutes', Record_Type__c='Questionnaire',Minimum__c=0,Maximum__c=15, Score__c=5, Related_To__c='Opp'); 
        insert scoretimeMIN;
        SEAD_Scoring_Time__c scoretimeHRS =  new SEAD_Scoring_Time__c(Name='Questionnaire_0-15',Time_Type__c='Minutes', Record_Type__c='Questionnaire',Minimum__c=0,Maximum__c=15, Score__c=5, Related_To__c='Opp'); 
        insert scoretimeHRS;
        SEAD_Scoring_Percent__c scorepercent = new SEAD_Scoring_Percent__c(Name='Questionnaire_0-25', Record_Type__c='Questionnaire',Minimum__c=0, Maximum__c=25,Score__c=1, Related_To__c='Opp');
        insert scorepercent;


        List<Opportunity> testOppslst = TestUtils.createOpportunities(25 , 'TestLastName', false);
            for(Integer i = 0 ; i<25 ; ++i)
            {
            	testOppslst[i].StageName = 'New';
                testOppslst[i].LeadSource = 'Mobile';
                testOppslst[i].Questionnaire_End_Time__c=System.now();
                testOppslst[i].My_Account_End_Time__c=System.now();
                testOppslst[i].Website_End_Time__c=System.now();
                testOppslst[i].Questionnaire_Percent_Complete__c=24;
            }

        Test.startTest();
            insert testOppslst;
            SEAD_OppScoringBatch oppBatch = new SEAD_OppScoringBatch();
        	Database.executebatch(oppBatch, 25);
        Test.stopTest();
    }
    
    static testmethod void populateCloseDateTest() {
    	List<Opportunity> testOppslst = TestUtils.createOpportunities(5 , 'TestLastName', false);
            for(Integer i = 0; i<5 ; ++i) {
            	testOppslst[i].StageName = 'New';
                testOppslst[i].LeadSource = 'Mobile';
                testOppslst[i].Questionnaire_End_Time__c=System.now();
                testOppslst[i].My_Account_End_Time__c=System.now();
                testOppslst[i].Website_End_Time__c=System.now();
                testOppslst[i].Questionnaire_Percent_Complete__c=24;
            }
		testOppslst[0].StageName = 'Closed Won';
		
        Test.startTest();
            insert testOppslst;
        Test.stopTest();
        for(Integer i = 0; i<5 ; ++i) {
        	testOppslst[i].StageName = 'Closed Won';
        }
        testOppslst[0].LeadSource = 'Chat,';
        update testOppslst;
        
    }
    
    static testmethod void populateTealiumChangesTest() {
    	List<Opportunity> testOppslst = TestUtils.createOpportunities(5 , 'TestLastName', false);
            for(Integer i = 0; i<5 ; ++i) {
            	testOppslst[i].StageName = 'New';
                testOppslst[i].LeadSource = 'Mobile';
                testOppslst[i].Questionnaire_End_Time__c = System.now().addDays(-1);
                testOppslst[i].My_Account_End_Time__c = System.now().addDays(-1);
                testOppslst[i].Website_End_Time__c = System.now().addDays(-1);
                testOppslst[i].Questionnaire_Percent_Complete__c = 25;
            }

        Test.startTest();
            insert testOppslst;
        Test.stopTest();
        for(Integer i = 0; i<5 ; ++i) {
        	testOppslst[i].Updated_By_Tealium__c = true;
			testOppslst[i].Questionnaire_End_Time__c = System.now();
            testOppslst[i].My_Account_End_Time__c = System.now();
            testOppslst[i].Website_End_Time__c = System.now();
            testOppslst[i].Questionnaire_Percent_Complete__c = 75;
        }
        update testOppslst;
        
    }
}