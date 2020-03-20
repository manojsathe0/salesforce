/*Author : Padma S
 * Story : @B-22215 Kollaborate
 * Date  : 11/14/2017
 * Description: This is the controller class for the IADOrderstatus page. Constructor receives the processingnumber from the page and uses to call the getstatusplan endpoint
 */
global class IADOrderStatusController {

    global static String orderId {get;set;} // Order Id is the processing number    
    public final static string GetStatusPlan ='GetStatusPlan';    
   
   public IADOrderStatusController ()
    {
       orderId = ApexPages.currentPage().getParameters().get('processingNumber');
       // orderId=ApexPages.currentPage().getParameters().get('Id'); 
        System.debug('orderId is '+orderId);
        
    }
    
	//This is a remoting method being invoked by the javascipt from the IADOrderstatus page
    @RemoteAction    
 	global static Map<string, Object> IADorderStatuscontroller1 (String pId)
    {
        Map<string, Object> results; 
        String calloutURL;       
        IADApiGeeEndPoint__mdt cmdt = [select label, Request_Type__c, link__c ,Is_Async__c from IADApiGeeEndPoint__mdt where label ='GetStatusPlan'];
		system.debug('cmdt is '+cmdt);
        calloutURL = ((cmdt.link__c).replace('{referenceValue}',pId)).substringAfter('//');
        system.debug('calloutURl is'+ calloutURL);
        HTTPResponse resp =callApiGee(calloutURL,'',cmdt);
        System.debug('Response code is '+resp.getStatusCode());
        
        if (resp.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
             results = (Map<string, Object>) JSON.deserializeUntyped(resp.getBody());
            
            system.debug('padma results is '+results);   
            System.debug('padma date is'+results.get('orderStatus'));
            
            
            
        }
        
        return results;
    }

    public static HTTPResponse callApiGee(String calloutURL, String payload, IADApiGeeEndPoint__mdt config)
    {
      
        IADApiGeeIntegrationWorker worker = new IADApiGeeIntegrationWorker();
        APIRequestResponseWrapper request = new APIRequestResponseWrapper();
        
        
        String baseURL = IADHelper.getAPIBaseURL();
        worker.reqPayload = payload;
        worker.endPoint = baseURL+calloutURL;
        request.payload =payload;
        request.callURL = worker.endpoint;    
        request.requestType=config.Request_Type__c;
        
        worker.callApiGee(request);
        HTTPResponse result =request.theResponse;
        return result;
    }  
    
}