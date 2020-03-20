@isTest
private class IADEditPaymentTest
{

    @isTest static void setupData()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];

        system.runAs(u)
        {

            Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

            Order__c order1 = new Order__c( Name = '1000', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
            insert order1;
        }

    }
    @isTest static void testGetPayment()
    {
        setupData();

        PageReference pageRef = Page.IADEditPaymentPage;
        Test.setCurrentPage(pageRef);


        ApexPages.currentPage().getParameters().put('id', '1234');


        IADEditPaymentController theController = new IADEditPaymentController();

        //Async
        Continuation conti = (continuation)theController.populatePaymentProfile();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.dataService.APItoWrapper.get(IADEditPaymentService.GETPROFILEBYID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getPaymentProfileResponse();
        responseBody = responseBody.replace('2018', String.valueOf(system.now().year()-1));
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
    
    @isTest static void testPutPayment()
    {
        setupData();

        PageReference pageRef = Page.IADEditPaymentPage;
        Test.setCurrentPage(pageRef);


        ApexPages.currentPage().getParameters().put('id', '1234');
        
        IADEditPaymentController theController = new IADEditPaymentController();

         String profilebody ='{"zip":"34252","year":2022 , "customerId": 0, "state":"KY","phone":"4352345243","month":1,"lastName":"sdfasdf","firstName":"asdfasdfasdfasdfasdfasd","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}';
        IADContractBeans.IADPaymentProfileBean theProfile =  (IADContractBeans.IADPaymentProfileBean) JSON.deserialize(profilebody , IADContractBeans.IADPaymentProfileBean.class);
        theController.dataService.theProfile = theProfile;
        theController.dataService.theProfile.year = String.valueOf(System.today().year()-1);
        theController.updatePaymentProfile();
        theController.dataService.theProfile.year = String.valueOf(System.today().year());
        theController.updatePaymentProfile();
        
        Continuation conti = (continuation)theController.updatePaymentProfile();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.dataService.APItoWrapper.get(IADEditPaymentService.PUTPROFILEBYID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = '{"zip":"34252","year":2022 , "customerId": 0, "state":"KY","phone":"4352345243","month":1,"lastName":"sdfasdf","firstName":"asdfasdfasdfasdfasdfasd","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}';
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

    @isTest static void testErrors()
    {
        setupData();

        PageReference pageRef = Page.IADEditPaymentPage;
        Test.setCurrentPage(pageRef);

        Test.startTest();
        IADEditPaymentController theController = new IADEditPaymentController();
        theController.dataService.populateProfileById();
        theController.dataService.getPaymentProfileById('');

        try{
            theController.theId = null;
            theController.dataService = null;
            theController.populatePaymentProfile();
        }
        catch(exception e){}

        try{
            theController.dataService = null;
            theController.processProfile();

        }
        catch(exception e){}
        try{
            theController.dataService = null;
            theController.populatePaymentProfile();

        }
        catch(exception e){}
        try {
            theController.dataService = null;
            theController.updatePaymentProfile();

        }
        catch(exception e){}
        try {

            APIRequestResponseWrapper response = theController.dataService.APItoWrapper.get(IADEditPaymentService.GETPROFILEBYID);
            response.responseData = null;
            theController.dataService.APItoWrapper.put(IADEditPaymentService.GETPROFILEBYID, response);
            theController.dataService.populateProfileById();

            response = theController.dataService.APItoWrapper.get(IADEditPaymentService.PUTPROFILEBYID);
            response.responseData = null;
            theController.dataService.APItoWrapper.put(IADEditPaymentService.PUTPROFILEBYID, response);
            theController.processProfile();
            theController.dataService.putPopulateProfileById();
        }
        catch(exception e){}
        Test.stopTest();

    }
    
     @isTest static void testdeletePayment()
    {
        setupData();

        PageReference pageRef = Page.IADEditPaymentPage;
        Test.setCurrentPage(pageRef);


        ApexPages.currentPage().getParameters().put('id', '1234');
        
        IADEditPaymentController theController = new IADEditPaymentController();

         String profilebody ='{"zip":"34252","year":2022 , "customerId": 0, "state":"KY","phone":"4352345243","month":1,"lastName":"sdfasdf","firstName":"asdfasdfasdfasdfasdfasd","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}';
        IADContractBeans.IADPaymentProfileBean theProfile =  (IADContractBeans.IADPaymentProfileBean) JSON.deserialize(profilebody , IADContractBeans.IADPaymentProfileBean.class);
        theController.dataService.theProfile = theProfile;
        theController.dataService.theProfile.year = String.valueOf(System.today().year()-1);
        theController.DeletePaymentProfile();
        theController.dataService.theProfile.year = String.valueOf(System.today().year());
        theController.DeletePaymentProfile();
        
        Continuation conti = (continuation)theController.DeletePaymentProfile();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.dataService.APItoWrapper.get(IADEditPaymentService.DELETEPAYMENTPROFILEBYID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = '{"zip":"34252","year":2022 , "customerId": 0, "state":"KY","phone":"4352345243","month":1,"lastName":"sdfasdf","firstName":"asdfasdfasdfasdfasdfasd","city":"asdfa","addressLine2":"asdf","addressLine1":"sdfasd","accountType":"4","accountNumber":"342523452345234"}';
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



}