public class IADNewPaymentService_ltng extends IADServiceBase_ltng
{
    public final static String ADDNEWPAYMENT = 'PostNewPaymentProfile';
    public  static string statusCode {get;set;}
    public  static string profileId {get;set;}

    public  static IADContractBeans_ltng.IADPaymentProfileBean theProfile {get;set;}

    public IADNewPaymentService_ltng()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(ADDNEWPAYMENT);
        initEndpoints(endpoints);

    }
    public static void  postNewPayment( IADContractBeans_ltng.IADNewPaymentProfileRequestBean newProfile)
    {
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(ADDNEWPAYMENT).endPointConfig.link__c;
        String theBody = createnewPaymentRequestBody(newProfile);
        system.debug('thebody ' + theBody);
        IADServiceBase_ltng.APItoWrapper.get(ADDNEWPAYMENT).setInfo(APIRequestResponseWrapper_ltng.CUSTOMER, newProfile.paymentProfile.customerId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, ADDNEWPAYMENT, theBody);
        
    }
    public static void readNewPaymentResponse()
    {
        try
        {
            //initHTTPResponse(ADDNEWPAYMENT); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(ADDNEWPAYMENT);
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null)
                {
                    IADContractBeans_ltng.IADPaymentProfiles deserialzedProfile =  (IADContractBeans_ltng.IADPaymentProfiles) JSON.deserialize(response.responseData, IADContractBeans_ltng.IADPaymentProfiles.class);
                    system.debug('deserialzedProfile ' + deserialzedProfile);
                    statusCode = response.statusCode;
                    profileId = deserialzedProfile.paymentProfiles[0].profileId;
                    theProfile= deserialzedProfile.paymentProfiles[0];
                }
                else
                {
                   IADServiceBase_ltng.populateNullErrorMessage(response);
                }

            }
            else
            {
                // populateErrorMessage(response);
                IADServiceBase_ltng.populateErrorMessage('Payment method was not added. Response Code : '+response.statusCode );
            }


        }

        catch(Exception theException)
        {
            throw new IADException('Failed displaying new payment '+theException.getMessage() , theException);
        }
    }

    public  static String createnewPaymentRequestBody(IADContractBeans_ltng.IADNewPaymentProfileRequestBean newProfileBean)
    {
        newProfileBean.paymentProfile.gateway = UtilityLibrary.getConfig().Payment_Gateway__c;
        newProfileBean.paymentProfile.paymentType = UtilityLibrary.profilePaymentNameToTypeMap.get('Credit Card');
        newProfileBean.paymentProfile.token = null;
        newProfileBean.paymentProfile.isActive = true;
        newProfileBean.paymentProfile.isRecurring = false;
        return JSON.serialize(newProfileBean);
    }


}