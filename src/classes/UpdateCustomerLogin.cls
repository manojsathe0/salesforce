/*
 @author :  Harsha Reddy <sxreddy@legalzoom.com>
 @file Description : STORY B-38226
 @desc Created on 2019-04-09 8:33:06 pm
*/
public with sharing class UpdateCustomerLogin {
    
    @Testvisible private static IADServiceBase_ltng iAD = new IADServiceBase_ltng();
    @TestVisible private class customException extends Exception {}
    
    @AuraEnabled
    public static string sendCustomerLoginEmail( requestWrapper rWrap, string customerid){
        final string UPDATECUSTOMERLOGIN = 'UPDATECUSTOMERLOGIN';
        APIRequestResponseWrapper_ltng apiWrap;
        responseWrapper parsedResponse;
        String calloutURL ='';
        try{
            if(rWrap!=null && string.isNotBlank(customerid)){
                rWrap.updatedBy = UserInfo.getUserName().substring(0, UserInfo.getUserName().indexOf('@'));
                rWrap.orderType = 'legalZoom'; // Hard Coded for Now
                IADServiceBase_ltng.initEndpoints(new List<String>{UPDATECUSTOMERLOGIN});
                IADServiceBase_ltng.initWrapper(UPDATECUSTOMERLOGIN);
                calloutURL = IADServiceBase_ltng.APItoWrapper.get(UPDATECUSTOMERLOGIN).endPointConfig.link__c;
                calloutURL = calloutURL.replace('{customerId}', customerid);
                IADServiceBase_ltng.makeRequestMulti(calloutURL, UPDATECUSTOMERLOGIN, JSON.serialize(rWrap));            
                apiWrap = IADServiceBase_ltng.APItoWrapper.get(UPDATECUSTOMERLOGIN);
                if(apiWrap.checkIsValidResponse()){
                	parsedResponse = String.isNotBlank(apiWrap.responseData) ? ((responseWrapper) System.JSON.deserialize(apiWrap.responseData, responseWrapper.class)):null;
                    return (parsedResponse!=null)?((parsedResponse.isUpdated!=null)?(parsedResponse.isUpdated ?'SUCCESS':'FAILURE'):'FAILURE'):'FAILURE';
                } else if(String.isNotBlank(apiWrap.errorMessage)) {
                    return apiWrap.errorMessage;
                }
            } else{
                throw new customException('Input Params are Blank');
            }
        	return 'FAILURE';   
        } catch (Exception e){
            return e.getMessage();
        }
    } 
    
    public with sharing class requestWrapper{
        /*
            {
            	"currentLoginEmail": "string",
              	"newLoginEmail": "string",
              	"orderType": "legalZoom",
              	"updatedBy": "string"
            }
		*/
        
        @AuraEnabled public string updatedBy{get;set;}
        @AuraEnabled public string newLoginEmail{get;set;}
        @AuraEnabled public string orderType{get;set;}
        @AuraEnabled public string currentLoginEmail{get;set;}
    }
    
    @testvisible private with sharing class responseWrapper{
        /*
        	{
            	"isUpdated": true,
              	"customerId": 0,
              	"loginEmail": "string",
              	"message": "string"
       		}
		*/
        @testvisible private string loginEmail{get;set;}
        @testvisible private string message{get;set;}
        @testvisible private integer customerId{get;set;}
        @testvisible private boolean isUpdated{get;set;}
    }
}