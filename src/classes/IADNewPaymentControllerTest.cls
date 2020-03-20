@isTest
private class IADNewPaymentControllerTest
{


    @isTest static void setupData()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];

        system.runAs(u)
        {

            Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;
            Relationship_Type__c rt = new Relationship_Type__c(name='test', Relationship_Type_ID__c = '1234');
            insert rt;
            Product2 prod = new Product2(Name='test', LZ_Product_ID__c=123, Relationship_Type__c = rt.id);

            insert prod;

            Order__c order1 = new Order__c( Name = '1234',
                    Contact__c = con1.Id,
                    State_of_Formation__c = '11',
                    Entity_Name__c = '12',
                    Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01),
                    Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01),
                    User_Order_ID__c='1234',
                    Base_Product__c=prod.id);
            insert order1;
        }

    }
    @isTest static void testPostNewPayment()
    {
        setupData();

        PageReference pageRef = Page.IADAddNewPayment;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('orderid', '1234');



        IADNewPaymentController theController = new IADNewPaymentController();
        IADContractBeans.IADNewPaymentProfileRequestBean theBean =  (IADContractBeans.IADNewPaymentProfileRequestBean) JSON.deserialize(IADTestDataUtil.postPaymentProfile() , IADContractBeans.IADNewPaymentProfileRequestBean.class);
        theController.newPayment = theBean.paymentProfile;
        //Async
        Continuation conti = (continuation)theController.addNewPayment();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.newPaymentService.APItoWrapper.get(IADNewPaymentService.ADDNEWPAYMENT);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getPaymentProfileResponse();
        response.setBody(responseBody);
        response.setStatusCode(201);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //errors

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(201);
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

    @isTest static void testPostNewPaymentErrors()
    {
        setupData();

        PageReference pageRef = Page.IADAddNewPayment;
        Test.setCurrentPage(pageRef);

        Test.startTest();

        ApexPages.currentPage().getParameters().put('orderid', '1234');


        IADNewPaymentController theController = new IADNewPaymentController();
        try{
            theController.newPayment.accountNumber = '1220';
            theController.newPayment.accountType = UtilityLibrary.profileNameToAccountTypeMap.get('American Express');
            if(System.today().month()==1)
            {
                theController.newPayment.month = 12;
            }
            else
            {
                theController.newPayment.month = System.today().month()-1;
            }
            theController.newPayment.year = System.today().year();
            theController.addNewPayment();
        }
        catch(exception e){}
        try{
            theController.newPaymentService = null;
            theController.newPaymentService.postNewPayment(null);
        }
        catch(exception e){}
        try{
            theController.newPaymentService = null;
            theController.processAddPaymentProfileResponse();

        }
        catch(exception e){}
        try {

            APIRequestResponseWrapper response = theController.newPaymentService.APItoWrapper.get(IADNewPaymentService.ADDNEWPAYMENT);
            response.responseData = null;
            theController.newPaymentService.APItoWrapper.put(IADNewPaymentService.ADDNEWPAYMENT, response);
            theController.newPaymentService.postNewPayment(null);
        }
        catch(exception e){}

        Test.stopTest();

    }

    @isTest static void testPopulateProfiles()
    {
        setupData();

        PageReference pageRef = Page.IADAddNewPayment;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('orderid', '1234');

        IADNewPaymentController theController = new IADNewPaymentController();
        //Async
        Continuation conti = (continuation)theController.populateTheProfiles();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.paymentProfileService.APItoWrapper.get(IADPaymentProfilesService.GETPROFILESBYUSERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getPaymentProfilesResponse();
        response.setBody(responseBody);
        response.setStatusCode(201);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //errors

        response = new HttpResponse();
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(201);
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

    @isTest static void testGetAndUpdateInstallments()
    {
        setupData();

        PageReference pageRef = Page.IADAddNewPayment;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('orderid', '1234');
        ApexPages.currentPage().getParameters().put('apiIndex', '0');
        ApexPages.currentPage().getParameters().put('wrapIds', 'inst1234');

        IADNewPaymentController theController = new IADNewPaymentController();
        //Async
        Continuation conti = (continuation)theController.makeAPICallout();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.instServiceClass.getAPItoWrapper().get(IADInstallmentService.GETINSTALLMENTSBYORDERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getInstallmentsResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //test get errors

//        response = new HttpResponse();
//        responseBody = '';
//        response.setBody(responseBody);
//        response.setStatusCode(200);
//        system.debug('responseBody-----'+responseBody);
//        // Set the fake response for the continuation
//        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
//        result = Test.invokeContinuationMethod(theController , conti);
//        System.assertEquals(null, result);
//
//        response = new HttpResponse();
//        responseBody = '';
//        response.setBody(responseBody);
//        response.setStatusCode(500);
//        system.debug('responseBody-----'+responseBody);
//        // Set the fake response for the continuation
//        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
//        result = Test.invokeContinuationMethod(theController , conti);
//        System.assertEquals(null, result);

        theController.populateWrappers();
        theController.populateUpdateChains();

        IADContractBeans.IADInstallmentBean inst = new IADContractBeans.IADInstallmentBean(); //
        system.debug('inst ' + inst);
        IADContractBeans.IADInstallmentUpdateBean updateBean = new IADContractBeans.IADInstallmentUpdateBean();
        updateBean.dueDate = '1234';
        updateBean.paymentProfileId = Integer.valueOf(1234);
        updateBean.updatedBy = UtilityLibrary.generateUpdatedBy();
        theController.installmentIdToInstallment.put('1234', inst);

        //now make update callout

        theController.newPaymentService.profileId='1234';
        ApexPages.currentPage().getParameters().put('apiIndex', '0');
        conti = (continuation)theController.makeAPICallout();

        requests = conti.getRequests();
        System.assert(requests.size() == 1);
        apiresponse = theController.instServiceClass.getAPItoWrapper().get(IADInstallmentService.PUTUPDATEINSTALLMENTBYINSTALLMENTID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);


        response = new HttpResponse();
        responseBody = IADTestDataUtil.getInstallmentResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


        //update errors testing

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
    @isTest static void testGetAndUpdateSubscriptions()
    {
        setupData();

        PageReference pageRef = Page.IADAddNewPayment;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('orderid', '1234');
        ApexPages.currentPage().getParameters().put('apiIndex', '1');
        ApexPages.currentPage().getParameters().put('wrapIds', 'sub1234');

        IADNewPaymentController theController = new IADNewPaymentController();
        //Async
        theController.apiIndex = 1;
        Continuation conti = (continuation)theController.makeAPICallout();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.subServiceClass.getAPItoWrapper().get(IADSubscriptionPanelService.GETSUBSCRIPTIONSBYORDERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);



        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getSubscriptionByOrderIdResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //get sub testing

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

        theController.populateWrappers();
        theController.populateUpdateChains();

        //now make update callout

        theController.newPaymentService.profileId='1234';
        ApexPages.currentPage().getParameters().put('apiIndex', '0');
        conti = (continuation)theController.makeAPICallout();

        requests = conti.getRequests();
        System.assert(requests.size() == 1);
        apiresponse = theController.subServiceClass.getAPItoWrapper().get(IADSubscriptionPanelService.PUTSUBSCRIPTIONBYSUBSCRIPTIONID);
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


        //update errors testing

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

        theController.syncProfileMessages();
        theController.closeModal();


    }

}