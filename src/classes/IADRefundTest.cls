@isTest
private class IADRefundTest
{

    @isTest static void setupData()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];

        system.runAs(u)
        {
            Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234', email='test@dasjfhkjsdlkjfasdlkfalskdj.com');
            insert con1;


            Customer_Login__c cust = new Customer_Login__c(Primary_Contact__c = con1.id, Customer_ID__c = '1234');
            insert cust;

            Order__c order1 = new Order__c( Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }

    }
    @isTest static void testOpeningAPI()
    {
        setupData();

        PageReference pageRef = Page.IADRefundPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('orderId', '1234');
        ApexPages.currentPage().getParameters().put('customerId', '1234');
        ApexPages.currentPage().getParameters().put('amount', '12.34');

        IADRefundController theController = new IADRefundController();

        theController.balanceService.APItoAsync.put(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, true);
        theController.paymentsService.APItoAsync.put(IADPendingPaymentsService.GETPAYMENTSBYORDERID, true);
        theController.profileService.APItoAsync.put(IADPaymentProfilesService.GETPROFILESBYUSERID, true);
        Continuation conti = (continuation)theController.startRequestsInParallel();

        Map<String, HttpRequest> requests = conti.getRequests();

        //parrallel requests have 3 responses currently
        System.assert(requests.size() == 3);

        //Order balance Response
        APIRequestResponseWrapper wrapper = theController.balanceService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID);
        System.assert(wrapper != null);
        system.debug('response ' + wrapper);

        // Perform mock callout

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrderBalanceResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //errors order balance


        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(500);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


        //IADPendingPaymentsService.GETPROFILESBYUSERID

        wrapper = theController.profileService.APItoWrapper.get(IADPaymentProfilesService.GETPROFILESBYUSERID);
        System.assert(wrapper != null);
        system.debug('response ' + wrapper);


        response = new HttpResponse();
        responseBody = IADTestDataUtil.getPaymentProfilesResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //errors profile

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(500);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);



        //IADPendingPaymentsService.GETPAYMENTSBYORDERID

        wrapper = theController.paymentsService.APItoWrapper.get(IADPendingPaymentsService.GETPAYMENTSBYORDERID);
        System.assert(wrapper != null);
        system.debug('response ' + wrapper);


        response = new HttpResponse();
        responseBody = IADTestDataUtil.getPaymentsByOrderIdResponse(4);
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //errors GETPAYMENTSBYORDERID

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(500);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
        

    }

    @isTest static void testPostRefund()
    {

        setupData();

        PageReference pageRef = Page.IADRefundPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('orderId', '1234');
        ApexPages.currentPage().getParameters().put('customerId', '1234');
        ApexPages.currentPage().getParameters().put('amount', '12.34');

        IADRefundController theController = new IADRefundController();
        IADRefundController.OtherWrapper wrap = new IADRefundController.OtherWrapper();
        wrap.index = 0;
        theController.addOtherAmt();

        theController.balanceService.APItoAsync.put(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, true);
        theController.paymentsService.APItoAsync.put(IADPendingPaymentsService.GETPAYMENTSBYORDERID, true);
        theController.profileService.APItoAsync.put(IADPaymentProfilesService.GETPROFILESBYUSERID, true);
        Continuation conti = (continuation)theController.startRequestsInParallel();

        Map<String, HttpRequest> requests = conti.getRequests();

        //parrallel requests have 3 responses currently
        System.assert(requests.size() == 3);

        //Order balance Response
        APIRequestResponseWrapper wrapper = theController.balanceService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID);
        System.assert(wrapper != null);
        system.debug('response ' + wrapper);

        // Perform mock callout

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrderBalanceResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);



        //IADPendingPaymentsService.GETPROFILESBYUSERID

        wrapper = theController.profileService.APItoWrapper.get(IADPaymentProfilesService.GETPROFILESBYUSERID);
        System.assert(wrapper != null);
        system.debug('response ' + wrapper);


        response = new HttpResponse();
        responseBody = IADTestDataUtil.getPaymentProfilesResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //IADPendingPaymentsService.GETPAYMENTSBYORDERID

        wrapper = theController.paymentsService.APItoWrapper.get(IADPendingPaymentsService.GETPAYMENTSBYORDERID);
        System.assert(wrapper != null);
        system.debug('response ' + wrapper);


        response = new HttpResponse();
        responseBody = IADTestDataUtil.getPaymentsByOrderIdResponse(4);
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


        theController.pTransactionToAmount.put('1234', '100.00');
        theController.selectedPayment='1234';
        IADContractBeans.IADPaymentProfileBean profile = new IADContractBeans.IADPaymentProfileBean ();
        theController.selectedPayment='1234';


        theController.profileId = 'pp1234';
        ApexPages.currentPage().getParameters().put('totalAmount', '2000');
        theController.comments = '';
        theController.email = 'test';
        conti = (continuation)theController.processRefund();

        ApexPages.currentPage().getParameters().put('totalAmount', '-2000');
        conti = (continuation)theController.processRefund();

        //post refund
        theController.refundService.clearMessages();
        ApexPages.currentPage().getParameters().put('totalAmount', '12.34');
        theController.setProfileIdManual();
        theController.profileId = 'pp1234';
        theController.comments = '1234';
        theController.selectedReason = '1';
        theController.email = 'test@something.com';

        conti = (continuation)theController.processRefund();



        requests = conti.getRequests();
        System.assert(requests.size() == 1);
        wrapper = theController.refundService.APItoWrapper.get(IADInstallmentPaymentService.POSTREFUNDBYORDERID);
        System.assert(wrapper != null);
        system.debug('response ' + wrapper);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        response = new HttpResponse();
        responseBody = IADTestDataUtil.postPaymentResponse();
        response.setBody(responseBody);
        response.setStatusCode(201);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //errors

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(500);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


        //post refund storecredit
        theController.profileId = IADPaymentProfilesComponentController.refundToStoreCredit;

        conti = (continuation)theController.processRefund();

        requests = conti.getRequests();
        System.assert(requests.size() == 1);
        wrapper = theController.refundService.APItoWrapper.get(IADInstallmentPaymentService.POSTREFUNDSTORECREDITBYORDERID);
        System.assert(wrapper != null);
        system.debug('response ' + wrapper);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        response = new HttpResponse();
        responseBody = IADTestDataUtil.postPaymentStoreCreditResponse();
        response.setBody(responseBody);
        response.setStatusCode(201);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //errors

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(500);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
    }


    @isTest static void testPostRefundStorecreditToCard()
    {

        setupData();

        PageReference pageRef = Page.IADRefundPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('customerId', '1234');
        ApexPages.currentPage().getParameters().put('amount', '12.34');
        ApexPages.currentPage().getParameters().put('storeCreditToCard', '1');

        IADRefundController theController = new IADRefundController();
        theController.isRefundStoreCreditToCard = true;
        theController.setProfileId();

        theController.balanceService.APItoAsync.put(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, true);
        theController.paymentsService.APItoAsync.put(IADPendingPaymentsService.GETPAYMENTSBYORDERID, true);
        theController.profileService.APItoAsync.put(IADPaymentProfilesService.GETPROFILESBYUSERID, true);
        Continuation conti = (continuation)theController.startRequestsInParallel();

        Map<String, HttpRequest> requests = conti.getRequests();

        //only 1 request when order num not there
        System.assert(requests.size() == 1);

        //Order balance Response
        APIRequestResponseWrapper wrapper = theController.profileService.APItoWrapper.get(IADPaymentProfilesService.GETPROFILESBYUSERID);
        System.assert(wrapper != null);
        system.debug('response ' + wrapper);

        // Perform mock callout

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getPaymentProfilesResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);



        //post refund
        theController.refundService.clearMessages();
        ApexPages.currentPage().getParameters().put('totalAmount', '12.34');
        theController.setProfileIdManual();
        theController.profileId = 'pp1234';
        theController.comments = '1234';
        theController.selectedReason = '1';
        theController.email = 'test@something.com';
        theController.selectedPayment='1234';
        theController.pTransactionToProfileId.put('1234', '1234');

        IADContractBeans.IADPaymentProfileBean profile = new IADContractBeans.IADPaymentProfileBean();
        profile.profileId='1234';
        profile.isActive = true;

        theController.profileIdToProfile.put('1234', profile);

        theController.setSelectedPaymentManual();
        conti = (continuation)theController.processRefund();



        requests = conti.getRequests();
        System.assert(requests.size() == 1);
        wrapper = theController.refundService.APItoWrapper.get(IADInstallmentPaymentService.POSTREFUNDSTORECREDITTOCARD);
        System.assert(wrapper != null);
        system.debug('response ' + wrapper);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        response = new HttpResponse();
        responseBody = IADTestDataUtil.postPaymentResponse();
        response.setBody(responseBody);
        response.setStatusCode(201);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(wrapper.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


    }

}