public class IADRefundController_ltng {
    @AuraEnabled public static String email{get;set;}
    @AuraEnabled public static String amount{get;set;}
    @AuraEnabled public static Decimal amountDue{get;set;}
    
    @AuraEnabled public static String responseStatus{get;set;}
    
    @AuraEnabled public static Integer otherAmountCounts{get;set;}
    
    @AuraEnabled public static Map<String,String> pastPaymentOptions{get;set;}
    
    @AuraEnabled public static IADInstallmentPaymentService_ltng refundService{get;set;}  
    @AuraEnabled public static IADOrderWithOrderItemsService_ltng balanceService{get;set;}  
    @AuraEnabled public static IADContractBeans_ltng.IADOrderBalance theOrderBalance{get;set;}
    
    @AuraEnabled public static Map<String,IADContractBeans_ltng.IADPaymentProfileBean> profileIdToProfile{get;set;}
    @AuraEnabled public static Map<String,String> pTransactionToProfileId{get;set;}
    @AuraEnabled public static Map<String,String> pTransactionToAmount{get;set;}
    
    @AuraEnabled public static String invokingPage{get;set;}
    @AuraEnabled public static String invokingPageId{get;set;}
    
    @AuraEnabled public static Boolean isRefundToStoreCredit{get;set;}
    @AuraEnabled public static Boolean isRefundStoreCreditToCard{get;set;}
    @AuraEnabled public static Boolean isRefundStoreCreditToMC{get;set;}
    @AuraEnabled public static Boolean isRefundProcessed{get;set;}
    @AuraEnabled public static String statecode{get;set;}
    @AuraEnabled public static order__c ordercontact{get;set;}
    
    @AuraEnabled public static List<IADMessage_ltng> messages{get;set;}    
    
    @AuraEnabled
    public static Map<String, String> refundReasons
    {
        get
        {
            if(refundReasons == null)
            {
                refundReasons = new Map<String, String>();
                for (IAD_Refund_Reason__c reason : [SELECT ReasonId__c, Reason__c FROM IAD_Refund_Reason__c order by Reason__c asc])
                {
                    refundReasons.put(reason.Reason__c, String.valueOf(reason.ReasonId__c));
                }
            }
            system.debug('refundReasons');
            system.debug(refundReasons);
            return refundReasons;
        }
        set;
    }
    @AuraEnabled
    public static Map<decimal, String> states
    {
        get
        {
            if(states == null)
            {
                states = new Map<Decimal,String>();
                states=UtilityLibrary.stateIdsToStateMap;
                
            }
            
            return states;
        }
        set;
    }
    
    @AuraEnabled
    public static Map<String, String> manualrefundReasons
    {
        get
        {
            if(manualrefundReasons == null)
            {
                manualrefundReasons = new Map<String, String>();
                manualrefundReasons.put('Old Charge','1');
                manualrefundReasons.put('Account closed','3');
                manualrefundReasons.put('Customer Intially paid by paper check ,cash or money order','2');
                
            }
            
            return manualrefundReasons;
        }
        set;
    }
    public static void onload(){
        otherAmountCounts = 0; 
        isRefundStoreCreditToCard = false;
        isRefundProcessed = false;
        isRefundStoreCreditToMC = false;
        messages = new List<IADMessage_ltng>();
        pTransactionToAmount = new Map<String, String>();
        pTransactionToProfileId = new Map<String, String>();
        profileIdToProfile = new Map<String,IADContractBeans_ltng.IADPaymentProfileBean>();
        pastPaymentOptions = new Map<String,String>();
    }
    
