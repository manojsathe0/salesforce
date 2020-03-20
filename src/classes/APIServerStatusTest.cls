@isTest
private class APIServerStatusTest
{


    static testMethod void testCallout()
    {

        PageReference pageRef = Page.APIServerStatus;

        Test.setCurrentPage(pageRef);

        APIServerStatus theController = new APIServerStatus();
        theController.label = IADPaymentService.GETPAYMENTBYPAYMENTID;
        theController.endpoint = 'v1/billing/payments/';

        //Async
        Continuation conti = (continuation)theController.makeCallout();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.apiresponse;
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getPaymentsByOrderIdResponse(1);
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);



    }
    static testMethod void testCalloutError()
    {

        PageReference pageRef = Page.APIServerStatus;

        Test.setCurrentPage(pageRef);

        APIServerStatus theController = new APIServerStatus();
        theController.label = IADPaymentService.GETPAYMENTBYPAYMENTID;

        Continuation conti = (continuation)theController.makeCallout();




    }


}