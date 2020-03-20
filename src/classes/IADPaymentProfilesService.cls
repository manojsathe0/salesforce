public class IADPaymentProfilesService extends IADServiceBase
{
    public final static String GETPROFILESBYUSERID = 'GetProfilesByUserId';
    public List<IADContractBeans.IADPaymentProfileBean> profiles{get;set;}
    public List<IADContractBeans.IADPaymentProfileBean> allProfiles{get;set;}

    public Boolean hasPaymentProfiles {get;set;}

    public IADPaymentProfilesService()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETPROFILESBYUSERID);
        initEndpoints(endpoints);
        hasPaymentProfiles = false;
        profiles = new List<IADContractBeans.IADPaymentProfileBean>();
        allProfiles =  new List<IADContractBeans.IADPaymentProfileBean>();

    }
    public Object getPaymentProfilesByUserId(String userId)
    {
        String calloutURL = APItoWrapper.get(GETPROFILESBYUSERID).endPointConfig.link__c+userId;
        APItoWrapper.get(GETPROFILESBYUSERID).setInfo(APIRequestResponseWrapper.CUSTOMER, userId);
        Object continuationObject = makeRequest(calloutURL, GETPROFILESBYUSERID, '');

        return continuationObject;
    }
    public Object getPaymentProfilesByUserId(Object continuationObject, String userId)
    {
        String calloutURL = APItoWrapper.get(GETPROFILESBYUSERID).endPointConfig.link__c+userId;
        APItoWrapper.get(GETPROFILESBYUSERID).setInfo(APIRequestResponseWrapper.CUSTOMER, userId);
        continuationObject = makeRequestMulti(continuationObject, calloutURL, GETPROFILESBYUSERID, '');

        return continuationObject;
    }
    //do any manipulation of data as needed
    public void populateProfiles()
    {
        APIRequestResponseWrapper response = APItoWrapper.get(GETPROFILESBYUSERID);
        try
        {
            profiles.clear();
            allProfiles.clear();
            if(response.responseData != null)
            {
                if(response.checkIsValidResponse()) {
                    IADContractBeans.IADPaymentProfiles deSerializedpayments = (IADContractBeans.IADPaymentProfiles) JSON.deserialize(response.responseData, IADContractBeans.IADPaymentProfiles.class);
                    system.debug('deSerializedpayments ' + deSerializedpayments);
                    if (deSerializedpayments != null) {
                        system.debug('deSerializedpayments.paymentProfiles ' + deSerializedpayments.paymentProfiles);
                        response.resultObjects = deSerializedpayments.paymentProfiles;
                        for (IADContractBeans.IADPaymentProfileBean bean : deSerializedpayments.paymentProfiles) {
                            bean.adjCreationDate = UtilityLibrary.parseIADDateTime(bean.dateCreated);
                            if (bean.isActive)
                                profiles.add(bean);
                            allProfiles.add(bean);
                        }
                        system.debug('profiles ' + profiles);
                        hasPaymentProfiles = true;
                    }
                }
                else
                {
                    populateErrorMessage(response);
                }
            }
            else
            {
                populateNullErrorMessage(response);
            }
        }
        catch(Exception theException)
        {
            populateErrorMessage(theException);
        }
    }
}