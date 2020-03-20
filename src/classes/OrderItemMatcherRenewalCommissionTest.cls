@isTest
public class OrderItemMatcherRenewalCommissionTest 
{
    static List<Order__c> parentOrders;
    static List<Order__c> renewalOrders;
    
    static List<Task> tasksToCreate;
    
    static List<Order_Matching_Activity__c> testOrderMatchingActivities;
   
    
    static User testUser;
    static Product2 testProduct;
    final static String PRODUCT_LINE = 'Test ProductLine';
    static Id relationshipTypeId;
    static Id renewalRelationshipTypeId;
    static Id packageRelationshipTypeId;
    
    static Product2 renewalProduct;
    static Product2 registerAgentProduct;
    static Product2 anyRenewalOrderProduct;
    
    static final String REGISTERED_AGENT = 'Registered Agent';
    static final String THEPACKAGE = 'Package';
    static final String CROSS_SELL = 'Cross-Sell';
    
    
    static List<RA_Renewal_Product_Name__c> RARenewalProducts;
    static Relationship_Type__c packageRelationshipType;
    static Relationship_Type__c crossSellRelationshipType;
    static List<Contact> testContacts;
    final static String PRIMARY_CONTACT = 'Primary Contact';
    static  Relationship_Type__c renewalRelationshipType;
    
    static
    {
        RARenewalProducts = new List<RA_Renewal_Product_Name__c>();
        RA_Renewal_Product_Name__c theRARenewalProduct = new RA_Renewal_Product_Name__c();
        theRARenewalProduct.Name = '1';
        theRARenewalProduct.Product_Name__c = 'RA Renewal - 1 year';
        RARenewalProducts.add(theRARenewalProduct);
        
        insert RARenewalProducts;
        
        tasksToCreate= new List<Task>();
        
        testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
        testProduct.Name = '1';
        testProduct.LZ_Product_ID__c = 1;
        Product_Line__c testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;
        
        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        
        renewalProduct = TestUtils.createProducts(1 , 'Renewal Product', false)[0];
        renewalProduct.Name = 'RA Renewal - 1 year';
        renewalProduct.LZ_Product_ID__c = 2;
        
        renewalRelationshipType = TestUtils.createRelationshipTypesTypes(1 , 'Renewal', false)[0];
        renewalRelationshipType.Name = 'Renewal';
        
        insert renewalRelationshipType;
        
        renewalProduct.Product_Line__c = testProductLine.Id;
        renewalProduct.Relationship_Type__c = renewalRelationshipType.Id;
        
        
        registerAgentProduct = TestUtils.createProducts(1 , REGISTERED_AGENT, false)[0];
        registerAgentProduct.Name = REGISTERED_AGENT;
        registerAgentProduct.LZ_Product_ID__c = 3;
        
        packageRelationshipType = TestUtils.createRelationshipTypesTypes(1 , THEPACKAGE, false)[0];
        packageRelationshipType.Name = THEPACKAGE;
        
        insert packageRelationshipType;
        
        registerAgentProduct.Product_Line__c = testProductLine.Id;
        registerAgentProduct.Relationship_Type__c = packageRelationshipType.Id;
        
        anyRenewalOrderProduct = TestUtils.createProducts(1 , 'Renewal Product', false)[0];
        anyRenewalOrderProduct.Name = 'Full Service Compliance Package Renewal';
        anyRenewalOrderProduct.LZ_Product_ID__c = 4;
        anyRenewalOrderProduct.Product_Line__c = testProductLine.Id;
        anyRenewalOrderProduct.Relationship_Type__c = renewalRelationshipType.Id;

        
        insert new List<Product2>{registerAgentProduct , renewalProduct , testProduct , anyRenewalOrderProduct};
       
    }
    
        
    
