public with sharing class IADStoreCreditController_ltng
{
    public  static String customerId{get;set;}
    
    @AuraEnabled  public static IADStoreCreditService_ltng storeCreditService{get;set;}
    
    @AuraEnabled 
    public static  IADStoreCreditService_ltng  populateStoreCredit(string storeCreditId)
    {
        storeCreditService = new IADStoreCreditService_ltng();
        try
        {
            if(UtilityLibrary.isNotNullOrBlank(storeCreditId))
            {
                IADServiceBase_ltng.initWrapper(IADStoreCreditService_ltng.GETSTORECREDITSBYSTORECREDITIDV2);
                IADStoreCreditService_ltng.getStoreCreditDetailByStoreCreditId(storeCreditId);  
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
        }
        return storeCreditService ;
    }
    /* STORY B-39093 - Changes Starts Here */
    // Test Coverage in IADStoreCreditTest_ltng Class
    @Testvisible private static IADServiceBase_ltng iAD = new IADServiceBase_ltng();
    @TestVisible private class customException extends Exception {}
    
    @AuraEnabled
    public static String sendRefundStoreCreditUpdate(string transactionId, String status, string reasonId, string reasonText){
   		final string PUTUPDATEPAYMENTSTATUS = 'PUTUPDATEPAYMENTSTATUS';
        APIRequestResponseWrapper_ltng rWrap;
        responseWrapper parsedResponse;
        String calloutURL ='';
        try{
            if(String.isNotBlank(transactionId) && string.isNotBlank(status)){
                IADServiceBase_ltng.initEndpoints(new List<String>{PUTUPDATEPAYMENTSTATUS});
                IADServiceBase_ltng.initWrapper(PUTUPDATEPAYMENTSTATUS);
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(PUTUPDATEPAYMENTSTATUS).endPointConfig.link__c;
                IADServiceBase_ltng.makeRequestMulti(calloutURL, PUTUPDATEPAYMENTSTATUS, updateTransactionStatusJSON(transactionId, status, true,reasonId, reasonText));            
                rWrap = IADServiceBase_ltng.APItoWrapper.get(PUTUPDATEPAYMENTSTATUS);
                if(rWrap.checkIsValidResponse()){
                    parsedResponse = String.isNotBlank(rWrap.responseData) ? ((responseWrapper) system.JSON.deserialize(rWrap.responseData, responseWrapper.class)):null;
                    return (parsedResponse.isSuccess!=null)?((parsedResponse.isSuccess)?'SUCCESS':'FAILURE'):'FAILURE';
				} else if(String.isNotBlank(rWrap.errorMessage)) {
                    return rWrap.errorMessage;
                }
            } else{
                throw new customException('Apex Method input Params are Blank');
            }
            return 'FAILURE';
        } catch(Exception e){
            return e.getMessage();
        }
    }
    
   	@testvisible private with sharing class responseWrapper{
        @testvisible private boolean isSuccess{get;set;}
    }
    
    @TestVisible private static string updateTransactionStatusJSON(string transactionId, String status, boolean isStoreCreditRefund, string reasonId, string reasonText){
        /*
        	{
              "transactionId": 0,
              "isStoreCreditRefund": true,
              "updatedBy": "string",
              "transactionStatus": "pending",
              "reasonCode": "string",
              "reasonText": "string"
            }
         */
        JSONGenerator gen = JSON.createGenerator(true);

        gen.writeStartObject();
        gen.writeNumberField('transactionId', integer.valueof(transactionId));
        gen.writeBooleanField('isStoreCreditRefund',isStoreCreditRefund);
        gen.writeStringField('updatedBy', UserInfo.getUserName().substring(0, UserInfo.getUserName().indexOf('@')));
        gen.writeStringField('reasonCode', reasonId);
        gen.writeStringField('reasonText', reasonText);
        gen.writeStringField('transactionStatus',status);
        gen.writeEndObject();
        
        return gen.getAsString();
    }
    
    @AuraEnabled 
    public static boolean isFinanceUser(){
        return IADPendingPaymentController_ltng.isFinanceUser();
    }
    /* STORY B-39093 - Changes Ends Here */
}