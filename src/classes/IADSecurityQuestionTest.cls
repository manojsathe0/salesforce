@isTest
private class IADSecurityQuestionTest 
{
    static testMethod void testSecurityQuestionAsync()
    {
        IADSecurityQuestionController theController = new IADSecurityQuestionController();
        theController.customerId = '11576778';
        Continuation conti = (continuation)theController.populateSecurityQuestion();
       
        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        System.assert(requests.get(theController.securityQuestionService.APIToWrapper.get(IADSecurityQuestionService.GETSECURITYQUESTIONBYCUSTOMERID).requestLabelContinuation) != null);
        
        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.securityQuestionResponse();
        response.setBody(responseBody); 
        response.setStatusCode(200);
             
        Test.setContinuationResponse(theController.securityQuestionService.APIToWrapper.get(IADSecurityQuestionService.GETSECURITYQUESTIONBYCUSTOMERID).requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(responseBody, theController.securityQuestionService.APIToWrapper.get(IADSecurityQuestionService.GETSECURITYQUESTIONBYCUSTOMERID).responseData);
              
        
    }
    static testMethod void testSecurityQuestionSync()
    {
        IADSecurityQuestionController theController = new IADSecurityQuestionController();
        theController.customerId = '11576778';
        theController.securityQuestionService.APItoAsync.put(IADSecurityQuestionService.GETSECURITYQUESTIONBYCUSTOMERID, false);
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.securityQuestionResponse();
        mock.statusCode=200;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock);
            theController.populateSecurityQuestion();
        Test.stopTest();    
        
        HttpResponse res = theController.securityQuestionService.APIToWrapper.get(IADSecurityQuestionService.GETSECURITYQUESTIONBYCUSTOMERID).theResponse;
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json' , 'Right Content Type Should be populated');
        String actualValue = res.getBody();
        String expectedValue = IADTestDataUtil.securityQuestionResponse();
        System.assertEquals(actualValue, expectedValue , 'Right response should have been populated');
        System.assertEquals(200, res.getStatusCode() , 'Right status code should have been populated');
        
    }
   
    static testMethod void testErrorHandling()
    {
        IADSecurityQuestionController theController = new IADSecurityQuestionController();
        theController.customerId = 'abcx';
        theController.securityQuestionService.APItoAsync.put(IADSecurityQuestionService.GETSECURITYQUESTIONBYCUSTOMERID, true);
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = 'Bad Response';// To cause exception;
        mock.statusCode=200;
        
        
        theController.processResponse();
        theController.populateSecurityQuestion();
        theController.customerId = '';
        
        mock.statusCode= 400;
        Continuation conti = (continuation)theController.populateSecurityQuestion();
        theController.securityQuestionService.APIToWrapper.get(IADSecurityQuestionService.GETSECURITYQUESTIONBYCUSTOMERID).statusCode = '500';
        
        conti = (continuation)theController.populateSecurityQuestion();
        theController.securityQuestionService.APIToWrapper.get(IADSecurityQuestionService.GETSECURITYQUESTIONBYCUSTOMERID).responseData = null;
        theController.securityQuestionService.APItoAsync.put(IADSecurityQuestionService.GETSECURITYQUESTIONBYCUSTOMERID, true);
        conti = (continuation)theController.populateSecurityQuestion();
                        
        theController.securityQuestionService.APItoAsync.put(IADSecurityQuestionService.GETSECURITYQUESTIONBYCUSTOMERID, false);
        conti = (continuation)theController.populateSecurityQuestion();
       
    }
   
    
  
}