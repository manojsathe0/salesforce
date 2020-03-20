public with sharing class IADInstallmentService extends IADServiceBase implements IADIServiceClassFactory
{
    public final static String GETINSTALLMENTBYINSTALLMENTID = 'GetInstallmentByInstallmentId';
    public final static String GETINSTALLMENTSBYORDERID = 'GetInstallmentsByOrderId';
    public final static String PUTUPDATEINSTALLMENTBYINSTALLMENTID = 'PutUpdateInstallmentByInstallmentId';
    public Boolean hasInstallment{get;set;}
    public IADContractBeans.IADInstallmentsWrapper theInstallmentsWrapper{get;set;}
    public IADContractBeans.IADInstallmentWrapper theInstallmentWrapper{get;set;}
    public Boolean isInstallmentLoaded{get;set;}
    public IADInstallmentService()
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
    public Object getInstallmentByInstallmentId(String installmentId)
    {
        String calloutURL = APItoWrapper.get(GETINSTALLMENTBYINSTALLMENTID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{installmentId}', installmentId);
        Object continuationObject = makeRequest(calloutURL, GETINSTALLMENTBYINSTALLMENTID, '');
        return continuationObject;
    }
    public void populateInstallment()
    {
         try
        {
            initHTTPResponse(GETINSTALLMENTBYINSTALLMENTID);
            APIRequestResponseWrapper response = APItoWrapper.get(GETINSTALLMENTBYINSTALLMENTID);
       
            if (response.checkIsValidResponse())
            {
                if(response.responseData != null)
                {
                    IADContractBeans.IADInstallmentWrapper deserialzedInstallments =  (IADContractBeans.IADInstallmentWrapper) JSON.deserialize(response.responseData, IADContractBeans.IADInstallmentWrapper.class);
                    
                    theInstallmentWrapper = deserialzedInstallments;
                    IADContractBeans.IADInstallmentBean loopObj = deserialzedInstallments.installment;
                    
                    if(loopObj.paymentDate != null)
                        loopObj.adjPaymentDateInString = UtilityLibrary.getIADDateTime(loopObj.paymentDate);
                    if(loopObj.dueDate != null)
                        loopObj.adjDueDateInString = UtilityLibrary.getIADDateTime(loopObj.dueDate);
                    system.debug('(loopObj.dateCreated ' + loopObj.dateCreated);
                    loopObj.adjCreationDateInString = UtilityLibrary.getIADDateTime(loopObj.dateCreated);
                    loopObj.status = IADPaymentTransaction.installmentBillStatusMap.get(loopObj.installmentBillStatus);
                    

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
        catch (Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
    
    public Object getInstallmentsByOrderId(String orderId)
    {
        //String orderNum = [select name from Order__c where id=: orderId].name;
        String calloutURL = APItoWrapper.get(GETINSTALLMENTSBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}',  orderId);
        APItoWrapper.get(GETINSTALLMENTSBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        Object continuationObject = makeRequest(calloutURL, GETINSTALLMENTSBYORDERID, '');
        return continuationObject;
    }
    //do any manipulation of data as needed
    public void populateInstallments()
    {
       
        try
        {
            initHTTPResponse(GETINSTALLMENTSBYORDERID);
            APIRequestResponseWrapper response = APItoWrapper.get(GETINSTALLMENTSBYORDERID);
       
            if (response.checkIsValidResponse())
            {
                if(response.responseData != null)
                {
                    IADContractBeans.IADInstallmentsWrapper deserialzedInstallments =  (IADContractBeans.IADInstallmentsWrapper) JSON.deserialize(response.responseData, IADContractBeans.IADInstallmentsWrapper.class);
                    
                    theInstallmentsWrapper = deserialzedInstallments;
                    
                    for(IADContractBeans.IADInstallmentBean loopObj : deserialzedInstallments.installments)
                    {
                        
                        hasInstallment = true;
                        if(loopObj.paymentDate != null)
                            loopObj.adjPaymentDateInString = UtilityLibrary.getIADDateTime(loopObj.paymentDate);
                        if(loopObj.dueDate != null)
                            loopObj.adjDueDateInString = UtilityLibrary.getIADDateTime(loopObj.dueDate);

                        loopObj.adjCreationDateInString = UtilityLibrary.getIADDateTime(loopObj.dateCreated);
                        isInstallmentLoaded = true;
                    }

                    response.resultObjects = new List<Object>{deserialzedInstallments};

                }
                else
                {
                    populateNullErrorMessage(response);
                }
            }
            else
            {
                if(!(response.statusCode=='404' && response.errorMessage == 'Not Found'))
                {
                    hasInstallment = false;
                    populateErrorMessage(response);
                }
            }
                
        }
        catch (Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
    public Object putInstallmentByInstallmentId(String body, String installmentId)
    {
        String calloutURL = APItoWrapper.get(PUTUPDATEINSTALLMENTBYINSTALLMENTID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{installmentId}', installmentId);
        Object continuationObject = makeRequest(calloutURL, PUTUPDATEINSTALLMENTBYINSTALLMENTID, body);
        return continuationObject;
    }

    //do any manipulation of data as needed
    public void populateInstallmentUpdateReponse()
    {
        
        try
        {
            initHTTPResponse(PUTUPDATEINSTALLMENTBYINSTALLMENTID);
            APIRequestResponseWrapper response = APItoWrapper.get(PUTUPDATEINSTALLMENTBYINSTALLMENTID);
            system.debug('response' + response);
            if (response.checkIsValidResponse()) 
            {
                if (response.responseData != null)
                {

                    IADContractBeans.IADInstallmentWrapper deserializedInstallment = (IADContractBeans.IADInstallmentWrapper) JSON.deserialize(response.responseData, IADContractBeans.IADInstallmentWrapper.class);

                    system.debug('deserializedInstallment ' + deserializedInstallment);
                    if (deserializedInstallment != null)
                    {
                        populateSuccessMessage('Installment Successfully Updated.');
                    }
                    response.resultObjects = new List<Object>{deserializedInstallment};

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
        catch (Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
    public IADContractBeans.IADInstallmentsWrapper getInstallments()
    {
        return theInstallmentsWrapper;
    }
    
}