    @AuraEnabled
    public static IADRefundController_ltng initCtrl(String amount, String orderId, String customerId, String invokingPage, String invokingPageId)
    {
        onload();
        IADRefundController_ltng ctrlRef = new IADRefundController_ltng();
        if(customerId != null && customerId != '')
        {
            List<Customer_Login__c> customerLogins = [SELECT Id , Primary_Contact__r.Email FROM Customer_Login__c WHERE Customer_ID__c = :customerId];
            if(!customerLogins.isEmpty())
            {
                email = customerLogins[0].Primary_Contact__r.Email;
            }
        }
        if(orderId!=null && orderId!='')
        {
            
            List<order__c> orders =[select contact__r.FirstName ,contact__r.LastName,contact__r.MailingStreet,contact__r.MailingCity,contact__r.MailingPostalCode,contact__r.MailingState from order__c  where id =:invokingpageid];
            if(!orders.isEmpty())
            {
                ordercontact=orders[0];
                statecode=String.valueof(UtilityLibrary.stateToStateIdsMap.get(UtilityLibrary.stateCodeToStateMap.get(ordercontact.contact__r.MailingState)));
            }
        }
        system.debug('controller Reference: '+ctrlRef);
        return ctrlRef;
    }
    
    @AuraEnabled
    public static IADInstallmentPaymentController_ltng populateRefundOptions(String customerId, String pageType){
        onload();
        IADInstallmentPaymentController_ltng ctrlRef = new IADInstallmentPaymentController_ltng();
        ctrlRef = IADInstallmentPaymentController_ltng.populateProfiles(customerId, pageType);
        processPaymentResponse();
        return ctrlRef;
    }
    
    @AuraEnabled
    public static IADRefundController_ltng getOrderBalanceByOrderId(String orderNumber)
    {
        system.debug('ready to getOrderBalanceByOrderId ');
        onload();
        IADRefundController_ltng ctrlRef = new IADRefundController_ltng();
        balanceService = new IADOrderWithOrderItemsService_ltng();        
        try
        {
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERBALANCESBYORDERID);//, 'processAllResponses'
            IADOrderWithOrderItemsService_ltng.getOrderBalanceByOrderId(orderNumber);
            processOrderBalancesResponse();
            system.debug('balanceService: '+balanceService);
            system.debug('orderBalanceWrapper.theOrderBalance.orderBalanceAmount: '+IADOrderWithOrderItemsService_ltng.theOrderBalance.orderBalanceAmount);
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
        system.debug('inside order balance method');
        system.debug('ctrlRef: '+ctrlRef);
        system.debug('messages: '+messages);
        return ctrlRef;
    }
    
    @AuraEnabled
    public static IADRefundController_ltng getPaymentProfilesByUserId(String customerId, String orderNumber)
    {
        system.debug('inside getPaymentProfilesByUserId');
        onload();
        refundService = new IADInstallmentPaymentService_ltng();
        IADRefundController_ltng ctrlRef = new IADRefundController_ltng();
        try
        {
            IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.GETPROFILESBYUSERID);
            IADInstallmentPaymentService_ltng.getPaymentProfilesByUserId(customerId);
            processProfileResponse();
            
            getPaymentsByOrderId(orderNumber);
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
        return ctrlRef;
    }
    
    
    @AuraEnabled
    public static void getPaymentsByOrderId(String orderNumber)
    {
        system.debug('getPaymentsByOrderId');
        try
        {
            IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.GETPAYMENTSBYORDERID);//, 'processAllResponses'
            IADInstallmentPaymentService_ltng.getPaymentsByOrderId(orderNumber);
            processPaymentResponse();
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
    }   
    
    public static void processOrderBalancesResponse() 
    {
        system.debug('made it to response');
        APIRequestResponseWrapper_ltng orderBalanceResponse =  IADServiceBase_ltng.APItoWrapper.get(IADOrderWithOrderItemsService_ltng.GETORDERBALANCESBYORDERID);
        IADOrderWithOrderItemsService_ltng.populateOrderBalance();
        if(orderBalanceResponse.resultObjects != null)
        {
            theOrderBalance = (IADContractBeans_ltng.IADOrderBalance)orderBalanceResponse.resultObjects[0];
            amount = String.valueOf(theOrderBalance.orderBalanceAmount).replace('-', '');
            amountDue = Decimal.valueOf(String.valueOf(theOrderBalance.orderBalanceAmount).replace('-', ''));
        }
        messages.addAll(IADServiceBase_ltng.iadMessages);        
    }
    
