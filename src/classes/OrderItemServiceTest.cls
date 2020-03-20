@isTest
public class OrderItemServiceTest 
{
    static List<Order__c> testOrders;
    static List<Order_Item__c> testOrderItems;
    final Static Integer SIZE = 10;
    static Product2 testProduct;
    final static String PRODUCT_LINE = 'Intellectual Property';
    static Id relationshipTypeId;
    static Product_Line__c testProductLine;
    static String ENTITY_NAME = 'My Entity';
    static
    {
        testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
        testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;
        
        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        
        insert testProduct; 
    }
    
    static void setupData()
    {
        testOrders = TestUtils.createOrders(SIZE , testProduct.Id , true);  
    }
    
    static testMethod void testPopulateOrderItemLookUp()
    {
        setupData();
        List<Order_Item__c> allOrderItems = new List<Order_Item__c>();
        Map<String,Id> lzOrderItemIdToSFDCId = new Map<String,Id>();
        
        for(Order__c theOrder : testOrders)
        {
            allOrderItems.addAll(TestUtils.createOrderItems(2 , theOrder.Id, false));
        }
        Integer lzOrderItemId = 0;
        for(Order_Item__c theItem : allOrderItems)
        {
            theItem.LZ_Order_Item_ID__c = String.valueOf(lzOrderItemId);
            ++lzOrderItemId;
        }
        insert allOrderItems;
        List<Order_Item__c> insertedOrderItems = [SELECT Id , LZ_Order_Item_ID__c FROM Order_Item__c WHERE Id IN :allOrderItems];
        for(Order_Item__c theItem : insertedOrderItems)
        {
            lzOrderItemIdToSFDCId.put(theItem.LZ_Order_Item_ID__c , theItem.Id);
        }
        
        List<Order__c> newOrders = TestUtils.createOrders(SIZE , testProduct.Id , true);
        List<Order_Item__c> newOrderItems = new List<Order_Item__c>();
        for(Order__c theOrder : newOrders)
        {
            newOrderItems.addAll(TestUtils.createOrderItems(2 , theOrder.Id, false));
        }
        lzOrderItemId = 0;
        for(Order_Item__c theItem : newOrderItems)
        {
            theItem.LZ_Parent_Order_Item_Id__c =  String.valueOf(lzOrderItemId);
            ++lzOrderItemId;
        }
        Test.startTest();
            insert newOrderItems;
        Test.stopTest();
        
        List<Order_Item__c> updatedOrderItems = [SELECT Id , LZ_Parent_Order_Item_Id__c , Parent__c FROM Order_Item__c WHERE Id IN :newOrderItems];
        System.assertEquals(20 , updatedOrderItems.size() , '20 orders items should have been returned');
        for(Order_Item__c theItem : updatedOrderItems)
        {
            System.assertEquals(lzOrderItemIdToSFDCId.get(theItem.LZ_Parent_Order_Item_Id__c) , theItem.Parent__c , 'Right Order item look up should have been populated');
        }
    }
    
    
    
    
    static testmethod void testAssociateOrderMatchingWithOrderItems()
    {
        //create 5 orders
        testOrders = TestUtils.createOrders(5, testProduct.Id, false);
        for(Integer i = 0 ; i < 5; ++i)
        {
            testOrders[i].OrderID__c = i+'';        
        }
        insert testOrders;
        
        User firstAgent = TestUtils.createUser( 'Austin', TestUtils.STANDARD_PROFILE_ID , true);
        User secondAgent = TestUtils.createUser( 'Johnson', TestUtils.STANDARD_PROFILE_ID , true);
        List<Order_Matching_Activity__c> orderMatchingActivities = new List<Order_Matching_Activity__c>();
        Map<Id,Set<Id>> orderIdsToOMAIds = new Map<Id,Set<Id>>();
        for(Order__c theOrder : testOrders)
        {
            theOrder.Commission_Eligible_Agent_1__c = firstAgent.Id;
            theOrder.Commission_Eligible_Agent_2__c = secondAgent.Id;
            theOrder.Agent_1_Activity__c = DateTime.now().addHours(-5);
            theOrder.Agent_2_Activity__c = DateTime.now().addHours(-6);
            theOrder.Order_Date_Time_Created__c = DateTime.now();
            Order_Matching_Activity__c firstOMA = new Order_Matching_Activity__c(Order__c = theOrder.Id);
            orderMatchingActivities.add(firstOMA);
            Order_Matching_Activity__c secondOMA = new Order_Matching_Activity__c(Order__c = theOrder.Id);
            orderMatchingActivities.add(secondOMA);
            
        }
        insert orderMatchingActivities;
        
        for(Order_Matching_Activity__c theOMA : orderMatchingActivities)
        {
            if(!orderIdsToOMAIds.containsKey(theOMA.Order__c))
                orderIdsToOMAIds.put(theOMA.Order__c , new Set<Id>());
            orderIdsToOMAIds.get(theOMA.Order__c).add(theOMA.Id);
        }
        List<Order_Item__c> orderItemsToInsert = new List<Order_Item__c>();
        for(Order__c theOrder : testOrders)
        {
            for(Integer i = 0 ;i<5 ;++i)
            {
                Order_Item__c orderItem = new Order_Item__c();
                orderItem.Order__c = theOrder.Id;
                orderItem.LZ_Order_Item_ID__c = theOrder.OrderID__c+'-'+i;
                orderItemsToInsert.add(orderItem);
            }
        }
        
        Test.startTest();
            insert orderItemsToInsert;
        Test.stopTest();
        
        
        List<Order360__c> order360Created = [SELECT Id ,Order_Item__c , Order__c, Order_Matching_Activity__c FROM Order360__c WHERE Order_Item__c IN :orderItemsToInsert];
        System.assertEquals(50 , order360Created.size() , '50 records should have been created.');
        
        
        Map<Id,Set<Id>> orderItemIdToActualSetOfOMAs = new Map<Id,Set<Id>>();
        Map<Id,Id> orderItemToOrderId = new Map<Id,Id>();
        for(Order360__c theOrder360 : order360Created)
        {
            if(!orderItemIdToActualSetOfOMAs.containsKey(theOrder360.Order_Item__c))
                orderItemIdToActualSetOfOMAs.put(theOrder360.Order_Item__c , new Set<Id>());
            orderItemIdToActualSetOfOMAs.get(theOrder360.Order_Item__c).add(theOrder360.Order_Matching_Activity__c);
            orderItemToOrderId.put(theOrder360.Order_Item__c , theOrder360.Order__c);
        }
        System.assertEquals(25 , orderItemIdToActualSetOfOMAs.size() , '25 order items should have been returned');
        for(Id orderItemId : orderItemIdToActualSetOfOMAs.keySet())
        {
            Set<Id> actualOMAIds = orderItemIdToActualSetOfOMAs.get(orderItemId);
            System.assertEquals(2, orderIdsToOMAIds.get(orderItemToOrderId.get(orderItemId)).size() , '2 OMAs should have been there');
            System.assert(actualOMAIds.containsAll(orderIdsToOMAIds.get(orderItemToOrderId.get(orderItemId))) , 'Right OMA Ids should have been there');
        }
    }
    
