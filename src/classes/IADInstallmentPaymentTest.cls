@isTest
private class IADInstallmentPaymentTest
{

    @isTest static void setupData()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];

        system.runAs(u)
        {

            Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

            Order__c order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }

    }
    @isTest static void testGetOrderBalance()
    {
        setupData();

        PageReference pageRef = Page.IADInstallmentPayments;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('orderId', '1234');
        ApexPages.currentPage().getParameters().put('customerId', '1234');
        ApexPages.currentPage().getParameters().put('installment', '1');



        IADInstallmentPaymentController theController = new IADInstallmentPaymentController();
        //Async
        Continuation conti = (continuation)theController.populateOrderBalances();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.balanceService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrderBalanceResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        theController.paymentName = 'Installment';
        conti = (continuation)theController.populateOrderBalances();
        response = new HttpResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
      
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


       
        //errors
        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(500);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

    }

    @isTest static void testOrderBalanceErrors()
    {
        setupData();

        PageReference pageRef = Page.IADInstallmentPayments;
        Test.setCurrentPage(pageRef);

        Test.startTest();


        ApexPages.currentPage().getParameters().put('orderId', '1234');
        ApexPages.currentPage().getParameters().put('customerId', '1234');
        ApexPages.currentPage().getParameters().put('amountdue', '1');

        IADInstallmentPaymentController theController = new IADInstallmentPaymentController();

        try{
            theController.balanceService = null;
            theController.balanceService.populateOrderBalance();
        }
        catch(exception e){}
        try{
            theController.balanceService = null;
            theController.processOrderBalancesResponse();

        }
        catch(exception e){}
        try{

            APIRequestResponseWrapper response = theController.balanceService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID);
            response.responseData = null;
            theController.balanceService.APItoWrapper.put(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, response);
            theController.balanceService.populateOrderBalance();
        }
        catch(exception e){}

        Test.stopTest();

    }

    @isTest static void testPostPayment()
    {
        setupData();

        PageReference pageRef = Page.IADInstallmentPayments;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('orderId', '1234');
        ApexPages.currentPage().getParameters().put('customerId', '1234');
        ApexPages.currentPage().getParameters().put('installment', '1');
        ApexPages.currentPage().getParameters().put('totalAmount', '12.34');
        ApexPages.currentPage().getParameters().put('amount', '12.34');


        IADInstallmentPaymentController theController = new IADInstallmentPaymentController();
        IADInstallmentPaymentController.OtherWrapper wrap = new IADInstallmentPaymentController.OtherWrapper();
        wrap.index = 0;
        theController.addOtherAmt();

        //do get first
        Continuation conti = (continuation)theController.populateOrderBalances();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.balanceService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrderBalanceResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //test validation

        theController.profileId = 'pp1234';
        ApexPages.currentPage().getParameters().put('totalAmount', '2000');
        theController.comments = '';
        theController.email = 'test';
        conti = (continuation)theController.postPayment();

        ApexPages.currentPage().getParameters().put('totalAmount', '-2000');
        conti = (continuation)theController.postPayment();

        //post payment now
        theController.paymentService.clearMessages();
        ApexPages.currentPage().getParameters().put('totalAmount', '12.34');
        theController.setProfileIdManual();
        theController.profileId = 'pp1234';
        theController.comments = '1234';
        theController.selectedReason = '1';
        theController.email = 'test@something.com';
        conti = (continuation)theController.postPayment();

        requests = conti.getRequests();
        System.assert(requests.size() == 1);
        apiresponse = theController.paymentService.APItoWrapper.get(IADInstallmentPaymentService.POSTPAYMENT);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        response = new HttpResponse();
        responseBody = IADTestDataUtil.postPaymentResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //errors

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(500);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //post payment installment
        
        theController.invokingPage = 'Installment';
        theController.invokingPageId = '3423423';
        conti = (continuation)theController.postPayment();

        requests = conti.getRequests();
        System.assert(requests.size() == 1);
        apiresponse = theController.paymentService.APItoWrapper.get(IADInstallmentPaymentService.POSTPAYMENTFORINSTALLMENT);
        System.assert(apiresponse != null);
        System.debug('response ' + apiresponse);

        response = new HttpResponse();
        responseBody = IADTestDataUtil.postPaymentResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);



        

        //post payment storecredit
        theController.profileId = 'sc1234';

        conti = (continuation)theController.postPayment();

        requests = conti.getRequests();
        System.assert(requests.size() == 1);
        apiresponse = theController.paymentService.APItoWrapper.get(IADInstallmentPaymentService.POSTPAYMENTBYSTORECREDITID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        response = new HttpResponse();
        responseBody = IADTestDataUtil.postPaymentStoreCreditResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


        //errors

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(500);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


    }

    @isTest static void testPostPaymentErrors()
    {
        setupData();

        PageReference pageRef = Page.IADInstallmentPayments;
        Test.setCurrentPage(pageRef);

        Test.startTest();


        ApexPages.currentPage().getParameters().put('orderId', '1234');
        ApexPages.currentPage().getParameters().put('customerId', '1234');
        ApexPages.currentPage().getParameters().put('installment', '1');

        IADInstallmentPaymentController theController = new IADInstallmentPaymentController();
        theController.postPayment();

        try{
            theController.totalAmountConverted();
            theController.paymentService = null;
            theController.thePayment = null;
            theController.processPaymentResponse();
        }
        catch(exception e){}
        try{
            theController.paymentService = null;
            theController.paymentService.populatePayments();
        }
        catch(exception e){}
        try{
            theController.paymentService = null;
            theController.processPaymentResponse();

        }
        catch(exception e){}
        try{

            APIRequestResponseWrapper response = theController.paymentService.APItoWrapper.get(IADInstallmentPaymentService.POSTPAYMENT);
            response.responseData = null;
            theController.paymentService.APItoWrapper.put(IADInstallmentPaymentService.POSTPAYMENT, response);
            theController.paymentService.populatePayments();
        }
        catch(exception e){}

        Test.stopTest();

    }

}