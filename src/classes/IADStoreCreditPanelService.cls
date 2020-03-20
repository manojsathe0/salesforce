public with sharing class IADStoreCreditPanelService extends IADServiceBase
{
	
	public Boolean hasStoreCredit{get;set;}
	public final static String GETSTORECREDITSBYCUSTOMERID = 'GetStoreCreditsByCustomerId';
	public IADContractBeans.IADStoreCredit storeCredit{get;set;}

	public IADStoreCreditPanelService()
	{
		super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETSTORECREDITSBYCUSTOMERID);
        initEndpoints(endpoints);
        hasStoreCredit = false;
	}

    public Object getStoreCreditsByCustomerId(String customerId) 
    {
        
        String calloutURL = (APItoWrapper.get(GETSTORECREDITSBYCUSTOMERID).endPointConfig.link__c).replace('{customerId}',customerId);
        APItoWrapper.get(GETSTORECREDITSBYCUSTOMERID).setInfo(APIRequestResponseWrapper.CUSTOMER, customerId);
        Object continuationObject = makeRequest(calloutURL, GETSTORECREDITSBYCUSTOMERID, '');
        
        return continuationObject;
        
     
    }

   public void populateStoreCredits()
   {
      
        try
         {    
            
             initHTTPResponse(GETSTORECREDITSBYCUSTOMERID); //sets the responseData and statusCode on the wrapper
            
             APIRequestResponseWrapper theResponse = APItoWrapper.get(GETSTORECREDITSBYCUSTOMERID);
             
             if(theResponse.checkIsValidResponse())
             {
                 if(theResponse.responseData != null && theResponse.responseData!='') //Only check this if you need the response body
                 {
                    system.debug('theResponse.responseData ' + theResponse.responseData);
                     IADContractBeans.IADStoreCredit deSerializedResponse = (IADContractBeans.IADStoreCredit) System.JSON.deserialize(theResponse.responseData , IADContractBeans.IADStoreCredit.class);
                     theResponse.resultObjects =  new List<Object>{deSerializedResponse};
                  
                     if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                     {
                         hasStoreCredit = true;
                         storeCredit = ( IADContractBeans.IADStoreCredit)APItoWrapper.get(GETSTORECREDITSBYCUSTOMERID).resultObjects[0];
                     }
                 }
                 else if(theResponse.responseData == null || theResponse.responseData=='')
                 {
                     hasStoreCredit = false;
                 }
                 else
                 {
                     populateNullErrorMessage(theResponse);
                                     
                 }
             }
             else
             {
                  populateErrorMessage(theResponse);
                         
             }
             
            
         }
         
         catch(Exception theException)
         {
             throw new IADException('Failed displaying Store Credits.'+theException.getMessage() , theException);
         } 
   }
   
}