public class IADEditPaymentController
{
    public IADEditPaymentService dataService{get;set;}
    public String theId{get;set;}

    public List<SelectOption> expMonths{get;set;}
    public List<SelectOption> paymentTypes {get;set;}
    public List<SelectOption> expYears {get;set;}
    public List<SelectOption> statePicklist {get;set;}

    public IADEditPaymentController()
    {
        dataService = new IADEditPaymentService();
        theId = ApexPages.currentPage().getParameters().get('id');

        expMonths = UtilityLibrary.expMonths;
        paymentTypes = UtilityLibrary.paymentTypes;
        expYears = UtilityLibrary.expYears;
        statePicklist = UtilityLibrary.statePicklist;
    }

    public Object populatePaymentProfile()
    {
        Object continuationObject;
        try
        {
            dataService.initWrapper(IADEditPaymentService.GETPROFILEBYID, 'processProfile');
            continuationObject = dataService.getPaymentProfileById(theId);
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
            dataService.populateProfileById();
            system.debug('dataService.theProfile.year ' + dataService.theProfile.year);
            if(Integer.valueOf(dataService.theProfile.year) < System.today().year())
            {
                List<SelectOption> expYearsCopy = new List<SelectOption>();
                expYearsCopy.addAll(expYears);
                expYears.clear();
                expYears.add(new SelectOption( dataService.theProfile.year, dataService.theProfile.year));
                expYears.addAll(expYearsCopy);
            }
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
    public Object updatePaymentProfile()
    {
        Object continuationObject;

        try
        {
            if(Integer.valueOf(dataService.theProfile.year) >= System.today().year() )
            {
                dataService.initWrapper(IADEditPaymentService.PUTPROFILEBYID, 'processUpdateProfile');
                continuationObject = dataService.putPaymentProfileById(theId);
            }
            else
            {
                dataService.populateErrorMessage('Please select a current or future year.');
            }
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
    public Object processUpdateProfile()
    {
        try
        {
            dataService.putPopulateProfileById();

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
    
    public Object DeletePaymentProfile()
    {
        Object continuationObject;

        try
        {
            if(Integer.valueOf(dataService.theProfile.year) >= System.today().year() )
            {
                dataService.initWrapper(IADEditPaymentService.DELETEPAYMENTPROFILEBYID, 'processDeleteProfile');
                continuationObject = dataService.deletePaymentProfileById(theId);
            }
            else
            {
                dataService.populateErrorMessage('Please select a current or future year.');
            }
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
    public Object processDeleteProfile()
    {
        try
        {
            dataService.deletePopulateProfileById();

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