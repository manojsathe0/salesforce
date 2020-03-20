@isTest
public class OrderItemMatchingRenewalTest 
{
    static List<Order__c> parentOrders;
    static List<Order__c> renewalOrders;

    static List<Lead> testLeads;
    
    static List<Account> testAccounts;
    static List<Order_Matching_Activity__c> testOrderMatchingActivities;
    static List<Task> tasksToCreate;
    
    static final String ABANDONER = 'Abandoner';
    static Id abandonerRecordTypeId;
    static User testUser;
    static Product2 testProduct;
    final static String PRODUCT_LINE = 'Test ProductLine';
    static Id relationshipTypeId;
    static Id renewalRelationshipTypeId;
    static Id packageRelationshipTypeId;
    
    
    static Product2 renewalProduct;
    static Product2 registerAgentProduct;
    static final String REGISTERED_AGENT = 'Registered Agent';
    static final String THEPACKAGE = 'Package';
    static final String CROSS_SELL = 'Cross-Sell';
    
    
    static List<RA_Renewal_Product_Name__c> RARenewalProducts;
    static Relationship_Type__c packageRelationshipType;
    static Relationship_Type__c crossSellRelationshipType;
    static List<Contact> testContacts;
    final static String PRIMARY_CONTACT = 'Primary Contact';

    
    static
    {
        OrderService.hasOrderMatchingTriggerRun = true;
        testUser = TestUtils.createUser( 'Austin', TestUtils.STANDARD_PROFILE_ID , true);
        User firstCommissionUser = TestUtils.createUser( 'Bonjovi', TestUtils.STANDARD_PROFILE_ID , true);

        RARenewalProducts = new List<RA_Renewal_Product_Name__c>();
        RA_Renewal_Product_Name__c theRARenewalProduct = new RA_Renewal_Product_Name__c();
        theRARenewalProduct.Name = '1';
        theRARenewalProduct.Product_Name__c = 'RA Renewal - 1 year';
        RARenewalProducts.add(theRARenewalProduct);
        
        insert RARenewalProducts;
        
        abandonerRecordTypeId = OrderService.developerNameToRecordTypeIds.get(ABANDONER); 
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
        
        Relationship_Type__c renewalRelationshipType = TestUtils.createRelationshipTypesTypes(1 , 'Renewal', false)[0];
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
        
        
        insert new List<Product2>{registerAgentProduct , renewalProduct , testProduct};
  
    }
    


