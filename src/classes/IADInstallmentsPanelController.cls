public with sharing class IADInstallmentsPanelController
{

    public String theId{get;set;}
    public String orderId{get;set;}

   
    public IADInstallmentService installmentService{get;set;}
    public String approvalIcon {get;set;}
    public String customerId{get;set;}
    public IADPaymentProfilesService paymentProfileService{get;set;}

    public IADInstallmentsPanelController () 
    {
        
        theId = ApexPages.currentPage().getParameters().get('id');
        installmentService = new IADInstallmentService();
        paymentProfileService = new IADPaymentProfilesService();

        approvalIcon = IADSGVIconStrings.checkIcon;
        
        List<Order__c> orders = [select Name , Contact__r.FkUser__c from Order__c where id =:theId];
        if(!orders.isEmpty())
        {
            orderId = orders[0].Name;
            customerId = orders[0].Contact__r.FkUser__c;
        }
    }
    
    public Object populateInstallments()
    {
        Object continuationObject;
        try
        {
           
            installmentService.initWrapper(IADInstallmentService.GETINSTALLMENTSBYORDERID, 'processInstallmentResponse');
            continuationObject = installmentService.getInstallmentsByorderId(orderId);
          
        }
        catch(IADException theException)
        {
            installmentService.populateErrorMessage(theException);          
                   
        }
        catch(Exception theException)
        {
            installmentService.populateErrorMessage(theException);
        }
        return continuationObject; 
       
    }
        

    public Object processInstallmentResponse()
    {
        Continuation chainedContinuation = null;
        try
        {
            installmentService.populateInstallments();
            
            if(installmentService.hasInstallment)
            {
                chainedContinuation = (Continuation)populatePaymentProfiles();
            }
        }
        catch(IADException theException)
        {
            installmentService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            installmentService.populateErrorMessage(theException);
        }
        return chainedContinuation;
    }

    public Object populatePaymentProfiles()
    {
        Object continuationObject;
        try
        {
           
            paymentProfileService.initWrapper(IADPaymentProfilesService.GETPROFILESBYUSERID, 'processPaymentProfiles');
            if(customerId != null)
              continuationObject = paymentProfileService.getPaymentProfilesByUserId(customerId);
            installmentService.iadMessages.addAll(paymentProfileService.iadMessages);  
        }
        catch(IADException theException)
        {
            installmentService.populateErrorMessage(theException);    
        }
        catch(Exception theException)
        {
            installmentService.populateErrorMessage(theException);
        }
        return continuationObject; 
         
       
    }
       
    public Object processPaymentProfiles() 
    {
          try
          {
            paymentProfileService.initHTTPResponse(IADPaymentProfilesService.GETPROFILESBYUSERID);
            paymentProfileService.populateProfiles();
            installmentService.iadMessages.addAll(paymentProfileService.iadMessages);
                
            for(IADContractBeans.IADInstallmentBean theInstallment : installmentService.theInstallmentsWrapper.installments)
            {
                for(IADContractBeans.IADPaymentProfileBean profileBean : paymentProfileService.allProfiles)
                {
           
                 profileBean.setIsExpiredFlag();
                 if(profileBean.profileId == theInstallment.paymentProfileId && IADPaymentTransaction.installmentBillStatusMap.get(theInstallment.installmentBillStatus) != 'Paid')
                 {
                    
                     theInstallment.hasPaymentProfileExpired = profileBean.isExpired;
                     
                 }
              }
            }
            installmentService.isInstallmentLoaded = false;
          }
          catch(IADException theException)
          {
              installmentService.populateErrorMessage(theException);
          } 
          catch(Exception theException)
          {
              installmentService.populateErrorMessage(theException);
          }
          return null;
    }

     
 }