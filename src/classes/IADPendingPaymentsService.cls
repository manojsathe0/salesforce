public class IADPendingPaymentsService extends IADServiceBase
{
     
   public Boolean hasPayments{get;set;}
   public IADContractBeans.IADPaymentBeanWrapper payment{get;set;}
   public final static String GETPAYMENTSBYORDERID = 'GetPaymentsByOrderId'; 
   
   public IADPendingPaymentsService()
   {
        super();
        hasPayments = false;
        List <String> endpoints = new List <String> ();
        endpoints.add(GETPAYMENTSBYORDERID);
        initEndpoints(endpoints);
        
   }
   public Object getPaymentsByOrderId(String orderId) 
   {      
               
        String calloutURL = (APItoWrapper.get(GETPAYMENTSBYORDERID).endPointConfig.link__c);
        calloutURL = calloutURL.replace('{orderId}',orderId);
        APItoWrapper.get(GETPAYMENTSBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        Object continuationObject = makeRequest(calloutURL, GETPAYMENTSBYORDERID, '');

        if(!APItoWrapper.get(GETPAYMENTSBYORDERID).isAsync)
        {
            populatePayments();
        }
        return continuationObject;
    }
    
    public Object getPaymentsByOrderId(Object continuationObject, String orderId)
    {
        String calloutURL = (APItoWrapper.get(GETPAYMENTSBYORDERID).endPointConfig.link__c);
        calloutURL = calloutURL.replace('{orderId}',orderId);
        APItoWrapper.get(GETPAYMENTSBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        continuationObject = makeRequestMulti(continuationObject, calloutURL, GETPAYMENTSBYORDERID, '');

        return continuationObject;
    }
    
   
   //do any manipulation of data as needed
   public void populatePayments()
   {
     
     try
     {    
         initHTTPResponse(GETPAYMENTSBYORDERID); //sets the responseData and statusCode on the wrapper
         APIRequestResponseWrapper paymentRequestResponse = APItoWrapper.get(GETPAYMENTSBYORDERID);

         if(paymentRequestResponse.checkIsValidResponse())
         {
             if(paymentRequestResponse.responseData != null)
             {
             
                IADContractBeans.IADPaymentBeanWrapper deserializedResponse = (IADContractBeans.IADPaymentBeanWrapper) JSON.deserialize(paymentRequestResponse.responseData , IADContractBeans.IADPaymentBeanWrapper.class);
                if(deserializedResponse != null)
                {
                    for(IADContractBeans.IADPaymentBean thePayment : deSerializedResponse.payments)
                    {
                        thePayment.createdDateTimeInString = UtilityLibrary.getIADDateTime(thePayment.creationDate);//takes String
                        if(IADPaymentTransaction.typeMap.get(thePayment.transactionType) == 'Payment')
                        {
                            thePayment.iadStatus = IADPaymentTransaction.statusMap.get(thePayment.transactionStatus);

                        
                        }
                        else if(IADPaymentTransaction.typeMap.get(thePayment.transactionType) == 'Refund')
                        {
                            thePayment.iadStatus = IADPaymentTransaction.statusMap.get(thePayment.transactionStatus);
                           
                        }
                    }
                    paymentRequestResponse.resultObjects = new List<Object>{deserializedResponse};//one element list
                    payment =  (IADContractBeans.IADPaymentBeanWrapper)paymentRequestResponse.resultObjects[0];
                    if(!payment.payments.isEmpty())
                    {
                        hasPayments = true;
                    }
                        
                    

                }    
                 
             }
             else
             {
                  populateNullErrorMessage(paymentRequestResponse);
             }
        
         }
         else
         {
             populateErrorMessage(paymentRequestResponse);            
         }
     
     
     }
     
     catch(Exception theException)
     {
         throw new IADException('Failed Displaying Payments '+theException.getMessage() , theException);
     }  
    }
      
  
}