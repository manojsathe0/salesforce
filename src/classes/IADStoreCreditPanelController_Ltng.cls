public class IADStoreCreditPanelController_Ltng
{
    @AuraEnabled public static String customerId {get;set;}
    @AuraEnabled public static IADInstallmentPaymentService_ltng storeCreditPanelService{get;set;}
    @AuraEnabled public static String orderId{get;set;}
    
    public static void onload(String orderRecordId) 
    {
        storeCreditPanelService = new IADInstallmentPaymentService_ltng();     
        for(Order__c theOrder : [SELECT Id , OrderID__c, Contact__r.FkUser__c FROM Order__c WHERE Id = :orderRecordId])
        {
            customerId = theOrder.Contact__r.FkUser__c;
            orderId = theOrder.OrderID__c;
        }
    }
    
    @AuraEnabled
    public static IADInstallmentPaymentService_ltng populateStoreCredits(String orderRecordId)
    {
        try
        {
            onload(orderRecordId);
            if(customerId != null && customerId != '')
            {
                IADServiceBase_ltng.initWrapper(IADStoreCreditPanelService.GETSTORECREDITSBYCUSTOMERID);//, 'processStoreCredits'
                IADInstallmentPaymentService_ltng.getStoreCreditsByCustomerId(customerId); 
                IADInstallmentPaymentService_ltng.populateStoreCredits();
                IADInstallmentPaymentService_ltng.orderId = orderId;
                IADInstallmentPaymentService_ltng.customerId=customerId;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
        }
        return storeCreditPanelService;
    }
}