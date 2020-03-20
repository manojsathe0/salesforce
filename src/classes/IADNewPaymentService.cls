public class IADNewPaymentService extends IADServiceBase
{
    public final static String ADDNEWPAYMENT = 'PostNewPaymentProfile';
    public string statusCode {get;set;}
    public string profileId {get;set;}

    public IADContractBeans.IADPaymentProfileBean theProfile {get;set;}

    public IADNewPaymentService()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(ADDNEWPAYMENT);
        initEndpoints(endpoints);

    }
    public Object postNewPayment( IADContractBeans.IADNewPaymentProfileRequestBean newProfile)
    {
        String calloutURL = APItoWrapper.get(ADDNEWPAYMENT).endPointConfig.link__c;
        String theBody = createnewPaymentRequestBody(newProfile);
        system.debug('thebody ' + theBody);
        APItoWrapper.get(ADDNEWPAYMENT).setInfo(APIRequestResponseWrapper.CUSTOMER, newProfile.paymentProfile.customerId);
        Object continuationObject = makeRequest(calloutURL, ADDNEWPAYMENT, theBody);
        return continuationObject;
    }
    public void readNewPaymentResponse()
    {
        try
        {
            initHTTPResponse(ADDNEWPAYMENT); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper response = APItoWrapper.get(ADDNEWPAYMENT);
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null)
                {
                    IADContractBeans.IADPaymentProfiles deserialzedProfile =  (IADContractBeans.IADPaymentProfiles) JSON.deserialize(response.responseData, IADContractBeans.IADPaymentProfiles.class);
                    system.debug('deserialzedProfile ' + deserialzedProfile);
                    statusCode = response.statusCode;
                    profileId = deserialzedProfile.paymentProfiles[0].profileId;
                    theProfile= deserialzedProfile.paymentProfiles[0];
                }
                else
                {
                    populateNullErrorMessage(response);
                }

            }
            else
            {
                 populateErrorMessage(response);
                //populateErrorMessage('Payment method was not added. Response Code : '+response.statusCode );
            }


        }

        catch(Exception theException)
        {
            throw new IADException('Failed displaying new payment '+theException.getMessage() , theException);
        }
    }

    public String createnewPaymentRequestBody(IADContractBeans.IADNewPaymentProfileRequestBean newProfileBean)
    {
        newProfileBean.paymentProfile.gateway = UtilityLibrary.getConfig().Payment_Gateway__c;
        newProfileBean.paymentProfile.paymentType = UtilityLibrary.profilePaymentNameToTypeMap.get('Credit Card');
        newProfileBean.paymentProfile.token = null;
        newProfileBean.paymentProfile.isActive = true;
        newProfileBean.paymentProfile.isRecurring = false;
        return JSON.serialize(newProfileBean);
    }


}