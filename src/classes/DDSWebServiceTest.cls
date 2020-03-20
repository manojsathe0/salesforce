/*
Test coverage for DDSWebService class.
Created by: Artyom M.
Per story: B-24116
*/

@isTest
public with sharing class DDSWebServiceTest {
	public static String testJSONstr;
	static List<Order__c> testOrders;
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
        
        testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
		testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        insert testProduct; 
		
		testOrders = TestUtils.createOrders(1 , testProduct.Id , false);
		for (Order__c thisOrder : testOrders) {
			thisOrder.Name = '12345';
			thisOrder.Contact__c = testCnt[0].Id;
		}
		insert testOrders;
		
		/*
		Resources:
		JSON to string online converter -
		http://www.tools.knowledgewalls.com/jsontostring
		
		Online Multi Line to Single Line Converter -
		http://www.tools.knowledgewalls.com/onlinemultilinetosinglelineconverter
		*/
		testJSONstr = '{ \"CaseId\":\"005G0000996V5KL\", \"firstName\":\"John\", \"lastName\":\"Doe\", \"uuid\": \"aafc2e65-2868-4b9a-8abd-ca69804b42e3\", \"email\": \"johndoe@yahoo.com\", \"customerId\": \"123987635\", \"phone\": \"5555555555\", \"OrderNumber\":\"12345\", \"Processing Number\":\"2345678\", \"CustomerLogin\":\"AccountEmail@lz.com\", \"ValidatedRules\": [ { \"Description\": \"View Compliance Calendar\" }, { \"Description\": \"View Completed Orders\"}, { \"Description\": \"Print Invoice\"}, { \"Description\": \"Set up Attorney/Tax Consultation\"}, { \"Description\": \"Company Profile\"}, { \"Description\": \"Account Profile\"}, { \"Description\": \"Make a Payment\"} ] }';
		
		
	}
	
	@isTest
	static void testCreateCaseSuccess() {
		dataSetup();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
		req.requestURI = '/services/apexrest/DDSWebService/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstr);

        Test.startTest();
	        RestContext.request = req;
	        RestContext.response = res;
	
	        DDSWebService.createCase();
	
	        System.debug(req);
	        System.debug(res);
	
        Test.stopTest();
	}
	
	@isTest
	static void testCreateCaseNoSuccess() {
		dataSetup();
		RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
		req.requestURI = '/services/apexrest/DDSWebService/';
        req.httpMethod = 'POST';
        
        Test.startTest();
        	req.requestBody = Blob.valueOf(testJSONstr);

        
	        RestContext.request = req;
	        RestContext.response = res;
	
	        DDSWebService.createCase();
	
	        System.debug(req);
	        System.debug(res);
	        
	        req.requestBody = Blob.valueOf(testJSONstr);

        
	        RestContext.request = req;
	        RestContext.response = res;
	
	        DDSWebService.createCase();
	
	        System.debug(req);
	        System.debug(res);
        
        	req.requestBody = Blob.valueOf('{}');

        
	        RestContext.request = req;
	        RestContext.response = res;
	
	        DDSWebService.createCase();
	
	        System.debug(req);
	        System.debug(res);
	
        	req.requestBody = Blob.valueOf('');

        
	        RestContext.request = req;
	        RestContext.response = res;
	
	        DDSWebService.createCase();
	
	        System.debug(req);
	        System.debug(res);
        
        
        	req.requestBody = Blob.valueOf('empty');

        
	        RestContext.request = req;
	        RestContext.response = res;
	
	        DDSWebService.createCase();
	
	        System.debug(req);
	        System.debug(res);
	
        
        
        	req.requestBody = Blob.valueOf('{"orderNumber" : 123453}');

        
	        RestContext.request = req;
	        RestContext.response = res;
	
	        DDSWebService.createCase();
	
	        System.debug(req);
	        System.debug(res);
	
        Test.stopTest();
	}
    
}