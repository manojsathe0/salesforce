public with sharing class IADInstallmentPaymentController
{
    public String selectedPayment{get;set;}
    public String comments{get;set;}
    public String email{get;set;}
    public String selectedReason{get;set;}
    public String paymentType{get;set;}
    public String paymentName{get;set;}
    public String profileId{get;set;}
    public String amount{get;set;}
    public Decimal amountDue{get;set;}
    public Decimal theBalance{get;set;}
    public String customerId{get;set;}
    public String orderNum{get;set;}
    public String responseStatus{get;set;}
    public Integer otherAmountCounts{get;set;}
    public List<selectOption> paymentReasons{get;set;}
    public String invokingPage{get;set;}
    public String invokingPageId{get;set;}
    public IADInstallmentPaymentService paymentService{get;set;}
    public IADOrderWithOrderItemsService balanceService{get;set;}
    public IADContractBeans.IADPaymentBean thePayment{get;set;}
    public List<OtherWrapper> otherAmntList {get;set;}
    public Map<Integer, OtherWrapper> otherAmntMap {get;set;}
    public boolean isStoreCreditPayment{get;set;}
    public IADContractBeans.IADOrderBalance theOrderBalance{get;set;}
    public IAD_Config__mdt config{get;set;}

    public IADInstallmentPaymentController()
    {
        orderNum = ApexPages.currentPage().getParameters().get('orderId');
        customerId = ApexPages.currentPage().getParameters().get('customerId');
        invokingPage = ApexPages.currentPage().getParameters().get('invokingPage');
        invokingPageId = ApexPages.currentPage().getParameters().get('invokingPageId');

        system.debug('customerid ' + customerId);

        if(ApexPages.currentPage().getParameters().get('installment') == '1')
        {
            paymentType = 'Installment Payment';
            paymentName = 'Installment';
        }
        else if(ApexPages.currentPage().getParameters().get('amountdue') == '1')
        {
            paymentType = 'Payment';
            paymentName = 'Amount';
        }

        amount = ApexPages.currentPage().getParameters().get('amount');

        paymentService = new IADInstallmentPaymentService();
        balanceService = new IADOrderWithOrderItemsService();
        otherAmountCounts = 0;
        otherAmntList= new List<OtherWrapper>();
        otherAmntMap= new Map<Integer, OtherWrapper>();



        profileId = Apexpages.currentPage().getParameters().get('profileId');

        paymentReasons= UtilityLibrary.paymentReasons;

        config = UtilityLibrary.getConfig();

        if(customerId != null && customerId != '')
        {
            List<Customer_Login__c> customerLogins = [SELECT Id , Primary_Contact__r.Email FROM Customer_Login__c WHERE Customer_ID__c = :customerId];
            if(!customerLogins.isEmpty())
            {
                email = customerLogins[0].Primary_Contact__r.Email;
            }
        }
    }
    public void setProfileIdManual()
    {
        system.debug('profile id '  + profileId);
    }
    public class OtherWrapper
    {
        public Integer index{Get;set;}
        public Decimal amount{get;set;}
    }
    public void addOtherAmt()
    {
        OtherWrapper wrap = new OtherWrapper();
        wrap.index=otherAmountCounts;

        otherAmntMap.put(otherAmountCounts, wrap);
        otherAmntList.add(wrap);
        otherAmountCounts ++;

    }
    public Object populateOrderBalances()
    {
        Object continuationObject;
        balanceService.initWrapper(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, 'processOrderBalancesResponse');
        continuationObject = balanceService.getOrderBalanceByOrderId(orderNum);

        return continuationObject;

    }

    //Callback method for Asynchronous
    public Object processOrderBalancesResponse()
    {
        try
        {
            system.debug('made it to response');
            balanceService.populateOrderBalance();

            APIRequestResponseWrapper response =  balanceService.APItoWrapper.get(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID);

            if(response.checkIsValidResponse())
            {
                if(paymentName!='Installment')
                {
                    amount = String.valueOf(balanceService.theOrderBalance.orderBalanceAmount);
                    amountDue = balanceService.theOrderBalance.orderBalanceAmount;
                }
                else
                    amountDue = Decimal.valueOf(amount); //Decimal.valueOf(balanceService.theOrderBalance.subTotalInstallmentBalance);
            }
            else
            {
                paymentService.populateErrorMessage(response);
            }

        }
        catch(IADException theException)
        {
            paymentService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            paymentService.populateErrorMessage(theException);
        }


        return null;
    }


    public Object postPayment()
    {
        Object continuationObject;
        isStoreCreditPayment = false;
        paymentService.clearMessages();
        try
        {
            Decimal totalAmountConverted = totalAmountConverted();

            system.debug('totalAmountConverted + ' + totalAmountConverted + ' amountDue ' + amountDue);
            if(comments == null || comments == '')
            {
                paymentService.populateErrorMessage('Must provide comments.');
            }

            if(email != null && email != '')
                email = email.trim();

            if(!UtilityLibrary.validateEmail(email) && !profileId.contains('sc'))
            {
                paymentService.populateErrorMessage('Must provide valid email format.');
            }
            if(totalAmountConverted > amountDue)
            {
                paymentService.populateErrorMessage('Process amount is greater than amount due.');
            }
            if(getTotalAmount().contains('-'))
            {
                paymentService.populateErrorMessage('Negative payments not allowed');
            }
            if(paymentService.errorCount == 0)
            {
                if(!getTotalAmount().contains('-') && totalAmountConverted > 0  && totalAmountConverted <= amountDue && totalAmountConverted != 0.00)
                {
                    if(profileId.contains('pp'))
                    {
                        if(invokingPage!='Installment')
                        {
                            paymentService.initWrapper(IADInstallmentPaymentService.POSTPAYMENT, 'processPaymentResponse');
                            IADContractBeans.IADMakePaymentBean paymentbean = new IADContractBeans.IADMakePaymentBean();
                            paymentbean.orderId = orderNum;
                            paymentbean.amount = String.valueOf(totalAmountConverted());
                            paymentbean.createdBy = UtilityLibrary.generateUpdatedBy();
                            paymentbean.source = config.Payment_Source__c;
                            paymentbean.paymentProfileId = UtilityLibrary.stripStoreCreditOrProfileId(profileId);
                            paymentbean.gateway = config.Payment_Gateway__c;
                            paymentbean.comments = comments;
                            paymentbean.reasonId = selectedReason;
                            paymentbean.notificationEmail = email;
                            continuationObject = paymentService.postPayment(paymentbean);
                        }
                        else
                        {
                            paymentService.initWrapper(IADInstallmentPaymentService.POSTPAYMENTFORINSTALLMENT, 'processPaymentForInstallmentResponse');
                            IADContractBeans.IADMakePaymentInstallmentBean paymentbean = new IADContractBeans.IADMakePaymentInstallmentBean();
                            paymentbean.orderId = orderNum;
                            paymentbean.amount = String.valueOf(totalAmountConverted());
                            paymentbean.createdBy = UtilityLibrary.generateUpdatedBy();
                            paymentbean.source = config.Payment_Source__c;
                            paymentbean.paymentProfileId = UtilityLibrary.stripStoreCreditOrProfileId(profileId);
                            paymentbean.gateway = config.Payment_Gateway__c;
                            paymentbean.comments = comments;
                            paymentbean.reasonId = selectedReason;
                            paymentbean.notificationEmail = email;
                            paymentBean.installmentBill = invokingPageId;

                            continuationObject = paymentService.postPaymentForInstallment(paymentbean);
                        }

                    }
                    else if(profileId.contains('sc'))
                    {
                        isStoreCreditPayment = true;
                        paymentService.initWrapper(IADInstallmentPaymentService.POSTPAYMENTBYSTORECREDITID, 'processPaymentStoreCreditResponse');
                        IADContractBeans.IADMakePaymentStoreCredit paymentbean = new IADContractBeans.IADMakePaymentStoreCredit();
                        paymentbean.orderId = orderNum;
                        paymentbean.storeCreditPaymentAmount = String.valueOf(totalAmountConverted());
                        paymentbean.creatorId = UtilityLibrary.generateUpdatedBy();
                        paymentbean.storeCreditId = UtilityLibrary.stripStoreCreditOrProfileId(profileId);
                        paymentbean.comments = comments;
                        continuationObject = paymentService.postPaymentByStoreCreditId(paymentbean);
                    }
                }
                else
                {
                    paymentService.populateErrorMessage('Not a valid amount.');
                }
            }
        }
        catch(IADException theException)
        {
            paymentService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            paymentService.populateErrorMessage(theException);
        }

        return continuationObject;
    }
    //Callback method for Asynchronous
    public Object processPaymentStoreCreditResponse()
    {
        try
        {
            Decimal totalAmountConverted = totalAmountConverted();

            paymentService.populateStoreCreditResponse();

            APIRequestResponseWrapper response = paymentService.APItoWrapper.get(IADInstallmentPaymentService.POSTPAYMENTBYSTORECREDITID);

            system.debug('response ' + response);

            if(response.resultObjects != null)
            {
                system.debug('not null');
                IADContractBeans.IADMakePaymentStoreCreditResponse thePaymentStoreCredit = (IADContractBeans.IADMakePaymentStoreCreditResponse)response.resultObjects[0];
                if(thePaymentStoreCredit != null && thePaymentStoreCredit.storeCreditTransactionId!= null && paymentService.errorCount==0)
                {
                    responseStatus = 'Approved';
                    paymentService.populateSuccessMessage( 'Payment processed for $' + totalAmountConverted + '! If your balance due is $0, this page will close.');
                }
            }
        }
        catch(IADException theException)
        {
            paymentService.populateErrorMessage(theException);

        }
        catch(Exception theException)
        {
            paymentService.populateErrorMessage(theException);
        }
        return null;
    }
    //Callback method for Asynchronous
    public Object processPaymentResponse()
    {
        try
        {
            Decimal totalAmountConverted = totalAmountConverted();

            paymentService.populatePayments();

            APIRequestResponseWrapper response = paymentService.APItoWrapper.get(IADInstallmentPaymentService.POSTPAYMENT);

            system.debug('response ' + response);

            if( response.resultObjects != null)
            {
                thePayment = paymentService.thePayment;
                if(thePayment != null &&  thePayment.paymentTransactionId!= null && paymentService.errorCount==0)
                {
                    responseStatus =  IADPaymentTransaction.statusMap.get(thePayment.transactionStatus);
                    paymentService.populateSuccessMessage( 'Payment processed for $' + totalAmountConverted + '! If your balance due is $0, this page will close.');
                }
            }
        }
        catch(IADException theException)
        {
            paymentService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            paymentService.populateErrorMessage(theException);
        }
        return null;
    }

    public Object processPaymentForInstallmentResponse()
    {
        try
        {
            Decimal totalAmountConverted = totalAmountConverted();

            paymentService.populatePaymentsForInstallment();

            APIRequestResponseWrapper response = paymentService.APItoWrapper.get(IADInstallmentPaymentService.POSTPAYMENTFORINSTALLMENT);

            system.debug('response ' + response);

            if(response.resultObjects != null)
            {
                thePayment = paymentService.thePayment;
                if(thePayment != null && thePayment.paymentTransactionId!= null && paymentService.errorCount==0)
                {
                    responseStatus =  IADPaymentTransaction.statusMap.get(thePayment.transactionStatus);
                    paymentService.populateSuccessMessage( 'Payment processed for $' + totalAmountConverted + '! This page will close.');
                }
            }
        }
        catch(IADException theException)
        {
            paymentService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            paymentService.populateErrorMessage(theException);
        }
        return null;
    }
    public String getTotalAmount()
    {
        return Apexpages.currentPage().getParameters().get('totalAmount');
    }
    public Decimal totalAmountConverted()
    {
        String totalAmnt = getTotalAmount();
        if(totalAmnt != null && totalAmnt != '')
        {
            return Decimal.valueOf(getTotalAmount());
        }
        else
        {
            return 0.00;
        }

    }


}