@isTest
public class ProblemOrderRoutingServiceTest 
{
public static List<Order__c> newOrders = new List<Order__c>();
public static Customer_Login__c newCustomerLogin = new Customer_Login__c();
public static Contact newContact = new Contact();
final static Datetime problemIdentified = system.today().addDays(-2);
public static Id relationshipTypeId;
public static Process__c newProcess;
public static Process__c newProcess2;
public static Product2 newProducts_revision;
public static Product2 newProduct;
public static Relationship_Type__c relationshipTypeId_Revised;
public final static Integer SIZE = 1;

    public static void setupData()
    {
        OrderService.hasOrderMatchingTriggerRun = true;
        //insert custom seetings for queue
        POR_case_routing_queues__c PORSetting = new POR_case_routing_queues__c(
            Name = ProblemOrderConstants.POA, 
            Queue_Name__c = ProblemOrderConstants.QUEUE_NAME,
            Template_DeveloperName__c = ProblemOrderConstants.EMAIL_TEMPLATE);
        insert PORSetting;

        //create relationship id for a process
        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process' , true)[0].Id;
        relationshipTypeId_Revised = TestUtils.createRelationshipTypesTypes(1 , '' , false)[0];
        relationshipTypeId_Revised.Name = 'Revision';
        relationshipTypeId_Revised.Relationship_Type_ID__c = '1';
        insert relationshipTypeId_Revised;
        system.debug(relationshipTypeId_Revised);

        //create process
        newProcess = new Process__c();
            newProcess.Name = ProblemOrderConstants.POA;
            newProcess.Process_ID__c = 1;
         insert newProcess;

         //create process for revision
        Process__c newProcess_revision = new Process__c();
            newProcess_revision.Name = ProblemOrderConstants.REVISION;
            newProcess_revision.Process_ID__c = 2;
         insert newProcess_revision;

        //create new product
        List<Product2> newProducts = TestUtils.createProducts(1 , '', false);
        newProducts[0].Name = ProblemOrderConstants.POA;
        newProducts[0].Relationship_Type__c = relationshipTypeId;
        newProducts[0].Process__c = newProcess.Id;
        insert newProducts;

         newProcess2 = new Process__c();
            newProcess2.Name = ProblemOrderConstants.EP_BUNDLE;
            newProcess2.Process_ID__c = 3;
         insert newProcess2;

        newProduct = TestUtils.createProducts(1 , '', false)[0];
        newProduct.Name = ProblemOrderConstants.EP_BUNDLE;
        newProduct.Relationship_Type__c = TestUtils.createRelationshipTypesTypes(1 , 'Cross Sell' , true)[0].Id;
        newProduct.LZ_Product_ID__c = 3;
        newProduct.Process__c = newProcess2.Id;
        insert newProduct;

        //insert Account
        Account newAccount = TestUtils.createAccounts(1 , 'POR Account' , true)[0];

        //insert contact
        newContact = TestUtils.createContacts(1 , 'POR Contact' , newAccount.Id , false)[0];
        newContact.Email = 'lzPORtest@lzTestClass.com';
        insert newContact;

        //insert Customer login
        newCustomerLogin = TestUtils.createCustomerLogins(1 , 'Cust Login' , false)[0];
        newCustomerLogin.Primary_Contact__c = newContact.Id;
        insert newCustomerLogin;

        //insert dummy orders
        newOrders = TestUtils.createOrders(SIZE, newProducts[0].Id, false);
        integer i=0;
        for(Order__c theOrder : newOrders)
        {
            theOrder.contact__c = newContact.Id;
            theOrder.customer_Login__c = newCustomerLogin.Id;
            theOrder.User_Order_ID__c = '500000'+i;
            i++;
        }
        insert newOrders;

        List<Order_Item__c> orderItemsToinsert = new List<Order_Item__c>();
        for(Order__c theOrder : newOrders)
        {
            Order_Item__c newOrderItem = new Order_Item__c();
            newOrderItem.Order__c = theOrder.Id;
            newOrderItem.Product__c = newProducts[0].Id;
            newOrderItem.User_Order_ID__c = theOrder.User_Order_ID__c;
            orderItemsToinsert.add(newOrderItem);
        }
        insert orderItemsToinsert;
    }
    
    
    static testMethod void createCaseForProblemOrderTest_NotIntegrationUser()
    {
        setupData();
        Set<Id> orderIds = new Set<Id>(); 
        List<Task> tasksToCreate = new List<Task>();

        //create problem orders(tasks with action type = Manual Problem Order)
        for(Order__C theOrder : newOrders)
        {
            Task theTask = new Task();
            theTask.WhatId = theOrder.id;
            theTask.Description = 'Test Description';
            theTask.Action_Type__C = ProblemOrderConstants.ACTION_TYPE;
            theTask.Datetime_Created_External_System__c = problemIdentified;
            theTask.User_Order_ID__c = theOrder.User_Order_ID__c;
            tasksToCreate.add(theTask);
            orderIds.add(theOrder.Id);
        }

        Test.startTest();
            insert tasksToCreate;
        Test.stopTest();


        List<Case> insertedCases = [Select Id, Queue__c , Product__c , Problem_Order_Type__c , Total_Automatic_Outbound_Emails__c , Customer_Login__c , ContactId , DateTime_Problem_Identified__c , Total_Outbound_Emails__c From Case Where Order__c In: orderIds];
        //System.assertEquals(insertedCases.size(),SIZE, SIZE+' cases should have been created');

        for(Case theCase : insertedCases)
        {
            system.assertEquals(ProblemOrderConstants.QUEUE_NAME, theCase.Queue__c);
            system.assertEquals(ProblemOrderConstants.POA, theCase.Product__c);
            system.assertEquals(ProblemOrderConstants.ACTION_TYPE, theCase.Problem_Order_Type__c);
            system.assertEquals(newCustomerLogin.id, theCase.Customer_Login__c);
            system.assertEquals(newContact.Id, theCase.ContactId);
            system.assertEquals(problemIdentified, theCase.DateTime_Problem_Identified__c);
            system.assertEquals(1, theCase.Total_Outbound_Emails__c);
            system.assertEquals(0, theCase.Total_Automatic_Outbound_Emails__c);
        }
    }

