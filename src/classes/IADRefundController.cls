public  with sharing class IADRefundController
{
    public String comments{get;set;}
    public String email{get;set;}
    public String selectedReason{get;set;}
    public String selectedPayment{get;set;}
    public String selectedReasonForRefunds{get;set;}
    public String profileId{get;set;}
    public String orderNum{get;set;}
    public String amount{get;set;}
    public String customerId{get;set;}
    public Decimal amountDue{get;set;}

    public String responseStatus{get;set;}

    public Integer otherAmountCounts{get;set;}

    public List<selectOption> pastPaymentOptions{get;set;}
    public List<SelectOption> reasonForRefunds{get;set;}

    public IADInstallmentPaymentService refundService{get;set;}  
    public IADOrderWithOrderItemsService balanceService{get;set;}  
    public IADContractBeans.IADOrderBalance theOrderBalance{get;set;}
    public IADPendingPaymentsService paymentsService {get;set;}
    public IADPaymentProfilesService profileService{Get;set;}

    public Map<String,IADContractBeans.IADPaymentProfileBean> profileIdToProfile{get;set;}
    public Map<String,String> pTransactionToProfileId{get;set;}
    public Map<String,String> pTransactionToAmount{get;set;}


    public List<OtherWrapper> otherAmntList {get;set;}

    public Map<Integer, OtherWrapper> otherAmntMap {get;set;}

    public String invokingPage{get;set;}
    public String invokingPageId{get;set;}

    public Boolean isRefundToStoreCredit{get;set;}
    public Boolean isRefundStoreCreditToCard{get;set;}
    

    public IADRefundController()
    {
        orderNum = ApexPages.currentPage().getParameters().get('orderId');
        customerId = ApexPages.currentPage().getParameters().get('customerId');
        invokingPage = ApexPages.currentPage().getParameters().get('invokingPage');
        invokingPageId = ApexPages.currentPage().getParameters().get('invokingPageId');
        isRefundStoreCreditToCard = ApexPages.currentPage().getParameters().get('storeCreditToCard')=='1'?true:false;

        amount = ApexPages.currentPage().getParameters().get('amount');
        otherAmountCounts = 0;
        otherAmntList= new List<OtherWrapper>();
        otherAmntMap= new Map<Integer, OtherWrapper>();

        refundService = new IADInstallmentPaymentService();
        balanceService = new IADOrderWithOrderItemsService();
        paymentsService = new IADPendingPaymentsService();
        profileService = new IADPaymentProfilesService();
        pTransactionToAmount=new Map<String, String>();
        pTransactionToProfileId = new Map<String, String>();
        profileIdToProfile = new Map<String,IADContractBeans.IADPaymentProfileBean>();

        reasonForRefunds = UtilityLibrary.refundReasons;
        if(customerId != null && customerId != '')
        {
            List<Customer_Login__c> customerLogins = [SELECT Id , Primary_Contact__r.Email FROM Customer_Login__c WHERE Customer_ID__c = :customerId];
            if(!customerLogins.isEmpty())
            {
                email = customerLogins[0].Primary_Contact__r.Email;
            }
        }
    }
    public void addOtherAmt()
    {
        OtherWrapper wrap = new OtherWrapper();
        wrap.index=otherAmountCounts;

        otherAmntMap.put(otherAmountCounts, wrap);
        otherAmntList.add(wrap);
        otherAmountCounts ++;

    }
    public class OtherWrapper
    {
        public Integer index{Get;set;}
        public Decimal amount{get;set;}
    }
    public void setProfileIdManual()
    {
        system.debug('profile id '  + profileId);
    }

    public void setProfileId()
    {
        profileId = Apexpages.currentPage().getParameters().get('profileId');
    }
    public String getTotalAmount()
    {
        return Apexpages.currentPage().getParameters().get('totalAmount');
    }
    public Decimal totalAmountConverted()
    {
        String totalAmnt = amount;
        if(totalAmnt != null && totalAmnt != '')
        {
            return Decimal.valueOf(getTotalAmount());
        }
        else
        {
            return 0.00;
        }
    }
    public Object startRequestsInParallel()
    {
        Continuation continuationObject = new Continuation(60);
        continuationObject.continuationMethod='processAllResponses';
        try
        {
            if(UtilityLibrary.isNotNullOrBlank(orderNum))
            {
                balanceService.initWrapper(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, 'processAllResponses');
                continuationObject = (Continuation)balanceService.getOrderBalanceByOrderId(continuationObject, orderNum);
            }

            profileService.initWrapper(IADPaymentProfilesService.GETPROFILESBYUSERID, 'processAllResponses');
            continuationObject = (Continuation)profileService.getPaymentProfilesByUserId(continuationObject, customerId);

            if(UtilityLibrary.isNotNullOrBlank(orderNum))
            {
                paymentsService.initWrapper(IADPendingPaymentsService.GETPAYMENTSBYORDERID, 'processAllResponses');
                continuationObject = (Continuation) paymentsService.getPaymentsByOrderId(continuationObject, orderNum);
            }

        }
        catch(IADException theException)
        {
            refundService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            refundService.populateErrorMessage(theException);
        }

        return continuationObject;
    }
    public void processAllResponses()
    {
        if(UtilityLibrary.isNotNullOrBlank(orderNum))
            processOrderBalancesResponse();
        processProfileResponse();
        if(UtilityLibrary.isNotNullOrBlank(orderNum))
            processPaymentResponse();
        else
            amountDue = Decimal.valueOf(amount).setScale(2);

    }
    
    //Callback method for Asynchronous
    public Object processOrderBalancesResponse() 
    {
        system.debug('made it to response');
        APIRequestResponseWrapper orderBalanceResponse =  balanceService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID);
        HttpResponse response = Continuation.getResponse(orderBalanceResponse.requestLabelContinuation);
        orderBalanceResponse.responseData = response.getBody();
        orderBalanceResponse.statusCode = response.getStatusCode()+'';
        balanceService.populateOrderBalance();
        if(orderBalanceResponse.resultObjects!= null)
        {
            theOrderBalance = (IADContractBeans.IADOrderBalance)orderBalanceResponse.resultObjects[0];
            amount = String.valueOf(theOrderBalance.orderBalanceAmount).replace('-', '');
            //if(invokingPage != 'Subscription')
            amountDue = Decimal.valueOf(String.valueOf(theOrderBalance.orderBalanceAmount).replace('-', ''));
        }
        else
            refundService.iadMessages = balanceService.iadMessages;
                 
         
          return null;
    }

    public Object processRefund()
    {
        Object continuationObject;
        refundService.clearMessages();
        try
        {
            Decimal totalAmountConverted = totalAmountConverted();
            system.debug('totalAmountConverted ' + totalAmountConverted);

            Decimal balanceConverted;
            if(isRefundStoreCreditToCard)
                balanceConverted = Decimal.valueOf(amount).setScale(2);
            else
                balanceConverted = Decimal.valueOf(String.valueOf(theOrderBalance.grandTotal).replace('-', ''));

            refundService.clearMessages();
            if(comments == null || comments == '')
            {
                refundService.populateErrorMessage('Must provide comments.');
            }
            if(email != null && email != '')
                email = email.trim();
            if(!UtilityLibrary.validateEmail(email))
            {
                refundService.populateErrorMessage('Must provide valid email format.');
            }
            if(totalAmountConverted > balanceConverted)
            {
                refundService.populateErrorMessage('Process amount is greater than amount due.');
            }
            if(refundService.errorCount == 0)
            {
                if(isRefundStoreCreditToCard)
                {
                    String reqPayload = constructRefundRequestForSCtoCard();
                    system.debug('posting to card');
                    refundService.initWrapper(IADInstallmentPaymentService.POSTREFUNDSTORECREDITTOCARD, 'processRefundResponse');
                    continuationObject = refundService.postRefundStoreCreditToCard(reqPayload);
                }
                else if(totalAmountConverted > 0  && totalAmountConverted <= balanceConverted && totalAmountConverted != 0.00)
                {
                    system.debug('Decimal.valueOf(pTransactionToAmount.get(selectedPayment)) ' + Decimal.valueOf(pTransactionToAmount.get(selectedPayment)));
                    if(totalAmountConverted <= Decimal.valueOf(pTransactionToAmount.get(selectedPayment)))
                    {

                        String reqPayload = constructRefundRequest();
                        if(profileId!=IADPaymentProfilesComponentController.refundToStoreCredit)
                        {
                            refundService.initWrapper(IADInstallmentPaymentService.POSTREFUNDBYORDERID, 'processRefundResponse');
                            continuationObject = refundService.postRefund(reqPayload);
                        }
                        else
                        {
                            refundService.initWrapper(IADInstallmentPaymentService.POSTREFUNDSTORECREDITBYORDERID, 'processRefundResponse');
                            continuationObject = refundService.postRefundByStoreCredit(reqPayload);
                        }
                    }
                    else
                    {
                        refundService.populateErrorMessage('Refund amount is greater than the selected transaction. Please use Other Amount to refund the $' + pTransactionToAmount.get(selectedPayment) +  ' value. ');
                    }
                }
                else
                {
                    refundService.populateErrorMessage('Not a valid amount.');
                }
            }

        }
        catch(IADException theException)
        {
            refundService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            refundService.populateErrorMessage(theException);
        }
        system.debug(continuationObject);
        return continuationObject; 
       
    }
    
    //Callback method for Asynchronous
    public Object processRefundResponse() 
    {   
        system.debug('Inside Callback');
        try
        {
            Decimal totalAmountConverted = totalAmountConverted();
            APIRequestResponseWrapper wrap;
            if(isRefundStoreCreditToCard)
            {
                isRefundToStoreCredit = true;
                refundService.initHTTPResponse(IADInstallmentPaymentService.POSTREFUNDSTORECREDITTOCARD);
                refundService.readProcessRefundStoreCreditToCardResponse();
                wrap = refundService.APItoWrapper.get(IADInstallmentPaymentService.POSTREFUNDSTORECREDITTOCARD);
            }
            else if(profileId!=IADPaymentProfilesComponentController.refundToStoreCredit)
            {

                isRefundToStoreCredit = false;
                refundService.initHTTPResponse(IADInstallmentPaymentService.POSTREFUNDBYORDERID);
                refundService.readProcessRefundResponse();
                wrap = refundService.APItoWrapper.get(IADInstallmentPaymentService.POSTREFUNDBYORDERID);
            }
            else
            {
                isRefundToStoreCredit = true;
                refundService.initHTTPResponse(IADInstallmentPaymentService.POSTREFUNDSTORECREDITBYORDERID);
                refundService.readProcessRefundStoreCreditResponse();
                wrap = refundService.APItoWrapper.get(IADInstallmentPaymentService.POSTREFUNDSTORECREDITBYORDERID);
            }
            system.debug('wrap ' + wrap.statusCode);
            if(wrap.statusCode == '201' && refundService.errorCount==0)
            {
                responseStatus = 'Approved';
                if(invokingPage!='Installment')
                    refundService.populateSuccessMessage( 'Refund processed for $' + totalAmountConverted + '! If your balance due is $0, this page will close.');
                else
                    refundService.populateSuccessMessage( 'Refund processed for $' + totalAmountConverted + '! This page will close.');
            }
            else if(isRefundStoreCreditToCard && wrap.statusCode == '200' )
            {
                refundService.populateSuccessMessage( 'Refund processed for $' + totalAmountConverted + '! This page will close.');
            }

        }
        catch(IADException theException)
        {
            refundService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            refundService.populateErrorMessage(theException.getMessage());
        }
        system.debug(refundService.iadMessages); 
        return null;
    }
    public Object processPaymentResponse()
    {
        try
        {
            paymentsService.populatePayments();
            pTransactionToProfileId = new Map<String, String>();
            pTransactionToAmount=new Map<String, String>();
            if(paymentsService.payment != null)
            {
                pastPaymentOptions = new  List<SelectOption>();
                pastPaymentOptions.add(new selectOption('', ''));
                for(IADContractBeans.IADPaymentBean thePayment : paymentsService.payment.payments)
                {
                    if(IADPaymentTransaction.typeMap.get(Integer.valueOf(thePayment.transactionType))!='Refund' &&
                       IADPaymentTransaction.statusMap.get(Integer.valueOf(thePayment.transactionStatus))=='Approved')
                    {
                        IADContractBeans.IADPaymentProfileBean paymentProfile = profileIdToProfile.get(thePayment.paymentProfileId);
                        if(paymentProfile != null)
                        {
                            system.debug('paymentProfile ' + paymentProfile);
                            pastPaymentOptions.add(new SelectOption(thePayment.paymentTransactionId, thePayment.paymentTransactionId + ': '
                                    + UtilityLibrary.profileAccountTypeToNameMap.get(paymentProfile.AccountType)
                                    + ' - ' + paymentProfile.last4Digits + ' - $' + thePayment.amount));
                            pTransactionToProfileId.put(thePayment.paymentTransactionId, thePayment.paymentProfileId);
                            pTransactionToAmount.put(thePayment.paymentTransactionId, String.valueOf(thePayment.amount));

                        }

                    }
                }

            }
        }
        catch(IADException theException)
        {
            refundService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            refundService.populateErrorMessage(theException);
        }


        return null;
    }
    public Object processProfileResponse()
    {

        system.debug('processProfileResponse');
        try
        {
            profileService.initHTTPResponse(IADPaymentProfilesService.GETPROFILESBYUSERID);

            profileService.populateProfiles();


            profileIdToProfile = new Map<String,IADContractBeans.IADPaymentProfileBean>();
            if(profileService.allProfiles.size()>0)
            {
                for(IADContractBeans.IADPaymentProfileBean thePayment : profileService.allProfiles)
                {
                    profileIdToProfile.put(thePayment.profileId, thePayment);
                }
            }
            if(profileService.profiles.size()>0)
            {
                profileId = profileService.profiles[0].profileId;
            }

        }
        catch(IADException theException)
        {
            refundService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {

            refundService.populateErrorMessage(theException);
        }
        return null;
    }
    public String constructRefundRequestForSCtoCard()
    {
        IADContractBeans.IADStoreCreditRefundToCard refund = new IADContractBeans.IADStoreCreditRefundToCard();
        refund.storeCreditId = invokingPageId;
        refund.amount = totalAmountConverted();
        refund.customerId = customerId;
        refund.comments = comments;
        refund.notificationEmail = email;
        refund.createdBy = UtilityLibrary.generateUpdatedBy();

        return JSON.serialize(refund);
    }
    public String constructRefundRequest()
    {
        IADContractBeans.IADProcessRefundBean refundBean = new IADContractBeans.IADProcessRefundBean();
        IADContractBeans.IADProcessRefund refund = new IADContractBeans.IADProcessRefund();
        refund.orderId = orderNum;
        refund.amount = String.valueOf(totalAmountConverted()); //p1ToAmount.get(selectedPayment);
        refund.createdBy = UtilityLibrary.generateUpdatedBy();
        if(profileId!=IADPaymentProfilesComponentController.refundToStoreCredit)
            refund.paymentProfileId = UtilityLibrary.stripStoreCreditOrProfileId(profileId); //pTransactionToProfileId.get(selectedPayment);
        refund.comments = comments;
        refund.customerId = customerId;
        refund.reasonId = selectedReasonForRefunds;
        refund.source = UtilityLibrary.getConfig().Payment_Source__c;
        refund.notificationEmail = email;
        refund.paymentTransactionId = selectedPayment;
        system.debug('refund' + refund);
        refundBean.refundDetail = refund;

        return JSON.serialize(refundBean);
    }
    public void setSelectedPaymentManual()
    {
        system.debug('selectedPayment '  + selectedPayment);

        String profileIdToSet = pTransactionToProfileId.get(selectedPayment);
        if(profileIdToSet!= null)
        {
            system.debug('profileIdToSet ' + profileIdToSet);
            if(profileIdToProfile.get(profileIdToSet).isActive==true)
            {
                system.debug('profileId before ' + profileId);
                profileId = 'pp' + profileIdToSet;
                system.debug('profileId after ' + profileId);
            }
            else
            {
                profileId = '';
            }
        }
        else
        {
            profileId = '';
        }
    }
}