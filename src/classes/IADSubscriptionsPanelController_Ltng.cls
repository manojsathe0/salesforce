public class IADSubscriptionsPanelController_Ltng
{
    @AuraEnabled public static String orderId{get;set;}
    @AuraEnabled public static String customerId{get;set;}
    @AuraEnabled public static List<Order__c> orders{get;set;}
    @AuraEnabled public static IADSubscriptionPanelService_Ltng subscriptionService{get;set;}    
    
    public static void onload(String orderRecordId) 
    {
        subscriptionService = new IADSubscriptionPanelService_Ltng();
        
        orders =  [SELECT Name, OrderID__c, Contact__r.FKUser__c FROM Order__c WHERE Id = :orderRecordId limit 1];
        
        if(!orders.isEmpty())
        {
            orderId = orders[0].OrderID__c;
            customerId = orders[0].Contact__r.FKUser__c;
        }
    }
    
    @AuraEnabled
    public static List<Order__c> retriveOrderDetail(String orderNumber)
    {
        orders =  [SELECT Id, Name, OrderID__c, Contact__r.FKUser__c FROM Order__c WHERE OrderID__c = :orderNumber limit 1];
        system.debug('Orders-->');
        system.debug(orders);
        return orders;
    }
    
    @AuraEnabled
    public static IADSubscriptionPanelService_Ltng populateSubscriptions(String orderRecordId)
    {
        system.debug('orderRecordId: '+orderRecordId);
        
        try
        {
            if(orderRecordId.startsWith('a0p'))
            {
                onload(orderRecordId);
                system.debug('orderId: '+orderId);
                IADSubscriptionPanelService_Ltng.isSubscriptionLoaded = false;
                IADServiceBase_Ltng.initWrapper(IADSubscriptionPanelService.GETSUBSCRIPTIONSBYORDERID); //, 'processSubscriptions'
                //continuationObject = subscriptionService.getSubscriptionsyByOrderId(orderId);  
                IADSubscriptionPanelService_Ltng.getSubscriptionsyByOrderId(orderId, customerId);
            }
            else
            {
                contactload(orderRecordId) ;
                IADSubscriptionPanelService_Ltng.isSubscriptionLoaded = false;
                IADServiceBase_Ltng.initWrapper(IADSubscriptionPanelService_ltng.GETSUBSCRIPTIONSBYCUSTOMERID); //, 'processSubscriptions'
                //continuationObject = subscriptionService.getSubscriptionsyByOrderId(orderId);  
                IADSubscriptionPanelService_Ltng.getSubscriptionsyByCustomerId(customerId);
                
            }
        }
        catch(IADException theException)
        {
            IADServiceBase_Ltng.populateErrorMessage(theException);    
        }
        catch(Exception theException)
        {
            IADServiceBase_Ltng.populateErrorMessage(theException);
        }
        system.debug('subscriptionService: '+subscriptionService);
        return subscriptionService; 
    }    
    
    public static void contactload(String orderRecordId) 
    {
        subscriptionService = new IADSubscriptionPanelService_Ltng();
        //paymentProfileService = new IADInstallmentPaymentService_ltng();
        
        //orderId = ApexPages.currentPage().getParameters().get('Id');
        
        List<contact> contacts =  [SELECT FKUser__c FROM contact WHERE Id = :orderRecordId limit 1];
        
        if(!contacts.isEmpty())
        {
            
            customerId = contacts[0].FKUser__c;
        }
        //approvalIcon = IADSGVIconStrings.checkIcon;
    }
    
}