    static testMethod void createCaseForProblemOrderTest_IntegrationUser()
    {
        setupData();
        Set<Id> orderIds = new Set<Id>(); 
        List<Task> tasksToCreate = new List<Task>();

        //create problem orders(tasks with action type = Manual Problem Order)
        for(Order__C theOrder : newOrders)
        {
            Task theTask = new Task();
            theTask.WhatId = theOrder.id;
            theTask.Description = 'Test Description';
            theTask.Action_Type__C = ProblemOrderConstants.ACTION_TYPE;
            theTask.Datetime_Created_External_System__c = problemIdentified;
            theTask.User_Order_ID__c = theOrder.User_Order_ID__c;
            tasksToCreate.add(theTask);
            orderIds.add(theOrder.Id);
        }

        Test.startTest();
            System.runAs(UtilityLibrary.integrationUser) //used the Utility library to retrieve the integration user: B-38758
            {
                insert tasksToCreate;
            }
        Test.stopTest();


        List<Case> insertedCases = [Select Id, Queue__c , Product__c , Problem_Order_Type__c , Total_Automatic_Outbound_Emails__c , Customer_Login__c , ContactId , DateTime_Problem_Identified__c , Total_Outbound_Emails__c From Case Where Order__c In: orderIds];
        //System.assertEquals(insertedCases.size(),SIZE, SIZE+' cases should have been created');

        for(Case theCase : insertedCases)
        {
            system.assertEquals(ProblemOrderConstants.QUEUE_NAME, theCase.Queue__c);
            system.assertEquals(ProblemOrderConstants.POA, theCase.Product__c);
            system.assertEquals(ProblemOrderConstants.ACTION_TYPE, theCase.Problem_Order_Type__c);
            system.assertEquals(newCustomerLogin.id, theCase.Customer_Login__c);
            system.assertEquals(newContact.Id, theCase.ContactId);
            system.assertEquals(problemIdentified, theCase.DateTime_Problem_Identified__c);
            system.assertEquals(1, theCase.Total_Outbound_Emails__c);
            system.assertEquals(1, theCase.Total_Automatic_Outbound_Emails__c);
        }
    }

