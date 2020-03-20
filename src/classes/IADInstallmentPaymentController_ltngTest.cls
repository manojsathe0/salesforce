@isTest
private class IADInstallmentPaymentController_ltngTest 
{    
    static Contact con;
    static Order__c order;

    public static void setupData() 
    {
        con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', FKUser__c='1234');
        insert con;
        
        order = new Order__c(Name = '1000', OrderID__c = '1000', Contact__c = con.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order;
    }
    
    static testMethod void testInitCrl()
    {
        IADInstallmentPaymentController_ltng theController = new IADInstallmentPaymentController_ltng();
        Map<String, String> payReasons = IADInstallmentPaymentController_ltng.paymentReasons;
        IADInstallmentPaymentController_ltng.initCtrl('1234', '4567910', 'Installment', '1234');
    }
    
    static testMethod void testPopulateOrderBalancePositive()
    {
        IADInstallmentPaymentController_ltng theController = new IADInstallmentPaymentController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderBalanceResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentPaymentController_ltng.populateOrderBalances('1234');
    }
    
    static testMethod void testPopulateOrderBalanceNegative()
    {
        IADInstallmentPaymentController_ltng theController = new IADInstallmentPaymentController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderBalanceResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentPaymentController_ltng.populateOrderBalances('');
    }
    
    static testMethod void testPostPaymentInstallmentPositive()
    {
        IADInstallmentPaymentController_ltng theController = new IADInstallmentPaymentController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postPaymentResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentPaymentController_ltng.postPayment('1234', 10.50, 10.50, 'Installment', '0', 'test', 'pp123443', 'test@test.com', '1234' ,'12','1','1','1');
    }
    
    static testMethod void testPostPaymentNonInstallmentPositive()
    {
        IADInstallmentPaymentController_ltng theController = new IADInstallmentPaymentController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postPaymentResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentPaymentController_ltng.postPayment('1234', 10.50, 10.50, 'Payment', '0', 'test', 'pp123443', 'test@test.com', '1234','12','1','1','1');
    }
    
    static testMethod void testPostPaymentSCPositive()
    {
        IADInstallmentPaymentController_ltng theController = new IADInstallmentPaymentController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postPaymentStoreCreditResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentPaymentController_ltng.postPayment('1234', 10.50, 10.50, 'StoreCredit', '0', 'test', 'sc123443', 'test@test.com', '1234','12','1','1','1');
    }
        
    static testMethod void testPopulateProfilesPositiveCase1()
    {
        IADInstallmentPaymentController_ltng theController = new IADInstallmentPaymentController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentProfileResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentPaymentController_ltng.populateProfiles('11596577','Installment');
    }
    
    static testMethod void testPopulateProfilesPositiveCase2()
    {
        IADInstallmentPaymentController_ltng theController = new IADInstallmentPaymentController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentProfileResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentPaymentController_ltng.populateProfiles('11596577','MakePayment');
    }
    
    static testMethod void testPopulateInstallmentsPositive()
    {
        setupData();
        Test.startTest();
        IADInstallmentsPanelController_Ltng theController = new IADInstallmentsPanelController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getInstallmentsResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentsPanelController_Ltng.populateInstallments(String.valueOf(order.Id));
        Test.stopTest();
    }
    
    static testMethod void testPopulateInstallmentsNegative()
    {
        IADInstallmentsPanelController_Ltng theController = new IADInstallmentsPanelController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getInstallmentsResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentsPanelController_Ltng.populateInstallments('');
    }
    
    static testMethod void testPopulatePaymentsPositive()
    {
        setupData();
        Test.startTest();
        IADPendingPaymentsPanelController_Ltng theController = new IADPendingPaymentsPanelController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentsByOrderIdResponse(2);
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADPendingPaymentsPanelController_Ltng.populatePayments(String.valueOf(order.Id));
        Test.stopTest();
    }
    
    static testMethod void testPopulatePaymentsNegative()
    {
        setupData();
        Test.startTest();
        IADPendingPaymentsPanelController_Ltng theController = new IADPendingPaymentsPanelController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentsByOrderIdResponse(2);
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADPendingPaymentsPanelController_Ltng.populatePayments('');
        Test.stopTest();
    }
    
    static testMethod void testPopulatePaymentProfilePositive()
    {
        setupData();
        Test.startTest();
        IADPaymentProfileLabelController_ltng theController = new IADPaymentProfileLabelController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentProfileResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADPaymentProfileLabelController_ltng.populatePaymentProfile('27756997');
        Test.stopTest();
    }
    
    static testMethod void testPopulatePaymentProfileNegative()
    {
        setupData();
        Test.startTest();
        IADPaymentProfileLabelController_ltng theController = new IADPaymentProfileLabelController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getPaymentProfileResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        IADPaymentProfileLabelController_ltng.populatePaymentProfile('');
        Test.stopTest();
    }
    static testMethod void testPostPaymentInstallmentPositiveManual()
    {
        IADInstallmentPaymentController_ltng theController = new IADInstallmentPaymentController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.postPaymentResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        IADInstallmentPaymentController_ltng.postPayment('1234', 10.50, 10.50, 'Installment', '0', 'test', 'manual', 'test@test.com', '1234' ,'12','1','1','1');
    }
}