    static testMethod void testRARenewalOrdersForCrossSellOrders()
    {
        
        OrderService.hasOrderMatchingTriggerRun = true;
        CampaignLogic.hasCampaignLogicRun = true;

        crossSellRelationshipType = TestUtils.createRelationshipTypesTypes(1 , CROSS_SELL, false)[0];
        crossSellRelationshipType.Name = CROSS_SELL;
        insert crossSellRelationshipType;
        
        registerAgentProduct.Relationship_Type__c = crossSellRelationshipType.Id;
        
        Account anotherAccount = TestUtils.createAccounts(1 , 'Test Account', false)[0];
        anotherAccount.Name = 'Test0@test.com';
        insert anotherAccount;

        testContacts = new List<Contact>();
        for(Integer i = 0; i <50 ; ++i)
        {
            Contact theContact = TestUtils.createContacts(1 , 'Test Contact', anotherAccount.Id, false)[0];
            theContact.HomePhone = '77777777'+i;
            theContact.Contact_Type__c = PRIMARY_CONTACT;
            testContacts.add(theContact);
            
        }
        insert testContacts;

        testUser = TestUtils.createUser( 'Austin', TestUtils.STANDARD_PROFILE_ID , false);
        testUser.FirstName = 'Steve';           
        List<Order_Matching_Activity__c> oMAs = new List<Order_Matching_Activity__c>();
        System.runAs(testUser)
        {
            
            for(Contact theContact : testContacts)
            {
                Task theTask = TestUtils.createTasks(1 , null , false)[0];
                theTask.Commission_Eligible__c = true;
                theTask.WhoId = theContact.Id;
                tasksToCreate.add(theTask);
            }
            insert tasksToCreate;
        }

        
        parentOrders = TestUtils.createOrders(50 , testProduct.Id ,  false);
        for(Integer i =0 ; i<50; ++i) 
        {
            parentOrders[i].OrderID__c = String.valueOf(i);
            parentOrders[i].Name = String.valueOf(i);
            parentOrders[i].User_Order_ID__c = String.valueOf(i);
            parentOrders[i].Order_Date_Time_Created__c = DateTime.now().addHours(5);
            parentOrders[i].Contact__c = testContacts[i].Id;                
        }
        insert parentOrders;
        
        List<Order_Item__c> orderItemsToCreate = new List<Order_Item__c>();
        Integer j = 0;
        for(Order__c theOrder : parentOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            theItem.Product__c = registerAgentProduct.Id;
            theItem.Relationship_Type__c = crossSellRelationshipType.Id;
            theItem.Extended_Price__c = 0.00;
            theItem.Subscription_Status__c = 'Active';
            theItem.LZ_Order_Item_ID__c = j+'';
            ++j;
            orderItemsToCreate.add(theItem);
        }
        
        insert orderItemsToCreate;
        
        List<Order360__c> order360Created = [SELECT Id ,Agent_Name__c FROM Order360__c WHERE Order_Item__c IN :orderItemsToCreate];
        System.assertEquals(50, order360Created.size() , '50 Order360 records should have been created.Each for orderItem');

        for(Order360__c the360 : order360Created)
        {
            System.assertEquals('SteveAustin' , the360.Agent_Name__c , 'Austin should have got credit for it.');
        }

        User anotherUser = TestUtils.createUser( 'Bonjovi', TestUtils.STANDARD_PROFILE_ID , false);
        anotherUser.FirstName = 'John';

        tasksToCreate.clear();
        System.runAs(anotherUser)
        {
            
            for(Contact theContact : testContacts)
            {
                Task theTask = TestUtils.createTasks(1 , null , false)[0];
                theTask.Commission_Eligible__c = true;
                theTask.WhoId = theContact.Id;
                tasksToCreate.add(theTask);
            }
            insert tasksToCreate;
        }


        
        renewalOrders = TestUtils.createOrders(50 , renewalProduct.Id ,  false);
        for(Integer i =0 ; i<50 ;++i)
        {
            renewalOrders[i].OrderID__c = String.valueOf(i)+'renewal';
            renewalOrders[i].Name = String.valueOf(i)+'renewal';
            renewalOrders[i].Base_Product__c =  renewalProduct.Id;
            renewalOrders[i].LZ_Parent_Order__c = String.valueOf(i);
            //renewalOrders[i].Order_Created_By__c = 'abc';
            renewalOrders[i].Order_Date_Time_Created__c = DateTime.now().addHours(8);
            renewalOrders[i].Account__c = anotherAccount.Id;
            renewalOrders[i].Contact_Email__c = anotherAccount.Name;
            renewalOrders[i].Contact__c = testContacts[i].Id;
            
        }
        insert renewalOrders;

        j = 0; 
        Integer k=50;
        List<Order_Item__c> renewalOrderItemsToCreate = new List<Order_Item__c>();
        for(Order__c theOrder : renewalOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            theItem.Product__c = renewalProduct.Id;
            theItem.Relationship_Type__c = renewalRelationshipType.Id;
            theItem.LZ_Order_Item_ID__c = k+'';
            theItem.LZ_Parent_Order_Item_Id__c = j+'';
            ++j;
            ++k;
            renewalOrderItemsToCreate.add(theItem);
        }
       
       
        Test.startTest();
            insert renewalOrderItemsToCreate;
        Test.stopTest();
        List<Order360__c> order360CreatedForRenewal = [SELECT Id , Agent_Name__c , Agent__c FROM Order360__c WHERE Order_Item__c IN :renewalOrderItemsToCreate];
        System.assertEquals(50, order360CreatedForRenewal.size() , '50 Order360 records should have been created.Each for orderItem');
        for(Order360__c the360 : order360CreatedForRenewal)
        {
            System.assertEquals('SteveAustin' , the360.Agent_Name__c , 'SteveAustin should have got credit for it.He is original Agent.');
            System.assertEquals('Agent 1' , the360.Agent__c , 'Agent 1 should have been populated');
        }
                
    }
    
