public with sharing class IADSubscriptionsPanelController
{
    public String orderId{get;set;}
    public IADSubscriptionPanelService subscriptionService{get;set;}
    public String customerId{get;set;}
    public String approvalIcon {get;set;}
    public IADPaymentProfilesService paymentProfileService{get;set;}
  

    public IADSubscriptionsPanelController () 
    {
        subscriptionService = new IADSubscriptionPanelService();
        paymentProfileService = new IADPaymentProfilesService();

        orderId = ApexPages.currentPage().getParameters().get('Id');
      
        List<Order__c> orders =  [SELECT Name , Contact__r.FKUser__c FROM Order__c WHERE Id = :orderId limit 1];
      
        if(!orders.isEmpty())
        {
            orderId = orders[0].Name;
            customerId = orders[0].Contact__r.FKUser__c;
        }
        approvalIcon = IADSGVIconStrings.checkIcon;
       

    }

    public Object populateSubscriptions()
    {
        Object continuationObject;
        try
        {
           
            subscriptionService.isSubscriptionLoaded = false;
            subscriptionService.initWrapper(IADSubscriptionPanelService.GETSUBSCRIPTIONSBYORDERID, 'processSubscriptions');
            continuationObject = subscriptionService.getSubscriptionsyByOrderId(orderId);  
        }
        catch(IADException theException)
        {
            subscriptionService.populateErrorMessage(theException);    
        }
        catch(Exception theException)
        {
            subscriptionService.populateErrorMessage(theException);
        }
        return continuationObject; 
         
       
    }
       
    public Object processSubscriptions() 
    {
          try
          {
              subscriptionService.populateSubscription();

          }
          catch(IADException theException)
          {
               subscriptionService.populateErrorMessage(theException);
          } 
          catch(Exception theException)
          {
               subscriptionService.populateErrorMessage(theException);
          }
          return null;
    }

    public Object populatePaymentProfiles()
    {
        Object continuationObject;
        try
        {
           
            paymentProfileService.initWrapper(IADPaymentProfilesService.GETPROFILESBYUSERID, 'processPaymentProfiles');
            if(customerId != null)
              continuationObject = paymentProfileService.getPaymentProfilesByUserId(customerId);
            subscriptionService.iadMessages.addAll(paymentProfileService.iadMessages);  
        }
        catch(IADException theException)
        {
            subscriptionService.populateErrorMessage(theException);    
        }
        catch(Exception theException)
        {
            subscriptionService.populateErrorMessage(theException);
        }
        return continuationObject; 
         
       
    }
       
    public Object processPaymentProfiles() 
    {
          try
          {
              paymentProfileService.initHTTPResponse(IADPaymentProfilesService.GETPROFILESBYUSERID);
              paymentProfileService.populateProfiles();
              subscriptionService.iadMessages.addAll(paymentProfileService.iadMessages);

              for(IADContractBeans.IADPaymentProfileBean profileBean : paymentProfileService.allProfiles)
              {
                  profileBean.setIsExpiredFlag();
                  for(IADContractBeans.IADSubscription theSubscription : subscriptionService.subscriptionItem.subscriptions)
                  {
                     if(profileBean.profileId == theSubscription.paymentProfileId && theSubscription.status == 'Active' && theSubscription.autoRenew == 'Yes')
                     {
                        
                         theSubscription.hasPaymentProfileExpired = profileBean.isExpired;
                         
                     }
                  }
              }
              subscriptionService.isSubscriptionLoaded = false;
          }
          catch(IADException theException)
          {
              subscriptionService.populateErrorMessage(theException);
          } 
          catch(Exception theException)
          {
              subscriptionService.populateErrorMessage(theException);
          }
          return null;
    }
  
}