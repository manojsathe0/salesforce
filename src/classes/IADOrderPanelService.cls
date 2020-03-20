public class IADOrderPanelService extends IADServiceBase
{
    public Boolean hasIncompleteOrders{get;set;}
    //public APIRequestResponseWrapper incompleteOrderResponse{get;set;}
    public final static String GETORDERSBYCUSTOMERID = 'GetOrdersByCustomerId';
    public Set<IADContractBeans.IADOrderBean> theOrders{get;set;}

    public IADOrderPanelService()
    {
        super();
        hasIncompleteOrders = false;
        List <String> endpoints = new List <String> ();
        endpoints.add(GETORDERSBYCUSTOMERID);
        initEndpoints(endpoints);
    }
    public Object getOrdersByCustomerId(String custId)
    {
        String calloutURL = APItoWrapper.get(GETORDERSBYCUSTOMERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{customerId}',custId);
        APItoWrapper.get(GETORDERSBYCUSTOMERID).setInfo(APIRequestResponseWrapper.CUSTOMER, custId);
        Object continuationObject = makeRequest(calloutURL, GETORDERSBYCUSTOMERID, '');

        return continuationObject;
    }
    public void populateOrders()
    {

        try
        {
            initHTTPResponse(GETORDERSBYCUSTOMERID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper response = APItoWrapper.get(GETORDERSBYCUSTOMERID);
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null)
                {
                    IADContractBeans.IADOrdersBean deserializedResponse = (IADContractBeans.IADOrdersBean) JSON.deserialize(response.responseData , IADContractBeans.IADOrdersBean.class);
                    if(deserializedResponse != null)
                    {

                        system.debug('deserializedResponse ' + deserializedResponse);

                        theOrders = new Set<IADContractBeans.IADOrderBean>();

                        for(IADContractBeans.IADOrderGroup theGroup : deserializedResponse.orderGroups)
                        {
                            theOrders.addAll(theGroup.orders);
                            for(IADContractbeans.IADOrderBean theOrder : theOrders)
                            {
                                for(IADContractbeans.IADOrderItem theOrderItemWrapper : theOrder.orderItems)
                                {
                                    if((theOrderItemWrapper.productConfiguration.productTypeId == '2' || theOrderItemWrapper.productConfiguration.productTypeId == '12'
                                            || theOrderItemWrapper.productConfiguration.productTypeId == '13' || theOrderItemWrapper.productConfiguration.productTypeId == '10'
                                            || theOrderItemWrapper.productConfiguration.productTypeId == '9'))
                                    {
                                        if(theOrder.productName == null)
                                            theOrder.productName = theOrderItemWrapper.productConfiguration.productComponent.displayNameOnBill;
                                    }
                                }
                                theOrder.dateCreatedDatetime = UtilityLibrary.parseIADDatetime(theOrder.dateCreated);
                                theOrder.paymentStatusName = IADPaymentTransaction.orderStatusMap.get(Integer.valueOf(theOrder.paymentStatus));
                                system.debug('paymentStatusName ' + theOrder.paymentStatusName);
                            }
                        }

                        response.resultObjects = new List<Object>{deserializedResponse};
                    }

                }
                else
                {
                    populateNullErrorMessage(response);
                }

            }
            else
            {
                populateErrorMessage(response);
            }


        }
        catch(Exception theException)
        {
            throw new IADException('Failed Displaying Orders '+theException.getMessage() , theException);
        }
    }
   /*
   public Object getIncompleteOrders(String theCustId) 
   {
         
        IADApiGeeIntegrationWorker getIncompleteOrdersList = new IADApiGeeIntegrationWorker();
        system.debug('Req Payload' + getIncompleteOrdersList.reqPayload);
        getIncompleteOrdersList.endPoint = (incompleteOrderResponse.endPointConfig.link__c).replace('{customerId}',theCustId);
        Continuation continuationObject; 
        if(incompleteOrderResponse.IsAsync)
        {
            continuationObject =  new Continuation(40);
            getIncompleteOrdersList.callApiGeeAsync(continuationObject , incompleteOrderResponse);
        }
        else
        {
            getIncompleteOrdersList.callApiGee(incompleteOrderResponse);
            populateIncompleteOrders();

        }        
        return continuationObject;
   }

   public void populateIncompleteOrders()
   {
         try
         {    
              system.debug(incompleteOrderResponse);
              system.debug(incompleteOrderResponse.responseData);
             if(incompleteOrderResponse.responseData != null)
             {
                 if(incompleteOrderResponse.checkIsValidResponse())
                 {

                     IADContractBeans.IncompleteOrdersBean deSerializedOrders = (IADContractBeans.IncompleteOrdersBean) JSON.deserialize(incompleteOrderResponse.responseData , IADContractBeans.IncompleteOrdersBean.class);
                     
                     
                     incompleteOrderResponse.resultObjects = new List<Object>{deSerializedOrders};
                     if(incompleteOrderResponse.resultObjects != null && !incompleteOrderResponse.resultObjects.isEmpty())
                     {
                        hasIncompleteOrders = true;
                        
                     }
                     else
                         hasIncompleteOrders = false;
                 }
                 else
                 {
                       iadMessages.add(IADMessageFactory.createMessage('error' , 'Invalid Response. Response Code : '+incompleteOrderResponse.statusCode + ' Message Body :  '+incompleteOrderResponse.errorMessage));             }
             }
             else
             {
                 iadMessages.add(IADMessageFactory.createMessage('error' , 'Null Response. Response Code : '+incompleteOrderResponse.statusCode));             
             }
             system.debug(hasIncompleteOrders);
         }
         
         catch(Exception theException)
         {
             throw new IADException('Failed Displaying Incomplete Orders '+theException.getMessage() , theException);
         }  
  }
  */
}