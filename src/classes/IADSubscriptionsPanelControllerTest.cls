@isTest
private class IADSubscriptionsPanelControllerTest {
    
    static Contact con1;
    static Order__c order1;
    static void setupData()
    {
            User u = [select id, profileid from User where name = 'Integration User' limit 1];

            system.runAs(u)
            {
                con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
                insert con1;

                order1 = new Order__c( Name = '1000', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
                insert order1;
           }
    }

    static testMethod void testPopulateSubscriptionByorderId()
    {
        setupData();
        PageReference pageRef = Page.IADSubscriptionsPanelPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', order1.Id);
       
        IADSubscriptionsPanelController theController = new IADSubscriptionsPanelController();
        
        theController.subscriptionService.APItoAsync.put(IADSubscriptionPanelService.GETSUBSCRIPTIONSBYORDERID, true);

        //Async
        Continuation conti;

        theController.orderId = null;
        conti = (continuation)theController.populateSubscriptions(); //Exception Occurs

        theController.orderId = order1.Name;
        conti = (continuation)theController.populateSubscriptions(); 

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.subscriptionService.APItoWrapper.get(IADSubscriptionPanelService.GETSUBSCRIPTIONSBYORDERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getSubscriptionByOrderIdResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

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
    

    }


    
}