@isTest
private class IADPendingPaymentControllerTest {
	
	
	static Contact con1;
    static Order__c order1;

    public static void setupData() 
    {
        con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789');
        insert con1;
        
        order1 = new Order__c(Name = '1000', OrderID__c = '1000', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order1;
    }

	static testMethod void testPopulatePayments_PaymentsByOrderId() {
		
		setupData();
		PageReference pageRef = Page.IADPendingPaymentsPanelPage;

        pageRef.getParameters().put('id', order1.id);

        Test.setCurrentPage(pageRef);

        IADPendingPaymentsPanelController theController = new IADPendingPaymentsPanelController();
        theController.pendingPaymentService.APItoAsync.put(IADPendingPaymentsService.GETPAYMENTSBYORDERID, true);
        Continuation conti;

        theController.orderId = null;
        conti = (continuation)theController.populatePayments(); //throws Exception

        theController.orderId = '1000';
        conti = (continuation)theController.populatePayments();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.pendingPaymentService.APItoWrapper.get(IADPendingPaymentsService.GETPAYMENTSBYORDERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getPaymentsByOrderIdResponse(2);
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


	}

	static testMethod void testPopulatePayments_PaymentByPaymentId() {
		
		setupData();
		PageReference pageRef = Page.IADPendingPaymentPage;

        pageRef.getParameters().put('id', '1234');//PaymentId
        pageRef.getParameters().put('transactionType', '1');//Payment Type


        Test.setCurrentPage(pageRef);

        IADPendingPaymentController theController = new IADPendingPaymentController();
        theController.paymentService.APItoAsync.put(IADPaymentService.GETPAYMENTBYPAYMENTID, true);

        //Async
        Continuation conti = (continuation)theController.populatePayments();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.paymentService.APItoWrapper.get(IADPaymentService.GETPAYMENTBYPAYMENTID);
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

    static testMethod void testPopulatePayments_RefundByRefundId() {
        
        setupData();
        PageReference pageRef = Page.IADPendingPaymentPage;

        pageRef.getParameters().put('id', '1234');//PaymentId
        pageRef.getParameters().put('transactionType', '2');//Refund


        Test.setCurrentPage(pageRef);

        IADPendingPaymentController theController = new IADPendingPaymentController();
        theController.paymentService.APItoAsync.put(IADPaymentService.GETREFUNDBYREFUNDID, true);

        //Async
        Continuation conti = (continuation)theController.populatePayments();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.paymentService.APItoWrapper.get(IADPaymentService.GETREFUNDBYREFUNDID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = '{ "refundDetails": { "id": 0, "orderId": 0, "transactionType": 2, "paymentType": "string", "amount": 0, "currencyCode": "string", "creationDate": "2016-12-08T00:38:37.638Z", "creatorId": "string", "status": 2, "statusDate": "2016-12-08T00:38:37.638Z", "parentId": 0, "customerId": "string", "comments": "string", "reason": "string", "paymentProfileId": 0, "gateway": "string", "cancelled": true, "cancellationDate": "string", "source": "string", "manualCheckId": "string", "receiptEmail": "string" } }';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //Set Bad Response.Creattion Date is messed up.Throws exception
        responseBody = '{ "refundDetails": { "id": 0, "orderId": 0, "transactionType": 2, "paymentType": "string", "amount": 0, "currencyCode": "string", "creationDate": "2016-08T00:38:37.638Z", "creatorId": "string", "status": 2, "statusDate": "2016-12-08T00:38:37.638Z", "parentId": 0, "customerId": "string", "comments": "string", "reason": "string", "paymentProfileId": 0, "gateway": "string", "cancelled": true, "cancellationDate": "string", "source": "string", "manualCheckId": "string", "receiptEmail": "string" } }';
      
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);



    }


    static testMethod void testPopulatePayments_OriginalPaymentByPaymentId() {

        setupData();
        PageReference pageRef = Page.IADPendingPaymentPage;

        pageRef.getParameters().put('id', '1234');//PaymentId
        pageRef.getParameters().put('transactionType', '1');//Payment Type


        Test.setCurrentPage(pageRef);

        IADPendingPaymentController theController = new IADPendingPaymentController();
        theController.paymentService.APItoAsync.put(IADPaymentService.GETPAYMENTBYPAYMENTID, true);

        //Async
        Continuation conti = (continuation)theController.populateOriginalPayment();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.paymentService.APItoWrapper.get(IADPaymentService.GETPAYMENTBYPAYMENTID);
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

        //populate original profile
        theController.thePayment.paymentType = '1';
        conti = (continuation)theController.populateOriginalPaymentProfile();

         requests = conti.getRequests();
        System.assert(requests.size() == 1);
        apiresponse = theController.getProfileService.APItoWrapper.get(IADEditPaymentService.GETPROFILEBYID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        response = new HttpResponse();
        responseBody = IADTestDataUtil.getPaymentProfileResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);

    }
    @isTest static void testErrors()
    {
        setupData();

        PageReference pageRef = Page.IADPendingPaymentPage;
        Test.setCurrentPage(pageRef);

        Test.startTest();
        IADPendingPaymentController theController = new IADPendingPaymentController();

        try{
            theController.theId = null;
            theController.paymentService = null;
            theController.populatePayments();
        }
        catch(exception e){}

        try{
            theController.paymentService = null;
            theController.populateOriginalPayment();

        }
        catch(exception e){}
        try{
            theController.paymentService = null;
            theController.populateOriginalPayment();

        }
        catch(exception e){}
        try {
            theController.getProfileService = null;
            theController.populateOriginalPaymentProfile();

        }
        catch(exception e){}

        Test.stopTest();

    }


}