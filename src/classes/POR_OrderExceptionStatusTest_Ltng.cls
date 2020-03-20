@isTest
<<<<<<< HEAD
public  class POR_OrderExceptionStatusTest_Ltng {
    static Product2 testProduct;
    final static String PRODUCT_LINE = 'Intellectual Property';
    static Product_Line__c testProductLine;
    static Id relationshipTypeId;
    static Id exceptionId;
    static Id caseId;
    public static void dataSetup() {
        List<Account> testAcc = TestUtils.createAccounts(1, 'Smith', true);
        List<Contact> testCnt = TestUtils.createContacts(1, 'Smith', testAcc[0].Id, true);
        
        Customer_Login__c custLogin = new Customer_Login__c(name = 'AccountEmail@lz.com', Customer_ID__c = '12345678');
        insert custLogin;
        
        testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;
        
        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        
        testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
        testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        insert testProduct; 
        
        Order__c testOrder = TestUtils.createOrders(1 , testProduct.Id , true)[0];

        Order_Exception__c newExc = new Order_Exception__c();
        newExc.Order_Number__c = testOrder.Id;
        newExc.Processing_Number__c = '12345';
        insert newExc;
        exceptionId = newExc.Id;
        
        Failed_Rules__c rule1 = new Failed_Rules__c();
        rule1.Name = 'test';
        rule1.Parent_Exception__c = exceptionId;
        rule1.Description__c = 'Test';
        rule1.Rule_Type__c = 'Manual';
        insert rule1;
        Case testCase = TestUtils.createCases(1, false)[0];
        insert testCase;
        caseId = testCase.Id;
        /*
        Resources:
        JSON to string online converter -
        http://www.tools.knowledgewalls.com/jsontostring
        
        Online Multi Line to Single Line Converter -
        http://www.tools.knowledgewalls.com/onlinemultilinetosinglelineconverter
        */
        
        //testJSONstr = '"{ \"ordersComplete\": { \"success\": false } }"';
        
    }
    @isTest
    static void testLoadHoldStatusField() {
        dataSetup();
        POR_OrderExceptionStatusController_Ltng.loadHoldStatusField(exceptionId);
    }
    @isTest
    static void testLoadHoldStatusFieldFail() {
        dataSetup();
        POR_OrderExceptionStatusController_Ltng.loadHoldStatusField(null);
    }
    @isTest
    static void testCheckExistingCases() {
        dataSetup();
        POR_OrderExceptionStatusController_Ltng.checkExistingCases(caseId);
    }
    @isTest
    static void testCheckExistingCasesFail() {
        dataSetup();
        POR_OrderExceptionStatusController_Ltng.checkExistingCases(null);
    }
    @isTest
    static void testPutOnHold() {
        dataSetup();
        Test.startTest();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = 'test';
        mock.statusCode = 200;
        
        Test.setMock(HttpCalloutMock.class, mock);
        POR_OrderExceptionStatusController_Ltng.putOnHold(exceptionId);
        Test.stopTest();
    }
    @isTest
    static void testPutOnHoldFail() {
        dataSetup();
        POR_OrderExceptionStatusController_Ltng.putOnHold(null);
    }
    
    static testMethod void testRemoveFromHold() {
        dataSetup();
        IADOrderWithOrderItemsService_ltng lt= new IADOrderWithOrderItemsService_ltng();
        //IADServiceBase_ltng.APItoAsync.put(IADOrderWithOrderItemsService_ltng.GETORDERITEMRULESTATUS, true);
        //IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERITEMRULESTATUS);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        Map<String,Map<String,Object>> mapMap = new Map<String,Map<String,Object>>();
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('overallRuleStatus',(Object)'passed');
        mapMap.put('overallOrderRuleStatus',orderItemIdToPdtCnfgId);
        String JSONresponse = JSON.serialize(mapMap);
        
        mock.testBody = JSONresponse;
        mock.statusCode = 200;
        
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        POR_OrderExceptionStatusController_Ltng.removeFromHold(exceptionId);
        Test.stopTest();
    }
    @isTest
    static void testRemoveFromHoldFail() {
        dataSetup();
        POR_OrderExceptionStatusController_Ltng.removeFromHold(null);
    }
=======
public with sharing class POR_OrderExceptionStatusTest_Ltng {
	static Product2 testProduct;
	final static String PRODUCT_LINE = 'Intellectual Property';
	static Product_Line__c testProductLine;
	static Id relationshipTypeId;
	static Id exceptionId;
	static Id caseId;
	public static void dataSetup() {
		List<Account> testAcc = TestUtils.createAccounts(1, 'Smith', true);
	 	List<Contact> testCnt = TestUtils.createContacts(1, 'Smith', testAcc[0].Id, true);
		
		Customer_Login__c custLogin = new Customer_Login__c(name = 'AccountEmail@lz.com', Customer_ID__c = '12345678');
		insert custLogin;
		
		testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;
        
        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        
        testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
		testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        insert testProduct; 
		
		Order__c testOrder = TestUtils.createOrders(1 , testProduct.Id , true)[0];

		Order_Exception__c newExc = new Order_Exception__c();
        newExc.Order_Number__c = testOrder.Id;
        insert newExc;
		exceptionId = newExc.Id;
		
		Case testCase = TestUtils.createCases(1, false)[0];
        insert testCase;
        caseId = testCase.Id;
		/*
		Resources:
		JSON to string online converter -
		http://www.tools.knowledgewalls.com/jsontostring
		
		Online Multi Line to Single Line Converter -
		http://www.tools.knowledgewalls.com/onlinemultilinetosinglelineconverter
		*/
		
		//testJSONstr = '"{ \"ordersComplete\": { \"success\": false } }"';
		
	}
	@isTest
	static void testLoadHoldStatusField() {
		dataSetup();
		POR_OrderExceptionStatusController_Ltng.loadHoldStatusField(exceptionId);
	}
	@isTest
	static void testLoadHoldStatusFieldFail() {
		dataSetup();
		POR_OrderExceptionStatusController_Ltng.loadHoldStatusField(null);
	}
	@isTest
	static void testCheckExistingCases() {
		dataSetup();
		POR_OrderExceptionStatusController_Ltng.checkExistingCases(caseId);
	}
	@isTest
	static void testCheckExistingCasesFail() {
		dataSetup();
		POR_OrderExceptionStatusController_Ltng.checkExistingCases(null);
	}
	@isTest
	static void testPutOnHold() {
		dataSetup();
		POR_OrderExceptionStatusController_Ltng.putOnHold(exceptionId);
	}
	@isTest
	static void testPutOnHoldFail() {
		dataSetup();
		POR_OrderExceptionStatusController_Ltng.putOnHold(null);
	}
	@isTest
	static void testRemoveFromHold() {
		dataSetup();
		POR_OrderExceptionStatusController_Ltng.removeFromHold(exceptionId);
	}
	@isTest
	static void testRemoveFromHoldFail() {
		dataSetup();
		POR_OrderExceptionStatusController_Ltng.removeFromHold(null);
	}
>>>>>>> branch 'sead' of https://github.legalzoom.com/enterprise-applications/LZ-Salesforce/
    
}