public class IADPromoCodeService_Ltng extends IADServiceBase_ltng {
    
    public final static String POSTCANCELPROMOCODEBYORDERID = 'PostCancelPromoCodeByOrderId';
    public final static String GETPROMOCODESBYORDERID = 'GetPromoCodesByorderId';
    public final static String POSTAPPLYPROMOCODEBYORDERID = 'PostApplyPromoCodeByOrderId';
    public final static String GETVALIDATEPROMOCODEBYORDERID = 'GetValidatePromoCodeByPromoCode';
    
    @AuraEnabled public static List<IADMessage_ltng> iadServiceMessages{get;set;}
    @AuraEnabled public static Boolean isPromoCodeApplied{get;set;}
    @AuraEnabled public static Boolean isPromoCodeValid{get;set;}
    @AuraEnabled public static Boolean isPromoCodeCancelled{get;set;}
    @AuraEnabled public static Decimal promoCodeValue{get;set;}
    @AuraEnabled public static String currentPromoCode{get;set;}
    @AuraEnabled public static Decimal currentAmount{get;set;}
    @AuraEnabled public static APIRequestResponseWrapper_ltng response{get;set;}
    @AuraEnabled public static Boolean hasPromoCode{get;set;}
    
    public IADPromoCodeService_Ltng() {
        super();
        List <String> endpoints = new List <String>();
        endpoints.add(POSTCANCELPROMOCODEBYORDERID);
        endpoints.add(GETPROMOCODESBYORDERID);
        endpoints.add(POSTAPPLYPROMOCODEBYORDERID);
        endpoints.add(GETVALIDATEPROMOCODEBYORDERID);
        initEndpoints(endpoints);
        isPromoCodeApplied = false;
        hasPromoCode = false;
        isPromoCodeValid = false;
        iadServiceMessages = new List<IADMessage_ltng>();
    }
    
    public static void applyPromoCode(String orderId , String promoCode , String comments) {
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTAPPLYPROMOCODEBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        String  requestBody = '{"promoCode":"'+promoCode+'","createdBy":"'+UtilityLibrary.generateUpdatedBy()+'","comments":"'+comments+'"}';
        
        IADServiceBase_ltng.APItoWrapper.get(POSTAPPLYPROMOCODEBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTAPPLYPROMOCODEBYORDERID, requestBody);
        
        processApplyPromoCode();
    }
    
