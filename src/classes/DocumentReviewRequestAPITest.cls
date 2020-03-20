/**

 */
@isTest
private class DocumentReviewRequestAPITest {
	public static String testJSONstr;
	public static String testJSONstrNotValid;
	public static String testJSONstrNotFound;
	public static String testJSONstrEmpty;
	public static String testJSONstrNoProcId;
	public static void dataSetup() {
		Order_Exception__c exRecord = new Order_Exception__c();
		exRecord.Processing_Number__c = '44444444';
		insert exRecord;
		System.Debug(exRecord);
		testJSONstr = '{ \"RequestBy\" : \"John Smith\", \"ProcessId\" : 23333331, \"ProductProcessingId\" : 44444444, \"ReferenceId\" : 1234, \"StateId\" : 12 }';
		testJSONstrNotValid = '{';
		testJSONstrNotFound = '{ \"RequestBy\" : \"John Smith\", \"ProcessId\" : 23333331, \"ProductProcessingId\" : 444444424, \"ReferenceId\" : 1234, \"StateId\" : 12 }';
		testJSONstrEmpty = '';
		testJSONstrNoProcId = '{ \"RequestBy\" : \"John Smith\", \"ProcessId\" : 23333331, \"ProductProcessingIdWrong\" : 44444444, \"ReferenceId\" : 1234, \"StateId\" : 12 }';
	}
	@isTest
    static void testDocumentReviewRequestAPI() {
    	dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/DocumentReviewRequestAPI';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstr);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
    
            DocumentReviewRequestAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    @isTest
    static void testDocumentReviewRequestAPINotValidJSON() {
    	dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/DocumentReviewRequestAPI';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstrNotValid);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
    
            DocumentReviewRequestAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    @isTest
    static void testDocumentReviewRequestAPINotFound() {
    	dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/DocumentReviewRequestAPI';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstrNotFound);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
    
            DocumentReviewRequestAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    @isTest
    static void testDocumentReviewRequestAPIEmpty() {
    	dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/DocumentReviewRequestAPI';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstrEmpty);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
    
            DocumentReviewRequestAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    @isTest
    static void testDocumentReviewRequestAPINoProcId() {
    	dataSetup();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/v1/DocumentReviewRequestAPI';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(testJSONstrNoProcId);

        Test.startTest();
            RestContext.request = req;
            RestContext.response = res;
    
            DocumentReviewRequestAPI.handleHTTPRequest();
    
            System.debug(req);
            System.debug(res);
    
        Test.stopTest();
    }
    @isTest
    static void testBeanClass() {
    	DocumentReviewRequestBeans.DocumentReviewInboundRequest testBean = new DocumentReviewRequestBeans.DocumentReviewInboundRequest();
    	testBean.requestBy = 'Test';
    	testBean.processId = 123;
    	testBean.productProcessingId = 456;
    	testBean.referenceId = 456;
    	testBean.stateId = 789;
    	
    	  

    }
}