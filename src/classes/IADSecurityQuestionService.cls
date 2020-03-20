public class IADSecurityQuestionService extends IADServiceBase
{
    
    public Boolean hasSecurityQuestion{get;set;}
    public final static String GETSECURITYQUESTIONBYCUSTOMERID = 'GetSecurityQuestionByCustomerId';
    public List<IADContractBeans.IADSecurityQuestionBean> securityQuestion{get;set;}
    
    public IADSecurityQuestionService()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETSECURITYQUESTIONBYCUSTOMERID);
        initEndpoints(endpoints);
        hasSecurityQuestion = false;
    }
    public Object getSecurityQuestionByCustomerId(String customerId)
    {
      
        String calloutURL = (APItoWrapper.get(GETSECURITYQUESTIONBYCUSTOMERID).endPointConfig.link__c)+customerId;
        APItoWrapper.get(GETSECURITYQUESTIONBYCUSTOMERID).setInfo(APIRequestResponseWrapper.CUSTOMER, customerId);
        Object continuationObject = makeRequest(calloutURL, GETSECURITYQUESTIONBYCUSTOMERID, '');
        if(!APItoWrapper.get(GETSECURITYQUESTIONBYCUSTOMERID).isAsync)
        {
            populateSecurityQuestion();
        }
        return continuationObject;
    }
   
    public void populateSecurityQuestion()
    {
        try
        {  
            initHTTPResponse(IADSecurityQuestionService.GETSECURITYQUESTIONBYCUSTOMERID);
            
            APIRequestResponseWrapper response = APItoWrapper.get(GETSECURITYQUESTIONBYCUSTOMERID);
           
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null)
                {
                    IADContractBeans.IADSecurityQuestionBean deSerializedSecurity = (IADContractBeans.IADSecurityQuestionBean) JSON.deserialize(response.responseData ,IADContractBeans.IADSecurityQuestionBean.class);
                    response.resultObjects = new List<IADContractBeans.IADSecurityQuestionBean>();
                    response.resultObjects.add(deSerializedSecurity);
                    system.debug(' obj' + deSerializedSecurity);
                    if(deSerializedSecurity != null && !response.resultObjects.isEmpty())
                    {
                        hasSecurityQuestion = true;
                        securityQuestion = ( List<IADContractBeans.IADSecurityQuestionBean>)APItoWrapper.get(GETSECURITYQUESTIONBYCUSTOMERID).resultObjects; 
              
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
            throw new IADException('Failed displaying Security Question.'+theException.getMessage() , theException);
        } 
    }
}