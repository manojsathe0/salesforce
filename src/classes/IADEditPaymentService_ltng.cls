public class IADEditPaymentService_ltng extends IADServiceBase_ltng
{
    public final static String GETPROFILEBYID = 'GetProfileById';
    public final static String PUTPROFILEBYID = 'PutProfileById';
    public final static String DELETEPAYMENTPROFILEBYID='DeletePaymentprofile';
    @AuraEnabled public static IADContractBeans_ltng.IADPaymentProfileBean theProfile{get;set;}
    public static string customerid;
    public static boolean deletecheck ;
    
    public IADEditPaymentService_ltng()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETPROFILEBYID);
        endpoints.add(PUTPROFILEBYID);
        endpoints.add(DELETEPAYMENTPROFILEBYID);
        initEndpoints(endpoints);
    }
    
    public static void getPaymentProfileById(String theId)
    {
        if(theId != null && theId != '')
        {
            String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(GETPROFILEBYID).endPointConfig.link__c).replace('{paymentProfileId}',theId);
            system.debug('calloutURL ' + calloutURL);
            IADServiceBase_ltng.makeRequestMulti(calloutURL, GETPROFILEBYID , '');
            populateProfileById();
        }
    }
    public  static void populateProfileById()
    {
        try
        {
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(GETPROFILEBYID);
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null && response.responseData != '') //Only check this if you need the response body
                {
                    IADContractBeans_ltng.IADPaymentProfiles deSerializedpayments = (IADContractBeans_ltng.IADPaymentProfiles) JSON.deserialize(response.responseData , IADContractBeans_ltng.IADPaymentProfiles.class);
                    system.debug('deSerializedpayments ' + deSerializedpayments);
                    if(deSerializedpayments != null)
                    {
                        system.debug('deSerializedpayments.paymentProfiles ' + deSerializedpayments.paymentProfiles);
                        response.resultObjects = deSerializedpayments.paymentProfiles;
                        List<IADContractBeans_ltng.IADPaymentProfileBean> profiles = deSerializedpayments.paymentProfiles;
                        if(profiles.size() > 0)
                        {
                            theProfile = profiles[0];
                            theProfile.last4Digits = 'xxxx-xxxx-xxxx' + theProfile.last4Digits;
                            system.debug('theProfile ' + theProfile);
                        }
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(response);
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(response);
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('test + ' + theException.getStackTraceString());
        }
    }
    
    public static void putPaymentProfileById(String theId)
    {
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(PUTPROFILEBYID).endPointConfig.link__c).replace('{paymentProfileId}',theId);
        system.debug('calloutURL ' + calloutURL);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, PUTPROFILEBYID , getUpdateBody());
    }
    
    
    public static void DeletePaymentProfileById(String theId)
    {
        String calloutURL = (IADServiceBase_ltng.APItoWrapper.get(DELETEPAYMENTPROFILEBYID).endPointConfig.link__c).replace('{paymentProfileId}',theId);
        system.debug('calloutURL ' + calloutURL);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, DELETEPAYMENTPROFILEBYID , '');
    }
    public static void putPopulateProfileById()
    {
        try
        {
            //initHTTPResponse(PUTPROFILEBYID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(PUTPROFILEBYID);
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null && response.responseData != '') //Only check this if you need the response body
                {
                    system.debug('response.responsedata ' + response.responseData);
                    IADContractBeans_ltng.IADPaymentProfiles deSerializedpayments = (IADContractBeans_ltng.IADPaymentProfiles) JSON.deserialize(response.responseData , IADContractBeans_ltng.IADPaymentProfiles.class);
                    system.debug('deSerializedpayments ' + deSerializedpayments);
                    if(deSerializedpayments != null)
                    {
                        system.debug('deSerializedpayments.paymentProfiles ' + deSerializedpayments.paymentProfiles);
                        response.resultObjects = deSerializedpayments.paymentProfiles;
                        List<IADContractBeans_ltng.IADPaymentProfileBean> profiles = deSerializedpayments.paymentProfiles;
                        if(profiles.size() > 0)
                        {  if(deletecheck)
                           {
                           IADServiceBase_ltng.populateSuccessMessage('Payment Profile Deleted Successfully ');
                           
                           }
                           else
                           {
                            IADServiceBase_ltng.populateSuccessMessage('Payment Profile Successfully Updated.');
                            }
                        }
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(response);
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(response);
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
        }
    }
     public static void DeleteProfileById()
    {
        try
        {
            //initHTTPResponse(PUTPROFILEBYID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(DELETEPAYMENTPROFILEBYID);
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null && response.responseData != '') //Only check this if you need the response body
                {
                  
                           
                  IADServiceBase_ltng.populateSuccessMessage('Payment Profile Deleted Successfully ');
                       
                    
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(response);
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(response);
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
        }
    }
    
    public static String getUpdateBody()
    {
        IADContractBeans_ltng.IADPaymentUpdateProfileBean thePaymentUpdate = new IADContractBeans_ltng.IADPaymentUpdateProfileBean();
        thePaymentUpdate.updatePaymentProfile = new IADContractBeans_ltng.IADPaymentProfileUpdate();
        thePaymentUpdate.updatePaymentProfile.firstName = theProfile.firstName;
        thePaymentUpdate.updatePaymentProfile.lastName = theProfile.lastName;
        thePaymentUpdate.updatePaymentProfile.paymentType = theProfile.paymentType;
        thePaymentUpdate.updatePaymentProfile.accountType = theProfile.accountType;
        thePaymentUpdate.updatePaymentProfile.addressLine1 = theProfile.addressLine1;
        if(theProfile.addressLine2==null)
        {
        thePaymentUpdate.updatePaymentProfile.addressLine2=''; 
        }
        else
        {
        thePaymentUpdate.updatePaymentProfile.addressLine2 = theProfile.addressLine2;
        }
        thePaymentUpdate.updatePaymentProfile.city = theProfile.city;
        thePaymentUpdate.updatePaymentProfile.state = theProfile.state;
        thePaymentUpdate.updatePaymentProfile.zip = theProfile.zip;
        thePaymentUpdate.updatePaymentProfile.phone = theProfile.phone;
        thePaymentUpdate.updatePaymentProfile.month = theProfile.month;
        thePaymentUpdate.updatePaymentProfile.customerId=Integer.valueof(theProfile.customerId);
        thePaymentUpdate.updatePaymentProfile.year = theProfile.year;
        
        return JSON.serialize(thePaymentUpdate);
    }
    
}