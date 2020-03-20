/**
 * Created by hravuru on 4/24/2019.
 */

@IsTest
private class OrderItemMatchingBatchTest {
    static Product2 testProduct;
    static Id abandonerRecordTypeId;
    static List<RA_Renewal_Product_Name__c> RARenewalProducts;
    static Relationship_Type__c packageRelationshipType;
    static Relationship_Type__c crossSellRelationshipType;
    static List<Contact> testContacts = new List<Contact>();
    static List<Task> tasksToCreate = new List<Task>();
    static List<Order__c> newOrders = new List<Order__c>();

    static Id relationshipTypeId;
    static Id renewalRelationshipTypeId;
    static Id packageRelationshipTypeId;

    static Product2 renewalProduct;
    static Product2 registerAgentProduct;

    final static String PRIMARY_CONTACT = 'Primary Contact';
    final static String PRODUCT_LINE = 'Test ProductLine';
    final static String REGISTERED_AGENT = 'Registered Agent';
    final static String THEPACKAGE = 'Package';
    final static String CROSS_SELL = 'Cross-Sell';
    final static String INC = 'Express Gold Incorporation';
    final static String AGENT1 = 'Agent 1';
    final static integer contactsSize = 10;
    final static integer taskSize = 1;
    final static integer orderSize = 2;
    final static integer orderItemSize = 10;

    static
    {
        OrderService.hasOrderMatchingTriggerRun = true;
        RARenewalProducts = new List<RA_Renewal_Product_Name__c>();
        RA_Renewal_Product_Name__c theRARenewalProduct = new RA_Renewal_Product_Name__c();
        theRARenewalProduct.Name = '1';
        theRARenewalProduct.Product_Name__c = 'RA Renewal - 1 year';
        RARenewalProducts.add(theRARenewalProduct);
        insert RARenewalProducts;


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

        Rematching_Days__c newDays = new Rematching_Days__c(Name = 'Number Of Days', Number_of_Days__c = 90);
        insert newDays;
    }
    static void setup_Data()
    {
        //insert account and contacts
        Account anotherAccount = TestUtils.createAccounts(1 , 'Test Account', true)[0];
        testContacts = TestUtils.createContacts(contactsSize , 'Test Contact', anotherAccount.Id, true);

        //create oma for inserted contacts
        tasksToCreate = new List<Task>();
        User testUser = TestUtils.createUser( 'Austin', TestUtils.STANDARD_PROFILE_ID , true);
        System.runAs(testUser)
        {
            for(Contact theContact : testContacts)
            {
                for(integer i = 0; i<taskSize; i++)
                {
                    Task theTask = TestUtils.createTasks(1 , null , false)[0];
                    theTask.whoId = theContact.Id;
                    theTask.Commission_Eligible__c = true;
                    tasksToCreate.add(theTask);
                }
            }
            insert tasksToCreate;
        }

        List<Order_Matching_Activity__c> createdOMA = [Select Order__c,Agent__c , Id  From Order_Matching_Activity__c Where Contact__c IN: testContacts];
        system.assertEquals(contactsSize*taskSize , createdOMA.size() , '20 OMA records should have been created');

        //insert orders
        newOrders = TestUtils.createOrders(contactsSize*orderSize , testProduct.Id ,  false);
        integer z = 0;
        for(Contact theContact : testContacts)
        {
            for(Integer i =0 ; i<orderSize; i++)
            {
                newOrders[z].OrderID__c = String.valueOf(z);
                newOrders[z].Name = String.valueOf(z);
                newOrders[z].User_Order_ID__c = String.valueOf(z);
                newOrders[z].Order_Date_Time_Created__c = DateTime.now().addHours(5);
                newOrders[z].Contact__c = theContact.Id;
                z++;
            }
        }
        insert newOrders;

        //create order items
        List<Order_Item__c> orderItemsToCreate = new List<Order_Item__c>();
        for(Order__c theOrder : newOrders)
        {
            for(Integer i =0 ; i<orderItemSize; i++)
            {
                Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
                theItem.Product__c = testProduct.Id;
                theItem.Relationship_Type__c = packageRelationshipType.Id;
                orderItemsToCreate.add(theItem);
            }
        }

        insert orderItemsToCreate;
    }

    static testMethod void testBatchSchedule() {
        Map<Id,List<Order_Matching_Activity__c>> contactToListOfOMA = new Map<Id, List<Order_Matching_Activity__c>>();
        setup_Data();

        OrderItemMatchingBatchScheduler oischedule = new OrderItemMatchingBatchScheduler();
        String cron = '0 0 22 1,15 * ?';
        //system.schedule('Scheduled Job', schedule , bch);
        //message = 'Job scheduled for 10pm on 1st and 15th of every month.';
        String jobId = System.schedule('OrderItemMatchingBatchScheduler', cron, oischedule);
    }

    static testMethod void testBatchJob() {
        setup_Data();
        test.startTest();
        String timeFrame = 'last_n_days:15'; //use Last_n_days:15 if we want run this for last 15 days
        OrderItemMatchingBatch theBatch = new OrderItemMatchingBatch(timeFrame);
        Id batchId = Database.executeBatch(theBatch , 50);
        test.stopTest();

    }
}