@isTest
public class CampaignFutureHandlerTest 
{
    static List<Account> testAccounts;
    static List<Contact> testContacts;
    static List<Order__c> testOrders;
    static List<Order_Item__c> testOrderItems;
    
    final static String TEST_ACCOUNT = 'Test Account';
    final static String TEST_CONTACT = 'Test Contact';
    final static Integer SIZE = 200; 

    static List<CampaignMember> testCampaignMembers;
    static List<CampaignMember> campaignMembersToInsert;
    static List<CampaignMember> abandonerCampaignMembersToInsert;
    static List<CampaignMember> raOutboundCampaignMembersToInsert;
    static List<CampaignMember> businessLicenseCampaignMembersToInsert;
    static List<CampaignMember> tmSearchCampaignMembersToInsert;
    static List<CampaignMember> sixMonthBizCampaignMembersToInsert;

    static void setupData()
    {
        testContacts = new List<Contact>();
        testOrderItems = new List<Order_Item__c>();
        testAccounts = TestUtils.createAccounts(SIZE , TEST_ACCOUNT , false);
        insert testAccounts;
    Integer i = 0;
        for(Account theAccount : testAccounts)
        {
            Contact theContact = TestUtils.createContacts(1 , TEST_CONTACT , theAccount.Id , false)[0];
            theContact.LegalZoom_Contact_ID__c = theContact.LegalZoom_Contact_ID__c + i;
            testContacts.add(theContact);
            i++;
        }
        insert testContacts;

       
    }

    static void createTestOrders()
    {
        testOrders = new List<Order__c>();
        for(Contact theContact : testContacts)
        {
            Order__c theOrder = TestUtils.createOrders(1 , CampaignRulesSetup.testProducts[0].Id , false)[0];
            theOrder.Contact__c = theContact.Id;
            testOrders.add(theOrder);
        }
        insert testOrders;
    }
    /*These campaings are not being used.
    static void setupPostPurchaseCampaignMembers()
    {
        campaignMembersToInsert = new List<CampaignMember>();
        raOutboundCampaignMembersToInsert = new List<CampaignMember>();
        businessLicenseCampaignMembersToInsert = new List<CampaignMember>();
        tmSearchCampaignMembersToInsert = new List<CampaignMember>();
        sixMonthBizCampaignMembersToInsert = new List<CampaignMember>();

        for(Integer i = 0 ; i<SIZE/2 ; ++i)
        {
            CampaignMember theMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.raOutboundCampaign.Id , testContacts[i].Id , null , false)[0];
            raOutboundCampaignMembersToInsert.add(theMember);
            
        }
        
        for(Integer i = SIZE/2 ; i<125 ; ++i)
        {
            CampaignMember theMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.businessLicenseOutboundCampaign.Id , testContacts[i].Id , null , false)[0];
            businessLicenseCampaignMembersToInsert.add(theMember);
            
        }
        
        for(Integer i = 125 ; i<150 ; ++i)
        {
            CampaignMember theMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.tmSearchOutboundCampaign.Id , testContacts[i].Id , null , false)[0];
            tmSearchCampaignMembersToInsert.add(theMember);
        }

        for(Integer i = 150 ; i<SIZE ; ++i)
        {
            CampaignMember theMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.sixMonthBizCampaign.Id , testContacts[i].Id , null , false)[0];
            sixMonthBizCampaignMembersToInsert.add(theMember);
            
        }
        
        campaignMembersToInsert.addAll(raOutboundCampaignMembersToInsert);
        
        campaignMembersToInsert.addAll(businessLicenseCampaignMembersToInsert);
        campaignMembersToInsert.addAll(tmSearchCampaignMembersToInsert);
        campaignMembersToInsert.addAll(sixMonthBizCampaignMembersToInsert);
        

        insert campaignMembersToInsert;

    }
    
    static testMethod void testRemoveCampaignMemberForPostPurchase()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        createTestOrders();
        setupPostPurchaseCampaignMembers();
        List<Order_Item__c> orderItemsToInsert = new List<Order_Item__c>();

        for(Integer i = 0 ; i<SIZE/2 ; ++i)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , testOrders[i].Id , false)[0];
            theItem.Product__c = CampaignRulesSetup.testProducts[3].Id; //Register Agent Service added
            orderItemsToInsert.add(theItem);
        }
        
        for(Integer i = SIZE/2 ; i<125 ; ++i)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , testOrders[i].Id , false)[0];
            theItem.Product__c = CampaignRulesSetup.testProducts[4].Id; //Business License AddOn added
            orderItemsToInsert.add(theItem);
            
        }
        
        for(Integer i = 125 ; i<150 ; ++i)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , testOrders[i].Id , false)[0];
            theItem.Product__c = CampaignRulesSetup.testProducts[2].Id; // Trademark Gold added 
            orderItemsToInsert.add(theItem);
            
        }
        for(Integer i = 150 ; i<SIZE ; ++i)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , testOrders[i].Id , false)[0];
            theItem.Product__c = CampaignRulesSetup.testProducts[5].Id; //Bank Of America added
            orderItemsToInsert.add(theItem);
            
        }
        
        Test.startTest();
            insert orderItemsToInsert;
        Test.stopTest();
        List<CampaignMember> updatedCampaignMembers = [SELECT Id , Status FROM CampaignMember];
        System.assertEquals(200 , updatedCampaignMembers.size() , 'There should have been 200 Campaign members');
        for(CampaignMember theMember : updatedCampaignMembers)
        {
            System.assertEquals(CampaignConstants.ORDER_PLACED , theMember.Status , 'Status should have been Removed');
        }

    }
    */

    static void setupPrePurchaseCampaignMembers()
    {
        
        abandonerCampaignMembersToInsert = new List<CampaignMember>();
        for(Integer i = 0 ; i<SIZE ; ++i)
        {
            CampaignMember theMember = TestUtils.createCampaignMembers(1 , CampaignRulesSetup.abandonerCampaign.Id , testContacts[i].Id , null , false)[0];
            abandonerCampaignMembersToInsert.add(theMember);
            
        }
        insert abandonerCampaignMembersToInsert;
    }
    
    static testMethod void testRemoveCampaignMembersForPrePurchase()
    {
        CampaignRulesSetup.setupCampaignWithRules();
        setupData();
        setupPrePurchaseCampaignMembers();
        
        Test.startTest();
            createTestOrders();
        Test.stopTest();

        List<CampaignMember> updatedCampaignMembers = [SELECT Id , Status FROM CampaignMember];
        
        System.assertEquals(SIZE  , updatedCampaignMembers.size() , '200 Campaign Members should have been there');
        for(CampaignMember theMember : updatedCampaignMembers)
        {
            System.assertEquals(CampaignConstants.ORDER_PLACED , theMember.Status , 'Campaign Member Status should have been removed');
        }
    }   
        
}