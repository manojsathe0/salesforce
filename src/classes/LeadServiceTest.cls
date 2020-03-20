//B-38758
@isTest
public class LeadServiceTest 
{
    static void setup()
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
    static List<Lead> testLeads;
    static testMethod void testCustomOwnerFieldPopulated_OnInsert()
    {
        setup();
        testLeads = TestUtils.createLeads(5 , 'Johnson', false);
        Test.startTest();
            insert testLeads;
        Test.stopTest();
        List<Lead> insertedLeads = [SELECT Id , OwnerId , Custom_Owner__c FROM Lead];
        System.assertEquals(5 , insertedLeads.size() , '5 leads should have been returned');
        for(Lead theLead : insertedLeads)
        {
            System.assertEquals(theLead.OwnerId , theLead.Custom_Owner__c , 'Custom Owner look up should have been populated with owner Id');
        }
    }
    
    static testMethod void testCheckForDuplicateContact()
    {
        setup();
        Account theAccount = TestUtils.createAccounts(1 , 'TestDuplicate' , true)[0];
        List<Contact> contactsToInsert = TestUtils.createContacts(100, 'ContactDuplicateTest', theAccount.id, false);
        for(integer i=0; i< contactsToInsert.size()/2; i++)
        {
            contactsToInsert[i].Contact_Type__c = 'Primary Contact';
            contactsToInsert[i].Email = i+'dupetest@lz.com';
        }
        for(integer i=contactsToInsert.size()/2; i< contactsToInsert.size(); i++)
        {
            contactsToInsert[i].Contact_Type__c = 'Authorized Contact';
            contactsToInsert[i].Email = i+'dupetestAuth@lz.com';
        }
        insert contactsToInsert;

        List<Lead> leadsToTest = TestUtils.createLeads(100, 'leadDupeTest', false);
        for(integer i=0; i< leadsToTest.size()/2; i++)
        {
            leadsToTest[i].Email = i+'dupetest@lz.com';
        }
        for(integer i=leadsToTest.size()/2; i< leadsToTest.size(); i++)
        {
            leadsToTest[i].Email = i+'dupetestAuth@lz.com';
            leadsToTest[i].FirstName = 'authfirstNAme';
        }
        Test.startTest();
        try
        {
            insert leadsToTest;
            LeadService.checkForDuplicateContact(leadsToTest);
            system.debug(leadsToTest);
        }
        catch(Exception exp)
        { 
            system.assertEquals(50, exp.getNumDml());
        }
        Test.stopTest();
    }
    
    static testMethod void testLedsForConversion()
    {
        setup();
        testLeads = TestUtils.createLeads(100 , 'TestLastName', false);
        for(Integer i = 0 ; i< 50 ; ++i)
        {
            testLeads[i].Company = 'testEmail@test.test'+i;
            testLeads[i].LeadSource = 'Mobile';
            testLeads[i].Lead_Source_Detail__c = MobileCampaignTest.BUSINESS_SERVICES;
            testLeads[i].Campaign__c = 'TMS';
            
            
        }
        for(Integer i = 50 ; i< 100 ; ++i)
        {
            testLeads[i].Company = 'anotherEmail@test.test'+i;
            testLeads[i].LeadSource = 'Mobile';
            testLeads[i].Lead_Source_Detail__c = MobileCampaignTest.BUSINESS_SERVICES;
             testLeads[i].Campaign__c ='TMS';
        }


        List<Contact> testContacts = TestUtils.createContacts(100 , 'Test Contact', null , false);
        for(Integer i = 0 ; i<100; ++i)
        {
            testContacts[i].FkUser__c = i+'';
            testContacts[i].Email = 'testEmail@test.test'+i;
            testContacts[i].Contact_Type__c = 'Primary Contact';
        }
        insert testContacts;

        Test.startTest();
            insert testLeads;

        Test.stopTest();
        List<Lead> leadlist=[SELECT Id,Campaign__c,Email FROM Lead WHERE Id IN :testLeads];
        LeadService.processTmsLeads(leadlist);
        List<Lead> unConvertedLeads = [SELECT Id FROM Lead WHERE IsConverted = false];
        System.assertEquals(50 , unconvertedLeads.size() , '50 leads hsould have been not converted');

        List<Lead> convertedLeads = [SELECT Id FROM Lead WHERE IsConverted = true];
        System.assertEquals(50 , convertedLeads.size() , '50 leads hsould have been converted');
        
    }
    static testMethod void tealiumUpdatetest()
    {
        setup();
        User u = [select id, profileid from User where name = 'Integration User' limit 1];

        system.runAs(u)
        {
           list<Lead> testLeads = TestUtils.createLeads(100 , 'TestLastName', false);
            for(Integer i = 0 ; i< 100 ; ++i)
            {
                testLeads[i].Company = 'testEmail@test.test'+i;
                testLeads[i].LeadSource = 'Mobile';
                testLeads[i].Lead_Source_Detail__c = MobileCampaignTest.BUSINESS_SERVICES;
            }


            Test.startTest();
            insert testLeads;


            testLeads[0].Updated_By_Tealium__c = true;
            testLeads[0].LeadSource = 'Abandoner';

            update testLeads[0];
            test.stopTest();
        }


    }
     /*
    Test Populate Opp score functionality based on Custom Settings data
    Created By: Artyom M.
    Per Stories: B-18405, B-18411
    
    Moved to OppService test
    */
    


/* Author : Padma S
 * Story  :B-18708 and B-16602
 * Date   :06/20/2017
 * Description : Test method for populateLeadScore
    */

