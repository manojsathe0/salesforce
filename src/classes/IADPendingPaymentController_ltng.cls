public with sharing class IADPendingPaymentController_ltng 
{
    public static String theId;
    // public  static String orderId {get;set;}
    public String dayview{get;set;}
    @auraenabled public static  IADContractBeans_ltng.IADPaymentBean thePayment{get;set;}
    @auraenabled public  static IADContractBeans_ltng.IADPaymentBean theOriginalPayment{get;set;}
    //public IADPaymentService paymentService{get;set;}
    public IADEditPaymentService getProfileService{get;set;}
    //public static  String transactionType{get;set;}
    @Auraenabled public static String transactionTypeLabel{get;set;}
    @Auraenabled  public  static String transactionLabel{get;set;}
    @auraEnabled public static IADPaymentService_ltng paymentService{get;set;}
    @auraenabled  public  static string  profilelabel{get;set;}
    @AuraEnabled public static List<IADMessage_ltng> exceptions {get;set;}
    
    public IADPendingPaymentController_ltng () 
    {
        
        
        
    }
    
    @AuraEnabled
    public static   IADPendingPaymentController_ltng    populatePayments( string orderId, string transactionType)
    {
        IADPendingPaymentController_ltng  pendingpayment = new  IADPendingPaymentController_ltng ();
        exceptions=new List<IADMessage_ltng>();
        paymentService = new IADPaymentService_ltng();
        try
        {  
            if(transactionType == '1') //Payments
            {
                IADServiceBase_ltng.initWrapper(IADPaymentService.GETPAYMENTBYPAYMENTID);
                IADPaymentService_ltng.getPaymentByPaymentId(orderId);
                transactionTypeLabel = 'Payment';
                thePayment = IADPaymentService_ltng.thePayment;
                
                exceptions = IADServiceBase_ltng.iadMessages;
                
            }
            else if(transactionType == '2') //Refunds
            {
                IADServiceBase_ltng.initWrapper(IADPaymentService.GETREFUNDBYREFUNDID);
                IADPaymentService_ltng.getRefundByRefundId(orderId);
                transactionTypeLabel = 'Refund';
                thePayment = IADPaymentService_ltng.thePayment;
                populateOriginalPayment();
                
                exceptions = IADServiceBase_ltng.iadMessages;
            }
            return pendingpayment; 
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages; 
            system.debug('the error'+exceptions );
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages; 
            system.debug('the error'+exceptions );
        }
        
        return pendingpayment; 
        
    }
    
    public static void  populateOriginalPayment()
    {
        
        
        try
        {
            String objectId = IADPaymentService_ltng.thePayment.parentId;
            IADServiceBase_ltng.initWrapper(IADPaymentService_ltng.GETPAYMENTBYPAYMENTID);
            IADPaymentService_ltng.getPaymentByPaymentId(objectId);
            theOriginalPayment = IADPaymentService_ltng.thePayment;
            populateOriginalPaymentProfile();
            
            //Saved for if logic gets separated out to separate API, otherwise continue using the above
            //            if(UtilityLibrary.paymentTypeToNameMap.get(thePayment.paymentType) == 'Credit Card') //Credit Card Payment
            //            {
            //                paymentService.initWrapper(IADPaymentService.GETPAYMENTBYPAYMENTID, 'processOriginalPaymentResponse');
            //                continuationObject = paymentService.getPaymentByPaymentId(objectId);
            //                transactionTypeLabel = 'Payment';
            //            }
            //            else if(UtilityLibrary.paymentTypeToNameMap.get(thePayment.paymentType) == 'Store Credit') //Store Credit
            //            {
            //                paymentService.initWrapper(IADPaymentService.SOMEAPI, 'processOriginalPaymentResponse');
            //                continuationObject = paymentService.getPaymentByPaymentId(objectId);
            //                transactionTypeLabel = 'Store Credit';
            //            }
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages; 
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages; 
        }
        
        
    }
    
    public static void  populateOriginalPaymentProfile()
    {
        try
        {
            system.debug('populatepaymentprofile');
            IADEditPaymentService_ltng editpayment = new IADEditPaymentService_ltng();
            IADServiceBase_ltng.initWrapper(IADEditPaymentService_ltng.GETPROFILEBYID);
            
            if(theOriginalPayment.paymentProfileId != null && theOriginalPayment.paymentProfileId != '' && theOriginalPayment.paymentProfileId != '0')
            {
                IADEditPaymentService_ltng.getPaymentProfileById(theOriginalPayment.paymentProfileId);
                processOriginalProfile();
                
            }
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages; 
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages; 
        }
        
        
        
    }
    public static void  processOriginalProfile()
    {
        try
        {
            
            
            if( IADEditPaymentService_ltng.theProfile!= null)
            {
                if(UtilityLibrary.paymentTypeToNameMap.get(thePayment.paymentType) == 'Credit Card') //Credit Card Payment
                {
                    transactionLabel = theOriginalPayment.paymentTransactionId + ': '
                        + UtilityLibrary.profileAccountTypeToNameMap.get( IADEditPaymentService_ltng.theProfile.AccountType)
                        + ' - ' +  IADEditPaymentService_ltng.theProfile.last4Digits + ' - $' + theOriginalPayment.amount;
                }
                //                else if(UtilityLibrary.paymentTypeToNameMap.get(thePayment.paymentType) == 'Store Credit') //Store Credit
                //                {
                //                    //Todo when store credit contract errors are solved, create a proper label with this information
                //                    transactionLabel = theOriginalPayment.paymentTransactionId + ': '
                //                            + UtilityLibrary.profileAccountTypeToNameMap.get(getProfileService.theProfile.AccountType)
                //                            + ' - ' + getProfileService.theProfile.last4Digits + ' - $' + theOriginalPayment.amount;
                //                }
                
            }
            
            
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages; 
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages; 
        }
        // return null;
    }
    
    //Callback method for Asynchronous
    
    
    /*
    @AuraEnabled
    public static IADPaymentService_ltng updateManualCheckStatus(String paymentDetails, String clearedDeclinedDate){
        paymentService = new IADPaymentService_ltng();
        IADServiceBase_ltng.initWrapper(IADPaymentService_ltng.PUTMANUALCHECKSTATUS);
        IADPaymentService_ltng.updateManualCheckStatus(paymentDetails, clearedDeclinedDate);
        
        return paymentService;
    }
    */
    // Modified By Harsha  - STORY B-40440 - Starts Here - Created By Hari
   	@Testvisible private static IADServiceBase_ltng iAD = new IADServiceBase_ltng();
    @TestVisible private class customException extends Exception {}
    @AuraEnabled
    public static string updateManualCheckStatus(String clearedDeclinedDate, string paymentTransactionId, string iadStatus) {
        try{
            if(string.isBlank(paymentTransactionId) ||  string.isBlank(clearedDeclinedDate) || string.isBlank(iadStatus)){
                throw new customException('Input Params are Blank');
            }
            final String PUTMANUALCHECKSTATUS = 'CHANGEMANUALCHECKSTATUS';
            APIRequestResponseWrapper_ltng rWrap;
            responseRefundClass parsedResponse;
            IADContractBeans_ltng.IADPaymentBean deserializedPaymentDetails;
            String calloutURL='';
            String payload ='';
            IADServiceBase_ltng.initEndpoints(new List<String>{PUTMANUALCHECKSTATUS});
            IADServiceBase_ltng.initWrapper(PUTMANUALCHECKSTATUS);
            calloutURL = IADServiceBase_ltng.APItoWrapper.get(PUTMANUALCHECKSTATUS).endPointConfig.link__c;
            payload = '{"paymentTransactionId":'+paymentTransactionId+',"transactionStatusDate":"'+clearedDeclinedDate+'","status":"'+iadStatus+'","updatedBy":"'+UtilityLibrary.generateUpdatedBy()+'","checkNumber":"null","isStoreCreditToManualCheck":false,"storeCreditTranscationId" :null}';
            IADServiceBase_ltng.makeRequestMulti(calloutURL, PUTMANUALCHECKSTATUS, payload);
            rWrap = IADServiceBase_ltng.APItoWrapper.get(PUTMANUALCHECKSTATUS);
            if(rWrap.checkIsValidResponse()){
                parsedResponse = String.isNotBlank(rWrap.responseData) ? ((responseRefundClass) System.JSON.deserialize(rWrap.responseData, responseRefundClass.class)):null;
                return (parsedResponse.isStatusChanged != null) ? ((parsedResponse.isStatusChanged == true) ? 'SUCCESS':'FAILURE') :'FAILURE';
            } else if(String.isNotBlank(rWrap.errorMessage)) {
                return rWrap.errorMessage;
            }
            return 'FAILURE';
        } catch(Exception e){
            return e.getMessage();
        }
    }
    // added By Harsha  - STORY B-40440 - Ends Here
    
    @AuraEnabled
    public static Boolean isFinanceUser(){
        return UtilityLibrary.isPermissionSetAssigned(UserInfo.getUserId(), 'SF_Ability_to_Edit_Finance_Fields');
    }
    
       ///*STORY B-38496 - Changes Starts Here */
    
    @AuraEnabled
   public static string sendUpdatePaymentStatus(string transactionId, String status, string reasonId, string reasonText){
        try{
        	if(string.isNotBlank(transactionId) && string.isNotBlank(status) && string.isNotBlank(reasonId)){
                final string PUTUPDATEPAYMENTSTATUS = 'PUTUPDATEPAYMENTSTATUS';
                APIRequestResponseWrapper_ltng rWrap;
                String calloutURL ='';
                IADServiceBase_ltng.initEndpoints(new List<String>{PUTUPDATEPAYMENTSTATUS});
                IADServiceBase_ltng.initWrapper(PUTUPDATEPAYMENTSTATUS);
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(PUTUPDATEPAYMENTSTATUS).endPointConfig.link__c;
                IADServiceBase_ltng.makeRequestMulti(calloutURL, PUTUPDATEPAYMENTSTATUS, updateTransactionStatusJSON(transactionId, status,false,reasonId,reasonText));
                rWrap = IADServiceBase_ltng.APItoWrapper.get(PUTUPDATEPAYMENTSTATUS);
                if(rWrap.checkIsValidResponse()){
                    /*
                    updateTransactionStatusResponseClass parsedResponse = (updateTransactionStatusResponseClass) system.JSON.deserialize(rWrap.responseData, updateTransactionStatusResponseClass.class);
                    return String.isNotBlank(parsedResponse.transactionStatus) ? (parsedResponse.transactionStatus.equalsIgnoreCase(status) ? 'SUCCESS' : 'FAILURE') : 'FAILURE';
					*/
                    responseWrapper parsedResponse = String.isNotBlank(rWrap.responseData) ? ((responseWrapper) system.JSON.deserialize(rWrap.responseData, responseWrapper.class)):null;
                    return (parsedResponse.isSuccess!=null)?((parsedResponse.isSuccess)?'SUCCESS':'FAILURE'):'FAILURE';
                } else if(String.isNotBlank(rWrap.errorMessage)) {
                    return rWrap.errorMessage;
                }
            } else {
                throw new customException('Input Params are Blank');
            }
        	return 'FAILURE';
        } catch (Exception e){
            IADServiceBase_ltng.populateErrorMessage(e);
            return e.getMessage();
        }
    }
    ///*STORY B-38496 - Changes Ends Here */
    
    /* STORY B-38746 - Changes Starts Here */
    /*
    @AuraEnabled
    public static String sendRefundUpdateDetails(String transactionId,string status,DateTime checkDate,String checkNumber){
        try{
            if(String.isNotBlank(transactionId) && string.isNotBlank(status) && string.isNotBlank(checkNumber) && checkDate !=null){
                final string CHANGEMANUALCHECKSTATUS = 'CHANGEMANUALCHECKSTATUS';
                APIRequestResponseWrapper_ltng rWrap;
                responseRefundClass parsedResponse;
                String calloutURL ='';
                IADServiceBase_ltng.initEndpoints(new List<String>{CHANGEMANUALCHECKSTATUS});
                IADServiceBase_ltng.initWrapper(CHANGEMANUALCHECKSTATUS);
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(CHANGEMANUALCHECKSTATUS).endPointConfig.link__c;
                IADServiceBase_ltng.makeRequestMulti(calloutURL, CHANGEMANUALCHECKSTATUS, refundStatusJSON(transactionId, status,checkDate,CheckNumber));            
                rWrap = IADServiceBase_ltng.APItoWrapper.get(CHANGEMANUALCHECKSTATUS);
                if(rWrap.checkIsValidResponse()){
                	parsedResponse = String.isNotBlank(rWrap.responseData) ? ((responseRefundClass) System.JSON.deserialize(rWrap.responseData, responseRefundClass.class)):null;
                    return (parsedResponse.isStatusChanged != null) ? ((parsedResponse.isStatusChanged == true) ? 'SUCCESS':'FAILURE') :'FAILURE';
                } else if(String.isNotBlank(rWrap.errorMessage)) {
                    return rWrap.errorMessage;
                }
            } else{
                throw new customException('Apex Method input Params are Blank');
            }
            return 'FAILURE';
        } catch(Exception e){
            //system.debug('Exception ~~~~~~> '+e);
            return e.getMessage();
        }
    }

	@TestVisible private static string refundStatusJSON (String transactionId,string status,DateTime checkDate,String checkNumber){
    */    
        /*
         * 
            {
              "paymentTransactionId": 0,
              "transactionStatusDate": "2018-03-13T12:48:12.993Z",
              "status": "pending",
              "updatedBy": "string",
              "checkNumber": "string"
              "isStoreCreditToManualCheck": false,
              "storeCreditTransactionId": 0
            }
        *
        */
    /*
		JSONGenerator gen = JSON.createGenerator(true);

        gen.writeStartObject();
        gen.writeNumberField('paymentTransactionId', integer.valueof(transactionId));
		gen.writeDateTimeField('transactionStatusDate', checkDate);
        gen.writeStringField('status',status);
        gen.writeStringField('updatedBy',userInfo.getUserName().substring(0,userInfo.getUserName().indexOf('@')));
		gen.writeStringField('checkNumber',checkNumber);
        // I don't think that store credit related fields are not necessary here and they are optional for this API,.. 
		//https://legalzoom.atlassian.net/wiki/spaces/API/pages/484474883/Change+Manual+Check+status+-+PUT
        gen.writeEndObject();
        
        return gen.getAsString();
		
	}
    */
    
    @TestVisible private with sharing class responseRefundClass {
        /*
            {
              "storeCreditTransactionId": 0,
              "paymentTransactionId": 0,
              "isStatusChanged": true,
              "errorMessge": "string"
            }
		*/
        @TestVisible private integer storeCreditTransactionId{get;set;}
        @TestVisible private integer paymentTransactionId{get;set;}
        @TestVisible private boolean isStatusChanged{get;set;}
        @TestVisible private string errorMessge{get;set;}
    }
    /* STORY B-38746 - Changes Ends Here */
    
    /* STORY B-39093 - Changes Starts Here */
    /*
    @AuraEnabled
    public static String sendRefundStoreCreditUpdate(string transactionId, String status, string reasonId, string reasonText){
        try{
            if(String.isNotBlank(transactionId) && string.isNotBlank(status)){
                final string PUTUPDATEPAYMENTSTATUS = 'PUTUPDATEPAYMENTSTATUS';
                APIRequestResponseWrapper_ltng rWrap;
                String calloutURL ='';
                //updateTransactionStatusResponseClass parsedResponse;
                IADServiceBase_ltng.initEndpoints(new List<String>{PUTUPDATEPAYMENTSTATUS});
                IADServiceBase_ltng.initWrapper(PUTUPDATEPAYMENTSTATUS);
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(PUTUPDATEPAYMENTSTATUS).endPointConfig.link__c;
                IADServiceBase_ltng.makeRequestMulti(calloutURL, PUTUPDATEPAYMENTSTATUS, updateTransactionStatusJSON(transactionId, status, true,reasonId, reasonText));            
                rWrap = IADServiceBase_ltng.APItoWrapper.get(PUTUPDATEPAYMENTSTATUS);
                if(rWrap.checkIsValidResponse()){
                    responseWrapper parsedResponse = String.isNotBlank(rWrap.responseData) ? ((responseWrapper) system.JSON.deserialize(rWrap.responseData, responseWrapper.class)):null;
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
    */
   
    /* STORY B-39093 - Changes Ends Here */
    
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
    /*
    @TestVisible private with sharing class updateTransactionStatusResponseClass {

        @TestVisible private integer transactionId{get;set;}
        @TestVisible private boolean isStoreCreditRefund{get;set;}
        @TestVisible private string updatedBy{get;set;}
        @TestVisible private string transactionStatus{get;set;}
        @TestVisible private string reasonCode{get;set;}
        @TestVisible private string reasonText{get;set;}
    }
    */
    @testvisible private with sharing class responseWrapper{
        @testvisible private boolean isSuccess{get;set;}
    }
        // <!-- STORY B-39061 -->
    public with sharing class refundManualRequestWrapper{
		@AuraEnabled public Integer customerId;	//0
		@AuraEnabled public String transactionStatusDate;	//2019-03-29T12:22:33.359Z
		@AuraEnabled public String status;	//pending
		@AuraEnabled public String checkNumber;	//string
		@AuraEnabled public Integer orderId;	//0
		@AuraEnabled public String firstName;	//string
		@AuraEnabled public String lastName;	//string
		@AuraEnabled public String address1;	//string
		@AuraEnabled public String address2;	//string
		@AuraEnabled public String city;	//string
		@AuraEnabled public Integer stateId;	//0
		@AuraEnabled public String zipCode;	//string
		@AuraEnabled public String country;	//string
		@AuraEnabled public String updatedBy;	//string
    }
    
    @AuraEnabled
    public static String sendRefundUpdateDetails(string reqWrapStr, string paymentTransactionId){
    	final string UPDATEMANUALCHECKSTATUSMAILINGADDRESS = 'UpdateManualCheckStatusMailingAddress';  //  use correct metadata type name
        APIRequestResponseWrapper_ltng rWrap;
        responseRefundClass parsedResponse;
        refundManualRequestWrapper reqWrap;
        String calloutURL ='';
        try{
            if(string.isNotBlank(reqWrapStr) && string.isNotBlank(paymentTransactionId)){
                reqWrap = (refundManualRequestWrapper)JSON.deserialize(reqWrapStr, refundManualRequestWrapper.class);
                reqWrap.updatedBy = UserInfo.getUserEmail().substring(0, UserInfo.getUserEmail().indexOf('@'));
                IADServiceBase_ltng.initEndpoints(new List<String>{UPDATEMANUALCHECKSTATUSMAILINGADDRESS});
                IADServiceBase_ltng.initWrapper(UPDATEMANUALCHECKSTATUSMAILINGADDRESS);
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(UPDATEMANUALCHECKSTATUSMAILINGADDRESS).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{paymentTransactionId}', paymentTransactionId);
                IADServiceBase_ltng.makeRequestMulti(calloutURL, UPDATEMANUALCHECKSTATUSMAILINGADDRESS, JSON.serialize(reqWrap));            
                rWrap = IADServiceBase_ltng.APItoWrapper.get(UPDATEMANUALCHECKSTATUSMAILINGADDRESS);
                if(rWrap.checkIsValidResponse()){
                	parsedResponse = String.isNotBlank(rWrap.responseData) ? ((responseRefundClass) System.JSON.deserialize(rWrap.responseData, responseRefundClass.class)):null;
                    return (parsedResponse.isStatusChanged!=null)?(parsedResponse.isStatusChanged?'SUCCESS':(string.isBlank(parsedResponse.errorMessge)?'FAILURE':parsedResponse.errorMessge)):'FAILURE';
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
    // <!-- STORY B-39061 -->
}