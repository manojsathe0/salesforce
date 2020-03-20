@isTest
private class IADContactHistoryControllerTest
{
    
   @isTest static void populateCustomerHistory_Async()
   {
      
        Test.startTest();
            IADContactHistoryController theController = new IADContactHistoryController();
            theController.contactHistoryService.APItoAsync.put('GetContactHistoryByCustId', true);

            Continuation conti = (Continuation)theController.populateCustomerHistory(); //Throws Exception as no Customer Id
            theController.customerId = '12345';
            
            conti = (Continuation)theController.populateCustomerHistory();
            // Verify that the continuation has the proper requests
            system.debug('conti---'+conti);
            Map<String, HttpRequest> requests = conti.getRequests();
            System.assert(requests.size() == 1);
            //theController.securityQuestionService.APIToWrapper.get(IADContactHistoryService.GETCONTACTHISTORYBYCUSTID).requestLabelContinuation
            System.assert(requests.get(theController.contactHistoryService.APIToWrapper.get(IADContactHistoryService.GETCONTACTHISTORYBYCUSTID).requestLabelContinuation) != null);
            
            
            // Perform mock callout 
            // (i.e. skip the callout and call the callback method)
            HttpResponse response = new HttpResponse();
            String responseBody = IADTestDataUtil.getCustomerHistoryResponse(5);
            response.setBody(responseBody);   
            response.setStatusCode(200);
            // Set the fake response for the continuation     
            Test.setContinuationResponse(theController.contactHistoryService.APIToWrapper.get(IADContactHistoryService.GETCONTACTHISTORYBYCUSTID).requestLabelContinuation, response);
            // Invoke callback method
            Object result = Test.invokeContinuationMethod(theController , conti);
            // result is the return value of the callback
            System.assertEquals(null, result);
            // Verify that the controller's result variable
            //   is set to the mock response.
            System.assertEquals(responseBody , theController.contactHistoryService.APIToWrapper.get(IADContactHistoryService.GETCONTACTHISTORYBYCUSTID).responseData , 'Right response should have been returned');
          
        Test.stopTest();
    }
    
    @isTest static void populateCustomerHistory_Sync()
    {
        IADContactHistoryController theController = new IADContactHistoryController();
        theController.customerId = '11576778';
        theController.contactHistoryService.APItoAsync.put(IADContactHistoryService.GETCONTACTHISTORYBYCUSTID, false);
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getCustomerHistoryResponse(5);
        mock.statusCode=200;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock);
            theController.populateCustomerHistory();
        Test.stopTest();    
        
        HttpResponse res = theController.contactHistoryService.APIToWrapper.get(IADContactHistoryService.GETCONTACTHISTORYBYCUSTID).theResponse;
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = IADTestDataUtil.getCustomerHistoryResponse(5);
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        
    }
    @isTest static void testErrors()
    {
        IADContactHistoryController theController = new IADContactHistoryController();
        theController.customerId = '11576778';
         
        theController.contactHistoryService.APItoAsync.put(IADContactHistoryService.GETCONTACTHISTORYBYCUSTID, false);
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = 'Bad Response';
        mock.statusCode=200;
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock);
            theController.processContactHistory();
        Test.stopTest();
    }
    
}