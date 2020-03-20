public with sharing class IADHighlightsPanelContactService extends IADServiceBase{
	
	public Boolean hasBoxAccount{get;set;}
	public final static String GETCUSTOMERBYCUSTOMERID = 'GetCustomerByCustomerId';
    public IADContractBeans.IADCustomerBean customer{get;set;}
    public String boxId{get;set;}
    public String oauthToken{get;set;}
    public String userId{get;set;}
    public String appURL{get;set;}
    public String appId{get;set;}
    public Boolean hasSecurityQuestion{get;set;}

	public IADHighlightsPanelContactService() {
		super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETCUSTOMERBYCUSTOMERID);
        initEndpoints(endpoints);
        hasBoxAccount = false;
        hasSecurityQuestion = false;
        populateAppUrlAndAppId();

	}

    public void populateAppUrlAndAppId()
    {
        Map<String,String> appIdToAppURL = IADHelper.getAppIdToAppURL();
        for(String theKey : appIdToAppURL.keySet())
        {
            appId = theKey;
            appURL = appIdToAppURL.get(theKey);
        }
    } 

    
    public Object getCustomerByCustomerId(String customerId)
    {
        String calloutURL = (APItoWrapper.get(GETCUSTOMERBYCUSTOMERID).endPointConfig.link__c).replace('{customerId}',customerId);
        APItoWrapper.get(GETCUSTOMERBYCUSTOMERID).setInfo(APIRequestResponseWrapper.CUSTOMER, customerId);
        Object continuationObject = makeRequest(calloutURL, GETCUSTOMERBYCUSTOMERID, '');
        if(!APItoWrapper.get(GETCUSTOMERBYCUSTOMERID).isAsync)
        {
            populateCustomer();
        }
        return continuationObject;
    }
   
    public void populateCustomer()
    {
        try
        {  
            initHTTPResponse(GETCUSTOMERBYCUSTOMERID);
            
            APIRequestResponseWrapper response = APItoWrapper.get(GETCUSTOMERBYCUSTOMERID);
           
            if(response.checkIsValidResponse())
            {
                if(response.responseData != null)
                {
                    IADContractBeans.IADCustomerBean deSerializedInfo = (IADContractBeans.IADCustomerBean)JSON.deserialize(response.responseData ,IADContractBeans.IADCustomerBean.class);
                    response.resultObjects = new List<IADContractBeans.IADCustomerBean>();
                    response.resultObjects.add(deSerializedInfo);
                    system.debug(' obj' + deSerializedInfo);
                    if(deSerializedInfo != null && !response.resultObjects.isEmpty())
                    {
                        
                        customer = (IADContractBeans.IADCustomerBean)response.resultObjects[0];
                        for(IADContractBeans.IADthirdPartyUserInfoBean theThirdParty : customer.thirdPartyUserInfo)
                        {
                        	if(theThirdParty.thirdPartyTypeId == '8')
                        	{
                        	   boxId = theThirdParty.thirdPartyId;
                        	   userId = theThirdParty.userId;
                        	   hasBoxAccount = true;
                        	   oauthToken = response.theToken;	
                        	}

                        }
                         System.debug('HAHAHA MAMAMA '+customer.securityQuestion);   
                        if(customer.securityQuestion.question != null)
                        {
                            hasSecurityQuestion = true; 
                        }        
           
                        
                    }
                }
                else
                {
                    iadMessages.add(IADMessageFactory.createMessage('error' , 'Null Response. Response Code : '+response.statusCode)); 
                }
            }
            else
            {
            
               iadMessages.add(IADMessageFactory.createMessage('error' , 'Invalid Response. Response Code : '+response.statusCode + ' Message Body :  '+response.errorMessage)); 
            }
                    
        }
        catch(Exception theException)
        {
            throw new IADException('Failed displaying  Box Account Info.'+theException.getMessage() , theException);
        } 
    }
}