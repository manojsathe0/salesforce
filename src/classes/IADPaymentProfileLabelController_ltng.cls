public class IADPaymentProfileLabelController_ltng
{
    @AuraEnabled public static string paymentProfileLabel{Get;set;}
    @AuraEnabled public static IADEditPaymentService_ltng dataService{get;set;}
    
    @AuraEnabled
    public static String populatePaymentProfile(string paymentProfileId)
    {
        try
        { 
            dataService = new IADEditPaymentService_ltng();
            system.debug('populatepaymentprofile');
            IADServiceBase_ltng.initWrapper(IADEditPaymentService_ltng.GETPROFILEBYID);
            
            paymentProfileId = UtilityLibrary.stripStoreCreditOrProfileId(paymentProfileId);
            if(paymentProfileId != null && paymentProfileId != '' && paymentProfileId != '0')
            {
                IADEditPaymentService_ltng.getPaymentProfileById(paymentProfileId);
                processProfile();
            }
            else
            {
                paymentProfileLabel = 'No valid payment method saved to record.';
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
        }
        system.debug('paymentProfileLabel');
        system.debug(paymentProfileLabel);
        return paymentProfileLabel;
    }
    
    public static void  processProfile()
    {
        try
        {
            system.debug('populatepaymentprofile response');
            IADEditPaymentService_ltng.populateProfileById();
            
            if(IADEditPaymentService_ltng.theProfile!= null)
            {    
                paymentProfileLabel = UtilityLibrary.profileAccountTypeToNameMap.get(IADEditPaymentService_ltng.theProfile.AccountType) + ' - ' + IADEditPaymentService_ltng.theProfile.last4Digits;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
        }
    }
}