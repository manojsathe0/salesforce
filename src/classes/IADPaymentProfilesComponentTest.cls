/**
 * Created by jboles on 11/30/2016.
 */
@isTest
private class IADPaymentProfilesComponentTest 
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
    @isTest static void testGetPaymentProfiles()
    {
        setupData();

        PageReference pageRef = Page.IADEditPaymentPage;
        Test.setCurrentPage(pageRef);


        ApexPages.currentPage().getParameters().put('id', '1234');


        IADPaymentProfilesComponentController theController = new IADPaymentProfilesComponentController();
        theController.orderId = '1234';

        theController.userId = '1234';

        //Async
        Continuation conti = (continuation)theController.populateProfiles();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.dataService.APItoWrapper.get(IADPaymentProfilesService.GETPROFILESBYUSERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getPaymentProfilesResponse();
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
    @isTest static void testGetStoreCredits()
    {
        setupData();

        PageReference pageRef = Page.IADEditPaymentPage;
        Test.setCurrentPage(pageRef);


        ApexPages.currentPage().getParameters().put('id', '1234');


        IADPaymentProfilesComponentController theController = new IADPaymentProfilesComponentController();
        theController.orderId = '1234';
        theController.userId = '1234';

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
        String responseBody = IADTestDataUtil.getStoreCreditsByCustomerId();
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
        IADPaymentProfilesComponentController theController = new IADPaymentProfilesComponentController();

        try{
            theController.userId = null;
            theController.dataService = null;
            theController.populateProfiles();
        }
        catch(exception e){}
        try{
            theController.dataService = null;
            theController.processProfileResponse();

        }
        catch(exception e){}
        try{


            theController.dataService = null;
            theController.populateStoreCredits();
        }
        catch(exception e){}
        try{
            theController.dataService = null;
            theController.processStoreCredits();
        }
        catch(exception e){}
        try{
            APIRequestResponseWrapper response = theController.dataService.APItoWrapper.get(IADPaymentProfilesService.GETPROFILESBYUSERID);
            response.responseData = null;
            theController.dataService.APItoWrapper.put(IADPaymentProfilesService.GETPROFILESBYUSERID, response);
            theController.dataService.populateProfiles();
        }
        catch(exception e){}

        Test.stopTest();

    }
}