    static testMethod void createCaseForProblemOrderTest_CrossSell()
    {
        setupData();
        //insert dummy orders
        newOrders = TestUtils.createOrders(SIZE, newProduct.Id, false);
        integer i=0;
        for(Order__c theOrder : newOrders)
        {
            theOrder.contact__c = newContact.Id;
            theOrder.customer_Login__c = newCustomerLogin.Id;
            theOrder.User_Order_ID__c = '500000'+i;
            i++;
        }
        insert newOrders;

        List<Order_Item__c> orderItemsToinsert = new List<Order_Item__c>();
        for(Order__c theOrder : newOrders)
        {
            Order_Item__c newOrderItem = new Order_Item__c();
            newOrderItem.Order__c = theOrder.Id;
            newOrderItem.Product__c = newProduct.Id;
            newOrderItem.User_Order_ID__c = theOrder.User_Order_ID__c;
            orderItemsToinsert.add(newOrderItem);
        }
        insert orderItemsToinsert;
        system.debug(orderItemsToinsert);
        Set<Id> orderIds = new Set<Id>(); 
        List<Task> tasksToCreate = new List<Task>();

        //create problem orders(tasks with action type = Manual Problem Order)
        for(Order__C theOrder : newOrders)
        {
            Task theTask = new Task();
            theTask.WhatId = theOrder.id;
            theTask.Description = 'Test Description';
            theTask.Action_Type__C = ProblemOrderConstants.ACTION_TYPE;
            theTask.Datetime_Created_External_System__c = problemIdentified;
            theTask.User_Order_ID__c = theOrder.User_Order_ID__c;
            tasksToCreate.add(theTask);
            orderIds.add(theOrder.Id);
        }
        system.debug(tasksToCreate);
        Test.startTest();
            System.runAs(UtilityLibrary.integrationUser)//used the Utility library to retrieve the integration user: B-38758
            {
                insert tasksToCreate;
            }
        Test.stopTest();

        List<Case> insertedCases = [Select Id, Queue__c , Product__c , Problem_Order_Type__c , Total_Automatic_Outbound_Emails__c , Customer_Login__c , ContactId , DateTime_Problem_Identified__c , Total_Outbound_Emails__c From Case Where Order__c In: orderIds];
        //System.assertEquals(insertedCases.size(),SIZE, SIZE+' cases should have been created');
        system.debug(insertedCases);
        for(Case theCase : insertedCases)
        {
            system.assertEquals(ProblemOrderConstants.QUEUE_NAME, theCase.Queue__c);
            system.assertEquals(ProblemOrderConstants.EP_BUNDLE, theCase.Product__c);
            system.assertEquals(ProblemOrderConstants.ACTION_TYPE, theCase.Problem_Order_Type__c);
            system.assertEquals(newCustomerLogin.id, theCase.Customer_Login__c);
            system.assertEquals(newContact.Id, theCase.ContactId);
            system.assertEquals(1, theCase.Total_Outbound_Emails__c);
            system.assertEquals(1, theCase.Total_Automatic_Outbound_Emails__c);
        }


    }
    

