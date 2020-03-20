/**
 * Created by jboles on 1/24/2017.
 */

@isTest
public with sharing class IADOrdersGridControllerTest
{
    @isTest static void setupData()
    {
        User u = [select id, profileid from User where name = 'Integration User' limit 1];

        system.runAs(u)
        {

            Contact con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789', fkUser__c='1234');
            insert con1;

            Order__c order1 = new Order__c( OrderID__c = '1234', Name = '1234', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='1234');
            insert order1;
        }

    }
    @isTest static void testGetOrders()
    {
        setupData();

        PageReference pageRef = Page.IADOrdersGrid;
        Test.setCurrentPage(pageRef);

        Contact con1 = [select id, fkUser__c from Contact where fkUser__c = '1234' limit 1];
        ApexPages.currentPage().getParameters().put('id', con1.fkUser__c);



        IADOrdersGridController theController = new IADOrdersGridController();
        //Async
        Continuation conti = (continuation)theController.populateOrders();

        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        APIRequestResponseWrapper apiresponse = theController.orderService.APItoWrapper.get(IADOrderPanelService.GETORDERSBYCUSTOMERID);
        System.assert(apiresponse != null);
        system.debug('response ' + apiresponse);

        // Perform mock callout
        // (i.e. skip the callout and call the callback method)

        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrdersResponse();
        response.setBody(responseBody);
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);
        // Set the fake response for the continuation
        Test.setContinuationResponse(apiresponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
        IADContractBeans.IADOrderBean orderBean = new IADContractBeans.IADOrderBean();
        orderBean.orderId = '12345';
        List<IADContractBeans.IADOrderItem> orderItems = new List<IADContractBeans.IADOrderItem>();
        IADContractBeans.IADOrderItem orderItem = new IADContractBeans.IADOrderItem();
        orderItem.processingOrder = new IADContractBeans.ProcessingOrder();
        orderItem.processingOrder.processingOrderId = '12345';
        orderItems.add(orderItem);
        orderBean.orderItems = orderItems;
        theController.orderIdToOrderMap.put('1234', orderBean);
        theController.oldOrderNum='12345';
        theController.createOrder();
        theController.oldOrderNum='12345';
        theController.createOrder();



    }

    @isTest static void testGetOrdersErrors()
    {
        setupData();

        PageReference pageRef = Page.IADOrdersGrid;
        Test.setCurrentPage(pageRef);

        Test.startTest();

        Contact con1 = [select id, fkUser__c from Contact where fkUser__c = '1234' limit 1];
        ApexPages.currentPage().getParameters().put('id', con1.fkUser__c);



        IADOrdersGridController theController = new IADOrdersGridController();
        try{
            theController.orderService = null;
            theController.populateOrders();
        }
        catch(exception e){}
        try{
            theController.orderService = null;
            theController.orderService.populateOrders();
        }
        catch(exception e){}
        try{
            theController.orderService = null;
            theController.processOrdersResponse();

        }
        catch(exception e){}
        try{

            APIRequestResponseWrapper response = theController.orderService.APItoWrapper.get(IADOrderPanelService.GETORDERSBYCUSTOMERID);
            response.responseData = null;
            theController.orderService.APItoWrapper.put(IADOrderPanelService.GETORDERSBYCUSTOMERID, response);
            theController.orderService.populateOrders();
        }
        catch(exception e){}

        Test.stopTest();
    }

}