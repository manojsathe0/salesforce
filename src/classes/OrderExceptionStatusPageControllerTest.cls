@isTest
public class OrderExceptionStatusPageControllerTest {
    static Product2 testProduct;
    final static String PRODUCT_LINE = 'Intellectual Property';
    static Product_Line__c testProductLine;
    static Id relationshipTypeId;
    static Id exceptionId;
    static Id caseId;
    static Order_Exception__c newExc;
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

        newExc = new Order_Exception__c();
        newExc.Order_Number__c = testOrder.Id;
        newExc.Status__c = 'Problem';
        newExc.Processing_Number__c='1234567';
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
        IADTestMockGenerator mock = new IADTestMockGenerator();
        Map<String,Map<String,Object>> mapMap = new Map<String,Map<String,Object>>();
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('overallRuleStatus',(Object)'passed');
        mapMap.put('overallOrderRuleStatus',orderItemIdToPdtCnfgId);
        String JSONresponse = JSON.serialize(mapMap);
        
        mock.testBody = JSONresponse;
        mock.statusCode = 200;
        
        
        
        
     Test.setMock(HttpCalloutMock.class, mock);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newExc);
        OrderExceptionStatusPageController testCnt = new OrderExceptionStatusPageController(sc);
        testCnt.getThereAreOpenCases();
        testCnt.getOnHold();
        testCnt.putOnHold();
        Test.startTest();
        testCnt.removeFromHold();
        Test.stopTest();
    }
    
}