    static testMethod void closeRelatedOpenCasesForRevisedOrderTest()
    {
        setupData();
        Set<Id> orderIds = new Set<Id>(); 
        List<Task> tasksToCreate = new List<Task>();
        List<Order_Item__c> revisedItems = new List<Order_Item__c>();

        //create problem orders(tasks with action type = Manual Problem Order)
        for(Order__C theOrder : newOrders)
        {
            Task theTask = new Task();
            theTask.WhatId = theOrder.id;
            theTask.Description = 'Test Description';
            theTask.Action_Type__C = ProblemOrderConstants.ACTION_TYPE;
            theTask.Datetime_Created_External_System__c = problemIdentified;
            theTask.User_Order_ID__c =  theOrder.User_Order_ID__c; 
            tasksToCreate.add(theTask);
            orderIds.add(theOrder.Id);
        }
        test.starttest();
        insert tasksToCreate;
        test.stoptest();
        for(Order__c theOrder : newOrders)
        {
            Order_Item__c revisedOrder = new Order_Item__c();
            revisedOrder.Order__c = theOrder.Id;
            revisedOrder.User_Order_ID__c = theOrder.User_Order_ID__c;
            revisedOrder.Relationship_Type__c = relationshipTypeId_Revised.Id;
            revisedOrder.Name = '3'+theOrder.User_Order_ID__c;
            revisedItems.add(revisedOrder);
        }

        
            insert revisedItems;
        
       system.debug(newOrders);
        List<Case> insertedCases = [Select Id, Status, Problem_Order_Resolution__c From Case Where Order__c In: orderIds];
        for(Case theCase : insertedCases)
        {
            system.assertEquals('Closed',theCase.Status);
            system.assertEquals('Resolved – Revision Placed on LZ.com',theCase.Problem_Order_Resolution__c);
        }
    }
    
    static testMethod void closeRelatedOpenCasesForRevisedOrderTest_after7day()
    {
        setupData();
        Set<Id> orderIds = new Set<Id>(); 
        List<Task> tasksToCreate = new List<Task>();
        List<Order_Item__c> revisedItems = new List<Order_Item__c>();

        //create problem orders(tasks with action type = Manual Problem Order)
        for(Order__C theOrder : newOrders)
        {
            Task theTask = new Task();
            theTask.WhatId = theOrder.id;
            theTask.Description = 'Test Description';
            theTask.Action_Type__C = ProblemOrderConstants.ACTION_TYPE;
            theTask.Datetime_Created_External_System__c = problemIdentified;
            theTask.User_Order_ID__c =  theOrder.User_Order_ID__c; 
            tasksToCreate.add(theTask);
            orderIds.add(theOrder.Id);
        }
        test.starttest();
        insert tasksToCreate;
        test.stoptest();
        List<Case> insertedCases = [Select Id, Status, Problem_Order_Resolution__c From Case Where Order__c In: orderIds];
        for(Case theCase : insertedCases)
        {
            theCase.Problem_Order_Resolution__c = ProblemOrderConstants.UNRESOLVED_CLOSED;
        }
        update insertedCases;

        for(Order__c theOrder : newOrders)
        {
            Order_Item__c revisedOrder = new Order_Item__c();
            revisedOrder.Order__c = theOrder.Id;
            revisedOrder.User_Order_ID__c = theOrder.User_Order_ID__c;
            revisedOrder.Relationship_Type__c = relationshipTypeId_Revised.Id;
            revisedOrder.Name = '3'+theOrder.User_Order_ID__c;
            revisedItems.add(revisedOrder);
        }

        
            insert revisedItems;
        
       system.debug(newOrders);
        List<Case> insertedCases2 = [Select Id, Status, Problem_Order_Resolution__c From Case Where Order__c In: orderIds];
        for(Case theCase : insertedCases2)
        {
            system.assertEquals('Closed',theCase.Status);
            system.assertEquals(ProblemOrderConstants.REVISION_AFTER_7DAY_STATUS,theCase.Problem_Order_Resolution__c);
        }
    }
    
}