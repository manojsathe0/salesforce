public class IADInstallmentService_Ltng extends IADServiceBase_ltng
{
    public final static String GETINSTALLMENTBYINSTALLMENTID = 'GetInstallmentByInstallmentId';
    public final static String GETINSTALLMENTSBYORDERID = 'GetInstallmentsByOrderId';
    public final static String PUTUPDATEINSTALLMENTBYINSTALLMENTID = 'PutUpdateInstallmentByInstallmentId';
    
    @AuraEnabled public static Boolean hasInstallment{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADInstallmentsWrapper theInstallmentsWrapper{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADInstallmentWrapper theInstallmentWrapper{get;set;}
    @AuraEnabled public static Boolean isInstallmentLoaded{get;set;}
    
    @AuraEnabled public static List<IADMessage_ltng> iadServiceMessages{get;set;}
    
    public IADInstallmentService_Ltng()
    {
        super();
        List <String> endpoints = new List <String>();
        endpoints.add(GETINSTALLMENTBYINSTALLMENTID);
        endpoints.add(GETINSTALLMENTSBYORDERID);
        endpoints.add(PUTUPDATEINSTALLMENTBYINSTALLMENTID);
        initEndpoints(endpoints);
        hasInstallment = false;
        isInstallmentLoaded = false;
    }
    
    public  static void getInstallmentByInstallmentId(String installmentId)
    {
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETINSTALLMENTBYINSTALLMENTID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{installmentId}', installmentId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETINSTALLMENTBYINSTALLMENTID, '');
        populateInstallment();
    }
    
    public static  void populateInstallment()
    {
        try
        {
            //initHTTPResponse(GETINSTALLMENTBYINSTALLMENTID);
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(GETINSTALLMENTBYINSTALLMENTID);
            
            if (response.checkIsValidResponse())
            {
                if(response.responseData != null)
                {
                    IADContractBeans_ltng.IADInstallmentWrapper deserialzedInstallments =  (IADContractBeans_ltng.IADInstallmentWrapper) JSON.deserialize(response.responseData, IADContractBeans_ltng.IADInstallmentWrapper.class);
                    
                    theInstallmentWrapper = deserialzedInstallments;
                    IADContractBeans_ltng.IADInstallmentBean loopObj = deserialzedInstallments.installment;
                    
                    if(loopObj.paymentDate != null){
                        loopObj.adjPaymentDateInString = UtilityLibrary.getIADDateTime(loopObj.paymentDate);
                    }
                    
                    if(loopObj.dueDate != null){
                        loopObj.adjDueDateInString = UtilityLibrary.getIADDateTime(loopObj.dueDate);
                    }
                    
                    system.debug('(loopObj.dateCreated ' + loopObj.dateCreated);
                    loopObj.adjCreationDateInString = UtilityLibrary.getIADDateTime(loopObj.dateCreated);
                    loopObj.status = IADPaymentTransaction.installmentBillStatusMap.get(loopObj.installmentBillStatus);
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
    
    public static void getInstallmentsByOrderId(String orderId)
    {
        system.debug('inside getInstallmentsByOrderId');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETINSTALLMENTSBYORDERID).endPointConfig.link__c;
        system.debug('calloutURL: '+calloutURL);
        calloutURL = calloutURL.replace('{orderId}',  orderId);
        system.debug(calloutURL);
        IADServiceBase_ltng.APItoWrapper.get(GETINSTALLMENTSBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETINSTALLMENTSBYORDERID, '');
        populateInstallments();
    }
    
    public static void populateInstallments()
    {
        try
        {
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(GETINSTALLMENTSBYORDERID);
            
            if (response.checkIsValidResponse())
            {
                if(response.responseData != null)
                {
                    IADContractBeans_ltng.IADInstallmentsWrapper deserialzedInstallments =  (IADContractBeans_ltng.IADInstallmentsWrapper) JSON.deserialize(response.responseData, IADContractBeans_ltng.IADInstallmentsWrapper.class);
                    
                    theInstallmentsWrapper = deserialzedInstallments;
                    
                    for(IADContractBeans_ltng.IADInstallmentBean loopObj : deserialzedInstallments.installments)
                    {
                        hasInstallment = true;
                        if(loopObj.paymentDate != null){
                            loopObj.adjPaymentDateInString = UtilityLibrary.getIADDateTime(loopObj.paymentDate);
                        }
                        
                        if(loopObj.dueDate != null){
                            loopObj.adjDueDateInString = UtilityLibrary.getIADDateTime(loopObj.dueDate);
                        }
                        loopObj.adjCreationDateInString = UtilityLibrary.getIADDateTime(loopObj.dateCreated);
                        isInstallmentLoaded = true;
                    }
                    response.resultObjects = new List<Object>{deserialzedInstallments};
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(response);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                if(!(response.statusCode=='404' && response.errorMessage == 'Not Found'))
                {
                    hasInstallment = false;
                    IADServiceBase_ltng.populateErrorMessage(response);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void putInstallmentByInstallmentId(String body, String installmentId)
    {
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(PUTUPDATEINSTALLMENTBYINSTALLMENTID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{installmentId}', installmentId);
        //Object continuationObject = makeRequest(calloutURL, PUTUPDATEINSTALLMENTBYINSTALLMENTID, body);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, PUTUPDATEINSTALLMENTBYINSTALLMENTID, body);
        populateInstallmentUpdateReponse();
    }
    
    //do any manipulation of data as needed
    public static void  populateInstallmentUpdateReponse()
    {
        
        try
        {
            //initHTTPResponse(PUTUPDATEINSTALLMENTBYINSTALLMENTID);
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(PUTUPDATEINSTALLMENTBYINSTALLMENTID);
            system.debug('response' + response);
            if (response.checkIsValidResponse()) 
            {
                if (response.responseData != null)
                {
                    
                    IADContractBeans_ltng.IADInstallmentWrapper deserializedInstallment = (IADContractBeans_ltng.IADInstallmentWrapper) JSON.deserialize(response.responseData, IADContractBeans_ltng.IADInstallmentWrapper.class);
                    
                    system.debug('deserializedInstallment ' + deserializedInstallment);
                    if (deserializedInstallment != null)
                    {
                        IADServiceBase_ltng.populateSuccessMessage('Installment Successfully Updated.');
                        iadServiceMessages = IADServiceBase_ltng.iadMessages;
                    }
                    response.resultObjects = new List<Object>{deserializedInstallment};
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
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public IADContractBeans_ltng.IADInstallmentsWrapper getInstallments()
    {
        return theInstallmentsWrapper;
    }
}