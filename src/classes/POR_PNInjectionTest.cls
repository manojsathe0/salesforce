@isTest
public without sharing class POR_PNInjectionTest {
	public static String testJSONstr;
    public static String testJSONstr2;
    public static String testJSONstr3;
	static List<Order__c> testOrders;
    static List<Order_Item__c> orderItems;
	static Product2 testProduct;
	final static String PRODUCT_LINE = 'Intellectual Property';
	static Product_Line__c testProductLine;
	static Id relationshipTypeId;
    public static void dataSetup() {
		List<Account> testAcc = TestUtils.createAccounts(1, 'Smith', true);
	 	List<Contact> testCnt = TestUtils.createContacts(1, 'Smith', testAcc[0].Id, true);
		
		Customer_Login__c custLogin = new Customer_Login__c(name = 'AccountEmail@lz.com', Customer_ID__c = '12345678');
		insert custLogin;
		
		testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;
        
        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        
        testProduct = TestUtils.createProducts(1 , 'LWT', false)[0];
		testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        insert testProduct; 
		
		testOrders = TestUtils.createOrders(1 , testProduct.Id , false);
		for (Order__c thisOrder : testOrders) {
			thisOrder.Name = '12345';
			thisOrder.User_Order_ID__c = '54321';
			thisOrder.Contact__c = testCnt[0].Id;
		}
		insert testOrders;

		orderItems = TestUtils.createOrderItems(1 , testOrders[0].Id, false);
        
        for (Order_Item__c orderItem : orderItems) {
            orderItem.User_Order_ID__c = '123456';
            orderItem.Product__c = testProduct.Id;
            orderItem.Name = '1234';
        }
        try {
            insert orderItems;
        }
        catch(Exception e) {
            System.debug(e);
        }


        

        
		/*
		Resources:
		JSON to string online converter -
		http://www.tools.knowledgewalls.com/jsontostring
		
		Online Multi Line to Single Line Converter -
		http://www.tools.knowledgewalls.com/onlinemultilinetosinglelineconverter
		*/
		
		//testJSONstr = '"{ \"ordersComplete\": { \"success\": true } }"';
		testJSONstr = '{ \"ordersComplete\": { \"success\": true } }';
	}
	@isTest
	static void testGetOrderData() {
		dataSetup();
		POR_PNInjectionButtonController_Ltng.getOrderData(orderItems[0].Id);
        POR_DDSWorkflowOrderInjectionService.orderNumber = 'test';
        POR_DDSWorkflowOrderInjectionService.processingNumber = 'test';
        //POR_DDSWorkflowOrderInjectionService.InjectionResponseWrapper test = new POR_DDSWorkflowOrderInjectionService.InjectionResponseWrapper();
        //test.ordersComplete.sucess = false;
	}
    @isTest
	static void testCheckIfRelaunchEligible() {
		dataSetup();
		POR_PNInjectionButtonController_Ltng.checkIfRelaunchEligible(orderItems[0].Id);
	}
	@isTest
	static void testInjectProcessingNumber() {
		dataSetup();
		IADTestMockGenerator mock = new IADTestMockGenerator();
    	mock.testBody = testJSONstr;
    	mock.statusCode = 200;
		
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
        POR_PNInjectionButtonController_Ltng.orderName = 'Order';
        POR_PNInjectionButtonController_Ltng.TriggerDDS('12345', '54321');
		POR_PNInjectionButtonController_Ltng.injectProcessingNumber('12345', '54321', '54321');
        Test.stopTest();
	}
	@isTest
	static void testInjectProcessingNumberFail1() {
		dataSetup();
		POR_PNInjectionButtonController_Ltng.injectProcessingNumber(null, null, null);
	}
    
    @isTest
	static void testInjectProcessingNumberFail2() {
		dataSetup();
		IADTestMockGenerator mock = new IADTestMockGenerator();
    	mock.testBody = '"{ \"ordersComplete\": { \"success\": true } }"';
    	mock.statusCode = 200;
		
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
        POR_PNInjectionButtonController_Ltng.orderName = 'Order';
        POR_PNInjectionButtonController_Ltng.TriggerDDS('12345', '54321');
		POR_PNInjectionButtonController_Ltng.injectProcessingNumber('12345', '54321', '54321');
        Test.stopTest();
	}
    @isTest
	static void testInjectProcessingNumberFail3() {
		dataSetup();
		IADTestMockGenerator mock = new IADTestMockGenerator();
    	mock.testBody = '{ \"ordersComplete\": { \"success\": false } }';
    	mock.statusCode = 200;
		
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
        POR_PNInjectionButtonController_Ltng.orderName = 'Order';
        POR_PNInjectionButtonController_Ltng.TriggerDDS('12345', '54321');
		POR_PNInjectionButtonController_Ltng.injectProcessingNumber('12345', '54321', '54321');
        Test.stopTest();
	}
	@isTest
	static void testInjectProcessingNumberFail4() {
		dataSetup();
		IADTestMockGenerator mock = new IADTestMockGenerator();
    	mock.testBody = '"{ \"ordersComplete\": { \"success\": true } }"';
    	mock.statusCode = 500;
		
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
        POR_PNInjectionButtonController_Ltng.orderName = 'Order';
        POR_PNInjectionButtonController_Ltng.TriggerDDS('12345', '54321');
		POR_PNInjectionButtonController_Ltng.injectProcessingNumber('12345', '54321', '54321');
        Test.stopTest();
	}
	
}