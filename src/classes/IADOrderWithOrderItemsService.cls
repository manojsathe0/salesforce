public with sharing class IADOrderWithOrderItemsService  extends IADServiceBase
{
    public final static String GETORDERBYORDERID = 'GetOrderByOrderId';
    public final static String GETORDERBALANCESBYORDERID = 'GetOrderBalancesByOrderId';
    public final static String GETORDERHISTORYBYORDERID = 'GetOrderHistoryByOrderId';
    public final static String GETORDERPROMOCODESBYORDERID = 'GetOrderPromoCodesByOrderId';
    public final static String GETACTIONITEMSBYORDERITEMID = 'GetActionItemsByorderItemId';
    public final static String POSTADDONSBYORDERID = 'PostAddOnsByOrderId';
    public final static String POSTCROSSSELLSBYORDERID = 'PostCrossSellsByOrderId';
    public final static String POSTSHIPPINGBYORDERID = 'PostShippingByOrderId';
    public final static String POSTFILINGFEESBYORDERID = 'PostFilingFeesByOrderId';
    public final static String DELETEORDERITEMBYORDERITEMDID = 'DeleteOrderItemByOrderItemId';
    public final static String POSTPACKAGECHANGEBYORDERID = 'PostPackageChangeByOrderId';
    public final static String PUTORDERTO3PAYBYORDERID = 'PutOrderTo3PayByOrderId';
    public final static String POSTMISCITEMBYORDERID = 'PostMiscItemByOrderId';
    public final static String POSTRENEWALBYORDERITEMID = 'PostRenewalByOrderItemId';
    public final static String DELETEORDERBYORDERID = 'DeleteOrderByOrderID';
    public final static String PUTORDERBYORDERID = 'PutOrderByOrderId';
    public final static String PUTSHIPPINGBYORDERITEMID = 'PutShippingByOrderItemId';
    public final static String PUTUNCANCELORDERBYORDERID = 'PutUncancelOrderByOrderId';
    public final static String GETTERMSBYORDERID = 'GetTermsByOrderId';

    public IADContractBeans.IADOrderPromoCode thePromoCode{get;set;}
    public transient IADContractBeans.IADOrderBeanWrapper theOrder{get;set;}
    public IADContractBeans.IADOrderBalance theOrderBalance{get;set;}
    public IADContractBeans.IADOrderHistoryBean theOrderHistory{get;set;}
   
    public Set<String> orderItemProductTypes = new Set<String>{'AddOn',  'Cross-sell', 'Filing Fee', 'Shipping'};
    public List<OrderItemWrapper> finalOrderItemWrappers{get;set;}

    public IADContractBeans.IADActionItemBean availableActionItems{get;set;} 
    public List<IADContractBeans.IADActionItem> currentActionItems{get;set;} 

    public String mainOrderItemId{get;set;} 
    /*Either Package(ProductComponent Id 2) or Renewal(Product Component Id 12)*/
    public Set<String> currentActionTypeIds{get;set;}
     //0=>Add,1=>,2=>Cancel,3=>Change
    public Boolean addOnAdded{get;set;}
    public List<OrderItemWrapper> modifiedOrderItemWrappers{get;set;}

    public Map<String,IADContractBeans.IADActionItem> productConfigurationIdToActionItem;
    public String currentAPIEndPoint{get;set;}
    Map<String,String> orderItemIdToProductConfigurationId;
    public String customerId{get;set;}
    public String orderNumber{get;set;}
    public String processingNumber{get;set;}
    public String baseProductName{get;set;}
    public String grossTotal{get;set;}
    public String orderDateTimeCreated{get;set;}
    public Boolean refreshOrder{get;set;}
    public IADContractBeans.IADMiscItem miscItem{get;set;}
    public Boolean cancelUnCancelResponse{get;set;}
    public Boolean isNewOrderAdded{get;set;}
    public String newOrderId{get;set;}
    public Boolean isThreePay{get;set;}
    public Decimal orderDiscount{get;set;}
    public String termAcceptedDate{get;set;}
    public Decimal promoCodeAmount{get;set;}
    public Boolean is3PayConverted{get;set;}
    public Set<String> crossSellProductConfigIds{get;set;}
    public String baseProcessingStatus{get;set;}
    public String customerLogin{get;set;}
    public Map<String,String> orderItemIdToProductName{get;set;}
    public Boolean isCrossSell{get;set;}
    public String entityName{get;set;}

    public IADOrderWithOrderItemsService()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETORDERBYORDERID);
        endpoints.add(GETORDERBALANCESBYORDERID);
        endpoints.add(GETORDERPROMOCODESBYORDERID);
        endpoints.add(GETACTIONITEMSBYORDERITEMID);
        endpoints.add(POSTADDONSBYORDERID);
        endpoints.add(POSTCROSSSELLSBYORDERID);
        endpoints.add(POSTSHIPPINGBYORDERID);
        endpoints.add(POSTFILINGFEESBYORDERID);
        endpoints.add(DELETEORDERITEMBYORDERITEMDID);
        endpoints.add(POSTPACKAGECHANGEBYORDERID);
        endpoints.add(GETORDERHISTORYBYORDERID);
        endpoints.add(PUTORDERTO3PAYBYORDERID);
        endpoints.add(POSTMISCITEMBYORDERID);
        endpoints.add(POSTRENEWALBYORDERITEMID);
        endpoints.add(DELETEORDERBYORDERID); 
        endpoints.add(PUTORDERBYORDERID);
        endpoints.add(PUTSHIPPINGBYORDERITEMID);
        endpoints.add(PUTUNCANCELORDERBYORDERID);
        endpoints.add(GETTERMSBYORDERID);     

        initEndpoints(endpoints);
        finalOrderItemWrappers = new List<OrderItemWrapper>();
        availableActionItems = new IADContractBeans.IADActionItemBean();
       
        currentActionTypeIds = new Set<String>();
        addOnAdded = false;
        productConfigurationIdToActionItem = new Map<String,IADContractbeans.IADActionItem>();
        modifiedOrderItemWrappers = new List<OrderItemWrapper>();
        orderItemIdToProductConfigurationId = new Map<String,String>();
        refreshOrder = false;
        miscItem = new IADContractbeans.IADMiscItem();
        isNewOrderAdded = false;
        orderDiscount = 0;
        promoCodeAmount = 0;
        is3PayConverted = false;
        crossSellProductConfigIds = new Set<String>();
        orderItemIdToProductName = new Map<String,String>();
    }
 
    public Object getOrderByOrderId(Object continuationObject, String orderId)
    {
        if(orderId != '' && orderId != null)
        {
            List<Order__c> orders = [SELECT Id , Customer_Login__r.Name , Entity_Name__c FROM Order__c WHERE OrderID__c = :orderId];
            if(!orders.isEmpty())
            {
                customerLogin = orders[0].Customer_Login__r.Name;
                if(orders[0].Entity_Name__c != null && orders[0].Entity_Name__c != 'none')
                {
                    entityName = orders[0].Entity_Name__c;
                }
            }
        }
        
        String calloutURL = APItoWrapper.get(GETORDERBYORDERID).endPointConfig.link__c + OrderID+'?showOrderItemTree=true';
        APItoWrapper.get(GETORDERBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        continuationObject = makeRequestMulti(continuationObject, calloutURL, GETORDERBYORDERID, '');
        if(!APItoWrapper.get(GETORDERBYORDERID).isAsync)
        {
            populateOrder();
        }
        return continuationObject;
    }


    
    public void populateOrder()
    {
        
        orderItemIdToProductConfigurationId.clear();
        try
        {
            initHTTPResponse(GETORDERBYORDERID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(GETORDERBYORDERID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                    IADContractBeans.IADOrderBeanWrapper deSerializedResponse  = (IADContractBeans.IADOrderBeanWrapper) JSON.deserialize(theResponse.responseData , IADContractBeans.IADOrderBeanWrapper.class);
                    customerId = deserializedResponse.Order.customerId;
                    isThreePay = deserializedResponse.Order.orderFlags.isThreePay;
                    for(IADContractBeans.IADOrderItem theItem : deSerializedResponse.Order.orderItems)
                    {
                        theItem.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theItem.dateCreated);//takes String
                    }
                    theResponse.resultObjects = new List<Object>{deSerializedResponse};
                    if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        
                        theOrder = (IADContractBeans.IADOrderBeanWrapper)APItoWrapper.get(GETORDERBYORDERID).resultObjects[0];
                        orderNumber = theOrder.Order.orderId;
                        orderDateTimeCreated = UtilityLibrary.getIADDateTime(theOrder.Order.dateCreated);//takes String
                        populateFinalOrderItemWrappers();
                        theOrder.Order.dateCreatedDatetime = UtilityLibrary.parseIADDatetime(theOrder.Order.dateCreated);
                    }
                }
                else
                {
                    populateNullErrorMessage(theResponse);
                }
            }
            else
            {
                populateErrorMessage(theResponse);
            }
           
        }
        
        catch(Exception theException)
        {
            throw new IADException('Failed Displaying Order '+theException.getMessage() , theException);
        }
    }
    

    

    public void populateFinalOrderItemWrappers()
    {
        finalOrderItemWrappers.clear();
        crossSellProductConfigIds.clear();
        Integer i = 0;
        for(IADContractbeans.IADOrderItem theOrderItemWrapper : theOrder.Order.orderItems)
        {
            orderItemIdToProductName.put(theOrderItemWrapper.orderItemId , theOrderItemWrapper.productName);
            if((theOrderItemWrapper.productConfiguration.productTypeId == '2' || theOrderItemWrapper.productConfiguration.productTypeId == '12' 
                || theOrderItemWrapper.productConfiguration.productTypeId == '13' || theOrderItemWrapper.productConfiguration.productTypeId == '10'
                || theOrderItemWrapper.productConfiguration.productTypeId == '9'))
            {
                if(!theOrderItemWrapper.isCancelled && !crossSellProductConfigIds.contains(theOrderItemWrapper.productConfiguration.productConfigurationId))
                {
                    mainOrderItemId = theOrderItemWrapper.orderItemId;
                    if(theOrderItemWrapper.processingOrder != null)
                    {
                       baseprocessingStatus = processingStatusIdToName.get(theOrderItemWrapper.processingOrder.processingStatusId); 
                    }
                     
                }
                if(!crossSellProductConfigIds.contains(theOrderItemWrapper.productConfiguration.productConfigurationId))
                {    
                    OrderItemWrapper theWrapper = new OrderItemWrapper(theOrderItemWrapper.productName , null ,
                                   theOrderItemWrapper.dateTimeCreatedInString , theOrderItemWrapper.orderItemId , theOrderItemWrapper.quantity , theOrderItemWrapper.extendedPrice , theOrderItemWrapper.isCancelled , i);
                    if(theOrderItemWrapper.processingOrder != null)
                    {
                        theWrapper.processingOrderId = theOrderItemWrapper.processingOrder.processingOrderId;
                        processingNumber = theWrapper.processingOrderId;
                        theWrapper.processingStatus = processingStatusIdToName.get(theOrderItemWrapper.processingOrder.processingStatusId); 
                    }
                    if(theOrderItemWrapper.productConfiguration != null)
                    {
                        theWrapper.productTypeId =  theOrderItemWrapper.productConfiguration.productTypeId; 
                        orderItemIdToProductConfigurationId.put(theOrderItemWrapper.orderItemId  , theOrderItemWrapper.productConfiguration.productConfigurationId);
                        theWrapper.productConfigurationId =  theOrderItemWrapper.productConfiguration.productConfigurationId;
                        if(!theOrderItemWrapper.isCancelled)
                        {
                            baseProductName = theWrapper.productName;
                            theWrapper.isMainOrderItem = true;
                        }
                    }
                    
                    
                    finalOrderItemWrappers.add(theWrapper);
                    populateChildItems(theOrderItemWrapper.childOrderItems , i);
               }
            }
        }

        
    }

    public void populateChildItems(List<IADContractbeans.IADOrderItem> theWrapper , Integer i)
    {
        ++i;
        for(IADContractbeans.IADOrderItem theOrderItemWrapper : theWrapper)
        {
            
            orderItemIdToProductName.put(theOrderItemWrapper.orderItemId , theOrderItemWrapper.productName);
            if(theOrderItemWrapper.productConfiguration.productTypeId != '4')
            {
                if(theOrderItemWrapper.productConfiguration.productTypeId == '9')
                    crossSellProductConfigIds.add(theOrderItemWrapper.productConfiguration.productConfigurationId);

                theOrderItemWrapper.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theOrderItemWrapper.dateCreated);//takes String
                OrderItemWrapper theWrapp = new OrderItemWrapper(theOrderItemWrapper.productName , null ,
                           theOrderItemWrapper.dateTimeCreatedInString , theOrderItemWrapper.orderItemId , theOrderItemWrapper.quantity , theOrderItemWrapper.extendedPrice , theOrderItemWrapper.isCancelled , i);
                if(theOrderItemWrapper.processingOrder != null)
                {
                    theWrapp.processingOrderId = theOrderItemWrapper.processingOrder.processingOrderId;
                    theWrapp.processingStatus = processingStatusIdToName.get(theOrderItemWrapper.processingOrder.processingStatusId); 
                }
                if(theOrderItemWrapper.productConfiguration != null)
                {
                    theWrapp.productTypeId =  theOrderItemWrapper.productConfiguration.productTypeId;
                    orderItemIdToProductConfigurationId.put(theOrderItemWrapper.orderItemId  , theOrderItemWrapper.productConfiguration.productConfigurationId); 
                    theWrapp.productConfigurationId =  theOrderItemWrapper.productConfiguration.productConfigurationId;
                }
                finalOrderItemWrappers.add(theWrapp);
                populateChildItems(theOrderItemWrapper.childOrderItems , i);
            }
            
        }
            
               
        
    }
    
    public Object getOrderBalanceByOrderId(Object continuationObject, String orderId)
    {
        String calloutURL = APItoWrapper.get(GETORDERBALANCESBYORDERID).endPointConfig.link__c + OrderID+'/balances';
        APItoWrapper.get(GETORDERBALANCESBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        continuationObject = makeRequestMulti(continuationObject, calloutURL, GETORDERBALANCESBYORDERID, '');
        if(!APItoWrapper.get(GETORDERBALANCESBYORDERID).isAsync)
        {
            populateOrderBalance();
        }

        return continuationObject;
    }
    

    public Object getOrderBalanceByOrderId(String orderid)
    {

        Object  continuationObject;
        String calloutURL = APItoWrapper.get(GETORDERBALANCESBYORDERID).endPointConfig.link__c + orderid+'/balances';
        calloutURL = calloutURL.replace('{orderid}', orderid);
        APItoWrapper.get(GETORDERBALANCESBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderid);
        continuationObject = makeRequest(calloutURL, GETORDERBALANCESBYORDERID, '');
        if(!APItoWrapper.get(GETORDERBALANCESBYORDERID).isAsync)
        {
            populateOrderBalance();
        }
        return continuationObject;
    }
    

    public void populateOrderBalance()
    {
        
        try
        {
            initHTTPResponse(GETORDERBALANCESBYORDERID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(GETORDERBALANCESBYORDERID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                    orderDiscount = 0;
                    promoCodeAmount = 0;
                    IADContractBeans.IADOrderBalance deSerializedResponse  = (IADContractBeans.IADOrderBalance) JSON.deserialize(theResponse.responseData , IADContractBeans.IADOrderBalance.class);
                    theResponse.resultObjects = new List<Object>{deSerializedResponse};
                    if(!theResponse.resultObjects.isEmpty())
                    {
                        theOrderBalance = ( IADContractBeans.IADOrderBalance)theResponse.resultObjects[0];
                        for(IADContractbeans.IADDiscountDetail theDiscountDetail : theOrderBalance.discountDetails)
                        {
                          if(theDiscountDetail.discountType != null)
                          {
                             if(theDiscountDetail.discountType.discountTypeId == 2 && !theDiscountDetail.isCancelled) //Custom Discount Type 
                             {
                                promoCodeAmount = theDiscountDetail.amount; 
                             }
                          }
                        }
                        orderDiscount = Decimal.valueOf(theOrderBalance.subTotalDiscount) - promoCodeAmount;  
                        theOrderBalance.grandTotal = theOrderBalance.orderBalanceAmount;
                    }
                }
                else
                {
                    populateNullErrorMessage(theResponse);
                }
            }
            else
            {
                populateErrorMessage(theResponse);
            }
            
        }
        catch(Exception theException)
        {
            throw new IADException('Failed Displaying Order Balance'+theException.getMessage() , theException);
        }
    }

    public Object getOrderHistoryByOrderId(String orderid)
    {
        
        Object  continuationObject;
        String calloutURL = APItoWrapper.get(GETORDERHISTORYBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderid}', orderid);
        APItoWrapper.get(GETORDERHISTORYBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderid);
        continuationObject = makeRequest(calloutURL, GETORDERHISTORYBYORDERID, '');
        if(!APItoWrapper.get(GETORDERHISTORYBYORDERID).isAsync)
        {
            populateOrderHistory();
        }
        return continuationObject;
    }
    
    public void populateOrderHistory()
    {
        
        try
        {
            initHTTPResponse(GETORDERHISTORYBYORDERID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(GETORDERHISTORYBYORDERID);
            if (theResponse.checkIsValidResponse())
            {
                if (theResponse.responseData != null)
                {
                    IADContractBeans.IADOrderHistoryBean  deserializedResponse = (IADContractBeans.IADOrderHistoryBean) JSON.deserialize(theResponse.responseData , IADContractBeans.IADOrderHistoryBean.class);
                    theResponse.resultObjects = new List<Object>{deserializedResponse };//one element list
                    
                    if(!theResponse.resultObjects.isEmpty())
                    theOrderHistory = (IADContractBeans.IADOrderHistoryBean)theResponse.resultObjects[0];
                    
                    
                    if(theOrderHistory != null && !theOrderHistory.orderItemsHistory.isEmpty())
                    {
                        for(IADContractbeans.IADOrderItemsHistoryBean theOrderHistory : theOrderHistory.orderItemsHistory)
                        {
                            for(IADContractBeans.IADOrderItemsHistory loopObj : theOrderHistory.history)
                            {
                                
                                if(loopObj.createdDate != null)
                                {
                                    loopObj.adjCreatedDateString = UtilityLibrary.getIADDateTime(loopObj.createdDate);
                                                                                            
                                }
                            }
                         }
                    }
                }
                else
                {
                    populateNullErrorMessage(theResponse);
                }
            }
            else
            {
                populateErrorMessage(theResponse);
            }
            
        }
        catch (Exception theException)
        {
            throw new IADException('Failed Displaying Order History ' + theException.getMessage(), theException);
        }
    }


    public Object convertOrderTo3Pay(String orderId)
    {
        String calloutURL = APItoWrapper.get(PUTORDERTO3PAYBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        String jsonString = '{"customerId":'+customerId+',"updatedBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
        APItoWrapper.get(PUTORDERTO3PAYBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        Object continuationObject = makeRequest(calloutURL, PUTORDERTO3PAYBYORDERID, jsonString);
        if(!APItoWrapper.get(PUTORDERTO3PAYBYORDERID).isAsync)
        {
            processConvert3PayResponse();
        }

        return continuationObject;

    }

    public void processConvert3PayResponse()
    {
        refreshOrder = false;
        try
        {
            initHTTPResponse(PUTORDERTO3PAYBYORDERID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(PUTORDERTO3PAYBYORDERID);
                
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                   
                    IADContractBeans.IADOrderBeanWrapper deSerializedResponse  = (IADContractBeans.IADOrderBeanWrapper) JSON.deserialize(theResponse.responseData , IADContractBeans.IADOrderBeanWrapper.class);
                    customerId = deserializedResponse.Order.customerId;
                    
                    theResponse.resultObjects = new List<Object>{deSerializedResponse};
                    if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        
                        theOrder = (IADContractBeans.IADOrderBeanWrapper)APItoWrapper.get(PUTORDERTO3PAYBYORDERID).resultObjects[0];
                        OrderItemWrapper theWrapp = new OrderItemWrapper(theOrder.Order.orderItems[0].productConfiguration.productComponent.displayNameOnBill , null ,
                                       null , null , null, null ,null, null);
                        if(theResponse.requestType == 'PUT')
                        {
                            theWrapp.modificationType = '3 Pay Conversion';    
                            theWrapp.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theOrder.Order.orderItems[0].dateCreated);
                            populateSuccessMessage('Order Successfully Converted to 3 Pay');
                            refreshOrder = true;
                            is3PayConverted = true;
                        }
                        modifiedOrderItemWrappers.add(theWrapp);

                    }
                
                }
                else
                {
                    populateNullErrorMessage(theResponse);
                }
            }
            else
            {
                populateErrorMessage(theResponse);
            }
            
        }
        catch(Exception theException)
        {
            throw new IADException('Failed Converting to 3 Pay'+theException.getMessage() , theException);
        }
    }
      
      


    public Object cancelOrderItem(String productConfigurationId , String orderId)
    {
        currentAPIEndPoint = '';
        refreshOrder = false;
        IADContractBeans.IADActionItem theActionItem = productConfigurationIdToActionItem.get(productConfigurationId);
        Object  continuationObject;
        try
        {
           
            String calloutURL;
            currentAPIEndPoint = DELETEORDERITEMBYORDERITEMDID;
            initWrapper(DELETEORDERITEMBYORDERITEMDID, 'processOrderItemResponse');
            calloutURL = APItoWrapper.get(DELETEORDERITEMBYORDERITEMDID).endPointConfig.link__c;
            calloutURL = calloutURL.replace('{orderId}',orderId);
            calloutURL = calloutURL.replace('{orderItemId}',theActionItem.orderItemId);
   
            if(calloutURL != null && calloutURL != '')
            {
                APItoWrapper.get(DELETEORDERITEMBYORDERITEMDID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
                APItoWrapper.get(DELETEORDERITEMBYORDERITEMDID).setInfo(APIRequestResponseWrapper.ORDERITEM, theActionItem.orderItemId);
                continuationObject = makeRequest(calloutURL, currentAPIEndPoint, '');
                if(!APItoWrapper.get(currentAPIEndPoint).isAsync)
                {
                    processOrderItemResponse();
                }
            }
           
      
        }
        catch(Exception theException)
        {
            populateErrorMessage('Failed Cancelling Order Items '+theException.getMessage());
           
        }
        return continuationObject;
    }

    public Object changeOrderItem(String productConfigurationId , String orderId ,  String orderItemId)
    {
        currentAPIEndPoint = '';
        refreshOrder = false;
        IADContractBeans.IADActionItem theActionItem = productConfigurationIdToActionItem.get(productConfigurationId);
        try
        {
            Object  continuationObject;
            if(theActionItem.productTypeId == '2')//Only for Package
            {
                String calloutURL;
                currentAPIEndPoint = POSTPACKAGECHANGEBYORDERID;
                initWrapper(currentAPIEndPoint, 'processOrderChangeResponse');
                calloutURL = APItoWrapper.get(currentAPIEndPoint).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderId}',orderId);
               
                 
                if(calloutURL != null && calloutURL != '')
                {
                    String jsonString = '{"oldProductConfigurationId":'+orderItemIdToProductConfigurationId.get(theActionItem.orderItemId)+',"newProductConfigurationId":'+theActionItem.productConfigurationId+',"createdBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
                    APItoWrapper.get(POSTPACKAGECHANGEBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
                    APItoWrapper.get(POSTPACKAGECHANGEBYORDERID).setInfo(APIRequestResponseWrapper.ORDERITEM, orderItemId);
                    continuationObject = makeRequest(calloutURL, currentAPIEndPoint, jsonString);
                    if(!APItoWrapper.get(currentAPIEndPoint).isAsync)
                    {
                        processOrderResponse();
                    }
                }
            }
            else if(theActionItem.productTypeId == '7')//Shipping
            {
                String calloutURL;
                currentAPIEndPoint = PUTSHIPPINGBYORDERITEMID;
                initWrapper(currentAPIEndPoint, 'processOrderItemResponse');
                calloutURL = APItoWrapper.get(currentAPIEndPoint).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderItemId}',orderItemId);
               
                 
                if(calloutURL != null && calloutURL != '')
                {
                    String jsonString = '{"productConfigurationId":'+theActionItem.productConfigurationId+',"createdBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
                    APItoWrapper.get(PUTSHIPPINGBYORDERITEMID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
                    APItoWrapper.get(PUTSHIPPINGBYORDERITEMID).setInfo(APIRequestResponseWrapper.ORDERITEM, orderItemId);
                    continuationObject = makeRequest(calloutURL, currentAPIEndPoint, jsonString);
                    if(!APItoWrapper.get(currentAPIEndPoint).isAsync)
                    {
                        processOrderItemResponse();
                    }
                }
            }
            return continuationObject;
      
        }
        catch(Exception theException)
        {
            populateErrorMessage('Failed Changing Item '+theException.getMessage());
            return null;
        }
        
    }

    public Object addOrderItem(String productConfigurationId , String orderId , String orderItemId) 
    {
        isCrossSell = false;
        currentAPIEndPoint = '';
        refreshOrder = false;
        isNewOrderAdded = false;
        IADContractBeans.IADActionItem theActionItem = productConfigurationIdToActionItem.get(productConfigurationId);
        try
        {
            Object  continuationObject;
            String calloutURL;
          
            
            if(theActionItem.productTypeId == '3') //Add On
            {
                
                currentAPIEndPoint = POSTADDONSBYORDERID;
                initWrapper(POSTADDONSBYORDERID, 'processOrderItemResponse');
                calloutURL = APItoWrapper.get(POSTADDONSBYORDERID).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderId}',orderId);
            }
            else if(theActionItem.productTypeId == '9') //Cross Sell
            {
                initWrapper(POSTCROSSSELLSBYORDERID, 'processOrderItemResponse');
                currentAPIEndPoint = POSTCROSSSELLSBYORDERID;
                calloutURL = APItoWrapper.get(POSTCROSSSELLSBYORDERID).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderId}',orderId);
                isCrossSell = true;
            
            }
            else if(theActionItem.productTypeId == '7') //Shipping
            {
                initWrapper(POSTSHIPPINGBYORDERID, 'processOrderItemResponse');
                currentAPIEndPoint = POSTSHIPPINGBYORDERID;
                calloutURL = APItoWrapper.get(POSTSHIPPINGBYORDERID).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderId}',orderId);
            
            }
            else if(theActionItem.productTypeId == '8') //Filing Fees
            {
                initWrapper(POSTFILINGFEESBYORDERID, 'processOrderItemResponse');
                currentAPIEndPoint = POSTFILINGFEESBYORDERID;
                calloutURL = APItoWrapper.get(POSTFILINGFEESBYORDERID).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderId}',orderId);
            
            }
            else if(theActionItem.productTypeId == '12') //Renewal
            {
                initWrapper(POSTRENEWALBYORDERITEMID, 'processOrderChangeResponse');
                currentAPIEndPoint = POSTRENEWALBYORDERITEMID;
                calloutURL = APItoWrapper.get(POSTRENEWALBYORDERITEMID).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderItemId}',orderItemId);
                
            }
         
            System.debug('CALL Out URL '+calloutURL);
            if(calloutURL != null && calloutURL != '')
            {
                String jsonString;
                if(theActionItem.actionItemsType == '0') //Add
                {
                    jsonString = '{"productConfigurationId":'+theActionItem.productConfigurationId+',"createdBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
                    APItoWrapper.get(currentAPIEndPoint).setInfo(APIRequestResponseWrapper.ORDER, orderId);
                    APItoWrapper.get(currentAPIEndPoint).setInfo(APIRequestResponseWrapper.ORDERITEM, orderItemId);
                    continuationObject = makeRequest(calloutURL, currentAPIEndPoint, jsonString);
                }
                if(!APItoWrapper.get(currentAPIEndPoint).isAsync)
                {
                    processOrderResponse();
                }
            }
            return continuationObject;
      
        }
        catch(Exception theException)
        {
            populateErrorMessage('Failed Adding Item '+theException.getMessage());
            return null;
        }
        
       
    }

    public void processOrderItemResponse()
    {
        try
        {
            initHTTPResponse(currentAPIEndPoint); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(currentAPIEndPoint);
            newOrderId = null;    
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                    addOnAdded = true;
                    IADContractBeans.IADOrderItemResponse  deserializedResponse = (IADContractBeans.IADOrderItemResponse) JSON.deserialize(theResponse.responseData , IADContractBeans.IADOrderItemResponse.class);
                    theResponse.resultObjects = new List<Object>{deserializedResponse };//one element list
                    
                    if(deserializedResponse != null)
                    {
                        if(deserializedResponse.orderItem != null)
                        {
                            IADContractbeans.IADOrderItem theItem = deSerializedResponse.orderItem;
                            theItem.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theItem.dateCreated);//takes String
                            OrderItemWrapper theWrapp = new OrderItemWrapper(theItem.productName , null ,
                                       theItem.dateTimeCreatedInString , theItem.orderItemId , theItem.quantity , theItem.extendedPrice , theItem.isCancelled , 0);
                            if(theItem.processingOrder != null)
                            {
                                theWrapp.processingOrderId = theItem.processingOrder.processingOrderId;
                            }
                            if(theItem.productConfiguration != null)
                            {
                                theWrapp.productTypeId =  theItem.productConfiguration.productTypeId; 
                            }
                            if(theResponse.requestType == 'POST')
                            {
                                theWrapp.modificationType = 'Added';
                                theWrapp.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theItem.dateCreated);
                                populateSuccessMessage('Item Added Successfully!!');
                                if(orderNumber != deserializedResponse.orderId)
                                {
                                    isNewOrderAdded = true;
                                    newOrderId = deserializedResponse.orderId; 
                                }
                            }
                            else if(theResponse.requestType == 'DELETE')
                            {
                                theWrapp.modificationType = 'Cancelled';
                                populateSuccessMessage('Item Cancelled Successfully!!');
                            }
                            else if(theResponse.requestType == 'PUT')
                            {
                                theWrapp.modificationType = 'Changed';    
                                populateSuccessMessage('Item Changed Successfully!!');
                            }
                            modifiedOrderItemWrappers.add(theWrapp);
                           
                            refreshOrder = true;
                           
                        }
                    }
           
                }
                else
                {
                    populateNullErrorMessage(theResponse);
                }
            }
            else
            {
                populateErrorMessage(theResponse);
            }
            
        }
        catch(Exception theException)
        {
            throw new IADException('Failed Adding Addons'+theException.getStackTraceString() , theException);
        }
    }

    public void processOrderResponse()
    {
        try
        {
            initHTTPResponse(currentAPIEndPoint); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(currentAPIEndPoint);
             
            newOrderId = null;  
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                                  
                        IADContractBeans.IADOrderBeanWrapper deSerializedResponse  = (IADContractBeans.IADOrderBeanWrapper) JSON.deserialize(theResponse.responseData , IADContractBeans.IADOrderBeanWrapper.class);
                        for(IADContractBeans.IADOrderItem theItem : deSerializedResponse.Order.orderItems)
                        {
                            theItem.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theItem.dateCreated);//takes String
                        }
                        theResponse.resultObjects = new List<Object>{deSerializedResponse};
                        if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                        {
                            
                            IADContractBeans.IADOrderBeanWrapper responseOrder = (IADContractBeans.IADOrderBeanWrapper)APItoWrapper.get(currentAPIEndPoint).resultObjects[0];
                            for(IADContractbeans.IADOrderItem theOrderItemWrapper : responseOrder.Order.orderItems)
                            {
              
                                if((theOrderItemWrapper.productConfiguration.productTypeId == '2' || theOrderItemWrapper.productConfiguration.productTypeId == '12' 
                                    || theOrderItemWrapper.productConfiguration.productTypeId == '13' || theOrderItemWrapper.productConfiguration.productTypeId == '10'
                                    ) && !theOrderItemWrapper.isCancelled)
                                {
                                                                       
                                   
                                    theOrderItemWrapper.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theOrderItemWrapper.dateCreated);//takes String
                                    OrderItemWrapper theWrapp = new OrderItemWrapper(theOrderItemWrapper.productName , null ,
                                               theOrderItemWrapper.dateTimeCreatedInString , theOrderItemWrapper.orderItemId , theOrderItemWrapper.quantity , theOrderItemWrapper.extendedPrice , theOrderItemWrapper.isCancelled , 0);
                                      
                                    if(theResponse.requestType == 'POST')
                                    {
                                        if(currentAPIEndPoint == POSTPACKAGECHANGEBYORDERID)
                                        {
                                            
                                            mainOrderItemId = theOrderItemWrapper.orderItemId;
                                            if(theOrderItemWrapper.processingOrder != null)
                                            {
                                               baseprocessingStatus = processingStatusIdToName.get(theOrderItemWrapper.processingOrder.processingStatusId); 
                                            }
                                            orderNumber = responseOrder.Order.orderId;
                                            orderDateTimeCreated = UtilityLibrary.getIADDateTime(responseOrder.Order.dateCreated);//takes String
                                            populateSuccessMessage('Package Successfully Changed');
                                            theWrapp.modificationType = 'Changed Package';
                                        }
                                        else if(currentAPIEndPoint == POSTRENEWALBYORDERITEMID)
                                        {
                                            populateSuccessMessage('Renewal Added');
                                            theWrapp.modificationType = 'Renewal Added';
                                            isNewOrderAdded = true;
                                            newOrderId = responseOrder.Order.orderId;
                                            System.debug('Inside response method');   
                                        }
                                    }
                                    else if(theResponse.requestType == 'DELETE')
                                        theWrapp.modificationType = 'Cancelled';
                                    
                                    modifiedOrderItemWrappers.add(theWrapp);
                                    refreshOrder = true;
                                    break;
                                }
                            
                           
                            }


                           
                     
                        }

                }
                else
                {
                    populateNullErrorMessage(theResponse);
                }
            }
            else
            {
                populateErrorMessage(theResponse);
            }
            
        }
        catch(Exception theException)
        {
            throw new IADException('Failed Processing Order Response'+theException.getStackTraceString() , theException);
        }
    }
      


    public Object getActionItemsByOrderItemId(String orderItemId , Set<String> actionTypeIds)
    {
        Object  continuationObject;
        currentActionTypeIds = actionTypeIds;
        String calloutURL = APItoWrapper.get(GETACTIONITEMSBYORDERITEMID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderItemId}', orderItemId);
        APItoWrapper.get(GETACTIONITEMSBYORDERITEMID).setInfo(APIRequestResponseWrapper.ORDERITEM, orderItemId);
        continuationObject = makeRequest(calloutURL, GETACTIONITEMSBYORDERITEMID, '');
        if(!APItoWrapper.get(GETACTIONITEMSBYORDERITEMID).isAsync)
        {
            populateActionItems();
        }
        return continuationObject;
    }
    
    public void populateActionItems()
    {
        refreshOrder = false;
        try
        {
            initHTTPResponse(GETACTIONITEMSBYORDERITEMID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(GETACTIONITEMSBYORDERITEMID);
            
            if(theResponse.checkIsValidResponse())
            {
                
                if(theResponse.responseData != null)
                {
                    availableActionItems = new IADContractbeans.IADActionItemBean();
                    currentActionItems = new List<IADContractBeans.IADActionItem>();
                    system.debug('theResponse.responseData ' + theResponse.responseData);
                    IADContractBeans.IADActionItemBean deSerializedResponse  = (IADContractBeans.IADActionItemBean) JSON.deserialize(theResponse.responseData , IADContractBeans.IADActionItemBean.class);
                    availableActionItems =  deSerializedResponse;
                    for(IADContractBeans.IADActionItem theActionItem : availableActionItems.actionItems)
                    {
                        theActionItem.productTypeName = productComponentIdToName.get(theActionItem.productTypeId);
                        productConfigurationIdToActionItem.put(theActionItem.productConfigurationId , theActionItem);
                        if(currentActionTypeIds.isEmpty())
                        {
                            currentActionItems.add(theActionItem);
                        }
                        else if(currentActionTypeIds.contains(theActionItem.actionItemsType))
                        {
                            currentActionItems.add(theActionItem);
                        }
                        
                    }
                    
                }
                else
                {
                    populateNullErrorMessage(theResponse);
                }
            }
            else
            {
                populateErrorMessage(theResponse);
            }
        }
        catch(Exception theException)
        {
            throw new IADException('Failed Displaying Action Items '+theException.getMessage() , theException);
        }
    }

    public Object createMiscItemByOrderId(String orderId)
    {
        Object  continuationObject;
        currentAPIEndPoint = POSTMISCITEMBYORDERID;
        initWrapper(POSTMISCITEMBYORDERID, 'processOrderItemResponse');
        String calloutURL = APItoWrapper.get(POSTMISCITEMBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        String jsonBody = '{"description":"'+miscItem.description+'","quantity":'+miscItem.quantity+',"pricePerUnit":'+miscItem.pricePerUnit+',"createdBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
        APItoWrapper.get(POSTMISCITEMBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        continuationObject = makeRequest(calloutURL, POSTMISCITEMBYORDERID, jsonBody);
        return continuationObject;
        
    }
 
    public Object callCancelUnCancelOrder(String Orderid, String Operation)
    {
        
        Object continuationObject;
        currentAPIEndPoint = '';
        if(Operation == 'Cancel')
        {
            currentAPIEndPoint = DELETEORDERBYORDERID;
            String url = (APItoWrapper.get(currentAPIEndPoint).endPointConfig.link__c);
            String calloutURL = url.replace('{orderId}',Orderid);
            APItoWrapper.get(DELETEORDERBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, Orderid);
            continuationObject = makeRequest(calloutURL, currentAPIEndPoint,'');
        }
        else if(Operation == 'Uncancel')
        {
            currentAPIEndPoint = PUTUNCANCELORDERBYORDERID;
            String url = (APItoWrapper.get(currentAPIEndPoint).endPointConfig.link__c);
            String calloutURL = url.replace('{orderId}',Orderid);
            String jsonBody = '{"updatedBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';

            system.debug(calloutURL);
            APItoWrapper.get(PUTUNCANCELORDERBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, Orderid);
            continuationObject = makeRequest(calloutURL, currentAPIEndPoint, jsonBody);
        }
        
        return continuationObject;
    }

    public void processCancelUncancelResponse()
    {
               
        cancelUnCancelResponse = false;
        try
        {
            initHTTPResponse(currentAPIEndPoint); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper orderResponse = APItoWrapper.get(currentAPIEndPoint);
            if (orderResponse.responseData != null)
            {
                if (orderResponse.checkIsValidResponse())
                {

                    if(currentAPIEndPoint == DELETEORDERBYORDERID)
                    {
                        iadMessages.add(IADMessageFactory.createMessage('success' , 'Order Cancelled Successfully'));
                    }
                    else if(currentAPIEndPoint == PUTUNCANCELORDERBYORDERID)
                    {
                        iadMessages.add(IADMessageFactory.createMessage('success' , 'Order UnCancelled Successfully'));   
                    }
                    cancelUnCancelResponse = true;
                }
                else
                {
                    populateErrorMessage('Invalid Response. Response Code : ' + orderResponse.statusCode + ' Message Body :  ' + orderResponse.errorMessage);
                   
                }
            }
            else
            {
                populateErrorMessage('Null Response. Response Code : ' + orderResponse.statusCode + ' Message Body :  ' + orderResponse.errorMessage);
              

            }
        }
        catch (Exception theException)
        {
            throw new IADException('Unable to canel order at this time. ' + theException.getMessage(), theException);
        }
    }

    public static Map<String,String> productComponentIdToName
    {
        get
        {
            if(productComponentIdToName == null)
            {

                productComponentIdToName = new Map<String,String>();
                for(Relationship_Type__c theType : [SELECT Id , Name , Relationship_Type_ID__c FROM Relationship_Type__c])
                {
                    productComponentIdToName.put(theType.Relationship_Type_ID__c , theType.Name);
                }

            }
            return productComponentIdToName;
        }
        set;
    } 
    
    public Map<String,String> processingStatusIdToName
    {
        get
        {
            
            if(processingStatusIdToName == null)
            {
                processingStatusIdToName = new Map<String,String>();
                for(Processing_Status__c theStatus : [SELECT Name , LZ_Processing_Status_ID__c FROM Processing_Status__c])
                {
                    processingStatusIdToName.put(theStatus.LZ_Processing_Status_ID__c , theStatus.Name);
                }
            }
            
            return processingStatusIdToName;
        }
        set;
    }

    public class OrderItemWrapper
    {

        public String productName{get;set;}
        public String processingOrderId{get;set;}
        public String dateTimeCreatedInString{get;set;}
        public String orderItemId{get;set;}
        public String quantity{get;set;}
        public String extendedPrice{get;set;}
        public Boolean isCancelled{get;set;}
        public Integer indent{get;set;}
        public String productTypeId{get;set;}
        public String modificationType{get;set;}
        public String productConfigurationId{get;set;}
        public Boolean isMainOrderItem{get;set;}
        public String processingStatus{get;set;} 

        public OrderItemWrapper(String prodName , String pNumber , String dateTimeCreated , String oItemId , String qty , String ePrice , Boolean isCancel , Integer toIndent)
        {

            productName = prodName;
            processingOrderId = pNumber;
            dateTimeCreatedInString = dateTimeCreated;
            orderItemId = oItemId;
            quantity = qty;
            extendedPrice = ePrice;
            isCancelled = isCancel;
            indent = toIndent;
        } 
    }
   
}