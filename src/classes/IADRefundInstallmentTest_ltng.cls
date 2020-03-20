@istest private class IADRefundInstallmentTest_ltng
{
static Contact con;
    static Order__c order;

    public static void setupData() 


  {
        con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789');
        insert con;
        
        order = new Order__c(Name = '1000', OrderID__c = '1000', Contact__c = con.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order;
    }


 static testMethod void testGetOrderBalanceByOrderIdPositive(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETORDERBALANCESBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderBalanceResponse();
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADrefundInstallment_ltng.populateInstallments( '32546240');
    }
    
  static testMethod void testManualPostRefundPositiveCase()
    {
      setupData();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postRefundResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        Test.starttest();
        IADrefundInstallment_ltng.processRefund(order.id,'10');
        test.stoptest();
    }
    static testMethod void testGetOrderBalanceByOrderIdNegative(){
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETORDERBALANCESBYORDERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderBalanceResponse();
        mock.statusCode=400;
        Test.setMock(HttpCalloutMock.class, mock);        
        IADrefundInstallment_ltng.populateInstallments( '32546240');
    }
    
  static testMethod void testManualPostRefundNegativeCase()
    {
      setupData();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postRefundResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        Test.starttest();
        IADrefundInstallment_ltng.processRefund(order.id,'10');
        test.stoptest();
    }

}