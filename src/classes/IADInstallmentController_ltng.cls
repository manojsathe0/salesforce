public with sharing class IADInstallmentController_ltng
{
    public  static  string  theId {get;set;}
    @Auraenabled public  static String orderId {get;set;}
    @Auraenabled public  static String orderIdNum {get;set;}
    
    public  static String profileId{get;set;}
    @Auraenabled public  static String customerId {get;set;}
    @AuraEnabled public static String selectedPayment{get;set;}
    @auraenabled public static Datetime duedateformat{get;set;}
    public static  IADInstallmentService_ltng installmentService{get;set;}
    public static  Map<String,IADApiGeeEndPoint__mdt> paymentAPItoEndpoint{get;set;}
    @ AuraEnabled public static IADContractBeans_ltng.IADInstallmentWrapper installmentresponse{get;set;}
    @AuraEnabled public static List<IADContractBeans_ltng.IADPaymentProfileBean> profiles{get;set;}
    @AuraEnabled public static List<IADMessage_ltng> messages{get;set;}
    @AuraEnabled public static String currentPaymentProfileId{get;set;}
    @AuraEnabled public static String currentPaymentProfileLabel{get;set;}
    public  static  String dueDate{get;set;}
    public static string invokingPageType;
    @AuraEnabled public static Map<String, String> paymentOptions{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADInstallmentUpdateBean installmentBean {get;set;}
    @AuraEnabled public static List<IADMessage_ltng> exceptions {get;set;}
    
    public IADInstallmentController_ltng () 
    {   
        profiles = new List<IADContractBeans_ltng.IADPaymentProfileBean>();
        
        paymentAPItoEndpoint = new Map<String,IADApiGeeEndPoint__mdt>();
        paymentOptions = new Map<String, String>();
        paymentOptions.put('none', '--Select Payment Method--');
        paymentOptions.put('newPayment', 'Add New Payment Method');
    }
    
    
    
    @Auraenabled 
    public static IADInstallmentController_ltng  populateInstallment(string installment, string orderid )
    {
        IADInstallmentController_ltng installmentdetail = new IADInstallmentController_ltng();
        exceptions = new  List<IADMessage_ltng>();
        
        List<Order__c> orders = [select Name , Contact__r.FkUser__c from Order__c where id =: orderid];
        if(!orders.isEmpty())
        {
            orderId = orders[0].Name;
            orderIdNum=orders[0].Name;
            customerId = orders[0].Contact__r.FkUser__c;
        }
        try
        {
            installmentService  = new IADInstallmentService_ltng();
            String installmentId = installment ;
            IADServiceBase_ltng.initWrapper(IADInstallmentService_ltng.GETINSTALLMENTBYINSTALLMENTID);
            IADInstallmentService_ltng.getInstallmentByInstallmentId(installmentId);
            
            if(IADInstallmentService_ltng.theInstallmentWrapper.installment.adjDueDateInString != null){
                Datetime dt = DateTime.parse(IADInstallmentService_ltng.theInstallmentWrapper.installment.adjDueDateInString);
                duedateformat = dt;
            }
            installmentresponse= IADInstallmentService_ltng.theInstallmentWrapper;
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;        
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages; 
        }
        
        
        
        return  installmentdetail;
    }
    
    
    
    @AuraEnabled
    public static IADInstallmentController_ltng populateProfiles(String customerId, String pageType)
    {
        system.debug('Inside populateProfiles: controller' + customerId);
        //onload();
        //IADInstallmentPaymentController_ltng ctrlRef = new IADInstallmentPaymentController_ltng();
        IADInstallmentController_ltng  ctrlRef= new IADInstallmentController_ltng();
        IADInstallmentPaymentService_ltng installmentpayment = new  IADInstallmentPaymentService_ltng();
        exceptions = new  List<IADMessage_ltng>();
        invokingPageType = pageType;
        try
        {
            system.debug('ready to getPaymentProfilesByUserId');
            system.debug('IADInstallmentPaymentService_ltng.GETPROFILESBYUSERID: '+IADInstallmentPaymentService_ltng.GETPROFILESBYUSERID);
            IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.GETPROFILESBYUSERID); //, 'processProfileResponse'
            IADInstallmentPaymentService_ltng.getPaymentProfilesByUserId(customerId);
            system.debug('ready to process profile response');
            processProfileResponse(customerId);
        }
        catch(IADException theException)
        {
            system.debug('IADException: controller ');
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            system.debug('Exception: controller ');
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        system.debug('Inside populate profile method: Controller Reference: ');
        system.debug(ctrlRef);
        return ctrlRef;
    }
    
    public static void processProfileResponse(String customerId) 
    {
        system.debug('processProfileResponse');
        try
        {
            IADInstallmentPaymentService_ltng.populateProfiles();
            
            if(IADInstallmentPaymentService_ltng.hasPaymentProfiles)
            {
                system.debug('not emty');
                profiles = new List<IADContractBeans_ltng.IADPaymentProfileBean>();
                profiles.addAll(IADInstallmentPaymentService_ltng.profiles);
                if(invokingPageType != 'MakePayment'){
                    populatePaymentOptions();
                }else{
                    // getStoreCreditsByCustomerId(customerId);
                }
            }
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
        }
    }
    public static void populatePaymentOptions()
    {
        paymentOptions.clear();
        
        system.debug('currentPaymentProfileId ' + currentPaymentProfileId);
        system.debug('profiles: '+profiles);
        for(IADContractBeans_ltng.IADPaymentProfileBean profile : profiles)
        {
            currentPaymentProfileLabel = UtilityLibrary.profileAccountTypeToNameMap.get(profile.AccountType) + ' - ' + profile.last4Digits;// + ' - ' + profile.profileId;
            if(!currentPaymentProfileLabel.contains('Manual')){
                paymentOptions.put('pp' + profile.profileId, currentPaymentProfileLabel);
            }
            
            // paymentOptions.put('pp' + profile.profileId, currentPaymentProfileLabel);
            
            if(currentPaymentProfileId == '' || currentPaymentProfileId == null)
            {
                currentPaymentProfileId = 'pp' + profile.profileId;
            }
        }
        
        system.debug('payment options1: '+paymentOptions);
        
        if(profiles != null && profiles.size() > 0)
        {
            if(currentPaymentProfileId != '' && currentPaymentProfileId != null){
                selectedPayment = currentPaymentProfileId;
            }
        }
        
        system.debug('selectedPayment ' + selectedPayment);
        // system.debug('storeCredits: ' + storeCredits);
        
        
        
        system.debug('payment options2: '+paymentOptions);
        
        if(invokingPageType == 'MakeRefund'){
            paymentOptions.put('0', '');
            paymentOptions.put('refundToStoreCredit', 'Store Credit');
        }
        
        if(paymentOptions.size() == 0){
            paymentOptions.put('none', '--Select Payment Method--');
        }
        
        paymentOptions.put('newPayment', 'Add New Payment Method');
        
        system.debug('payment options3: '+paymentOptions);
    }
    
    @AuraEnabled
    public static IADInstallmentController_ltng  updateInstallment(string installmentId,String installmenttoupdate, String profileId ,string dueDate)
    {
        IADInstallmentController_ltng installmentupdate = new IADInstallmentController_ltng();   
        try
        {
            
            
            exceptions = new  List<IADMessage_ltng>();
            installmentService  = new IADInstallmentService_ltng();
            IADContractBeans_ltng.IADInstallmentWrapper   theInstallmentWrapper = (IADContractBeans_ltng.IADInstallmentWrapper) JSON.deserialize(installmenttoupdate,IADContractBeans_ltng.IADInstallmentWrapper.class); 
            // String installmentId = theId;
            
            IADServiceBase_ltng.initWrapper(IADInstallmentService_ltng.PUTUPDATEINSTALLMENTBYINSTALLMENTID);
            //IADInstallmentService_ltng.getInstallmentByInstallmentId(installmentId);
            // installmentService.initWrapper(IADInstallmentService.PUTUPDATEINSTALLMENTBYINSTALLMENTID, 'processUpdateInstallmentResponse');
            installmentBean = new IADContractBeans_ltng.IADInstallmentUpdateBean();
            
            Datetime oldDueDate = UtilityLibrary.getIADDateTimeDT(theInstallmentWrapper.installment.dueDate);
            dueDate=UtilityLibrary.getIADDateTime(dueDate);
            Datetime newDueDate = UtilityLibrary.convertJSDateToIADDateDT(dueDate);
            
            Integer dueDateDaysBetween = Date.valueOf(oldDueDate).daysBetween(Date.valueOf(newDueDate));
            
            Integer todayDaysBetween = Date.valueOf(Datetime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0))).daysBetween(Date.valueOf(newDueDate));
            
            if(dueDateDaysBetween>14)
            {
                IADServiceBase_ltng.populateErrorMessage('Date cannot be set past two weeks from the original due date.');
                exceptions = IADServiceBase_ltng.iadMessages;
                // installmentService.populateErrorMessage('Date cannot be set past two weeks from the original due date.');
            }
            else if(todayDaysBetween<0)
            {
                IADServiceBase_ltng.populateErrorMessage('Date cannot be set to the past.');
                exceptions = IADServiceBase_ltng.iadMessages;
                // installmentService.populateErrorMessage('Date cannot be set to the past.');
            }
            
            if(IADServiceBase_ltng.errorCount==0)
            {
                installmentBean.dueDate = UtilityLibrary.convertJSDateToIADDate(dueDate, theInstallmentWrapper.installment.dueDate);
                installmentBean.updatedBy = UtilityLibrary.generateUpdatedBy();
                installmentBean.paymentProfileId = Integer.valueOf(UtilityLibrary.stripStoreCreditOrProfileId(profileId));
                
                IADInstallmentService_ltng.putInstallmentByInstallmentId(JSON.serialize(installmentBean), installmentId);
            }           
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;          
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
            
        }
        exceptions = IADServiceBase_ltng.iadMessages; 
        return installmentupdate;
    }
    
}