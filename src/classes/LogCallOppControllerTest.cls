@isTest
public class LogCallOppControllerTest {
    static final String CONTACT_STATUS = 'Contacted/Spoke';
    static final String COMMISSION_CONTACT_STATUS = 'Contacted/Spoke - Commission Eligible';

    //static final String LEAD_STATUS = 'Order Placed';
    static final String QUALIFIED_INTERESTED = 'Qualified (Interested)';

    static void setupDataSEAD() {
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
     
     static testMethod void testCreateTask() {
     	
     	Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
        Contact testContact = TestUtils.createContacts(1 , 'Test Contact' , testAccount.Id , false)[0];
        testContact.Genesys_Interaction_Id__c = '998899';
        insert testContact;
        
        System.Debug(testContact);
        List<Opportunity> testOpps = TestUtils.createOpportunities(1, 'Smith', false);
		 	for (Opportunity opp : testOpps) {
		 		opp.StageName = 'New';
		 		opp.Product2__c = 'LLC';
		 		opp.Contact__c = testContact.Id;
		 		opp.AccountId = testAccount.Id;
		 	}
		 	try {
		 		insert testOpps;
		 	}
		 	catch (DMLException ex) {
		 		System.Debug('ERROR HERE: ' + ex.getMessage());
		 	}
		 	
		 	System.Debug(testOpps[0]);
		 	Task theTask = new Task();
                    theTask.WhoId = testContact.Id;
                    theTask.Description = 'Test Description';
                    theTask.Reason_For_Contact__c = 'Transfer';
                    theTask.Reason_For_Transfer__c = 'Test';
                    theTask.CallObject = '998899';
                    
                    
                    try {
		 		insert theTask;
		 	}
		 	catch (DMLException ex) {
		 		System.Debug('ERROR HERE: ' + ex.getMessage());
		 	}
		 	
			Id theId = testOpps[0].Id;
            ApexPages.StandardController sc = new ApexPages.StandardController(testOpps[0]);
                LogCallOppController theController = new LogCallOppController(sc);
                PageReference pageRef = Page.LogCallOpp;
                pageRef.getParameters().put('id', String.valueOf(theId));
                Test.setCurrentPage(pageRef);
                
                Test.startTest(); 
                theController.createTask();
                theController.createEmailTask();
                Test.stopTest();
        
     }
     

}