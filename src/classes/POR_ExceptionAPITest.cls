/*
Test coverage for POR_ExceptionAPI class.
Created by: Artyom M.
Per story: B-24116
*/

@isTest
public with sharing class POR_ExceptionAPITest {
    public static String testJSONstr;
    public static String testJSONstr2;
    public static String testJSONstr3;
    public static String dupCorrel;
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
        //testJSONstr = '{ \"CaseId\":\"005G0000996V5KL\", \"firstName\":\"John\", \"lastName\":\"Doe\", \"uuid\": \"aafc2e65-2868-4b9a-8abd-ca69804b42e1\", \"email\": \"johndoe@yahoo.com\", \"customerId\": \"123987635\", \"phone\": \"5555555555\", \"OrderNumber\":\"12345\", \"processingNumber\":\"2345678\", \"CustomerLogin\":\"AccountEmail@lz.com\", \"ValidatedRules\": [ { \"Description\": \"View Compliance Calendar\" }, { \"Description\": \"View Completed Orders\"}, { \"Description\": \"Print Invoice\"}, { \"Description\": \"Set up Attorney/Tax Consultation\"}, { \"Description\": \"Company Profile\"}, { \"Description\": \"Account Profile\"}, { \"Description\": \"Make a Payment\"} ] }';
        testJSONstr = '{ \"caseId\": \"005G0000996V5KL\", \"firstName\": \"John\", \"lastName\": \"Doe\", \"uuid\": \"aafc2e65-2868-4b9a-8abd-ca69804b422\", \"email\": \"johndoe@yahoo.com\", \"customerId\": \"123987635\", \"phone\": \"5555555555\", \"orderNumber\": \"12345\", \"processingNumber\": \"22345678\", \"customerLogin\": \"AccountEmail@lz.com\", \"failedBusinessRules\": [ { \"Name\": \"Test Biz Name 1\", \"Description\": \"View Compliance Calendar\" }, { \"Description\": \"View Completed Orders\" }, { \"Description\": \"Print Invoice\" }, { \"Description\": \"Set up Attorney/Tax Consultation\" } ], \"failedValidationRules\": [ {\"Name\": \"Test Biz Name 1\", \"Description\": \"Company Profile\" }, { \"Description\": \"Account Profile\" }, { \"Description\": \"Make a Payment\" } ] }';
        testJSONstr2 = '{ \"caseId\": \"005G0000996V5KL\", \"firstName\": \"John\", \"lastName\": \"Doe\", \"uuid\": \"aafc2e65-2868-4b9a-8abd-ca69804b423\", \"email\": \"johndoe@yahoo.com\", \"customerId\": \"123987635\", \"phone\": \"5555555555\", \"orderNumber\": \"12345\", \"processingNumber\": \"22345678\", \"customerLogin\": \"AccountEmail@lz.com\", \"failedValidationRules\": [ { \"Description\": \"Company Profile\" }, { \"Description\": \"Account Profile\" }, { \"Description\": \"Make a Payment\" } ] }';
        testJSONstr3 = '{ \"caseId\": \"005G0000996V5KL\", \"correlationId\": \"aafc32e65238684b9a8abdca69804b44\", \"firstName\": \"John\", \"lastName\": \"Doe\", \"uuid\": \"aafc2e65-2868-4b9a-8abd-ca69804b424\", \"email\": \"johndoe@yahoo.com\", \"customerId\": \"123987635\", \"phone\": \"5555555555\", \"orderNumber\": \"12345123\", \"processingNumber\": \"22345678\", \"customerLogin\": \"AccountEmail@lz.com\", \"failedValidationRules\": [ { \"Description\": \"Company Profile\" }, { \"Description\": \"Account Profile\" }, { \"Description\": \"Make a Payment\" } ] }';
        dupCorrel = '{ \"caseId\": \"005G0000996V5KL\", \"correlationId\": \"aafc32e65238684b9a8abdca69804b44\", \"firstName\": \"John\", \"lastName\": \"Doe\", \"uuid\": \"aafc2e65-2868-4b9a-8abd-ca69804b424\", \"email\": \"johndoe@yahoo.com\", \"customerId\": \"123987635\", \"phone\": \"5555555555\", \"orderNumber\": \"12345\", \"processingNumber\": \"22345678\", \"customerLogin\": \"AccountEmail@lz.com\", \"failedValidationRules\": [ { \"Description\": \"Company Profile\" }, { \"Description\": \"Account Profile\" }, { \"Description\": \"Make a Payment\" } ] }';
    }
    
    @isTest
    static void testHandleDDSExceptionSuccess() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/DDSExceptionAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstr);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
    
            POR_ExceptionAPI.handleDDSException();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    @isTest
    static void testHandleDDSExceptionWithCaseSuccess() {
        dataSetup();
        
        Case testCase = TestUtils.createCases(1, false)[0];
        testCase.Processing_Number__c = '22345678';
        insert testCase;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/DDSExceptionAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstr2);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
    
            POR_ExceptionAPI.handleDDSException();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    
    @isTest
    static void testHandleDDSExceptionWithCaseReopenSuccess() {
        dataSetup();
        
        User testUser = TestUtils.createUser('SamSmith', TestUtils.salesAgentProfileId , true);
        Case testCase = TestUtils.createCases(1, false)[0];
        testCase.Processing_Number__c = '22345678';
        testCase.POR_Closed_By__c = testUser.Id;
        insert testCase;
        Order_Exception__c existingException = new Order_Exception__c();
        existingException.Reinjection_Request_Submitted__c = true;
        existingException.Processing_Number__c = '22345678';
        existingException.Order_Number__c = testOrders[0].Id;

        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/DDSExceptionAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstr2);

        Test.startTest();
            POR_ExceptionAPIService.reopenCase(testCase.id);
            RestContext.request = req;
            RestContext.response = res;
    
            POR_ExceptionAPI.handleDDSException();
            System.debug(req);
            System.debug(res);
            
        Test.stopTest();
    }
    
    @isTest
    static void testHandleDDSExceptionExistingRecordsSuccess() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/DDSExceptionAPI/';
        req.httpMethod = 'POST';
        

        Test.startTest();
            req.requestBody = Blob.valueOf(testJSONstr2);
            RestContext.request = req;
            RestContext.response = res;
    
            POR_ExceptionAPI.handleDDSException();
    
            System.debug(req);
            System.debug(res);
            
            req.requestBody = Blob.valueOf(testJSONstr2);
            RestContext.request = req;
            RestContext.response = res;
            POR_ExceptionAPI.handleDDSException();
            System.debug(req);
            System.debug(res);
        Test.stopTest();
    }
    @isTest
    static void testDupCorrelation() {
    	dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/DDSExceptionAPI/';
        req.httpMethod = 'POST';
        Test.startTest();
        	req.requestBody = Blob.valueOf(dupCorrel);
            RestContext.request = req;
            RestContext.response = res;
    
            POR_ExceptionAPI.handleDDSException();
    
            System.debug(req);
            System.debug(res);
            
            req.requestBody = Blob.valueOf(dupCorrel);
            RestContext.request = req;
            RestContext.response = res;
            POR_ExceptionAPI.handleDDSException();
            System.debug(req);
            System.debug(res);
        Test.stopTest();
    }
    @isTest
    static void testHandleDDSExceptionNoSuccess() {
        dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/DDSExceptionAPI/';
        req.httpMethod = 'POST';
        
        Test.startTest();
            req.requestBody = Blob.valueOf(testJSONstr);

        
            RestContext.request = req;
            RestContext.response = res;
    
            POR_ExceptionAPI.handleDDSException();
    
            System.debug(req);
            System.debug(res);
            
            req.requestBody = Blob.valueOf(testJSONstr3);

        
            RestContext.request = req;
            RestContext.response = res;
    
            POR_ExceptionAPI.handleDDSException();
    
            System.debug(req);
            System.debug(res);
        
            req.requestBody = Blob.valueOf('{}');

        
            RestContext.request = req;
            RestContext.response = res;
    
            POR_ExceptionAPI.handleDDSException();
    
            System.debug(req);
            System.debug(res);
    
            req.requestBody = Blob.valueOf('');

        
            RestContext.request = req;
            RestContext.response = res;
    
            POR_ExceptionAPI.handleDDSException();
    
            System.debug(req);
            System.debug(res);
        
        
            req.requestBody = Blob.valueOf('empty');

        
            RestContext.request = req;
            RestContext.response = res;
    
            POR_ExceptionAPI.handleDDSException();
    
            System.debug(req);
            System.debug(res);
    
        
        
            req.requestBody = Blob.valueOf('{"orderNumber" : 123453}');

        
            RestContext.request = req;
            RestContext.response = res;
    
            POR_ExceptionAPI.handleDDSException();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    
    @isTest
    static void testCloseExceptionsAndCases() {
        Product2 testProduct;
        String PRODUCT_LINE = 'Intellectual Property';
        Product_Line__c testProductLine;
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
        
        Case testCase = TestUtils.createCases(1, false)[0];
        testCase.Order_Exception__c = newExc.Id;
        insert testCase;
        Set<Id> orderIds = new Set<Id>();
        orderIds.add(testOrder.Id);
        
        POR_ExceptionAPIService.closeExceptionsAndCases(orderIds, 'Test', 'Clean Revision Placed', 'Revision placed on LZ.com');
    }
}