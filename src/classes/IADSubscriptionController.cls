public with sharing class IADSubscriptionController 
{
    public String theId {get;set;}
    public String regAgentCancelReason{get;set;}
    public String otherCancelReason{get;set;}
    public String cancelInput{get;set;}
    public String dayview {get;set;}
    public Boolean isRegistered {get;set;}
    public String paymentOption {get;set;}
    public String profileId{get;set;}
    public String subscriptionId{get;set;}
    public String customerId{get;set;}
    public IADSubscriptionPanelService subscriptionService{get;set;}
    public String refundAmount{get;set;}
    public String note{get;set;}
    public Boolean showTheForm{get;set;}
    public Boolean isPartial{get;set;} 
    public String currentOrderItemId{get;set;}

    public IADSubscriptionController () 
    {
        subscriptionService = new IADSubscriptionPanelService();
        theId = ApexPages.currentPage().getParameters().get('id');
        
        system.debug('the id ' + theId);
        dayview = IADSGVIconStrings.dayview;
        
        isRegistered = false;

        subscriptionId = ApexPages.currentPage().getParameters().get('subscriptionId');


        customerId = ApexPages.currentPage().getParameters().get('customerId');
        showTheForm = false;
    }
    public void setProfileIdManual(){
       profileId = Apexpages.currentPage().getParameters().get('profileId');

       system.debug('profile id '  + profileId);
    }
    public void setPaymentOption(){
        paymentOption = Apexpages.currentPage().getParameters().get('paymentName');

        system.debug('paymentOption '  + paymentOption);
    }
    
    public String endDate{
        get;
        set{
                endDate = value;
                System.debug('value: ' + value);
            }
    }
    public String cancelReason{
        get;
        set{
                cancelReason = value;
                System.debug('value: ' + value);
            }
    }
    public Integer renewChoice{
        get;
        set{
            renewChoice = value;
            System.debug('value: ' + value);
        }
    }
    public void detailSave()
    {
        system.debug('date ' + endDate);
        Date d =  Date.parse(endDate);
        system.debug('date ' + String.valueOf(d));
        //theItem.Subscription_End_Date__c = datetime.newInstance(d.year(), d.month(),d.day());

        //theItem.renewPlaceholder = renewChoice;

       
    }
    public void cancelSave()
    {
        //endDate = Apexpages.currentPage().getParameters().get('endDate');

        system.debug('cancel reason ' + cancelReason);
        
         system.debug('other cancel reason ' + otherCancelReason);

        //no cancel reason yet
        //theItem.cancelReasonPlaceholder = cancelReason;
        //Update theItem;
        
    }
    public List<selectOption> getRACancellationReasons()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult fieldResult = IAD_Picklists__c.Sub_Registered_Agent_Reasons_for_Cancel__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry value : pickListValues)
           {
              options.add(new SelectOption(value.getLabel(), value.getValue()));
           }       
        return options;
    }
    public List<selectOption> getOtherCancellationReasons()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult fieldResult = IAD_Picklists__c.Sub_Other_Reasons_for_Cancel__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry value : pickListValues)
           {
              options.add(new SelectOption(value.getLabel(), value.getValue()));
           }       
        return options;
    }

    public Object populateSubscription()
    {
        subscriptionService.isCancelSuccess = false;
        Object continuationObject;
        try
        {
            subscriptionService.initWrapper(IADSubscriptionPanelService.GETSUBSCRIPTIONBYSUBSCRIPTIONID, 'processSubscription');
            continuationObject = subscriptionService.getSubscriptionBySubscriptionId(subscriptionId);

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
       
    public Object processSubscription() 
    {
          try
          {
              subscriptionService.populateSubscriptionBySubcriptionId();

              if( subscriptionService.subscriptionSingleItem.subscription.userPaymentProfile != null)
                  profileId =  'pp' + subscriptionService.subscriptionSingleItem.subscription.userPaymentProfile;
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
    public void clearMessages()
    {
        subscriptionService.clearMessages();
    }
    public Object updateSubscription()
    {
        Object continuationObject;

        try
        {
            subscriptionService.clearMessages();
            if(profileId == null || profileId == '')
            {
                subscriptionService.populateErrorMessage('Please select a profile Id');
            }
            if(subscriptionService.errorCount == 0)
            {
                subscriptionService.initWrapper(IADSubscriptionPanelService.PUTSUBSCRIPTIONBYSUBSCRIPTIONID, 'processUpdateSubscription');
                continuationObject = subscriptionService.putSubscriptionBySubscriptionId(subscriptionId, renewChoice, Integer.valueOf(UtilityLibrary.stripStoreCreditOrProfileId(profileId)));
            }
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

    public Object processUpdateSubscription()
    {
        try
        {
            subscriptionService.populatePutSubscriptionBySubcriptionId();
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

    public Object cancelSubscriptionRenewal()
    {
        subscriptionService.clearMessages();
        if(isPartial)
        {
            if(refundAmount == '' || refundAmount == null)
            {
                subscriptionService.populateErrorMessage('Please Provide Refund Amount');
                return null;
            }
            if(note == '' || note == null)
            {
                subscriptionService.populateErrorMessage('Please Provide Comments');
                return null;
            }
        }
        if(!isPartial)
        {
            if(note == '' || note == null)
            {
                subscriptionService.populateErrorMessage('Please Provide Comments');
                return null;
            }   
        }

        Object continuationObject;
        String oItemId = subscriptionService.subscriptionDetailToPost.orderItemId;
        String subscriptionEndDate;
        System.debug('OI OI '+refundAmount);
        if(refundAmount == '' || refundAmount == null)
            refundAmount  = '0.00'; 
        if(isPartial)
        {
            subscriptionEndDate = subscriptionService.subscriptionDetailToPost.adjSubscriptionEndDate;
            subscriptionEndDate = UtilityLibrary.convertJSDateToIADDate(subscriptionEndDate, subscriptionService.subscriptionDetailToPost.subscriptionEndDate);
        }
        else
        {
            subscriptionService.isAllowedCancel = true;
            subscriptionEndDate = subscriptionService.subscriptionDetailToPost.subscriptionEndDate;    
        }
       
        try
        {
            subscriptionService.clearMessages();
            subscriptionService.initWrapper(IADSubscriptionPanelService.PUTORDERSUBSCRIPTIONBYORDERITEMID, 'processCancelSubscriptionRenewal');
            continuationObject = subscriptionService.putSubscriptionByOrderItemId(customerId , oItemId , Boolean.valueOf(isPartial), Double.valueOf(refundAmount) , subscriptionEndDate , note);
            
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

    public Object processCancelSubscriptionRenewal()
    {
        try
        {
            subscriptionService.populatePutOrderSubscriptionByOrderItemId();
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

    public void populateSelectedSubscriptionTerm()
    {
           subscriptionService.clearMessages();
           subscriptionService.isCancelSuccess = false;
           showtheForm = true;

           String orderItemSubscriptionId = ApexPages.currentPage().getParameters().get('orderItemSubscriptionId');
           currentOrderItemId =  ApexPages.currentPage().getParameters().get('currentOrderItemId');
           String partial = ApexPages.currentPage().getParameters().get('isPartial');
           if(partial == '1')
                isPartial = true;
           else if(partial == '0')
           {
            
               subscriptionService.isAllowedCancel = true;
               isPartial = false;
           }
           subscriptionService.subscriptionDetailToPost = subscriptionService.subscriptionOrderItemIdToDetail.get(currentOrderItemId);
          
    }

    public PageReference closeTheForm()
    {
        showtheForm = false;
        subscriptionService.clearMessages();
        return null;
    }

    public Object populateProratedRefund()
    {
        Object continuationObject;
        if(isPartial)
        {
            try
            {
                subscriptionService.clearMessages();
                subscriptionService.initWrapper(IADSubscriptionPanelService.GETPRORATEDREFUNDBYORDERITEMID, 'processProratedRefund');
                continuationObject = subscriptionService.populateProratedRefund(currentOrderItemId);
              
            }
            catch(IADException theException)
            {
                subscriptionService.populateErrorMessage(theException);
            }
            catch(Exception theException)
            {
                subscriptionService.populateErrorMessage(theException);
            }
        }
        return continuationObject;


    }

    public Object processProratedRefund()
    {
        try
        {
            subscriptionService.processProratedRefund();
            
            /*
            String dueDate =  subscriptionService.subscriptionDetailToPost.adjSubscriptionEndDate;
            Date theDate = Date.parse(dueDate.substring(0,dueDate.indexOf(' ')));
            Date dt = date.newInstance(theDate.year(), theDate.month(),theDate.day());
            String correctedDateFormat = dt+'';
            String dateOnly = correctedDateFormat.subString(0,correctedDateFormat.indexOf(' '));
           
            if(subscriptionService.dayToProRatedAmount.containsKey(dateOnly))
            {
                refundAmount = subscriptionService.dayToProRatedAmount.get(dateOnly);
            }
            */
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

    public void populateRefundAmount()
    {
        String dueDate = ApexPages.currentPage().getParameters().get('dueDate');
        
        Date theDate = Date.parse(dueDate);
        Date dt = date.newInstance(theDate.year(), theDate.month(),theDate.day());
        String correctedDateFormat = dt+'';
        String dateOnly = correctedDateFormat.subString(0,correctedDateFormat.indexOf(' '));

        if(subscriptionService.dayToProRatedAmount.containsKey(dateOnly)) 
        {
            refundAmount = subscriptionService.dayToProRatedAmount.get(dateOnly);
        }
        
    }

}