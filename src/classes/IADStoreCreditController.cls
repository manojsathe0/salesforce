public with sharing class IADStoreCreditController
{
	public String storeCreditId{get;set;}
    public String customerId{get;set;}
    public IADStoreCreditService storeCreditService{get;set;}
   
    public IADStoreCreditController () 
    {
        storeCreditId  = ApexPages.currentPage().getParameters().get('storeCreditId');
        customerId = ApexPages.currentPage().getParameters().get('customerId');
        storeCreditService = new IADStoreCreditService();
    }

    public Object populateStoreCredit()
    {
       
        Object continuationObject;
        try
        {
            if(UtilityLibrary.isNotNullOrBlank(storeCreditId))
            {
               storeCreditService.initWrapper(IADStoreCreditService.GETSTORECREDITSBYSTORECREDITID, 'processStoreCredit');
               continuationObject = storeCreditService.getStoreCreditDetailByStoreCreditId(storeCreditId);  
            }
        }
        catch(IADException theException)
        {
            storeCreditService.populateErrorMessage(theException);    
        }
        catch(Exception theException)
        {
           
            storeCreditService.populateErrorMessage(theException);
        }
        return continuationObject; 
    }

    public Object processStoreCredit() 
    {
          try
          {
               storeCreditService.populateStoreCredit();
          }
          catch(IADException theException)
          {
               storeCreditService.populateErrorMessage(theException);
          } 
          catch(Exception theException)
          {
               storeCreditService.populateErrorMessage(theException);
          }
        
          return null;
    }
  
}