public class IADInstallmentPaymentController_ltng 
{
    @AuraEnabled public static String selectedPayment{get;set;}
    @AuraEnabled public static String email{get;set;}
    @AuraEnabled public static String paymentType{get;set;}
    @AuraEnabled public static String paymentName{get;set;}
    @AuraEnabled public static String amount{get;set;}
    @AuraEnabled public static String customerId{get;set;}
    @AuraEnabled public static String orderNum{get;set;}
    @AuraEnabled public static String responseStatus{get;set;}
    @AuraEnabled public static String invokingPage{get;set;}
    @AuraEnabled public static String invokingPageId{get;set;}
    @AuraEnabled public static String currentPaymentProfileId{get;set;}
    @AuraEnabled public static String currentPaymentProfileLabel{get;set;}
    @AuraEnabled public static String invokingPageType{get;set;}
    
    @AuraEnabled public static Integer otherAmountCounts{get;set;}
    
    @AuraEnabled public static Decimal amountDue{get;set;}
    @AuraEnabled public static Decimal theBalance{get;set;}
    
    @AuraEnabled public static Boolean isStoreCreditPayment{get;set;}
    
    @AuraEnabled public static Boolean isPaymentProcessed{get;set;}
    
    @AuraEnabled public static IADInstallmentPaymentService_ltng paymentService{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADPaymentBean thePayment{get;set;}
    @AuraEnabled public static IADContractBeans.IADOrderBalance theOrderBalance{get;set;}
    
    @AuraEnabled public static IAD_Config__mdt config{get;set;}
    
    @AuraEnabled public static Map<String, String> paymentOptions{get;set;}
    
    @AuraEnabled public static List<IADContractBeans_ltng.IADPaymentProfileBean> profiles{get;set;}
    @AuraEnabled public static List<IADContractBeans_ltng.IADStoreCreditBean> storeCredits{get;set;}
    
    @AuraEnabled public static List<IADMessage_ltng> messages{get;set;}
    
    @AuraEnabled
    public static Map<String, String> paymentReasons
    {
        get
        {
            if(paymentReasons == null)
            {
                paymentReasons= new Map<String, String>();
                for (IAD_Payment_Reason__c reason : [SELECT ReasonId__c, Reason__c FROM IAD_Payment_Reason__c order by Reason__c asc])
                {
                    paymentReasons.put(reason.Reason__c, String.valueOf(reason.ReasonId__c));
                }
            }
            return paymentReasons;
        }
        set;
    }
    
    public static void onload(){
        isPaymentProcessed = false;
        paymentService = new IADInstallmentPaymentService_ltng();
        profiles = new List<IADContractBeans_ltng.IADPaymentProfileBean>();
        storeCredits = new List<IADContractBeans_ltng.IADStoreCreditBean>();
        messages = new List<IADMessage_ltng>();
        
        paymentOptions = new Map<String, String>();
        paymentOptions.put('none', '--Select Payment Method--');
        paymentOptions.put('newPayment', 'Add New Payment Method');
        
        otherAmountCounts = 0;
        config = UtilityLibrary.getConfig();
    }
    
    @AuraEnabled
    public static IADInstallmentPaymentController_ltng initCtrl(String orderId, String customerId, String invokingPage, String invokingPageId)
    {
        system.debug('customerid ' + customerId);
        
        IADInstallmentPaymentController_ltng ctrlRef = new IADInstallmentPaymentController_ltng();
        
        onload();
        
        if(customerId != null && customerId != '')
        {
            List<Customer_Login__c> customerLogins = [SELECT Id , Primary_Contact__r.Email FROM Customer_Login__c WHERE Customer_ID__c = :customerId];
            system.debug('customerLogins: '+customerLogins);
            if(!customerLogins.isEmpty())
            {
                email = customerLogins[0].Primary_Contact__r.Email;
            }
        }
        
        return ctrlRef;
    }
    
    @AuraEnabled
    public static IADInstallmentPaymentController_ltng populateOrderBalances(String orderNumber)
    {
        system.debug('ready to populate order balance');
        IADInstallmentPaymentController_ltng ctrlRef = new IADInstallmentPaymentController_ltng();
        IADOrderWithOrderItemsService_ltng orderService = new IADOrderWithOrderItemsService_ltng();
        messages = new List<IADMessage_ltng>();
        try
        {
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERBALANCESBYORDERID);//, 'processOrderBalancesResponse'
            IADOrderWithOrderItemsService_ltng.getOrderBalanceByOrderId(orderNumber);
            processOrderBalancesResponse();
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages = IADServiceBase_ltng.iadMessages;
        }
        messages = IADServiceBase_ltng.iadMessages;
        return ctrlRef;
    }

