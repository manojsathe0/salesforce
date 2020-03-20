/*
4/15 - Haritha Updated for jenkins deployment
*/
@isTest
public class OrderServiceTest 
{
    
    static Product2 testProduct;
    final static String PRODUCT_LINE = 'Test ProductLine';
    static Id relationshipTypeId;
    public static final Integer SIZE = 3;
    
    static 
    {
        testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
        Product_Line__c testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;
        
        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        testProduct.Product_Line__c = testProductLine.Id;
        insert testProduct; 
    }
    
    static testMethod void testDeveloperNameToRecordTypeIdMapPopulated()
    {
        Test.startTest();
            System.assert(!OrderService.developerNameToRecordTypeIds.isEmpty() ,  'The map should have been populated');
        Test.stopTest();
    }
    
    static testMethod void testDateRange_Populated()
    {
        Test.startTest();
            System.assertNotEquals(null , OrderService.dateRange ,'Date range should have been populated');
        Test.stopTest();
    }
    
    static testMethod void testOppsRecordTypeIds_Populated()
    {
        Test.startTest();
            System.assert(!OrderService.oppsRecordTypeIds.isEmpty() ,'Opportunity Record type Ids should have been populated');
        Test.stopTest();
    }
    
    
    
    static testMethod void testPopulateParentOrderLookUp()
    {
        
        List<Order__c> parentOrders = TestUtils.createOrders(10 , testProduct.Id ,  false);
        for(Integer i = 0 ; i<10 ;++i)
        {
            parentOrders[i].OrderID__c = i+'';
        }
        insert parentOrders;
        
        List<Order__c> childOrders = new List<Order__c>();
        for(Integer i = 0 ; i< 10 ;++i)
        {
            //create 2 child orders
            List<Order__c> ordersPerParent =  TestUtils.createOrders(2 , testProduct.Id , false);
            ordersPerParent[0].LZ_Parent_Order__c = i+'';
            ordersPerParent[1].LZ_Parent_Order__c = i+'';
            childOrders.addAll(ordersPerParent);
        }
        
        Test.startTest();
            insert childOrders;
        Test.stopTest();
        
        List<Order__c> parentOrdersWithChildOrders = [SELECT Id,(SELECT Id ,Parent_Order__c FROM Orders__r) FROM Order__c WHERE Id IN :parentOrders];
        
        System.assertEquals(10 , parentOrdersWithChildOrders.size() , '10 orders should have been returned');
        
        for(Order__c theOrder : parentOrdersWithChildOrders)
        {
            System.assertEquals(2 , theOrder.Orders__r.size() , 'Each order should have 2 child orders');
        }   
        
    }

    static testMethod void testCountNumberOfOrders()
    {
        //insert Account
        Account newAccount = TestUtils.createAccounts(1 , 'POR Account' , true)[0];

        //insert contact
        List<Contact> newContacts = TestUtils.createContacts(SIZE , 'POR Contact' , newAccount.Id , true);
        List<Order__c> ordersToInsert = new List<Order__c>();
        for(Contact theContact : newContacts)
        {
            theContact.Total_Phone_Contacts__c = 5;

            Order__c theOrder = new Order__c();
            theOrder.Contact__c = theContact.Id;
            theOrder.Order_Date_Time_Created__c = DateTime.now();
            ordersToInsert.add(theOrder);
        }
        update newContacts;


        Test.startTest();
            insert ordersToInsert;
        Test.stopTest();

        List<Contact> updatedContacts = [SELECT Id, Total_Activities__c FROM Contact Where Id In: newContacts];
        for(Contact theContact : updatedContacts)
        {
            system.assertEquals(0 , theContact.Total_Activities__c,'Total Contacts should have been zerod');
        }

        ordersToInsert.clear();
        for(Contact theContact : newContacts)
        {
            theContact.Total_Phone_Contacts__c = 5;
            Order__c theOrder = new Order__c();
            theOrder.Contact__c = theContact.Id;
            theOrder.Order_Date_Time_Created__c = DateTime.now();
            ordersToInsert.add(theOrder);
        }
        insert ordersToInsert;

        List<Contact> updatedContactsforNewOrders = [SELECT Id, Total_Activities__c FROM Contact Where Id In: newContacts];
        for(Contact theContact : updatedContactsforNewOrders)
        {
            system.assertEquals(0 , theContact.Total_Activities__c,'Total Contacts should have been zerod');
        }
        Map<Id, Order__c> oldOrders = new Map<Id, Order__c>([select id, Order_Date_Time_Created__c from Order__c ]);
        OrderService.preserveOriginalOrderCreatedDateTime(ordersToInsert, oldOrders);
        OrderService.processForCampaigns(oldOrders.keySet());
    
    }
    static testMethod void oppsRecordTypeIdsCommaSeparated()
    {
        String str = OrderService.oppsRecordTypeIdsCommaSeparated;
        str = OrderService.allOppsRecordTypeIdsCommaSeparated;
    }
    
