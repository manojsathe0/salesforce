public class IADContactHistoryService extends IADServiceBase
{
    public Boolean hasHistory{get;set;}
    public IADContractBeans.IADCustomerHistoryBean customerHistory{get;set;}   
    public final static String GETCONTACTHISTORYBYCUSTID = 'GetContactHistoryByCustId';

    public IADContactHistoryService()
    {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(GETCONTACTHISTORYBYCUSTID);
        initEndpoints(endpoints);
        hasHistory = false;
    }

    public Object getContactHistoryByCustId(String customerId) 
    {
        String calloutURL = (APItoWrapper.get(GETCONTACTHISTORYBYCUSTID).endPointConfig.link__c).replace('{customerId}',customerId);
        APItoWrapper.get(GETCONTACTHISTORYBYCUSTID).setInfo(APIRequestResponseWrapper.CUSTOMER, customerId);
        Object continuationObject = makeRequest(calloutURL, GETCONTACTHISTORYBYCUSTID, '');
        if(!APItoWrapper.get(GETCONTACTHISTORYBYCUSTID).isAsync)
        {
            populateHistory();
        }
        return continuationObject;
        
     
    }

   public void populateHistory()
   {
      
        try
         {    
            
             initHTTPResponse(GETCONTACTHISTORYBYCUSTID); //sets the responseData and statusCode on the wrapper
            
             APIRequestResponseWrapper contactHistoryResponse = APItoWrapper.get(GETCONTACTHISTORYBYCUSTID);
             
             if(contactHistoryResponse.checkIsValidResponse())
             {
                 if(contactHistoryResponse.responseData != null) //Only check this if you need the response body
                 {
           
                     IADContractBeans.IADCustomerHistoryBean deSerializedHistory = (IADContractBeans.IADCustomerHistoryBean) System.JSON.deserialize(contactHistoryResponse.responseData , IADContractBeans.IADCustomerHistoryBean.class);
                     contactHistoryResponse.resultObjects =  new List<Object>{deSerializedHistory};
                  
                     if(contactHistoryResponse.resultObjects != null && !contactHistoryResponse.resultObjects.isEmpty())
                     {
                         hasHistory = true;
                         customerHistory = ( IADContractBeans.IADCustomerHistoryBean)APItoWrapper.get(GETCONTACTHISTORYBYCUSTID).resultObjects[0];
                         changeModifiedDate();
                         customerHistory.customerHistories.sort();                 
                     }
                     system.debug('customerHistory-->');
                     system.debug(customerHistory);
                 }
                 else
                 {
                     populateNullErrorMessage(contactHistoryResponse);
                 }
             }
             else
             {
                  populateErrorMessage(contactHistoryResponse);
             }
         }
         catch(Exception theException)
         {
             throw new IADException('Failed displaying customer history.'+theException.getMessage() , theException);
         } 
   }
   
    public void changeModifiedDate()
    {
        for(IADContractBeans.IADCustomerHistory thehistory : customerHistory.customerHistories)
        {
            thehistory.adjDateModified = UtilityLibrary.getIADDateTime(thehistory.dateModified);
            thehistory.adjDateModifiedDT = UtilityLibrary.getIADDateTimeDT(thehistory.dateModified);
            if(thehistory.description.contains('Email Password Request Link'))
            {    
                String target = '\nhttps % 3A % 2F % 2Fwww.legalzoom.com % 2FLZWeb % 2FWelcome % 2FPasswordReset.aspx % 3FPwdResetRequest % 3D ';
                String replacement = ' https://www.legalzoom.com/LZWeb/Welcome/PasswordReset.aspx?PwdResetRequest=';
                
                system.debug('Ready to update the URL field');
                thehistory.passwordResetUrl = theHistory.description.substringBetween('href=\'','\'>').replace(target, replacement);
                system.debug('thehistory.passwordResetUrl');
                system.debug(thehistory.passwordResetUrl);
                
                thehistory.mailTo = theHistory.passwordResetUrl.substringBetween('mailto:','?Subject');
                thehistory.subject = 'LegalZoom.com Account Password Help';
                
                system.debug('thehistory.description--->before');                
                system.debug(thehistory.description);
                
                thehistory.description = theHistory.description.substringBefore('<a');
                thehistory.body = theHistory.passwordResetUrl.substringAfter('Body=');
                
                thehistory.passwordResetUrl = theHistory.passwordResetUrl.substringBetween('password: ', ' You');
                
                system.debug('thehistory.description--->after');                
                system.debug(thehistory.description);
            }
        }
    }
}