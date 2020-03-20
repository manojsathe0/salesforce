@isTest
private class IADRefundController_ltngTest {
    static Contact con;
    static Order__c order;
    static Customer_Login__c customerLogin;
    
    public static void setupData() 
    {
        con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', FKUser__c='1234');
        insert con;
        
        customerLogin = new Customer_Login__c(Name = 'abcd@abcd.com', customer_ID__c = '1234', Primary_Contact__c = con.Id);
        insert customerLogin;
        
        order = new Order__c(Name = '1000', OrderID__c = '1000', Contact__c = con.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order;
    }
    
    static testMethod void testInitCrl()
    {
        setupData();
        IADRefundController_ltng theController = new IADRefundController_ltng();
        Map<String, String> payReasons = IADRefundController_ltng.refundReasons;
        IADRefundController_ltng.initCtrl('123', '4567910', '1234', 'MakeRefund', '4567910');
    }
    
    static testMethod void testPopulateRefundOptionsPositive()
    {
        IADRefundController_ltng theController = new IADRefundController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentProfileResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADRefundController_ltng.populateRefundOptions('1234', 'MakeRefund');
    }
    
    static testMethod void testGetOrderBalanceByOrderIdPositive()
    {
        IADRefundController_ltng theController = new IADRefundController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderBalanceResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADRefundController_ltng.getOrderBalanceByOrderId('1234');
    }
    
    static testMethod void testGetOrderBalanceByOrderIdNegative()
    {
        IADRefundController_ltng theController = new IADRefundController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderBalanceResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADRefundController_ltng.getOrderBalanceByOrderId('');
    }
    
    static testMethod void testGetPaymentProfilesByUserIdPositive()
    {
        IADRefundController_ltng theController = new IADRefundController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentProfileByCustomerIdResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADRefundController_ltng.getPaymentProfilesByUserId('1234', '232');
    }
    
    static testMethod void testGetPaymentProfilesByUserIdNegative()
    {
        IADRefundController_ltng theController = new IADRefundController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentProfileByCustomerIdResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADRefundController_ltng.getPaymentProfilesByUserId('', '');
    }
    
    static testMethod void testPostRefundPositiveCase1()
    {
        IADRefundController_ltng theController = new IADRefundController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postRefundResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        //IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'StoreCredit', 'Test', '0', 'abcd@abcd.com', '23456', 'StoreCredit', '2345','test1','test1','test1','test1','test1','test1','test1','test1');/*Commeneted For STORY B-39538*/
        IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'StoreCredit', 'Test', '0', 'abcd@abcd.com', '23456', 'StoreCredit', '2345','test1','test1','test1','test1','test1','test1','test1','test1','test1');/*Added For STORY B-39538*/
    }
    
    static testMethod void testPostRefundPositivecase2()
    {
        IADRefundController_ltng theController = new IADRefundController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postRefundResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        //IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'StoreCredit', 'Test', '0', 'abcd@abcd.com', '23456', 'XYZ', '2345','test1','test1','test1','test1','test1','test1','test1','test1');/*Commeneted For STORY B-39538*/
        IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'StoreCredit', 'Test', '0', 'abcd@abcd.com', '23456', 'XYZ', '2345','test1','test1','test1','test1','test1','test1','test1','test1','test1');/*Added For STORY B-39538*/
    }
    
    static testMethod void testPostRefundPositivecase3()
    {
        IADRefundController_ltng theController = new IADRefundController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postRefundResponse();
        mock.statusCode = 201;
        Test.setMock(HttpCalloutMock.class, mock);
        //IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'refundToStoreCredit', 'Test', '0', 'abcd@abcd.com', '23456', 'refundToStoreCredit', '2345','test1','test1','test1','test1','test1','test1','test1','test1');/*Commeneted For STORY B-39538*/
        IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'refundToStoreCredit', 'Test', '0', 'abcd@abcd.com', '23456', 'refundToStoreCredit', '2345','test1','test1','test1','test1','test1','test1','test1','test1','test1');/*Added For STORY B-39538*/
    }
    
    static testMethod void testManualPostRefundPositiveCase()
    {
        IADRefundController_ltng theController = new IADRefundController_ltng();
        Map<decimal, String> states= IADRefundController_ltng.states;
        Map<String, String> manualrefundReasons= IADRefundController_ltng.manualrefundReasons;
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postRefundResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        //IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'manualCheck', 'Test', '0', 'abcd@abcd.com', '23456', 'manual', '2345','test1','test1','test1','test1','test1','test1','1','23');/*Commeneted For STORY B-39538*/
        IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'manualCheck', 'Test', '0', 'abcd@abcd.com', '23456', 'manual', '2345','test1','test1','test1','test1','test1','test1','1','23','test1');/*Added For STORY B-39538*/
    }
    
    static testMethod void testManualPostRefundnegativeCase()
    {
        IADRefundController_ltng theController = new IADRefundController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postRefundResponse();
        mock.statusCode = 404;
        Test.setMock(HttpCalloutMock.class, mock);
        //IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'manualCheck', 'Test', '0', 'abcd@abcd.com', '23456', 'manual', '2345','test1','test1','test1','test1','test1','test1','1','23');/*Commeneted For STORY B-39538*/
        IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'manualCheck', 'Test', '0', 'abcd@abcd.com', '23456', 'manual', '2345','test1','test1','test1','test1','test1','test1','1','23','test1');/*Added For STORY B-39538*/
    }
    
    static testMethod void testManualPostRefundSCtoMC()
    {
        IADRefundController_ltng theController = new IADRefundController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postRefundResponse();
        mock.statusCode = 404;
        Test.setMock(HttpCalloutMock.class, mock);
        //IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'StoreCreditToMC', 'Test', '0', 'abcd@abcd.com', '23456', 'StoreCreditToMC', '2345','test1','test1','test1','test1','test1','test1','1','23');/*Commeneted For STORY B-39538*/
        IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'StoreCreditToMC', 'Test', '0', 'abcd@abcd.com', '23456', 'StoreCreditToMC', '2345','test1','test1','test1','test1','test1','test1','1','23','test1');/*Added For STORY B-39538*/
    }
      /*Added For STORY B-39538 - To Increase Existing Code Coverage*/
    static testMethod void testRefundStoreCreditToMC(){        
        IADRefundController_ltng theController = new IADRefundController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postRefundResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADRefundController_ltng.processRefund(10.00, 10.00, '232', '1234', 'StoreCredit', 'Test', '0', 'abcd@abcd.com', '23456', 'StoreCreditToMC', '2345','test1','test1','test1','test1','test1','test1','test1','test1','test1');
        IADRefundController_ltng.constructRefundRequestSCToMC('11111','12222','13.0','test1',8977,'hars','hars','adffff','Round Rock',1,'78664','hars@test.com');
    }
}