    public static void processApplyPromoCode() {
        System.Debug('processApplyPromoCode: ');
        try 
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(POSTAPPLYPROMOCODEBYORDERID); 
            System.Debug('theResponse: ' + theResponse);
            if(theResponse.checkIsValidResponse()) {
                System.Debug('valid response: ' + theResponse.checkIsValidResponse());
                if(theResponse.responseData != null) {
                    System.Debug('theResponse.responseData: ' + theResponse.responseData);
                    IADServiceBase_ltng.populateSuccessMessage('Promo Code Applied Successfully!!!');
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                    isPromoCodeApplied = true;
                }
                else {
                    System.Debug('populateNullErrorMessage theResponse: ' + theResponse);
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else {
                System.Debug('populateErrorMessage theResponse: ' + theResponse);
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            //throw new IADException('Error processing Response ' + theException.getMessage(), theException);
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void cancelPromoCode(String orderId , String promoCode) {
        System.Debug('inside cancelPromoCode: ');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTCANCELPROMOCODEBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        String  requestBody = '{"promoCode":"'+promoCode+'","updatedBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
        
        IADServiceBase_ltng.APItoWrapper.get(POSTCANCELPROMOCODEBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTCANCELPROMOCODEBYORDERID, requestBody);
        
        processCancelPromoCode();
    }
    
    public static void processCancelPromoCode() {
        System.Debug('isnide processCancelPromoCode: ');
        try 
        {
            System.Debug('isnide processCancelPromoCode: 2');
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(POSTCANCELPROMOCODEBYORDERID);
            System.Debug('isnide processCancelPromoCode: ' + theResponse);
            System.Debug('theResponse.checkIsValidResponse(): ' + theResponse.checkIsValidResponse());
            if(theResponse.checkIsValidResponse()) 
            {
                if(theResponse.responseData != null) 
                {
                    IADServiceBase_ltng.populateSuccessMessage('Promo Code Cancelled Successfully!!!');
                    response = theResponse;
                    hasPromoCode = false;
                    isPromoCodeCancelled = true;
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
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
            //throw new IADException('Error processing Response ' + theException.getMessage(), theException);
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void checkPromoCode(String orderId , String promoCode) {
        System.Debug('Inside checkPromoCode');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETVALIDATEPROMOCODEBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        calloutURL = calloutURL.replace('{promoCode}', promoCode);
        IADServiceBase_ltng.APItoWrapper.get(GETVALIDATEPROMOCODEBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETVALIDATEPROMOCODEBYORDERID, '');
        
        processCheckPromoCode();
    }
    
    public static void processCheckPromoCode() {
        System.Debug('Inside processCheckPromoCode');
        
        try 
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETVALIDATEPROMOCODEBYORDERID);        	
            System.Debug('theResponse = ' + theResponse);	
            System.Debug('theResponse.checkIsValidResponse(): ' + theResponse.checkIsValidResponse());
            if(theResponse.checkIsValidResponse())             {
                if(theResponse.responseData != null) {
                    IADContractBeans_ltng.IADPromoCode deSerializedResponse  = (IADContractBeans_ltng.IADPromoCode) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADPromoCode.class);
                    theResponse.resultObjects = new List<Object>{deSerializedResponse};
                       
                    if(!theResponse.resultObjects.isEmpty())
                    {
                        if(deserializedResponse.isValid)
                        {
                            system.debug('promo code valid');
                            IADServiceBase_ltng.populateSuccessMessage('Promo Code Checked Successfully!!!');
                            isPromoCodeValid = true;
                            promoCodeValue = deserializedResponse.discountAmount; 
                            iadServiceMessages = IADServiceBase_ltng.iadMessages;
                        }
                        else
                        {
                            system.debug('promo code not valid');
                            IADServiceBase_ltng.iadMessages.add(IADMessageFactory_ltng.createMessage('error' , 'Promo Code is Invalid or Does Not Apply to This Order!!'));
                            iadServiceMessages = IADServiceBase_ltng.iadMessages;
                        }
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                if(theResponse.statusCode == '404') 
                {
                    IADServiceBase_ltng.iadMessages.add(IADMessageFactory_ltng.createMessage('error' , 'Promo Code is Invalid or Does Not Apply to This Order!!'));
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
                else 
                {
                    IADServiceBase_ltng.populateErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
        }
        catch(Exception theException)
        {
            //throw new IADException('Error processing Response ' + theException.getMessage(), theException);
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    
    public static void displayPromoCode(String orderId) {
        System.Debug('Inside displayPromoCode');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETPROMOCODESBYORDERID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderId);
        
        IADServiceBase_ltng.APItoWrapper.get(GETPROMOCODESBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETPROMOCODESBYORDERID, '');
        processDisplayPromoCode();
    }
    
    public static void processDisplayPromoCode() {
        System.Debug('Inside processDisplayPromoCode');
        
        try {
            
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETPROMOCODESBYORDERID);        	
            System.Debug('theResponse = ' + theResponse);
            if(theResponse.checkIsValidResponse())             {
                if(theResponse.responseData != null) {
                    IADContractBeans_ltng.IADOrderPromoCodeBean deSerializedResponse  = (IADContractBeans_ltng.IADOrderPromoCodeBean) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADOrderPromoCodeBean.class);
                    if(!deSerializedResponse.orderPromoCodes.isEmpty()) {
                        for(IADContractBeans_ltng.IADOrderPromoCode thePromoCode : deSerializedResponse.orderPromoCodes) {
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
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                if(theResponse.statusCode == '404') {
                    hasPromoCode = false;
                }
                else {
                    IADServiceBase_ltng.populateErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
        }
        catch(Exception theException)
        {
            //throw new IADException('Error processing Response ' + theException.getMessage(), theException);
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
}