public with sharing class IADOrderWithOrderItemsService_ltng  extends IADServiceBase_ltng
{
    public final static String GETORDERBYORDERID = 'GetOrderByOrderId';
    public final static String GETORDERBALANCESBYORDERID = 'GetOrderBalancesByOrderId';
    public final static String GETORDERHISTORYBYORDERID = 'GetOrderHistoryByOrderId';
    public final static String GETORDERTAGBYORDERID = 'GetOrderTagByOrderId';
    public final static String DELETEORDERTAGBYORDERID = 'DeleteOrderTagByOrderId';
    public final static String GETSHIPMENTSBYORDERID = 'GetShipmentsByOrderId';
    public final static String POSTORDERTAGBYORDERID = 'PostOrderTagByOrderId';
    public final static string GETENTITYBYPROCESSINGID='GetEntityByProcessingId';
    public final static String GETORDERPROMOCODESBYORDERID = 'GetOrderPromoCodesByOrderId';
    public final static String GETACTIONITEMSBYORDERITEMID = 'GetActionItemsByorderItemId';
    public final static String POSTADDONSBYORDERID = 'PostAddOnsByOrderId';
    public final static String POSTCROSSSELLSBYORDERID = 'PostCrossSellsByOrderId';
    public final static String POSTCROSSSELLSBYORDERIDV3 = 'PostCrossSellsByOrderIdV3';
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
    public final static String GETORDERITEMRULESTATUS = 'GetOrderItemRuleStatus';
    public final static String POSTDOCUMENTBYPROCESSINGORDERID = 'PostDocumentByProcessingOrderId';
    public final static String GETORDERCONTACTSBYORDERID = 'GetOrderContactsByOrderId';
    public final static String GETCONTACTSBYCONTACTTYPE = 'GetContactsByContactType';
    public final static String GETDOCUMENTSBYPROCESSINGORDERID = 'GetDocumentsByProcessingOrderId';
    public final static String SHAREDOCUMENTSBYPROCESSINGORDERID = 'ShareDocumentsByProcessingOrderId';
    public final static String GETSUBSCRIPTIONCHANGEOPTIONS = 'GetSubscriptionChangeOptions';
    public final static String POSTPRORATEDSUBSCRIPTIONTERM = 'PostProratedSubscriptionTerm';
    public final static String PUTSUBSCRIPTIONADJUSTMENT = 'PutSubscriptionAdjustment';
       public final static String PostProcessingStatus = 'PutProcessingStatus';
    
    public static Set<String> orderItemProductTypes = new Set<String>{'AddOn',  'Cross-sell', 'Filing Fee', 'Shipping'};
    
    @AuraEnabled public Static Map<String, IADContractBeans_ltng.IADActionItem> productConfigurationIdToActionItem {get;set;}
    @AuraEnabled public Static String currentAPIEndPoint {get;set;}
    @AuraEnabled public Static Map<String, String> orderItemIdToProductConfigurationId {get;set;}
    @AuraEnabled public static Map<String, List<OrderItemShipmentsWrapper>> finalOrderItemShipmentsMap {get;set;}
    
    @AuraEnabled public static IADContractBeans_ltng.IADOrderPromoCode thePromoCode{get;set;}
    @AuraEnabled public static transient IADContractBeans_ltng.IADOrderBeanWrapper theOrder{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADOrderBalance theOrderBalance{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADOrderHistoryBean theOrderHistory{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADOrderTagBean theOrderTag{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADOrderBean newOrderInfo{get;set;}
    
    @AuraEnabled public static List<OrderItemWrapper> finalOrderItemWrappers{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADActionItemBean availableActionItems{get;set;} 
    @AuraEnabled public static List<IADContractBeans_ltng.IADActionItem> currentActionItems{get;set;} 
    @AuraEnabled public static String mainOrderItemId{get;set;} 
    @AuraEnabled public static  IADContractBeans_ltng.IADEntity deserialzedEntity{get;set;}
    
    //@AuraEnabled public static IADContractBeans_ltng.IADCustomerContactBean iadCustomerContacts{get;set;}    
    
    //Either Package(ProductComponent Id 2) or Renewal(Product Component Id 12)
    @AuraEnabled public static Set<String> currentActionTypeIds{get;set;}
    
    @AuraEnabled public static List<IADMessage_ltng> iadServiceMessages{get;set;}
    
    //0=>Add,1=>,2=>Cancel,3=>Change
    @AuraEnabled public static Boolean addOnAdded{get;set;}
    
    @AuraEnabled public static Boolean isRA {get;set;}
    
    @AuraEnabled public static List<OrderItemWrapper> modifiedOrderItemWrappers{get;set;}    
    @AuraEnabled public static List<OrderItemHistoryWrapper> finalOrderItemHistoryWrapper{get;set;}    
    @AuraEnabled public static List<OrderItemShipmentsWrapper> finalOrderItemShipmentsWrapper{get;set;}
    
    @AuraEnabled public Static String customerId{get;set;}
    @AuraEnabled public Static String orderNumber{get;set;}
    @AuraEnabled public Static String processingNumber{get;set;}
    @AuraEnabled public Static String baseProductName{get;set;}
    @AuraEnabled public Static String grossTotal{get;set;}
    @AuraEnabled public Static String orderDateTimeCreated{get;set;}
    @AuraEnabled public Static Boolean refreshOrder{get;set;}
    @AuraEnabled public Static IADContractBeans_ltng.IADMiscItem miscItem{get;set;}
    @AuraEnabled public Static Boolean cancelUnCancelResponse{get;set;}
    @AuraEnabled public Static Boolean isNewOrderAdded{get;set;}
    @AuraEnabled public Static String newOrderId{get;set;}
    @AuraEnabled public Static Boolean isThreePay{get;set;}
    @AuraEnabled public Static Decimal orderDiscount{get;set;}
    @AuraEnabled public Static String termAcceptedDate{get;set;}
    @AuraEnabled public Static Decimal promoCodeAmount{get;set;}
    @AuraEnabled public Static Boolean is3PayConverted{get;set;}
    @AuraEnabled public Static Set<String> crossSellProductConfigIds{get;set;}
    @AuraEnabled public Static String baseProcessingStatus{get;set;}
    @AuraEnabled public Static String customerLogin{get;set;}
    @AuraEnabled public Static Map<String,String> orderItemIdToProductName{get;set;}
    @AuraEnabled public Static Boolean isCrossSell{get;set;}
    @AuraEnabled public Static String entityName{get;set;}
    @AuraEnabled public Static String customerName{get;set;}
    
    @AuraEnabled public static List<String> orderTagList{get;set;}
    @AuraEnabled public static Map<String, String> orderTagMap{get;set;}
    @AuraEnabled public static Map<String, Order_Item__c> processingOrderIdOrderItemMap{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADDocumentsBean documents{get;set;}
    @AuraEnabled public static List<IADContractBeans_ltng.DocumentList> docList{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADSubscriptionChangeOptionBean subChangeOptions{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.CalculateProratedAmountForSubscriptionBean proratedSubInfo{get;set;}
    
    @AuraEnabled public static Boolean documentsQueuedSuccessfully{get;set;}
    @AuraEnabled public static Boolean showCancelledItemsCheckbox{get;set;}
    
    public IADOrderWithOrderItemsService_ltng()
    {
        super();
        
        List<String> endpoints = new List<String>();
        endpoints.add(GETORDERBYORDERID);
        endpoints.add(GETORDERTAGBYORDERID);
        endpoints.add(DELETEORDERTAGBYORDERID);
        endpoints.add(POSTORDERTAGBYORDERID);
        endpoints.add(GETSHIPMENTSBYORDERID);
        endpoints.add(GETORDERBALANCESBYORDERID);
        endpoints.add(GETORDERPROMOCODESBYORDERID);
        endpoints.add(GETACTIONITEMSBYORDERITEMID);
        endpoints.add(POSTADDONSBYORDERID);
        endpoints.add(POSTCROSSSELLSBYORDERID);
        endpoints.add(POSTCROSSSELLSBYORDERIDV3);
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
        endpoints.add(GETORDERITEMRULESTATUS); 
        endpoints.add(GETENTITYBYPROCESSINGID);
        endpoints.add(POSTDOCUMENTBYPROCESSINGORDERID);
        endpoints.add(GETORDERCONTACTSBYORDERID);
        endpoints.add(GETCONTACTSBYCONTACTTYPE);
        endpoints.add(GETDOCUMENTSBYPROCESSINGORDERID);
        endpoints.add(SHAREDOCUMENTSBYPROCESSINGORDERID);
        endpoints.add(GETSUBSCRIPTIONCHANGEOPTIONS);
        endpoints.add(POSTPRORATEDSUBSCRIPTIONTERM);
        endpoints.add(PUTSUBSCRIPTIONADJUSTMENT);
        endpoints.add(PostProcessingStatus);
        initEndpoints(endpoints);
        
        orderDiscount = 0;
        promoCodeAmount = 0;
        isRA = false;
        addOnAdded = false;
        refreshOrder = false;
        isNewOrderAdded = false;
        is3PayConverted = false;
        cancelUnCancelResponse = false;
        documentsQueuedSuccessfully = false;
        showCancelledItemsCheckbox = false;
        
        orderTagMap = new Map<String, String>();
        iadServiceMessages = new List<IADMessage_ltng>();
        crossSellProductConfigIds = new Set<String>();
        orderItemIdToProductName = new Map<String,String>();
        currentActionTypeIds = new Set<String>();
        miscItem = new IADContractbeans_ltng.IADMiscItem();  
        currentActionItems = new List<IADContractBeans_ltng.IADActionItem>();                    
        modifiedOrderItemWrappers = new List<OrderItemWrapper>();
        orderItemIdToProductConfigurationId = new Map<String,String>();
        finalOrderItemShipmentsMap = new Map<String, List<OrderItemShipmentsWrapper>>();
        finalOrderItemWrappers = new List<OrderItemWrapper>();
        availableActionItems = new IADContractBeans_ltng.IADActionItemBean();
        finalOrderItemHistoryWrapper = new List<OrderItemHistoryWrapper>();
        finalOrderItemShipmentsWrapper = new List<OrderItemShipmentsWrapper>();
        productConfigurationIdToActionItem = new Map<String,IADContractbeans_ltng.IADActionItem>();
        //iadCustomerContacts = new IADContractBeans_ltng.IADCustomerContactBean();
        processingOrderIdOrderItemMap = new Map<String, Order_Item__c> ();
        subChangeOptions = new IADContractBeans_ltng.IADSubscriptionChangeOptionBean();
        proratedSubInfo  = new IADContractBeans_ltng.CalculateProratedAmountForSubscriptionBean();
        newOrderInfo = new IADContractBeans_ltng.IADOrderBean();
    }
    
    public static void getOrderByOrderId(String orderId)
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
            
            for(Order_Item__c oItem : [Select User_Order_ID__c, Product__r.Process__r.Process_Id__c, Product__r.Process__r.Name, Entity_Name__c, TradeMark_Copyright_Name__c From Order_Item__c WHERE Order__r.OrderID__c =: orderId and User_Order_ID__c != null])
            {
                processingOrderIdOrderItemMap.put(oItem.User_Order_ID__c, oItem);
            }
            system.debug('processingOrderIdOrderItemMap--->');
            system.debug(processingOrderIdOrderItemMap);
        }
        
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETORDERBYORDERID).endPointConfig.link__c + OrderID+'?showOrderItemTree=true';
        IADServiceBase_ltng.APItoWrapper.get(GETORDERBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETORDERBYORDERID, '');
        system.debug('get order by order Id:');
        system.debug('calloutURL: '+calloutURL);
        populateOrder();
        if(string.valueOf(finalOrderItemWrappers).containsIgnoreCase('Registered Agent Service')){
            system.debug('im inside the RA service');
            isRA=true;
        }
        populateProoferStatus();
    }
    
    public Static void populateOrder()
    {        
        orderItemIdToProductConfigurationId.clear(); 
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETORDERBYORDERID);
            system.debug('get order by order Id: theResponse: ');
            system.debug(theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                    IADContractBeans_ltng.IADOrderBeanWrapper deSerializedResponse  = (IADContractBeans_ltng.IADOrderBeanWrapper) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADOrderBeanWrapper.class);
                    system.debug('deSerializedResponse');
                    system.debug(deSerializedResponse);
                    customerId = deserializedResponse.Order.customerId;
                    isThreePay = deserializedResponse.Order.orderFlags.isThreePay;
                    for(IADContractBeans_ltng.IADOrderItem theItem : deSerializedResponse.Order.orderItems)
                    {
                        theItem.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theItem.dateCreated);//takes String
                    }
                    theResponse.resultObjects = new List<Object>{deSerializedResponse};
                        if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        theOrder = (IADContractBeans_ltng.IADOrderBeanWrapper)IADServiceBase_ltng.APItoWrapper.get(GETORDERBYORDERID).resultObjects[0];
                        orderNumber = theOrder.Order.orderId;
                        orderDateTimeCreated = UtilityLibrary.getIADDateTime(theOrder.Order.dateCreated);//takes String
                        populateFinalOrderItemWrappers();
                        theOrder.Order.dateCreatedDatetime = UtilityLibrary.parseIADDatetime(theOrder.Order.dateCreated);
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
            
        }
        
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed Displaying Order: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public Static void populateFinalOrderItemWrappers()
    {
        finalOrderItemWrappers.clear();
        crossSellProductConfigIds.clear();
        Integer i = 0;
        system.debug('theOrder.Order.orderItems');
        system.debug(theOrder.Order.orderItems);
        for(IADContractbeans_ltng.IADOrderItem theOrderItemWrapper : theOrder.Order.orderItems)
        {
            if(theOrderItemWrapper.isCancelled && showCancelledItemsCheckbox != true){
                showCancelledItemsCheckbox = true;
            }
            system.debug('theOrderItemWrapper.productConfiguration.productTypeId: '+theOrderItemWrapper.productConfiguration.productTypeId);
            system.debug('crossSellProductConfigIds: '+crossSellProductConfigIds);
            orderItemIdToProductName.put(theOrderItemWrapper.orderItemId , theOrderItemWrapper.productName);
            if((theOrderItemWrapper.productConfiguration.productTypeId == '2' || theOrderItemWrapper.productConfiguration.productTypeId == '12' 
                || theOrderItemWrapper.productConfiguration.productTypeId == '13' || theOrderItemWrapper.productConfiguration.productTypeId == '10'
                || theOrderItemWrapper.productConfiguration.productTypeId == '9' || (theOrder.Order.orderItems.size() == 1 && theOrderItemWrapper.productConfiguration.productTypeId == '3')))
            {
                system.debug('theOrderItemWrapper.isCancelled: '+theOrderItemWrapper.isCancelled);                
                system.debug('theOrderItemWrapper.productConfiguration.productConfigurationId: '+theOrderItemWrapper.productConfiguration.productConfigurationId);
                system.debug('crossSellProductConfigIds.contains(theOrderItemWrapper.productConfiguration.productConfigurationId): '+crossSellProductConfigIds.contains(theOrderItemWrapper.productConfiguration.productConfigurationId));
                if(!theOrderItemWrapper.isCancelled && !crossSellProductConfigIds.contains(theOrderItemWrapper.productConfiguration.productConfigurationId))
                {
                    mainOrderItemId = theOrderItemWrapper.orderItemId;
                    if(theOrderItemWrapper.processingOrder != null)
                    {
                        baseProcessingStatus = processingStatusIdToName.get(theOrderItemWrapper.processingOrder.processingStatusId); 
                    }
                }
                if(!crossSellProductConfigIds.contains(theOrderItemWrapper.productConfiguration.productConfigurationId))
                {    
                    OrderItemWrapper theWrapper = new OrderItemWrapper(theOrderItemWrapper.productConfiguration.productComponent.displayNameOnBill, theOrderItemWrapper.productName , 
                                                                       theOrderItemWrapper.dateTimeCreatedInString , theOrderItemWrapper.orderItemId , theOrderItemWrapper.quantity , theOrderItemWrapper.extendedPrice , theOrderItemWrapper.isCancelled , i);
                    if(theOrderItemWrapper.processingOrder != null)
                    {
                        theWrapper.processingOrderId = theOrderItemWrapper.processingOrder.processingOrderId;
                        processingNumber = theWrapper.processingOrderId;
                        theWrapper.processingStatus = processingStatusIdToName.get(theOrderItemWrapper.processingOrder.processingStatusId); 
                        
                        theWrapper.entityName = processingOrderIdOrderItemMap.get(theOrderItemWrapper.processingOrder.processingOrderId) != null ? processingOrderIdOrderItemMap.get(theOrderItemWrapper.processingOrder.processingOrderId).Entity_Name__c : '';
                        theWrapper.copyrightTradeMarkName = processingOrderIdOrderItemMap.get(theOrderItemWrapper.processingOrder.processingOrderId) != null ? processingOrderIdOrderItemMap.get(theOrderItemWrapper.processingOrder.processingOrderId).Trademark_Copyright_Name__c : '';
                        
                        theWrapper.processId = processingOrderIdOrderItemMap.get(processingNumber) != null ? Integer.valueOf(processingOrderIdOrderItemMap.get(processingNumber).Product__r.Process__r.Process_Id__c) : null;
                        theWrapper.processName = processingOrderIdOrderItemMap.get(processingNumber) != null ? processingOrderIdOrderItemMap.get(processingNumber).Product__r.Process__r.Name : '';
                    }
                    system.debug('theOrderItemWrapper.productConfiguration: '+theOrderItemWrapper.productConfiguration);
                    if(theOrderItemWrapper.productConfiguration != null)
                    {
                        theWrapper.productTypeId =  theOrderItemWrapper.productConfiguration.productTypeId; 
                        orderItemIdToProductConfigurationId.put(theOrderItemWrapper.orderItemId  , theOrderItemWrapper.productConfiguration.productConfigurationId);
                        theWrapper.productConfigurationId =  theOrderItemWrapper.productConfiguration.productConfigurationId;
                        system.debug('theOrderItemWrapper.isCancelled: '+theOrderItemWrapper.isCancelled);
                        if(!theOrderItemWrapper.isCancelled)
                        {
                            baseProductName = theWrapper.productName;
                            system.debug('base product name: '+baseProductName);
                            theWrapper.isMainOrderItem = true;
                            system.debug('theWrapper.isMainOrderItem: '+theWrapper.isMainOrderItem);
                        }
                    }
                    
                    finalOrderItemWrappers.add(theWrapper);
                    system.debug('theOrderItemWrapper.childOrderItems');
                    system.debug(theOrderItemWrapper.childOrderItems);
                    populateChildItems(theOrderItemWrapper.childOrderItems , i);
                }
            }
        }
    }
    
    public Static void populateChildItems(List<IADContractbeans_ltng.IADOrderItem> theWrapper , Integer i)
    {
        ++i;
        for(IADContractbeans_ltng.IADOrderItem theOrderItemWrapper : theWrapper)
        {
            if(theOrderItemWrapper.isCancelled && showCancelledItemsCheckbox != true){
                showCancelledItemsCheckbox = true;
            }
            orderItemIdToProductName.put(theOrderItemWrapper.orderItemId , theOrderItemWrapper.productName);
            
            if(theOrderItemWrapper.productConfiguration.productTypeId != '4')
            {
                if(theOrderItemWrapper.productConfiguration.productTypeId == '9')
                {
                    crossSellProductConfigIds.add(theOrderItemWrapper.productConfiguration.productConfigurationId);
                }
                theOrderItemWrapper.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theOrderItemWrapper.dateCreated);//takes String
                OrderItemWrapper theWrapp = new OrderItemWrapper(theOrderItemWrapper.productConfiguration.productComponent.displayNameOnBill,theOrderItemWrapper.productName , 
                                                                 theOrderItemWrapper.dateTimeCreatedInString , theOrderItemWrapper.orderItemId , theOrderItemWrapper.quantity , theOrderItemWrapper.extendedPrice , theOrderItemWrapper.isCancelled , i);
                if(theOrderItemWrapper.processingOrder != null)
                {
                    theWrapp.processingOrderId = theOrderItemWrapper.processingOrder.processingOrderId;
                    theWrapp.processingStatus = processingStatusIdToName.get(theOrderItemWrapper.processingOrder.processingStatusId); 
                    
                    theWrapp.processId = processingOrderIdOrderItemMap.get(processingNumber) != null ? Integer.valueOf(processingOrderIdOrderItemMap.get(processingNumber).Product__r.Process__r.Process_Id__c) : null;
                    theWrapp.processName = processingOrderIdOrderItemMap.get(processingNumber) != null ? processingOrderIdOrderItemMap.get(processingNumber).Product__r.Process__r.Name : '';
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
    
    public static void populateProoferStatus(){
        IADServiceBase_ltng.initWrapper(GETORDERITEMRULESTATUS);
        for(OrderItemWrapper odrItemWrpr : finalOrderItemWrappers){
            if(odrItemWrpr.processingOrderId != null)
            {
                system.debug('---->'+odrItemWrpr.processingOrderId);
                odrItemWrpr.prooferStatus = getOrderItemRuleStatusForOrder(odrItemWrpr.processingOrderId, '1');
                system.debug('---->'+odrItemWrpr.prooferStatus);
            }
        }
    }
    
    public static string getOrderItemRuleStatusForOrder(String processingNumber, String ruleType)
    {
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETORDERITEMRULESTATUS).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{processingOrderId}', processingNumber);
        calloutURL = calloutURL.replace('{ruleType}', ruleType);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETORDERITEMRULESTATUS, '');
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(GETORDERITEMRULESTATUS);
        system.debug('----->'+response.responseData);
        map<string,object> apiWrapper = (map<string,object>)JSON.deserializeUntyped(response.responseData);
        map<string,object> res = (map<string,object>)apiWrapper.get('overallOrderRuleStatus');
        string resultStat = string.valueOf(res.get('overallRuleStatus'));
        
        return resultStat;
    }
    
    public static void getShipmentsByOrderId(String orderId) 
    {   
        try
        {   
            String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETSHIPMENTSBYORDERID).endPointConfig.link__c + orderId;
            IADServiceBase_ltng.APItoWrapper.get(GETSHIPMENTSBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
            IADServiceBase_ltng.makeRequestMulti(calloutURL, GETSHIPMENTSBYORDERID, '');
            populateShipments();
        }
        catch(IADException theException)
        {
            system.debug('exception thrown in getShipmentsByOrderId');
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in getShipmentsByOrderId');
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public Static void populateShipments()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETSHIPMENTSBYORDERID);
            system.debug('shipments by orderId: '+theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null && theResponse.responseData != '' && theResponse.StatusCode != '204')
                {
                    IADContractBeans_ltng.IADShipmentBean deSerializedResponse  = (IADContractBeans_ltng.IADShipmentBean) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADShipmentBean.class);
                    system.debug('deSerializedResponse.. shipments: '+deSerializedResponse); 
                    theResponse.resultObjects = new List<Object>{deSerializedResponse};
                        if(!theResponse.resultObjects.isEmpty())
                    {
                        IADContractBeans_ltng.IADShipmentBean theShipmentWrapper = ( IADContractBeans_ltng.IADShipmentBean)theResponse.resultObjects[0];
                        for(IADContractbeans_ltng.IADShipments allShipments : theShipmentWrapper.shipments)
                        {
                            String placeholderImageURL = '/shipments/{0}/{2}/shipment_{1}.gif';
                            List<String> fillers = new List<String>();
                            if (allShipments.shippingMethod.shipMethodId <= '0')
                            {
                                //Do nothing
                            }
                            else if (allShipments.shippingMethod.shipMethodId > '8') // Fixed OM-121 (by Suchat 12/15/2014):No Icon for shipint Method Id > 8
                            {
                                //Do nothing
                            }
                            else
                            {
                                String trackingURL = '';
                                fillers.add(allShipments.shippingType.shippingTypeId);
                                fillers.add(allShipments.shippingMethod.shipMethodId);
                                if(!String.isEmpty(allShipments.receivedDate)){
                                    fillers.add('shipped');
                                }else if(String.isEmpty(allShipments.receivedDate)){
                                    fillers.add('not_shipped');
                                }
                                String imageURL = String.format(placeholderImageURL, fillers);
                                system.debug('image url: '+imageURL);
                                String shippedDate = allShipments.shippedDate.subString(0,10);
                                if(allShipments.shippingType.shippingTypeId == '1'){
                                    trackingURL = 'http://www.fedex.com/Tracking?action=track&language=english&tracknumbers={0}';
                                    trackingURL = String.format(trackingURL, new List<String>{allShipments.trackingCode});
                                }else if(allShipments.shippingType.shippingTypeId == '2'){
                                    trackingURL = 'http://trkcnfrm1.smi.usps.com/PTSInternetWeb/InterLabelInquiry.do?origTrackNum={0}';
                                    trackingURL = String.format(trackingURL, new List<String>{allShipments.trackingCode});
                                }else if(allShipments.shippingType.shippingTypeId == '4'){
                                    trackingURL = 'http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums={0}';
                                    trackingURL = String.format(trackingURL, new List<String>{allShipments.trackingCode});
                                }
                                OrderItemShipmentsWrapper oisw = new OrderItemShipmentsWrapper(allShipments.orderItemId, imageURL, shippedDate, allShipments.trackingCode, allShipments.vendorName, trackingURL);
                                finalOrderItemShipmentsWrapper.add(oisw);
                                if(finalOrderItemShipmentsMap.get(allShipments.orderItemId) != null){
                                    finalOrderItemShipmentsMap.get(allShipments.orderItemId).add(oisw);
                                }else{
                                    finalOrderItemShipmentsMap.put(allShipments.orderItemId, finalOrderItemShipmentsWrapper);
                                }
                            }                        
                        }    
                        system.debug('finalOrderItemShipmentsWrapper: '+finalOrderItemShipmentsWrapper); 
                        system.debug('finalOrderItemShipmentsMap: '+finalOrderItemShipmentsMap);
                    }
                }
                else if(theResponse.StatusCode == '204'){
                    system.debug('No shipments to retrieve!');
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            //throw new IADException('Failed Displaying Shipment information'+theException.getMessage() , theException);
            IADServiceBase_ltng.populateErrorMessage('Failed Displaying Shipment information: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public Static void getOrderBalanceByOrderId(String orderid)  // changed return type from objec to void
    {
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETORDERBALANCESBYORDERID).endPointConfig.link__c + orderid+'/balances';
        calloutURL = calloutURL.replace('{orderid}', orderid);
        system.debug('Order balance url: '+calloutURL);
        IADServiceBase_ltng.APItoWrapper.get(GETORDERBALANCESBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderid);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETORDERBALANCESBYORDERID, '');
        
        populateOrderBalance();
        system.debug('the order balance: '+theOrderBalance);
    }
    
    
    public Static void populateOrderBalance()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETORDERBALANCESBYORDERID);
            system.debug('Order balance response: '+theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                    orderDiscount = 0;
                    promoCodeAmount = 0;
                    IADContractBeans_ltng.IADOrderBalance deSerializedResponse  = (IADContractBeans_ltng.IADOrderBalance) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADOrderBalance.class);
                    system.debug('deSerializedResponse.. order balance: '+deSerializedResponse); 
                    theResponse.resultObjects = new List<Object>{deSerializedResponse};
                        if(!theResponse.resultObjects.isEmpty())
                    {
                        theOrderBalance = ( IADContractBeans_ltng.IADOrderBalance)theResponse.resultObjects[0];
                        for(IADContractbeans_ltng.IADDiscountDetail theDiscountDetail : theOrderBalance.discountDetails)
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
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
            
        }
        catch(Exception theException)
        {
            //throw new IADException('Failed Displaying Order Balance'+theException.getMessage() , theException);
            IADServiceBase_ltng.populateErrorMessage('Failed Displaying Order Balance: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void createOrderTagByOrderId(String orderId, String tagName)
    {   
        List<String> orderTagList = new List<String>();
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTORDERTAGBYORDERID).endPointConfig.link__c + orderId;
        String jsonString = '{"tagType":"unset","tag":"'+tagName+'"}';
        IADServiceBase_ltng.APItoWrapper.get(POSTORDERTAGBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTORDERTAGBYORDERID, jsonString);
        APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(POSTORDERTAGBYORDERID);
        system.debug('theResponse inside create Order Tag ----> '+theResponse.responseData);
        if(!theResponse.checkIsValidResponse())
        {
            IADServiceBase_ltng.populateNullErrorMessage(theResponse);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void deleteOrderTagByOrderId(String orderId, String tagName)
    {   
        List<String> orderTagList = new List<String>();
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(DELETEORDERTAGBYORDERID).endPointConfig.link__c + orderId;
        String jsonString = '{"tagType":"unset","tag":"'+tagName+'"}';
        IADServiceBase_ltng.APItoWrapper.get(DELETEORDERTAGBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, DELETEORDERTAGBYORDERID, jsonString);
        APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(DELETEORDERTAGBYORDERID);
        system.debug('theResponse inside delete Order Tag ----> '+theResponse.responseData);
        if(!theResponse.checkIsValidResponse())
        {
            IADServiceBase_ltng.populateNullErrorMessage(theResponse);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static List<String> getOrderTagByOrderId(String orderId)
    {   
        orderTagList = new List<String>();
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETORDERTAGBYORDERID).endPointConfig.link__c + orderId +'?tagType=unset';
        IADServiceBase_ltng.APItoWrapper.get(GETORDERTAGBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETORDERTAGBYORDERID, '');
        orderTagList = populateOrderTag();
        system.debug('getOrderbyOrderTag: '+orderTagList);
        return orderTagList;
    }
    
    public Static List<String> populateOrderTag()
    {
        try
        {
            List<String> orderTagList = new List<String>();
            orderTagMap = new Map<String, String>();
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETORDERTAGBYORDERID);
            system.debug('Order tags: '+theResponse);
            system.debug('theResponse.checkIsValidResponse(): '+theResponse.checkIsValidResponse());
            system.debug('theResponse.responseData: '+theResponse.responseData);
            if(theResponse.checkIsValidResponse())
            {
                if(String.isNotBlank(theResponse.responseData) && theResponse.responseData != null && theResponse.StatusCode != '204')
                {
                    IADContractBeans_ltng.IADOrderTagBean deSerializedResponse  = (IADContractBeans_ltng.IADOrderTagBean) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADOrderTagBean.class);
                    system.debug('deSerializedResponse.. order tag: '+deSerializedResponse); 
                    theResponse.resultObjects = new List<Object>{deSerializedResponse};
                        if(!theResponse.resultObjects.isEmpty())
                    {
                        theOrderTag = ( IADContractBeans_ltng.IADOrderTagBean)theResponse.resultObjects[0];
                        for(IADContractbeans_ltng.IADOrderTags orderTags : theOrderTag.orderTags){
                            orderTagList.add(orderTags.tag);
                            orderTagMap.put(orderTags.tag, orderTags.tagType);
                        }
                    }
                }
                else if(theResponse.StatusCode == '204')
                {
                    System.debug('There are no tags to retrieve!');
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else{
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
            return orderTagList;
        }
        catch(Exception theException)
        {
            //throw new IADException('Failed Displaying Order Tags'+theException.getMessage() , theException);
            IADServiceBase_ltng.populateErrorMessage('Failed Displaying Order Tags: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
            return null;
        }
    }
    
    
    public static void getOrderHistoryByOrderId(String orderid, Map<String, String> oipnMap)
    {
        system.debug('Im inside Order History ');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETORDERHISTORYBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderid}', orderid);
        IADServiceBase_ltng.APItoWrapper.get(GETORDERHISTORYBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderid);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETORDERHISTORYBYORDERID, '');
        orderItemIdToProductName = oipnMap;
        populateOrderHistory();
        system.debug('Order History Wrapper: '+finalOrderItemHistoryWrapper);
        system.debug('orderItemIdToProductName: '+orderItemIdToProductName);
    }
    
    public static void populateOrderHistory()
    {
        try
        {
            finalOrderItemHistoryWrapper = new List<OrderItemHistoryWrapper>();
            List<IADContractBeans_ltng.IADOrderItemsHistoryWithUIComponents> oihList = new List<IADContractBeans_ltng.IADOrderItemsHistoryWithUIComponents>();
            IADContractBeans_ltng.IADOrderItemsHistoryWithUIComponents oih = new IADContractBeans_ltng.IADOrderItemsHistoryWithUIComponents();
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETORDERHISTORYBYORDERID);
            system.debug('Order history response: '+theResponse);
            if (theResponse.checkIsValidResponse())
            {
                if (theResponse.responseData != null)
                {
                    IADContractBeans_ltng.IADOrderHistoryBean  deserializedResponse = (IADContractBeans_ltng.IADOrderHistoryBean) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADOrderHistoryBean.class);
                    theResponse.resultObjects = new List<Object>{deserializedResponse };//one element list
                        
                        if(!theResponse.resultObjects.isEmpty())
                    {     
                        theOrderHistory = (IADContractBeans_ltng.IADOrderHistoryBean)theResponse.resultObjects[0];
                    }
                    if(theOrderHistory != null && !theOrderHistory.orderItemsHistory.isEmpty())
                    {
                        Integer parentRowNumber = 1;
                        for(IADContractBeans_ltng.IADOrderItemsHistoryBean theOrderHistory : theOrderHistory.orderItemsHistory)
                        {
                            Integer rowNumber = 1;
                            oihList = new List<IADContractBeans_ltng.IADOrderItemsHistoryWithUIComponents>();
                            String productName = orderItemIdToProductName.get(theOrderHistory.orderItemId) <> null ? orderItemIdToProductName.get(theOrderHistory.orderItemId) : '';
                            system.debug('productName------->'+productName);
                            for(IADContractBeans_ltng.IADOrderItemsHistory loopObj : theOrderHistory.history)
                            {   
                                oih = new IADContractBeans_ltng.IADOrderItemsHistoryWithUIComponents();
                                
                                oih.updatedBy = loopObj.updatedBy;
                                oih.description = loopObj.description;
                                oih.status = loopObj.status;
                                oih.additionalInfo = loopObj.additionalInfo;
                                oih.createdDate = loopObj.createdDate;
                                oih.adjCreatedDate = loopObj.adjCreatedDate;
                                if(loopObj.createdDate != null)
                                {
                                    oih.adjCreatedDateString = UtilityLibrary.getIADDateTime(loopObj.createdDate);
                                }else
                                {
                                    oih.adjCreatedDateString = loopObj.adjCreatedDateString;
                                }
                                oih.rowNumber = rowNumber;
                                oihList.add(oih);
                                rowNumber++;
                            }
                            finalOrderItemHistoryWrapper.add(new OrderItemHistoryWrapper(orderNumber, productName, parentRowNumber, oihList));
                            parentRowNumber++;
                        }
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
            
        }
        catch (Exception theException)
        {
            //throw new IADException('Failed Displaying Order History ' + theException.getMessage(), theException);
            IADServiceBase_ltng.populateErrorMessage('Failed Displaying Order History: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }    
    
    public static void getDocumentsByProcessingOrderId(String processingOrderId)
    {   
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETDOCUMENTSBYPROCESSINGORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{processingOrderId}', processingOrderId);
        IADServiceBase_ltng.APItoWrapper.get(GETDOCUMENTSBYPROCESSINGORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, processingOrderId);        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETDOCUMENTSBYPROCESSINGORDERID, '');
        processDocumentsList();
    }
    
    public Static void processDocumentsList()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETDOCUMENTSBYPROCESSINGORDERID);
            system.debug('processDocumentsList: '+theResponse);
            system.debug('theResponse.checkIsValidResponse(): '+theResponse.checkIsValidResponse());
            system.debug('theResponse.responseData: '+theResponse.responseData);
            if(theResponse.checkIsValidResponse())
            {
                IADContractBeans_ltng.IADDocumentsBean  deserializedResponse = (IADContractBeans_ltng.IADDocumentsBean) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADDocumentsBean.class);
                theResponse.resultObjects = new List<Object>{deserializedResponse };//one element list
                    system.debug('deserializedResponse---->');
                system.debug(deserializedResponse);
                docList = new List<IADContractBeans_ltng.DocumentList>();
                IADContractBeans_ltng.DocumentList doc = new IADContractBeans_ltng.DocumentList();
                if(!theResponse.resultObjects.isEmpty())
                {     
                    Integer i = 1;
                    documents = (IADContractBeans_ltng.IADDocumentsBean)theResponse.resultObjects[0];
                    for(IADContractBeans_ltng.DocumentList loopDocs : documents.documentList)
                    {   
                        doc = new IADContractBeans_ltng.DocumentList();
                        doc.documentId = i;
                        doc.documentName = loopDocs.documentName;
                        doc.folderName = loopDocs.folderName;
                        doc.isFileNetDocument = loopDocs.isFileNetDocument;
                        doc.createdDate = loopDocs.createdDate;
                        docList.add(doc);
                        i++;
                    } 
                    system.debug('Documents list');
                    system.debug(docList);
                }
                else
                {
                    IADServiceBase_ltng.populateSuccessMessage('No documents to retrieve!');
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;                   
                }
            }
            else{
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed retrieving documents: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void shareDocumentByProcessingOrderId(String processingOrderId, String payload)
    {   
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(SHAREDOCUMENTSBYPROCESSINGORDERID).endPointConfig.link__c;
        system.debug('calloutURL--->'+calloutURL);
        IADServiceBase_ltng.APItoWrapper.get(SHAREDOCUMENTSBYPROCESSINGORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, processingOrderId);        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, SHAREDOCUMENTSBYPROCESSINGORDERID, payload);
        processDocDeliveryResponse(processingOrderId);
    }
    
    public Static void processDocDeliveryResponse(String processingOrderId)
    {
        try 
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(SHAREDOCUMENTSBYPROCESSINGORDERID);
            system.debug('processDocAutomationResponse: '+theResponse);
            system.debug('theResponse.checkIsValidResponse(): '+theResponse.checkIsValidResponse());
            system.debug('theResponse.responseData: '+theResponse.responseData);
            if(theResponse.checkIsValidResponse() && theResponse.StatusCode == '202')
            {
                documentsQueuedSuccessfully = true;
                //IADServiceBase_ltng.populateSuccessMessage('Documents has been queued for delivery!');
                //iadServiceMessages = IADServiceBase_ltng.iadMessages;    
                NextPadController_Ltng.submitRecord(processingOrderId, null, null, 'Documents Sent to Customer', 'note', '');            
            }
            else{
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed Re-Automating Order: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void postDocumentByProcessingOrderId(String processingOrderId)
    {   
        String payload = '{"processingOrderId":'+processingOrderId+',"source":' + 1 + '}';
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTDOCUMENTBYPROCESSINGORDERID).endPointConfig.link__c;
        IADServiceBase_ltng.APItoWrapper.get(POSTDOCUMENTBYPROCESSINGORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, processingOrderId);        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTDOCUMENTBYPROCESSINGORDERID, payload);
        processDocAutomationResponse();
    }
    
    public Static void processDocAutomationResponse()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(POSTDOCUMENTBYPROCESSINGORDERID);
            system.debug('processDocAutomationResponse: '+theResponse);
            system.debug('theResponse.checkIsValidResponse(): '+theResponse.checkIsValidResponse());
            system.debug('theResponse.responseData: '+theResponse.responseData);
            if(theResponse.checkIsValidResponse())
            {
                IADServiceBase_ltng.populateSuccessMessage('Order has been queued for Automation!');
                iadServiceMessages = IADServiceBase_ltng.iadMessages;                
            }
            else{
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed Re-Automating Order: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }    
    
    public static void convertOrderTo3Pay(String orderId, String customerId)
    {
        system.debug('Inside conver to 3pay service method');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(PUTORDERTO3PAYBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        String jsonString = '{"customerId":'+customerId+',"updatedBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
        IADServiceBase_ltng.APItoWrapper.get(PUTORDERTO3PAYBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, PUTORDERTO3PAYBYORDERID, jsonString);
        system.debug('ready to make callout');
        processConvert3PayResponse();
    }
    
    public static void processConvert3PayResponse()
    {
        refreshOrder = false;
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(PUTORDERTO3PAYBYORDERID);
            system.debug('callout response: '+theResponse);    
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                    
                    IADContractBeans_ltng.IADOrderBeanWrapper deSerializedResponse  = (IADContractBeans_ltng.IADOrderBeanWrapper) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADOrderBeanWrapper.class);
                    customerId = deserializedResponse.Order.customerId;
                    system.debug('3pay deSerializedResponse: '+deSerializedResponse);
                    theResponse.resultObjects = new List<Object>{deSerializedResponse};
                        if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        theOrder = (IADContractBeans_ltng.IADOrderBeanWrapper)IADServiceBase_ltng.APItoWrapper.get(PUTORDERTO3PAYBYORDERID).resultObjects[0];
                        OrderItemWrapper theWrapp = new OrderItemWrapper(theOrder.Order.orderItems[0].productConfiguration.productComponent.displayNameOnBill, theOrder.Order.orderItems[0].productConfiguration.productComponent.displayNameOnBill , 
                                                                         null , null , null, null ,null, null);
                        if(theResponse.requestType == 'PUT')
                        {
                            theWrapp.modificationType = '3 Pay Conversion';    
                            theWrapp.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theOrder.Order.orderItems[0].dateCreated);
                            IADServiceBase_ltng.populateSuccessMessage('Order Successfully Converted to 3 Pay');
                            refreshOrder = true;
                            is3PayConverted = true;
                        }
                        modifiedOrderItemWrappers.add(theWrapp);
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            system.debug('exception inside 3pay service method');
            IADServiceBase_ltng.populateErrorMessage('Failed Converting to 3 Pay: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void cancelOrderItem(String productConfigurationId , String orderId, Map<String,IADContractBeans_ltng.IADActionItem> pdtCnfgActionItemMap)
    {
        currentAPIEndPoint = '';
        refreshOrder = false;
        IADContractBeans_ltng.IADActionItem theActionItem = pdtCnfgActionItemMap.get(productConfigurationId);
        try
        {
            String calloutURL;
            currentAPIEndPoint = DELETEORDERITEMBYORDERITEMDID;
            IADServiceBase_ltng.initWrapper(DELETEORDERITEMBYORDERITEMDID); //, 'processOrderItemResponse'
            calloutURL = IADServiceBase_ltng.APItoWrapper.get(DELETEORDERITEMBYORDERITEMDID).endPointConfig.link__c;
            calloutURL = calloutURL.replace('{orderId}',orderId);
            calloutURL = calloutURL.replace('{orderItemId}',theActionItem.orderItemId);
            
            if(calloutURL != null && calloutURL != '')
            {
                IADServiceBase_ltng.APItoWrapper.get(DELETEORDERITEMBYORDERITEMDID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
                IADServiceBase_ltng.APItoWrapper.get(DELETEORDERITEMBYORDERITEMDID).setInfo(APIRequestResponseWrapper.ORDERITEM, theActionItem.orderItemId);
                IADServiceBase_ltng.makeRequestMulti(calloutURL, currentAPIEndPoint, '');
                processOrderItemResponse();
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed Cancelling Order Items '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void changeOrderItem(String productConfigurationId , String orderId ,  String orderItemId, Map<String,IADContractBeans_ltng.IADActionItem> pdtCnfgActionItemMap, Map<String, String> orderItemIdToPdtCnfgIdMap)
    {
        currentAPIEndPoint = '';
        refreshOrder = false;
        IADContractBeans_ltng.IADActionItem theActionItem = pdtCnfgActionItemMap.get(productConfigurationId);
        system.debug('theActionItem.productTypeId: '+theActionItem.productTypeId);
        try
        {
            if(theActionItem.productTypeId == '2')//Only for Package
            {
                String calloutURL;
                currentAPIEndPoint = POSTPACKAGECHANGEBYORDERID;
                IADServiceBase_ltng.initWrapper(currentAPIEndPoint);
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(currentAPIEndPoint).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderId}',orderId);
                
                system.debug('calloutURL: '+calloutURL);
                
                if(calloutURL != null && calloutURL != '')
                {
                    String jsonString = '{"oldProductConfigurationId":'+orderItemIdToPdtCnfgIdMap.get(theActionItem.orderItemId)+',"newProductConfigurationId":'+theActionItem.productConfigurationId+',"createdBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
                    IADServiceBase_ltng.APItoWrapper.get(POSTPACKAGECHANGEBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
                    IADServiceBase_ltng.APItoWrapper.get(POSTPACKAGECHANGEBYORDERID).setInfo(APIRequestResponseWrapper.ORDERITEM, orderItemId);
                    IADServiceBase_ltng.makeRequestMulti(calloutURL, currentAPIEndPoint, jsonString);
                    system.debug('before process order response: ');
                    processOrderResponse();
                }
            }
            else if(theActionItem.productTypeId == '7')//Shipping
            {
                String calloutURL;
                currentAPIEndPoint = PUTSHIPPINGBYORDERITEMID;
                IADServiceBase_ltng.initWrapper(currentAPIEndPoint);
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(currentAPIEndPoint).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderItemId}',orderItemId);
                
                if(calloutURL != null && calloutURL != '')
                {
                    String jsonString = '{"productConfigurationId":'+theActionItem.productConfigurationId+',"createdBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
                    IADServiceBase_ltng.APItoWrapper.get(PUTSHIPPINGBYORDERITEMID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
                    IADServiceBase_ltng.APItoWrapper.get(PUTSHIPPINGBYORDERITEMID).setInfo(APIRequestResponseWrapper.ORDERITEM, orderItemId);
                    IADServiceBase_ltng.makeRequestMulti(calloutURL, currentAPIEndPoint, jsonString);
                    processOrderItemResponse();
                }
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed Changing Item '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void addOrderItem(String productConfigurationId , String orderId , String orderItemId, Map<String,IADContractBeans_ltng.IADActionItem> pdtCnfgActionItemMap) 
    {
        orderNumber = orderId;
        isCrossSell = false;
        currentAPIEndPoint = '';
        refreshOrder = false;
        isNewOrderAdded = false;
        IADContractBeans_ltng.IADActionItem theActionItem = pdtCnfgActionItemMap.get(productConfigurationId);
        system.debug('theActionItem: '+theActionItem);
        system.debug('Product Type Id: '+theActionItem.productTypeId);
        try
        {
            String calloutURL;
            
            system.debug('Product Type Id: '+theActionItem.productTypeId);
            
            if(theActionItem.productTypeId == '3') //Add On
            {
                currentAPIEndPoint = POSTADDONSBYORDERID;
                IADServiceBase_ltng.initWrapper(POSTADDONSBYORDERID); 
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTADDONSBYORDERID).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderId}',orderId);
            }
            else if(theActionItem.productTypeId == '9') //Cross Sell
            {
                //changes made as part of story B-39032
                if(UtilityLibrary.isPermissionSetAssigned(UserInfo.getUserId(), UtilityLibrary.PERMISSION_SET1)){
                    IADServiceBase_ltng.initWrapper(POSTCROSSSELLSBYORDERIDV3);
                    currentAPIEndPoint = POSTCROSSSELLSBYORDERIDV3;
                    calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTCROSSSELLSBYORDERIDV3).endPointConfig.link__c;
                }else{
                    IADServiceBase_ltng.initWrapper(POSTCROSSSELLSBYORDERID);
                    currentAPIEndPoint = POSTCROSSSELLSBYORDERID;
                    calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTCROSSSELLSBYORDERID).endPointConfig.link__c;
                }
                calloutURL = calloutURL.replace('{orderId}',orderId);
                isCrossSell = true;
                
            }
            else if(theActionItem.productTypeId == '7') //Shipping
            {
                IADServiceBase_ltng.initWrapper(POSTSHIPPINGBYORDERID);
                currentAPIEndPoint = POSTSHIPPINGBYORDERID;
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTSHIPPINGBYORDERID).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderId}',orderId);
                
            }
            else if(theActionItem.productTypeId == '8') //Filing Fees
            {
                IADServiceBase_ltng.initWrapper(POSTFILINGFEESBYORDERID);
                currentAPIEndPoint = POSTFILINGFEESBYORDERID;
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTFILINGFEESBYORDERID).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderId}',orderId);
                
            }
            else if(theActionItem.productTypeId == '12') //Renewal
            {
                IADServiceBase_ltng.initWrapper(POSTRENEWALBYORDERITEMID);
                currentAPIEndPoint = POSTRENEWALBYORDERITEMID;
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTRENEWALBYORDERITEMID).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{orderItemId}',orderItemId);
                
            }
            
            System.debug('CALL Out URL '+calloutURL);
            System.debug('IADServiceBase_ltng.APItoWrapper: '+IADServiceBase_ltng.APItoWrapper);
            if(calloutURL != null && calloutURL != '')
            {
                String jsonString;
                if(theActionItem.actionItemsType == '0') //Add
                {
                    jsonString = '{"productConfigurationId":'+theActionItem.productConfigurationId+',"createdBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
                    IADServiceBase_ltng.APItoWrapper.get(currentAPIEndPoint).setInfo(APIRequestResponseWrapper.ORDER, orderId);
                    IADServiceBase_ltng.APItoWrapper.get(currentAPIEndPoint).setInfo(APIRequestResponseWrapper.ORDERITEM, orderItemId);
                    IADServiceBase_ltng.makeRequestMulti(calloutURL, currentAPIEndPoint, jsonString);
                    
                    System.debug('theActionItem.productTypeId '+theActionItem.productTypeId);
                    
                    if(theActionItem.productTypeId != '12'){
                        processOrderItemResponse();
                    }else if(theActionItem.productTypeId == '12'){
                        processOrderResponse();
                    }
                }
            }
            system.debug('modifiedOrderItemWrappers: '+modifiedOrderItemWrappers);
        }
        catch(Exception theException)
        {
            system.debug('Exception thrown inside add order item');
            IADServiceBase_ltng.populateErrorMessage('Failed Adding Item '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void processOrderItemResponse()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(currentAPIEndPoint);
            newOrderId = null;    
            system.debug('theResponse: addon: '+theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                    addOnAdded = true;
                    IADContractBeans_ltng.IADOrderItemResponse  deserializedResponse = (IADContractBeans_ltng.IADOrderItemResponse) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADOrderItemResponse.class);
                    theResponse.resultObjects = new List<Object>{deserializedResponse };//one element list
                        system.debug('processOrderItemResponse: deSerializedResponse..  '+deSerializedResponse); 
                    if(deserializedResponse != null)
                    {
                        if(deserializedResponse.orderItem != null)
                        {
                            IADContractbeans_ltng.IADOrderItem theItem = deSerializedResponse.orderItem;
                            theItem.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theItem.dateCreated);//takes String
                            String displayNameOnBill;
                            if(theItem.productConfiguration != null && theItem.productConfiguration.productComponent != null && theItem.productConfiguration.productComponent.displayNameOnBill != null){
                            	displayNameOnBill = theItem.productConfiguration.productComponent.displayNameOnBill;
                                system.debug('theItem.productConfiguration.productComponent.displayNameOnBill-->'+theItem.productConfiguration.productComponent.displayNameOnBill);                            
                            }
                            OrderItemWrapper theWrapp = new OrderItemWrapper(displayNameOnBill, theItem.productName , 
                                                                             theItem.dateTimeCreatedInString , theItem.orderItemId , theItem.quantity , theItem.extendedPrice , theItem.isCancelled , 0);
                            if(theItem.processingOrder != null)
                            {
                                theWrapp.processingOrderId = theItem.processingOrder.processingOrderId;
                                theWrapp.entityName = processingOrderIdOrderItemMap.get(theItem.processingOrder.processingOrderId) != null ? processingOrderIdOrderItemMap.get(theItem.processingOrder.processingOrderId).Entity_Name__c : '';
                                theWrapp.copyrightTradeMarkName = processingOrderIdOrderItemMap.get(theItem.processingOrder.processingOrderId) != null ? processingOrderIdOrderItemMap.get(theItem.processingOrder.processingOrderId).Trademark_Copyright_Name__c : '';
                            }
                            if(theItem.productConfiguration != null)
                            {
                                theWrapp.productTypeId =  theItem.productConfiguration.productTypeId; 
                            }
                            if(theResponse.requestType == 'POST')
                            {
                                theWrapp.modificationType = 'Added';
                                theWrapp.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theItem.dateCreated);
                                IADServiceBase_ltng.populateSuccessMessage('Item Added Successfully!!');
                                if(orderNumber != deserializedResponse.orderId)
                                {
                                    isNewOrderAdded = true;
                                    newOrderId = deserializedResponse.orderId; 
                                }
                            }
                            else if(theResponse.requestType == 'DELETE')
                            {
                                theWrapp.modificationType = 'Cancelled';
                                IADServiceBase_ltng.populateSuccessMessage('Item Cancelled Successfully!!');
                            }
                            else if(theResponse.requestType == 'PUT')
                            {
                                theWrapp.modificationType = 'Changed';    
                                IADServiceBase_ltng.populateSuccessMessage('Item Changed Successfully!!');
                                iadServiceMessages = IADServiceBase_ltng.iadMessages;
                            }
                            modifiedOrderItemWrappers.add(theWrapp);
                            
                            refreshOrder = true;
                        }
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed Adding Addons: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void processOrderResponse()
    {
        try
        {
            system.debug('inside process order response: ');
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(currentAPIEndPoint);
            system.debug('theResponse: '+theResponse); 
            newOrderId = null;  
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                    system.debug('the Response data: '+theResponse.responseData) ;              
                    IADContractBeans_ltng.IADOrderBeanWrapper deSerializedResponse  = (IADContractBeans_ltng.IADOrderBeanWrapper) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADOrderBeanWrapper.class);
                    
                    system.debug('processOrderResponse deSerializedResponse.. : '+deSerializedResponse); 
                    
                    for(IADContractBeans_ltng.IADOrderItem theItem : deSerializedResponse.Order.orderItems)
                    {
                        theItem.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theItem.dateCreated);//takes String
                    }
                    theResponse.resultObjects = new List<Object>{deSerializedResponse};
                        
                        if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        IADContractBeans_ltng.IADOrderBeanWrapper responseOrder = (IADContractBeans_ltng.IADOrderBeanWrapper)IADServiceBase_ltng.APItoWrapper.get(currentAPIEndPoint).resultObjects[0];
                        
                        for(IADContractbeans_ltng.IADOrderItem theOrderItemWrapper : responseOrder.Order.orderItems)
                        {
                            if((theOrderItemWrapper.productConfiguration.productTypeId == '2' || theOrderItemWrapper.productConfiguration.productTypeId == '12' 
                                || theOrderItemWrapper.productConfiguration.productTypeId == '13' || theOrderItemWrapper.productConfiguration.productTypeId == '10'
                               ) && !theOrderItemWrapper.isCancelled)
                            {
                                theOrderItemWrapper.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theOrderItemWrapper.dateCreated);//takes String
                                OrderItemWrapper theWrapp = new OrderItemWrapper(theOrderItemWrapper.productConfiguration.productComponent.displayNameOnBill, theOrderItemWrapper.productName , 
                                                                                 theOrderItemWrapper.dateTimeCreatedInString , theOrderItemWrapper.orderItemId , theOrderItemWrapper.quantity , theOrderItemWrapper.extendedPrice , theOrderItemWrapper.isCancelled , 0);
                                
                                if(theResponse.requestType == 'POST')
                                {
                                    if(currentAPIEndPoint == POSTPACKAGECHANGEBYORDERID)
                                    {
                                        
                                        mainOrderItemId = theOrderItemWrapper.orderItemId;
                                        if(theOrderItemWrapper.processingOrder != null)
                                        {
                                            baseProcessingStatus = processingStatusIdToName.get(theOrderItemWrapper.processingOrder.processingStatusId); 
                                        }
                                        orderNumber = responseOrder.Order.orderId;
                                        orderDateTimeCreated = UtilityLibrary.getIADDateTime(responseOrder.Order.dateCreated);//takes String
                                        IADServiceBase_ltng.populateSuccessMessage('Package Successfully Changed');
                                        theWrapp.modificationType = 'Changed Package';
                                    }
                                    else if(currentAPIEndPoint == POSTRENEWALBYORDERITEMID)
                                    {
                                        IADServiceBase_ltng.populateSuccessMessage('Renewal Added');
                                        theWrapp.modificationType = 'Renewal Added';
                                        isNewOrderAdded = true;
                                        newOrderId = responseOrder.Order.orderId;
                                        // Creating orders for renewal
                                        IADOrderSearchController_Ltng.createNewOrder(neworderid,IADOrderWithOrderItemsController_ltng.customerIdrelated);
                                        System.debug('Inside response method');   
                                    }
                                }
                                else if(theResponse.requestType == 'DELETE')
                                {    
                                    theWrapp.modificationType = 'Cancelled';
                                }
                                modifiedOrderItemWrappers.add(theWrapp);
                                refreshOrder = true;
                                break;
                            }     
                        }
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed Processing Order Response '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void getActionItemsByOrderItemId(String orderItemId , Set<String> actionTypeIds)
    {
        currentActionTypeIds = actionTypeIds;
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETACTIONITEMSBYORDERITEMID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderItemId}', orderItemId);
        IADServiceBase_ltng.APItoWrapper.get(GETACTIONITEMSBYORDERITEMID).setInfo(APIRequestResponseWrapper.ORDERITEM, orderItemId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETACTIONITEMSBYORDERITEMID, '');
        system.debug('im inside getActionItemsByOrderItemId');
        populateActionItems();
    }
    
    public static void populateActionItems()
    {
        refreshOrder = false;
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETACTIONITEMSBYORDERITEMID);
            system.debug('The response: getActionItemsByOrderItemId: '+theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                    availableActionItems = new IADContractbeans_ltng.IADActionItemBean();
                    currentActionItems = new List<IADContractBeans_ltng.IADActionItem>();
                    system.debug('action items : theResponse.responseData ' + theResponse.responseData);
                    system.debug('currentActionTypeIds: '+currentActionTypeIds);
                    IADContractBeans_ltng.IADActionItemBean deSerializedResponse  = (IADContractBeans_ltng.IADActionItemBean) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADActionItemBean.class);
                    availableActionItems =  deSerializedResponse;
                    
                    for(IADContractBeans_ltng.IADActionItem theActionItem : availableActionItems.actionItems)
                    {
                        system.debug('productComponentIdToName: '+productComponentIdToName);
                        system.debug('theActionItem.actionItemsType: '+theActionItem.actionItemsType);
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
                    system.debug('currentActionItems: '+currentActionItems);
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed Displaying Action Items '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    
    public static void createMiscItemByOrderId(String orderId, String itemQuantity, String itemPricePerUnit, String itemDescription )
    {
        System.debug('im inside createMiscItemByOrderId');
        orderNumber = orderId;
        currentAPIEndPoint = POSTMISCITEMBYORDERID;
        IADServiceBase_ltng.initWrapper(POSTMISCITEMBYORDERID); //, 'processOrderItemResponse'
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTMISCITEMBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        String jsonBody = '{"description":"'+itemDescription+'","quantity":'+itemQuantity+',"pricePerUnit":'+itemPricePerUnit+',"createdBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
        IADServiceBase_ltng.APItoWrapper.get(POSTMISCITEMBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTMISCITEMBYORDERID, jsonBody);
        processOrderItemResponse();
    }
    
    public static void callCancelUnCancelOrder(String Orderid, String Operation)
    {
        
        system.debug('Operation: '+Operation);
        currentAPIEndPoint = '';
        if(Operation == 'Cancel')
        {
            currentAPIEndPoint = DELETEORDERBYORDERID;
            String url = (IADServiceBase_ltng.APItoWrapper.get(currentAPIEndPoint).endPointConfig.link__c);
            String calloutURL = url.replace('{orderId}',Orderid);
            IADServiceBase_ltng.APItoWrapper.get(DELETEORDERBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, Orderid);
            IADServiceBase_ltng.makeRequestMulti(calloutURL, currentAPIEndPoint,'');
        }
        else if(Operation == 'Uncancel')
        {
            currentAPIEndPoint = PUTUNCANCELORDERBYORDERID;
            String url = (IADServiceBase_ltng.APItoWrapper.get(currentAPIEndPoint).endPointConfig.link__c);
            String calloutURL = url.replace('{orderId}',Orderid);
            String jsonBody = '{"updatedBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
            
            system.debug('Uncancellation URL: '+calloutURL);
            system.debug('Uncancellation jsonBody: '+jsonBody);
            IADServiceBase_ltng.APItoWrapper.get(PUTUNCANCELORDERBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, Orderid);
            IADServiceBase_ltng.makeRequestMulti(calloutURL, currentAPIEndPoint, jsonBody);
            system.debug('Uncancellation success: ');
        }
        processCancelUncancelResponse();
    }
    
    public static void processCancelUncancelResponse()
    {
        
        cancelUnCancelResponse = false;
        try
        {
            APIRequestResponseWrapper_ltng orderResponse = IADServiceBase_ltng.APItoWrapper.get(currentAPIEndPoint);
            system.debug('Order cancellation response: '+orderResponse);
            if (orderResponse.responseData != null)
            {
                if (orderResponse.checkIsValidResponse())
                {
                    system.debug('It is a valid Order cancellation response: ');
                    system.debug('currentAPIEndPoint: '+currentAPIEndPoint);
                    if(currentAPIEndPoint == DELETEORDERBYORDERID)
                    {
                        IADServiceBase_ltng.iadMessages.add(IADMessageFactory_ltng.createMessage('success' , 'Order Cancelled Successfully'));
                        iadServiceMessages = IADServiceBase_ltng.iadMessages;
                    }
                    else if(currentAPIEndPoint == PUTUNCANCELORDERBYORDERID)
                    {
                        IADServiceBase_ltng.iadMessages.add(IADMessageFactory_ltng.createMessage('success' , 'Order UnCancelled Successfully'));
                        iadServiceMessages = IADServiceBase_ltng.iadMessages;
                    }
                    cancelUnCancelResponse = true;
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage('Invalid Response. Response Code : ' + orderResponse.statusCode + ' Message Body :  ' + orderResponse.errorMessage);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage('Null Response. Response Code : ' + orderResponse.statusCode + ' Message Body :  ' + orderResponse.errorMessage);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Unable to canel order at this time. '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
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
    
    public Static Map<String,String> processingStatusIdToName
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
    
    public  static void getEntityByProcessingID(String processingid)
    {
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETENTITYBYPROCESSINGID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{processingid}', processingid);
        IADServiceBase_ltng.makeRequestMulti(calloutURL,GETENTITYBYPROCESSINGID , '');
        populateEIN();
    }
    
    public static  void populateEIN()
    {
        try
        {
            //initHTTPResponse(GETINSTALLMENTBYINSTALLMENTID);
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(GETENTITYBYPROCESSINGID);
            
            if (response.checkIsValidResponse())
            {
                if(response.responseData != null)
                {
                    deserialzedEntity =  (IADContractBeans_ltng.IADEntity) JSON.deserialize(response.responseData, IADContractBeans_ltng.IADEntity.class);
                    
                    system.debug('the entity '+deserialzedEntity);
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(response);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(response);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
        }
    }    
    
    public static void createExpedite(String orderId, String itemQuantity, String productconfig, string itemPricePerUnit )
    {
        System.debug('im inside expedite');
        currentAPIEndPoint = POSTADDONSBYORDERID;
        IADServiceBase_ltng.initWrapper(POSTADDONSBYORDERID); //, 'processOrderItemResponse'
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTADDONSBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        String jsonBody = '{"productConfigurationId": '+productconfig+',"quantity":'+itemQuantity+',"createdBy":"'+UtilityLibrary.generateUpdatedBy()+'","price":'+itemPricePerUnit+'}';
        IADServiceBase_ltng.APItoWrapper.get(POSTADDONSBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL,POSTADDONSBYORDERID , jsonBody);
        processOrderItemResponse();
    }
    
    public static void createFilingItem(String orderId, Integer itemQuantity, String productconfig, string itemPricePerUnit )
    {
        system.debug('the qunatity'+itemQuantity);
        if(productconfig=='4492')
        {
            currentAPIEndPoint = POSTFILINGFEESBYORDERID;
            IADServiceBase_ltng.initWrapper(POSTFILINGFEESBYORDERID); //, 'processOrderItemResponse'
            String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTFILINGFEESBYORDERID).endPointConfig.link__c;
            calloutURL = calloutURL.replace('{orderId}', orderId);
            String jsonBody = '{"productConfigurationId": '+productconfig+',"quantity":'+itemQuantity+',"createdBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
            IADServiceBase_ltng.APItoWrapper.get(POSTFILINGFEESBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
            IADServiceBase_ltng.makeRequestMulti(calloutURL,POSTFILINGFEESBYORDERID , jsonBody);
            processOrderItemResponse();
        }
        
        else
        {
            currentAPIEndPoint = POSTADDONSBYORDERID;
            IADServiceBase_ltng.initWrapper(POSTADDONSBYORDERID); //, 'processOrderItemResponse'
            String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTADDONSBYORDERID).endPointConfig.link__c;
            calloutURL = calloutURL.replace('{orderId}', orderId);
            String jsonBody = '{"productConfigurationId": '+productconfig+',"quantity":'+itemQuantity+',"createdBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
            IADServiceBase_ltng.APItoWrapper.get(POSTADDONSBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
            IADServiceBase_ltng.makeRequestMulti(calloutURL,POSTADDONSBYORDERID , jsonBody);
            processOrderItemResponse();
        }
    }
    
    public static void getSubscriptionChangeOptions(String productComponentId, String orderItemId, String custName)
    {
        system.debug('Inside getSubscriptionChangeOptions- custName ->'+custName);
        customerName = custName;
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONCHANGEOPTIONS).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{productComponentId}', productComponentId) +'?orderItemId=' +orderItemId;
        system.debug('calloutURL--->'+calloutURL);
        //IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONCHANGEOPTIONS).setInfo(APIRequestResponseWrapper.ORDERITEM, orderItemId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETSUBSCRIPTIONCHANGEOPTIONS, '');
        system.debug('im inside getSubscriptionChangeOptions');
        populateSubscriptionChangeOptions();
    }
    
    public static void populateSubscriptionChangeOptions()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONCHANGEOPTIONS);
            system.debug('The response: GETSUBSCRIPTIONCHANGEOPTIONS: '+theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                    subChangeOptions  = (IADContractBeans_ltng.IADSubscriptionChangeOptionBean) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADSubscriptionChangeOptionBean.class);
                	system.debug('subChangeOptions---->');
                    system.debug(subChangeOptions);
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed retrieve subscription change options '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void postProratedSubscriptionTermInfo(String orderId, String orderItemId, String renewalProductConfigurationId)
    {
        String payload = '{"orderId":' + orderId + ',"orderItemId":' + orderItemId + ',"renewalProductConfigurationId":' + renewalProductConfigurationId +'}';
        system.debug('payload--->'+payload);
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTPRORATEDSUBSCRIPTIONTERM).endPointConfig.link__c;
        IADServiceBase_ltng.APItoWrapper.get(POSTPRORATEDSUBSCRIPTIONTERM).setInfo(APIRequestResponseWrapper.ORDERITEM, orderItemId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTPRORATEDSUBSCRIPTIONTERM, payload);
        system.debug('im inside getSubscriptionChangeOptions');
        populateProratedSubscriptionInfo();
    }
    
    public static void populateProratedSubscriptionInfo()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(POSTPRORATEDSUBSCRIPTIONTERM);
            system.debug('The response: POSTPRORATEDSUBSCRIPTIONTERM: '+theResponse);
            if(theResponse.checkIsValidResponse())
            {
                system.debug('is valid response: proceed');
                if(theResponse.responseData != null)
                {
                    proratedSubInfo  = (IADContractBeans_ltng.CalculateProratedAmountForSubscriptionBean) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.CalculateProratedAmountForSubscriptionBean.class);
                	system.debug('proratedSubInfo--->');
                    system.debug(proratedSubInfo);
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed retrieve subscription change options '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void upgradeSubscriptionPackage(Integer subscriptionId, String orderItemId, String targetPackage, String newProductComponentId, String renewalProductConfigurationId)
    {
        String payload = '{"subscriptionId":'+ subscriptionId + ',"orderItemId":' + orderItemId + ',"targetPackage":' + targetPackage + ',"newProductComponentId":' + newProductComponentId +',"renewalProductConfigurationId":' + renewalProductConfigurationId + ',"updatedby":' + '"'+userinfo.getUserName().substringBefore('@') + '"' +'}';
        system.debug('payload-->');
        system.debug(payload);
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(PUTSUBSCRIPTIONADJUSTMENT).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderItemId}', orderItemId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, PUTSUBSCRIPTIONADJUSTMENT, payload);
        system.debug('im inside getSubscriptionChangeOptions');
        populateUpgradedSubscriptionInfo();
    }
    
    public static void populateUpgradedSubscriptionInfo()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(PUTSUBSCRIPTIONADJUSTMENT);
            system.debug('The response: PRORATEDSUBSCRIPTIONTERM: '+theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                    newOrderInfo  = (IADContractBeans_ltng.IADOrderBean) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADOrderBean.class);
                	system.debug('newOrderInfo');
                    system.debug(newOrderInfo);
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed retrieve subscription change options '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
        
    public class OrderItemWrapper
    {
        @AuraEnabled public String productName{get;set;}
        @AuraEnabled public Boolean productNameContainsLLC{get;set;}
        @AuraEnabled public String processingOrderId{get;set;}
        @AuraEnabled public String dateTimeCreatedInString{get;set;}
        @AuraEnabled public String orderItemId{get;set;}
        @AuraEnabled public String quantity{get;set;}
        @AuraEnabled public String extendedPrice{get;set;}
        @AuraEnabled public Boolean isCancelled{get;set;}
        @AuraEnabled public Integer indent{get;set;}
        @AuraEnabled public String productTypeId{get;set;}
        @AuraEnabled public String modificationType{get;set;}
        @AuraEnabled public String productConfigurationId{get;set;}
        @AuraEnabled public Boolean isMainOrderItem{get;set;}
        @AuraEnabled public String processingStatus{get;set;} 
        @AuraEnabled public String prooferStatus{get;set;}
        @AuraEnabled public Integer processId{get;set;}
        @AuraEnabled public String processName{get;set;}
        @AuraEnabled public String displayNameOnBill{get;set;}
        @AuraEnabled public String entityName{get;set;}
        @AuraEnabled public String copyrightTradeMarkName{get;set;}
        
        public OrderItemWrapper(String dispNameOnBill, String prodName , String dateTimeCreated , String oItemId , String qty , String ePrice , Boolean isCancel , Integer toIndent)
        {
            system.debug('dispNameOnBill---->'+dispNameOnBill);
            displayNameOnBill = dispNameOnBill;
            productName = prodName;
            productNameContainsLLC = prodName.containsAny('LLC');
            dateTimeCreatedInString = dateTimeCreated;
            orderItemId = oItemId;
            quantity = qty;
            extendedPrice = ePrice;
            isCancelled = isCancel;
            indent = toIndent;
        } 
    }
    
    public class OrderItemHistoryWrapper
    {   
        @AuraEnabled public String orderNumberForOH{get;set;}
        @AuraEnabled public String productName{get;set;}
        @AuraEnabled public Integer parentRowNumber{get;set;}
        @AuraEnabled public List<IADContractBeans_ltng.IADOrderItemsHistoryWithUIComponents> orderItemHistory{get;set;}         
        
        public OrderItemHistoryWrapper(String orderNumber, String productName, Integer parentRowNumber , List<IADContractBeans_ltng.IADOrderItemsHistoryWithUIComponents> orderItemHistory)
        {
            orderNumberForOH = orderNumber;
            this.productName = productName;
            this.parentRowNumber = parentRowNumber;
            this.orderItemHistory = orderItemHistory;
        } 
    }
    
    public class OrderItemShipmentsWrapper
    {
        @AuraEnabled public String orderItemId{get;set;}
        @AuraEnabled public String imageURL{get;set;}
        @AuraEnabled public String shippedDate{get;set;}
        @AuraEnabled public String trackingCode{get;set;}
        @AuraEnabled public String trackingURL{get;set;}
        @AuraEnabled public String vendorName{get;set;}
        
        public OrderItemShipmentsWrapper(String orderItemId, String imageURL, String shippedDate, String trackingCode, String vendorName, String trackingURL){
            this.orderItemId = orderItemId;
            this.imageURL = imageURL;
            this.shippedDate = shippedDate;
            this.trackingCode = trackingCode;
            this.vendorName = vendorName;
            this.trackingURL = trackingURL;
        }
    }
      public static void postProcessingstatus(String processingnumber)
    {   
    
    POR_DDSContractBeans.UpdateProcessingBean processingUpdate = new  POR_DDSContractBeans.UpdateProcessingBean();
     
      processingUpdate.orderNumber=processingnumber;
      processingUpdate.processingStatus='Consultation Complete';
      String payloadprocessing =JSON.serialize(processingUpdate);
        
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(PostProcessingStatus).endPointConfig.link__c;
               
        IADServiceBase_ltng.makeRequestMulti(calloutURL, PostProcessingStatus, payloadprocessing);
        processProcessingStatusResponse();
    }
    
    public Static void processProcessingStatusResponse()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(PostProcessingStatus);
            
            if(theResponse.checkIsValidResponse())
            {
                IADServiceBase_ltng.populateSuccessMessage('Process status Updated');
                iadServiceMessages = IADServiceBase_ltng.iadMessages;                
            }
            else{
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed Re-Automating Order: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }    
}