    static testMethod void testRARenewalOrdersForStandAloneOrders()
    {
        Account anotherAccount = TestUtils.createAccounts(1 , 'Test Account', false)[0];
        anotherAccount.Name = 'Test0@test.com';
        insert anotherAccount;
        
        testContacts = new List<Contact>();
        Contact firstContact = TestUtils.createContacts(1 , 'Test Contact', anotherAccount.Id, false)[0];
        firstContact.HomePhone = '7777777777';
        firstContact.Contact_Type__c = PRIMARY_CONTACT;
        testContacts.add(firstContact);
        insert testContacts;

        parentOrders = TestUtils.createOrders(50 , testProduct.Id ,  false);
        for(Integer i =0 ; i<50; ++i) 
        {
            parentOrders[i].OrderID__c = String.valueOf(i);
            parentOrders[i].Name = String.valueOf(i);
            parentOrders[i].User_Order_ID__c = String.valueOf(i);
            parentOrders[i].Order_Date_Time_Created__c = DateTime.now().addHours(5);
            parentOrders[i].Contact__c = testContacts[0].Id;            
        }
        insert parentOrders;
        
        List<Order_Item__c> orderItemsToCreate = new List<Order_Item__c>();
        for(Order__c theOrder : parentOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            theItem.Product__c = registerAgentProduct.Id;
            theItem.Relationship_Type__c = packageRelationshipType.Id;
            orderItemsToCreate.add(theItem);
        }
        insert orderItemsToCreate;
        
        
        renewalOrders = TestUtils.createOrders(50 , renewalProduct.Id ,  false);
        for(Integer i =0 ; i<50 ;++i)
        {
            renewalOrders[i].OrderID__c = String.valueOf(i)+'renewal';
            renewalOrders[i].Name = String.valueOf(i)+'renewal';
            renewalOrders[i].Base_Product__c =  renewalProduct.Id;
            renewalOrders[i].LZ_Parent_Order__c = String.valueOf(i);
            renewalOrders[i].Account__c = anotherAccount.Id;
            renewalOrders[i].Contact_Email__c = anotherAccount.Name;
            renewalOrders[i].Order_Date_Time_Created__c = DateTime.now().addHours(8);
            renewalOrders[i].Order_Created_By__c = 'abc';
            renewalOrders[i].Contact__c = testContacts[0].Id; 
        }
        insert renewalOrders;
        List<Order_Item__c> renewalorderItemsToCreate = new List<Order_Item__c>();
        for(Order__c theOrder : renewalOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            theItem.Product__c = registerAgentProduct.Id;
            theItem.Relationship_Type__c = packageRelationshipType.Id;
            renewalorderItemsToCreate.add(theItem);
        }
        
        System.runAs(testUser)
        {
            for(Contact theContact : testContacts)
            {
                Task theTask = TestUtils.createTasks(1 , null, false)[0];
                theTask.WhoId = theContact.Id;
                theTask.Commission_Eligible__c = true;
                tasksToCreate.add(theTask);
            }
            insert tasksToCreate;
        }
                    
        Test.startTest();
            insert renewalorderItemsToCreate;
        Test.stopTest();
        List<Order_Matching_Activity__c> createdOMAs = [SELECT Id , Agent__c FROM Order_Matching_Activity__c WHERE Contact__c IN :testContacts];
        system.assertEquals(testContacts.size(), createdOMAs.size() , 'Right number of OMAs should have been created.1 for each Contact');

        List<Order360__c> newOrder360 = [Select Id, Agent__c , New_Logic__c FROM Order360__c Where Order_Item__c IN: renewalorderItemsToCreate];
        system.assertEquals(renewalorderItemsToCreate.size()*testContacts.size(), newOrder360.size() , 'Right number of Active revenue records should have been created');

        for(Order360__c theOrder360 : newOrder360)
        {
            system.assertEquals(true , theOrder360.New_Logic__c , 'Checkbox should be true since its new logic');
        }
    }
    
   
    static testMethod void testRARenewalOrdersForCrossSellOrders()
    {
        crossSellRelationshipType = TestUtils.createRelationshipTypesTypes(1 , CROSS_SELL, false)[0];
        crossSellRelationshipType.Name = CROSS_SELL;
        insert crossSellRelationshipType;
        
        registerAgentProduct.Relationship_Type__c = crossSellRelationshipType.Id;
        
        Account anotherAccount = TestUtils.createAccounts(1 , 'Test Account', false)[0];
        anotherAccount.Name = 'Test0@test.com';
        insert anotherAccount;

        testContacts = new List<Contact>();
        Contact firstContact = TestUtils.createContacts(1 , 'Test Contact', anotherAccount.Id, false)[0];
        firstContact.HomePhone = '7777777777';
        firstContact.Contact_Type__c = PRIMARY_CONTACT;
        testContacts.add(firstContact);
        insert testContacts;

        
        parentOrders = TestUtils.createOrders(50 , testProduct.Id ,  false);
        for(Integer i =0 ; i<50; ++i) 
        {
            parentOrders[i].OrderID__c = String.valueOf(i);
            parentOrders[i].Name = String.valueOf(i);
            parentOrders[i].User_Order_ID__c = String.valueOf(i);
            parentOrders[i].Order_Date_Time_Created__c = DateTime.now().addHours(5);
            parentOrders[i].Contact__c = testContacts[0].Id;                
        }
        insert parentOrders;
        
        List<Order_Item__c> orderItemsToCreate = new List<Order_Item__c>();
        for(Order__c theOrder : parentOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            theItem.Product__c = registerAgentProduct.Id;
            theItem.Relationship_Type__c = crossSellRelationshipType.Id;
            orderItemsToCreate.add(theItem);
        }

        System.runAs(testUser)
        {
            for(Contact theContact : testContacts)
            {
                Task theTask = TestUtils.createTasks(1 , null, false)[0];
                theTask.WhoId = theContact.Id;
                theTask.Commission_Eligible__c = true;
                tasksToCreate.add(theTask);
            }
            insert tasksToCreate;
        }
        
        insert orderItemsToCreate;
        List<Order360__c> oldOrder360 = [Select Id, Agent__c, Order__c, Order_Matching_Activity__c FROM Order360__c Where Order_Item__c IN: orderItemsToCreate];
        Map<Id,Id> parentorderIdtoOMAId = new Map<Id,Id>();
        for(Order360__c theOrder360 : oldOrder360)
        {
            parentorderIdtoOMAId.put(theorder360.Order__c,theorder360.Order_Matching_Activity__c);
        }
        
        renewalOrders = TestUtils.createOrders(50 , renewalProduct.Id ,  false);
        for(Integer i =0 ; i<50 ;++i)
        {
            renewalOrders[i].OrderID__c = String.valueOf(i)+'renewal';
            renewalOrders[i].Name = String.valueOf(i)+'renewal';
            renewalOrders[i].Base_Product__c =  renewalProduct.Id;
            renewalOrders[i].LZ_Parent_Order__c = String.valueOf(i);
            renewalOrders[i].Order_Created_By__c = 'abc';
            renewalOrders[i].Order_Date_Time_Created__c = DateTime.now().addHours(8);
            renewalOrders[i].Account__c = anotherAccount.Id;
            renewalOrders[i].Contact_Email__c = anotherAccount.Name;
            renewalOrders[i].Contact__c = testContacts[0].Id;
        }
        insert renewalOrders;

        List<Order_Item__c> renewalorderItemsToCreate = new List<Order_Item__c>();
        for(Order__c theOrder : renewalOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            theItem.Product__c = registerAgentProduct.Id;
            theItem.Relationship_Type__c = packageRelationshipType.Id;
            renewalorderItemsToCreate.add(theItem);
        }
            
        Test.startTest();
            insert renewalorderItemsToCreate;
        Test.stopTest();

        List<Order_Matching_Activity__c> createdOMAs = [SELECT Id , Agent__c FROM Order_Matching_Activity__c WHERE Contact__c IN :testContacts];
        System.assertEquals(testContacts.size(), createdOMAs.size() , 'Right number of OMAs should have been created.1 for each Contact');

         List<Order360__c> newOrder360 = [Select Id, Agent__c, Order__r.Parent_Order__c,Order_Matching_Activity__c,Order__c,Order_Item__c , New_Logic__c FROM Order360__c Where Order_Item__c IN: renewalorderItemsToCreate];
        System.assertEquals(renewalorderItemsToCreate.size()*testContacts.size(), newOrder360.size() , 'Right number of Active revenue records should have been created');
        
        for(Order360__c theOrder360 : newOrder360)
        {
            system.assertEquals(theorder360.Order_Matching_Activity__c , parentorderIdtoOMAId.get(theOrder360.Order__r.Parent_Order__c), 'Rhight Parent order OMA should have been matched');
            system.assertEquals(theorder360.Agent__c , 'Agent 1' , 'Agent field should have been populated to Agent 1');
            system.assertEquals(true , theOrder360.New_Logic__c , 'Checkbox should be true since its new logic');
        }       
    }


