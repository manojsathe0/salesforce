@isTest
private class IADStoreCreditPanelController_LtngTest {
	static Contact con;
    static Order__c order;

    public static void setupData() 
    {
        con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', FKUser__c='1234', LegalZoom_Contact_ID__c='1234', LZ_Order_Contact_ID__c = '1234');
        insert con;
        
        order = new Order__c(Name = '1000', OrderID__c = '1000', Contact__c = con.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order;
    }   
    
    static testMethod void testPopulateStoreCreditsPositive()
    {
        setupData();
        Test.startTest();
        IADStoreCreditPanelController_Ltng theController = new IADStoreCreditPanelController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getStoreCreditsByCustomerId();
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
		IADStoreCreditPanelController_Ltng.populateStoreCredits(String.valueOf(order.Id));
        Test.stopTest();
	}
    
    static testMethod void testPopulateStoreCreditsNegative()
    {
        setupData() ;
        Test.startTest();
        IADStoreCreditPanelController_Ltng theController = new IADStoreCreditPanelController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil_ltng.getStoreCreditsByCustomerId();
        mock.statusCode = 404;
        Test.setMock(HttpCalloutMock.class, mock);
		IADStoreCreditPanelController_Ltng.populateStoreCredits(String.valueOf(order.Id));
        Test.stopTest();
	}
    static testMethod void testPopulateStoreCreditsNegativenull()
    {
        setupData() ;
        Test.startTest();
        IADStoreCreditPanelController_Ltng theController = new IADStoreCreditPanelController_Ltng();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '';
        mock.statusCode = 200;
        Test.setMock(HttpCalloutMock.class, mock);
		IADStoreCreditPanelController_Ltng.populateStoreCredits(String.valueOf(order.Id));
        Test.stopTest();
	}
}