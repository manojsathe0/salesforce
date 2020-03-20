public with sharing class IADPaymentService_ltng extends IADServiceBase_ltng
{

    public final static String GETPAYMENTBYPAYMENTID = 'GetPaymentByPaymentId';
    public final static String GETREFUNDBYREFUNDID = 'GetRefundByRefundId';
  
    public static  IADContractBeans_ltng.IADPaymentBean thePayment{get;set;}

    public IADPaymentService_ltng()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETPAYMENTBYPAYMENTID);
        endpoints.add(GETREFUNDBYREFUNDID);
        initEndpoints(endpoints);
    }
    public static  void  getPaymentByPaymentId(String paymentId)
    {
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETPAYMENTBYPAYMENTID).endPointConfig.link__c + paymentId;
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETPAYMENTBYPAYMENTID, '');
        populatePayments();
        
    }

    public static void  getRefundByRefundId(String refundId)
    {
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETREFUNDBYREFUNDID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{id}', refundId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETREFUNDBYREFUNDID, '');
        populateRefund();
       
    }


    //do any manipulation of data as needed
    public static  void populatePayments()
    {
        APIRequestResponseWrapper_ltng paymentRequestResponse = IADServiceBase_ltng.APItoWrapper.get(GETPAYMENTBYPAYMENTID);
        try
        {
        if (paymentRequestResponse.responseData != null)
            {
                if (paymentRequestResponse.checkIsValidResponse())
                {
                    system.debug('respnse data is  '+paymentRequestResponse.responseData);

                    IADContractBeans_ltng.IADPaymentBeanWrapper deSerializedpayment = (IADContractBeans_ltng.IADPaymentBeanWrapper) JSON.deserialize(paymentRequestResponse.responseData, IADContractBeans_ltng.IADPaymentBeanWrapper.class);

                    thePayment = deSerializedpayment.payments[0];
                    thePayment.createdDateTimeInString = UtilityLibrary.getIADDateTime(thePayment.creationDate);//takes String
                    
                     if(thePayment.createdby.contains('Legalzoom'))
                        {
                           String [] users = new List<String>(); 
                          users=thePayment.createdby.split('\\\\');  
                            thePayment.createdby=users[1];
                        }
                    
                    else
                    {
                      thePayment.createdby='Customer';
                    }
                    if(UtilityLibrary.isNotNullOrBlank(thePayment.statusDate))
                        thePayment.statusDateTimeInString = UtilityLibrary.getIADDateTime(thePayment.statusDate);//takes String
                    thePayment.iadStatus = IADPaymentTransaction.statusMap.get(thePayment.transactionStatus);
                    system.debug('thePayment ' + thePayment);

                }
                else
                {
                     IADServiceBase_ltng.populateErrorMessage(paymentRequestResponse);
                    //PageMessageFactory.createFailedMessage('Invalid Response. Response Code : ' + paymentRequestResponse.statusCode + ' Message Body :  ' + paymentRequestResponse.errorMessage);
                }
            }
            else
            {
                  IADServiceBase_ltng.populateNullErrorMessage(paymentRequestResponse);
            }
        }
        catch (Exception theException)
        {
            throw new IADException('Failed Displaying Payment ' + theException.getStackTraceString(), theException);
        }
    }

      //do any manipulation of data as needed
    public  static void populateRefund()
    {
        APIRequestResponseWrapper_ltng paymentRequestResponse = IADServiceBase_ltng.APItoWrapper.get(GETREFUNDBYREFUNDID);
        try
        {
        if (paymentRequestResponse.responseData != null)
            {
                if (paymentRequestResponse.checkIsValidResponse())
                {

                    IADContractBeans_ltng.IADRefundBeanWrapper deSerializedpayment = (IADContractBeans_ltng.IADRefundBeanWrapper) JSON.deserialize(paymentRequestResponse.responseData, IADContractBeans_ltng.IADRefundBeanWrapper.class);

                    thePayment = deSerializedpayment.refundDetails;
                    thePayment.paymentTransactionId = thePayment.id;
                    thePayment.createdDateTimeInString = UtilityLibrary.getIADDateTime(thePayment.creationDate);//takes String
                    thePayment.iadStatus = IADPaymentTransaction.statusMap.get(thePayment.status);
                       if(thePayment.creatorId.contains('Legalzoom'))
                        {
                           String [] users = new List<String>(); 
                          users=thePayment.creatorId.split('\\\\');  
                            thePayment.createdby=users[1];
                        }
                    
                    else
                    {
                      thePayment.createdby='Customer';
                    }

                }
                else
                {
                      IADServiceBase_ltng.populateErrorMessage(paymentRequestResponse);
                }
            }
            else
            {
                 IADServiceBase_ltng.populateNullErrorMessage(paymentRequestResponse);
            }
        }
        catch (Exception theException)
        {
            throw new IADException('Failed Displaying Refund ' + theException.getStackTraceString(), theException);
        }
    }



}