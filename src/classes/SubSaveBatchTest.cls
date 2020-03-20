@isTest
private class SubSaveBatchTest 
{
    public static List<Order__c> newOrders = new List<Order__c>();
    public static List<Order_Item__c> orderItemsToinsert = new List<Order_Item__c>();
    public static List<Order_Matching_Activity__c> omasToInsert = new List<Order_Matching_Activity__c>();
    public static Customer_Login__c newCustomerLogin = new Customer_Login__c();
    public static Contact newContact = new Contact();
    public static Id relationshipTypeId;
    public static Process__c newProcess;
    public static Product2 newProduct;
    public static Relationship_Type__c relationshipTypeId_Revised;
    public final static Integer SIZE = 1;

     public static void setupData()
    {
        //insert custom seetings for subscription days
        ss_days__c ssSaveSetting = new ss_days__c(
            Name = '1');
        insert ssSaveSetting;

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

        //create new product
        List<Product2> newProducts = TestUtils.createProducts(1 , '', false);
        newProducts[0].Name = ProblemOrderConstants.POA;
        newProducts[0].Relationship_Type__c = relationshipTypeId;
        newProducts[0].Process__c = newProcess.Id;
        insert newProducts;

     
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


        for(Order__c theOrder : newOrders)
        {
            Order_Item__c newOrderItem = new Order_Item__c();
            newOrderItem.Order__c = theOrder.Id;
            newOrderItem.Product__c = newProducts[0].Id;
            newOrderItem.User_Order_ID__c = theOrder.User_Order_ID__c;
            newOrderItem.Subscription_Status__c = 'Active';
            orderItemsToinsert.add(newOrderItem);

            Order_Matching_Activity__c newOma = new Order_Matching_Activity__c();
            newOma.Order__c = theOrder.Id;
            newOma.Is_Subscription_Activity__c = true;
            omasToInsert.add(newOma);

        }
        insert orderItemsToinsert;
        insert omasToInsert;
    }

    static testmethod void sunsave30DayAllSave_Test()
    {
        setupData();
        integer i = 0;
        Map<Id,Id> omaIdToOrderId = new Map<Id,Id>();

        for(Order_Matching_Activity__c theOma : omasToInsert)
            omaIdToOrderId.put(theOma.Order__c , theOma.Id);

        List<Order360__c> recordsToInsert = new List<Order360__c>();
        for(Order_Item__c theOrderItem : orderItemsToinsert)
        {
            Order360__c newOrder360 = new Order360__c();
            newOrder360.createdDate = system.today().addDays(-1);
            newOrder360.LZ_Order_Item_Id__c = '000101'+i;
            newOrder360.Order__c = theOrderItem.Order__c;
            newOrder360.Parent_Order_Item__c = theOrderItem.Id;
            newOrder360.Order_Matching_Activity__c = omaIdToOrderId.get(theOrderItem.Order__c);
            recordsToInsert.add(newOrder360);
            i++;
        }

        insert recordsToInsert;

        Test.startTest();
            Database.executeBatch(new SubSave30DayBatch(),1);
        Test.stopTest();

        List<Order360__c> updatedOrder360 = [Select Id, Subscription_Saved__c From Order360__c where Id in: recordsToInsert];
        for(Order360__c theOrder360 : updatedOrder360)
        {
            system.assertEquals(true , theOrder360.Subscription_Saved__c , 'Subscription should have been saved since all subscription order items are active');
        }
    }

     static testmethod void sunsave30DayPartialSave_Test()
    {
        setupData();
        integer count = 0;
        Map<Id,Id> omaIdToOrderId = new Map<Id,Id>();
        List<Id> cancelledItems = new List<Id>();
        List<Id> savedItems = new List<Id>();

        for(Order_Matching_Activity__c theOma : omasToInsert)
            omaIdToOrderId.put(theOma.Order__c , theOma.Id);

        List<Order360__c> recordsToInsert = new List<Order360__c>();
        for(Order_Item__c theOrderItem : orderItemsToinsert)
        {
            Order360__c newOrder360 = new Order360__c();
            newOrder360.createdDate = system.today().addDays(-1);
            newOrder360.LZ_Order_Item_Id__c = '000101'+count;
            newOrder360.Order__c = theOrderItem.Order__c;
            newOrder360.Parent_Order_Item__c = theOrderItem.Id;
            newOrder360.Order_Matching_Activity__c = omaIdToOrderId.get(theOrderItem.Order__c);
            recordsToInsert.add(newOrder360);
            count++;
        }
        insert recordsToInsert;

        for(integer i=0 ; i< orderItemsToinsert.size()/2 ; i++)
        {
            orderItemsToinsert[i].Subscription_Status__c = 'Cancelled';
            cancelledItems.add(orderItemsToinsert[i].Id);
        }

        for(integer i=orderItemsToinsert.size()/2 ; i< orderItemsToinsert.size() ; i++)
        {
            savedItems.add(orderItemsToinsert[i].Id);
        }

        String CRON_EXP = '0 0 0 15 3 ? 2022';
        Test.startTest();
            System.schedule('Sub Save 30 day batch', CRON_EXP, new SubSave30DayScheduler());
        Test.stopTest();

        List<Order360__c> savedOrder360 = [Select Id, Subscription_Saved__c From Order360__c where Order_Matching_Activity__r.Id in: savedItems];
        for(Order360__c theOrder360 : savedOrder360)
        {
            system.assertEquals(true , theOrder360.Subscription_Saved__c , 'Subscription should have been saved since all subscription order items are active');
        }

        List<Order360__c> cancelledOrder360 = [Select Id, Subscription_Saved__c From Order360__c where Order_Matching_Activity__c in: cancelledItems];
        for(Order360__c theOrder360 : cancelledOrder360)
        {
            system.assertEquals(false , theOrder360.Subscription_Saved__c , 'Subscription should have been cancelled ');
        }
    }
}