    // Added New Param - ApprovedBy to this Method - STORY B-39538
    @AuraEnabled
    public static IADRefundController_ltng processRefund(Decimal amountDue, Decimal processAmount, String orderNumber, String customerId, String profileId, String comments, String selectedReasonForRefund, String email, String selectedPaymentTransaction, String invokingPage, String storeCreditId,string manualcheck,string address,string firstname,string lastname ,string city ,string zipcode ,string manualcheckreasonid,string state,string approvedBy)
    {
        onload();
        refundService = new IADInstallmentPaymentService_ltng();
        IADRefundController_ltng ctrlRef = new IADRefundController_ltng();
        
        try
        {            
            processAmount = processAmount.setScale(2);
            system.debug('orderNumber: '+ orderNumber + 'processAmount: ' + String.valueOf(processAmount) + 'customerId: ' + customerId + ' profileId ' + profileId + 'Store Credit Id: '+storeCreditId);
            system.debug('comments: '+ comments + 'selectedReasonForRefund: ' + selectedReasonForRefund + 'email: ' + email + 'selectedPaymentTransaction: ' + selectedPaymentTransaction +  email + 'manualcheckreasonid: ' +manualcheckreasonid);
            
            if(email != null && email != ''){
                email = email.trim();
            }
            
            if(invokingPage == 'StoreCredit')
            {
                isRefundStoreCreditToCard = true;
            }
            else if(invokingPage == 'StoreCreditToMC')
            {
                isRefundStoreCreditToMC = true;
            }
            else
            {
                isRefundStoreCreditToCard = false;
            }
            
            if(IADServiceBase_ltng.errorCount == 0)
            {
                
                if(profileId=='manualCheck'){
                    // Added New Param - ApprovedBy to this Method - STORY B-39538
                    //String reqPayload = constructRefundRequestManual(orderNumber, customerId, String.valueOf(processAmount), profileId, comments, selectedReasonForRefund, email, selectedPaymentTransaction,address ,city,firstname,lastname,Integer.valueOf(state),Integer.valueOf(manualcheckreasonid),zipcode);
                    String reqPayload = constructRefundRequestManual(orderNumber, customerId, String.valueOf(processAmount), profileId, comments, selectedReasonForRefund, email, selectedPaymentTransaction,address ,city,firstname,lastname,Integer.valueOf(state),Integer.valueOf(manualcheckreasonid),zipcode,approvedBy);
                    system.debug('posting to card');
                    system.debug('posting to card: '+reqPayload);
                    IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.POSTREFUNDBYMANUALCHECK); 
                    IADInstallmentPaymentService_ltng.postManualCheckRefund(reqPayload,orderNumber);                   
                    processRefundbyManualCheck(profileId, processAmount, invokingPage);
                    
                }
                else                    
                {
                    if(isRefundStoreCreditToCard)
                    {
                        String reqPayload = constructRefundRequestForSCtoCard(storeCreditId, processAmount, customerId, comments, email);
                        system.debug('posting to card');
                        system.debug('posting to card: '+reqPayload);
                        IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.POSTREFUNDSTORECREDITTOCARD); 
                        IADInstallmentPaymentService_ltng.postRefundStoreCreditToCard(reqPayload);
                        processRefundResponse(profileId, processAmount, invokingPage);
                    }
                    else if(isRefundStoreCreditToMC)
                    {
                        system.debug('SC to MC');
                        system.debug('storeCreditId-->' + storeCreditId + 'customerId-->'+ customerId + 'String.valueOf(processAmount)-->' + String.valueOf(processAmount) + 'comments--->' + comments);
                        system.debug('Integer.valueOf(manualcheckreasonid)-->'+ manualcheckreasonid + 'firstname-->' + firstname + 'lastname-->' + lastname + 'address-->' + address );
                        system.debug('city-->' + city + 'Integer.valueOf(state)-->'+ Integer.valueOf(state) + 'zipcode-->' + zipcode + 'email-->' +email);
                        string reqPayload = constructRefundRequestSCToMC(storeCreditId, customerId, String.valueOf(processAmount), comments, Integer.valueOf(manualcheckreasonid), firstname, lastname, address, city, Integer.valueOf(state), zipcode, email);
                    	system.debug('SC to MC Payload: '+reqPayload);
                        IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.PostRefundStoreCreditToManualCheck); 
                        IADInstallmentPaymentService_ltng.postRefundStoreCreditToManualCheck(reqPayload);
                        processRefundResponse(profileId, processAmount, invokingPage);
                    }
                    else
                    {
                        String reqPayload = constructRefundRequest(orderNumber, customerId, String.valueOf(processAmount), profileId, comments, selectedReasonForRefund, email, selectedPaymentTransaction);
                        system.debug('reqPayload: ');
                        system.debug(reqPayload);
                        if(profileId != 'refundToStoreCredit')
                        {
                            system.debug('ready to post refund');
                            IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.POSTREFUNDBYORDERID);//, 'processRefundResponse'
                            IADInstallmentPaymentService_ltng.postRefund(reqPayload, orderNumber);
                        }
                        else
                        {
                            IADServiceBase_ltng.initWrapper(IADInstallmentPaymentService_ltng.POSTREFUNDSTORECREDITBYORDERID);//, 'processRefundResponse'
                            IADInstallmentPaymentService_ltng.postRefundByStoreCredit(reqPayload, orderNumber);
                        }
                        processRefundResponse(profileId, processAmount, invokingPage);
                    }
                }
            }
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
        
        system.debug('refund final result');
        system.debug('messages: '+messages);
        system.debug('ctrlRef: '+ctrlRef);
        return ctrlRef;
    }
    
    public static void processRefundResponse(String profileId, Decimal processAmount, String invokingPage) 
    {   
        system.debug('Inside Callback');
        try
        {
            APIRequestResponseWrapper_ltng wrap;
            if(isRefundStoreCreditToCard)
            {
                isRefundToStoreCredit = true;
                IADInstallmentPaymentService_ltng.readProcessRefundStoreCreditToCardResponse();
                wrap = IADServiceBase_ltng.APItoWrapper.get(IADInstallmentPaymentService_ltng.POSTREFUNDSTORECREDITTOCARD);
            }
            else if(isRefundStoreCreditToMC)
            {
                IADInstallmentPaymentService_ltng.readProcessRefundStoreCreditToMCResponse();
                wrap = IADServiceBase_ltng.APItoWrapper.get(IADInstallmentPaymentService_ltng.POSTREFUNDSTORECREDITTOMANUALCHECK);
            }
            else if(profileId != 'refundToStoreCredit')
            {
                isRefundToStoreCredit = false;
                IADInstallmentPaymentService_ltng.readProcessRefundResponse();
                wrap = IADServiceBase_ltng.APItoWrapper.get(IADInstallmentPaymentService_ltng.POSTREFUNDBYORDERID);
            }
            else
            {
                isRefundToStoreCredit = true;
                IADInstallmentPaymentService_ltng.readProcessRefundStoreCreditResponse();
                wrap = IADServiceBase_ltng.APItoWrapper.get(IADInstallmentPaymentService_ltng.POSTREFUNDSTORECREDITBYORDERID);
            }
            system.debug('wrap ' + wrap.statusCode);
            
            if(isRefundStoreCreditToMC && wrap.statusCode == '200' )
            {
                IADServiceBase_ltng.populateSuccessMessage( 'Refund processed Store Credit to Manual Check for $' + processAmount + '!'); 
                messages.addAll(IADServiceBase_ltng.iadMessages);
            }
            else if(wrap.statusCode == '201' && IADServiceBase_ltng.errorCount==0)
            {
                responseStatus = 'Approved';
                if(invokingPage != 'Installment'){
                    IADServiceBase_ltng.populateSuccessMessage( 'Refund processed for $' + processAmount + '!'); 
                    isRefundProcessed = true;
                    messages.addAll(IADServiceBase_ltng.iadMessages);
                }
                else{
                    IADServiceBase_ltng.populateSuccessMessage( 'Refund processed for $' + processAmount + '!'); 
                    isRefundProcessed = true;
                    messages.addAll(IADServiceBase_ltng.iadMessages);
                }
            }
            else if(isRefundStoreCreditToCard && wrap.statusCode == '200' )
            {
                IADServiceBase_ltng.populateSuccessMessage( 'Refund processed for $' + processAmount + '!'); 
                messages.addAll(IADServiceBase_ltng.iadMessages);
            }
            
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
        system.debug(IADServiceBase_ltng.iadMessages); 
    }
    
    
    public static void processRefundbyManualCheck(String profileId, Decimal processAmount, String invokingPage) 
    {   
        system.debug('Inside Callback');
        try
        {
            APIRequestResponseWrapper_ltng wrap;
            
            
            IADInstallmentPaymentService_ltng.readProcessRefundManualCheck();
            wrap = IADServiceBase_ltng.APItoWrapper.get(IADInstallmentPaymentService_ltng.POSTREFUNDBYMANUALCHECK );
            
            
            if( wrap.statusCode == '200' )
            {
                IADServiceBase_ltng.populateSuccessMessage( 'Refund processed  manual for $' + processAmount + '!'); 
                messages.addAll(IADServiceBase_ltng.iadMessages);
            }
            
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException.getMessage());
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
        system.debug(IADServiceBase_ltng.iadMessages); 
    }
    
    public static void processPaymentResponse()
    {
        system.debug('processPaymentResponse');
        try
        {
            pTransactionToProfileId = new Map<String, String>();
            pTransactionToAmount = new Map<String, String>();
            system.debug('IADInstallmentPaymentService_ltng.payment: '+IADInstallmentPaymentService_ltng.payment);
            if(IADInstallmentPaymentService_ltng.payment != null)
            {
                pastPaymentOptions = new Map<String,String>();
                pastPaymentOptions.put('0', '');
                for(IADContractBeans_ltng.IADPaymentBean thePayment : IADInstallmentPaymentService_ltng.payment.payments)
                {
                    if(IADPaymentTransaction_ltng.typeMap.get(Integer.valueOf(thePayment.transactionType))!='Refund' &&
                       IADPaymentTransaction_ltng.statusMap.get(Integer.valueOf(thePayment.transactionStatus))=='Approved')
                    {
                        IADContractBeans_ltng.IADPaymentProfileBean paymentProfile = profileIdToProfile.get(thePayment.paymentProfileId);
                        if(paymentProfile != null)
                        {
                            system.debug('paymentProfile ' + paymentProfile);
                            system.debug('the payment: '+thePayment);
                            system.debug('the paymentTransactionId: '+thePayment.paymentTransactionId);
                            pastPaymentOptions.put(thePayment.paymentTransactionId, thePayment.paymentTransactionId + ': '
                                                   + UtilityLibrary.profileAccountTypeToNameMap.get(paymentProfile.AccountType)
                                                   + ' - ' + paymentProfile.last4Digits + ' - $' + thePayment.amount);
                            pTransactionToProfileId.put(thePayment.paymentTransactionId, thePayment.paymentProfileId);
                            pTransactionToAmount.put(thePayment.paymentTransactionId, String.valueOf(thePayment.amount));
                        }
                    }
                }
            }
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
    }
    
    public static void processProfileResponse()
    {
        
        system.debug('processProfileResponse');
        try
        {
            IADInstallmentPaymentService_ltng.populateProfiles();
            
            profileIdToProfile = new Map<String, IADContractBeans_ltng.IADPaymentProfileBean>();
            
            if(IADInstallmentPaymentService_ltng.allProfiles.size() > 0)
            {
                for(IADContractBeans_ltng.IADPaymentProfileBean thePayment : IADInstallmentPaymentService_ltng.allProfiles)
                {
                    profileIdToProfile.put(thePayment.profileId, thePayment);
                }
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            messages.addAll(IADServiceBase_ltng.iadMessages);
        }
    }
    
    public static String constructRefundRequestForSCtoCard(String storeCreditId, Decimal amount, String customerId, String comments, String email)
    {
        IADContractBeans_ltng.IADStoreCreditRefundToCard refund = new IADContractBeans_ltng.IADStoreCreditRefundToCard();
        refund.storeCreditId = storeCreditId;
        refund.amount = String.valueOf(amount); //totalAmountConverted(); 
        refund.customerId = customerId;
        refund.comments = comments;
        refund.notificationEmail = email;
        refund.createdBy = UtilityLibrary.generateUpdatedBy_withPrefix();
        
        return JSON.serialize(refund);
    }
    
    public static String constructRefundRequest(String orderNumber, String customerId, String amount, String profileId, String comments, String selectedReasonForRefund, String email, String selectedPaymentTransaction)
    {
        IADContractBeans_ltng.IADProcessRefundBean refundBean = new IADContractBeans_ltng.IADProcessRefundBean();
        IADContractBeans_ltng.IADProcessRefund refund = new IADContractBeans_ltng.IADProcessRefund();
        refund.orderId = orderNumber;
        refund.amount = amount; //String.valueOf(totalAmountConverted()); 
        refund.createdBy = UtilityLibrary.generateUpdatedBy_withPrefix();
        if(profileId != 'refundToStoreCredit'){
            refund.paymentProfileId = UtilityLibrary.stripStoreCreditOrProfileId(profileId);
        }
        refund.comments = comments;
        refund.customerId = customerId;
        refund.reasonId = selectedReasonForRefund;
        refund.source = UtilityLibrary.getConfig().Payment_Source__c;
        refund.notificationEmail = email;
        refund.paymentTransactionId = selectedPaymentTransaction;
        system.debug('refund' + refund);
        refundBean.refundDetail = refund;
        
        return JSON.serialize(refundBean);
    }
    
    // Added New Param - ApprovedBy to this Method - STORY B-39538
    public static String constructRefundRequestManual(String orderNumber, String customerId, String amount, String profileId, String comments, String selectedReasonForRefund, String email, String selectedPaymentTransaction, string address , string city, string firstname, string lastname, Integer state, Integer manualcheckreasonid, String zipcode, string approvedBy)                  
    {
        IADContractBeans_ltng.IADManualCheckRefundbean refund = new IADContractBeans_ltng.IADManualCheckRefundbean();
        
        refund.amount = Decimal.valueof(amount); //String.valueOf(totalAmountConverted()); 
        refund.createdBy = UtilityLibrary.generateUpdatedBy_withPrefix();
        
        refund.comments = comments;
        refund.refundReasonId = Integer.valueof(selectedReasonForRefund);
        
        refund.notificationEmail = email;
        refund.paymentTransactionId = Integer.valueof(selectedPaymentTransaction);
        refund.manualCheckReasonId=manualcheckreasonid;
        refund.firstName=firstname;
        refund.lastName=lastname;
        refund.address=address;
        refund.zipcode=zipcode;
        refund.city=city;
        refund.state=state;
        refund.approvedBy=approvedBy; // STORY B-39538
        system.debug('refund' + refund);
        
        return JSON.serialize(refund);
    }
    
    public static String constructRefundRequestSCToMC(String storeCreditId, String customerId, String amount, String comments, Integer manualcheckreasonid, string firstname, string lastname, string address, string city, Integer state, String zipcode, String email)                  
    {
        IADContractBeans_ltng.IADStoreCreditToManualCheckBean refund = new IADContractBeans_ltng.IADStoreCreditToManualCheckBean();
        refund.storeCreditId = Integer.valueOf(storeCreditId);
        refund.customerId = Integer.valueOf(customerId);
        refund.amount = Decimal.valueof(amount);
        refund.comments = comments;
        refund.manualCheckReasonId = manualcheckreasonid;
        refund.firstName = firstname;
        refund.lastName = lastname;
        refund.address = address;
        refund.city = city;
        refund.state = state;
        refund.zipcode = zipcode;
        refund.notificationEmail = email;
        refund.checkNumber = '';
        refund.depositDate = system.now();
        refund.createdBy = UtilityLibrary.generateUpdatedBy_withPrefix();
        refund.approvedBy = 'string';
        system.debug('refund' + refund);
        
        return JSON.serialize(refund);
    }
    
}