    static testmethod void testOrderItemAndOrder360Deletion()
    {
        final String DUMMY_ORDER_NAME = 'DummyOrderx';
        Dummy_Order_For_OrderItem__c dummyOrderName = new Dummy_Order_For_OrderItem__c();
        dummyOrderName.Name = DUMMY_ORDER_NAME;
        
        insert dummyOrderName;
        
        Order__c dummyOrder = new Order__c(Name = DUMMY_ORDER_NAME);
        insert dummyOrder;
        
        //create 5 orders
        testOrders = TestUtils.createOrders(5, testProduct.Id, false);
        for(Integer i = 0 ; i <5; ++i)
        {
            testOrders[i].OrderID__c = i+'';        
        }
        insert testOrders;
        
        User firstAgent = TestUtils.createUser( 'Austin', TestUtils.STANDARD_PROFILE_ID , true);
        User secondAgent = TestUtils.createUser( 'Johnson', TestUtils.STANDARD_PROFILE_ID , true);
        List<Order_Matching_Activity__c> orderMatchingActivities = new List<Order_Matching_Activity__c>();
        Map<Id,Set<Id>> orderIdsToOMAIds = new Map<Id,Set<Id>>();
        for(Order__c theOrder : testOrders)
        {
            theOrder.Commission_Eligible_Agent_1__c = firstAgent.Id;
            theOrder.Commission_Eligible_Agent_2__c = secondAgent.Id;
            theOrder.Agent_1_Activity__c = DateTime.now().addHours(-5);
            theOrder.Agent_2_Activity__c = DateTime.now().addHours(-6);
            theOrder.Order_Date_Time_Created__c = DateTime.now();
            Order_Matching_Activity__c firstOMA = new Order_Matching_Activity__c(Order__c = theOrder.Id);
            orderMatchingActivities.add(firstOMA);
            Order_Matching_Activity__c secondOMA = new Order_Matching_Activity__c(Order__c = theOrder.Id);
            orderMatchingActivities.add(secondOMA);
            
        }
        insert orderMatchingActivities;
        
        for(Order_Matching_Activity__c theOMA : orderMatchingActivities)
        {
            if(!orderIdsToOMAIds.containsKey(theOMA.Order__c))
                orderIdsToOMAIds.put(theOMA.Order__c , new Set<Id>());
            orderIdsToOMAIds.get(theOMA.Order__c).add(theOMA.Id);
        }
        List<Order_Item__c> orderItemsToInsert = new List<Order_Item__c>();
        for(Order__c theOrder : testOrders)
        {
            for(Integer i = 0 ;i<10 ;++i)
            {
                Order_Item__c orderItem = new Order_Item__c();
                orderItem.Order__c = theOrder.Id;
                orderItem.LZ_Order_Item_ID__c = theOrder.OrderID__c+'-'+i;
                orderItemsToInsert.add(orderItem);
            }
        }
        
        insert orderItemsToInsert;
        
        for(Order_Item__c theItem : orderItemsToInsert)
        {
            theItem.Order__c = dummyOrder.Id;
        }
        Test.startTest();
            update orderItemsToInsert;
        Test.stopTest();
        
        List<Order360__c> order360Deleted= [SELECT Id FROM Order360__c WHERE Order_Item__c IN :orderItemsToInsert];
        System.assertEquals(0 , order360Deleted.size() , 'All Order360 should have been deleted.');
        
        List<Order_Item__c> orderItemsDeleted= [SELECT Id FROM Order_Item__c WHERE Id IN :orderItemsToInsert];
        System.assertEquals(0 , orderItemsDeleted.size() , 'All Order Item should have been deleted.');
        
    }
    

    
    static testMethod void testUserOrderExtensionLookUpPopulatedOnOrderItemAndOrder_OnInsert()
    {
        List<User_Order_Extension__c> userOrderExtensionToCreateForPackage = new List<User_Order_Extension__c>();
        Map<String,Id> expectedOrderItemNumberToUserExtensionLookUpForPackage = new Map<String,Id>();
        List<User_Order_Extension__c> userOrderExtensionToCreateForSubscriptionUsage = new List<User_Order_Extension__c>();
        Map<String,Id> expectedOrderItemNumberToUserExtensionLookUpForSubscriptionUsage = new Map<String,Id>();
        
        for(Integer i = 0 ; i<100 ;++i)
        {
            userOrderExtensionToCreateForPackage.add(new User_Order_Extension__c(LZ_Order_Item_ID__c = i+'' , Entity_Name__c = ENTITY_NAME));
        }
        for(Integer i = 100 ; i<200 ;++i)
        {
            userOrderExtensionToCreateForSubscriptionUsage.add(new User_Order_Extension__c(LZ_Order_Item_ID__c = i+'' , Entity_Name__c = ENTITY_NAME));
        }
        insert userOrderExtensionToCreateForPackage;
        insert userOrderExtensionToCreateForSubscriptionUsage;
        
        for(User_Order_Extension__c theExtension : userOrderExtensionToCreateForPackage)
        {
            expectedOrderItemNumberToUserExtensionLookUpForPackage.put(theExtension.LZ_Order_Item_ID__c , theExtension.Id);
        }
        
        for(User_Order_Extension__c theExtension : userOrderExtensionToCreateForSubscriptionUsage)
        {
            expectedOrderItemNumberToUserExtensionLookUpForSubscriptionUsage.put(theExtension.LZ_Order_Item_ID__c , theExtension.Id);
        }
        
        List<Order__c> orders = TestUtils.createOrders(200 , null , true);
        
        List<Order_Item__c> orderItemsToCreateForPackage = new List<Order_Item__c>();
        List<Order_Item__c> orderItemsToCreateForSubscriptionUsage = new List<Order_Item__c>();
        
        Relationship_Type__c packageRelationshipType = TestUtils.createRelationshipTypesTypes(1 , null , false)[0];
        packageRelationshipType.Name = 'Package';
        insert packageRelationshipType;
        
        Relationship_Type__c subscriptionUsageRelationshipType = TestUtils.createRelationshipTypesTypes(2 , null , false)[0];
        subscriptionUsageRelationshipType.Name = 'SubscriptionUsage';
        insert subscriptionUsageRelationshipType;
        
        for(Integer i = 0 ; i<100 ;++i)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1, orders[i].Id , false)[0];
            theItem.LZ_Order_Item_ID__c = i+'';
            theItem.Relationship_Type__c = packageRelationshipType.Id;
            orderItemsToCreateForPackage.add(theItem);
        }
        
        Integer j = 100;
        for(Integer i = 100 ; i<200 ;++i)
        {
            
            Order_Item__c theItem = TestUtils.createOrderItems(1, orders[j].Id , false)[0];
            theItem.LZ_Order_Item_ID__c = i+'';
            theItem.Relationship_Type__c = subscriptionUsageRelationshipType.Id;
            orderItemsToCreateForSubscriptionUsage.add(theItem);
            ++j;
        }
        List<Order_Item__c> allOrderItems = new List<Order_Item__c>();
        allOrderItems.addAll(orderItemsToCreateForPackage);
        allOrderItems.addAll(orderItemsToCreateForSubscriptionUsage);
        
        Test.startTest();
            insert allOrderItems;
        Test.stopTest();
        
        List<Order_Item__c> updatedPackageOrderItems = [SELECT Id , User_Order_Extension__c ,LZ_Order_Item_ID__c,Order__r.User_Order_Extension__c FROM Order_Item__c WHERE Id IN :orderItemsToCreateForPackage];
        
        System.assertEquals(100 , updatedPackageOrderItems.size() , '100 Order items should have been created');
        
        for(Order_Item__c theItem : updatedPackageOrderItems)
        {
            Id expectedUserOrderExtensionId = expectedOrderItemNumberToUserExtensionLookUpForPackage.get(theItem.LZ_Order_Item_ID__c);
            System.assertEquals(expectedUserOrderExtensionId , theItem.User_Order_Extension__c , 'Right User Order Extension look up should have been populated on Order Item');
            System.assertEquals(expectedUserOrderExtensionId , theItem.Order__r.User_Order_Extension__c , 'Right User Order Extension look up should have been populated on Order');
        }
        
        List<Order_Item__c> updatedSubscriptionUsageOrderItems = [SELECT Id , User_Order_Extension__c ,LZ_Order_Item_ID__c,Order__r.User_Order_Extension__c FROM Order_Item__c WHERE Id IN :orderItemsToCreateForSubscriptionUsage];
        
        System.assertEquals(100 , updatedSubscriptionUsageOrderItems.size() , '100 Order items should have been created');
        
        for(Order_Item__c theItem : updatedSubscriptionUsageOrderItems)
        {
            Id expectedUserOrderExtensionId = expectedOrderItemNumberToUserExtensionLookUpForSubscriptionUsage.get(theItem.LZ_Order_Item_ID__c);
            System.assertEquals(expectedUserOrderExtensionId , theItem.User_Order_Extension__c , 'Right User Order Extension look up should have been populated on Order Item');
            System.assertEquals(expectedUserOrderExtensionId , theItem.Order__r.User_Order_Extension__c , 'Right User Order Extension look up should have been populated on Order');
        }
        List<Order__c> updatedOrders = [SELECT Id , Entity_Name__c FROM Order__c WHERE Id IN :orders];
        System.assertEquals(200 , updatedOrders.size() , 'There should have been 200 orders');
        for(Order__c theOrder : updatedOrders)
        {
            System.assertEquals(ENTITY_NAME , theOrder.Entity_Name__c , 'Right Entity Name should have been populated');
        }   
    
    }
    
    static testMethod void testUserOrderExtensionLookUpPopulatedOnOrder_OnUpdate()
    {
        List<User_Order_Extension__c> userOrderExtensionToCreate = new List<User_Order_Extension__c>();
        Map<String,Id> expectedOrderItemNumberToUserExtensionLookUp = new Map<String,Id>();
        
        for(Integer i = 0 ; i<200 ;++i)
        {
            userOrderExtensionToCreate.add(new User_Order_Extension__c(LZ_Order_Item_ID__c = i+'' , Entity_Name__c = ENTITY_NAME));
        }
        insert userOrderExtensionToCreate;
        for(User_Order_Extension__c theExtension : userOrderExtensionToCreate)
        {
            expectedOrderItemNumberToUserExtensionLookUp.put(theExtension.LZ_Order_Item_ID__c , theExtension.Id);
        }
        
        List<Order__c> orders = TestUtils.createOrders(200 , null , true);
        
        List<Order_Item__c> orderItemsToCreate = new List<Order_Item__c>();
        Relationship_Type__c packageRelationshipType = TestUtils.createRelationshipTypesTypes(1 , null , false)[0];
        packageRelationshipType.Name = 'Package';
        insert packageRelationshipType;
        
        for(Integer i = 0 ; i<200 ;++i)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1, orders[i].Id , false)[0];
            theItem.LZ_Order_Item_ID__c = i+'';
            orderItemsToCreate.add(theItem);
        }
        insert orderItemsToCreate;
        
        for(Order_Item__c theItem : orderItemsToCreate)
        {
            theItem.Relationship_Type__c = packageRelationshipType.Id;
            theItem.User_Order_Extension__c = expectedOrderItemNumberToUserExtensionLookUp.get(theItem.LZ_Order_Item_ID__c);
        }
        
        Test.startTest();
            update orderItemsToCreate;          
        Test.stopTest();
        
        List<Order_Item__c> updatedOrderItems = [SELECT Id , User_Order_Extension__c ,LZ_Order_Item_ID__c,Order__r.User_Order_Extension__c FROM Order_Item__c WHERE Id IN :orderItemsToCreate];
        
        System.assertEquals(200 , updatedOrderItems.size() , '200 Order items should have been created');
        
        for(Order_Item__c theItem : updatedOrderItems)
        {
            Id expectedUserOrderExtensionId = expectedOrderItemNumberToUserExtensionLookUp.get(theItem.LZ_Order_Item_ID__c);
            System.assertEquals(expectedUserOrderExtensionId , theItem.Order__r.User_Order_Extension__c , 'Right User Order Extension look up should have been populated on Order');
        }
        List<Order__c> updatedOrders = [SELECT Id , Entity_Name__c FROM Order__c WHERE Id IN :orders];
        System.assertEquals(200 , updatedOrders.size() , 'There should have been 200 orders');
        for(Order__c theOrder : updatedOrders)
        {
            System.assertEquals(ENTITY_NAME , theOrder.Entity_Name__c , 'Right Entity Name should have been populated');
        }   
        
    }
    
    static testMethod void testPopulateOrderItemLookUpForSubscriptionSaveActiveRevenue()
    {
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
        Contact testContact = TestUtils.createContacts(1 , 'Test Contact' , testAccount.Id , true)[0];
        
               
        Order__c testOrder = TestUtils.createOrders(1, null , false)[0];
        testOrder.Contact__c = testContact.Id;
        insert testOrder;
        
        Order_Item__c parentOrderItem = TestUtils.createOrderItems(1, testOrder.Id ,  false)[0];
        parentOrderItem.Subscription_Status__c = 'Active';
        parentOrderItem.LZ_Order_Item_ID__c = '1234';
        insert parentOrderItem;
        
      
        Order360__c activeRevenue = new Order360__c();
        activeRevenue.Parent_Order_Item__c = parentOrderItem.Id;
        activeRevenue.LZ_Order_Item_ID__c = '1234';
        insert activeRevenue;


        Relationship_Type__c renewalRelationshipType = TestUtils.createRelationshipTypesTypes(1 , 'Renewal', false)[0];
        renewalRelationshipType.Name = 'Renewal';
        insert renewalRelationshipType;
       
        Order__c renewalOrder = TestUtils.createOrders(1, null , false)[0];
        renewalOrder.Contact__c = testContact.Id;
        insert renewalOrder ;

        Order_Item__c childOrderItem = TestUtils.createOrderItems(1, renewalOrder.Id ,  false)[0];
        childOrderItem.LZ_Order_Item_ID__c = '5678';
        childOrderItem.LZ_Parent_Order_Item_Id__c = '1234';
        childOrderItem.Relationship_Type__c = renewalRelationshipType.Id;
        
        Test.startTest();
            insert childOrderItem;
        Test.stopTest();

        List<Order360__c> activeRevenues = [SELECT Id, Order_Item__c , LZ_Order_Item_Id__c   FROM Order360__c WHERE Id = :activeRevenue.Id];
        System.assertEquals(1 , activeRevenues.size() , 'There should be 1 active revenue');
        System.assertEquals(childOrderItem.Id , activeRevenues[0].Order_Item__c , 'Right Order Item should have been populated');
        System.assertEquals('5678' , activeRevenues[0].LZ_Order_Item_Id__c , 'Right LZ Order Item should have been populated');

    }
    
}