    static testMethod void testRARenewalOrdersForStandAloneOrders()
    {
        OrderService.hasOrderMatchingTriggerRun = true;
        CampaignLogic.hasCampaignLogicRun = true;             
        Account anotherAccount = TestUtils.createAccounts(1 , 'Test Account', false)[0];
        anotherAccount.Name = 'Test0@test.com';
        insert anotherAccount;

        testContacts = new List<Contact>();
        for(Integer i = 0; i <50 ; ++i)
        {
            Contact theContact = TestUtils.createContacts(1 , 'Test Contact', anotherAccount.Id, false)[0];
            theContact.HomePhone = '77777777'+i;
            theContact.Contact_Type__c = PRIMARY_CONTACT;
            testContacts.add(theContact);
            
        }
        insert testContacts;

        testUser = TestUtils.createUser( 'Austin', TestUtils.STANDARD_PROFILE_ID , false);
        testUser.FirstName = 'Steve';           
        List<Order_Matching_Activity__c> oMAs = new List<Order_Matching_Activity__c>();
        System.runAs(testUser)
        {
            
            for(Contact theContact : testContacts)
            {
                Task theTask = TestUtils.createTasks(1 , null , false)[0];
                theTask.Commission_Eligible__c = true;
                theTask.WhoId = theContact.Id;
                tasksToCreate.add(theTask);
            }
            insert tasksToCreate;
        }

        
        parentOrders = TestUtils.createOrders(50 , testProduct.Id ,  false);
        for(Integer i =0 ; i<50; ++i) 
        {
            parentOrders[i].OrderID__c = String.valueOf(i);
            parentOrders[i].Name = String.valueOf(i);
            parentOrders[i].User_Order_ID__c = String.valueOf(i);
            parentOrders[i].Order_Date_Time_Created__c = DateTime.now().addHours(5);
            parentOrders[i].Contact__c = testContacts[i].Id;                
        }
        insert parentOrders;
        
        Integer j = 0;
        List<Order_Item__c> orderItemsToCreate = new List<Order_Item__c>();
        for(Order__c theOrder : parentOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            theItem.Product__c = testProduct.Id; //Any Subscription Product
            theItem.Relationship_Type__c = packageRelationshipType.Id;
            theItem.Extended_Price__c = 149.99;
            theItem.Subscription_Status__c = 'Active';
            theItem.LZ_Order_Item_ID__c = j+'';
            ++j;
            orderItemsToCreate.add(theItem);
        }
        Test.startTest();        
            insert orderItemsToCreate;
        Test.stopTest();
        
        List<Order360__c> order360Created = [SELECT Id ,Agent_Name__c FROM Order360__c WHERE Order_Item__c IN :orderItemsToCreate];
        System.assertEquals(50, order360Created.size() , '50 Order360 records should have been created.Each for orderItem');

        for(Order360__c the360 : order360Created)
        {
            System.assertEquals('SteveAustin' , the360.Agent_Name__c , 'Austin should have got credit for it.');
        }

                
    }
    
    

