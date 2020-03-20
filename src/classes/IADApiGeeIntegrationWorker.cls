public without sharing class IADApiGeeIntegrationWorker
{

    public static string accessToken {get;Set;}
    public string reqPayload = '';
    public string endPoint = '';
    public String requestLabel;
    public static string userId{get;set;}
    public static String isNew = 'No';
    
    public IADApiGeeIntegrationWorker(){}
  
    public static void getApiGeeToken()
    {
        System.debug ('----------------------------Entering Get Token Method---------------------------');
        userId = UserInfo.getUserId(); // Current User Id
        //Check if SF has an active token code for this User
        APIGEE_ACCESS_TOKEN__c[] accToken = [select Access_Token__c from APIGEE_ACCESS_TOKEN__c where User_Id__c=:userId and Last_Token_Time__c >= :System.now().addMinutes(-25)];
        
        if (accToken.size() == 0)
        {
            string oauthTokenURL = '';
            string payloadToken = '';
            HttpRequest reqToken = new HttpRequest();
            //Get Client ID and Security Key params 
            IAD_API_Base_URL__mdt[] tokenKeys1 = [select ClientID_SecurityKey__c,link__c from IAD_API_Base_URL__mdt where DeveloperName = :IADHelper.getEnvironmentName()];
            oauthTokenURL = IADHelper.getAPIBaseURL()+tokenKeys1[0].link__c;
            payloadToken = tokenKeys1[0].ClientID_SecurityKey__c;
            System.debug('EndPoint to get auth token: '+oauthTokenURL);
            System.debug('Payload input:'+payloadToken);
            // Set the header 
            reqToken.setEndpoint(oauthTokenURL);
            reqtoken.setHeader('Content-Type', IADConstants.CONTENTTYPE_URL);
            reqtoken.setHeader('Content-Length', IADConstants.CONTENTLENGTH);
            reqtoken.setMethod('POST');
            reqtoken.setTimeout(IADConstants.TIMEOUT);
            reqtoken.setBody(payloadToken);
            // Make HTTP request call and get the token response
            try
            {
                Http http = new Http();
                HttpResponse resTokenBody;
                resTokenBody = http.send(reqToken);
                String responseData = resTokenBody.getBody();
                
                Integer statusCode = resTokenBody.getStatusCode();
                if(statusCode == 200)
                { 
                    IADContractBeans.OauthToken oauthToken = (IADContractBeans.OauthToken) JSON.deserialize(responseData ,IADContractBeans.OauthToken.class);
                    accessToken = oauthToken.access_token;
                }
                else if(statusCode == 401) //Unauthorized
                {
                    IADContractBeans.OauthError oauthError = (IADContractBeans.OauthError) JSON.deserialize(responseData ,IADContractBeans.OauthError.class);
                    throw new IADException('Couldn\'t get valid Access Token '+oauthError.Error);
                    
                }
               
            }
            catch(System.CalloutException e)
            {
                system.debug('There was an error parsing the JSON response');
                System.debug('ERROR-------------------------------------: ' + e);
                throw new IADException(
                'Couldn\'t make Call Out to get Access Token'+e.getMessage(), e);
            }
            isNew = 'Yes';
                    
        }
        else
        {
        
            accessToken = accToken[0].Access_Token__c;
                        
        }
        
        
      
    }

   

    public void callApiGee(APIRequestResponseWrapper apiRequestResponse)
    {
        System.debug('Inside caller to ApiGee');
       
        String ApiGeeResponse; 
        if(!Test.isRunningTest())
            getApiGeeToken();
        
        apiRequestResponse.theToken = accessToken;
        HttpRequest req = new HttpRequest();
        String authString = 'Bearer ' + accessToken;
        //Set the payload and the content type based on apiRequestWrapper
        req.setHeader('Accept','*/*'); // This is required to set else Salesforce will add Accept headers and API doesn't work
        if(apiRequestResponse.requestType == 'POST' || apiRequestResponse.requestType == 'PUT' || apiRequestResponse.requestType == 'PATCH')
        {
    
             req.setHeader('Content-Type', IADConstants.CONTENTTYPE_JSON);
             req.setBody(reqPayload);
        }
        
        system.debug('endpoint + ' + endpoint);
        req.setMethod(apiRequestResponse.requestType); 
        req.setEndpoint(endPoint);
        req.setHeader('Authorization', authString);
        req.setTimeout(12000);
       
        // Make the API call
      
        try
        {
            Http http = new Http();
            HttpResponse res1;
            res1 = http.send(req);
            
            apiRequestResponse.theResponse = res1;
            apiRequestResponse.responseData = res1.getBody();
            apiRequestResponse.statusCode = res1.getStatusCode()+'';
            if(isNew == 'Yes')
               IADHelper.saveAccessToken(accessToken);
        }
        catch(System.CalloutException e)
        {
           throw new IADException(
                'Couldn\'t make Call Out '+e.getMessage(), e);
            
        }
        
            
        
    }
    
    public void callApiGeeAsync(Continuation con , APIRequestResponseWrapper apiRequestResponse)
    {
            
        con.continuationMethod = apiRequestResponse.callBackMethod;
        if(!Test.isRunningTest())
            getApiGeeToken();
        //Prepare the call for the API identified
        apiRequestResponse.theToken = accessToken;
        HttpRequest req = new HttpRequest();
        String authString = 'Bearer ' + accessToken;
        req.setHeader('Accept','*/*');
        
        if(apiRequestResponse.requestType == 'POST' || apiRequestResponse.requestType == 'PUT' || apiRequestResponse.requestType == 'PATCH')
        {
             req.setHeader('Content-Type', IADConstants.CONTENTTYPE_JSON);
             req.setBody(reqPayload);

        }
        
        system.debug('endpoint + ' + endpoint);
        req.setMethod(apiRequestResponse.requestType); 
        system.debug('request type ' + apiRequestResponse.requestType);
        req.setEndpoint(endPoint);
        req.setHeader('Authorization', authString);
        req.setTimeout(IADConstants.TIMEOUT);
       
        system.debug('req body '  + req.getbody());
        try
        {
            apiRequestResponse.requestLabelContinuation = con.addHttpRequest(req);
            if(isNew == 'Yes') //Only set this if you got new accessToken
            {
                apiRequestResponse.isNewToken = true;
                //Actual updating/inserting of token happens in IADServiceBase class for async call becaause of DML issue during
                //the call.Happnes once the callback returns.
            }
        }
        catch(System.CalloutException e)
        {
             throw new IADException(
                'Couldn\'t make Call Out '+e.getMessage(), e);
        }
        catch(Exception e){
            system.debug('general exception ' + e.getMessage());
        }
   
    }     
  
}