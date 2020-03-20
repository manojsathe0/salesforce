public class IADrefundInstallment_ltng

{

 @AuraEnabled public static IADInstallmentService_ltng installmentService{get;set;}
 @AuraEnabled public static String orderId{get;set;}
  @AuraEnabled public static String customerId{get;set;}
  @AuraEnabled public static IADOrderWithOrderItemsService_ltng orderService{get;set;}
 @AuraEnabled  public static double sumofpendinginstallments{get;set;}
 
 public static void onLoad(String orderRecordId) 
    {
        
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
    public static IADOrderWithOrderItemsService_ltng populateInstallments(String orderRecordId)
    {
        try
        {
            onLoad(OrderRecordId);
            
           orderService= IADOrderWithOrderItemsController_ltng.getOrderBalanceByOrderId(OrderRecordId,orderId);
          
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADOrderWithOrderItemsService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('installmentService');
        system.debug(installmentService);
        return orderservice;
    }
    
    
    
  @AuraEnabled
    public static  IADInstallmentPaymentService_ltng processrefund(String orderRecordId ,string amount )
    {    IADInstallmentPaymentService_ltng installmentservice = new IADInstallmentPaymentService_ltng();
        system.debug('getPaymentsByOrderId');
        try
        { onLoad(OrderRecordId);
           IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.POSTREFUNDINSTALLMENT);//, 'processAllResponses'
             String jsonBody = '{"Amount":"'+amount+'","UpdatedBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
            IADInstallmentPaymentService_ltng.PostrefundInstallment(jsonBody ,orderId);
            readProcessRefundInstallment(amount);
           // processPaymentResponse();
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADInstallmentPaymentService_ltng.iadServiceMessages=IADServiceBase_ltng.iadMessages;
        }
        
        return installmentservice; 
    } 
    
         public static void readProcessRefundInstallment(String processAmount )
    {
        APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(IADInstallmentPaymentService_ltng.POSTREFUNDINSTALLMENT);

        try
        {
            if (response.responseData != null)
            {
                if (response.checkIsValidResponse())
                {
                    IADServiceBase_ltng.populateSuccessMessage( 'Refund processed  Installment for $' + processAmount + '!'); 
                    IADInstallmentPaymentService_ltng.iadServiceMessages=IADServiceBase_ltng.iadMessages;
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(response);
                    IADInstallmentPaymentService_ltng.iadServiceMessages=IADServiceBase_ltng.iadMessages;
                    
                    }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(response);
                IADInstallmentPaymentService_ltng.iadServiceMessages=IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADInstallmentPaymentService_ltng.iadServiceMessages=IADServiceBase_ltng.iadMessages;
        }
    } 

}