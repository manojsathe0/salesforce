@isTest
private class IADOrderSearchController_LtngTest{
    static Contact con;
    static Order__c order;
    
    public static void setupData() 
    {
        con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', FkUser__c = '1234');
        insert con;
        
        order = new Order__c(Name = '32549427', OrderID__c = '32549427', Contact__c = con.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order;
    }
    
    static testMethod void testCreateNewOrder(){ 
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderSearchController_Ltng.createNewOrder('32549427', '1234');
    }
    
    static testMethod void testValidateOrderByOrderId(){
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderSearchController_Ltng.validateOrderByOrderId('32549427');
    }
    
    static testMethod void testValidateOrderByOrderIdNegative(){
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderResponse();
        mock.statusCode = 500;
        Test.setMock(HttpCalloutMock.class, mock);
        IADOrderSearchController_Ltng.validateOrderByOrderId('');
    }
}