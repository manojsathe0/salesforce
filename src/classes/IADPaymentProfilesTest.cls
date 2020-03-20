/**
 * Created by jboles on 10/28/2016.
 */

@isTest
private class IADPaymentProfilesTest
{


    public static void setupData()
    {
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
        insert con1;

        Order__c order1 = new Order__c(Name = '1000', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order1;

    }
    @isTest static void testGetContactsByOrderIdAsync()
    {
        setupData();

        PageReference pageRef = Page.IADInstallmentPage;
        Test.setCurrentPage(pageRef);

        String selectOptions = '{"newPayment":"Add New Payment Method","27757127":"Master Card - 0005","27757124":"Visa - 0001","27757123":"Master Card - 0005","27757121":"Master Card - 0005","27757120":"Visa - 0001","27757119":"Visa - 0001","27757118":"Visa - 1111","27757116":"Visa - 1111","27757115":"Master Card - 0005","27757113":"Master Card - 0005","27757111":"Master Card - 0005","27757110":"Master Card - 0005","27757109":"Master Card - 0005","27757106":"Master Card - 0005","27757105":"American Express - 3453","27757104":"Master Card - 0005","27756997":"Visa - 0002","27756945":"Visa - 0002","27756890":"Visa - 0002","27756889":"Visa - 0001"}';

        ApexPages.currentPage().getParameters().put('orderid', '1234');
        
        ApexPages.currentPage().getParameters().put('paymentProfileId', '1234');
        ApexPages.currentPage().getParameters().put('selectOptions', selectOptions);


        IADPaymentProfilesComponentController theController = new IADPaymentProfilesComponentController();
        theController.invokingPageType = 'test';
        theController.orderId = '1234';

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
        responseBody = IADTestDataUtil.getPaymentProfilesResponse();
        response.setBody(responseBody);
        response.setStatusCode(404);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);


    }

    @isTest static void testErrors()
    {
        setupData();

        PageReference pageRef = Page.IADInstallmentPage;
        Test.setCurrentPage(pageRef);

        Test.startTest();
        IADPaymentProfilesComponentController theController = new IADPaymentProfilesComponentController();
        theController.dataService.populateProfiles();
        theController.processProfileResponse();
        try{

            theController.dataService = null;

            theController.populateProfiles();
        }
        catch(exception e){}

        Test.stopTest();

    }


}