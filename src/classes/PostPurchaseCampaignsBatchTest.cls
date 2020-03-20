@isTest
private class PostPurchaseCampaignsBatchTest
{
    static List<Account> testAccounts;
    static List<Contact> testContacts;
    static List<Order__c> testOrders;
    static List<Order_Item__c> testOrderItems;
    static User_Order_Extension__c firstUserOrderExtension;
    static User_Order_Extension__c secondUserOrderExtension;
  
    final static String TEST_ACCOUNT = 'Test Account';
    final static String TEST_CONTACT = 'Test Contact';
    final static Integer SIZE = 100; 

    static void setupData()
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

        firstUserOrderExtension = new User_Order_Extension__c();
        firstUserOrderExtension.Processing_Status__c = CampaignRulesSetup.sentToCustomerProcessingStatus.Id;
        firstUserOrderExtension.Processing_Status_Date_Time__c = Date.today().addDays(-16);
        insert firstUserOrderExtension;

        secondUserOrderExtension = new User_Order_Extension__c();
        secondUserOrderExtension.Processing_Status__c = CampaignRulesSetup.sentToCustomerProcessingStatus.Id;
        secondUserOrderExtension.Processing_Status_Date_Time__c = Date.today().addDays(-190);
        insert secondUserOrderExtension;

    }

    static testMethod void testPostPurchaseCampaignBatchWithPostPurchase()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        testOrders = new List<Order__c>();
        for(Integer i = 0 ; i<SIZE/2 ; ++i)
        {
            Order__c theOrder = TestUtils.createOrders(1 , CampaignRulesSetup.testProducts[0].Id , false)[0]; //Product Line of Business Formation
            theOrder.User_Order_Extension__c = firstUserOrderExtension.Id; //2 Weeks since Order status sent to Customer
            theOrder.Contact__c = testContacts[i].Id;
            testOrders.add(theOrder);   
        }
        for(Integer i = SIZE/2 ; i<SIZE ; ++i)
        {
            Order__c theOrder = TestUtils.createOrders(1 , CampaignRulesSetup.testProducts[1].Id , false)[0]; // Trademark Search
            theOrder.Contact__c = testContacts[i].Id;
            theOrder.User_Order_Extension__c = firstUserOrderExtension.Id; //2 Weeks since Order status sent to Customer
            testOrders.add(theOrder);   
        }
        insert testOrders;

        Test.startTest();
            PostPurchaseCampaignsBatch theBatch = new PostPurchaseCampaignsBatch(null , null);
            Database.executeBatch(theBatch , SIZE);
        Test.stopTest();

        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember];
        System.assertEquals(SIZE , campaignMembers.size() , '100 Campaign Members should have been created');

    }
       

   
    
    
}