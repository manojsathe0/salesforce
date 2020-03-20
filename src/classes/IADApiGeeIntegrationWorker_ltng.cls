public without sharing class IADApiGeeIntegrationWorker_ltng
{

    public static string accessToken {get;Set;}
    public string reqPayload = '';
    public string endPoint = '';
    public String requestLabel;
    public static string userId{get;set;}
    public static String isNew = 'No';
    public static Map<Datetime, String> mapCurrentToken = new Map<Datetime, String>();
    
    public IADApiGeeIntegrationWorker_ltng(){}
  
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
                system.debug('before callout');
                system.debug('reqToken' +reqToken);
                system.debug('payloadToken' +payloadToken);
                Http http = new Http();
                
                HttpResponse resTokenBody;
                resTokenBody = http.send(reqToken);
                system.debug('Responetoken ' +resTokenBody);
                String responseData = resTokenBody.getBody();
                system.debug('response resTokenBody' +responseData);
                
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

    //This Generates new Token every 25minues.
    //Used only for DNC, from DNC_checkDNCList_Schedule.cls or DNC_CheckDNCList_Batch.cls
    public static void getApiGeeTokenDNC() {
        Boolean requiresNewToken = true;
        if (!mapCurrentToken.isEmpty()) {
            requiresNewToken = false;
            for (DateTime dt : mapCurrentToken.keySet()) {
                if (dt <= System.now().addMinutes(-25))         //Existing Token is older than 25mins, then requires a new Token
                    requiresNewToken = true;
            }
        }

        if (requiresNewToken) {
            mapCurrentToken.clear();                            //Clear existing map contains Token
            if (!Test.isRunningTest())
                getApiGeeToken();                                   //Get new Token
            mapCurrentToken.put(System.Now(), accessToken);
        } else
            accessToken = mapCurrentToken.values()[0];          //If Token is not older than 25mins, then take the previous token
    }

    public void callApiGee(APIRequestResponseWrapper_ltng apiRequestResponse)
    {
        System.debug('Inside caller to ApiGee');
       
        String ApiGeeResponse; 
        if (!Test.isRunningTest()) {
            if (endpoint.contains('v1/do-not-call/scrub?phoneNumber=') || endpoint.contains('v1/do-not-call/private-do-not-call'))
                getApiGeeTokenDNC();
            else
                getApiGeeToken();
        }
        
        apiRequestResponse.theToken = accessToken;
        HttpRequest req = new HttpRequest();
        String authString = 'Bearer ' + accessToken;
        //Set the payload and the content type based on apiRequestWrapper
        req.setHeader('Accept','*/*'); // This is required to set else Salesforce will add Accept headers and API doesn't work
        
        if(apiRequestResponse.requestType == 'POST' || apiRequestResponse.requestType == 'PUT' || apiRequestResponse.requestType == 'PATCH' || apiRequestResponse.requestType == 'DELETE')
        {
    
            req.setHeader('Content-Type', IADConstants.CONTENTTYPE_JSON);
            //Check if The Rest Resource is For Lead , if it is then add then add X-LZ-Api-Key in header
            if(endpoint.contains('attribution/uuid')){
                //query the api key from LZ_Config__mdt meta data type
                LZ_Config__mdt lzpaikey = [select x_lz_apikey__c from LZ_Config__mdt where MasterLabel ='LeadUUIDApiKey' limit 1];
                req.setHeader('X-LZ-Api-Key', lzpaikey.x_lz_apikey__c);
            }
            req.setBody(reqPayload);
        }
        
        if(endpoint.contains('subscriptionadjustment/scheduledUpgrades/') && endpoint.contains('/cancel')){
            req.setHeader('x-lz-modifiedBy', userInfo.getUserName().substringBefore('@'));
        }
        
        system.debug('endpoint + ' + endpoint);
        req.setMethod(apiRequestResponse.requestType); 
        req.setEndpoint(endPoint);
        req.setHeader('Authorization', authString);
        req.setTimeout(IADConstants.TIMEOUT);
       
        // Make the API call
      
        try
        {
            Http http = new Http();
            HttpResponse res1;
            res1 = http.send(req);
            
            apiRequestResponse.theResponse = res1;
            system.debug('Response -----------------> Body');
            system.debug(res1.getBody());
            apiRequestResponse.responseData = res1.getBody();
            apiRequestResponse.statusCode = res1.getStatusCode()+'';
            if(isNew == 'Yes')
            {    
              // IADHelper_ltng.saveAccessToken(accessToken);
            }
        }
        catch(System.CalloutException e)
        {
           throw new IADException('Couldn\'t make Call Out '+e.getMessage(), e);
        }      
    }   
}