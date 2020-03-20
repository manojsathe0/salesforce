public class IADSubscriptionPanelService_Ltng extends IADServiceBase_Ltng
{
    public final static String GETSUBSCRIPTIONSBYORDERID = 'GetSubscriptionsByOrderId';
    public final static String GETSUBSCRIPTIONBYSUBSCRIPTIONID = 'GetSubscriptionBySubscriptionId';
    public final static String PUTSUBSCRIPTIONBYSUBSCRIPTIONID = 'PutSubscriptionBySubscriptionId';
    public final static String PUTORDERSUBSCRIPTIONBYORDERITEMID = 'PutOrderSubscriptionByOrderItemId';
    public final static String GETPRORATEDREFUNDBYORDERITEMID = 'GetProratedRefundByOrderItemId';
    public final static String GETORDERNUMBERFROMORDERITEMID = 'GetOrderNumberFromOrderItemId';//B-15926 Updates in subscription detail view
    public final static String GETPAYMENTFROMORDERID = 'GetPaymentsByOrderId';//B-15925 View Payment Details of Subscription Renewals
    public final static String GETSUBSCRIPTIONSBYCUSTOMERID = 'GetSubscriptionsByCustomerid';
    public final static String GETSUBSCRIPTIONRENEWALTERMS = 'GetSubscriptionRenewalTerms';
    public final static String GETNEXTSUBSCRIPTIONMODIFICATION = 'GetNextSubscriptionModification';
    public final static String CANCELSUBSCRIPTIONUPGRADE = 'CancelSubscriptionUpgrade';
    public final static String CANCELSUBSCRIPTIONWITHOUTREFUND = 'CancelSubscriptionWithoutRefund';
    
    @AuraEnabled public static IADContractBeans_ltng.IADSubscriptionBean subscriptionItem{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADSingleSubscriptionBean subscriptionSingleItem{get;set;}
    @AuraEnabled public static List<IADContractBeans_ltng.IADSubscriptionInfoDetail> subscriptionInfoDetails{get;set;}
    @AuraEnabled public static List<SubscriptionWrapper> subscriptionInfoDetailsWrapped{get;set;}////B-15926 Updates in subscription detail view
    @AuraEnabled public static SubscriptionWrapper subscriptionSingleItemWrapped{get;set;}////B-15926 Updates in subscription detail view
    @AuraEnabled public static IADContractBeans_ltng.IADSubscriptionInfoDetail lastestSubscriptionInfoDetail{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADSubscriptionInfoDetail subscriptionDetailToPost{get;set;}
    @AuraEnabled public static Map<String,IADContractBeans_ltng.IADSubscriptionInfoDetail> subscriptionOrderItemIdToDetail{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADSubscriptionRenewalTerms subscriptionRenewalTerms{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADSubscriptionAdjustment scheduledUpgrade{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADSubUpgradeCancellation subscriptionUpgradeCancelResponse{get;set;}
    
    @AuraEnabled public static String customerId{get;set;}
    @AuraEnabled public static String profileId{get;set;}
    @AuraEnabled public static String startDateRange{get;set;}
    @AuraEnabled public static String endDateRange{get;set;}
    @AuraEnabled public static String orderId{get;set;}
    @AuraEnabled public static Boolean isCancelSuccess{get;set;}
    @AuraEnabled public static Boolean isAllowedCancel{get;set;}
    @AuraEnabled public static String renewalOrderId{get;set;}
    @AuraEnabled public static Boolean hasSubscriptions{get;set;}
    @AuraEnabled public static Boolean isSubscriptionLoaded{get;set;}
    @AuraEnabled public static Map<String,String> dayToProRatedAmount{get;set;}
    @AuraEnabled public static Map<String,String> orderOrderItemMap{get;set;} ////B-15926 Updates in subscription detail view
    @AuraEnabled public static Map<String,String> transactionOrderMap{get;set;} //B-15925 View Payment Details of Subscription Renewals
    @AuraEnabled public static Map<String,String> transactionTypeOrderMap{get;set;} //B-15925 View Payment Details of Subscription Renewals
    @AuraEnabled public static Map<String,String> transactionAmountOrderMap{get;set;} //B-15925 View Payment Amount of Subscription Renewals
    
    @AuraEnabled public static Map<String,String> orderIdOrderRecordIdMap{get;set;} //B-31412
    @AuraEnabled public static Set<String> orderIdSet{get;set;}//B-31412
    @AuraEnabled public static Map<String,String> orderIdEntityNameMap{get;set;}//B-31412
    
    @AuraEnabled public static List<IADMessage_ltng> iadServiceMessages{get;set;}
    
    public IADSubscriptionPanelService_Ltng()
    {
        super();
        List <String> endpoints = new List <String> ();
        orderIdSet = new Set<String>();
        orderOrderItemMap = new Map<string,string>();
        transactionOrderMap = new Map<string,string>();
        transactionTypeOrderMap = new Map<string,string>();
        transactionAmountOrderMap = new Map<string,string>();
        orderIdOrderRecordIdMap = new Map<string,string>();
        orderIdEntityNameMap = new Map<string,string>();
        
        endpoints.add(GETSUBSCRIPTIONSBYORDERID);
        endpoints.add(GETSUBSCRIPTIONBYSUBSCRIPTIONID);
        endpoints.add(PUTSUBSCRIPTIONBYSUBSCRIPTIONID);
        endpoints.add(PUTORDERSUBSCRIPTIONBYORDERITEMID);
        endpoints.add(GETPRORATEDREFUNDBYORDERITEMID);
        endpoints.add(GETORDERNUMBERFROMORDERITEMID); 
        endpoints.add(GETPAYMENTFROMORDERID); 
        endpoints.add(GETSUBSCRIPTIONSBYCUSTOMERID);
        endpoints.add(GETSUBSCRIPTIONRENEWALTERMS);
        endpoints.add(GETNEXTSUBSCRIPTIONMODIFICATION);
        endpoints.add(CANCELSUBSCRIPTIONUPGRADE);
        endpoints.add(CANCELSUBSCRIPTIONWITHOUTREFUND);
        
        initEndpoints(endpoints);
        
        hasSubscriptions = false;
        isSubscriptionLoaded = false;
        iadServiceMessages = new List<IADMessage_ltng>();
        subscriptionInfoDetails = new List<IADContractBeans_ltng.IADSubscriptionInfoDetail>();
        subscriptionDetailToPost = new IADContractBeans_ltng.IADSubscriptionInfoDetail();
        subscriptionOrderItemIdToDetail = new Map<String,IADContractBeans_ltng.IADSubscriptionInfoDetail>();
        subscriptionRenewalTerms = new IADContractBeans_ltng.IADSubscriptionRenewalTerms();
        scheduledUpgrade = new IADContractBeans_ltng.IADSubscriptionAdjustment();
        subscriptionUpgradeCancelResponse = new IADContractBeans_ltng.IADSubUpgradeCancellation();
        subscriptionSingleItem = new IADContractBeans_ltng.IADSingleSubscriptionBean();
        lastestSubscriptionInfoDetail = new IADContractBeans_ltng.IADSubscriptionInfoDetail();
    }
    
    public static void getSubscriptionsyByOrderId(String odrId, String custId) 
    {
        orderId = odrId;
        customerId = custId;
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONSBYORDERID).endPointConfig.link__c).replace('{orderId}',orderId);
        IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONSBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETSUBSCRIPTIONSBYORDERID , '');
        
        populateSubscription();
    }
    
    public static void populateSubscription()
    {
        hasSubscriptions = false;
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONSBYORDERID);
            
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    IADContractBeans_ltng.IADSubscriptionBean deSerializedResponse  = (IADContractBeans_ltng.IADSubscriptionBean) System.JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADSubscriptionBean.class);
                    theResponse.resultObjects =  new List<Object>{deSerializedResponse};
                        system.debug('deSerializedResponse: '+deSerializedResponse);    
                    if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        hasSubscriptions = true;
                        subscriptionItem = (IADContractBeans_ltng.IADSubscriptionBean)IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONSBYORDERID).resultObjects[0];
                        isSubscriptionLoaded = true;
                        for(IADContractBeans_ltng.IADSubscription sub : subscriptionItem.subscriptions){
                            orderIdSet.add(sub.orderId);                            
                        }
                        mapOrderIdToEntityName(orderIdSet);
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
                if(theresponse.statusCode == '404')
                {
                    hasSubscriptions = false;
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }    
            }
        }
        
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException); 
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void getSubscriptionsyByCustomerId(String custId) 
    {
        
        customerId = custId;
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONSBYCUSTOMERID).endPointConfig.link__c).replace('{customerId}', customerId );
        //IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONSBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETSUBSCRIPTIONSBYCUSTOMERID , '');
        
        populateSubscriptionCustomerID();
    }
    
    
    public static void populateSubscriptionCustomerID()    {
        
        hasSubscriptions = false;
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONSBYCUSTOMERID);
            
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    IADContractBeans_ltng.IADSubscriptionBean deSerializedResponse  = (IADContractBeans_ltng.IADSubscriptionBean) System.JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADSubscriptionBean.class);
                    theResponse.resultObjects =  new List<Object>{deSerializedResponse};
                        system.debug('deSerializedResponse: '+deSerializedResponse);    
                    if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        hasSubscriptions = true;
                        subscriptionItem = (IADContractBeans_ltng.IADSubscriptionBean)IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONSBYCUSTOMERID).resultObjects[0];
                        isSubscriptionLoaded = true;
                        
                        for(IADContractBeans_ltng.IADSubscription sub : subscriptionItem.subscriptions){
                            orderIdSet.add(sub.orderId);
                        }
                        mapOrderIdToEntityName(orderIdSet);                        
                    }
                    subscriptionItem.subscriptions.sort();
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                if(theresponse.statusCode == '404')
                {
                    hasSubscriptions = false;
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }    
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }

    public static void mapOrderIdToEntityName(Set<String> odrIdSet) 
    {
        system.debug('odrIdSet');
        system.debug(odrIdSet);
        for(Order_Item__c oItem : [Select ID, Order__r.OrderID__c, User_Order_ID__c, Entity_Name__c, TradeMark_Copyright_Name__c From Order_Item__c WHERE Order__r.OrderID__c IN: odrIdSet AND TradeMark_Copyright_Name__c != null])
        {
            system.debug('oItem--->');
            system.debug(oItem);
            orderIdEntityNameMap.put(oItem.Order__r.OrderID__c, oItem.TradeMark_Copyright_Name__c);
        }
        system.debug('orderIdEntityNameMap');
        system.debug(orderIdEntityNameMap);
    }    
    
    public static void getSubscriptionBySubscriptionId(String subscriptionId)
    {
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONBYSUBSCRIPTIONID).endPointConfig.link__c).replace('{subscriptionId}',subscriptionId);
        system.debug('getSubscriptionBySubscriptionId: calloutURL '+calloutURL);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETSUBSCRIPTIONBYSUBSCRIPTIONID , '');
        populateSubscriptionBySubcriptionId();
    }
    
    public static void populateSubscriptionBySubcriptionId()
    {
        subscriptionInfoDetails.clear();
        try
        {
            Set<String> orderIds = new Set<String>();   
            Map<String, String> orderIdToOrderRecordIdMap = new Map<String, String>();
            
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONBYSUBSCRIPTIONID);
            
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    IADContractBeans_ltng.IADSingleSubscriptionBean deSerializedResponse  = (IADContractBeans_ltng.IADSingleSubscriptionBean) System.JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADSingleSubscriptionBean.class);
                    theResponse.resultObjects =  new List<Object>{deSerializedResponse};
                        
                        if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        subscriptionSingleItem = (IADContractBeans_ltng.IADSingleSubscriptionBean)IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONBYSUBSCRIPTIONID).resultObjects[0];
                        system.debug('<!------------ Single Subscription Details---->'+JSON.serialize(subscriptionSingleItem));
                        orderId = subscriptionSingleItem.subscription.orderId;
                        changeDateFormat();
                        String lastItemId;
                        
                        for(IADContractBeans_ltng.IADSubscriptionInfoDetail theDetail : subscriptionSingleItem.subscription.subscriptionInfoDetail)
                        {
                        	orderIds.add(theDetail.orderId);                                
                        }
                        
                        for(Order__c ord : [select Id, Name from Order__c where Name IN: orderIds]){
                            orderIdToOrderRecordIdMap.put(ord.Name, String.valueOf(ord.Id));
                        }
                        
                        for(IADContractBeans_ltng.IADSubscriptionInfoDetail theDetail : subscriptionSingleItem.subscription.subscriptionInfoDetail)
                        {
                            theDetail.adjSubscriptionStartDate = UtilityLibrary.getIADDateTime(theDetail.subscriptionStartDate);
                            theDetail.adjSubscriptionEndDate = UtilityLibrary.getIADDateTime(theDetail.subscriptionEndDate);
                            theDetail.adjSubscriptionStartDate = theDetail.adjSubscriptionStartDate.subString(0 , theDetail.adjSubscriptionStartDate.indexOf(' '));
                            theDetail.adjSubscriptionEndDate = theDetail.adjSubscriptionEndDate.subString(0 , theDetail.adjSubscriptionEndDate.indexOf(' '));
                            theDetail.associatedSFDCRecordId = orderIdToOrderRecordIdMap.get(theDetail.orderId) != null ? orderIdToOrderRecordIdMap.get(theDetail.orderId) : '';
                            lastItemId = theDetail.orderItemId;
                            system.debug('OrderItemId---->'+theDetail.orderItemId);
                            subscriptionInfoDetails.add(theDetail);
                            subscriptionOrderItemIdToDetail.put(theDetail.orderItemId , theDetail);                            
                        }
                        if(!subscriptionInfoDetails.isEmpty())
                        {
                            lastestSubscriptionInfoDetail = subscriptionInfoDetails[0];
                            system.debug('Latest Subscription Details---->'+lastestSubscriptionInfoDetail);
                            
                            if(subscriptionInfoDetails.size() == 1)
                            {
                                subscriptionInfoDetails.clear();
                            }
                            else
                            {
                                subscriptionInfoDetails.remove(0);
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
            IADServiceBase_ltng.populateErrorMessage('Failed displaying Subscription.'+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;            
        }
    }
    
    public static void putSubscriptionBySubscriptionId(String subscriptionId, Integer renew, Integer profileId, Integer pdtCompId, Integer pdtConfigId, Decimal extendedPrice)
    {
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(PUTSUBSCRIPTIONBYSUBSCRIPTIONID).endPointConfig.link__c).replace('{subscriptionId}',subscriptionId);
        system.debug('Callout URL: '+calloutURL);
        IADContractBeans_ltng.IADUpdateSubscriptionBean bean = new IADContractBeans_ltng.IADUpdateSubscriptionBean();
        IADContractBeans_ltng.IADUpdateSubscription sub = new IADContractBeans_ltng.IADUpdateSubscription();
        sub.subscriptionID = subscriptionId;
        sub.autoRenewOptionId = renew;
        sub.updatedBy = UtilityLibrary.generateUpdatedBy();
        sub.userPaymentProfileId = profileId;
        if(pdtCompId != null && pdtConfigId != null){
            sub.productComponentId = pdtCompId;
            sub.renewalProductConfigurationId = pdtConfigId;
            sub.extendedPrice = extendedPrice;
        }
        bean.orderItemSubscription = sub;
        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, PUTSUBSCRIPTIONBYSUBSCRIPTIONID , JSON.serialize(bean));
        
        populatePutSubscriptionBySubcriptionId();
    }
    
    public static void populatePutSubscriptionBySubcriptionId()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(PUTSUBSCRIPTIONBYSUBSCRIPTIONID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    system.debug('theresponse ' + theResponse.responseData);
                    IADContractBeans_ltng.IADUpdateSubscriptionResponse deSerializedResponse  = (IADContractBeans_ltng.IADUpdateSubscriptionResponse) System.JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADUpdateSubscriptionResponse.class);
                    
                    if(deSerializedResponse.success)
                    {
                        IADServiceBase_ltng.populateSuccessMessage(deSerializedResponse.message);
                        iadServiceMessages = IADServiceBase_ltng.iadMessages;
                    }
                    else
                    {
                        IADServiceBase_ltng.populateErrorMessage('Error: Order Item Subscription update failed.');
                        iadServiceMessages = IADServiceBase_ltng.iadMessages;
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
            IADServiceBase_ltng.populateErrorMessage(theException.getStackTraceString());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void changeDateFormat()
    {
        subscriptionSingleItem.subscription.adjCreatedDate = UtilityLibrary.getIADDateTime(subscriptionSingleItem.subscription.createdDate);
        subscriptionSingleItem.subscription.adjSubscriptionStartDate = UtilityLibrary.getIADDateTime(subscriptionSingleItem.subscription.subscriptionStartDate);
        subscriptionSingleItem.subscription.adjSubscriptionEndDate = UtilityLibrary.getIADDateTime(subscriptionSingleItem.subscription.subscriptionEndDate);
    }
    
    public static void putSubscriptionByOrderItemId(String customerId , String orderItemId, Boolean isPartialRefund , Double refundAmount, String subscriptionEndDate , String note)
    {
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(PUTORDERSUBSCRIPTIONBYORDERITEMID).endPointConfig.link__c);
        
        IADContractBeans_ltng.IADUpdateOrderSubscription requestBean = new IADContractBeans_ltng.IADUpdateOrderSubscription();
        
        requestBean.customerId = Integer.valueOf(customerId);
        requestBean.orderItemId = Integer.valueOf(orderItemId);
        requestBean.isPartialRefund = isPartialRefund;
        if(isPartialRefund)
        {    
            requestBean.refundAmount = refundAmount;
        }
        requestBean.updatedBy = UtilityLibrary.generateUpdatedBy();
        requestBean.note = note;
        requestBean.subscriptionEndDate = subscriptionEndDate;
        requestBean.actionType = 85;//Other.For now just pass Other
        
        System.debug('Request Man '+requestBean);
        IADServiceBase_ltng.APItoWrapper.get(PUTORDERSUBSCRIPTIONBYORDERITEMID).setInfo(APIRequestResponseWrapper_ltng.ORDERITEM, orderItemId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, PUTORDERSUBSCRIPTIONBYORDERITEMID , JSON.serialize(requestBean));
        
        populatePutOrderSubscriptionByOrderItemId();
    }
    
    public static void populatePutOrderSubscriptionByOrderItemId()
    {
        isCancelSuccess = false;
        
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(PUTORDERSUBSCRIPTIONBYORDERITEMID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    renewalOrderId = null;
                    IADContractBeans_ltng.IADOrderItemResponse  deserializedResponse = (IADContractBeans_ltng.IADOrderItemResponse) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADOrderItemResponse.class);
                    system.debug('deserializedResponse');
                    system.debug(deserializedResponse);
                    theResponse.resultObjects = new List<Object>{deserializedResponse };//one element list
                        
                        if(deserializedResponse != null)
                    {
                        if(deserializedResponse.orderItem != null)
                        {
                            IADContractbeans_ltng.IADOrderItem theItem = deSerializedResponse.orderItem;
                            renewalOrderId = theItem.orderId;
                            isCancelSuccess = true;
                            IADServiceBase_ltng.populateSuccessMessage('Successfully Cancelled');
                            iadServiceMessages = IADServiceBase_ltng.iadMessages;
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
            IADServiceBase_ltng.populateErrorMessage('Failed Processing response + ' + theException.getStackTraceString());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void populateProratedRefund(String orderItemId)
    {
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETPRORATEDREFUNDBYORDERITEMID).endPointConfig.link__c);
        calloutURL = calloutURL.replace('{orderItemId}', orderItemId);
        
        IADServiceBase_ltng.APItoWrapper.get(GETPRORATEDREFUNDBYORDERITEMID).setInfo(APIRequestResponseWrapper_ltng.ORDERITEM, orderItemId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETPRORATEDREFUNDBYORDERITEMID , '');
        processProratedRefund();
    }
    
    public static void processProratedRefund()
    {
        isAllowedCancel = false;
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETPRORATEDREFUNDBYORDERITEMID);
            system.debug('theResponse----->proratedRefund--->');
            system.debug(theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    dayToProRatedAmount = new Map<String,String>();
                    IADContractBeans_ltng.IADProRatedRefundWrapper deserializedResponse = (IADContractBeans_ltng.IADProRatedRefundWrapper) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADProRatedRefundWrapper.class);
                    system.debug('deserializedResponse: ');
                    system.debug(deserializedResponse);
                    Integer i = 1;
                    for(String theKey : deserializedResponse.proratedRefundData.keySet())
                    {
                        String datePart = theKey.substring(0,theKey.indexOf('T'));
                        if(i == deserializedResponse.proratedRefundData.size())
                        {
                            endDateRange = datePart;
                        }
                        else if(i == 1)
                        {
                            startDateRange = datePart;
                        }
                        ++i;
                        dayToProRatedAmount.put(datePart , deserializedResponse.proratedRefundData.get(theKey));
                    }
                    isAllowedCancel = true;
                    System.debug(dayToProRatedAmount);
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                if(theResponse.statusCode == '404')
                {
                    IADServiceBase_ltng.populateErrorMessage('Not Applicable for Partial Refund');
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed Pulling Prorated Refund + ' + theException.getStackTraceString());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void getSubscriptionRenewalTerms(String subscriptionId)
    {
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONRENEWALTERMS).endPointConfig.link__c);
        calloutURL = calloutURL.replace('{subscriptionId}', subscriptionId);
        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETSUBSCRIPTIONRENEWALTERMS , '');
        processSubscriptionRenewalTerms();
    }    
    
    public static void processSubscriptionRenewalTerms()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETSUBSCRIPTIONRENEWALTERMS);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    system.debug('theresponse ' + theResponse.responseData);
                    IADContractBeans_ltng.IADSubscriptionRenewalTerms deSerializedResponse  = (IADContractBeans_ltng.IADSubscriptionRenewalTerms) System.JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADSubscriptionRenewalTerms.class);
                    
                    subscriptionRenewalTerms = deSerializedResponse;
                    system.debug('subscriptionRenewalTerms');
                    system.debug(subscriptionRenewalTerms);
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
            IADServiceBase_ltng.populateErrorMessage(theException.getStackTraceString());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void getNextSubscriptionModification(String subscriptionId)
    {
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETNEXTSUBSCRIPTIONMODIFICATION).endPointConfig.link__c);
        calloutURL = calloutURL.replace('{subscriptionId}', subscriptionId);
        system.debug('calloutURL--->'+calloutURL);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETNEXTSUBSCRIPTIONMODIFICATION , '');
        processNxtSubscriptionModification();
    }    
    
    public static void processNxtSubscriptionModification()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETNEXTSUBSCRIPTIONMODIFICATION);
            system.debug('theResponse--->'+theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    system.debug('theResponse.responseData--->'+theResponse.responseData);
                    scheduledUpgrade  = (IADContractBeans_ltng.IADSubscriptionAdjustment) System.JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADSubscriptionAdjustment.class);
                    system.debug('scheduledUpgrade ' + scheduledUpgrade);
                    system.debug('theResponse ' + theResponse.responseData);
                }
            }
        }
        catch(Exception theException)
        {
            system.debug('exception thrown inside processNxtSubscriptionModification ');
            IADServiceBase_ltng.populateErrorMessage(theException.getStackTraceString());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void cancelSubscriptionUpgrade(String scheduleId)
    {
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(CANCELSUBSCRIPTIONUPGRADE).endPointConfig.link__c);
        calloutURL = calloutURL.replace('{scheduleId}', scheduleId);
        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, CANCELSUBSCRIPTIONUPGRADE, '');
        processSubscriptionUpgradeCancellation();
    }    
    
    public static void processSubscriptionUpgradeCancellation()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(CANCELSUBSCRIPTIONUPGRADE);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    subscriptionUpgradeCancelResponse  = (IADContractBeans_ltng.IADSubUpgradeCancellation) System.JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADSubUpgradeCancellation.class);
                    system.debug('subscriptionUpgradeCancelResponse ' + subscriptionUpgradeCancelResponse);
                    system.debug('subscriptionUpgradeCancelResponse.cancelledUpgrade ' + subscriptionUpgradeCancelResponse.cancelledUpgrade);
                    system.debug('theResponse ' + theResponse.responseData);
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
            system.debug('exception thrown inside processNxtSubscriptionModification ');
            IADServiceBase_ltng.populateErrorMessage(theException.getStackTraceString());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void putCancelSubscriptionWithoutRefund(String subscriptionId)
    {
        system.debug('inside putCancelSubscriptionWithoutRefund-->');
        String payload = '{"updatedBy" : "'+ UserInfo.getName() +'"}';
        system.debug('payload--->'+payload);
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(CANCELSUBSCRIPTIONWITHOUTREFUND).endPointConfig.link__c);
        calloutURL = calloutURL.replace('{subscriptionId}', subscriptionId);
        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, CANCELSUBSCRIPTIONWITHOUTREFUND, payload);
        processCancelSubscriptionWithoutRefund();
    }    
    
    public static void processCancelSubscriptionWithoutRefund()
    {
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(CANCELSUBSCRIPTIONWITHOUTREFUND);
            system.debug('theResponse--->');
            system.debug(theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    system.debug('theResponse.responseData-->');
                    system.debug(theResponse.responseData);
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
            system.debug('exception thrown inside processCancelSubscriptionWithoutRefund ');
            IADServiceBase_ltng.populateErrorMessage(theException.getStackTraceString());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public class SubscriptionWrapper{
        @AuraEnabled public Decimal amount{get;set;}
        @AuraEnabled public String isActive{get;set;}
        @AuraEnabled public String createdBy{get;set;}
        @AuraEnabled public String orderItemId{get;set;}
        @AuraEnabled public String createdDate{get;set;}
        @AuraEnabled public String adjCreatedDate{get;set;}
        @AuraEnabled public String renewalAlertEnd{get;set;}
        @AuraEnabled public String orderItemNumber{get;set;}
        @AuraEnabled public String freeShippingEndDate{get;set;}
        @AuraEnabled public String subscriptionEndDate{get;set;}
        @AuraEnabled public String orderItemTransaction{get;set;}
        @AuraEnabled public String renewalAlertStartDate{get;set;}
        @AuraEnabled public String subscriptionOrderItem{get;set;}
        @AuraEnabled public String subscriptionStartDate{get;set;}
        @AuraEnabled public String freeShippingStartDate{get;set;}
        @AuraEnabled public String associatedSFDCRecordId{get;set;}     
        @AuraEnabled public String adjSubscriptionEndDate{get;set;}
        @AuraEnabled public String orderItemSubscriptionId{get;set;}
        @AuraEnabled public String adjSubscriptionStartDate{get;set;}
        @AuraEnabled public String orderItemTransactionType{get;set;}
    }
}