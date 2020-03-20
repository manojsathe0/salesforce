@isTest
private class PrePurchaseCampaignExitSchedulerTest
{
    static List<Lead> testLeads;
    static Integer SIZE = 100;
    static List<Account> testAccounts;
    static List<Contact> testContacts;
    static List<Order__c> testOrders;
    static List<Order_Item__c> testOrderItems;
    
    final static String TEST_ACCOUNT = 'Test Account';
    final static String TEST_CONTACT = 'Test Contact';
    static  Order_Payment_Status__c thePaymentStatus; 
    static
    {
        CampaignRulesSetup.setupCampaignWithRules();
    }
    static void setupData()
    {
      testLeads = TestUtils.createLeads(SIZE , 'Test Lead', false);
      for(Integer i = 0 ; i<SIZE ; ++i)
      {
          testLeads[i].Company = 'testEmail@test.test'+i;
          testLeads[i].LeadSource = 'Mobile';
          testLeads[i].Lead_Source_Detail__c = MobileCampaignTest.BUSINESS_SERVICES;
      }
        insert testLeads;
        
        
    } 
    
    static void setupEPBundleData()
    {
        testContacts = new List<Contact>();
        testOrderItems = new List<Order_Item__c>();
        testAccounts = TestUtils.createAccounts(SIZE , TEST_ACCOUNT , false);
        insert testAccounts;
    
        for(Account theAccount : testAccounts)
        {
            Contact theContact = TestUtils.createContacts(1 , TEST_CONTACT , theAccount.Id , false)[0];
            testContacts.add(theContact);
        }
    
        insert testContacts;
    
        thePaymentStatus = new Order_Payment_Status__c();
        thePaymentStatus.Name  = 'Approved';
        thePaymentStatus.Order_Payment_Status_ID__c = '1';
        insert thePaymentStatus;
    }
    
   static testMethod void test_PrePurchaseExitScheduler() 
   {
       
       setupData();
       String CRON_EXP = '0 0 0 15 3 ? 2022';
       List<CampaignMember> membersToUpdate = new List<CampaignMember>();
       for(CampaignMember theMember : [SELECT Id, DateTime_Added_to_Campaign__c, Campaign.Name FROM CampaignMember Where Campaign.Name = 'Mobile'])
       {
           theMember.DateTime_Added_to_Campaign__c = System.now().addDays(-40);
           membersToUpdate.add(theMember);
       }
       update membersToUpdate;
       system.debug(membersToUpdate+'updated campaign members');
         
        test.startTest();
          System.schedule('ScheduleApexClassTest', CRON_EXP, new PrePurchaseCampaignExitBatchScheduler());
        test.stopTest();
        
    }
    
   static testMethod void test_PrePurchaseExitBatch() 
   {
      
       setupData();
       String CRON_EXP = '0 0 0 15 3 ? 2022';
       List<CampaignMember> membersToUpdate = new List<CampaignMember>();
       for(CampaignMember theMember : [SELECT Id, DateTime_Added_to_Campaign__c, Campaign.Name FROM CampaignMember Where Campaign.Name = 'Mobile'])
       {
           theMember.DateTime_Added_to_Campaign__c = System.now().addDays(-40);
           membersToUpdate.add(theMember);
       }
       update membersToUpdate;
       system.debug(membersToUpdate+'updated campaign members');
         
        test.startTest();
          Database.executebatch(new PrePurchaseCampaignExitBatch(), SIZE);
        test.stopTest();
        
        List<CampaignMember> campaignMembers = [SELECT Id, Lead.LeadSource FROM CampaignMember WHERE Status = :CampaignConstants.REMOVED AND LeadId IN :testLeads];
        System.assertEquals(SIZE , campaignMembers.size() , SIZE+' CampaignMembers should have been removed');
    
    
    }
    
    static testMethod void testEPBundleUpsell_Exit()
    {
       
        setupEPBundleData();
        testOrders = new List<Order__c>();
        for(Integer i = 0 ; i<SIZE ; ++i)
        {
            Order__c theOrder = TestUtils.createOrders(1 , CampaignRulesSetup.testProducts[6].Id , false)[0]; //Product Living Trust.Looks at the Process.
            theOrder.Contact_State__c = 'CA';
            theOrder.Contact__c = testContacts[i].Id;
            theOrder.Order_Payment_Status__c = thePaymentStatus.Id;
            testOrders.add(theOrder);   
        }
               
        insert testOrders;
        
        for(Order__c theOrder : testOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            testOrderItems.add(theItem);
        }
        insert testOrderItems;
        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember WHERE Status = 'Added' AND Campaign.Name = :CampaignConstants.EP_UPSELL_CAMPAIGN];
        System.assertEquals(SIZE , campaignMembers.size() , SIZE + ' Campaign Members should have been created');
        
        for(Contact theContact : testContacts)
        {
            theContact.Last_Sales_Activity__c = DateTime.now().addDays(-8);
        }
        update testContacts;
        
        Test.startTest();
             Database.executebatch(new PrePurchaseCampaignExitBatch(), SIZE);       
        Test.stopTest();

        campaignMembers = [SELECT Id FROM CampaignMember WHERE Status = 'Removed' AND Campaign.Name = :CampaignConstants.EP_UPSELL_CAMPAIGN];
        System.assertEquals(SIZE , campaignMembers.size() , SIZE+ ' Campaign Members should have been created');

    }
    
}