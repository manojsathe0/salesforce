public with sharing class IADStoreCreditPanelController
{
    public String customerId {get;set;}
    public IADStoreCreditPanelService storeCreditPanelService{get;set;}
    public String orderId{get;set;}
    public String approvalIcon {get;set;}
	
    
    public IADStoreCreditPanelController () 
    {
        //customerId = '11586120';
        storeCreditPanelService = new IADStoreCreditPanelService();     
        orderId = ApexPages.currentPage().getParameters().get('id');
        for(Order__c theOrder : [SELECT Id , Contact__r.FkUser__c FROM Order__c WHERE Id = :orderId])
        {
            customerId = theOrder.Contact__r.FkUser__c;
        }
        approvalIcon = IADSGVIconStrings.checkIcon;
    }
    
    public Object populateStoreCredits()
    {
       
        Object continuationObject;
        try
        {
            if(customerId != null && customerId != '')
            {
               storeCreditPanelService.initWrapper(IADStoreCreditPanelService.GETSTORECREDITSBYCUSTOMERID, 'processStoreCredits');
               continuationObject = storeCreditPanelService.getStoreCreditsByCustomerId(customerId);  
            }
        }
        catch(IADException theException)
        {
            storeCreditPanelService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
           
            storeCreditPanelService.populateErrorMessage(theException);
        }
        return continuationObject; 
    }

    public Object processStoreCredits() 
    {
          try
          {
              storeCreditPanelService.populateStoreCredits();
          }
          catch(IADException theException)
          {
               storeCreditPanelService.populateErrorMessage(theException);
          }
          catch(Exception theException)
          {
               storeCreditPanelService.populateErrorMessage(theException);
          }
              
          
          return null;
    }

}