    static testMethod void testRARenewalOrdersForFirstCrossSellOrders()
    {
        crossSellRelationshipType = TestUtils.createRelationshipTypesTypes(1 , CROSS_SELL, false)[0];
        crossSellRelationshipType.Name = CROSS_SELL;
        insert crossSellRelationshipType;
        
        registerAgentProduct.Relationship_Type__c = crossSellRelationshipType.Id;
        
        Account anotherAccount = TestUtils.createAccounts(1 , 'Test Account', false)[0];
        anotherAccount.Name = 'Test0@test.com';
        insert anotherAccount;

        testContacts = new List<Contact>();
        Contact firstContact = TestUtils.createContacts(1 , 'Test Contact', anotherAccount.Id, false)[0];
        firstContact.HomePhone = '7777777777';
        firstContact.Contact_Type__c = PRIMARY_CONTACT;
        testContacts.add(firstContact);
        insert testContacts;

        
        parentOrders = TestUtils.createOrders(50 , testProduct.Id ,  false);
        for(Integer i =0 ; i<50; ++i) 
        {
            parentOrders[i].OrderID__c = String.valueOf(i);
            parentOrders[i].Name = String.valueOf(i);
            parentOrders[i].User_Order_ID__c = String.valueOf(i);
            parentOrders[i].Order_Date_Time_Created__c = DateTime.now().addHours(5);
            parentOrders[i].Contact__c = testContacts[0].Id;                
        }
        insert parentOrders;
        
        List<Order_Item__c> orderItemsToCreate = new List<Order_Item__c>();
        for(Order__c theOrder : parentOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            theItem.Product__c = registerAgentProduct.Id;
            theItem.Relationship_Type__c = crossSellRelationshipType.Id;
            orderItemsToCreate.add(theItem);
        }

        System.runAs(testUser)
        {
            for(Contact theContact : testContacts)
            {
                Task theTask = TestUtils.createTasks(1 , null, false)[0];
                theTask.WhoId = theContact.Id;
                theTask.Commission_Eligible__c = true;
                tasksToCreate.add(theTask);
            }
            insert tasksToCreate;
        }
        
        insert orderItemsToCreate;

        List<Order360__c> oldOrder360 = [Select Id, Agent__c, Order__c, Order_Matching_Activity__c FROM Order360__c Where Order_Item__c IN: orderItemsToCreate];
        Map<Id,Id> parentorderIdtoOMAId = new Map<Id,Id>();
        for(Order360__c theOrder360 : oldOrder360)
        {
            parentorderIdtoOMAId.put(theorder360.Order__c,theorder360.Order_Matching_Activity__c);
        }

        renewalOrders = TestUtils.createOrders(50 , renewalProduct.Id ,  false);
        for(Integer i =0 ; i<50 ;++i)
        {
            renewalOrders[i].OrderID__c = String.valueOf(i)+'renewal';
            renewalOrders[i].Name = String.valueOf(i)+'renewal';
            renewalOrders[i].Base_Product__c =  renewalProduct.Id;
            renewalOrders[i].LZ_Parent_Order__c = String.valueOf(i);
            renewalOrders[i].Order_Created_By__c = 'abc';
            renewalOrders[i].Order_Date_Time_Created__c = DateTime.now().addHours(8);
            renewalOrders[i].Account__c = anotherAccount.Id;
            renewalOrders[i].Contact_Email__c = anotherAccount.Name;
            renewalOrders[i].Contact__c = testContacts[0].Id; 
            renewalOrders[i].Parent_Order__c = parentOrders[i].Id; 
            renewalOrders[i].Is_First_RA_Renewal__c = true; 
        }
        insert renewalOrders;
        List<Order_Item__c> renewalorderItemsToCreate = new List<Order_Item__c>();
        for(Order__c theOrder : renewalOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            theItem.Product__c = registerAgentProduct.Id;
            theItem.Relationship_Type__c = packageRelationshipType.Id;
            renewalorderItemsToCreate.add(theItem);
        }
            
        Test.startTest();
            insert renewalorderItemsToCreate;
        Test.stopTest();

        List<Order_Matching_Activity__c> createdOMAs = [SELECT Id , Agent__c FROM Order_Matching_Activity__c WHERE Contact__c IN :testContacts];
        System.assertEquals(testContacts.size(), createdOMAs.size() , 'Right number of OMAs should have been created.1 for each Contact');

        List<Order360__c> newOrder360 = [Select Id, Agent__c, Order__r.Parent_Order__c,Order_Matching_Activity__c,Order__c,Order_Item__c , New_Logic__c FROM Order360__c Where Order_Item__c IN: renewalorderItemsToCreate];
        System.assertEquals(renewalorderItemsToCreate.size()*testContacts.size(), newOrder360.size() , 'Right number of Active revenue records should have been created');

        for(Order360__c theOrder360 : newOrder360)
        {
            system.assertEquals(theorder360.Order_Matching_Activity__c , parentorderIdtoOMAId.get(theOrder360.Order__r.Parent_Order__c), 'Rhight Parent order OMA should have been matched');
            system.assertEquals(theorder360.Agent__c , 'Agent 1' , 'Agent field should have been populated to Agent 1');
            system.assertEquals(true , theOrder360.New_Logic__c , 'Checkbox should be true since its new logic');
        }        
    }
    

}