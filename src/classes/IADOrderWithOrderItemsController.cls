public with sharing class IADOrderWithOrderItemsController
{
   
   
    public final static String DATE_TIME_FORMAT = 'MM/dd/yyyy hh:mm a';
     
    public String removeIcon{get;set;}
    public String orderIcon{get;set;}
    public String downIcon{get;set;}
    //public String upsLogoFG{get;set;}
    //public String upsLogoBG{get;set;}
    public String documentIcon{get;set;}
    public String contactIcon{get;set;}
    public String gearIcon{get;set;}
    public String creditCardIcon{get;set;}
	public static Boolean isRA {get;set;} // added
    //public String cancellationReason{get;set;}
    public Boolean termsAccepted{get;set;}
    public Boolean isCancelled{get;set;}
    public Boolean isOnHold{get;set;}
    public String tosAccepted{get;set;}
    public String orderNumber{get;set;}
    public Order__c thisOrder {get;set;}
    public String theId{get;set;}
    public IADOrderWithOrderItemsService  orderService{get;set;}
    public List<Authorized_Contact__c> authorizedContacts{get;set;}
    public String customerId{get;set;}
    
    public String recordIcon{get;set;}
    public String inboxIcon{get;set;}
    public String settingsIcon{get;set;}
    public String pageIcon{get;set;}
    public String phoneHistoryIcon{get;set;}
    public string checkIcon {get;set;} // Padma @B-22215


    public IADOrderWithOrderItemsController()
    {
      
   
        removeIcon = IADSGVIconStrings.remove;
        orderIcon  = IADSGVIconStrings.order;
        downIcon = IADSGVIconStrings.down;
        documentIcon = IADSGVIconStrings.document;
        contactIcon = IADSGVIconStrings.contactIcon;
        gearIcon = IADSGVIconStrings.gearIcon;
        creditCardIcon = IADSGVIconStrings.creditCardIcon;
        phoneHistoryIcon = IADSGVIconStrings.phoneHistoryIcon;
        authorizedContacts = new List<Authorized_Contact__c>();    
        termsAccepted = false;
        isCancelled = false;
        isOnHold = false;

        tosAccepted = '03/22/2016 10:07 AM';
        orderService  = new IADOrderWithOrderItemsService();
        customerId =  ApexPages.currentPage().getParameters().get('customerId'); 
        orderNumber = ApexPages.currentPage().getParameters().get('orderId');
        recordIcon = IADSGVIconStrings.recordIcon;
        inboxIcon = IADSGVIconStrings.inboxIcon;
        settingsIcon = IADSGVIconStrings.settingsIcon;
        checkIcon =IADSGVIconStrings.checkIcon; // Padma @B-22215
        pageIcon = IADSGVIconStrings.pageIcon;


        if(orderNumber == ''|| orderNumber == null)
        {
            theId = ApexPages.currentPage().getParameters().get('id');
            thisOrder = [SELECT Id , Name , OrderID__c , Contact__r.FkUser__c,Language_Preferance__c, Order_Date_Time_Created__c, Date_Time_TOS_Accepted__c, TOS_Accepted__c, OrderTerms__c, CreatedBy.Name, LastModifiedBy.Name FROM Order__c WHERE Id = :theId limit 1][0];
            orderNumber = thisOrder.OrderID__c;
            customerId = thisOrder.Contact__r.FkUser__c;
            System.debug('This Order '+thisOrder);
            authorizedContacts = [select id, Contact__r.LZ_Order_Contact_ID__c, Contact__r.Name, Authorized_Order__c, Authorized_Order__r.Name from Authorized_Contact__c where Authorized_Order__r.Id=:theId and Inactive__c = false];
        }
         
    }

    public PageReference refreshPage()
    {
        return null;
    }

    public Object startRequestsInParallel()
    {
       
        orderService.is3PayConverted = false;
        Continuation continuationObject = new Continuation(60);
        continuationObject.continuationMethod='processAllResponses';
        try
        {
            orderService.initWrapper(IADOrderWithOrderItemsService.GETORDERBYORDERID, 'processAllResponses');
            continuationObject = (Continuation)orderService.getOrderByOrderId(continuationObject, orderNumber);
            
            orderService.initWrapper(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, 'processAllResponses');
            continuationObject = (Continuation)orderService.getOrderBalanceByOrderId(continuationObject, orderNumber);
             
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
   
        return continuationObject;
    }
    public void processAllResponses()
    {
        processOrderResponse();
        processOrderBalancesResponse();
      
       
    }
    //Callback method for Asynchronous
    public Object processOrderResponse()
    {
        try
        {
            orderService.populateOrder();
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
        return null;
    }

    public Object processOrderBalancesResponse()
    {
        try
        {
            orderService.populateOrderBalance();
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
        return null;
    }

    
   

    

    public Object populateActionItemsByOrderItemId()
    {
        orderService.clearMessages();
        String orderItemId = Apexpages.currentPage().getParameters().get('orderItemId');
        String actionType = Apexpages.currentPage().getParameters().get('actionType');
        Set<String> actionTypeIds = new Set<String>();
        if(actionType == 'changePackage')
        {
            //actionTypeIds.add('2');//Cancel Uncomment this to display Cancel Package Action Item
            actionTypeIds.add('3');//Change
        }
        else if(actionType == 'addItem')
        {
            actionTypeIds.add('0');//Add
        }
        Object continuationObject;
        try
        {
            orderService.initWrapper(IADOrderWithOrderItemsService.GETACTIONITEMSBYORDERITEMID, 'processActionItemsByOrderItemIdResponse');
            continuationObject = orderService.getActionItemsByOrderItemId(orderItemId , actionTypeIds);
        }
        catch(IADException theException)
        {
           orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
           orderService.populateErrorMessage(theException);
        }
        return continuationObject;
    }


    public Object processActionItemsByOrderItemIdResponse()
    {

        try
        {
            orderService.populateActionItems();
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
        return null;
    }

    public Object modifyOrderItem()
    {
        orderService.clearMessages();
        String productConfigurationId = Apexpages.currentPage().getParameters().get('productConfigurationId');
        String orderItemId = Apexpages.currentPage().getParameters().get('orderItemId');
        String orderId = Apexpages.currentPage().getParameters().get('orderId');
        Object continuationObject;
        try
        {
            if(orderService.productConfigurationIdToActionItem.get(productConfigurationId).actionItemsType == '0') //Only Trigger this for Adding Add On, Cross Sell , Shipping and Filing Fees
            {
                continuationObject = orderService.addOrderItem(productConfigurationId,orderNumber,orderItemId);
            }
            else if(orderService.productConfigurationIdToActionItem.get(productConfigurationId).actionItemsType == '2')//Cancel
            {
                continuationObject = orderService.cancelOrderItem(productConfigurationId,orderNumber);
            }
            else if(orderService.productConfigurationIdToActionItem.get(productConfigurationId).actionItemsType == '3')//Change
            {
                continuationObject = orderService.changeOrderItem(productConfigurationId,orderNumber,orderItemId); 
            }
        }
        catch(IADException theException)
        {
          orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
           orderService.populateErrorMessage(theException);
        }   
        return continuationObject;
    }


    public Object processOrderItemResponse()
    {
        try
        {
            orderService.processOrderItemResponse();
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
        return null;
    }

    public Object processOrderChangeResponse()
    {
        try
        {
            orderService.processOrderResponse();
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
        return null;
    }

  

    /*public List<selectOption> getCancellationReasons()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult fieldResult = IAD_Picklists__c.Order_Reasons_for_Cancellation__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry value : pickListValues)
        {
        options.add(new SelectOption(value.getLabel(), value.getValue()));
        }
        return options;

    }
    */

    public object callCancelOrder()
    {
        orderService.clearMessages();
        Object continuationObject;
        try
        {
            
            orderService.initWrapper(IADOrderWithOrderItemsService.DELETEORDERBYORDERID, 'processCancelUncancelOperationResponse');
            continuationObject = orderService.callCancelUnCancelOrder(orderNumber , 'Cancel');
           
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
        return continuationObject;
    }

    
    public object callUncancelOrder()
    {
        orderService.clearMessages();
        Object continuationObject;
        try
        {
          
            orderService.initWrapper(IADOrderWithOrderItemsService.PUTUNCANCELORDERBYORDERID, 'processCancelUncancelOperationResponse');
            continuationObject = orderService.callCancelUnCancelOrder(orderNumber , 'UnCancel');
            
        }
        catch(IADException theException)
        {
             orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
             orderService.populateErrorMessage(theException);
        }
       
        return continuationObject;

    }
    

    //Asynchronous Callback method for order cancel and uncalcel
    public Object processCancelUncancelOperationResponse()
    {
        
        try
        {
            orderService.processCancelUncancelResponse();
        }
        catch(IADException theException)
        {
           orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
             orderService.populateErrorMessage(theException);
        }
        return null;
    }


    public Object convertOrderTo3pay()
    {

        orderService.clearMessages();
        Object continuationObject;
        try
        {
            orderService.initWrapper(IADOrderWithOrderItemsService.PUTORDERTO3PAYBYORDERID , 'processConvert3PayResponse');
            continuationObject = orderService.convertOrderTo3Pay(orderNumber);
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
        return continuationObject;
    }

    public Object processConvert3PayResponse()
    {
        try
        {
            orderService.processConvert3PayResponse();
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
        return null;
    }



    public Object populateOrderHistory()
    {
        orderService.clearMessages();
        Object continuationObject;
        try
        {
            orderService.initWrapper(IADOrderWithOrderItemsService.GETORDERHISTORYBYORDERID , 'processOrderHistoryResponse');
            continuationObject = orderService.getOrderHistoryByOrderId(orderNumber);
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
        return continuationObject;
    }


    public Object processOrderHistoryResponse()
    {
        try
        {
            orderService.populateOrderHistory();
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
        return null;
    }

    public Object createMiscItem()
    {
        orderService.clearMessages();
        Object continuationObject;
        try
        {
            continuationObject = orderService.createMiscItemByOrderId(orderNumber);
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
        return continuationObject;
    }

    public void clearFlags()
    {
        orderService.cancelUnCancelResponse = false;
        orderService.clearMessages();
    }
}