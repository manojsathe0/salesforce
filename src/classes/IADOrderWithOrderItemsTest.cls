@isTest
private class IADOrderWithOrderItemsTest
{
    static Contact con1;
    static Order__c order1;

    public static void setupData() 
    {
        con1 = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '123456789');
        insert con1;
        
        order1 = new Order__c(Name = '1000', OrderID__c = '1000', Contact__c = con1.Id, State_of_Formation__c = '11', Entity_Name__c = '12', Order_Date_Time_Created__c = DateTime.newInstance(2015, 12, 07, 12, 12, 01), Order_Date_Time_Modified__c = DateTime.newInstance(2015, 12, 08, 12, 12, 01), User_Order_ID__c='123');
        insert order1;
    }
    
    static testMethod void testOpeningAPIAsync()
    {
        setupData();
    
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', order1.Id);
         
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        theController.clearFlags();
        theController.orderService.APItoAsync.put(IADOrderWithOrderItemsService.GETORDERBYORDERID, true);
        theController.orderService.APItoAsync.put(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, true);
      
        Continuation conti = (continuation)theController.startRequestsInParallel();
        
        Map<String, HttpRequest> requests = conti.getRequests();
       
        //parrallel requests have 3 responses currently
        System.assert(requests.size() == 2);
        
        //Order Response
        APIRequestResponseWrapper orderResponse = theController.orderService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERBYORDERID);
        System.assert(orderResponse != null);
        system.debug('response ' + orderResponse);
        
        system.debug('errors  ' + theController.orderService.iadMessages);
        // Perform mock callout 
        
        HttpResponse response = new HttpResponse();
        String responseBody = IADTestDataUtil.getOrderResponse();
        response.setBody(responseBody); 
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);  
        // Set the fake response for the continuation     
        Test.setContinuationResponse(orderResponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
        
        //Order Balance Response
        
        APIRequestResponseWrapper orderBalanceResponse = theController.orderService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID);
        System.assert(orderBalanceResponse != null);
        system.debug('response ' + orderBalanceResponse);
        
        // Perform mock callout 
        
        response = new HttpResponse();
        responseBody = IADTestDataUtil.getOrderBalanceResponse();
        response.setBody(responseBody); 
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);  
        // Set the fake response for the continuation     
        Test.setContinuationResponse(orderBalanceResponse.requestLabelContinuation , response);
        result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
        
        
      
        
    }

    static testMethod void testOpeningAPIAsync_BadResponse()
    {
        setupData();
    
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', order1.Id);
         
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        
        theController.orderService.APItoAsync.put(IADOrderWithOrderItemsService.GETORDERBYORDERID, true);
        theController.orderService.APItoAsync.put(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, true);
        //theController.orderService.APItoAsync.put(IADOrderWithOrderItemsService.GETORDERPROMOCODESBYORDERID, true);
        Continuation conti = (continuation)theController.startRequestsInParallel();
        
        Map<String, HttpRequest> requests = conti.getRequests();
       
        //parrallel requests have 3 responses currently
        System.assert(requests.size() == 2);
        
        //Order Response
        APIRequestResponseWrapper orderResponse = theController.orderService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERBYORDERID);
        System.assert(orderResponse != null);
        system.debug('response ' + orderResponse);
        
        system.debug('errors  ' + theController.orderService.iadMessages);
        // Perform mock callout 
        
        HttpResponse response = new HttpResponse();
        String responseBody = JSON.serialize(IADTestDataUtilOrder.getOrderBean()); //making response bad
        response.setBody(responseBody); 
        response.setStatusCode(200);
        system.debug('responseBody-----'+responseBody);  
        // Set the fake response for the continuation     
        Test.setContinuationResponse(orderResponse.requestLabelContinuation , response);
        Object result = Test.invokeContinuationMethod(theController , conti);
        System.assertEquals(null, result);
         
        
    }
    
    static testmethod void testOpeningAPISync()
    {
        setupData();
   
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', order1.Id);
         
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        
        theController.orderService.APItoAsync.put(IADOrderWithOrderItemsService.GETORDERBYORDERID, false);
        theController.orderService.APItoAsync.put(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, false);
        
        
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getOrderResponse();
        mock.statusCode=200;
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        theController.startRequestsInParallel();
    
        
        HttpResponse res = theController.orderService.APIToWrapper.get(IADOrderWithOrderItemsService.GETORDERBYORDERID).theResponse;
        
        mock = new IADTestMockGenerator();
        mock.testBody = IADTestDataUtil.getOrderBalanceResponse();
        mock.statusCode=200;
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        theController.startRequestsInParallel();
    
        
        //res = theController.orderService.APIToWrapper.get(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID).theResponse;
    }
    
    
    static testMethod void testPopulateActionItemsByOrderItemId()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderItemId', '5678');
        ApexPages.currentPage().getParameters().put('actionType', 'addItem');

        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        theController.orderService.APItoAsync.put(IADOrderWithOrderItemsService.GETACTIONITEMSBYORDERITEMID, true);
       
        Continuation conti = (Continuation)theController.populateActionItemsByOrderItemId();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);
        APIRequestResponseWrapper actionItemResponse = theController.orderService.APItoWrapper.get(IADOrderWithOrderItemsService.GETACTIONITEMSBYORDERITEMID);
        System.assert(requests.get(actionItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getActionItemsByOrderItemIdResponse());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(actionItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(IADTestDataUtilOrder.getActionItemsByOrderItemIdResponse().actionItems.size(), theController.orderService.currentActionItems.size(), 'Right Action Item should have been populated');
    }

    static testMethod void testPopulateActionItemsByOrderItemId_CauseException()
    {
        setupData();
        try
        {
            PageReference pageRef = Page.IADOrderWithOrderItems;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', order1.Id);
            ApexPages.currentPage().getParameters().put('orderItemId', '5678');
            ApexPages.currentPage().getParameters().put('actionType', 'addItem');

            IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
            theController.orderService.APItoAsync.put(IADOrderWithOrderItemsService.GETACTIONITEMSBYORDERITEMID, true);
            
            theController.orderService.APItoWrapper = null;

            Continuation conti = (Continuation)theController.populateActionItemsByOrderItemId();
            Map<String, HttpRequest> requests = conti.getRequests();
            system.assert(requests.size() == 1);
            APIRequestResponseWrapper actionItemResponse = theController.orderService.APItoWrapper.get(IADOrderWithOrderItemsService.GETACTIONITEMSBYORDERITEMID);
            System.assert(requests.get(actionItemResponse.requestLabelContinuation) != null);
            HttpResponse response = new HttpResponse();
            String serializedString = JSON.serialize(IADTestDataUtilOrder.getActionItemsByOrderItemIdResponse());
            response.setBody(serializedString);   
            response.setStatusCode(200);
            
            Test.setContinuationResponse(actionItemResponse.requestLabelContinuation, response);
            Object result = Test.invokeContinuationMethod(theController, conti);
            System.assertEquals(null, result);
            System.assertEquals(IADTestDataUtilOrder.getActionItemsByOrderItemIdResponse().actionItems.size(), theController.orderService.currentActionItems.size(), 'Right Action Item should have been populated');
        }
        catch(Exception theExp)
        {

        }
    }

   
    
    static testMethod void testModifyOrderItem_AddAddOn()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');

        ApexPages.currentPage().getParameters().put('orderItemId', '567890');
        ApexPages.currentPage().getParameters().put('productConfigurationId', '983712');

        
        Map<String,IADContractBeans.IADActionItem> productConfigurationIdToActionItem = new Map<String,IADContractBeans.IADActionItem>();

        for(IADContractBeans.IADActionItem theItem : IADTestDataUtilOrder.getMultipleActionItemsByOrderItemIdResponse().actionItems)
        {
            productConfigurationIdToActionItem.put(theItem.productConfigurationId , theItem);
        } 
       
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        theController.orderService.productConfigurationIdToActionItem = productConfigurationIdToActionItem;

        Continuation conti = (Continuation)theController.modifyOrderItem();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderItemResponse());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(1, theController.orderService.modifiedOrderItemWrappers.size(), '1 Item should be present in the list');


    }

    static testMethod void testModifyOrderItem_AddAddOn_BadResponse()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');

        ApexPages.currentPage().getParameters().put('orderItemId', '567890');
        ApexPages.currentPage().getParameters().put('productConfigurationId', '983712');

        
        Map<String,IADContractBeans.IADActionItem> productConfigurationIdToActionItem = new Map<String,IADContractBeans.IADActionItem>();

        for(IADContractBeans.IADActionItem theItem : IADTestDataUtilOrder.getMultipleActionItemsByOrderItemIdResponse().actionItems)
        {
            productConfigurationIdToActionItem.put(theItem.productConfigurationId , theItem);
        } 
       
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        theController.orderService.productConfigurationIdToActionItem = productConfigurationIdToActionItem;

        Continuation conti = (Continuation)theController.modifyOrderItem();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getBadOrderItemResponse());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
    

    }

    static testMethod void testModifyOrderItem_AddAddOn_CauseException()
    {
        //productConfigurationIdToActionItem is not set which causes Exception
        setupData();
        try
        {
            PageReference pageRef = Page.IADOrderWithOrderItems;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', order1.Id);
            ApexPages.currentPage().getParameters().put('orderId', '1000');

            ApexPages.currentPage().getParameters().put('orderItemId', '567890');
            ApexPages.currentPage().getParameters().put('productConfigurationId', '983712');
    
            IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
            Continuation conti = (Continuation)theController.modifyOrderItem();
           
        }
        catch(Exception theExp)
        {

        }

    }

     static testMethod void testModifyOrderItem_AddAddCrossSell()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');

        ApexPages.currentPage().getParameters().put('orderItemId', '5678901');
        ApexPages.currentPage().getParameters().put('productConfigurationId', '9837121');

        
        Map<String,IADContractBeans.IADActionItem> productConfigurationIdToActionItem = new Map<String,IADContractBeans.IADActionItem>();

        for(IADContractBeans.IADActionItem theItem : IADTestDataUtilOrder.getMultipleActionItemsByOrderItemIdResponse().actionItems)
        {
            productConfigurationIdToActionItem.put(theItem.productConfigurationId , theItem);
        } 
       
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        theController.orderService.productConfigurationIdToActionItem = productConfigurationIdToActionItem;

        Continuation conti = (Continuation)theController.modifyOrderItem();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderItemResponse());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(1, theController.orderService.modifiedOrderItemWrappers.size(), '1 Item should be present in the list');


    }

     static testMethod void testModifyOrderItem_AddShipping()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '10003');

        ApexPages.currentPage().getParameters().put('orderItemId', '5678903');
        ApexPages.currentPage().getParameters().put('productConfigurationId', '9837123');

        
        Map<String,IADContractBeans.IADActionItem> productConfigurationIdToActionItem = new Map<String,IADContractBeans.IADActionItem>();

        for(IADContractBeans.IADActionItem theItem : IADTestDataUtilOrder.getMultipleActionItemsByOrderItemIdResponse().actionItems)
        {
            productConfigurationIdToActionItem.put(theItem.productConfigurationId , theItem);
        } 
       
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        theController.orderService.productConfigurationIdToActionItem = productConfigurationIdToActionItem;

        Continuation conti = (Continuation)theController.modifyOrderItem();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderItemResponse());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(1, theController.orderService.modifiedOrderItemWrappers.size(), '1 Item should be present in the list');


    }

    static testMethod void testModifyOrderItem_AddAddFilingFee()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '10002');

        ApexPages.currentPage().getParameters().put('orderItemId', '567890');
        ApexPages.currentPage().getParameters().put('productConfigurationId', '9837122');

        
        Map<String,IADContractBeans.IADActionItem> productConfigurationIdToActionItem = new Map<String,IADContractBeans.IADActionItem>();

        for(IADContractBeans.IADActionItem theItem : IADTestDataUtilOrder.getMultipleActionItemsByOrderItemIdResponse().actionItems)
        {
            productConfigurationIdToActionItem.put(theItem.productConfigurationId , theItem);
        } 
       
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        theController.orderService.productConfigurationIdToActionItem = productConfigurationIdToActionItem;

        Continuation conti = (Continuation)theController.modifyOrderItem();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderItemResponse());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(1, theController.orderService.modifiedOrderItemWrappers.size(), '1 Item should be present in the list');


    }



    static testMethod void testModifyOrderItem_CancelCrossSell()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');

        ApexPages.currentPage().getParameters().put('orderItemId', '5678901');
        ApexPages.currentPage().getParameters().put('productConfigurationId', '98063733');//Cancel Cross Sell

        
        Map<String,IADContractBeans.IADActionItem> productConfigurationIdToActionItem = new Map<String,IADContractBeans.IADActionItem>();

        for(IADContractBeans.IADActionItem theItem : IADTestDataUtilOrder.getMultipleActionItemsByOrderItemIdResponse().actionItems)
        {
            productConfigurationIdToActionItem.put(theItem.productConfigurationId , theItem);
        } 
       
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        theController.orderService.productConfigurationIdToActionItem = productConfigurationIdToActionItem;

        Continuation conti = (Continuation)theController.modifyOrderItem();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderItemResponse());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(1, theController.orderService.modifiedOrderItemWrappers.size(), '1 Item should be present in the list');
    }

    static testMethod void testModifyOrderItem_Change()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');

        ApexPages.currentPage().getParameters().put('orderItemId', '5678');
        ApexPages.currentPage().getParameters().put('productConfigurationId', '980637'); //Change Package

        
        Map<String,IADContractBeans.IADActionItem> productConfigurationIdToActionItem = new Map<String,IADContractBeans.IADActionItem>();

        for(IADContractBeans.IADActionItem theItem : IADTestDataUtilOrder.getMultipleActionItemsByOrderItemIdResponse().actionItems)
        {
            productConfigurationIdToActionItem.put(theItem.productConfigurationId , theItem);
        } 
       
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        theController.orderService.productConfigurationIdToActionItem = productConfigurationIdToActionItem;

        Continuation conti = (Continuation)theController.modifyOrderItem();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderBean());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(1, theController.orderService.modifiedOrderItemWrappers.size(), '1 Item should be present in the list');
    }

    static testMethod void testModifyOrderItem_Change_Shipping()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');

        ApexPages.currentPage().getParameters().put('orderItemId', '5678904');
        ApexPages.currentPage().getParameters().put('productConfigurationId', '9837124'); //Change Shipping

        
        Map<String,IADContractBeans.IADActionItem> productConfigurationIdToActionItem = new Map<String,IADContractBeans.IADActionItem>();

        for(IADContractBeans.IADActionItem theItem : IADTestDataUtilOrder.getMultipleActionItemsByOrderItemIdResponse().actionItems)
        {
            productConfigurationIdToActionItem.put(theItem.productConfigurationId , theItem);
        } 
       
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        theController.orderService.productConfigurationIdToActionItem = productConfigurationIdToActionItem;

        Continuation conti = (Continuation)theController.modifyOrderItem();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderItemResponse());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(1, theController.orderService.modifiedOrderItemWrappers.size(), '1 Item should be present in the list');
    }

    static testMethod void testModifyOrderItem_AddRenewal()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');

        ApexPages.currentPage().getParameters().put('orderItemId', '5678905');
        ApexPages.currentPage().getParameters().put('productConfigurationId', '9837125');

        
        Map<String,IADContractBeans.IADActionItem> productConfigurationIdToActionItem = new Map<String,IADContractBeans.IADActionItem>();

        for(IADContractBeans.IADActionItem theItem : IADTestDataUtilOrder.getMultipleActionItemsByOrderItemIdResponse().actionItems)
        {
            productConfigurationIdToActionItem.put(theItem.productConfigurationId , theItem);
        } 
       
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        theController.orderService.productConfigurationIdToActionItem = productConfigurationIdToActionItem;

        Continuation conti = (Continuation)theController.modifyOrderItem();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderBean());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(1, theController.orderService.modifiedOrderItemWrappers.size(), '1 Item should be present in the list');


    }


    static testMethod void testModifyOrderItem_Change_CauseException()
    {
        setupData();
        try
        {
            PageReference pageRef = Page.IADOrderWithOrderItems;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', order1.Id);
            ApexPages.currentPage().getParameters().put('orderId', '1000');

            ApexPages.currentPage().getParameters().put('orderItemId', '5678');
            ApexPages.currentPage().getParameters().put('productConfigurationId', '980637'); //Change Package

            
            Map<String,IADContractBeans.IADActionItem> productConfigurationIdToActionItem = new Map<String,IADContractBeans.IADActionItem>();

            for(IADContractBeans.IADActionItem theItem : IADTestDataUtilOrder.getMultipleActionItemsByOrderItemIdResponse().actionItems)
            {
                productConfigurationIdToActionItem.put(theItem.productConfigurationId , theItem);
            } 
           
            IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
            theController.orderService.productConfigurationIdToActionItem = productConfigurationIdToActionItem;
            theController.orderService.APItoWrapper = null;

            Continuation conti = (Continuation)theController.modifyOrderItem();
            Map<String, HttpRequest> requests = conti.getRequests();
            system.assert(requests.size() == 1);

            APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
            System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
            HttpResponse response = new HttpResponse();
            String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderBean());
            response.setBody(serializedString);   
            response.setStatusCode(200);
            
            Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
            Object result = Test.invokeContinuationMethod(theController, conti);
            System.assertEquals(null, result);
            System.assertEquals(1, theController.orderService.modifiedOrderItemWrappers.size(), '1 Item should be present in the list');
        }
        catch(Exception theExp)
        {

        }
    }

    static testMethod void testConvertOrderTo3Pay()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
      

        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        
        Continuation conti = (Continuation)theController.convertOrderTo3pay();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(IADOrderWithOrderItemsService.PUTORDERTO3PAYBYORDERID);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderBean());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(1, theController.orderService.modifiedOrderItemWrappers.size(), '1 Item should be present in the list');
    }

    static testMethod void testConvertOrderTo3Pay_CauseException()
    {
        setupData();
        try
        {
            PageReference pageRef = Page.IADOrderWithOrderItems;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', order1.Id);
          

            IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
            theController.orderService.APItoWrapper = null; //Causes the exception

            Continuation conti = (Continuation)theController.convertOrderTo3pay();
            Map<String, HttpRequest> requests = conti.getRequests();
            system.assert(requests.size() == 1);

            APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(IADOrderWithOrderItemsService.PUTORDERTO3PAYBYORDERID);
            System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
            HttpResponse response = new HttpResponse();
            String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderBean());
            response.setBody(serializedString);   
            response.setStatusCode(200);
            
            Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
            Object result = Test.invokeContinuationMethod(theController, conti);
            System.assertEquals(null, result);
        }
        catch (Exception theExp)
        {

        }
    }

    static testMethod void testConvertOrderTo3Pay_BadResponse()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
      

        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        
        Continuation conti = (Continuation)theController.convertOrderTo3pay();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(IADOrderWithOrderItemsService.PUTORDERTO3PAYBYORDERID);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getBadOrderBean());
        response.setBody(serializedString+';;');   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
      
    }

    static testMethod void testCreateMiscItem()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');
            
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        Continuation conti = (Continuation)theController.createMiscItem();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderItemResponse());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        System.assertEquals(1, theController.orderService.modifiedOrderItemWrappers.size(), '1 Item should be present in the list');
    }

    static testMethod void testCreateMiscItem_CauseException()
    {
        setupData();
        try
        {
            PageReference pageRef = Page.IADOrderWithOrderItems;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', order1.Id);
            ApexPages.currentPage().getParameters().put('orderId', '1000');
                
            IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
            theController.orderService.APItoWrapper = null; //Causes Exception
            Continuation conti = (Continuation)theController.createMiscItem();
            Map<String, HttpRequest> requests = conti.getRequests();
            system.assert(requests.size() == 1);

            APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
            System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
            HttpResponse response = new HttpResponse();
            String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderItemResponse());
            response.setBody(serializedString);   
            response.setStatusCode(200);
            
            Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
            Object result = Test.invokeContinuationMethod(theController, conti);
            System.assertEquals(null, result);
            System.assertEquals(1, theController.orderService.modifiedOrderItemWrappers.size(), '1 Item should be present in the list');
        }
        catch (Exception theExp)
        {

        }
    }

 

    static testMethod void testCreateMiscItem_BadResponse()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');
            
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        Continuation conti = (Continuation)theController.createMiscItem();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getBadOrderItemResponse());
        response.setBody(serializedString+';;');   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
      
    }


    static testMethod void testCancelOrder()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');
            
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        Continuation conti = (Continuation)theController.callCancelOrder();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderBean());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
       
    }

    static testMethod void testCancelOrder_CauseException()
    {
        setupData();
        try
        {
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');
            
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        theController.orderService.APItoWrapper = null;
        Continuation conti = (Continuation)theController.callCancelOrder();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getBadOrderBean());
        response.setBody(serializedString+';;');   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
        }
        catch(Exception theExp)
        {

        }
    }

    static testMethod void testUnCancelOrder()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');
            
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        Continuation conti = (Continuation)theController.callUnCancelOrder();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(theController.orderService.currentAPIEndPoint);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderBean());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
       
    }

    static testMethod void testPopulateOrderHistory()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');
            
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        Continuation conti = (Continuation)theController.populateOrderHistory();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERHISTORYBYORDERID);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderHistoryBean());
        response.setBody(serializedString);   
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
    }

    static testMethod void testPopulateOrderHistory_CauseException()
    {
        setupData();
        try
        {
         
            PageReference pageRef = Page.IADOrderWithOrderItems;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', order1.Id);
            ApexPages.currentPage().getParameters().put('orderId', '1000');
                
            IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
            
            theController.orderService.APItoWrapper = null; //Causes Exception

            Continuation conti = (Continuation)theController.populateOrderHistory();
            Map<String, HttpRequest> requests = conti.getRequests();
            system.assert(requests.size() == 1);

            APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERHISTORYBYORDERID);
            System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
            HttpResponse response = new HttpResponse();
            String serializedString = JSON.serialize(IADTestDataUtilOrder.getOrderHistoryBean());
            response.setBody(serializedString);   
            response.setStatusCode(200);
            
            Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
            Object result = Test.invokeContinuationMethod(theController, conti);
            System.assertEquals(null, result);
        }
        catch(Exception theExp)
        {

        }
    }
    
    
    static testMethod void testPopulateOrderHistory_BadResponse()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');
            
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        Continuation conti = (Continuation)theController.populateOrderHistory();
        Map<String, HttpRequest> requests = conti.getRequests();
        system.assert(requests.size() == 1);

        APIRequestResponseWrapper theItemResponse = theController.orderService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERHISTORYBYORDERID);
        System.assert(requests.get(theItemResponse.requestLabelContinuation) != null);
        HttpResponse response = new HttpResponse();
        IADContractBeans.IADOrderHistoryBean theBean = IADTestDataUtilOrder.getOrderHistoryBean();
        theBean.orderItemsHistory[0].history[0].createdDate = 'Bad Data'; //Throws and exception

        String serializedString = JSON.serialize(theBean);
        response.setBody(serializedString);  
        response.setStatusCode(200);
        
        Test.setContinuationResponse(theItemResponse.requestLabelContinuation, response);
        Object result = Test.invokeContinuationMethod(theController, conti);
        System.assertEquals(null, result);
    }


    static testMethod void testRefreshPage()
    {
        setupData();
        PageReference pageRef = Page.IADOrderWithOrderItems;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', order1.Id);
        ApexPages.currentPage().getParameters().put('orderId', '1000');
            
        IADOrderWithOrderItemsController theController = new IADOrderWithOrderItemsController();
        Test.startTest();
            PageReference pr = theController.refreshPage();
        Test.stopTest();
        System.assertEquals(null , pr , 'Page Referene should be null');

    }
    
    
}