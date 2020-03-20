public class ITPContactService_ltng  extends IADServiceBase_ltng
{

  public final static String GETACCOUNTSTATUSBYCUSTOMERID = 'GetCsidAccountStatus';
  public final static string GETINVITATIONDETAILS='GetInvitationDetails';
    public final static string DEACTIVATEACCOUNT='DeactivateCSIDAccount';
    public final static string SENDITPINVITATION='SendITPInvitation'; //Anvesh @B-33787    
  @Auraenabled public static IADContractBeans_ltng.IADItpAccountstatus deSerializedpayment{get;set;}
   @Auraenabled public static IADContractBeans_ltng.IADInvitationDetails deSerializedpayments{get;set;}
   @Auraenabled public static  String eligibility {get;set;}
   @Auraenabled public static  String Accounttype {get;set;}
    @Auraenabled public static  String primarycontactName {get;set;}
   @AuraEnabled public static List<IADMessage_ltng> iadServiceMessages{get;set;}
    @Auraenabled public static  String currentLoginUserName {get;set;}
     @Auraenabled public static String statusCode{get;set;}
    @Auraenabled public static transient String responseData{get;set;}
    @Auraenabled public static IADContractBeans_ltng.InvitationResponse response{get;set;}
   public ITPContactService_ltng()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETACCOUNTSTATUSBYCUSTOMERID);
        endpoints.add(GETINVITATIONDETAILS);
        endpoints.add(DEACTIVATEACCOUNT);
 		endpoints.add(SENDITPINVITATION);//Anvesh @B-33787
       
        initEndpoints(endpoints);
        currentLoginUserName= utilitylibrary.generateUpdatedBy_withPrefixlogin();
    }


 public static void getAccountStatus(String customerId) 
    {
        
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETACCOUNTSTATUSBYCUSTOMERID).endPointConfig.link__c).replace('{customerId}',customerId);
        calloutURL=callouturl.replace('apidev','apidev-internal');
        system.debug('inside getStoreCreditsByCustomerId: calloutURL: '+calloutURL);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETACCOUNTSTATUSBYCUSTOMERID, '');
        reaAccountStatusresponse();
    }


 public static void reaAccountStatusresponse()
    {
        APIRequestResponseWrapper_ltng refundRequestResponse = IADServiceBase_ltng.APItoWrapper.get(GETACCOUNTSTATUSBYCUSTOMERID);
        system.debug(refundRequestResponse);
        try
        {
            if (refundRequestResponse.responseData != null)
            {
                if (refundRequestResponse.checkIsValidResponse())
                {
                   
                  
                     deSerializedpayment = (IADContractBeans_ltng.IADItpAccountstatus) JSON.deserialize(refundRequestResponse.responseData, IADContractBeans_ltng.IADItpAccountstatus.class);
                     system.debug('the res '+deSerializedpayment );
                   

                      // getInvitationDetails(ITPContactController_ltng.customerid);
                   
                }
                else
                {
                    if(refundRequestResponse.statusCode=='404')
                    {
                        deSerializedpayment = new  IADContractBeans_ltng.IADItpAccountstatus();
                        IADContractBeans_ltng.subscriberData subscribe = new IADContractBeans_ltng.SubscriberData();
                        subscribe.webActive='Not Enrolled';
                        subscribe.cbStatus='Not Enrolled';
                        deSerializedpayment.subscriberData=subscribe;
                    }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(refundRequestResponse);
                   iadServiceMessages = IADServiceBase_ltng.iadMessages;
                   // getInvitationDetails(ITPContactController_ltng.customerid);
                }
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
    
     public static void getInvitationDetails(String customerId) 
    {
          IADServiceBase_ltng.initWrapper(ITPContactService_ltng.GETINVITATIONDETAILS);
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETINVITATIONDETAILS).endPointConfig.link__c).replace('{customerId}',customerId);
        system.debug('inside getStoreCreditsByCustomerId: calloutURL: '+calloutURL);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETINVITATIONDETAILS, '');
        readInvitationStatusresponse();
    }


 public static void readInvitationStatusresponse()
    {
        APIRequestResponseWrapper_ltng refundRequestResponse = IADServiceBase_ltng.APItoWrapper.get(GETINVITATIONDETAILS);
        system.debug(refundRequestResponse);
        try
        {
            if (refundRequestResponse.responseData != null)
            {
                if (refundRequestResponse.checkIsValidResponse())
                {
                     if(refundRequestResponse.responseData!='')
                     {
                     deSerializedpayments = (IADContractBeans_ltng.IADInvitationDetails) JSON.deserialize(refundRequestResponse.responseData, IADContractBeans_ltng.IADInvitationDetails .class);
                     system.debug('the res '+deSerializedpayment );
                     eligibility='No';
                     }
                  
                  else
                  {
                  
                  eligibility='Yes';
                  
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
    
      public static void putAccountStatus(String customerId,string payload) 
    {
        
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(DEACTIVATEACCOUNT).endPointConfig.link__c).replace('{customerId}',customerId);
        system.debug('inside getStoreCreditsByCustomerId: calloutURL: '+calloutURL);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, DEACTIVATEACCOUNT, payload);
        readDeactivateStatusresponse();
    }


 public static void readDeactivateStatusresponse()
    {
        APIRequestResponseWrapper_ltng refundRequestResponse = IADServiceBase_ltng.APItoWrapper.get(DEACTIVATEACCOUNT);
        system.debug(refundRequestResponse);
        try
        {
            if (refundRequestResponse.responseData != null)
            {
                if (refundRequestResponse.checkIsValidResponse())
                {
                     IADServiceBase_ltng.populateSuccessMessage(' DeActivated Account Successfully ');
                     iadServiceMessages = IADServiceBase_ltng.iadMessages;

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
    public static void sendInvitaion(String payload,String customerId){
        try{
            // String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(SENDITPINVITATION).endPointConfig.link__c).replace('{customerId}',customerId);
            String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(SENDITPINVITATION).endPointConfig.link__c);//Anvesh @B-33787 // need to check endpoint url.Is customerId is required in end point URL? If true then modify the metadata and remove this line and uncomment above line
            system.debug('inside sendInvitaion: calloutURL: '+calloutURL);
            IADServiceBase_ltng.makeRequestMulti(calloutURL, SENDITPINVITATION, payload); 
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(SENDITPINVITATION);
            //APIRequestResponseWrapper response = IADServiceBase_ltng.APItoWrapper.get(SENDITPINVITATION);
            System.debug('response'+response);
            try
            {
                if (response.responseData != null)
                {
                    if (response.checkIsValidResponse())
                    {
                        IADServiceBase_ltng.populateSuccessMessage(' Invitation send successfully.  ');
                        iadServiceMessages = IADServiceBase_ltng.iadMessages;
                        
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
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }    
    
    
   
    
}