@isTest
private class IADInstallmentTest
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
    @isTest static void testGetInstallments()
    {
        setupData();

        PageReference pageRef = Page.IADInstallmentsPanelPage;
        Test.setCurrentPage(pageRef);

        Order__c order1 = [select id from Order__c where name = '1234' limit 1];
        ApexPages.currentPage().getParameters().put('id', order1.Id);



        IADInstallmentsPanelController theController = new IADInstallmentsPanelController();
        //Async
        Continuation conti = (continuation)theController.populateInstallments();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.installmentService.APItoWrapper.get(IADInstallmentService.GETINSTALLMENTSBYORDERID);
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
        System.assertNotEquals(null, result); //Result is continuation object coz there is chaining here.So Not Null.


        //For payment Profile API

        conti = (continuation)theController.populatePaymentProfiles();

        requests = conti.getRequests();
        System.assert(requests.size() == 1);
        apiresponse = theController.paymentProfileService.APItoWrapper.get(IADPaymentProfilesService.GETPROFILESBYUSERID);
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
    
    @isTest static void testInstallmentPanelErrors()
    {
        setupData();

        PageReference pageRef = Page.IADInstallmentsPanelPage;
        Test.setCurrentPage(pageRef);

        Test.startTest();

        Order__c order1 = [select id from Order__c where name = '1234' limit 1];
        ApexPages.currentPage().getParameters().put('id', order1.Id);



        IADInstallmentsPanelController theController = new IADInstallmentsPanelController();

        try{
            theController.installmentService = null;
            theController.installmentService.populateInstallments();
        }
        catch(exception e){}
        try{
            theController.installmentService = null;
            theController.processInstallmentResponse();

        }
        catch(exception e){}
        try{

            APIRequestResponseWrapper response = theController.installmentService.APItoWrapper.get(IADInstallmentService.GETINSTALLMENTSBYORDERID);
            response.responseData = null;
            theController.installmentService.APItoWrapper.put(IADInstallmentService.GETINSTALLMENTSBYORDERID, response);
            theController.installmentService.populateInstallments();
        }
        catch(exception e){}

        Test.stopTest();

    }

    @isTest static void testGetInstallment()
    {
        setupData();

        PageReference pageRef = Page.IADInstallmentPage;
        Test.setCurrentPage(pageRef);


        ApexPages.currentPage().getParameters().put('id', '1234');

        ApexPages.currentPage().getParameters().put('orderid', '1234');


        IADInstallmentController theController = new IADInstallmentController();
        theController.setProfileIdManual();
        //Async
        Continuation conti = (continuation)theController.populateInstallment();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.installmentService.APItoWrapper.get(IADInstallmentService.GETINSTALLMENTBYINSTALLMENTID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getInstallmentResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
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

    @isTest static void testPutIntallment()
    {
        setupData();

        PageReference pageRef = Page.IADInstallmentPage;
        Test.setCurrentPage(pageRef);


        ApexPages.currentPage().getParameters().put('id', '1234');

        ApexPages.currentPage().getParameters().put('orderid', '1234');

        IADInstallmentController theController = new IADInstallmentController();
        theController.theId = '1234';

        //call populate first to get data

        Continuation conti = (continuation)theController.populateInstallment();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.installmentService.APItoWrapper.get(IADInstallmentService.GETINSTALLMENTBYINSTALLMENTID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);


        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getInstallmentResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        theController.profileId='1234';
        theController.dueDate = date.today().format();
        //now call update
        conti = (continuation)theController.updateInstallment();

        requests = conti.getRequests();
        System.assert(requests.size() == 1);
        apiresponse = theController.installmentService.APItoWrapper.get(IADInstallmentService.PUTUPDATEINSTALLMENTBYINSTALLMENTID);
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

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

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
        System.assertEquals(null, result);requests = conti.getRequests();
        System.assert(requests.size() == 1);
        apiresponse = theController.installmentService.APItoWrapper.get(IADInstallmentService.PUTUPDATEINSTALLMENTBYINSTALLMENTID);
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

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

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

    @isTest static void testInstallmentErrors()
    {
        setupData();

        PageReference pageRef = Page.IADInstallmentPage;
        Test.setCurrentPage(pageRef);

        Test.startTest();

        ApexPages.currentPage().getParameters().put('id', '1234');

        ApexPages.currentPage().getParameters().put('orderid', '1234');


        IADInstallmentController theController = new IADInstallmentController();

        try{
            theController.dueDate = date.today().addDays(15).format();
            theController.updateInstallment();
            theController.dueDate = date.today().addDays(-1).format();
            theController.updateInstallment();
            theController.dueDate ='test';
            theController.updateInstallment();


        }
        catch(exception e){}
        try{

            theController.theId = null;
            theController.installmentService = null;
            theController.populateInstallment();
            theController.installmentService = null;
            theController.processInstallmentResponse();
            theController.installmentService = null;
            theController.populateInstallment();
            theController.installmentService = null;
            theController.updateInstallment();

            APIRequestResponseWrapper response = theController.installmentService.APItoWrapper.get(IADInstallmentService.GETINSTALLMENTBYINSTALLMENTID);
            response.responseData = null;
            theController.installmentService.APItoWrapper.put(IADInstallmentService.GETINSTALLMENTBYINSTALLMENTID, response);
            theController.installmentService.populateInstallment();

            response = theController.installmentService.APItoWrapper.get(IADInstallmentService.PUTUPDATEINSTALLMENTBYINSTALLMENTID);
            response.responseData = null;
            theController.installmentService.APItoWrapper.put(IADInstallmentService.PUTUPDATEINSTALLMENTBYINSTALLMENTID, response);
            theController.processInstallmentResponse();
        }
        catch(exception e){}

        Test.stopTest();

    }
    
   

}