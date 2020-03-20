@istest public class IADOrderPanelTest_ltng

{


    
    static testMethod void getOrders() {



        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789',FkUser__c='1245');
        insert con1;
        List<Order__c> ordersToInsert = new List<Order__c>();

        Order__c order1 = new Order__c(Name = '1000', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        ordersToInsert.add(order1);
        Order__c order2 = new Order__c(Name = '1100', Contact__c = con1.Id, State_of_Formation__c = '13', Entity_Name__c = '14', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 09, 12, 12, 01), User_Order_ID__c='123');
        ordersToInsert.add(order2);
        Order__c order3 = new Order__c(Name = '1200', Contact__c = con1.Id, State_of_Formation__c = '13', Entity_Name__c = '14', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 10, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 09, 12, 12, 01), User_Order_ID__c='1234');
        ordersToInsert.add(order3);
        insert ordersToInsert;

        List<Order_Item__c> oiToInsert = new List<Order_Item__c>();

        Order_Item__c orderItem1 = new Order_Item__c(Name = '1000', Order__c = order1.Id);
        oiToInsert.add(orderItem1);

        Order_Item__c orderItem2 = new Order_Item__c(Name = '1100', Order__c = order2.Id);
        oiToInsert.add(orderItem2);

        insert oiToInsert;

       IADOrderPanelController_ltng.getOrders(con1.id);

    }
    static testMethod void testPopulateincomplete()
    
    {
   getOrders();
      IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody ='{"processingOrders":[{"processingOrderId":2234486,"customerId":1788471,"processId":"7","questionnaireId":51,"lastPageVisited":0,"startDate":"2006-11-03T14:23:00Z","completedDate":"2006-11-06T08:52:00Z","firstCompletedDate":"2006-11-06T08:52:00Z","lastCompletedDate":"1900-01-01T00:00:00Z","stateId":52,"lastAccessedDate":"2006-11-03T14:23:00Z","reOpenedDate":"1900-01-01T00:00:00Z","isQuestionnaireCompleted":false,"isRevision":false,"processingStatusId":"91","isExpedited":null},{"processingOrderId":2234486,"customerId":"1788471","processId":"7","questionnaireId":"51","lastPageVisited":"1000","startDate":"2006-11-03T14:23:00Z","completedDate":"2006-11-06T08:52:00Z","firstCompletedDate":"2006-11-06T08:52:00Z","lastCompletedDate":"1900-01-01T00:00:00Z","stateId":"52","lastAccessedDate":"2006-11-03T14:23:00Z","reOpenedDate":"1900-01-01T00:00:00Z","isQuestionnaireCompleted":true,"isRevision":false,"processingStatusId":"91","isExpedited":null}]}';
          mock.statusCode = 200;
        Test.startTest();
        
         Test.setMock(HttpCalloutMock.class, mock);
        
       contact c = [select id from contact where firstname ='John'limit 1];
        IADOrderPanelController_ltng.populateIncompleteOrders(c.id);
        Test.stoptest();
    }
    
    static testMethod void testPopulateincompletenegative()
    
    {
   getOrders();
      IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = 'fault';
          mock.statusCode = 500;
        Test.startTest();
        
         Test.setMock(HttpCalloutMock.class, mock);
        
       contact c = [select id from contact where firstname ='John'limit 1];
        IADOrderPanelController_ltng.populateIncompleteOrders(c.id);
        Test.stoptest();
    }

     static testMethod void testPopulateincompletenegativecontact()
    
    {
   getOrders();
      IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
          mock.statusCode = 404;
        Test.startTest();
        
         Test.setMock(HttpCalloutMock.class, mock);
        
       contact c = [select id from contact where firstname ='John'limit 1];
        IADOrderPanelController_ltng.populateIncompleteOrders(c.id);
        Test.stoptest();
    }
    








}