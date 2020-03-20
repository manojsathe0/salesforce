public with sharing class IADPaymentService extends IADServiceBase
{

    public final static String GETPAYMENTBYPAYMENTID = 'GetPaymentByPaymentId';
    public final static String GETREFUNDBYREFUNDID = 'GetRefundByRefundId';
  
    public IADContractBeans.IADPaymentBean thePayment{get;set;}

    public IADPaymentService()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETPAYMENTBYPAYMENTID);
        endpoints.add(GETREFUNDBYREFUNDID);
        initEndpoints(endpoints);
    }
    public Object getPaymentByPaymentId(String paymentId)
    {
        String calloutURL = APItoWrapper.get(GETPAYMENTBYPAYMENTID).endPointConfig.link__c + paymentId;
        Object continuationObject = makeRequest(calloutURL, GETPAYMENTBYPAYMENTID, '');
        return continuationObject;
    }

    public Object getRefundByRefundId(String refundId)
    {
        String calloutURL = APItoWrapper.get(GETREFUNDBYREFUNDID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{id}', refundId);
        Object continuationObject = makeRequest(calloutURL, GETREFUNDBYREFUNDID, '');
        return continuationObject;
    }


    //do any manipulation of data as needed
    public void populatePayments()
    {
        APIRequestResponseWrapper paymentRequestResponse = APItoWrapper.get(GETPAYMENTBYPAYMENTID);
        try
        {
        if (paymentRequestResponse.responseData != null)
            {
                if (paymentRequestResponse.checkIsValidResponse())
                {

                    IADContractBeans.IADPaymentBeanWrapper deSerializedpayment = (IADContractBeans.IADPaymentBeanWrapper) JSON.deserialize(paymentRequestResponse.responseData, IADContractBeans.IADPaymentBeanWrapper.class);

                    thePayment = deSerializedpayment.payments[0];
                    thePayment.createdDateTimeInString = UtilityLibrary.getIADDateTime(thePayment.creationDate);//takes String
                    if(UtilityLibrary.isNotNullOrBlank(thePayment.statusDate))
                        thePayment.statusDateTimeInString = UtilityLibrary.getIADDateTime(thePayment.statusDate);//takes String
                    thePayment.iadStatus = IADPaymentTransaction.statusMap.get(thePayment.transactionStatus);
                    system.debug('thePayment ' + thePayment);

                }
                else
                {
                    populateErrorMessage(paymentRequestResponse);
                    //PageMessageFactory.createFailedMessage('Invalid Response. Response Code : ' + paymentRequestResponse.statusCode + ' Message Body :  ' + paymentRequestResponse.errorMessage);
                }
            }
            else
            {
                populateNullErrorMessage(paymentRequestResponse);
            }
        }
        catch (Exception theException)
        {
            throw new IADException('Failed Displaying Payment ' + theException.getStackTraceString(), theException);
        }
    }

      //do any manipulation of data as needed
    public void populateRefund()
    {
        APIRequestResponseWrapper paymentRequestResponse = APItoWrapper.get(GETREFUNDBYREFUNDID);
        try
        {
        if (paymentRequestResponse.responseData != null)
            {
                if (paymentRequestResponse.checkIsValidResponse())
                {

                    IADContractBeans.IADRefundBeanWrapper deSerializedpayment = (IADContractBeans.IADRefundBeanWrapper) JSON.deserialize(paymentRequestResponse.responseData, IADContractBeans.IADRefundBeanWrapper.class);

                    thePayment = deSerializedpayment.refundDetails;
                    thePayment.paymentTransactionId = thePayment.id;
                    thePayment.createdDateTimeInString = UtilityLibrary.getIADDateTime(thePayment.creationDate);//takes String
                    thePayment.iadStatus = IADPaymentTransaction.statusMap.get(thePayment.status);

                }
                else
                {
                    populateErrorMessage(paymentRequestResponse);
                }
            }
            else
            {
                populateNullErrorMessage(paymentRequestResponse);
            }
        }
        catch (Exception theException)
        {
            throw new IADException('Failed Displaying Refund ' + theException.getStackTraceString(), theException);
        }
    }



}