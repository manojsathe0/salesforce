public class IADPendingPaymentsPanelController_Ltng 
{
    @AuraEnabled public static String orderId{get;set;}
    @AuraEnabled public static IADInstallmentPaymentService_ltng pendingPaymentService{get;set;} 
    
    public static void onload(String orderRecordId) 
    {
        system.debug('orderRecordId: '+orderRecordId);
        pendingPaymentService = new IADInstallmentPaymentService_ltng();
        List<Order__c> orders = [SELECT OrderID__c FROM Order__c WHERE Id = :orderRecordId];
        if(!orders.isEmpty())
        {
            orderId = orders[0].OrderID__c;
        }
    }
    
    @AuraEnabled
    public static IADInstallmentPaymentService_ltng populatePayments(String orderRecordId)
    {
        try
        {
            onload(orderRecordId);
            system.debug('orderId: '+orderId);
            IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.GETPAYMENTSBYORDERID);
            IADInstallmentPaymentService_ltng.getPaymentsByOrderId(orderId);  
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADInstallmentPaymentService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('pendingPaymentService');
        system.debug(pendingPaymentService);
        return pendingPaymentService;
    }
}