@isTest
public class CampaignEngineTest  
{
    static List<Account> testAccounts;
    static List<Contact> testContacts;
    static List<Order__c> testOrders;
    static List<Order_Item__c> testOrderItems;
    static User_Order_Extension__c firstUserOrderExtension;
    static User_Order_Extension__c secondUserOrderExtension;
  
    final static String TEST_ACCOUNT = 'Test Account';
    final static String TEST_CONTACT = 'Test Contact';
    final static Integer SIZE = 200; 

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
    

        firstUserOrderExtension = new User_Order_Extension__c();
        firstUserOrderExtension.Processing_Status__c = CampaignRulesSetup.sentToCustomerProcessingStatus.Id;
        firstUserOrderExtension.Processing_Status_Date_Time__c = Date.today().addDays(-16);
        insert firstUserOrderExtension;

        secondUserOrderExtension = new User_Order_Extension__c();
        secondUserOrderExtension.Processing_Status__c = CampaignRulesSetup.sentToCustomerProcessingStatus.Id;
        secondUserOrderExtension.Processing_Status_Date_Time__c = Date.today().addDays(-190);
        insert secondUserOrderExtension;

    }

    
    static testMethod void testAssignCampaignForOrders()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        insert testContacts;
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

        List<CampaignMember> campaignMembers;
        Set<String> campaignNames = new Set<String>();
        campaignNames.add(CampaignConstants.BIZ_LICENSE_OUTBOUND_UPSELL);
        campaignNames.add(CampaignConstants.TM_SEARCH_OUTBOUND_UPSELL);
        
        Test.startTest();
            CampaignEngine theEngine = new CampaignEngine();
            campaignMembers = theEngine.assignCampaignsForOrders(testOrders , campaignNames);
        Test.stopTest();
        System.assertEquals(SIZE, campaignMembers.size() , SIZE+ ' Campaign Members should have been returned');

    }
    
  
    
    
    static testMethod void testAssignCampaignForLeads()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        List<Lead> newLeads = TestUtils.createLeads(SIZE ,  'Test LastName' , false);
        for(Integer i = 0; i <SIZE/2 ; ++i)
        {
            newLeads[i].Phone = '555555555'+String.ValueOf(i);
        }
        DuplicateChecker.NoDuplicateCheck = true;
        insert newLeads;

        Test.startTest();
            LeadService.processForCampaigns(newLeads);
        Test.stopTest();
        List<CampaignMember> campaignMembers = [SELECT id , Status FROM CampaignMember];
        System.assertEquals(SIZE/2 , campaignMembers.size() , SIZE/2+' Campaign Members should have been returned');

    }
    
    
    static testMethod void testAssignCampaignForContacts()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        
        for(Integer i = 0 ; i < SIZE/2 ; ++i)
        {
            testContacts[i].HomePhone = '5555555555';
        }
        insert testContacts;

        Test.startTest();
            ContactService.processForCampaignsEntry(testContacts);
        Test.stopTest();
        List<CampaignMember> campaignMembers = [SELECT Id , Status FROM CampaignMember];
        System.assertEquals(SIZE/2 , campaignMembers.size() , SIZE/2+' Campaign Members should have been returned');

    }
    
    

    
    
    static testMethod void testExitCampaignForContact()
    {
        
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        insert testContacts;
        List<CampaignMember> campaignMembers = new List<CampaignMember>();
        for(Integer i = 0; i <SIZE ; ++i)
        {
            CampaignMember theMember = new CampaignMember();
            theMember.ContactId = testContacts[i].Id;
            theMember.CampaignId = CampaignRulesSetup.abandonerCampaign.Id;
            campaignMembers.add(theMember);
        }
        insert campaignMembers;
        
        testOrders = new List<Order__c>();
        for(Integer i = 0 ; i<SIZE/2 ; ++i)
        {
            Order__c theOrder = TestUtils.createOrders(1 , CampaignRulesSetup.testProducts[0].Id , false)[0]; //Product Line of Business Formation
            theOrder.Contact__c = testContacts[i].Id;
            testOrders.add(theOrder);   
        }
                
        Test.startTest();
            insert testOrders;
        Test.stopTest();
        List<CampaignMember> returnedCampaignmembers = [SELECT Id , Status FROM CampaignMember WHERE Status = :CampaignConstants.ORDER_PLACED];
        System.assertEquals(SIZE/2 , returnedCampaignMembers.size() , SIZE/2 + ' Campaign Members should have been returned');
        
    }
    
    
    static testMethod void testAssignCampaignForContactsWithExistingContactInCampaign()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        for(Contact theContact : testContacts)
        {
            theContact.HomePhone = '5555555555';
        }
        insert testContacts;
    
        List<Contact> sameContactsForCampaigns = new List<Contact>();
        for(Integer  i = 0 ; i<SIZE/2; ++i)
        {
            testContacts[i].HomePhone = '5555555555';
            sameContactsForCampaigns.add(testContacts[i]);
        }
        Set<String> campaignNames = new Set<String>();
        campaignNames.add(CampaignConstants.ABANDONER_DRIP);
        
        List<CampaignMember> returnedCampaignMembers;
        Test.startTest();
            CampaignEngine theEngine = new CampaignEngine();
            returnedCampaignMembers = theEngine.assignCampaignsForContact(sameContactsForCampaigns , campaignNames);
        Test.stopTest();
        System.assertEquals(SIZE/2 , returnedCampaignMembers.size() , SIZE/2 + ' Campaign Members should have been returned');

    }
    
    
    static testMethod void testAssignCampaignForLeadsWithExistingLeadInCampaign()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        List<Lead> newLeads = TestUtils.createLeads(SIZE ,  'Test LastName' , false);
        integer count = 0;
        for(Lead theLead : newLeads)
        {
            theLead.Phone = '555555555'+String.ValueOf(count);
            count++;
        }
        DuplicateChecker.NoDuplicateCheck = true;
        insert newLeads;

        LeadService.processForCampaigns(newLeads);


        List<CampaignMember> campaignMembers = new List<CampaignMember>();
        Set<String> campaignNames = new Set<String>();
        campaignNames.add(CampaignConstants.ABANDONER_DRIP);

        List<Lead> sameLeadsForCampaigns = new List<Lead>();
        for(Integer  i = 0 ; i<SIZE/2; ++i)
        {
            sameLeadsForCampaigns.add(newLeads[i]);
        }


        List<CampaignMember> returnedCampaignMembers;
        Test.startTest();
            CampaignEngine theEngine = new CampaignEngine();
            returnedCampaignMembers = theEngine.assignCampaignsForLead(sameLeadsForCampaigns , campaignNames);
        Test.stopTest();
        System.assertEquals(SIZE/2 , returnedCampaignMembers.size() , SIZE/2 + ' Campaign Members should have been returned');

    }
    
    static testMethod void testEvaluateLead()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        Lead testLead = TestUtils.createLeads(1 , 'Test Lead', false)[0];
        testLead.Phone = '5555555555';
        insert testLead;

        Lead queriedLead = [SELECT Id , Name , Phone FROM Lead limit 1];
        List<Campaign_Rule__c> theRulesForCampaign = [SELECT Id , Rule_Id__c, Field_To_Evaluate__c , Field_Value__c , Base_Product_Line__c , Base_Process__c,
                                      Child_Product_Name__c , RecordType.DeveloperName  , Has_Purchased__c , Base_Product_Name__c , Number_of_Days__c , 
                                      Status__c , Object__c , Across_Orders__c FROM Campaign_Rule__c  WHERE Entry_Exit__c = :CampaignConstants.THE_ENTRY AND Campaign__c = :CampaignRulesSetup.abandonerCampaign.Id 
                                      ORDER BY Rule_Id__c ASC];
        String postfixExpression = '12&34&|';

        Boolean theResult;
        Test.startTest();
            CampaignEngine theEngine = new CampaignEngine();
            theResult = theEngine.evaluateLead(queriedLead,CampaignRulesSetup.abandonerCampaign, theRulesForCampaign, postfixExpression, null , null);
        Test.stopTest();

        System.assert(theResult , 'Result must have been true');                             
    }
    
    
}