@isTest
private class IADEditShippingAddressCtrl_ltngTest {
    static Contact con;
    static Order__c order;

    public static void setupData() 
    {
        con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', FKUser__c='1234', LegalZoom_Contact_ID__c='1234', LZ_Order_Contact_ID__c = '1234');
        insert con;
        
        order = new Order__c(Name = '1000', OrderID__c = '1000', Contact__c = con.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order;
    }
    
    static testMethod void testInitCrl()
    {
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADEditShippingAddressController_ltng.init('1234', '123456', true);
	}
    
    static testMethod void testPopulateShippingAddressPositive()
    {
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderContactsResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
		IADEditShippingAddressController_ltng.populateShippingAddress('1234', '123456', true);
	}
    
    static testMethod void testPopulateShippingAddressNegative()
    {
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderContactsResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
		IADEditShippingAddressController_ltng.populateShippingAddress('', '', false);
	}
    static testMethod void testPopulateShippingAddressNegative1()
    {
        Test.startTest();
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderContactsResponse();
        mock.statusCode = 500;
        Test.setMock(HttpCalloutMock.class, mock);
		IADEditShippingAddressController_ltng.populateShippingAddress('12347', '1234568', true);
        Test.stopTest();
	}
    static testMethod void testPopulateShippingAddressNegative2()
    {
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = null;
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
		IADEditShippingAddressController_ltng.populateShippingAddress('1234', '123456', true);
	}
    static testMethod void testUpdateContactPositive()
    {
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderContactsResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String, Object> localContact = IADTestDataUtil_ltng.getLocalContactResponseMap1();
		IADEditShippingAddressController_ltng.updateContact('1234', '123456', true, localContact);
	}
    
    static testMethod void testUpdateContactNegative()
    {
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderContactsResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String, Object> localContact = IADTestDataUtil_ltng.getLocalContactResponseMap2();
		IADEditShippingAddressController_ltng.updateContact('', '', false, localContact);
	}
    
    static testMethod void testCreateContactPositive()
    {
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderContactsResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String, Object> localContact = IADTestDataUtil_ltng.getLocalContactResponseMap1();
		IADEditShippingAddressController_ltng.createContact('1234', '123456', true, localContact);
	}
    
    static testMethod void testCreateContactNegative()
    {
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderContactsResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String, Object> localContact = IADTestDataUtil_ltng.getLocalContactResponseMap1();
		IADEditShippingAddressController_ltng.createContact('', '', false, localContact);
	}
    
    static testMethod void testCreateContactNegative1()
    {
        /*
        */
        IADTestMockGenerator mock = new IADTestMockGenerator();
        String str = null;
        mock.testBody = str;
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, new IADTestMockGenerator());
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        Map<String, Object> localContact = IADTestDataUtil_ltng.getLocalContactResponseMap1();
		IADEditShippingAddressController_ltng.createContact('1234', '123456', true, localContact);

        //IADEditShippingAddressService_ltng.readCreateOrderContactResponse();
	}
    static testMethod void testCreateContactNegative2()
    {
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderContactsResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String, Object> localContact = IADTestDataUtil_ltng.getLocalContactResponseMap2();
		IADEditShippingAddressController_ltng.createContact('1234', '123456', true, localContact);
	}
    static testMethod void testDeleteContactPositive()
    {
        setupData();
        Test.startTest();
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderContactsResponse();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
		IADEditShippingAddressController_ltng.deleteContact('1234', '1234');
        Test.stopTest();
	}
    
    static testMethod void testDeleteContactNegative()
    {
        setupData();
        Test.startTest();
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderContactsResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
		IADEditShippingAddressController_ltng.deleteContact('', '');
        Test.stopTest();
	}
    static testMethod void testDeleteContactNegative1()
    {
        setupData();
        Test.startTest();
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock1 = new IADTestMockGenerator();
        mock1.testBody = null;//'{"":""}';//IADTestDataUtil_ltng.getOrderContactsResponse();
        mock1.statusCode = 400;
        Test.setMock(HttpCalloutMock.class, mock1);
		IADEditShippingAddressController_ltng.deleteContact('1234', '1234');
        Test.stopTest();
	}
    static testMethod void testDeleteContactNegative2()
    {
        setupData();
        Test.startTest();
        IADEditShippingAddressController_ltng theController = new IADEditShippingAddressController_ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getOrderContactsResponse();
        mock.statusCode = 501;
        Test.setMock(HttpCalloutMock.class, mock);
		IADEditShippingAddressController_ltng.deleteContact('1234', '1234');
        Test.stopTest();
	}
   
}