    static testMethod void exceptionClosureTest() {
        Order_Payment_Status__c pending = new Order_Payment_Status__c(Name = 'Pending');
        Order_Payment_Status__c cancelled = new Order_Payment_Status__c(Name = 'Cancelled');
        insert pending;
        insert cancelled;
        List<Order__c> parentOrders = TestUtils.createOrders(10 , testProduct.Id ,  false);
        for(Integer i = 0 ; i<10 ;++i) {
            parentOrders[i].Order_Payment_Status__c  = pending.Id;
            parentOrders[i].User_Order_ID__c = String.valueOf(123456+i);
        }
        insert parentOrders;
        
        for(Integer i = 0 ; i<10 ;++i) {
            parentOrders[i].Order_Payment_Status__c  = cancelled.Id;
        }
        update parentOrders;
    }
    static testmethod void onboardcreatetestcase()
    {
    
    SEAD_Configuration__c config = new SEAD_Configuration__c();
        config.Name = 'Default';
       config.ra__c = 5;
        config.bap__c = 2;
        config.tax__c = 3;
        config.compliance__c = 1;
        config.ein__c=4;
        config.standard__c= 1;
        config.tm_search__c = 2;
        config.Lead_Email_Score__c = 1;
        config.economy__c = 2;
        config.Express_gold__c= 3;


        insert config;
    
    Relationship_Type__c relationshiptype = new Relationship_Type__c();
    relationshiptype.name='Package';
    relationshiptype.Relationship_Type_ID__c='2';
    relationshiptype.active__c=true;
    insert  relationshiptype;
    
    Process__c process = new Process__c();
    process.name='LLC';
    process.Process_ID__c=2;
    process.Active__c=true;
    process.Deployed__c=true;
    insert process ;
       product2 testbase = new product2();
       testbase.Name='Economy LLC';
       testbase.Process__c=process.id;
       testbase.LZ_Product_ID__c=145;
       testbase.Relationship_Type__c=relationshiptype.id;
       
       insert testbase;
       
       order__c orderonboard = new Order__c();
       orderonboard.Name='54000011';
       orderonboard.User_Order_ID__c='1234';
       orderonboard.Base_Product__c=testbase.id;
        orderonboard.ra__c=true;
        orderonboard.compliance__c=true;
        orderonboard.tax__c=true;
        orderonboard.bap__c=true;
        
       
        orderonboard.ein__c=true;
        orderonboard.standard__c= true;
        orderonboard.tm_search__c = true;
     
        orderonboard.economy__c = true;
        orderonboard.Express_gold__c= true;
       insert orderonboard;
       
       
        
    }
    
     static testmethod void onboardupdatetestcase()
    {
    
    SEAD_Configuration__c config = new SEAD_Configuration__c();
        config.Name = 'Default';
        config.ra__c = 5;
        config.bap__c = 2;
        config.tax__c = 3;
        config.compliance__c = 1;
        config.ein__c=4;
        config.standard__c= 1;
        config.tm_search__c = 2;
        config.Lead_Email_Score__c = 1;
        config.economy__c = 2;
        config.Express_gold__c= 3;
     


        insert config;
    Relationship_Type__c relationshiptype = new Relationship_Type__c();
    relationshiptype.name='Package';
    relationshiptype.Relationship_Type_ID__c='2';
    relationshiptype.active__c=true;
    insert  relationshiptype;
    
    Process__c process = new Process__c();
    process.name='LLC';
    process.Process_ID__c=2;
    process.Active__c=true;
    process.Deployed__c=true;
    insert process ;
       
       Id processId = [Select id, name,Process_ID__c,Active__c,Deployed__c from process__c Where name='LLC'][0].id;
       product2 testbase = new product2();
       testbase.Name='Economy LLC';
       testbase.Process__c=processId;
       testbase.LZ_Product_ID__c=145;
       testbase.Relationship_Type__c=relationshiptype.id;
       
       insert testbase;
       
        id bproductId = [Select Id, Name, Process__c,Relationship_Type__c,LZ_Product_ID__c from product2 where name = 'Economy LLC'][0].id;
       
       order__c orderonboard = new Order__c();
       orderonboard.Name='54000011';
       orderonboard.User_Order_ID__c='1234';
       //orderonboard.Base_Product__c=testbase.id;
       orderonboard.Base_Product__c=bproductId;
        orderonboard.ra__c=true;
        orderonboard.compliance__c=true;
        orderonboard.tax__c=true;
        orderonboard.bap__c=true;
       insert orderonboard;
       
       
       update orderonboard;
        
    }
    
    static testMethod void testOnboardingCreation() {
    	
        Product_Line__c testIncProductLine = TestUtils.createProductLines(1 , 'Test INC Product' , false)[0];
        testIncProductLine.Name = 'Test INC Product';
        testIncProductLine.Product_Line_ID__c = 12;
        insert testIncProductLine;
        
        Process__c testProcess = new Process__c();
	    testProcess.Name = 'Incorporation';
	    testProcess.Process_ID__c = 11;
	    testProcess.Active__c = true;
	    testProcess.Deployed__c = true;
	    insert testProcess ;
        
        
        Product2 testProduct = TestUtils.createProducts(1 , 'Incorporation', false)[0];
        testProduct.Process__c = testProcess.Id;
        testProduct.LZ_Product_ID__c = 123;
        testProduct.Name = 'Incorporation';
        
        testProduct.Relationship_Type__c = relationshipTypeId;
        testProduct.Product_Line__c = testIncProductLine.Id;
        insert testProduct; 
    	
    	List<Order__c> ordersToInsert = TestUtils.createOrders(1, testProduct.Id,  false);
        
        System.debug(ordersToInsert);
        
        Test.startTest();
            insert ordersToInsert;
        Test.stopTest();
    }
}