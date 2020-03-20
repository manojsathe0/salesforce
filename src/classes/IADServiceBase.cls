public virtual class IADServiceBase
{
    public Map<String, APIRequestResponseWrapper> APItoWrapper{get;set;}
    public Map<String,IADApiGeeEndPoint__mdt> APItoEndpoint{get;set;}
    public Map<String,Boolean> APItoAsync{get;set;}
    public List<IADMessage> iadMessages{get;set;}
    public IADApiGeeIntegrationWorker worker {get;set;}
    public Integer errorCount;
    
    public IADServiceBase()
    {
        APItoWrapper = new Map<String, APIRequestResponseWrapper> ();
        APItoEndpoint = new Map<String,IADApiGeeEndPoint__mdt>();
        APItoAsync = new Map<String,Boolean>();
        iadMessages = new List<IADMessage>();
        worker = new IADApiGeeIntegrationWorker();
        errorCount = 0;
    }

    public Boolean sendEmail
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
    public void initEndpoints(List<String> endpoints)
    {
        IADApiGeeEndPoint__mdt[] endPointConfig = [select label, Request_Type__c, link__c ,Is_Async__c from IADApiGeeEndPoint__mdt where label in: endpoints];

        system.debug('endPointConfig ' + endPointConfig);
        for(IADApiGeeEndPoint__mdt theEndpoint : endPointConfig)
        {
            APItoEndpoint.put(theEndpoint.label , theEndpoint);
            APItoAsync.put(theEndpoint.label, theEndpoint.Is_Async__c);
        }   
    }
    public void initWrapper(String endpointLabel, String callBackMethod)
    {
        APIRequestResponseWrapper theWrapper = new APIRequestResponseWrapper();
        theWrapper.endPointConfig = APItoEndpoint.get(endpointLabel);
        theWrapper.callBackMethod = callBackMethod;
        theWrapper.isAsync = APItoAsync.get(endpointLabel);
        APItoWrapper.put(endpointLabel, theWrapper);

    }
    public Object makeRequest(String calloutURL, String endpointLabel, String payload)
    {
        Continuation continuationObject = new Continuation(40); 
        system.debug('callouturl ' + calloutURL);
        
        String baseURL = IADHelper.getAPIBaseURL();
        worker.reqPayload = payload;
        worker.endPoint = baseURL+calloutURL;
        
        APIRequestResponseWrapper request = APItoWrapper.get(endpointLabel);
        request.payload = payload;
        request.callURL = worker.endpoint;
        if(request.isAsync)
        {
            continuationObject =  new Continuation(40);
            worker.callApiGeeAsync(continuationObject , request);           
        }
        else
        {
            worker.callApiGee(request);
            continuationObject = null;
        }
        
        
        return continuationObject;
    }
    public Object makeRequestMulti(Object continuationObject, String calloutURL, String endpointLabel, String payload)
    {
        system.debug('callouturl ' + calloutURL);
        
        String baseURL = IADHelper.getAPIBaseURL();
        worker.reqPayload = payload;
        worker.endPoint = baseURL+calloutURL;
        
        APIRequestResponseWrapper request = APItoWrapper.get(endpointLabel);
        request.payload = payload;
        request.callURL = worker.endpoint;
        worker.callApiGeeAsync((Continuation)continuationObject , request); 
        
        
        return continuationObject;
    }
    public void initHTTPResponse(String endpointLabel)
    {
        APIRequestResponseWrapper response = APItoWrapper.get(endpointLabel);
        if(response.isAsync)
        {
            HttpResponse httpResponse = Continuation.getResponse(response.requestLabelContinuation);
            response.responseData = httpResponse.getBody();
            response.statusCode = httpResponse.getStatusCode()+'';
            String accessToken = response.theToken;
            if(response.isNewToken)
                IADHelper.saveAccessToken(accessToken);
        }
        
    }
    public void clearMessages()
    {
        errorCount = 0;
        iadMessages.clear();
    }
    public Integer getErrorCount()
    {
        return errorCount;
    }
    public Map<String, APIRequestResponseWrapper> getAPItoWrapper()
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
    public List<IADMessage> getIadMessages()
    {
        return iadMessages;
    }
    public void populateSuccessMessage(String theSuccess)
    {
        iadMessages.add(IADMessageFactory.createMessage('success' , theSuccess));  
        system.debug('Success : ' + theSuccess);
    }
      
    public void populateErrorMessage(String theException)
    {
        errorCount++;
        iadMessages.add(IADMessageFactory.createMessage('error' , theException));  
        system.debug('Manual Exception : ' + theException);
        //if(sendEmail)
        //SendExceptionEmail.sendGenericErrorEmal(theException , 'IAD Exception');
    }
    
    public void populateErrorMessage(IADException theException)
    {
        errorCount++;
        iadMessages.add(IADMessageFactory.createMessage('error' , theException.getMessage()));  
        system.debug('IADException : ' + theException.getMessage());
        if(sendEmail)
            SendExceptionEmail.sendIADExceptionEmail(theException , 'IAD Exception');
    }
    
    public void populateErrorMessage(Exception theException)
    {
        errorCount++;
        iadMessages.add(IADMessageFactory.createMessage('error' , theException.getMessage() +  theException.getStackTraceString()));   
        system.debug('Exception : ' + theException.getMessage() +  theException.getStackTraceString());
        if(sendEmail)
            SendExceptionEmail.sendExceptionEmail(theException , 'IAD Exception');
    }
    
    public void populateErrorMessage(APIRequestResponseWrapper  theResponse)
    {
        errorCount++;
        iadMessages.add(IADMessageFactory.createMessage('error' , 'Invalid Response. Response Code : '+theResponse.statusCode + ' Message Body :  '+theResponse.errorMessage)); 
        system.debug('API Exception : ' + 'Invalid Response. Response Code : '+theResponse.statusCode + ' Message Body :  '+theResponse.errorMessage);
        if(sendEmail)
            SendExceptionEmail.sendIADRequestResponseEmail(theResponse , 'Invalid Response');
    }
    
    public void populateNullErrorMessage(APIRequestResponseWrapper  theResponse)
    {
        errorCount++;
        iadMessages.add(IADMessageFactory.createMessage('error' , 'Null Response. Response Code : '+theResponse.statusCode));
        system.debug('API Null Exception : ' + 'Null Response. Response Code : '+theResponse.statusCode);
        if(sendEmail)
            SendExceptionEmail.sendIADRequestResponseEmail(theResponse , 'Null Response');
    }
    public void addMessages(List<IADMessage> messages, Integer count)
    {
        iadMessages.addAll(messages);
        errorCount = errorCount + count;
    }
}