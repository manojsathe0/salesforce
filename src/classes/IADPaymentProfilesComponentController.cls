public class IADPaymentProfilesComponentController 
{
    
    public String theId{get;set;}
    public String orderId{get;set;}
    public String selectedPayment{get;set;}
    public List<selectOption> paymentOptions{get;set;}
    public List<IADContractBeans.IADPaymentProfileBean> profiles{get;set;}
    public List<IADContractBeans.IADStoreCreditBean> storeCredits{get;set;}
    public IADPaymentProfilesService dataService{get;set;}
    public String userId{get;set;}
    public String currentPaymentProfileId{get;set;}
    public String currentPaymentProfileLabel{get;set;}
    public String invokingPageType{get;set;}
    public String invokingPageId{get;set;}
    public IADStoreCreditPanelService storeCreditPanelService{get;set;}

    
    public IADPaymentProfilesComponentController()
    {
        paymentOptions = new List<selectOption>();
        paymentOptions.add(new SelectOption('none', '--Select Payment Method--'));
        paymentOptions.add(new SelectOption(newPayment, 'Add New Payment Method'));

        theId = ApexPages.currentPage().getParameters().get('id');
        dataService = new IADPaymentProfilesService();
        storeCreditPanelService = new IADStoreCreditPanelService();
        profiles = new List<IADContractBeans.IADPaymentProfileBean>();
        storeCredits = new List<IADContractBeans.IADStoreCreditBean>();

        system.debug('currentPaymentProfileId ' + currentPaymentProfileId);

    }
    public static String refundToStoreCredit
    {
        get{
            return 'refundToStoreCredit';
        }
        set;
    }

    public static String newPayment
    {
        get{
            return 'newPayment';
        }
        set;
    }
    public void setSelectedProfileId()
    {
        //profileId = Apexpages.currentPage().getParameters().get('profileId');
        system.debug('selectedPayment '  + selectedPayment);
    }


    public void populatePaymentOptions()
    {
        paymentOptions.clear();

        system.debug('currentPaymentProfileId ' + currentPaymentProfileId);
        for(IADContractBeans.IADPaymentProfileBean profile : profiles)
        {
            currentPaymentProfileLabel = UtilityLibrary.profileAccountTypeToNameMap.get(profile.AccountType) + ' - ' + profile.last4Digits;// + ' - ' + profile.profileId;

            paymentOptions.add(new SelectOption('pp' + profile.profileId, currentPaymentProfileLabel));

            if(currentPaymentProfileId == '' || currentPaymentProfileId == null)
            {
                currentPaymentProfileId = 'pp' + profile.profileId;
            }
        }
        if(profiles!= null && profiles.size()>0)
        {
            if(currentPaymentProfileId != '' && currentPaymentProfileId != null)
                selectedPayment = currentPaymentProfileId;
        }

        system.debug('selectedPayment ' + selectedPayment);


        for(IADContractBeans.IADStoreCreditBean storeCredit : storeCredits)
        {
            if(storeCredit.refundableFlag && storeCredit.amount.setScale(2) > 0)
            {
                currentPaymentProfileLabel =  storeCredit.code + ' -  $' + storeCredit.amount.setScale(2) + ' : ' + IADPaymentTransaction.storeCreditStatusMap.get(Integer.valueOf(storeCredit.storeCreditStatusId));

                paymentOptions.add(new SelectOption('sc' + storeCredit.storeCreditId, currentPaymentProfileLabel));

                if(currentPaymentProfileId == '' || currentPaymentProfileId == null)
                {
                    currentPaymentProfileId = 'sc' + storeCredit.storeCreditId;
                }
            }
        }

        if(invokingPageType == 'MakeRefund')
            paymentOptions.add(new SelectOption(refundToStoreCredit, 'Store Credit'));

        if(paymentOptions.size()==0)
            paymentOptions.add(new SelectOption('none', '--Select Payment Method--'));
        paymentOptions.add(new SelectOption(newPayment, 'Add New Payment Method'));
    }
    
    public Object populateProfiles()
    {
        system.debug('populateProfiles ' + userId);
        Object continuationObject;
        try
        {
            dataService.initWrapper(IADPaymentProfilesService.GETPROFILESBYUSERID, 'processProfileResponse');
            continuationObject = dataService.getPaymentProfilesByUserId(userId);
        }
        catch(IADException theException)
        {
            dataService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            dataService.populateErrorMessage(theException.getMessage());
        }
        return continuationObject; 
    }
    
    //Callback method for Asynchronous
    public Object processProfileResponse() 
    {
        
        system.debug('processProfileResponse');
        try
        {
            dataService.initHTTPResponse(IADPaymentProfilesService.GETPROFILESBYUSERID);
            
            dataService.populateProfiles();

            if(dataService.hasPaymentProfiles)
            {
                system.debug('not emty');
                profiles = new List<IADContractBeans.IADPaymentProfileBean>();
                profiles.addAll(dataService.profiles);
                if(invokingPageType!='MakePayment')
                    populatePaymentOptions();
            }
        
        }
        catch(IADException theException)
        {
            dataService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            dataService.populateErrorMessage(theException.getMessage());
        }
        return null;
    }

    public Object populateStoreCredits()
    {

        Object continuationObject;
        try
        {
            storeCreditPanelService.initWrapper(IADStoreCreditPanelService.GETSTORECREDITSBYCUSTOMERID, 'processStoreCredits');
            continuationObject = storeCreditPanelService.getStoreCreditsByCustomerId(userId);

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

    public Object processStoreCredits()
    {
        try
        {
            storeCreditPanelService.populateStoreCredits();

            if(storeCreditPanelService.hasStoreCredit)
            {
                storeCredits = storeCreditPanelService.storeCredit.storeCredits;

                system.debug('storeCredits ' + storeCredits);
            }
            if(storeCreditPanelService.errorCount==0)
            {
                populatePaymentOptions();
            }
            else
            {
                dataService.iadMessages = storeCreditPanelService.iadMessages;
                dataService.errorCount = storeCreditPanelService.errorCount;
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
}