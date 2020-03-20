@isTest
public with sharing class IADDiscountConntrollerTest {
    

    static testMethod void testApplyOrderDiscount()
    {
        PageReference pageRef = Page.IADDiscountPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('orderId', '1234');
      
        IADDiscountController theController = new IADDiscountController();
        List<SelectOption> reasons = theController.getReasonsForDiscount();
        theController.discountService.APItoAsync.put(IADDiscountService.POSTORDERSORDERDISCOUNTS, true);
        theController.discountAmount = 'abc';
        Continuation conti;
        conti = (continuation)theController.applyOrderDiscount();//Throws Exception
        theController.discountAmount = '';
        conti = (continuation)theController.applyOrderDiscount();//Gives Error
        
        theController.discountAmount = '100';
        conti = (continuation)theController.applyOrderDiscount();//Gives Error as no comments

        theController.orderId = null;
        conti = (continuation)theController.applyOrderDiscount(); //Throws Exception
    
        theController.comments = 'Some Comments';
        theController.orderId = '1234';
        try
        {
            conti = (continuation)theController.applyOrderDiscount();
        }
        catch(Exception theExp)
        {

        }
        theController.selectedDiscountReason = '1';
        conti = (continuation)theController.applyOrderDiscount();
        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.discountService.APItoWrapper.get(IADDiscountService.POSTORDERSORDERDISCOUNTS);

        
        HttpResponse response = new HttpResponse();
        String responseBody = '{ "orderDiscount": { "orderDiscountId": 0, "orderItemId": 0, "orderId": 0, "discountType": "unset", "valueAmount": 0, "memberGroupCode": 0, "customDiscountId": 0, "userDiscountLogId": 0, "comments": "string", "cancelled": true, "discountId": 0, "dateCreated": "2016-12-06T05:22:13.615Z", "createdBy": "string", "dateLastModified": "2016-12-06T05:22:13.615Z", "lastModifiedBy": "string" } }';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //Error
        response.setStatusCode(404);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

     

    }
    static testMethod void testPopulateDiscountDetails()
    {
        PageReference pageRef = Page.IADDiscountPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('orderId', '1234');
      
        IADDiscountController theController = new IADDiscountController();
        theController.orderService.APItoAsync.put(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, true);
        Continuation conti;
        conti = (continuation)theController.populateDiscountDetails();
        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.orderService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID);
        
        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrderBalanceUpdatedResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);

        //Error
        response.setStatusCode(404);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
   

    }

    static testMethod void testCancelOrderDiscount()
    {
        PageReference pageRef = Page.IADDiscountPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('orderId', '1234');
        ApexPages.currentPage().getParameters().put('orderDiscountId', '5678');
        IADDiscountController theController = new IADDiscountController();
        theController.setOrderDiscountId();
        theController.discountService.APItoAsync.put(IADDiscountService.POSTCANCELDISCOUNTBYDISCOUNTID, true);
        Continuation conti;
        conti = (continuation)theController.cancelDiscount();
        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.discountService.APItoWrapper.get(IADDiscountService.POSTCANCELDISCOUNTBYDISCOUNTID);
       
        HttpResponse response = new HttpResponse();
        String responseBody = '{ "orderDiscount": { "orderDiscountId": 0, "orderItemId": 0, "orderId": 0, "discountType": "unset", "valueAmount": 0, "memberGroupCode": 0, "customDiscountId": 0, "userDiscountLogId": 0, "comments": "string", "cancelled": true, "discountId": 0, "dateCreated": "2016-12-06T05:22:13.615Z", "createdBy": "string", "dateLastModified": "2016-12-06T05:22:13.615Z", "lastModifiedBy": "string" } }';
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
        //Error
        response.setStatusCode(404);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
  }
}