public with sharing class IADPromoCodeService extends IADServiceBase
{
    public final static String POSTCANCELPROMOCODEBYORDERID = 'PostCancelPromoCodeByOrderId';
    public final static String GETPROMOCODESBYORDERID = 'GetPromoCodesByorderId';
    public final static String POSTAPPLYPROMOCODEBYORDERID = 'PostApplyPromoCodeByOrderId';
    public final static String GETVALIDATEPROMOCODEBYORDERID = 'GetValidatePromoCodeByPromoCode';

    public String currentPromoCode{get;set;}
    public Decimal currentAmount{get;set;}

    public Boolean hasPromoCode{get;set;}
    public Boolean isPromoCodeApplied{get;set;}
    public Boolean isPromoCodeCancelled{get;set;}
    public Decimal promoCodeValue{get;set;}

    public IADPromoCodeService() {
        super();
        List <String> endpoints = new List <String>();
        endpoints.add(POSTCANCELPROMOCODEBYORDERID);
        endpoints.add(GETPROMOCODESBYORDERID);
        endpoints.add(POSTAPPLYPROMOCODEBYORDERID);
        endpoints.add(GETVALIDATEPROMOCODEBYORDERID);

        initEndpoints(endpoints);
        hasPromoCode = false;
        isPromoCodeApplied = false;
        isPromoCodeCancelled = false;
       

    }

    public Object applyPromoCode(String orderId , String promoCode , String comments)
    {
        String calloutURL = APItoWrapper.get(POSTAPPLYPROMOCODEBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        String  requestBody = '{"promoCode":"'+promoCode+'","createdBy":"'+UtilityLibrary.generateUpdatedBy()+'","comments":"'+comments+'"}';
        APItoWrapper.get(POSTAPPLYPROMOCODEBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        Object continuationObject = makeRequest(calloutURL, POSTAPPLYPROMOCODEBYORDERID , requestBody);
        if(!APItoWrapper.get(POSTAPPLYPROMOCODEBYORDERID).isAsync)
        {
            processApplyPromoCode();
        }
        return continuationObject;

    }

    public void processApplyPromoCode()
    {
        try
        {
            initHTTPResponse(POSTAPPLYPROMOCODEBYORDERID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(POSTAPPLYPROMOCODEBYORDERID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                   
                     populateSuccessMessage('Promo Code Applied Successfully!!!');
                     isPromoCodeApplied = true;
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
           throw new IADException('Error processing Response ' + theException.getMessage(), theException);
        }
    }

    public Object displayPromoCode(String orderId)
    {
        String calloutURL = APItoWrapper.get(GETPROMOCODESBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        APItoWrapper.get(GETPROMOCODESBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        Object continuationObject = makeRequest(calloutURL, GETPROMOCODESBYORDERID , '');
        if(!APItoWrapper.get(GETPROMOCODESBYORDERID).isAsync)
        {
            processDisplayPromoCode();
        }
        return continuationObject;

    }

    public void processDisplayPromoCode()
    {
        try
        {
            initHTTPResponse(GETPROMOCODESBYORDERID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(GETPROMOCODESBYORDERID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                   
                     IADContractBeans.IADOrderPromoCodeBean deSerializedResponse  = (IADContractBeans.IADOrderPromoCodeBean) JSON.deserialize(theResponse.responseData , IADContractBeans.IADOrderPromoCodeBean.class);
                     if(!deserializedResponse.orderPromoCodes.isEmpty())
                     {
                        for(IADContractBeans.IADOrderPromoCode thePromoCode : deserializedResponse.orderPromoCodes)
                        {
                            if(!thePromoCode.isCancelled)
                            {
                                currentPromoCode = thePromoCode.code;
                                currentAmount = thePromoCode.amount;
                                hasPromoCode = true;
                                break;
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
                if(theResponse.statusCode == '404')
                {
                    hasPromoCode = false;
                }
                else
                {
                    populateErrorMessage(theResponse);
                }
                
            }
        }
        catch(Exception theException)
        {
            throw new IADException('Error processing Response ' + theException.getMessage(), theException);
        }
    }

    public Object checkPromoCode(String orderId , String promoCode)
    {
        String calloutURL = APItoWrapper.get(GETVALIDATEPROMOCODEBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        calloutURL = calloutURL.replace('{promoCode}', promoCode);
        APItoWrapper.get(GETVALIDATEPROMOCODEBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        Object continuationObject = makeRequest(calloutURL, GETVALIDATEPROMOCODEBYORDERID , '');
        if(!APItoWrapper.get(GETVALIDATEPROMOCODEBYORDERID).isAsync)
        {
            processCheckPromoCode();
        }
        return continuationObject;

    }

    public void processCheckPromoCode()
    {
        try
        {
            initHTTPResponse(GETVALIDATEPROMOCODEBYORDERID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(GETVALIDATEPROMOCODEBYORDERID);
            promoCodeValue = null;  
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                   
                   
                    IADContractBeans.IADPromoCode deSerializedResponse  = (IADContractBeans.IADPromoCode) JSON.deserialize(theResponse.responseData , IADContractBeans.IADPromoCode.class);
                    theResponse.resultObjects = new List<Object>{deSerializedResponse};
                    if(!theResponse.resultObjects.isEmpty())
                    {
                        
                        if(deserializedResponse.isValid)
                        {
                            populateSuccessMessage('Promo Code Checked Successfully!!!');
                            promoCodeValue = deserializedResponse.discountAmount;       
                            
                        }
                        else
                        {
                           iadMessages.add(IADMessageFactory.createMessage('error' , 'Promo Code is Invalid or Does Not Apply to This Order!!'));
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
                if(theResponse.statusCode == '404')
                    iadMessages.add(IADMessageFactory.createMessage('error' , 'Promo Code is Invalid or Does Not Apply to This Order!!'));
                else
                    populateErrorMessage(theResponse);
            }
        }
        catch(Exception theException)
        {
            throw new IADException('Error processing Response ' + theException.getMessage(), theException);
        }
    }

    public Object cancelPromoCode(String orderId , String promoCode)
    {
        
        String calloutURL = APItoWrapper.get(POSTCANCELPROMOCODEBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        String  requestBody = '{"promoCode":"'+promoCode+'","updatedBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
        APItoWrapper.get(POSTCANCELPROMOCODEBYORDERID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        Object continuationObject = makeRequest(calloutURL, POSTCANCELPROMOCODEBYORDERID , requestBody);
        if(!APItoWrapper.get(POSTCANCELPROMOCODEBYORDERID).isAsync)
        {
            processCancelPromoCode();
        }
        return continuationObject;

    }

    public void processCancelPromoCode()
    {
        try
        {
            initHTTPResponse(POSTCANCELPROMOCODEBYORDERID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(POSTCANCELPROMOCODEBYORDERID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                   
                     hasPromoCode = false;
                     populateSuccessMessage('Promo Code Cancelled Successfully!!!');
                     isPromoCodeCancelled = true;
                    
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
           throw new IADException('Error processing Response ' + theException.getMessage(), theException);
        }
    }

}