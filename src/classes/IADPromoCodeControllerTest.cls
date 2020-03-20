@isTest
private class IADPromoCodeControllerTest {
	
	
	static testMethod void testApplyPromoCode()
	{
		PageReference pageRef = Page.IADPromoCodePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('orderId', '1234');
      
        IADPromoCodeController theController = new IADPromoCodeController();
        theController.promoCodeService.APItoAsync.put(IADPromoCodeService.POSTAPPLYPROMOCODEBYORDERID, true);
        theController.promoCode = '100';
        Continuation conti;
        conti = (continuation)theController.applyPromoCode();//Gives Error
        theController.promoCode = '';
        theController.comments = 'Some Promo Code';
        conti = (continuation)theController.applyPromoCode();//Gives Error
        theController.promoCode = '100';

        theController.orderId = null;
        conti = (continuation)theController.applyPromoCode(); //Throws Exception
        
      
        theController.orderId = '1234';
        conti = (continuation)theController.applyPromoCode();
        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.promoCodeService.APItoWrapper.get(IADPromoCodeService.POSTAPPLYPROMOCODEBYORDERID);

        
        HttpResponse response = new HttpResponse();
        String responseBody = '{"orderDiscount": { "orderDiscountId": 0, "orderItemId": 0, "orderId": 0, "discountType": "unset", "valueAmount": 0, "memberGroupCode": 0, "customDiscountId": 0, "userDiscountLogId": 0, "comments": "string", "cancelled": false, "discountId": 0, "dateCreated": "2016-12-06T05:22:13.676Z", "createdBy": "string", "dateLastModified": "2016-12-06T05:22:13.676Z", "lastModifiedBy": "string"}';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //Error
        response.setStatusCode(404);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        // Make APIToWrapperNull for exception
        theController.promoCodeService.APItoWrapper = null;
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


     

	}

	static testMethod void  testDisplayPromoCode()
	{
		PageReference pageRef = Page.IADPromoCodePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('orderId', '1234');
      
        IADPromoCodeController theController = new IADPromoCodeController();
        theController.promoCodeService.APItoAsync.put(IADPromoCodeService.GETPROMOCODESBYORDERID, true);
        theController.orderId = null;
        Continuation conti = (continuation)theController.displayPromoCode();//Throws Exception
      	
      	theController.orderId = '1234';

        conti = (continuation)theController.displayPromoCode();
        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.promoCodeService.APItoWrapper.get(IADPromoCodeService.GETPROMOCODESBYORDERID);
        
        HttpResponse response = new HttpResponse();
        String responseBody = '{"orderId": 0, "orderPromoCodes": [ { "code": "string", "amount": 0, "isCancelled": false, "discountReason": "string", "dateEntered": "string", "enteredBy": "string", "comments": "string"}]}';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //Error
        response.setStatusCode(404);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

         // Make APIToWrapperNull for exception
        theController.promoCodeService.APItoWrapper = null;
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
	}

	static testMethod void testCheckPromoCode()
	{
		PageReference pageRef = Page.IADPromoCodePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('orderId', '1234');
      
        IADPromoCodeController theController = new IADPromoCodeController();
        theController.promoCodeService.APItoAsync.put(IADPromoCodeService.GETVALIDATEPROMOCODEBYORDERID, true);
        
        Continuation conti;

        conti = (continuation)theController.checkPromoCode(); //Gives Error
        theController.promoCode = '100';
      	
      	theController.orderId = null;
        conti = (continuation)theController.checkPromoCode();//Throws Exception

        theController.orderId = '1234';
      	conti = (continuation)theController.checkPromoCode();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.promoCodeService.APItoWrapper.get(IADPromoCodeService.GETVALIDATEPROMOCODEBYORDERID);
        
        HttpResponse response = new HttpResponse();
        String responseBody = '{"isValid": true, "promoCode": "string", "discountAmount": 0}';
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
        //Error
        response.setStatusCode(404);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

         // Make APIToWrapperNull for exception
        theController.promoCodeService.APItoWrapper = null;
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

	}

	static testMethod void testCancelPromoCode()
	{
		PageReference pageRef = Page.IADPromoCodePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('orderId', '1234');
      
        IADPromoCodeController theController = new IADPromoCodeController();
        theController.promoCodeService.APItoAsync.put(IADPromoCodeService.POSTCANCELPROMOCODEBYORDERID, true);
      
        Continuation conti;
		theController.orderId = null;
        conti = (continuation)theController.cancelPromoCode();//Throws Exception
        
        theController.orderId = '1234';
        conti = (continuation)theController.cancelPromoCode();
        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.promoCodeService.APItoWrapper.get(IADPromoCodeService.POSTCANCELPROMOCODEBYORDERID);
        
        HttpResponse response = new HttpResponse();
        String responseBody = '{"orderDiscount": { "orderDiscountId": 0, "orderItemId": 0, "orderId": 0, "discountType": "unset", "valueAmount": 0, "memberGroupCode": 0, "customDiscountId": 0, "userDiscountLogId": 0, "comments": "string", "cancelled": true, "discountId": 0, "dateCreated": "2016-12-06T05:22:13.676Z", "createdBy": "string", "dateLastModified": "2016-12-06T05:22:13.676Z", "lastModifiedBy": "string"}';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //Error
        response.setStatusCode(404);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

         // Make APIToWrapperNull for exception
        theController.promoCodeService.APItoWrapper = null;
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
	} 
}