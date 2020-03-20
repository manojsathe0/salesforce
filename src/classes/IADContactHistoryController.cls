public class IADContactHistoryController {
    
    public String customerId{get;set;}
  
    public IADContactHistoryService contactHistoryService{get;set;}
    public IADContactHistoryController() 
    {
        customerId = ApexPages.currentPage().getParameters().get('customerId');
        contactHistoryService = new IADContactHistoryService();
    }
    public Object populateCustomerHistory()
    {
        system.debug('inside controller');
        Object continuationObject;
        try
        {
            contactHistoryService.initWrapper(IADContactHistoryService.GETCONTACTHISTORYBYCUSTID, 'processContactHistory');
            continuationObject = contactHistoryService.getContactHistoryByCustId(customerId);  
            
        }
        catch(IADException theException)
        {
            contactHistoryService.populateErrorMessage(theException);    
        }
        catch(Exception theException)
        {
           
            contactHistoryService.populateErrorMessage(theException);
        }
        return continuationObject; 
       
    }

    public Object processContactHistory() 
    {
          try
          {
              contactHistoryService.populateHistory();
          }
          catch(IADException theException)
          {
               contactHistoryService.populateErrorMessage(theException);
          } 
          catch(Exception theException)
          {
               contactHistoryService.populateErrorMessage(theException);
          }
              
          
          return null;
    }

   

}