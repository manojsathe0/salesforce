public class IADSubscriptionPanelService extends IADServiceBase implements IADISubServiceClassFactory
{
    public Boolean hasSubscriptions{get;set;}
    public final static String GETSUBSCRIPTIONSBYORDERID = 'GetSubscriptionsByOrderId';
    public final static String GETSUBSCRIPTIONBYSUBSCRIPTIONID = 'GetSubscriptionBySubscriptionId';
    public final static String PUTSUBSCRIPTIONBYSUBSCRIPTIONID = 'PutSubscriptionBySubscriptionId';
    public final static String PUTORDERSUBSCRIPTIONBYORDERITEMID = 'PutOrderSubscriptionByOrderItemId';
    public final static String GETPRORATEDREFUNDBYORDERITEMID = 'GetProratedRefundByOrderItemId';


    public IADContractBeans.IADSubscriptionBean subscriptionItem{get;set;}
    public IADContractBeans.IADSingleSubscriptionBean subscriptionSingleItem{get;set;}
    public List<IADContractBeans.IADSubscriptionInfoDetail> subscriptionInfoDetails{get;set;}
    public IADContractBeans.IADSubscriptionInfoDetail lastestSubscriptionInfoDetail{get;set;}
    public String customerId{get;set;}
    public IADContractBeans.IADSubscriptionInfoDetail subscriptionDetailToPost{get;set;}
    public Map<String,IADContractBeans.IADSubscriptionInfoDetail> subscriptionOrderItemIdToDetail;
    public Map<String,String> dayToProRatedAmount{get;set;}
    public String startDateRange{get;set;}
    public String endDateRange{get;set;}
    public String orderId{get;set;}
    public Boolean isCancelSuccess{get;set;}
    public Boolean isAllowedCancel{get;set;}
    public String renewalOrderId{get;set;}

    public Boolean isSubscriptionLoaded{get;set;}


    public IADSubscriptionPanelService()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETSUBSCRIPTIONSBYORDERID);
        endpoints.add(GETSUBSCRIPTIONBYSUBSCRIPTIONID);
        endpoints.add(PUTSUBSCRIPTIONBYSUBSCRIPTIONID);
        endpoints.add(PUTORDERSUBSCRIPTIONBYORDERITEMID);
        endpoints.add(GETPRORATEDREFUNDBYORDERITEMID);

        initEndpoints(endpoints);
        hasSubscriptions = false;
        subscriptionInfoDetails = new List<IADContractBeans.IADSubscriptionInfoDetail>();
        subscriptionDetailToPost = new IADContractBeans.IADSubscriptionInfoDetail();
        subscriptionOrderItemIdToDetail = new Map<String,IADContractBeans.IADSubscriptionInfoDetail>();

        isSubscriptionLoaded = false;
    }
    public IADContractBeans.IADSubscriptionBean getSubscriptions()
    {
        return subscriptionItem;
    }
    public Object getSubscriptionsyByOrderId(String orderId)
    {

        String calloutURL = (APItoWrapper.get(GETSUBSCRIPTIONSBYORDERID).endPointConfig.link__c).replace('{orderId}',orderId);
        APItoWrapper.get(GETSUBSCRIPTIONSBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        Object continuationObject = makeRequest(calloutURL, GETSUBSCRIPTIONSBYORDERID , '');

        if(!APItoWrapper.get(GETSUBSCRIPTIONSBYORDERID).isAsync)
        {
            populateSubscription();
        }
        return continuationObject;

    }
    public void populateSubscription()
    {

        hasSubscriptions = false;
        try
        {

            initHTTPResponse(GETSUBSCRIPTIONSBYORDERID); //sets the responseData and statusCode on the wrapper

            APIRequestResponseWrapper theResponse = APItoWrapper.get(GETSUBSCRIPTIONSBYORDERID);

            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {

                    IADContractBeans.IADSubscriptionBean deSerializedResponse  = (IADContractBeans.IADSubscriptionBean) System.JSON.deserialize(theResponse.responseData , IADContractBeans.IADSubscriptionBean.class);
                    theResponse.resultObjects =  new List<Object>{deSerializedResponse};

                    if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        hasSubscriptions = true;
                        subscriptionItem = (IADContractBeans.IADSubscriptionBean)APItoWrapper.get(GETSUBSCRIPTIONSBYORDERID).resultObjects[0];
                        isSubscriptionLoaded = true;
                    }
                }
                else
                {
                    populateNullErrorMessage(theResponse);

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
                    populateErrorMessage(theResponse);
                }    
            }


        }

        catch(Exception theException)
        {

            throw new IADException('Failed displaying Subscriptions.'+theException.getMessage() , theException);
        }
    }
    public Object getSubscriptionBySubscriptionId(String subscriptionId)
    {
        String calloutURL = (APItoWrapper.get(GETSUBSCRIPTIONBYSUBSCRIPTIONID).endPointConfig.link__c).replace('{subscriptionId}',subscriptionId);
        Object continuationObject = makeRequest(calloutURL, GETSUBSCRIPTIONBYSUBSCRIPTIONID , '');
        if(!APItoWrapper.get(GETSUBSCRIPTIONBYSUBSCRIPTIONID).isAsync)
        {
            populateSubscriptionBySubcriptionId();
        }
        return continuationObject;

    }
    public void populateSubscriptionBySubcriptionId()
    {
        
        subscriptionInfoDetails.clear();
        try
        {
            initHTTPResponse(GETSUBSCRIPTIONBYSUBSCRIPTIONID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(GETSUBSCRIPTIONBYSUBSCRIPTIONID);
            
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    IADContractBeans.IADSingleSubscriptionBean deSerializedResponse  = (IADContractBeans.IADSingleSubscriptionBean) System.JSON.deserialize(theResponse.responseData , IADContractBeans.IADSingleSubscriptionBean.class);
                    theResponse.resultObjects =  new List<Object>{deSerializedResponse};

                    if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        subscriptionSingleItem = (IADContractBeans.IADSingleSubscriptionBean)APItoWrapper.get(GETSUBSCRIPTIONBYSUBSCRIPTIONID).resultObjects[0];
                        orderId = subscriptionSingleItem.subscription.orderId;
                        changeDateFormat();
                        String lastItemId;
                        for(IADContractBeans.IADSubscriptionInfoDetail theDetail : subscriptionSingleItem.subscription.subscriptionInfoDetail)
                        {
                            theDetail.adjSubscriptionStartDate = UtilityLibrary.getIADDateTime(theDetail.subscriptionStartDate);
                            theDetail.adjSubscriptionEndDate = UtilityLibrary.getIADDateTime(theDetail.subscriptionEndDate);
                            theDetail.adjSubscriptionStartDate = theDetail.adjSubscriptionStartDate.subString(0 , theDetail.adjSubscriptionStartDate.indexOf(' '));
                            theDetail.adjSubscriptionEndDate = theDetail.adjSubscriptionEndDate.subString(0 , theDetail.adjSubscriptionEndDate.indexOf(' '));
                            lastItemId = theDetail.orderItemId;
                            //if(subscriptionSingleItem.subscription.relationshipType != 'CrossSell')
                            //{
                                subscriptionInfoDetails.add(theDetail);
                                subscriptionOrderItemIdToDetail.put(theDetail.orderItemId , theDetail);
                            //}
                            //else
                            //{
                              //  if(subscriptionSingleItem.subscription.orderItemId != theDetail.orderItemId)
                                //{
                                  //  subscriptionInfoDetails.add(theDetail);
                                    //subscriptionOrderItemIdToDetail.put(theDetail.orderItemSubscriptionId , theDetail);   
                                //}
                            //}
                    
                           
                        }
                        if(!subscriptionInfoDetails.isEmpty())
                        {
                            lastestSubscriptionInfoDetail = subscriptionInfoDetails[0];
                           
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

            populateErrorMessage('test + ' + theException.getStackTraceString());
            throw new IADException('Failed displaying Subscription.'+theException.getMessage() , theException);
        }
    }
    public Object putSubscriptionBySubscriptionId(String subscriptionId, Integer renew, Integer profileId)
    {
        String calloutURL = (APItoWrapper.get(PUTSUBSCRIPTIONBYSUBSCRIPTIONID).endPointConfig.link__c).replace('{subscriptionId}',subscriptionId);

        IADContractBeans.IADUpdateSubscriptionBean bean = new IADContractBeans.IADUpdateSubscriptionBean();
        IADContractBeans.IADUpdateSubscription sub = new IADContractBeans.IADUpdateSubscription();
        sub.subscriptionID = subscriptionId;
        sub.autoRenewOptionId = renew;
        sub.updatedBy = UtilityLibrary.generateUpdatedBy();
        sub.userPaymentProfileId = profileId;
        bean.orderItemSubscription = sub;


        Object continuationObject = makeRequest(calloutURL, PUTSUBSCRIPTIONBYSUBSCRIPTIONID , JSON.serialize(bean));
        if(!APItoWrapper.get(PUTSUBSCRIPTIONBYSUBSCRIPTIONID).isAsync)
        {
            populatePutSubscriptionBySubcriptionId();
        }
        return continuationObject;

    }
    public void populatePutSubscriptionBySubcriptionId()
    {
        try
        {
            initHTTPResponse(PUTSUBSCRIPTIONBYSUBSCRIPTIONID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(PUTSUBSCRIPTIONBYSUBSCRIPTIONID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    system.debug('theresponse ' + theResponse.responseData);
                    IADContractBeans.IADUpdateSubscriptionResponse deSerializedResponse  = (IADContractBeans.IADUpdateSubscriptionResponse) System.JSON.deserialize(theResponse.responseData , IADContractBeans.IADUpdateSubscriptionResponse.class);

                    if(deSerializedResponse.success)
                        populateSuccessMessage(deSerializedResponse.message);
                    else
                        populateErrorMessage('Error: Order Item Subscription update failed.');
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
            populateErrorMessage('test + ' + theException.getStackTraceString());
        }
    }
    public void changeDateFormat()
    {

        subscriptionSingleItem.subscription.adjCreatedDate = UtilityLibrary.getIADDateTime(subscriptionSingleItem.subscription.createdDate);
        subscriptionSingleItem.subscription.adjSubscriptionStartDate = UtilityLibrary.getIADDateTime(subscriptionSingleItem.subscription.subscriptionStartDate);
        subscriptionSingleItem.subscription.adjSubscriptionEndDate = UtilityLibrary.getIADDateTime(subscriptionSingleItem.subscription.subscriptionEndDate);

    }

    public Object putSubscriptionByOrderItemId(String customerId , String orderItemId, Boolean isPartialRefund , Double refundAmount, String subscriptionEndDate , String note)
    {
        String calloutURL = (APItoWrapper.get(PUTORDERSUBSCRIPTIONBYORDERITEMID).endPointConfig.link__c);

        IADContractBeans.IADUpdateOrderSubscription requestBean = new IADContractBeans.IADUpdateOrderSubscription();
      
        requestBean.customerId = Integer.valueOf(customerId);
        requestBean.orderItemId = Integer.valueOf(orderItemId);
        requestBean.isPartialRefund = isPartialRefund;
        if(isPartialRefund)
            requestBean.refundAmount = refundAmount;
        requestBean.updatedBy = UtilityLibrary.generateUpdatedBy();
        requestBean.note = note;
        requestBean.subscriptionEndDate = subscriptionEndDate;
        //if(subscriptionSingleItem.subscription.isRA)
        //{
            requestBean.actionType = 85;//Other.For now just pass Other
        //}
        //else
        //{
          //  requestBean.actionType = 0;
        //}    

        System.debug('Request Man '+requestBean);
        APItoWrapper.get(PUTORDERSUBSCRIPTIONBYORDERITEMID).setInfo(APIRequestResponseWrapper.ORDERITEM, orderItemId);
        Object continuationObject = makeRequest(calloutURL, PUTORDERSUBSCRIPTIONBYORDERITEMID , JSON.serialize(requestBean));
        if(!APItoWrapper.get(PUTORDERSUBSCRIPTIONBYORDERITEMID).isAsync)
        {
            populatePutOrderSubscriptionByOrderItemId();
        }
        return continuationObject;

    }

    public void populatePutOrderSubscriptionByOrderItemId()
    {
        isCancelSuccess = false;

        try
        {
            initHTTPResponse(PUTORDERSUBSCRIPTIONBYORDERITEMID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(PUTORDERSUBSCRIPTIONBYORDERITEMID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    
                    renewalOrderId = null;
                    IADContractBeans.IADOrderItemResponse  deserializedResponse = (IADContractBeans.IADOrderItemResponse) JSON.deserialize(theResponse.responseData , IADContractBeans.IADOrderItemResponse.class);
                    theResponse.resultObjects = new List<Object>{deserializedResponse };//one element list
                    
                    if(deserializedResponse != null)
                    {
                        if(deserializedResponse.orderItem != null)
                        {
                            IADContractbeans.IADOrderItem theItem = deSerializedResponse.orderItem;
                            renewalOrderId = theItem.orderId;
                            isCancelSuccess = true;
                            populateSuccessMessage('Successfully Cancelled');
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
            populateErrorMessage('Failed Processing response + ' + theException.getStackTraceString());
        }
    }

    public void selectRenewalTerm()
    {

    }

    public Object populateProratedRefund(String orderItemId)
    {
        String calloutURL = (APItoWrapper.get(GETPRORATEDREFUNDBYORDERITEMID).endPointConfig.link__c);
        calloutURL = calloutURL.replace('{orderItemId}', orderItemId);

        APItoWrapper.get(GETPRORATEDREFUNDBYORDERITEMID).setInfo(APIRequestResponseWrapper.ORDERITEM, orderItemId);
        Object continuationObject = makeRequest(calloutURL, GETPRORATEDREFUNDBYORDERITEMID , '');
        if(!APItoWrapper.get(GETPRORATEDREFUNDBYORDERITEMID).isAsync)
        {
            processProratedRefund();
        }
        return continuationObject;

    }

    public void processProratedRefund()
    {
        isAllowedCancel = false;
        try
        {
            initHTTPResponse(GETPRORATEDREFUNDBYORDERITEMID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(GETPRORATEDREFUNDBYORDERITEMID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                   
                    dayToProRatedAmount = new Map<String,String>();
                    IADContractBeans.IADProRatedRefundWrapper  deserializedResponse = (IADContractBeans.IADProRatedRefundWrapper) JSON.deserialize(theResponse.responseData , IADContractBeans.IADProRatedRefundWrapper.class);
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
                    populateNullErrorMessage(theResponse);
                }
            }
            else
            {
                if(theResponse.statusCode == '404')
                {
                     populateErrorMessage('Not Applicable for Partial Refund');
                }
                else
                {
                    populateErrorMessage(theResponse);
                }
            }
        }
        catch(Exception theException)
        {
            populateErrorMessage('Failed Pulling Prorated Refund + ' + theException.getStackTraceString());
        }
    }



}