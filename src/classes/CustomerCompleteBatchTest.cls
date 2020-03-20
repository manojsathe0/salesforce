@isTest
public class CustomerCompleteBatchTest 
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

	static testMethod void testPostPurchaseCampaignBatchWithCustomerComplete()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        testOrders = new List<Order__c>();
        for(Integer i = 0 ; i<SIZE ; ++i)
        {
            Order__c theOrder = TestUtils.createOrders(1 , CampaignRulesSetup.testProducts[0].Id , false)[0]; // Business Formation Product Line
            theOrder.Contact__c = testContacts[i].Id;
            theOrder.User_Order_Extension__c = secondUserOrderExtension.Id; //6 months since order status sent to customer
            testOrders.add(theOrder);   
        }
       
        insert testOrders;

        List<String> campaignTypes = new List<String>{CampaignConstants.CUSTOMER_COMPLETE};
        Set<String> campaignNames = new Set<String>();
        for(Campaign theCampaign : [SELECT Id , Name FROM Campaign  WHERE Category__c IN :campaignTypes])
        {
            campaignNames.add(theCampaign.Name);
        }
        
        String theQuery = 'Select Id FROM Order__c';
               
        Test.startTest();
            CustomerCompleteBatch theBatch = new CustomerCompleteBatch(null , null);
            Database.executeBatch(theBatch , SIZE);
        Test.stopTest();

        List<CampaignMember> campaignMembers = [SELECT Id FROM CampaignMember];
        System.assertEquals(SIZE , campaignMembers.size() , '100 Campaign Members should have been created');

    }	
}