    static testMethod void testAnyRenewalOrdersForCrossSellOrders() //0$ on initial item.Not Charged up front
    {
       
        OrderService.hasOrderMatchingTriggerRun = true;
        CampaignLogic.hasCampaignLogicRun = true;  
        crossSellRelationshipType = TestUtils.createRelationshipTypesTypes(1 , CROSS_SELL, false)[0];
        crossSellRelationshipType.Name = CROSS_SELL;
        insert crossSellRelationshipType;
        
        registerAgentProduct.Relationship_Type__c = crossSellRelationshipType.Id;
        update registerAgentProduct;

        Account anotherAccount = TestUtils.createAccounts(1 , 'Test Account', false)[0];
        anotherAccount.Name = 'Test0@test.com';
        insert anotherAccount;

        testContacts = new List<Contact>();
        Integer i;
        for(i = 0; i <50 ; ++i)
        {
            Contact theContact = TestUtils.createContacts(1 , 'Test Contact', anotherAccount.Id, false)[0];
            theContact.HomePhone = '77777777'+i;
            theContact.Contact_Type__c = PRIMARY_CONTACT;
            testContacts.add(theContact);
            
        }
        insert testContacts;

        testUser = TestUtils.createUser( 'Austin', TestUtils.STANDARD_PROFILE_ID , false);
        testUser.FirstName = 'Steve';           
        List<Order_Matching_Activity__c> oMAs = new List<Order_Matching_Activity__c>();
        System.runAs(testUser)
        {
            
            for(Contact theContact : testContacts)
            {
                Task theTask = TestUtils.createTasks(1 , null , false)[0];
                theTask.Commission_Eligible__c = true;
                theTask.WhoId = theContact.Id;
                tasksToCreate.add(theTask);
            }
            insert tasksToCreate;
        }

        
        parentOrders = TestUtils.createOrders(50 , testProduct.Id ,  false);
        for(i =0 ; i<50; ++i) 
        {
            parentOrders[i].OrderID__c = String.valueOf(i);
            parentOrders[i].Name = String.valueOf(i);
            parentOrders[i].User_Order_ID__c = String.valueOf(i);
            parentOrders[i].Order_Date_Time_Created__c = DateTime.now().addHours(5);
            parentOrders[i].Contact__c = testContacts[i].Id;

        }
        insert parentOrders;
        
        List<Order_Item__c> orderItemsToCreate = new List<Order_Item__c>();
        i = 0; 
        for(Order__c theOrder : parentOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            theItem.Product__c = registerAgentProduct.Id;
            theItem.Relationship_Type__c = crossSellRelationshipType.Id;
            theItem.Extended_Price__c = 0.00;
            theItem.Subscription_Status__c = 'Active';
            theItem.LZ_Order_Item_ID__c = i+'';
            ++i;
            orderItemsToCreate.add(theItem);
        }
        
        insert orderItemsToCreate;
        
        List<Order360__c> order360Created = [SELECT Id ,Agent_Name__c FROM Order360__c WHERE Order_Item__c IN :orderItemsToCreate];
        System.assertEquals(50, order360Created.size() , '50 Order360 records should have been created.Each for orderItem');

        for(Order360__c the360 : order360Created)
        {
            System.assertEquals('SteveAustin' , the360.Agent_Name__c , 'Austin should have got credit for it.');
        }
        

        User anotherUser = TestUtils.createUser( 'Bonjovi', TestUtils.STANDARD_PROFILE_ID , false);
        anotherUser.FirstName = 'John';

        tasksToCreate.clear();
        System.runAs(anotherUser)
        {
            
            for(Contact theContact : testContacts)
            {
                Task theTask = TestUtils.createTasks(1 , null , false)[0];
                theTask.Commission_Eligible__c = true;
                theTask.WhoId = theContact.Id;
                tasksToCreate.add(theTask);
            }
            insert tasksToCreate;
        }


        
        renewalOrders = TestUtils.createOrders(50 , anyRenewalOrderProduct.Id ,  false);
        for(i =0 ; i<50 ;++i)
        {
            renewalOrders[i].OrderID__c = String.valueOf(i)+'renewal';
            renewalOrders[i].Name = String.valueOf(i)+'renewal';
            renewalOrders[i].Base_Product__c =  anyRenewalOrderProduct.Id;
            renewalOrders[i].LZ_Parent_Order__c = String.valueOf(i);
            //renewalOrders[i].Order_Created_By__c = 'abc';
            renewalOrders[i].Order_Date_Time_Created__c = DateTime.now().addHours(8);
            renewalOrders[i].Account__c = anotherAccount.Id;
            renewalOrders[i].Contact_Email__c = anotherAccount.Name;
            renewalOrders[i].Contact__c = testContacts[i].Id;
            
        }
        insert renewalOrders;

        List<Order_Item__c> renewalOrderItemsToCreate = new List<Order_Item__c>();
        i = 0 ;
        Integer j = 50;
        for(Order__c theOrder : renewalOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            theItem.Product__c = anyRenewalOrderProduct.Id;
            theItem.Relationship_Type__c = renewalRelationshipType.Id;
            theItem.LZ_Order_Item_ID__c = j+'';
            theItem.LZ_Parent_Order_Item_Id__c = i+'';
            ++j;
            ++i;
            renewalOrderItemsToCreate.add(theItem);
        }
       
       
        Test.startTest();
            insert renewalOrderItemsToCreate;
        Test.stopTest();
        List<Order360__c> order360CreatedForRenewal = [SELECT Id , Agent_Name__c , Agent__c FROM Order360__c WHERE Order_Item__c IN :renewalOrderItemsToCreate];
        System.assertEquals(50, order360CreatedForRenewal.size() , '50 Order360 records should have been created.Each for orderItem');
        for(Order360__c the360 : order360CreatedForRenewal)
        {
            System.assertEquals('SteveAustin' , the360.Agent_Name__c , 'SteveAustin should have got credit for it.He is original Agent.');
            System.assertEquals('Agent 1' , the360.Agent__c , 'Agent 1 should have been populated');
        }
                
    }
    
}