    public static void processOrderBalancesResponse()
    {
        try
        {
            system.debug('made it to response');
            IADOrderWithOrderItemsService_ltng.populateOrderBalance();

            APIRequestResponseWrapper_ltng response =  IADServiceBase_ltng.APItoWrapper.get(IADOrderWithOrderItemsService_ltng.GETORDERBALANCESBYORDERID);

            if(response.checkIsValidResponse())
            {
                if(paymentName != 'Installment')
                {
                    amount = String.valueOf(IADOrderWithOrderItemsService_ltng.theOrderBalance.orderBalanceAmount);
                    amountDue = IADOrderWithOrderItemsService_ltng.theOrderBalance.orderBalanceAmount;
                }
                else{
                    amountDue = Decimal.valueOf(amount); //Decimal.valueOf(balanceService.theOrderBalance.subTotalInstallmentBalance);
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(response);
                messages = IADServiceBase_ltng.iadMessages;
            }

        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    @AuraEnabled
    public static IADInstallmentPaymentController_ltng postPayment(String orderNumber, Decimal processAmount, Decimal dueAmount, String invokingPage, String selectedReason, String comments, String profileId, String email, String installmentId ,string firstname ,string lastname ,string bankname ,string checknumber)
    {
        IADInstallmentPaymentController_ltng ctrlRef = new IADInstallmentPaymentController_ltng();
        onload();
        isStoreCreditPayment = false;
        system.debug('it is working: '); 
        processAmount = processAmount.setScale(2);
        dueAmount = dueAmount.setScale(2);
        try
        {
            system.debug('installmentId ' + installmentId + 'processAmount + ' + processAmount + ' dueAmount ' + dueAmount + ' orderNumber ' + orderNumber + ' invokingPage ' + invokingPage + ' selectedReason ' + selectedReason + ' comments ' + comments + ' profileId ' + profileId + ' email ' + email);
            if(email != null && email != ''){
                email = email.trim();
            }

            if(profileId.contains('pp'))
            {
              
                system.debug('step1');
                if(invokingPage != 'Installment')
                {
                    system.debug('step2');
                    IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.POSTPAYMENT);//, 'processPaymentResponse'
                    IADContractBeans_ltng.IADMakePaymentBean paymentbean = new IADContractBeans_ltng.IADMakePaymentBean();
                    paymentbean.orderId = orderNumber;
                    paymentbean.amount = String.valueOf(processAmount);
                    paymentbean.createdBy = UtilityLibrary.generateUpdatedBy_withPrefix();
                    paymentbean.source = config.Payment_Source__c;
                    paymentbean.paymentProfileId = UtilityLibrary.stripStoreCreditOrProfileId(profileId);
                    paymentbean.gateway = config.Payment_Gateway__c;
                    paymentbean.comments = comments;
                    paymentbean.reasonId = selectedReason;
                    paymentbean.notificationEmail = email;
                    
                    IADInstallmentPaymentService_ltng.postPayment(paymentbean);
                    system.debug('paymentbean: '+paymentbean);
                    processPaymentResponse(processAmount);
                }
                else
                {
                    system.debug('ready to process installment payment');
                    IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.POSTPAYMENTFORINSTALLMENT);//, 'processPaymentForInstallmentResponse'
                    IADContractBeans_ltng.IADMakePaymentInstallmentBean paymentbean = new IADContractBeans_ltng.IADMakePaymentInstallmentBean();
                    paymentbean.orderId = orderNumber;
                    paymentbean.amount = String.valueOf(processAmount);
                    paymentbean.createdBy = UtilityLibrary.generateUpdatedBy_withPrefix();
                    paymentbean.source = config.Payment_Source__c;
                    paymentbean.paymentProfileId = UtilityLibrary.stripStoreCreditOrProfileId(profileId);
                    paymentbean.gateway = config.Payment_Gateway__c;
                    paymentbean.comments = comments;
                    paymentbean.reasonId = selectedReason;
                    paymentbean.notificationEmail = email;
                    paymentBean.installmentBill = installmentId;
                    
                    IADInstallmentPaymentService_ltng.postPaymentForInstallment(paymentbean);
                    system.debug('paymentbean: '+paymentbean);
                    processPaymentForInstallmentResponse(processAmount);
                }
                
                
                
            }
            else if(profileId.contains('sc'))
            {
                isStoreCreditPayment = true;
                IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService.POSTPAYMENTBYSTORECREDITID); //, 'processPaymentStoreCreditResponse'
                IADContractBeans_ltng.IADMakePaymentStoreCredit paymentbean = new IADContractBeans_ltng.IADMakePaymentStoreCredit();
                paymentbean.orderId = orderNumber;
                paymentbean.storeCreditPaymentAmount = String.valueOf(processAmount);
                paymentbean.creatorId = UtilityLibrary.generateUpdatedBy_withPrefix();
                paymentbean.storeCreditId = UtilityLibrary.stripStoreCreditOrProfileId(profileId);
                paymentbean.comments = comments;
                
                IADInstallmentPaymentService_ltng.postPaymentByStoreCreditId(paymentbean);
                system.debug('paymentbean: '+paymentbean);
                processPaymentStoreCreditResponse(processAmount);
            }
            else if(profileId.contains('manual'))
            {
            
             IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.POSTPAYMENTBYMANUALCHECK);
             IADContractBeans_ltng.IADManualCheckPayment paymentbean = new IADContractBeans_ltng.IADManualCheckPayment();
                    
                    paymentbean.amount = integer.valueOf(processAmount);
                    paymentbean.createdBy = UtilityLibrary.generateUpdatedBy_withPrefix();
                    paymentbean.firstname=firstname;
                    paymentbean.lastname=lastname;
                    paymentbean.bankname=bankname;
                    paymentbean.checkNumber=checknumber;
                    paymentbean.comments = comments;
                    paymentbean.paymentReasonId = Integer.valueof(selectedReason);
                    paymentbean.notificationEmail = email;
                    paymentbean.depositDate=String.valueof(system.now());
                    
                    if(installmentId!=null)
                    {
                    
                    IADContractBeans_ltng.Installments  installment = new IADContractBeans_ltng.Installments();
                    installment.installmentBillId= integer.valueOf(installmentId);
                    installment.amount=integer.valueOf(processAmount);
                    
                   List<IADContractBeans_ltng.Installments> installmentlist= new list<IADContractBeans_ltng.Installments>();
                   installmentlist.add(installment);
                   paymentbean.installments=installmentlist;
                    
                    }
                    
                     IADInstallmentPaymentService_ltng.postPaymentManual(paymentbean,orderNumber);
                     processPaymentResponseManual(processAmount);
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('paymentService:');
        system.debug(paymentService);
        messages = IADServiceBase_ltng.iadMessages;
        return ctrlRef;
    }
    
    public static void processPaymentStoreCreditResponse(Decimal totalAmount)
    {
        try
        {
            IADInstallmentPaymentService_ltng.populateStoreCreditResponse();

            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(IADInstallmentPaymentService_ltng.POSTPAYMENTBYSTORECREDITID);

            system.debug('response ' + response);

            if(response.resultObjects != null)
            {
                system.debug('not null');
                IADContractBeans_ltng.IADMakePaymentStoreCreditResponse thePaymentStoreCredit = (IADContractBeans_ltng.IADMakePaymentStoreCreditResponse)response.resultObjects[0];
                if(thePaymentStoreCredit != null && thePaymentStoreCredit.storeCreditTransactionId!= null && IADServiceBase_ltng.errorCount==0)
                {
                    responseStatus = 'Approved';
                    IADServiceBase_ltng.populateSuccessMessage( 'Payment processed for $' + totalAmount + '!');
                    system.debug('IADServiceBase_ltng.iadMessages: '+IADServiceBase_ltng.iadMessages);
                    messages = IADServiceBase_ltng.iadMessages;
                }
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void processPaymentResponse(Decimal totalAmount)
    {
        try
        {
            system.debug('inside processPaymentResponse: controller : totalAmount' + totalAmount);
            IADInstallmentPaymentService_ltng.populatePayments();
            
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(IADInstallmentPaymentService_ltng.POSTPAYMENT);

            system.debug('response ' + response);

            if( response.resultObjects != null)
            {
                thePayment = IADInstallmentPaymentService_ltng.thePayment;
                system.debug('thePayment---->'+thePayment);
                if(thePayment != null &&  thePayment.paymentTransactionId!= null && IADServiceBase_ltng.errorCount==0)
                {
                    responseStatus =  IADPaymentTransaction.statusMap.get(thePayment.transactionStatus);
                    IADServiceBase_ltng.populateSuccessMessage( 'Payment processed for $' + totalAmount + '!');
                    system.debug('IADServiceBase_ltng.iadMessages: '+IADServiceBase_ltng.iadMessages);
                    isPaymentProcessed = true;                    
                    messages = IADServiceBase_ltng.iadMessages;
                }
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages = IADServiceBase_ltng.iadMessages;
        }
    }
     public static void processPaymentResponseManual(Decimal totalAmount)
    {
        try
        {
            system.debug('inside processPaymentResponse: controller : totalAmount' + totalAmount);
            
            
            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(IADInstallmentPaymentService_ltng.POSTPAYMENTBYMANUALCHECK);

            system.debug('response ' + response);
      
                   
                       
           if (response.responseData != null)
            {
                if (response.checkIsValidResponse())
                {
                    IADServiceBase_ltng.populateSuccessMessage( 'Payment processed for $' + totalAmount + '!');
                    system.debug('IADServiceBase_ltng.iadMessages: '+IADServiceBase_ltng.iadMessages);
                    isPaymentProcessed = true;                    
                    messages = IADServiceBase_ltng.iadMessages;
                }
                else
                {
                    IADServiceBase_ltng.populateErrorMessage(response);
                    messages= IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateNullErrorMessage(response);
                messages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch (Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages = IADServiceBase_ltng.iadMessages;
        }
           
        
        
    }


    public static void processPaymentForInstallmentResponse(Decimal totalAmount)
    {
        try
        {
            IADInstallmentPaymentService_ltng.populatePaymentsForInstallment();

            APIRequestResponseWrapper_ltng response = IADServiceBase_ltng.APItoWrapper.get(IADInstallmentPaymentService_ltng.POSTPAYMENTFORINSTALLMENT);

            system.debug('response ' + response);

            if(response.resultObjects != null)
            {
                thePayment = IADInstallmentPaymentService_ltng.thePayment;
                if(thePayment != null && thePayment.paymentTransactionId!= null && IADServiceBase_ltng.errorCount==0)
                {
                    responseStatus =  IADPaymentTransaction.statusMap.get(thePayment.transactionStatus);
                    IADServiceBase_ltng.populateSuccessMessage( 'Payment processed for $' + totalAmount + '!');
                    isPaymentProcessed = true;                    
                    messages = IADServiceBase_ltng.iadMessages;
                }
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    
    @AuraEnabled
    public static IADInstallmentPaymentController_ltng populateProfiles(String customerId, String pageType)
    {
        system.debug('Inside populateProfiles: controller' + customerId);
        onload();
        IADInstallmentPaymentController_ltng ctrlRef = new IADInstallmentPaymentController_ltng();
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
        catch(Exception theException)
        {
            system.debug('Exception: controller ');
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            messages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('Inside populate profile method: Controller Reference: ');
        system.debug(ctrlRef);
        messages = IADServiceBase_ltng.iadMessages;
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
                    getStoreCreditsByCustomerId(customerId);
                }
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            messages = IADServiceBase_ltng.iadMessages;
        }
    }

    public static void getStoreCreditsByCustomerId(String customerId)
    {
        try
        {
            IADServiceBase_ltng.initWrapper(IADStoreCreditPanelService.GETSTORECREDITSBYCUSTOMERID);//, 'processStoreCredits'
            IADInstallmentPaymentService_ltng.getStoreCreditsByCustomerId(customerId);
            processStoreCredits();
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages = IADServiceBase_ltng.iadMessages;
        }
    }

    public static void processStoreCredits()
    {
        try
        {
            IADInstallmentPaymentService_ltng.populateStoreCredits();

            if(IADInstallmentPaymentService_ltng.hasStoreCredit)
            {
                storeCredits = IADInstallmentPaymentService_ltng.storeCredit.storeCredits;

                system.debug('storeCredits ' + storeCredits);
            }
            if(IADServiceBase_ltng.errorCount == 0)
            {
                populatePaymentOptions();
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages = IADServiceBase_ltng.iadMessages;
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
        system.debug('storeCredits: ' + storeCredits);

        for(IADContractBeans_ltng.IADStoreCreditBean storeCredit : storeCredits)
        {
            if(storeCredit.refundableFlag && storeCredit.amount.setScale(2) > 0)
            {
                currentPaymentProfileLabel =  storeCredit.code + ' -  $' + storeCredit.amount.setScale(2) + ' : ' + IADPaymentTransaction.storeCreditStatusMap.get(Integer.valueOf(storeCredit.storeCreditStatusId));

                paymentOptions.put('sc' + storeCredit.storeCreditId, currentPaymentProfileLabel);

                if(currentPaymentProfileId == '' || currentPaymentProfileId == null)
                {
                    currentPaymentProfileId = 'sc' + storeCredit.storeCreditId;
                }
            }
        }
        
        system.debug('payment options2: '+paymentOptions);

        if(invokingPageType == 'MakeRefund'){
            paymentOptions.put('0', '');
            paymentOptions.put('refundToStoreCredit', 'Store Credit');
            paymentOptions.put('refundinstallment' ,'Apply Refund To Installments');
        }

        if(paymentOptions.size() == 0){
            paymentOptions.put('none', '--Select Payment Method--');
        }
        if( invokingPageType != 'subscription')
        {
         paymentOptions.put('manualCheck', 'Manual Check');
         
        }
        paymentOptions.put('newPayment', 'Add New Payment Method');
       
        
        system.debug('payment options3: '+paymentOptions);
    }
}