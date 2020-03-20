public class IADSubscriptionController_Ltng 
{
    @AuraEnabled public static String customerId{get;set;}
    @AuraEnabled public static Boolean isRegistered {get;set;}
    @AuraEnabled public static String subscriptionId{get;set;}
    @AuraEnabled public static IADSubscriptionPanelService_Ltng subscriptionService{get;set;}
    @AuraEnabled public static IADInstallmentPaymentController_ltng iadInstPayCtrlRef{get;set;}       
    
    public static void onload(String subId, String custId) 
    {
        isRegistered = false;
        subscriptionId = subId;
        customerId = custId;
        
    	subscriptionService = new IADSubscriptionPanelService_Ltng();
        IADSubscriptionPanelService_Ltng.subscriptionInfoDetailsWrapped = new List<IADSubscriptionPanelService_Ltng.subscriptionWrapper>();
    }    
    
    @AuraEnabled
    public static IADInstallmentPaymentController_ltng populateProfiles(String customerId, String pageType)
    {
        try
        {
            iadInstPayCtrlRef = new IADInstallmentPaymentController_ltng();
            iadInstPayCtrlRef = IADInstallmentPaymentController_ltng.populateProfiles(customerId, pageType);
        }
        catch(Exception theException)
        {
            IADServiceBase_Ltng.populateErrorMessage(theException);
            IADInstallmentPaymentController_ltng.messages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('iadInstPayCtrlRef');
        system.debug(iadInstPayCtrlRef);
		return iadInstPayCtrlRef;
    }
    
    @AuraEnabled
    public static IADSubscriptionPanelService_Ltng populateSubscription(String subId, String custId)
    {
        system.debug('inside populateSubscription');
        IADSubscriptionPanelService_Ltng.isCancelSuccess = false;
        try
        {
            onload(subId, custId);
            IADServiceBase_Ltng.initWrapper(IADSubscriptionPanelService_Ltng.GETSUBSCRIPTIONBYSUBSCRIPTIONID); //, 'processSubscription'
            IADSubscriptionPanelService_Ltng.getSubscriptionBySubscriptionId(subscriptionId);
        	//processSubscription();
        }
        catch(Exception theException)
        {
            IADServiceBase_Ltng.populateErrorMessage(theException);
            IADSubscriptionPanelService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('subscriptionService: populateSubscription');
        system.debug(subscriptionService);
        system.debug(IADSubscriptionPanelService_Ltng.profileId);
        return subscriptionService;
    }
    
    @AuraEnabled
    public static IADSubscriptionPanelService_Ltng getSubscriptionRenewalTerms(String subscriptionId)
    {
        try
        {
            system.debug('subscriptionId: '+subscriptionId);
            onload(subscriptionId, '');
            IADServiceBase_Ltng.initWrapper(IADSubscriptionPanelService_Ltng.GETSUBSCRIPTIONRENEWALTERMS); //, 'processUpdateSubscription'
            IADSubscriptionPanelService_Ltng.getSubscriptionRenewalTerms(subscriptionId);
        }
        catch(Exception theException)
        {
            IADServiceBase_Ltng.populateErrorMessage(theException); 
            IADSubscriptionPanelService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        return subscriptionService;
    }
    
    @AuraEnabled
    public static IADSubscriptionPanelService_Ltng getNextSubscriptionModification(String subscriptionId)
    {
        try
        {
            system.debug('subscriptionId: '+subscriptionId);
            onload(subscriptionId, '');
            IADServiceBase_Ltng.initWrapper(IADSubscriptionPanelService_Ltng.GETNEXTSUBSCRIPTIONMODIFICATION); 
            IADSubscriptionPanelService_Ltng.getNextSubscriptionModification(subscriptionId);
        }
        catch(Exception theException)
        {
            system.debug('exception thrown inside getNextSubscriptionModification ctrlr');
            IADServiceBase_Ltng.populateErrorMessage(theException); 
            IADSubscriptionPanelService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        return subscriptionService;
    }
    
    @AuraEnabled
    public static IADSubscriptionPanelService_Ltng cancelSubscriptionUpgrade(String subscriptionId, String scheduleId)
    {
        try
        {
            system.debug('scheduleId: '+scheduleId);
            system.debug('subscriptionId: '+subscriptionId);
            onload(subscriptionId, '');
            IADServiceBase_Ltng.initWrapper(IADSubscriptionPanelService_Ltng.CANCELSUBSCRIPTIONUPGRADE); 
            IADSubscriptionPanelService_Ltng.cancelSubscriptionUpgrade(scheduleId);
        }
        catch(Exception theException)
        {
            system.debug('exception thrown inside cancelSubscriptionUpgrade ctrlr');
            IADServiceBase_Ltng.populateErrorMessage(theException); 
            IADSubscriptionPanelService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        return subscriptionService;
    }
        
    @AuraEnabled
    public static IADSubscriptionPanelService_Ltng updateSubscription(String subId, String renewChoice, String profileId, Integer productComponentId, Integer productConfigId, Decimal extendedPrice)
    {
        try
        {
            system.debug('subId: '+subId);
            system.debug('renewChoice: '+renewChoice);
            system.debug('profileId: '+profileId);
            system.debug('productComponentId: '+productComponentId);
            system.debug('productConfigId: '+productConfigId);
            onload(subId, '');
            IADServiceBase_Ltng.initWrapper(IADSubscriptionPanelService_Ltng.PUTSUBSCRIPTIONBYSUBSCRIPTIONID); //, 'processUpdateSubscription'
            IADSubscriptionPanelService_Ltng.putSubscriptionBySubscriptionId(subscriptionId, Integer.valueOf(renewChoice), Integer.valueOf(UtilityLibrary.stripStoreCreditOrProfileId(profileId)), productComponentId, productConfigId, extendedPrice);
        }
        catch(Exception theException)
        {
            IADServiceBase_Ltng.populateErrorMessage(theException); 
            IADSubscriptionPanelService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        return subscriptionService;
    }
    
    @AuraEnabled
    public static IADSubscriptionPanelService_Ltng cancelSubscriptionRenewal(String refundAmount, String subId, String custId, Boolean isPartial, String orderItemId, String subscriptionEndDate, String comments)
    {       
        try
        {
            system.debug('refundAmount: ' + refundAmount );
            system.debug('subId: ' + subId );
            system.debug('custId: ' + custId );
            system.debug('isPartial: ' + isPartial );
            system.debug('orderItemId: ' + orderItemId );
            system.debug('subscriptionEndDate: ' + subscriptionEndDate);
            system.debug('comments: ' + comments);
            system.debug('refundAmount: ' + refundAmount + 'subId: ' + subId + 'custId: ' + custId + 'isPartial: ' + isPartial + 'orderItemId: ' + orderItemId + 'subscriptionEndDate: ' + subscriptionEndDate + 'comments: ' +comments);
            onload(subId, custId);
            IADServiceBase_Ltng.initWrapper(IADSubscriptionPanelService.PUTORDERSUBSCRIPTIONBYORDERITEMID); //, 'processCancelSubscriptionRenewal'
            IADSubscriptionPanelService_Ltng.putSubscriptionByOrderItemId(customerId , orderItemId , Boolean.valueOf(isPartial), Double.valueOf(refundAmount), subscriptionEndDate, comments);
        }
        catch(Exception theException)
        {
            IADServiceBase_Ltng.populateErrorMessage(theException);
            IADSubscriptionPanelService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('subscriptionService');
        system.debug(subscriptionService);
        return subscriptionService;
    }
    
    @AuraEnabled
    public static IADSubscriptionPanelService_Ltng populateProratedRefund(String subId, String custId, Boolean isPartial, String currentOrderItemId)
    {
        system.debug('subId: '+subId);
        system.debug('custId: '+custId);
        system.debug('isPartial: '+isPartial);
        system.debug('currentOrderItemId: '+currentOrderItemId);
        onload(subId, custId);
        if(isPartial)
        {
            try
            {
                IADServiceBase_Ltng.initWrapper(IADSubscriptionPanelService_Ltng.GETPRORATEDREFUNDBYORDERITEMID); //, 'processProratedRefund'
                IADSubscriptionPanelService_Ltng.populateProratedRefund(currentOrderItemId);
                //IADSubscriptionPanelService_Ltng.processProratedRefund();
            }
            catch(Exception theException)
            {
                IADServiceBase_Ltng.populateErrorMessage(theException);
                IADSubscriptionPanelService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        system.debug('IADSubscriptionPanelService_Ltng.dayToProRatedAmount');
        system.debug(IADSubscriptionPanelService_Ltng.dayToProRatedAmount);
        return subscriptionService; 
    } 
    
    @AuraEnabled
    public static IADSubscriptionPanelService_Ltng cancelSubscriptionWithoutRefund(String subscriptionId)
    {
        system.debug('subscriptionId: '+subscriptionId);
        onload(subscriptionId, '');
        try
        {
            IADServiceBase_Ltng.initWrapper(IADSubscriptionPanelService_Ltng.CANCELSUBSCRIPTIONWITHOUTREFUND);
            IADSubscriptionPanelService_Ltng.putCancelSubscriptionWithoutRefund(subscriptionId);
        }
        catch(Exception theException)
        {
            IADServiceBase_Ltng.populateErrorMessage(theException);
            IADSubscriptionPanelService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        
        return subscriptionService; 
    }
}