@istest
public class IADOrdersGridControllerTest_ltng {
    
     @isTest static void setupData()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];

        system.runAs(u)
        {

            Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

            Order__c order1 = new Order__c( OrderID__c = '12345', Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }

    }
    @isTest static void testGetOrders()
    {
        setupData();

       

        Contact con1 = [select id, fkUser__c from Contact where fkUser__c = '1234' limit 1];
        

IADInstallmentController_ltng  inst = new  IADInstallmentController_ltng ();
        IADTestMockGenerator mock = new IADTestMockGenerator();
      mock.testBody =  IADTestDataUtil.getOrdersResponse();
      mock.statusCode=200;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, mock);
       IADOrdersGridController_ltng.populateOrders(con1.FkUser__c);
        
IADContractBeans_ltng.IADOrderBean orderBean = new IADContractBeans_ltng.IADOrderBean();
        orderBean.orderId = '12345';
        List<IADContractBeans_ltng.IADOrderItem> orderItems = new List<IADContractBeans_ltng.IADOrderItem>();
        IADContractBeans_ltng.IADOrderItem orderItem = new IADContractBeans_ltng.IADOrderItem();
        orderItem.processingOrder = new IADContractBeans_ltng.ProcessingOrder();
        orderItem.processingOrder.processingOrderId = '12345';
        orderItems.add(orderItem);
        orderBean.orderItems = orderItems;
        IADOrdersGridController_ltng.orderIdToOrderMap.put('1234', orderBean);
        
        IADOrdersGridController_ltng.createOrder('1234', Json.serialize(IADOrdersGridController_ltng.orderIdToOrderMap),'1234');
        test.stopTest();



    }


}