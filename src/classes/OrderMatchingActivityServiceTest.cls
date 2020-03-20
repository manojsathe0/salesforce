@isTest
public with sharing class OrderMatchingActivityServiceTest {
    public OrderMatchingActivityServiceTest() {
        
    }
    static List<Order__c> testOrders;
    static List<Account> testAccounts;
    static List<Contact> testContacts;
    final static Integer SIZE = 50;
    static User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , false);
    static void setupData()
    {
        testAccounts = TestUtils.createAccounts(SIZE , 'Test Account' , true);
        testContacts = new List<Contact>();
        for(Account theAccount : testAccounts)
        {
            Contact theContact = TestUtils.createContacts(1 , 'Test Contact' , theAccount.Id , false)[0];
            testContacts.add(theContact);
        }
        insert testContacts;
    }

    static void createContactTasks(String campaignName , List<Contact> contacts , Boolean isCommission)
    {
        List<Task> tasksToInsert = new List<Task>();
        for(Contact theContact : contacts)
        {
            theContact.Sales_opportunity_latest_campaign__c = campaignName;
            for(Integer i = 0; i < 1 ; ++i)
            {
                Task newTask = new task();
                newTask.Type = 'Call';
                newTask.Subject = 'Test Task';
                if(isCommission)
                    newTask.Commission_Eligible__c = true;
                newTask.WhoId = theContact.Id;
                tasksToInsert.add(newTask);
            }
        }
        update contacts; 
        insert tasksToInsert;
        OrderMatchingActivityService.hasCountByCampaignRun = false; //This is important to force the trigegr to run again
    }

    static void createLeadTasks(String campaignName , List<Lead> leads , Boolean isCommission)
    {
        List<Task> tasksToInsert = new List<Task>();
        for(Lead theLead : leads)
        {
            for(Integer i = 0; i < 1 ; ++i)
            {
                Task newTask = new task();
                newTask.Type = 'Call';
                newTask.Subject = 'Test Task';
                if(isCommission)
                    newTask.Commission_Eligible__c = true;
                newTask.WhoId = theLead.Id;
                tasksToInsert.add(newTask);
            }
        }
        update leads;
        insert tasksToInsert;
        OrderMatchingActivityService.hasCountByCampaignRun = false;  //This is important to force the trigegr to run again
    }

   

    static testMethod void testCountActivitiesByCampaignForContact_SingleCampaign()
    {
        setupData();
        
        Test.startTest();
            System.runAs(theUser)
            {
              createContactTasks('Inbound' , testContacts , true);
            }

        Test.stopTest();

        List<Order_Matching_Activity__c> updatedOMAs = [SELECT Id , Matched_Campaign__c ,  Activity_Count_By_Campaign__c FROM Order_Matching_Activity__c];
        System.assertEquals(50 , updatedOMAs.size() , '50 OMAs should have been created');
        for(Order_Matching_Activity__c theOMA : updatedOMAs)
        {

            System.assertEquals('Inbound' , theOMA.Matched_Campaign__c , 'Right Campaign should have been populated');
            System.assertEquals(1 , theOMA.Activity_Count_By_Campaign__c , 'Count  should be 1');
        }

    }
    

    static testMethod void testCountActivitiesByCampaignForContact_SingleCampaign_With_ThreeActivity()
    {
        setupData();
        
        Test.startTest();
            System.runAs(theUser)
            {
              createContactTasks('Inbound' , testContacts , true);
              createContactTasks('Inbound' , testContacts , false);
              createContactTasks('Inbound' , testContacts , true);
            }

        Test.stopTest();

        List<Order_Matching_Activity__c> updatedOMAs = [SELECT Id , Matched_Campaign__c ,  Activity_Count_By_Campaign__c FROM Order_Matching_Activity__c WHERE Activity_Count_By_Campaign__c = 3];
        System.assertEquals(50 , updatedOMAs.size() , '50 OMAs should have been created');
        
    }
    
    static testMethod void testCountActivitiesByCampaignForContact_MultipleCampaignsWithActivit()
    {
        setupData();
        System.runAs(theUser)
        {
        Test.startTest();
           
              createContactTasks('Inbound' , testContacts , true);
              createContactTasks('Inbound' , testContacts , true);
              createContactTasks('Abandoner' , testContacts , false);
              createContactTasks('Abandoner' , testContacts , true);
            

        Test.stopTest();
     
        }
        List<Order_Matching_Activity__c> updatedOMAs = [SELECT Id , Matched_Campaign__c ,  Activity_Count_By_Campaign__c FROM Order_Matching_Activity__c WHERE Activity_Count_By_Campaign__c = 2 AND Matched_Campaign__c = 'Abandoner'];
        System.assertEquals(50 , updatedOMAs.size() , '50 OMAs should have been created');

        updatedOMAs = [SELECT Id , Matched_Campaign__c ,  Activity_Count_By_Campaign__c FROM Order_Matching_Activity__c WHERE Activity_Count_By_Campaign__c = 2 AND Matched_Campaign__c = 'Inbound'];
        System.assertEquals(50 , updatedOMAs.size() , '50 OMAs should have been created');
        
    }
     
    static testMethod void testCountActivitiesByCampaignForLead_SingleCampaign()
    {
               
        Test.startTest();
            System.runAs(theUser)
            {
              List<Lead> testLeads = TestUtils.createLeads(SIZE , 'Test Lead' , true);
              createLeadTasks('Inbound' , testLeads , true);
            }

        Test.stopTest();

        List<Order_Matching_Activity__c> updatedOMAs = [SELECT Id , Matched_Campaign__c ,  Activity_Count_By_Campaign__c FROM Order_Matching_Activity__c];
        System.assertEquals(50 , updatedOMAs.size() , '50 OMAs should have been created');
        for(Order_Matching_Activity__c theOMA : updatedOMAs)
        {

            System.assertEquals('Inbound' , theOMA.Matched_Campaign__c , 'Right Campaign should have been populated');
            System.assertEquals(1 , theOMA.Activity_Count_By_Campaign__c , 'Count  should be 1');
        }

    }
    

    static testMethod void testCountActivitiesByCampaignForLead_SingleCampaign_With_ThreeActivity()
    {
        
       
        Test.startTest();
            System.runAs(theUser)
            {
              List<Lead> testLeads = TestUtils.createLeads(SIZE , 'Test Lead' , true);
              createLeadTasks('Inbound' , testLeads , true);
              createLeadTasks('Inbound' , testLeads , false);
              createLeadTasks('Inbound' , testLeads , true);
            }

        Test.stopTest();

        List<Order_Matching_Activity__c> updatedOMAs = [SELECT Id , Matched_Campaign__c ,  Activity_Count_By_Campaign__c FROM Order_Matching_Activity__c WHERE Activity_Count_By_Campaign__c = 3];
        System.assertEquals(50 , updatedOMAs.size() , '50 OMAs should have been created');
        
    }
    
    static testMethod void testCountActivitiesByCampaignForLead_MultipleCampaignsWithActivity()
    {
       
        
        Test.startTest();
            System.runAs(theUser)
            {
              List<Lead> testLeads = TestUtils.createLeads(SIZE , 'Test Lead' , true);
              createLeadTasks('Inbound' , testLeads , true);
              createLeadTasks('Inbound' , testLeads , false);
              createLeadTasks('Inbound' , testLeads , true);
              createLeadTasks('Abandoner' , testLeads , true);
            }

        Test.stopTest();

        List<Order_Matching_Activity__c> updatedOMAs = [SELECT Id , Matched_Campaign__c ,  Activity_Count_By_Campaign__c FROM Order_Matching_Activity__c WHERE Activity_Count_By_Campaign__c = 1 AND Matched_Campaign__c = 'Abandoner'];
        System.assertEquals(50 , updatedOMAs.size() , '50 OMAs should have been created');

        updatedOMAs = [SELECT Id , Matched_Campaign__c ,  Activity_Count_By_Campaign__c FROM Order_Matching_Activity__c WHERE Activity_Count_By_Campaign__c = 3 AND Matched_Campaign__c = 'Inbound'];
        System.assertEquals(50 , updatedOMAs.size() , '50 OMAs should have been created');
        
    }
  
}