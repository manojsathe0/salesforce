public with sharing class IADStoreCreditService extends IADServiceBase
{
	
	public final static String GETSTORECREDITSBYSTORECREDITID = 'GetStoreCreditByStoreCreditId';
	public IADContractBeans.IADStoreCreditById storeCredit{get;set;}
  

	public IADStoreCreditService()
	{
		
        super();
       
        List <String> endpoints = new List <String> ();
        endpoints.add(GETSTORECREDITSBYSTORECREDITID);
        initEndpoints(endpoints);
        
	}

    public Object getStoreCreditDetailByStoreCreditId(String storeCreditId) 
    {
        
        String calloutURL = (APItoWrapper.get(GETSTORECREDITSBYSTORECREDITID).endPointConfig.link__c).replace('{storeCreditId}',storeCreditId);
        Object continuationObject = makeRequest(calloutURL, GETSTORECREDITSBYSTORECREDITID, '');

        return continuationObject;
        
     
    }

   public void populateStoreCredit()
   {
      
        try
         {    
            
             initHTTPResponse(GETSTORECREDITSBYSTORECREDITID); //sets the responseData and statusCode on the wrapper
            
             APIRequestResponseWrapper theResponse = APItoWrapper.get(GETSTORECREDITSBYSTORECREDITID);
             
             if(theResponse.checkIsValidResponse())
             {
                 if(theResponse.responseData != null) //Only check this if you need the response body
                 {
           
                     IADContractBeans.IADStoreCreditById deSerializedResponse = (IADContractBeans.IADStoreCreditById) System.JSON.deserialize(theResponse.responseData , IADContractBeans.IADStoreCreditById.class);
                     theResponse.resultObjects =  new List<Object>{deSerializedResponse};
                  
                     if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                     {
                        storeCredit = ( IADContractBeans.IADStoreCreditById)APItoWrapper.get(GETSTORECREDITSBYSTORECREDITID).resultObjects[0];
                        updateDateTime();         
                     }
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
             throw new IADException('Failed displaying Store Credit.'+theException.getMessage() , theException);
         } 
   }

   public void updateDateTime()
   {
       
       storeCredit.storeCredit.adjDateCreated = UtilityLibrary.getIADDateTime(storeCredit.storeCredit.dateCreated);
       storeCredit.storeCredit.adjExpirationDate = UtilityLibrary.getIADDateTime(storeCredit.storeCredit.expriationDate);
       storeCredit.storeCredit.status = IADPaymentTransaction.storeCreditStatusMap.get(Integer.valueOf(storeCredit.storeCredit.storeCreditStatusId));
   }
   
}