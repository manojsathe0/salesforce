@isTest
private class IADSubscriptionControllerTest
{
    
	static testMethod void testPopulateSubscription()
    {
        PageReference pageRef = Page.IADSubscriptionPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('subscriptionId', '1234');
        ApexPages.currentPage().getParameters().put('customerId', '4567');
        ApexPages.currentPage().getParameters().put('customerId', '4567910');

        IADSubscriptionController theController = new IADSubscriptionController();
        
        theController.subscriptionService.APItoAsync.put(IADSubscriptionPanelService.GETSUBSCRIPTIONBYSUBSCRIPTIONID, true);

        //Async
        Continuation conti = (continuation)theController.populateSubscription();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.subscriptionService.APItoWrapper.get(IADSubscriptionPanelService.GETSUBSCRIPTIONBYSUBSCRIPTIONID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getSubscriptionResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


        theController.endDate = '02/02/2015';
        theController.setPaymentOption();
        theController.detailSave();
        theController.renewChoice= 1;
        theController.cancelReason = 'test reason';
        theController.cancelSave();
        theController.detailSave();
        theController.getRACancellationReasons();
        theController.getOtherCancellationReasons();
        theController.setProfileIdManual();
        theController.closeTheForm();
        theController.clearMessages();

	}

    static testMethod void testUpdateSubscription()
    {
        

        PageReference pageRef = Page.IADSubscriptionPage;

        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('subscriptionId', '1234');
        ApexPages.currentPage().getParameters().put('customerId', '4567');

        IADSubscriptionController theController = new IADSubscriptionController();
        theController.renewChoice = 1;
       


        theController.subscriptionService.APItoAsync.put(IADSubscriptionPanelService.PUTSUBSCRIPTIONBYSUBSCRIPTIONID, true);

        //Async
        Continuation conti;
        conti = (continuation)theController.updateSubscription(); //Error ad profileId is blank

        theController.profileId = 'pp112342';
        conti = (continuation)theController.updateSubscription();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.subscriptionService.APItoWrapper.get(IADSubscriptionPanelService.PUTSUBSCRIPTIONBYSUBSCRIPTIONID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getSubscriptionUpdateResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


      
    }
    

    static testMethod void testCancelSubscriptionRenewal()
    {
        

        PageReference pageRef = Page.IADSubscriptionPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('subscriptionId', '1234');
        ApexPages.currentPage().getParameters().put('customerId', '4567');

        ApexPages.currentPage().getParameters().put('orderItemSubscriptionId','1525398'); 
        ApexPages.currentPage().getParameters().put('currentOrderItemId','52716289');
        ApexPages.currentPage().getParameters().put('isPartial','1');


        IADSubscriptionController theController = new IADSubscriptionController();
        
        theController.subscriptionService.APItoAsync.put(IADSubscriptionPanelService.GETSUBSCRIPTIONBYSUBSCRIPTIONID, true);

        //Async
        Continuation conti = (continuation)theController.populateSubscription();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.subscriptionService.APItoWrapper.get(IADSubscriptionPanelService.GETSUBSCRIPTIONBYSUBSCRIPTIONID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getSubscriptionResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);

        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

       
        theController.populateSelectedSubscriptionTerm();
        
        theController.isPartial = true;
        theController.refundAmount = '';

        
        //Cancelling Subscription Terms Renewal

        conti = (continuation)theController.cancelSubscriptionRenewal();//Gives Error
        theController.refundAmount = '50';

        conti = (continuation)theController.cancelSubscriptionRenewal(); //Gives Error as no note

        theController.isPartial = false;
        conti = (continuation)theController.cancelSubscriptionRenewal(); //Gives Error as no note for Full Refund

        theController.isPartial = true;
        theController.note = 'Some note';

        
        theController.subscriptionService.APItoAsync.put(IADSubscriptionPanelService.PUTORDERSUBSCRIPTIONBYORDERITEMID, true);

        

        //Async
        conti = (continuation)theController.cancelSubscriptionRenewal();

        requests = conti.getRequests();
        System.assert(requests.size() == 1);
        apiresponse = theController.subscriptionService.APItoWrapper.get(IADSubscriptionPanelService.PUTORDERSUBSCRIPTIONBYORDERITEMID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        response = new HttpResponse();
        responseBody = IADTestDataUtil.getSubscriptionUpdateResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


      
    }

    static testMethod void testPopulateProratedRefund()
    {
        

        PageReference pageRef = Page.IADSubscriptionPage;

        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('subscriptionId', '1234');
        ApexPages.currentPage().getParameters().put('customerId', '4567');
        ApexPages.currentPage().getParameters().put('dueDate', '12/31/2016');

      
        IADSubscriptionController theController = new IADSubscriptionController();
        theController.isPartial = true;
        theController.currentOrderItemId = '5435345';    


        theController.subscriptionService.APItoAsync.put(IADSubscriptionPanelService.GETPRORATEDREFUNDBYORDERITEMID, true);

        //Async
        Continuation conti;
        conti = (continuation)theController.populateProratedRefund(); //Error ad profileId is blank

        theController.profileId = 'pp112342';
        conti = (continuation)theController.populateProratedRefund();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.subscriptionService.APItoWrapper.get(IADSubscriptionPanelService.GETPRORATEDREFUNDBYORDERITEMID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getProratedRefund();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        theController.populateRefundAmount();
    
    }

  
}