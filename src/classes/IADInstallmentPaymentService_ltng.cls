public class IADInstallmentPaymentService_ltng extends IADServiceBase_ltng
{
    public final static String GETPAYMENTSBYORDERID = 'GetPaymentsByOrderId'; 
    public final static String GETPROFILESBYUSERID = 'GetProfilesByUserId';
    public final static String GETSTORECREDITSBYCUSTOMERID = 'GetStoreCreditsByCustomerId';
    public final static String POSTPAYMENT = 'PostPayment';
    public final static String POSTPAYMENTFORINSTALLMENT = 'PostPaymentForInstallment';
    public final static String POSTREFUNDBYORDERID = 'PostRefundByOrderId';
    public final static String POSTREFUNDSTORECREDITBYORDERID = 'PostRefundStoreCreditByOrderId';
    public final static String POSTPAYMENTBYSTORECREDITID = 'PostPaymentByStoreCreditId';
    public final static String PUTORDERPAYMENTSTATUSBYORDERID = 'PutOrderPaymentStatusByOrderId';
    public final static String POSTREFUNDSTORECREDITTOCARD = 'PostRefundStoreCreditToCard';
    public final static String POSTREFUNDBYMANUALCHECK = 'PostRefundByManualcheck';
    
    public final static String POSTPAYMENTBYMANUALCHECK ='PostPaymentByManualcheck';
    public final static String POSTREFUNDINSTALLMENT ='PostRefundByInstallment';
    public final static String POSTREFUNDSTORECREDITTOMANUALCHECK = 'PostRefundStoreCreditToManualCheck';
    
    @AuraEnabled public static List<IADContractBeans_ltng.IADPaymentProfileBean> profiles{get;set;}
    @AuraEnabled public static List<IADContractBeans_ltng.IADPaymentProfileBean> allProfiles{get;set;}
    @AuraEnabled public static Boolean hasPaymentProfiles {get;set;}
    @AuraEnabled public static Boolean hasStoreCredit{get;set;}
    @AuraEnabled public static String orderId{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADStoreCredit storeCredit{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADPaymentBean thePayment{get;set;}
    
    @AuraEnabled public static Boolean hasPayments{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADPaymentBeanWrapper payment{get;set;}
    
    @AuraEnabled public static List<IADMessage_ltng> iadServiceMessages{get;set;}
    
    @AuraEnabled public static String customerId{get;set;}
    
    public IADInstallmentPaymentService_ltng()
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
        endpoints.add(GETSTORECREDITSBYCUSTOMERID);
        endpoints.add(GETPROFILESBYUSERID);
        endpoints.add(GETPAYMENTSBYORDERID);
        endpoints.add(POSTREFUNDBYMANUALCHECK);
        endpoints.add(POSTPAYMENTBYMANUALCHECK);
        endpoints.add(POSTREFUNDINSTALLMENT);
        endpoints.add(POSTREFUNDSTORECREDITTOMANUALCHECK);

        initEndpoints(endpoints);
        hasPayments = false;
        hasStoreCredit = false;
        hasPaymentProfiles = false;
        profiles = new List<IADContractBeans_ltng.IADPaymentProfileBean>();
        allProfiles =  new List<IADContractBeans_ltng.IADPaymentProfileBean>();
        iadServiceMessages = new List<IADMessage_ltng>();
        payment = new IADContractBeans_ltng.IADPaymentBeanWrapper();
    }
    
    public static void postPayment(IADContractBeans_ltng.IADMakePaymentBean paymentbean)
    {
        system.debug('inside postPayment: service class: ');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTPAYMENT).endPointConfig.link__c;
        system.debug('inside postPayment: calloutURL '+calloutURL);
        IADServiceBase_ltng.APItoWrapper.get(POSTPAYMENT).setInfo(APIRequestResponseWrapper_ltng.ORDER, paymentbean.orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTPAYMENT, JSON.serialize(paymentbean));
    }
     public static void postPaymentManual(IADContractBeans_ltng.IADManualCheckPayment paymentbean ,string orderid)
    {
        system.debug('inside postPayment: manual  service class: ');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTPAYMENTBYMANUALCHECK).endPointConfig.link__c.replace('{orderId}',orderid);
        system.debug('inside postPayment: calloutURL '+calloutURL);
        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTPAYMENTBYMANUALCHECK, JSON.serialize(paymentbean));
    }
      public static void postRefundInstallment(string payload ,string orderid)
    {
        system.debug('inside postPayment: manual  service class: ');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDINSTALLMENT).endPointConfig.link__c.replace('{orderId}',orderid);
        system.debug('inside postPayment: calloutURL '+calloutURL);
        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTREFUNDINSTALLMENT, payload);
    }
    
    public static void populatePayments()
    {
        try
        {
            system.debug('inside populatePayments: service class');
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(POSTPAYMENT);
            
            system.debug('inside populatePayments: service class: response '+response);
            
            thePayment = null;
            if (response.responseData != null)
            {
                if (response.checkIsValidResponse())
                {
                    IADContractBeans_ltng.IADPaymentBean deSerializedpayment = (IADContractBeans_ltng.IADPaymentBean) JSON.deserialize(response.responseData, IADContractBeans_ltng.IADPaymentBean.class);

                    if (deSerializedpayment != null)
                    {
                        deSerializedpayment.adjCreationDate = UtilityLibrary.parseIADDateTime(deSerializedpayment.creationDate);
                        deSerializedpayment.adjStatusDate = UtilityLibrary.parseIADDateTime(deSerializedpayment.statusDate);
                        thePayment = deSerializedpayment;
                        response.resultObjects = new List<Object>{deSerializedpayment};

                        String theStatus = IADPaymentTransaction.statusMap.get(thePayment.transactionStatus);
                        system.debug('theStatus ---->'+theStatus);
                        if(theStatus == 'Declined' || theStatus == 'Error'){
                            IADServiceBase_ltng.populateErrorMessage('Payment status: ' + theStatus);
                            iadServiceMessages = IADServiceBase_ltng.iadMessages;
                        }
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(response);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(response);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    public static void postPaymentForInstallment(IADContractBeans_ltng.IADMakePaymentInstallmentBean paymentbean)
    {
        system.debug('ready to post payment for installment');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTPAYMENTFORINSTALLMENT).endPointConfig.link__c;
        IADServiceBase_ltng.APItoWrapper.get(POSTPAYMENTFORINSTALLMENT).setInfo(APIRequestResponseWrapper_Ltng.ORDER, paymentbean.orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTPAYMENTFORINSTALLMENT, JSON.serialize(paymentbean));
    }
    
    public static void populatePaymentsForInstallment()
    {
        try
        {
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(POSTPAYMENTFORINSTALLMENT);
            thePayment = null;
            if (response.responseData != null)
            {
                if (response.checkIsValidResponse())
                {
                    IADContractBeans_ltng.IADPaymentBean deSerializedpayment = (IADContractBeans_ltng.IADPaymentBean) JSON.deserialize(response.responseData, IADContractBeans_ltng.IADPaymentBean.class);
                    system.debug('Deserialized installment payment response------>');
                    system.debug(deSerializedpayment);
                    if (deSerializedpayment != null)
                    {
                        deSerializedpayment.adjCreationDate = UtilityLibrary.parseIADDateTime(deSerializedpayment.creationDate);
                        deSerializedpayment.adjStatusDate = UtilityLibrary.parseIADDateTime(deSerializedpayment.statusDate);
                        thePayment = deSerializedpayment;
                        response.resultObjects = new List<Object>{deSerializedpayment};

                        String theStatus = IADPaymentTransaction.statusMap.get(thePayment.transactionStatus);
                        if(theStatus == 'Declined' || theStatus == 'Error'){
                            IADServiceBase_ltng.populateErrorMessage('Payment status: ' + theStatus);
                            iadServiceMessages = IADServiceBase_ltng.iadMessages;
                            IADInstallmentPaymentController_ltng.isPaymentProcessed = false;
                        }
                    }

                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(response);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(response);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void postRefund(String payload, String orderId)
    {
        system.debug('------process refund-----');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDBYORDERID).endPointConfig.link__c;
        //IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTREFUNDBYORDERID, payload);
    }
   
    //do any manipulation of data as needed
    public static void readProcessRefundResponse()
    {
        APIRequestResponseWrapper_ltng refundRequestResponse = IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDBYORDERID);
        system.debug(refundRequestResponse);
        try
        {
            if (refundRequestResponse.responseData != null)
            {
                if (refundRequestResponse.checkIsValidResponse())
                {

                    IADContractBeans_ltng.IADRefundBeanWrapper deSerializedpayment = (IADContractBeans_ltng.IADRefundBeanWrapper) JSON.deserialize(refundRequestResponse.responseData, IADContractBeans_ltng.IADRefundBeanWrapper.class);
                    refundRequestResponse.resultObjects = new List<Object>{deSerializedpayment};
                    String theStatus = IADPaymentTransaction.statusMap.get(deSerializedpayment.refundDetails.transactionStatus);
                    if(theStatus == 'Declined' || theStatus == 'Error'){
                        IADServiceBase_ltng.populateErrorMessage('Payment status: ' + theStatus + '. Please try another transaction for refund.');
                        iadServiceMessages = IADServiceBase_ltng.iadMessages;
                    }

                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(refundRequestResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(refundRequestResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }

    public static void postRefundByStoreCredit(String payload, String orderId)
    {
        system.debug('------process refund-----');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDSTORECREDITBYORDERID).endPointConfig.link__c;
        //IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDSTORECREDITBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTREFUNDSTORECREDITBYORDERID, payload);
    }

    //do any manipulation of data as needed
    public static void readProcessRefundStoreCreditResponse()
    {
        APIRequestResponseWrapper_ltng refundRequestResponse = IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDSTORECREDITBYORDERID);
        system.debug(refundRequestResponse);
        try
        {
            if (refundRequestResponse.responseData != null)
            {
                if (refundRequestResponse.checkIsValidResponse())
                {
                    IADContractBeans_ltng.IADProcessRefundBean deSerializedpayment = (IADContractBeans_ltng.IADProcessRefundBean) JSON.deserialize(refundRequestResponse.responseData, IADContractBeans_ltng.IADProcessRefundBean.class);
                    refundRequestResponse.resultObjects = new List<Object>{deSerializedpayment};
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(refundRequestResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(refundRequestResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }

    public static void postPaymentByStoreCreditId(IADContractBeans_ltng.IADMakePaymentStoreCredit paymentbean)
    {
        system.debug('im ready to post payment by credit');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTPAYMENTBYSTORECREDITID).endPointConfig.link__c;
        IADServiceBase_ltng.APItoWrapper.get(POSTPAYMENTBYSTORECREDITID).setInfo(APIRequestResponseWrapper.ORDER, paymentbean.orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTPAYMENTBYSTORECREDITID, JSON.serialize(paymentbean));
    }
    
    public static void populateStoreCreditResponse()
    {
        try
        {
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(POSTPAYMENTBYSTORECREDITID);

            if (response.responseData != null)
            {
                if (response.checkIsValidResponse())
                {
                    system.debug('response ' + response.responseData);

                    IADContractBeans_ltng.IADMakePaymentStoreCreditResponse deSerializedpayment = (IADContractBeans_ltng.IADMakePaymentStoreCreditResponse) JSON.deserialize(response.responseData, IADContractBeans_ltng.IADMakePaymentStoreCreditResponse.class);

                    response.resultObjects = new List<Object>{deSerializedpayment};
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(response);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(response);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void postRefundStoreCreditToCard(String payload)
    {
        system.debug('------process refund-----postRefundStoreCreditToCard');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDSTORECREDITTOCARD).endPointConfig.link__c;
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTREFUNDSTORECREDITTOCARD, payload);
    }

    public static void readProcessRefundStoreCreditToCardResponse()
    {
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDSTORECREDITTOCARD);

        try
        {
            if (response.responseData != null)
            {
                if (response.checkIsValidResponse())
                {
                    system.debug('response.responseData ' + response.responseData);
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(response);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(response);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void postManualCheckRefund(String payload , string orderid)
    {
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDBYMANUALCHECK).endPointConfig.link__c.replace('{orderId}',orderid);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTREFUNDBYMANUALCHECK, payload);
    }
    
    public static void readProcessRefundManualCheck()
    {
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDBYMANUALCHECK);

        try
        {
            if (response.responseData != null)
            {
                if (response.checkIsValidResponse())
                {
                    system.debug('response.responseData ' + response.responseData);
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(response);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(response);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void postRefundStoreCreditToManualCheck(String payload)
    {
        system.debug('------process refund-----postRefundStoreCreditToManualCheck');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDSTORECREDITTOMANUALCHECK).endPointConfig.link__c;
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTREFUNDSTORECREDITTOMANUALCHECK, payload);
    }

    public static void readProcessRefundStoreCreditToMCResponse()
    {
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(POSTREFUNDSTORECREDITTOMANUALCHECK);

        try
        {
            if (response.responseData != null)
            {
                if (response.checkIsValidResponse())
                {
                    system.debug('response.responseData ' + response.responseData);
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(response);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(response);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void getStoreCreditsByCustomerId(String customerId) 
    {
        system.debug('inside getStoreCreditsByCustomerId: service class');
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETSTORECREDITSBYCUSTOMERID).endPointConfig.link__c).replace('{customerId}',customerId);
        system.debug('inside getStoreCreditsByCustomerId: calloutURL: '+calloutURL);
        IADServiceBase_ltng.APItoWrapper.get(GETSTORECREDITSBYCUSTOMERID).setInfo(APIRequestResponseWrapper_ltng.CUSTOMER, customerId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETSTORECREDITSBYCUSTOMERID, '');
    }

    public static void populateStoreCredits()
    {
        try
        {    
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETSTORECREDITSBYCUSTOMERID);
            system.debug('theResponse: '+theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null && theResponse.responseData!='') //Only check this if you need the response body
                {
                    system.debug('theResponse.responseData ' + theResponse.responseData);
                    IADContractBeans_ltng.IADStoreCredit deSerializedResponse = (IADContractBeans_ltng.IADStoreCredit) System.JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADStoreCredit.class);
                    theResponse.resultObjects =  new List<Object>{deSerializedResponse};
                        
                    if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        hasStoreCredit = true;
                        storeCredit = ( IADContractBeans_ltng.IADStoreCredit)IADServiceBase_ltng.APItoWrapper.get(GETSTORECREDITSBYCUSTOMERID).resultObjects[0];
                    }
                }
                else if(theResponse.responseData == null || theResponse.responseData=='')
                {
                    hasStoreCredit = false;
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
            //throw new IADException('Failed displaying Store Credits.'+theException.getMessage() , theException);
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        } 
    }
    
    public static void getPaymentProfilesByUserId(String customerId)
    {
        system.debug('ready to getPaymentProfilesByUserId');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETPROFILESBYUSERID).endPointConfig.link__c+customerId;
        system.debug('callout URL: '+calloutURL);
        IADServiceBase_ltng.APItoWrapper.get(GETPROFILESBYUSERID).setInfo(APIRequestResponseWrapper_ltng.CUSTOMER, customerId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETPROFILESBYUSERID, '');
    }
    
    //do any manipulation of data as needed
    public static void populateProfiles()
    {
        system.debug('ready to populate profiles: inside service class');
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(GETPROFILESBYUSERID);
        try
        {
            profiles.clear();
            allProfiles.clear();
            if(response.responseData != null)
            {
                if(response.checkIsValidResponse()) {
                    IADContractBeans_ltng.IADPaymentProfiles deSerializedpayments = (IADContractBeans_ltng.IADPaymentProfiles) JSON.deserialize(response.responseData, IADContractBeans_ltng.IADPaymentProfiles.class);
                    system.debug('deSerializedpayments ' + deSerializedpayments);
                    if (deSerializedpayments != null) {
                        system.debug('deSerializedpayments.paymentProfiles ' + deSerializedpayments.paymentProfiles);
                        response.resultObjects = deSerializedpayments.paymentProfiles;
                        for (IADContractBeans_ltng.IADPaymentProfileBean bean : deSerializedpayments.paymentProfiles) {
                            bean.adjCreationDate = UtilityLibrary.parseIADDateTime(bean.dateCreated);
                            if (bean.isActive){
                                profiles.add(bean);
                            }
                            allProfiles.add(bean);
                        }
                        system.debug('profiles ' + profiles);
                        hasPaymentProfiles = true;
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(response);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(response);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void getPaymentsByOrderId(String orderId) 
    {   
        system.debug('inside getPaymentsByOrderId');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETPAYMENTSBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}',orderId);
        IADServiceBase_ltng.APItoWrapper.get(GETPAYMENTSBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETPAYMENTSBYORDERID, '');
        populateRefundPayments();
    }   
    
    public static void populateRefundPayments()
    {
        system.debug('inside populateRefundPayments');
        try
        {    
            Map<String, String> paymentReasonIdToNameMap = new Map<String, String>();
        	List<IAD_Payment_Reason__c> paymentReasons = new List<IAD_Payment_Reason__c>();
        	paymentReasons = [SELECT ReasonId__c, Reason__c FROM IAD_Payment_Reason__c LIMIT 300];
        	for (IAD_Payment_Reason__c rsn : paymentReasons) {
        		paymentReasonIdToNameMap.put(String.valueOf(rsn.ReasonId__c), rsn.Reason__c);
        	}
        	System.Debug('paymentReasonIdToNameMap size = ' + paymentReasonIdToNameMap.size());
            //initHTTPResponse(GETPAYMENTSBYORDERID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper_ltng paymentRequestResponse = IADServiceBase_ltng.APItoWrapper.get(GETPAYMENTSBYORDERID);
            
            if(paymentRequestResponse.checkIsValidResponse())
            {
                if(paymentRequestResponse.responseData != null)
                {
                    IADContractBeans_ltng.IADPaymentBeanWrapper deserializedResponse = (IADContractBeans_ltng.IADPaymentBeanWrapper) JSON.deserialize(paymentRequestResponse.responseData , IADContractBeans_ltng.IADPaymentBeanWrapper.class);
                    if(deserializedResponse != null)
                    {
                        for(IADContractBeans_ltng.IADPaymentBean thePayment : deSerializedResponse.payments)
                        {
                            thePayment.createdDateTimeInString = UtilityLibrary.getIADDateTime(thePayment.creationDate);//takes String
                            if(IADPaymentTransaction_ltng.typeMap.get(thePayment.transactionType) == 'Payment')
                            {
                                thePayment.iadStatus = IADPaymentTransaction_ltng.statusMap.get(thePayment.transactionStatus);
                            }
                            else if(IADPaymentTransaction.typeMap.get(thePayment.transactionType) == 'Refund')
                            {
                                thePayment.iadStatus = IADPaymentTransaction_ltng.statusMap.get(thePayment.transactionStatus);
                            }
                            if (paymentReasonIdToNameMap.get(thePayment.reasonId) != null) {
                            	thePayment.reason = paymentReasonIdToNameMap.get(thePayment.reasonId);
                            }
                        }
                        paymentRequestResponse.resultObjects = new List<Object>{deserializedResponse};//one element list
                        payment =  (IADContractBeans_ltng.IADPaymentBeanWrapper)paymentRequestResponse.resultObjects[0];
                        
                        if(!payment.payments.isEmpty())
                        {
                            hasPayments = true;
                        }
                    }    
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(paymentRequestResponse);
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(paymentRequestResponse);            
            }
        }
        
        catch(Exception theException)
        {
            //throw new IADException('Failed Displaying Payments '+theException.getMessage() , theException);
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }  
    }
  
}