@isTest
private class IADStoreCreditTest
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
    @isTest static void testGetStoreCredits()
    {
        setupData();

        PageReference pageRef = Page.IADStoreCreditPanelPage;
        Test.setCurrentPage(pageRef);

        Order__c order1 = [select id from Order__c where name = '1234' limit 1];
        ApexPages.currentPage().getParameters().put('id', order1.Id);



        IADStoreCreditPanelController theController = new IADStoreCreditPanelController();
        //Async
        Continuation conti = (continuation)theController.populateStoreCredits();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.storeCreditPanelService.APItoWrapper.get(IADStoreCreditPanelService.GETSTORECREDITSBYCUSTOMERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getStoreCreditResponse();
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
        apiresponse.responseData = null;
        responseBody = '';
        response.setBody(responseBody);
        response.setStatusCode(500);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

    }

    @isTest static void testStoreCreditPanelErrors()
    {
        setupData();

        PageReference pageRef = Page.IADStoreCreditPanelPage;
        Test.setCurrentPage(pageRef);

        Test.startTest();

        Order__c order1 = [select id from Order__c where name = '1234' limit 1];
        ApexPages.currentPage().getParameters().put('id', order1.Id);



        IADStoreCreditPanelController theController = new IADStoreCreditPanelController();

        try{
            theController.storeCreditPanelService = null;
            theController.populateStoreCredits();
        }
        catch(exception e){}
        try{
            theController.storeCreditPanelService = null;
            theController.processStoreCredits();

        }
        catch(exception e){}
        try{
        theController.storeCreditPanelService = null;
        theController.storeCreditPanelService.getStoreCreditsByCustomerId('1234');
        }
        catch(exception e){}

        try{
            theController.storeCreditPanelService = null;
            theController.storeCreditPanelService.populateStoreCredits();
        }
        catch(exception e){}

        try{

            APIRequestResponseWrapper response = theController.storeCreditPanelService.APItoWrapper.get(IADStoreCreditPanelService.GETSTORECREDITSBYCUSTOMERID);
            response.responseData = null;
            theController.storeCreditPanelService.APItoWrapper.put(IADStoreCreditPanelService.GETSTORECREDITSBYCUSTOMERID, response);
            theController.storeCreditPanelService.populateStoreCredits();
        }
        catch(exception e){}

        Test.stopTest();

    }

    @isTest static void testGetStoreCredit()
    {
        setupData();

        PageReference pageRef = Page.IAdStoreCreditPage;
        Test.setCurrentPage(pageRef);


        ApexPages.currentPage().getParameters().put('storeCreditId', '1234');


        IADStoreCreditController theController = new IADStoreCreditController();
        Continuation conti = (continuation)theController.populateStoreCredit();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.storeCreditService.APItoWrapper.get(IADStoreCreditService.GETSTORECREDITSBYSTORECREDITID);
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


    @isTest static void testStoreCreditErrors()
    {
        setupData();

        PageReference pageRef = Page.IAdStoreCreditPage;
        Test.setCurrentPage(pageRef);

        Test.startTest();

        ApexPages.currentPage().getParameters().put('id', '1234');



        IADStoreCreditController theController = new IADStoreCreditController();

        try{
            APIRequestResponseWrapper response = theController.storeCreditService.APItoWrapper.get(IADStoreCreditService.GETSTORECREDITSBYSTORECREDITID);
            response.responseData = null;
            theController.storeCreditService.APItoWrapper.put(IADStoreCreditService.GETSTORECREDITSBYSTORECREDITID, response);
            theController.populateStoreCredit();

        }
        catch(exception e){}


        try {
            APIRequestResponseWrapper wrap = theController.storeCreditService.APItoWrapper.get(IADStoreCreditService.GETSTORECREDITSBYSTORECREDITID);
            wrap.endPointConfig = null;
            theController.storeCreditService.APItoWrapper.put(IADStoreCreditService.GETSTORECREDITSBYSTORECREDITID, wrap);
            theController.populateStoreCredit();
        }
        catch(exception e){}
        try {
            theController.storeCreditService = null;
            theController.processStoreCredit();

        }
        catch(exception e){}


        Test.stopTest();

    }


}