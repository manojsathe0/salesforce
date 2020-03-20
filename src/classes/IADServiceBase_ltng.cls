public virtual class IADServiceBase_ltng
{
    public static Map<String, APIRequestResponseWrapper_ltng> APItoWrapper{get;set;} 
    public static Map<String,IADApiGeeEndPoint__mdt> APItoEndpoint{get;set;}
    public static Map<String,Boolean> APItoAsync{get;set;}
    public static List<IADMessage_ltng> iadMessages{get;set;}
    public static IADApiGeeIntegrationWorker_ltng worker {get;set;}
    public static Integer errorCount;
    
    public IADServiceBase_ltng()
    {
        system.debug('in super class constructor: ');
        APItoWrapper = new Map<String, APIRequestResponseWrapper_ltng> ();
        APItoEndpoint = new Map<String,IADApiGeeEndPoint__mdt>();
        APItoAsync = new Map<String,Boolean>();
        iadMessages = new List<IADMessage_ltng>();
        worker = new IADApiGeeIntegrationWorker_ltng();
        errorCount = 0;
    }

    public static Boolean sendEmail
    {
        get
        {
            Error_Email_Config__mdt[]  errorEmailConfig = [select label, Email_Send__c from Error_Email_Config__mdt where label = 'Team Email Config'];
            if(!errorEmailConfig.isEmpty()) 
                sendEmail = errorEmailConfig[0].Email_Send__c;
            return sendEmail;
        }
        set;
    }
    
    public Static void initEndpoints(List<String> endpoints)
    {
        IADApiGeeEndPoint__mdt[] endPointConfig = [select label, Request_Type__c, link__c ,Is_Async__c from IADApiGeeEndPoint__mdt where label in: endpoints];

        system.debug('endPointConfig ' + endPointConfig);
        for(IADApiGeeEndPoint__mdt theEndpoint : endPointConfig)
        {
            APItoEndpoint.put(theEndpoint.label , theEndpoint);
            APItoAsync.put(theEndpoint.label, theEndpoint.Is_Async__c);
        }   
    }
    
    public static void initWrapper(String endpointLabel)
    {
        system.debug('endpointLabel is '+endpointLabel);
        APIRequestResponseWrapper_ltng theWrapper = new APIRequestResponseWrapper_ltng();
        theWrapper.endPointConfig = APItoEndpoint.get(endpointLabel);
        theWrapper.isAsync = APItoAsync.get(endpointLabel);
        APItoWrapper.put(endpointLabel, theWrapper);
        system.debug('APItoWrapper: '+APItoWrapper);
    }     

    //new makeRequestMulti method for lightning
    public Static void makeRequestMulti(String calloutURL, String endpointLabel, String payload)
    {
        system.debug('callouturl: inside makeRequestMulti ' + calloutURL);
        system.debug('endpointLabel: inside makeRequestMulti ' + endpointLabel);
        system.debug('payload: inside makeRequestMulti ' + payload); 
        
        String baseURL = IADHelper_ltng.getAPIBaseURL();
        worker.reqPayload = payload;
        worker.endPoint = baseURL+calloutURL;
        
        APIRequestResponseWrapper_ltng request = APItoWrapper.get(endpointLabel);
        request.payload = payload;
        request.callURL = worker.endpoint;

        worker.callApiGee(request);         
    }
    
    @AuraEnabled
    public static void clearMessages()
    {
        errorCount = 0;
        iadMessages.clear();
    }
    public Integer getErrorCount()
    {
        return errorCount;
    }
    public Map<String, APIRequestResponseWrapper_ltng> getAPItoWrapper()
    {
        return APItoWrapper;
    }
    public Map<String,IADApiGeeEndPoint__mdt> getAPItoEndpoint()
    {
        return APItoEndpoint;
    }
    public Map<String,Boolean> getAPItoAsync()
    {
        return APItoAsync;
    }
    public List<IADMessage_ltng> getIadMessages()
    {
        return iadMessages;
    }
    public static void populateSuccessMessage(String theSuccess)
    {
        iadMessages.add(IADMessageFactory_ltng.createMessage('success' , theSuccess));  
        system.debug('Success : ' + theSuccess);
    }
      
    public static void populateErrorMessage(String theException)
    {
        errorCount++;
        iadMessages.add(IADMessageFactory_ltng.createMessage('error' , theException));  
        system.debug('Manual Exception : ' + theException);
    }
    
    public static void populateErrorMessage(IADException theException)
    {
        errorCount++;
        iadMessages.add(IADMessageFactory_ltng.createMessage('error' , theException.getMessage()));  
        system.debug('IADException : ' + theException.getMessage());
        if(sendEmail)
            SendExceptionEmail_ltng.sendIADExceptionEmail(theException , 'IAD Exception');
    }
    
    public static void populateErrorMessage(Exception theException)
    {
        errorCount++;
        iadMessages.add(IADMessageFactory_ltng.createMessage('error' , theException.getMessage() +  theException.getStackTraceString()));   
        system.debug('Exception : ' + theException.getMessage() +  theException.getStackTraceString());
        if(sendEmail)
            SendExceptionEmail_ltng.sendExceptionEmail(theException , 'IAD Exception');
    }
    
    public static void populateErrorMessage(APIRequestResponseWrapper_ltng  theResponse)
    {
        errorCount++;
        iadMessages.add(IADMessageFactory_ltng.createMessage('error' , 'Invalid Response. Response Code : '+theResponse.statusCode + ' Message Body :  '+theResponse.errorMessage)); 
        system.debug('API Exception : ' + 'Invalid Response. Response Code : '+theResponse.statusCode + ' Message Body :  '+theResponse.errorMessage);
        if(sendEmail)
            SendExceptionEmail_ltng.sendIADRequestResponseEmail(theResponse , 'Invalid Response');
    }
    
    public static void populateNullErrorMessage(APIRequestResponseWrapper_ltng  theResponse)
    {
        errorCount++;
        iadMessages.add(IADMessageFactory_ltng.createMessage('error' , 'Null Response. Response Code : '+theResponse.statusCode));
        system.debug('API Null Exception : ' + 'Null Response. Response Code : '+theResponse.statusCode);
        if(sendEmail)
            SendExceptionEmail_ltng.sendIADRequestResponseEmail(theResponse , 'Null Response');
    }
    public void addMessages(List<IADMessage_ltng> messages, Integer count)
    {
        iadMessages.addAll(messages);
        errorCount = errorCount + count;
    }
}