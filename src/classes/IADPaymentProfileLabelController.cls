/**
 * Created by jboles on 10/31/2016.
 */

public class IADPaymentProfileLabelController
{
    public string paymentProfileId{get;set;}
    public string paymentProfileLabel{Get;set;}
    public IADEditPaymentService dataService{get;set;}

    public IADPaymentProfileLabelController()
    {
        dataService = new IADEditPaymentService();
    }
    public Object populatePaymentProfile()
    {
        Object continuationObject;
        try
        {
            system.debug('populatepaymentprofile');
            dataService.initWrapper(IADEditPaymentService.GETPROFILEBYID, 'processProfile');

            paymentProfileId = UtilityLibrary.stripStoreCreditOrProfileId(paymentProfileId);
            if(paymentProfileId != null && paymentProfileId != '' && paymentProfileId != '0')
                continuationObject = dataService.getPaymentProfileById(paymentProfileId);
            else
                paymentProfileLabel = 'No valid payment method saved to record.';
        }
        catch(IADException theException)
        {
            dataService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            dataService.populateErrorMessage(theException);
        }
        return continuationObject;


    }
    public Object processProfile()
    {
        try
        {
            system.debug('populatepaymentprofile response');
            dataService.populateProfileById();

            if(dataService.theProfile!= null)
                paymentProfileLabel = UtilityLibrary.profileAccountTypeToNameMap.get(dataService.theProfile.AccountType) + ' - ' + dataService.theProfile.last4Digits;// + ' - ' + profile.profileId;

        }
        catch(IADException theException)
        {
            dataService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            dataService.populateErrorMessage(theException);
        }
        return null;
    }
}