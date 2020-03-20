/**
 * Created by jboles on 10/26/2016.
 */

public class IADEditPaymentService extends IADServiceBase
{
    public final static String GETPROFILEBYID = 'GetProfileById';
    public final static String PUTPROFILEBYID = 'PutProfileById';
    public final static String DELETEPAYMENTPROFILEBYID='DeletePaymentprofile';
    public IADContractBeans.IADPaymentProfileBean theProfile{get;set;}

    public IADEditPaymentService()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETPROFILEBYID);
        endpoints.add(PUTPROFILEBYID);
        endpoints.add(DELETEPAYMENTPROFILEBYID);
        initEndpoints(endpoints);
    }

    public Object getPaymentProfileById(String theId)
    {
        if(theId != null && theId != '')
        {
            String calloutURL = (APItoWrapper.get(GETPROFILEBYID).endPointConfig.link__c).replace('{paymentProfileId}',theId);
            system.debug('calloutURL ' + calloutURL);
            Object continuationObject = makeRequest(calloutURL, GETPROFILEBYID , '');

            return continuationObject;
        }
        return null;

    }
    public void populateProfileById()
    {
        try
        {
            initHTTPResponse(GETPROFILEBYID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper response = APItoWrapper.get(GETPROFILEBYID);
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null && response.responseData != '') //Only check this if you need the response body
                {
                    IADContractBeans.IADPaymentProfiles deSerializedpayments = (IADContractBeans.IADPaymentProfiles) JSON.deserialize(response.responseData , IADContractBeans.IADPaymentProfiles.class);
                    system.debug('deSerializedpayments ' + deSerializedpayments);
                    if(deSerializedpayments != null)
                    {
                        system.debug('deSerializedpayments.paymentProfiles ' + deSerializedpayments.paymentProfiles);
                        response.resultObjects = deSerializedpayments.paymentProfiles;
                        List<IADContractBeans.IADPaymentProfileBean> profiles = deSerializedpayments.paymentProfiles;
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
                    populateNullErrorMessage(response);
                }
            }
            else
            {
                populateErrorMessage(response);
            }
        }
        catch(Exception theException)
        {
            populateErrorMessage('test + ' + theException.getStackTraceString());
        }
    }
    public Object putPaymentProfileById(String theId)
    {
        String calloutURL = (APItoWrapper.get(PUTPROFILEBYID).endPointConfig.link__c).replace('{paymentProfileId}',theId);
        system.debug('calloutURL ' + calloutURL);
        Object continuationObject = makeRequest(calloutURL, PUTPROFILEBYID , getUpdateBody());

        return continuationObject;

    }
    public void putPopulateProfileById()
    {
        try
        {
            initHTTPResponse(PUTPROFILEBYID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper response = APItoWrapper.get(PUTPROFILEBYID);
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null && response.responseData != '') //Only check this if you need the response body
                {
                    system.debug('response.responsedata ' + response.responseData);
                    IADContractBeans.IADPaymentProfiles deSerializedpayments = (IADContractBeans.IADPaymentProfiles) JSON.deserialize(response.responseData , IADContractBeans.IADPaymentProfiles.class);
                    system.debug('deSerializedpayments ' + deSerializedpayments);
                    if(deSerializedpayments != null)
                    {
                        system.debug('deSerializedpayments.paymentProfiles ' + deSerializedpayments.paymentProfiles);
                        response.resultObjects = deSerializedpayments.paymentProfiles;
                        List<IADContractBeans.IADPaymentProfileBean> profiles = deSerializedpayments.paymentProfiles;
                        if(profiles.size() > 0)
                        {
                            populateSuccessMessage('Payment Profile Successfully Updated.');
                        }
                    }
                }
                else
                {
                    populateNullErrorMessage(response);
                }
            }
            else
            {
                populateErrorMessage(response);
            }
        }
        catch(Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
    
     public Object deletePaymentProfileById(String theId)
    {
        String calloutURL = (APItoWrapper.get(DELETEPAYMENTPROFILEBYID).endPointConfig.link__c).replace('{paymentProfileId}',theId);
        system.debug('calloutURL ' + calloutURL);
        Object continuationObject = makeRequest(calloutURL, DELETEPAYMENTPROFILEBYID , '');

        return continuationObject;

    }
    public void deletePopulateProfileById()
    {
        try
        {
            initHTTPResponse(DELETEPAYMENTPROFILEBYID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper response = APItoWrapper.get(DELETEPAYMENTPROFILEBYID);
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null && response.responseData != '') //Only check this if you need the response body
                {
                  
                            populateSuccessMessage('Payment Profile Successfully Deleted');
                       
                   
                }
                else
                {
                    populateNullErrorMessage(response);
                }
            }
            else
            {
                populateErrorMessage(response);
            }
        }
        catch(Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
    public String getUpdateBody()
    {
        IADContractBeans.IADPaymentUpdateProfileBean thePaymentUpdate = new IADContractBeans.IADPaymentUpdateProfileBean();
        thePaymentUpdate.updatePaymentProfile = new IADContractBeans.IADPaymentProfileUpdate();
        thePaymentUpdate.updatePaymentProfile.firstName = theProfile.firstName;
        thePaymentUpdate.updatePaymentProfile.lastName = theProfile.lastName;
        thePaymentUpdate.updatePaymentProfile.paymentType = theProfile.paymentType;
        thePaymentUpdate.updatePaymentProfile.accountType = theProfile.accountType;
        thePaymentUpdate.updatePaymentProfile.addressLine1 = theProfile.addressLine1;
        thePaymentUpdate.updatePaymentProfile.addressLine2 = theProfile.addressLine2;
        thePaymentUpdate.updatePaymentProfile.city = theProfile.city;
        thePaymentUpdate.updatePaymentProfile.state = theProfile.state;
        thePaymentUpdate.updatePaymentProfile.zip = theProfile.zip;
        thePaymentUpdate.updatePaymentProfile.phone = theProfile.phone;
        thePaymentUpdate.updatePaymentProfile.month = theProfile.month;
        thePaymentUpdate.updatePaymentProfile.year = theProfile.year;
         thePaymentUpdate.updatePaymentProfile.customerId=Integer.valueof(theProfile.customerId);

        return JSON.serialize(thePaymentUpdate);
    }

}