    static testmethod void populateLeadScoretest(){
        //Create custom setttings 
        SEAD_Configuration__c config = TestUtils.setupSEAD_config();

        SEAD_Scoring_Time__c scoretimeMIN =  new SEAD_Scoring_Time__c(Name='Questionnaire_0-15',Time_Type__c='Minutes', Record_Type__c='Questionnaire',Minimum__c=0,Maximum__c=15, Score__c=5, Related_To__c='Lead'); 
        insert scoretimeMIN;
        SEAD_Scoring_Time__c scoretimeHRS =  new SEAD_Scoring_Time__c(Name='Questionnaire_0-15',Time_Type__c='Minutes', Record_Type__c='Questionnaire',Minimum__c=0,Maximum__c=15, Score__c=5, Related_To__c='Lead'); 
        insert scoretimeHRS;
        SEAD_Scoring_Percent__c scorepercent = new SEAD_Scoring_Percent__c(Name='Questionnaire_0-25', Record_Type__c='Questionnaire',Minimum__c=0, Maximum__c=25,Score__c=1, Related_To__c='Lead');
        insert scorepercent;
        //create leads    
        List<Lead> testLeadslst = TestUtils.createLeads(25 , 'TestLastName', false);
            for(Integer i = 0 ; i<25 ; ++i)
            {
                testLeadslst[i].Company = 'testEmail@test.test'+i;
                testLeadslst[i].LeadSource = 'Mobile';
                testLeadslst[i].Lead_Source_Detail__c = MobileCampaignTest.BUSINESS_SERVICES;
                testLeadslst[i].Questionnaire_End_Time__c=System.now();
                testLeadslst[i].My_Account_End_Time__c=System.now();
                testLeadslst[i].Website_End_Time__c=System.now();
                testLeadslst[i].Questionnaire_Percent_Complete__c=24;
            }

        Test.startTest();
            insert testLeadslst;
            SEAD_LeadScoringBatch scorebatch = new SEAD_LeadScoringBatch();
            Database.executeBatch(scorebatch, 25);
        Test.stopTest();
    }  

    Static testmethod void reOpenClosedLeadtest(){
        setup();
        list<Lead> testLeads = TestUtils.createLeads(9 , 'TestLastName', false);
            for(Integer i = 0 ; i< 3 ; ++i)
            {
                testLeads[i].Company = 'testEmail@test.test'+i;
                testLeads[i].LeadSource = 'Mobile';
                testLeads[i].Status = 'Closed Lost';
                testleads[i].Closed_Lost_Reason__c = 'Product Too Expensive';
            }
          

          Insert  testLeads; 
          List<Task> tasktoinsert = new List<Task>();
          List<My_Account_Activity__c > acttoinsert = new List<My_Account_Activity__c >();
          List<Opt_In_Cart_Item__c> cartitems = new List<Opt_In_Cart_Item__c>();
         Task tsk0 = new Task(Description = 'Test Description', WhoId=testLeads[0].Id);
         tasktoinsert.add(tsk0);
         for (integer i=0; i<2; i++){
            Task tsk = new Task(Description = 'Test Description', WhoId=testLeads[1].Id);
            tasktoinsert.add(tsk);
            
            My_Account_Activity__c act = new My_Account_Activity__c(Name = 'Name'+i, Lead__c=testLeads[1].Id);
            acttoinsert.add(act);
            
            Opt_In_Cart_Item__c opt = new Opt_In_Cart_Item__c(Name='Name'+i, Lead__c=testLeads[1].Id);
            cartitems.add(opt);
         }
          for (integer i=0; i<3; i++){
            Task tsk = new Task(Description = 'Test Description', WhoId=testLeads[2].Id);
            tasktoinsert.add(tsk);
            
             My_Account_Activity__c act = new My_Account_Activity__c(Name = 'Name'+i+3, Lead__c=testLeads[2].Id);
            acttoinsert.add(act);
            
            Opt_In_Cart_Item__c opt = new Opt_In_Cart_Item__c(Name='Name'+i+3, Lead__c=testLeads[2].Id);
            cartitems.add(opt);
         }

         insert tasktoinsert;
         insert acttoinsert;
         insert cartitems;
         
         List<Lead>updateleads = new list<Lead>();
         for (Lead i : [Select Id,Questionnaire_End_Time__c from Lead Where Id IN:testLeads] ){
                i.Questionnaire_End_Time__c=System.Now();
                updateleads.add(i);
         }

         update   updateleads;
         
         LeadService.reOpenClosedLead(updateleads);
         List<Lead> leadlst = [Select id, Status from Lead Where Id in :updateleads and Status = 'New'];
         System.assertequals(leadlst[0].Status, 'New');
         
         List<Opt_In_Cart_Item__c > listopt = [Select id from Opt_In_Cart_Item__c  where Lead__c IN:updateleads];
         
         List<My_Account_Activity__c > listact = [Select id from My_Account_Activity__c where Lead__c IN:updateleads];
         
         Opt_In_Cart_Item__c  optitem1 = listopt [0];
         My_Account_Activity__c  actitem1=listact [0];
         
         delete optitem1 ;
         delete actitem1;
         OptInService.deleteOptIns(listopt);
         MyAccountActivityService.deleteMyAccountActivities(listact);

    }
 	@isTest
    static void testDelete() {
    	setup();
        testLeads = TestUtils.createLeads(5 , 'Johnson', true);
        Test.startTest();
        	
            delete testLeads;
        Test.stopTest();
    }
        
}