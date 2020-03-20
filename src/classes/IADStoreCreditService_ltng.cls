public with sharing class IADStoreCreditService_ltng extends IADServiceBase_ltng
{
    public final static String GETSTORECREDITSBYSTORECREDITID = 'GetStoreCreditByStoreCreditId';
    public final static String GETSTORECREDITSBYSTORECREDITIDV2 = 'GetStoreCreditByStoreCreditIdV2';
    
    @AuraEnabled public static IADContractBeans_ltng.IADStoreCreditV2 storeCredit{get;set;}
    @AuraEnabled public static List<IADMessage_ltng> exceptions {get;set;}
    
    public IADStoreCreditService_ltng()
    {
        super();
        
        List <String> endpoints = new List <String> ();
        endpoints.add(GETSTORECREDITSBYSTORECREDITID);
        endpoints.add(GETSTORECREDITSBYSTORECREDITIDV2);
        initEndpoints(endpoints);
        
        storeCredit = new IADContractBeans_ltng.IADStoreCreditV2();
    }
    
    public static void  getStoreCreditDetailByStoreCreditId(String storeCreditId) 
    {
        system.debug('im inside getStoreCreditDetailByStoreCreditId-->');
        exceptions = new List<IADMessage_ltng>();
        String calloutURL = ( IADServiceBase_ltng.APItoWrapper.get(GETSTORECREDITSBYSTORECREDITIDV2).endPointConfig.link__c).replace('{storeCreditId}',storeCreditId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETSTORECREDITSBYSTORECREDITIDV2, '');
        
        populateStoreCredit();  
    }
    
    public static void populateStoreCredit()
    {
        try
        {    
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETSTORECREDITSBYSTORECREDITIDV2);
            system.debug('response--->');
            system.debug(theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    IADContractBeans_ltng.IADStoreCreditV2 deSerializedResponse = (IADContractBeans_ltng.IADStoreCreditV2) System.JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADStoreCreditV2.class);
                    theResponse.resultObjects =  new List<Object>{deSerializedResponse};
                        
                    if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty()){
                        storeCredit = ( IADContractBeans_ltng.IADStoreCreditV2)IADServiceBase_ltng.APItoWrapper.get(GETSTORECREDITSBYSTORECREDITIDV2).resultObjects[0];
                        updateDateTime();        
                        for(IADContractBeans_ltng.IADStoreCreditOrderTransactionDetails scTransDetails : storeCredit.storeCredit.storeCreditOrderTransactionDetails ){
                            if(scTransDetails.transactionTypeId == 3){
                                scTransDetails.transactionStatus = IADPaymentTransaction_ltng.statusMap.get(scTransDetails.refundTransactionStatusId);
                            }
                            if(scTransDetails.transactionTypeId == 1){
                                storeCredit.storeCredit.orderId = scTransDetails.orderId;
                            }
                            scTransDetails.adjCreatedDate = UtilityLibrary.getIADDateTime(scTransDetails.createdDate);
                            scTransDetails.amount = -1 * scTransDetails.amount;
                        }
                        system.debug('Store Credit--->');                        
                        system.debug(storeCredit);                        
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    IADStoreCreditService_ltng.exceptions = IADServiceBase_ltng.iadMessages; 
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                IADStoreCreditService_ltng.exceptions = IADServiceBase_ltng.iadMessages; 
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADStoreCreditService_ltng.exceptions = IADServiceBase_ltng.iadMessages;
        } 
    }
    
    public static void updateDateTime()
    {
        storeCredit.storeCredit.adjDateCreated = UtilityLibrary.getIADDateTime(storeCredit.storeCredit.dateCreated);
        storeCredit.storeCredit.adjExpirationDate = UtilityLibrary.getIADDateTime(storeCredit.storeCredit.expriationDate);
        storeCredit.storeCredit.status = IADPaymentTransaction_ltng.storeCreditStatusMap.get(Integer.valueOf(storeCredit.storeCredit.storeCreditStatus));
    }
}