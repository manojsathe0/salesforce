public class IADInstallmentsPanelController_Ltng 
{
    @AuraEnabled public static String theId{get;set;}
    @AuraEnabled public static String orderId{get;set;}
    @AuraEnabled public static IADInstallmentService_ltng installmentService{get;set;}
    @AuraEnabled public static String customerId{get;set;}
    @AuraEnabled public static IADInstallmentPaymentService_ltng paymentProfileService{get;set;}
    
    public static void onLoad(String orderRecordId) 
    {
        installmentService = new IADInstallmentService_ltng();
        system.debug('OrderRecordId: '+OrderRecordId);
        List<Order__c> orders = [select Name , Contact__r.FkUser__c from Order__c where id =: orderRecordId];
        if(!orders.isEmpty())
        {
            orderId = orders[0].Name;
            customerId = orders[0].Contact__r.FkUser__c;
        }
        system.debug('orderId: '+orderId);
        system.debug('customerId: '+customerId);
    }
    
    @AuraEnabled
    public static IADInstallmentService_ltng populateInstallments(String orderRecordId)
    {
        try
        {
            onLoad(OrderRecordId);
            IADServiceBase_ltng.initWrapper(IADInstallmentService_ltng.GETINSTALLMENTSBYORDERID); //, 'processInstallmentResponse'
            system.debug('Order Id: '+IADInstallmentsPanelController_Ltng.orderId);
            system.debug('Order Id: '+orderId);
            IADInstallmentService_ltng.getInstallmentsByOrderId(orderId);
            if(IADInstallmentService_ltng.hasInstallment)
            {
                paymentProfileService = new IADInstallmentPaymentService_ltng();
                populatePaymentProfiles();
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADInstallmentService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('installmentService');
        system.debug(installmentService);
        return installmentService;
    }
    
    public static void populatePaymentProfiles()
    {
        try
        {
            IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.GETPROFILESBYUSERID); //, 'processPaymentProfiles'
            if(customerId != null){
                IADInstallmentPaymentService_ltng.getPaymentProfilesByUserId(customerId);
            }
            processPaymentProfiles();  
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADInstallmentService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void processPaymentProfiles() 
    {
        try
        {
            IADInstallmentPaymentService_ltng.populateProfiles();
            
            for(IADContractBeans_ltng.IADInstallmentBean theInstallment : IADInstallmentService_ltng.theInstallmentsWrapper.installments)
            {
                for(IADContractBeans_ltng.IADPaymentProfileBean profileBean : IADInstallmentPaymentService_ltng.allProfiles)
                {
                    profileBean.setIsExpiredFlag();
                    if(profileBean.profileId == theInstallment.paymentProfileId && IADPaymentTransaction_ltng.installmentBillStatusMap.get(theInstallment.installmentBillStatus) != 'Paid')
                    {
                        theInstallment.hasPaymentProfileExpired = profileBean.isExpired;
                    }
                }
            }
            IADInstallmentService_ltng.isInstallmentLoaded = false;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADInstallmentService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
}