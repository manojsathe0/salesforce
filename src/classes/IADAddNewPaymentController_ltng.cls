public class IADAddNewPaymentController_ltng
{
    @AuraEnabled public static String orderId{get;set;}
    @AuraEnabled public static String customerId{get;set;}
    public String tabId{get;set;}
    public static Boolean showModal{get;set;}
    public Boolean showDupeModal{get;set;}
    @auraenabled public  static IADContractBeans_ltng.IADNewPaymentProfileRequest newPayment{get;set;}
    @auraenabled  public  static List<IADContractBeans_ltng.IADPaymentProfileBean> dupeProfiles{get;set;}
    @AuraEnabled public static List<IADContractBeans_ltng.IADPaymentProfileBean> profiles{get;set;}
    @AuraEnabled public  static List<IADContractBeans_ltng.IADInstallmentBean> installments{get;set;}
    @AuraEnabled public static List<GridWrapper> gridWrappers{get;set;}
    public static List<Order__c> contactOrders{get;set;}
    
    @AuraEnabled public  static List<IADContractBeans_ltng.IADSubscription> subscriptions{get;set;}
    
    public static  Map<String,Order__c>orderNumToOrder{get;set;}
    public  static Map<String, IADContractBeans_ltng.IADInstallmentBean> installmentIdToInstallment{get;set;}
    public  static Map<String, IADContractBeans_ltng.IADPaymentProfileBean> profileIdToProfile{get;set;}
    @auraenabled public  static IADContractBeans_ltng.IADPaymentProfileBean responseData{get;set;}
    public static string invokingPageType;
    @auraenabled public static map<string ,string> months{get;set;}
    @auraenabled public static map<string ,string> years{get;set;}
    @auraenabled public static map<string ,string> cardtypes{get;set;}
    @auraenabled public static map<string ,string> states{get;set;}
    @auraenabled public static IADContractBeans_ltng.IADNewPaymentProfileRequest profilerequest{get;set;}
    @AuraEnabled public static List<IADMessage_ltng> exceptions {get;set;}
    @AuraEnabled public static string sfBaseURL {get; set;}
    
    @auraenabled
    public static IADAddNewPaymentController_ltng onload()
    {
        sfBaseURL=Url.getSalesforceBaseUrl().getHost().replace('my.salesforce','visual.force');        
        profilerequest = new IADContractBeans_ltng.IADNewPaymentProfileRequest(); 
        IADAddNewPaymentController_ltng newpayment = new IADAddNewPaymentController_ltng();
        exceptions = new List<IADMessage_ltng>();
        months = new map<string ,string>();
        years = new map<string ,string>();
        cardtypes = new map<string ,string>();
        states = new map<string ,string>();
        for(SelectOption  expmonth : UtilityLibrary.expMonths)
        {
            months.put(expmonth.getLabel(), expmonth.getValue());
        }
        for(SelectOption  expmonth : UtilityLibrary.expYears)
        {
            years.put(expmonth.getLabel(), expmonth.getValue());
        }
        for(SelectOption  expmonth : UtilityLibrary.paymentTypes)
        {
            cardtypes.put(expmonth.getLabel(), expmonth.getValue());
        }
        for(SelectOption  expmonth : UtilityLibrary.statePicklist)
        {
            states.put(expmonth.getLabel(), expmonth.getValue());
        }
        return  newpayment;
        
    }
    @Auraenabled
    public static IADAddNewPaymentController_ltng addNewPayment(string profiletocreate ,string  customerId)
    { 
        IADAddNewPaymentController_ltng addnewpayment = new IADAddNewPaymentController_ltng();
        
        IADNewPaymentService_ltng newpaymentservice = new IADNewPaymentService_ltng();
        newPayment = (IADContractBeans_ltng.IADNewPaymentProfileRequest) JSON.deserialize(profiletocreate,IADContractBeans_ltng.IADNewPaymentProfileRequest.class);
        exceptions = new List<IADMessage_ltng>();
        // IADContractBeans_ltng.IADNewPaymentProfileRequest newPayment = new IADContractBeans_ltng.IADNewPaymentProfileRequest();
        system.debug('The payment'+newPayment);
        try
        {
            
            if(newPayment.accountNumber.length() != 15 && newPayment.accountType == UtilityLibrary.profileNameToAccountTypeMap.get('American Express'))
            {
                IADServiceBase_ltng.populateErrorMessage('American Express cards should have 15 digits only.');
                exceptions = IADServiceBase_ltng.iadMessages; 
                
            }
            if(newPayment.month < System.today().month() && newPayment.year == system.today().year())
            {
                IADServiceBase_ltng.populateErrorMessage('Expiry date should be in the future');
                exceptions = IADServiceBase_ltng.iadMessages;
                
            }
            if(IADServiceBase_ltng.errorCount==0)
            {
                newPayment.firstDigit = newPayment.accountNumber.substring(0, 1);
                newPayment.last4Digits = newPayment.accountNumber.right(4);
                newPayment.customerId = customerId;
                if(newPayment.addressLine2==null)
                    newPayment.addressLine2='';
                IADServiceBase_ltng.initWrapper(IADNewPaymentService_ltng.ADDNEWPAYMENT);
                IADContractBeans_ltng.IADNewPaymentProfileRequestBean bean = new IADContractBeans_ltng.IADNewPaymentProfileRequestBean();
                bean.paymentProfile = newPayment;
                system.debug('the bean'+bean);
                IADNewPaymentService_ltng.postNewPayment(bean);
                processAddPaymentProfileResponse();
            }
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            exceptions = IADServiceBase_ltng.iadMessages;
            // newPaymentService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            exceptions = IADServiceBase_ltng.iadMessages;
            //newPaymentService.populateErrorMessage(theException.getMessage());
        }
        
        exceptions = IADServiceBase_ltng.iadMessages;
        return addnewpayment;
    }
    
    //callback method
    public static void processAddPaymentProfileResponse()
    {
        try
        {
            IADNewPaymentService_ltng.readNewPaymentResponse();
            responseData = IADNewPaymentService_ltng.theProfile;
            
            if(IADNewPaymentService_ltng.statusCode == '201')
            {
                IADServiceBase_ltng.populateSuccessMessage('Payment profile successfully created! Please wait while we check the system for any installments / subscriptions to apply the new profile to.');
                exceptions = IADServiceBase_ltng.iadMessages;
                // newPaymentService.populateSuccessMessage('Payment profile successfully created! Please wait while we check the system for any installments / subscriptions to apply the new profile to.');
            }
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            exceptions = IADServiceBase_ltng.iadMessages;
            // newPaymentService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            exceptions = IADServiceBase_ltng.iadMessages;
            //newPaymentService.populateErrorMessage(theException.getMessage());
        }
        //return null;
    }
    @AuraEnabled
    public static   IADAddNewPaymentController_ltng populateProfiles(string profiletocreate, String customerId)
    {
        exceptions = new List<IADMessage_ltng>();
        system.debug('Inside populateProfiles: controller' + customerId);
        //onload();
        //IADInstallmentPaymentController_ltng ctrlRef = new IADInstallmentPaymentController_ltng();
        IADAddNewPaymentController_ltng addnewpayment = new IADAddNewPaymentController_ltng();
        
        IADNewPaymentService_ltng newpaymentservice = new IADNewPaymentService_ltng();
        newPayment = (IADContractBeans_ltng.IADNewPaymentProfileRequest) JSON.deserialize(profiletocreate,IADContractBeans_ltng.IADNewPaymentProfileRequest.class);
        // IADContractBeans_ltng.IADNewPaymentProfileRequest newPayment = new IADContractBeans_ltng.IADNewPaymentProfileRequest();
        
        IADInstallmentPaymentService_ltng installmentpayment = new  IADInstallmentPaymentService_ltng();
        
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
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            system.debug('Exception: controller ');
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        system.debug('Inside populate profile method: Controller Reference: ');
        exceptions = IADServiceBase_ltng.iadMessages;
        return  addnewpayment;      
    }
    
    public static void processProfileResponse(String customerId) 
    {
        system.debug('processProfileResponse');
        try
        {  dupeProfiles = new List<IADContractBeans_ltng.IADPaymentProfileBean>();
         IADInstallmentPaymentService_ltng.populateProfiles();
         
         if(IADInstallmentPaymentService_ltng.hasPaymentProfiles)
         {
             system.debug('not emty');
             profiles = new List<IADContractBeans_ltng.IADPaymentProfileBean>();
             profiles.addAll(IADInstallmentPaymentService_ltng.profiles);
             newPayment.firstDigit = newPayment.accountNumber.substring(0, 1);
             newPayment.last4Digits = newPayment.accountNumber.right(4);
             for(IADContractBeans_ltng.IADPaymentProfileBean theProfile :IADInstallmentPaymentService_ltng.profiles)
             {
                 if(newPayment.firstDigit == theProfile.firstDigit && newPayment.last4Digits == theProfile.last4Digits)
                 {
                     dupeProfiles.add(theProfile);
                     
                 }
                 
             }
             
         }
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            exceptions = IADServiceBase_ltng.iadMessages;
        }
    }
    
    
    @AuraEnabled
    public static  IADAddNewPaymentController_ltng populateInstallments(String orderRecordId ,string ordername)
    {
        IADAddNewPaymentController_ltng newpaymentcontroller = new  IADAddNewPaymentController_ltng();
        installments= new List<IADContractBeans_ltng.IADInstallmentBean>();
        exceptions = new List<IADMessage_ltng>();
        IADInstallmentService_ltng  installmentService = new IADInstallmentService_ltng();
        getorderid(orderRecordId ,ordername);
        try
        {
            IADServiceBase_ltng.initWrapper(IADInstallmentService_ltng.GETINSTALLMENTSBYORDERID); //, 'processInstallmentResponse'
            
            IADInstallmentService_ltng.getInstallmentsByOrderId(orderId);
            if(IADInstallmentService_ltng.theInstallmentsWrapper!=null)
                installments.addAll(IADInstallmentService_ltng.theInstallmentsWrapper.installments);
            // populateWrappers();
            system.debug('installmnets'+installments);
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADInstallmentService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADInstallmentService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        system.debug('installmentService');
        system.debug(installmentService);
        exceptions = IADServiceBase_ltng.iadMessages;
        return newpaymentcontroller;
    }
    
    
    @AuraEnabled
    public static IADAddNewPaymentController_ltng   populateSubscriptions(String orderRecordId,string ordername)
    {
        IADAddNewPaymentController_ltng newpaymentcontroller = new  IADAddNewPaymentController_ltng();
        IADSubscriptionPanelService_Ltng  subscriptionService = new IADSubscriptionPanelService_Ltng ();
        subscriptions = new List<IADContractBeans_ltng.IADSubscription>();
        exceptions = new List<IADMessage_ltng>();
        system.debug('orderRecordId: '+orderRecordId);
        //Object continuationObject;
        try
        {
            getorderid(orderRecordId, ordername);
            system.debug('orderId: '+orderId);
            IADSubscriptionPanelService_Ltng.isSubscriptionLoaded = false;
            IADServiceBase_Ltng.initWrapper(IADSubscriptionPanelService.GETSUBSCRIPTIONSBYORDERID); //, 'processSubscriptions'
            //continuationObject = subscriptionService.getSubscriptionsyByOrderId(orderId);  
            IADSubscriptionPanelService_Ltng.getSubscriptionsyByOrderId(orderId, customerId);
            if(IADSubscriptionPanelService_Ltng.subscriptionItem!=null)
                subscriptions.addall(IADSubscriptionPanelService_Ltng.subscriptionItem.subscriptions);
        }
        catch(IADException theException)
        {
            IADServiceBase_Ltng.populateErrorMessage(theException); 
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_Ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        system.debug('subscriptionService: '+subscriptionService);
        exceptions = IADServiceBase_ltng.iadMessages;
        return newpaymentcontroller; 
    }    
    
    
    public static void   getorderid(String orderRecordId ,string ordername) 
    {
        orderNumToOrder= new Map<String,Order__c>();
        //paymentProfileService = new IADInstallmentPaymentService_ltng();
        
        //orderId = ApexPages.currentPage().getParameters().get('Id');
        List<Order__c> orders;
        if(String.isNotBlank(orderRecordId))
        {
            orders=  [SELECT Name, OrderID__c, Contact__r.FKUser__c FROM Order__c WHERE Id = :orderRecordId limit 1];
        }
        else
        {
            orders=  [SELECT Name, OrderID__c, Contact__r.FKUser__c FROM Order__c WHERE OrderID__c = :ordername limit 1];   
        }
        
        if(!orders.isEmpty())
        {
            orderId = orders[0].Name;
            customerId = orders[0].Contact__r.FKUser__c;
            String contactid = [select id from Contact where fkUser__c =: customerId and Contact_Type__c='Primary Contact' limit 1].Id;
            contactOrders = [SELECT Id, Name, Product_Name__c FROM Order__c WHERE Contact__c = :contactid ORDER BY Name DESC];
        }
        
        if(contactOrders != null && contactOrders.size() > 0)
        {
            for(Order__c o : contactOrders)
            {
                orderNumToOrder.put(o.Name, o);
            }
        }
        //approvalIcon = IADSGVIconStrings.checkIcon;
    }
    
    
    public class GridWrapper
    {
        @AuraEnabled public String wrapId{get;set;}
        @AuraEnabled  public Integer index{get;set;}
        @AuraEnabled  public String orderNum{get;set;}
        @AuraEnabled   public String orderDesc{Get;set;}
        @AuraEnabled public String ccInfo {get;set;}
        @AuraEnabled public String lastChargeDate{get;set;}
        @AuraEnabled  public String lastChargeAmnt{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled   public String wrapType{get;set;}
        @AuraEnabled public Boolean show{get;set;}
    }
    @AuraEnabled
    public  static IADAddNewPaymentController_ltng populateWrappers(String orderRecordId, string insts ,string subs,string profileidmap,string ordername)
    {
        
        IADAddNewPaymentController_ltng newpaymentcontroller = new  IADAddNewPaymentController_ltng();
        exceptions = new List<IADMessage_ltng>();
        //IADContractBeans_ltng.IADInstallmentsWrapper deserialzedInstallments =  (IADContractBeans_ltng.IADInstallmentsWrapper) JSON.deserialize(insts, IADContractBeans_ltng.IADInstallmentsWrapper.class);
        installments= (List<IADContractBeans_ltng.IADInstallmentBean>)JSON.deserialize(insts,List<IADContractBeans_ltng.IADInstallmentBean>.class);
        // installments =deserialzedInstallments.installments;
        subscriptions=    (List<IADContractBeans_ltng.IADSubscription>)JSON.deserialize(subs , List<IADContractBeans_ltng.IADSubscription>.class);
        getorderid(orderRecordId , ordername);
        installmentIdToInstallment = new Map<String, IADContractBeans_ltng.IADInstallmentBean>();
        
        profiles=(List<IADContractBeans_ltng.IADPaymentProfileBean>)JSON.deserialize(profileidmap,List<IADContractBeans_ltng.IADPaymentProfileBean>.class);
        profileIdToProfile = new  Map<String, IADContractBeans_ltng.IADPaymentProfileBean>();
        for(IADContractBeans_ltng.IADPaymentProfileBean theProfile : profiles)
        {
            profileIdToProfile.put(theProfile.profileId, theProfile);
        }
        gridWrappers = new List<GridWrapper>();
        system.debug('installments ' + installments);
        if(installments != null && installments.size()>0)
        {
            for(IADContractBeans_ltng.IADInstallmentBean inst : installments)
            {
                installmentIdToInstallment.put(inst.installmentId, inst);
            }
            for(IADContractBeans_ltng.IADInstallmentBean inst : installments)
            {
                Integer index = 0;
                system.debug('inst ' + inst);
                if(IADPaymentTransaction.installmentBillStatusMap.get(inst.installmentBillStatus) != 'Paid')
                {
                    
                    IADContractBeans_ltng.IADPaymentProfileBean profile = profileIdToProfile.get(inst.paymentProfileId);
                    GridWrapper wrap = new GridWrapper();
                    wrap.wrapId = inst.installmentId;
                    wrap.index = index;
                    wrap.orderNum = 'Inst-' +  inst.orderId;
                    IF(orderNumToOrder.get(inst.orderId)!=null)
                        wrap.orderDesc = orderNumToOrder.get(inst.orderId).Product_Name__c;
                    if(profile != null)
                        wrap.ccInfo = UtilityLibrary.profileAccountTypeToNameMap.get(profile.AccountType) +' xxxx' + profile.last4Digits;
                    wrap.lastChargeDate = inst.adjDueDateInString;
                    wrap.lastChargeAmnt = inst.balanceDueAmount;
                    wrap.status = IADPaymentTransaction.installmentBillStatusMap.get(inst.installmentBillStatus);
                    wrap.show=false;
                    wrap.wrapType='installment';
                    gridWrappers.add(wrap);
                    index++;
                }
            }
        }
        system.debug('subscriptions ' + subscriptions);
        if(subscriptions != null && subscriptions.size()>0)
        {
            for(IADContractBeans_ltng.IADSubscription sub : subscriptions)
            {
                system.debug('sub ' + sub);
                Integer index = 0;
                if(sub.status != 'Cancelled' && sub.status != 'Expired')
                {
                    IADContractBeans_ltng.IADPaymentProfileBean profile = profileIdToProfile.get(sub.paymentProfileId);
                    GridWrapper wrap = new GridWrapper();
                    wrap.wrapId = sub.orderItemSubscriptionId;
                    wrap.index = index;
                    wrap.orderNum = 'Sub-' + sub.orderId;
                    wrap.orderDesc = sub.productName;
                    if(profile != null)
                        wrap.ccInfo = UtilityLibrary.profileAccountTypeToNameMap.get(profile.AccountType) +' xxxx' + profile.last4Digits;
                    wrap.lastChargeDate = sub.adjSubscriptionEndDate;
                    wrap.lastChargeAmnt = String.valueOf(sub.renewalPrice);
                    wrap.status = sub.Status;
                    wrap.show=false;
                    wrap.wrapType='subscription';
                    gridWrappers.add(wrap);
                    
                    index++;
                }
            }
        }
        
        system.debug('gridWrappers ' + gridWrappers);
        exceptions = IADServiceBase_ltng.iadMessages;
        return  newpaymentcontroller;
    }
    
    @auraenabled public static void updateinstallment(string instid ,string profileidupdate, string insts)
        
    {
        
        installments= (List<IADContractBeans_ltng.IADInstallmentBean>)JSON.deserialize(insts,List<IADContractBeans_ltng.IADInstallmentBean>.class);
        installmentIdToInstallment = new Map<String, IADContractBeans_ltng.IADInstallmentBean>();
        exceptions = new List<IADMessage_ltng>();
        if(installments != null && installments.size()>0)
        {
            for(IADContractBeans_ltng.IADInstallmentBean inst : installments)
            {
                installmentIdToInstallment.put(inst.installmentId, inst);
            }
        }
        IADAddNewPaymentController_ltng newpaymentcontroller = new  IADAddNewPaymentController_ltng();
        IADInstallmentService_ltng  installmentService = new IADInstallmentService_ltng();
        try
        {
            IADServiceBase_ltng.initWrapper(IADInstallmentService_ltng.PUTUPDATEINSTALLMENTBYINSTALLMENTID); //, 'processInstallmentResponse'
            
            
            
            IADContractBeans_ltng.IADInstallmentBean inst = installmentIdToInstallment.get(instId);
            IADContractBeans_ltng.IADInstallmentUpdateBean updateBean = new IADContractBeans_ltng.IADInstallmentUpdateBean();
            updateBean.dueDate = inst.dueDate;
            updateBean.paymentProfileId = Integer.valueOf(profileidupdate);
            updateBean.updatedBy = UtilityLibrary.generateUpdatedBy();
            
            system.debug('updatebean ' + updateBean);
            
            IADInstallmentService_ltng.putInstallmentByInstallmentId(JSON.serialize(updateBean), instId);
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADInstallmentService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADInstallmentService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        
        
    }
    
    
    
    @auraenabled public static void updatesubscription(string subId ,string profileidupdate)
        
    {
        
        
        IADAddNewPaymentController_ltng newpaymentcontroller = new  IADAddNewPaymentController_ltng();
        IADSubscriptionPanelService_Ltng  subscriptionService = new IADSubscriptionPanelService_Ltng ();
        exceptions = new List<IADMessage_ltng>();
        
        try
        {
            IADServiceBase_ltng.initWrapper(IADSubscriptionPanelService_Ltng.PUTSUBSCRIPTIONBYSUBSCRIPTIONID); //, 'processInstallmentResponse'
            
            
            
            
            IADSubscriptionPanelService_Ltng.putSubscriptionBySubscriptionId(subId, 1, Integer.valueOf(profileidupdate), null, null, null);
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADInstallmentService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            IADInstallmentService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            exceptions = IADServiceBase_ltng.iadMessages;
        }
        
        
    }
    
}