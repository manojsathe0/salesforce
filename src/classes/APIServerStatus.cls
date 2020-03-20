public class APIServerStatus
{
    public Transient APIRequestResponseWrapper apiResponse{get;set;}
    
    public List<CalloutTest> calloutTests{get;set;}
    public String endpoint{get;set;}
    public String label{get;set;}
    public Integer responseCode{get;set;}
    
    public APIServerStatus() 
    {
        //hardcoded for now
        calloutTests = new List<CalloutTest>();

    }
    public Object makeCallout()
    {
        Object continuationObject;
        
        system.debug('label ' + label);
        
        List<IADApiGeeEndPoint__mdt> endPointMDT = [select label, link__c ,Request_Type__c from IADApiGeeEndPoint__mdt where label=:label limit 1];

        if(endPointMDT.size() > 0 && endPointMDT[0] != null){
            CalloutTest c = new CalloutTest();
            c.link = endpoint;
            system.debug('here');
            c.endPointConfig = endPointMDT[0];
            continuationObject =  executeGet(c);
        }
        return continuationObject;
    }
    public Object executeGet(CalloutTest c)
    {

        Continuation continuationObject;
        try{

            apiResponse = new APIRequestResponseWrapper();
            IADApiGeeIntegrationWorker worker = new IADApiGeeIntegrationWorker();
            
            worker.endPoint = c.link;
            system.debug('endpoint ' + c.link);
            Boolean isAsync = true;
            apiResponse.callBackMethod = 'processResponse';
            apiResponse.endPointConfig = c.endpointConfig;
            system.debug('here1');
            continuationObject = new Continuation(40);
            worker.callApiGeeAsync(continuationObject, apiResponse);
            
            system.debug('here2');

            responseCode = 0;
        }
        catch(Exception e){
            responseCode = 0;

            system.debug('here error');
            return continuationObject;
        }
        return continuationObject;
    }
    public class CalloutTest
    {
        public String link{get;set;}
        public IADApiGeeEndPoint__mdt endpointConfig{get;set;}
    }
    
    // Callback method for Asynchronous
    public Object processResponse() 
    {   
      
      HttpResponse response = Continuation.getResponse(apiResponse.requestLabelContinuation);
      String responseString= response.getBody();
      responseCode = response.getStatusCode();

        system.debug('responseCode ' + responseCode);
     //dataService.populateSecurityQuestion(responseString);
     // if(dataService.hasSecurityQuestion)
         // securityQuestion = ( List<IADContractBeans.IADSecurityQuestionBean>)dataService.apiResponse.resultObjects; 
      
      system.debug('responseString ' + responseString);
      
      return null;
    }
}