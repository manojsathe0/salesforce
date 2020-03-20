public class IADInstallmentPaymentService extends IADServiceBase
{
    public final static String POSTPAYMENT = 'PostPayment';
    public final static String POSTPAYMENTFORINSTALLMENT = 'PostPaymentForInstallment';
    public final static String POSTREFUNDBYORDERID = 'PostRefundByOrderId';
    public final static String POSTREFUNDSTORECREDITBYORDERID = 'PostRefundStoreCreditByOrderId';
    public final static String POSTPAYMENTBYSTORECREDITID = 'PostPaymentByStoreCreditId';
    public final static String PUTORDERPAYMENTSTATUSBYORDERID = 'PutOrderPaymentStatusByOrderId';
    public final static String POSTREFUNDSTORECREDITTOCARD = 'PostRefundStoreCreditToCard';

    public IADContractBeans.IADPaymentBean thePayment{get;set;}
    public IADInstallmentPaymentService()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(POSTPAYMENT);
        endpoints.add(POSTPAYMENTFORINSTALLMENT);
        endpoints.add(POSTREFUNDBYORDERID);
        endpoints.add(POSTREFUNDSTORECREDITBYORDERID);
        endpoints.add(POSTPAYMENTBYSTORECREDITID);
        endpoints.add(PUTORDERPAYMENTSTATUSBYORDERID);
        endpoints.add(POSTREFUNDSTORECREDITTOCARD);

        initEndpoints(endpoints);
    }
    public Object postPayment(IADContractBeans.IADMakePaymentBean paymentbean)
    {
        String calloutURL = APItoWrapper.get(POSTPAYMENT).endPointConfig.link__c;
        APItoWrapper.get(POSTPAYMENT).setInfo(APIRequestResponseWrapper.ORDER, paymentbean.orderId);
        Object continuationObject = makeRequest(calloutURL, POSTPAYMENT, JSON.serialize(paymentbean));
        return continuationObject;
    }
    public void populatePayments()
    {
        try
        {
            initHTTPResponse(POSTPAYMENT);

            APIRequestResponseWrapper response = APItoWrapper.get(POSTPAYMENT);
            thePayment = null;
            if (response.responseData != null)
            {
                if (response.checkIsValidResponse())
                {

                    IADContractBeans.IADPaymentBean deSerializedpayment = (IADContractBeans.IADPaymentBean) JSON.deserialize(response.responseData, IADContractBeans.IADPaymentBean.class);

                    if (deSerializedpayment != null)
                    {

                        deSerializedpayment.adjCreationDate = UtilityLibrary.parseIADDateTime(deSerializedpayment.creationDate);
                        deSerializedpayment.adjStatusDate = UtilityLibrary.parseIADDateTime(deSerializedpayment.statusDate);
                        thePayment = deSerializedpayment;
                        response.resultObjects = new List<Object>{deSerializedpayment};

                        String theStatus = IADPaymentTransaction.statusMap.get(thePayment.transactionStatus);
                        if(theStatus == 'Declined' || theStatus == 'Error')
                            populateErrorMessage('Payment status: ' + theStatus);
                    }

                }
                else
                {
                    populateErrorMessage(response);
                }
            }
            else
            {
                populateNullErrorMessage(response);
            }
        }
        catch (Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
    public Object postPaymentForInstallment(IADContractBeans.IADMakePaymentInstallmentBean paymentbean)
    {
        String calloutURL = APItoWrapper.get(POSTPAYMENTFORINSTALLMENT).endPointConfig.link__c;
        APItoWrapper.get(POSTPAYMENTFORINSTALLMENT).setInfo(APIRequestResponseWrapper.ORDER, paymentbean.orderId);
        Object continuationObject = makeRequest(calloutURL, POSTPAYMENTFORINSTALLMENT, JSON.serialize(paymentbean));
        return continuationObject;
    }
    public void populatePaymentsForInstallment()
    {
        try
        {
            initHTTPResponse(POSTPAYMENTFORINSTALLMENT);

            APIRequestResponseWrapper response = APItoWrapper.get(POSTPAYMENTFORINSTALLMENT);
            thePayment = null;
            if (response.responseData != null)
            {
                if (response.checkIsValidResponse())
                {
                    IADContractBeans.IADPaymentBean deSerializedpayment = (IADContractBeans.IADPaymentBean) JSON.deserialize(response.responseData, IADContractBeans.IADPaymentBean.class);

                    if (deSerializedpayment != null)
                    {

                        deSerializedpayment.adjCreationDate = UtilityLibrary.parseIADDateTime(deSerializedpayment.creationDate);
                        deSerializedpayment.adjStatusDate = UtilityLibrary.parseIADDateTime(deSerializedpayment.statusDate);
                        thePayment = deSerializedpayment;
                        response.resultObjects = new List<Object>{deSerializedpayment};

                        String theStatus = IADPaymentTransaction.statusMap.get(thePayment.transactionStatus);
                        if(theStatus == 'Declined' || theStatus == 'Error')
                            populateErrorMessage('Payment status: ' + theStatus);
                    }

                }
                else
                {
                    populateErrorMessage(response);
                }
            }
            else
            {
                populateNullErrorMessage(response);
            }
        }
        catch (Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
    public Object postRefund(String payload )
    {
        system.debug('------process refund-----');
        String calloutURL = APItoWrapper.get(POSTREFUNDBYORDERID).endPointConfig.link__c;
        Object continuationObject = makeRequest(calloutURL, POSTREFUNDBYORDERID, payload);
        return continuationObject;
    }
   
    //do any manipulation of data as needed
    public void readProcessRefundResponse()
    {
        APIRequestResponseWrapper refundRequestResponse = APItoWrapper.get(POSTREFUNDBYORDERID);
        system.debug(refundRequestResponse);
        try
        {
            if (refundRequestResponse.responseData != null)
            {
                if (refundRequestResponse.checkIsValidResponse())
                {

                    IADContractBeans.IADRefundBeanWrapper deSerializedpayment = (IADContractBeans.IADRefundBeanWrapper) JSON.deserialize(refundRequestResponse.responseData, IADContractBeans.IADRefundBeanWrapper.class);
                    refundRequestResponse.resultObjects = new List<Object>{deSerializedpayment};
                    String theStatus = IADPaymentTransaction.statusMap.get(deSerializedpayment.refundDetails.transactionStatus);
                    if(theStatus == 'Declined' || theStatus == 'Error')
                        populateErrorMessage('Payment status: ' + theStatus + '. Please try another transaction for refund.');

                }
                else
                {
                    populateErrorMessage(refundRequestResponse);
                }
            }
            else
            {
                populateNullErrorMessage(refundRequestResponse);

            }
        }
        catch (Exception theException)
        {
            populateErrorMessage(theException);
        }
    }

    public Object postRefundByStoreCredit(String payload )
    {
        system.debug('------process refund-----');
        String calloutURL = APItoWrapper.get(POSTREFUNDSTORECREDITBYORDERID).endPointConfig.link__c;
        Object continuationObject = makeRequest(calloutURL, POSTREFUNDSTORECREDITBYORDERID, payload);
        return continuationObject;
    }

    //do any manipulation of data as needed
    public void readProcessRefundStoreCreditResponse()
    {
        APIRequestResponseWrapper refundRequestResponse = APItoWrapper.get(POSTREFUNDSTORECREDITBYORDERID);
        system.debug(refundRequestResponse);
        try
        {
            if (refundRequestResponse.responseData != null)
            {
                if (refundRequestResponse.checkIsValidResponse())
                {

                    IADContractBeans.IADProcessRefundBean deSerializedpayment = (IADContractBeans.IADProcessRefundBean) JSON.deserialize(refundRequestResponse.responseData, IADContractBeans.IADProcessRefundBean.class);
                    refundRequestResponse.resultObjects = new List<Object>{deSerializedpayment};


                }
                else
                {
                    populateErrorMessage(refundRequestResponse);
                }
            }
            else
            {
                populateNullErrorMessage(refundRequestResponse);

            }
        }
        catch (Exception theException)
        {
            populateErrorMessage(theException);
        }
    }

    public Object postPaymentByStoreCreditId(IADContractBeans.IADMakePaymentStoreCredit paymentbean)
    {
        String calloutURL = APItoWrapper.get(POSTPAYMENTBYSTORECREDITID).endPointConfig.link__c;
        APItoWrapper.get(POSTPAYMENTBYSTORECREDITID).setInfo(APIRequestResponseWrapper.ORDER, paymentbean.orderId);
        Object continuationObject = makeRequest(calloutURL, POSTPAYMENTBYSTORECREDITID, JSON.serialize(paymentbean));
        return continuationObject;
    }
    public void populateStoreCreditResponse()
    {
        try
        {
            initHTTPResponse(POSTPAYMENTBYSTORECREDITID);

            APIRequestResponseWrapper response = APItoWrapper.get(POSTPAYMENTBYSTORECREDITID);

            if (response.responseData != null)
            {
                if (response.checkIsValidResponse())
                {
                    system.debug('response ' + response.responseData);

                    IADContractBeans.IADMakePaymentStoreCreditResponse deSerializedpayment = (IADContractBeans.IADMakePaymentStoreCreditResponse) JSON.deserialize(response.responseData, IADContractBeans.IADMakePaymentStoreCreditResponse.class);

                    response.resultObjects = new List<Object>{deSerializedpayment};
                }
                else
                {
                    populateErrorMessage(response);
                }
            }
            else
            {
                populateNullErrorMessage(response);
            }
        }
        catch (Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
    public Object postRefundStoreCreditToCard(String payload )
    {
        system.debug('------process refund-----');
        String calloutURL = APItoWrapper.get(POSTREFUNDSTORECREDITTOCARD).endPointConfig.link__c;
        Object continuationObject = makeRequest(calloutURL, POSTREFUNDSTORECREDITTOCARD, payload);
        return continuationObject;
    }

    //do any manipulation of data as needed
    public void readProcessRefundStoreCreditToCardResponse()
    {
        APIRequestResponseWrapper response = APItoWrapper.get(POSTREFUNDSTORECREDITTOCARD);

        try
        {
            if (response.responseData != null)
            {
                if (response.checkIsValidResponse())
                {

                    system.debug('response.responseData ' + response.responseData);
//                    IADContractBeans.IADRefundBeanWrapper deSerializedpayment = (IADContractBeans.IADRefundBeanWrapper) JSON.deserialize(response.responseData, IADContractBeans.IADRefundBeanWrapper.class);
//                    response.resultObjects = new List<Object>{deSerializedpayment};
//                    String theStatus = IADPaymentTransaction.statusMap.get(deSerializedpayment.refundDetails.transactionStatus);
//                    if(theStatus == 'Declined' || theStatus == 'Error')
//                        populateErrorMessage('Payment status: ' + theStatus + '. Please try another transaction for refund.');

                }
                else
                {
                    populateErrorMessage(response);
                }
            }
            else
            {
                populateNullErrorMessage(response);

            }
        }
        catch (Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
  
}