public with sharing class IADPendingPaymentController 
{
    public String theId;
    public String orderId {get;set;}
    public String dayview{get;set;}
    public IADContractBeans.IADPaymentBean thePayment{get;set;}
    public IADContractBeans.IADPaymentBean theOriginalPayment{get;set;}
    public IADPaymentService paymentService{get;set;}
    public IADEditPaymentService getProfileService{get;set;}
    public String transactionType{get;set;}
    public String transactionTypeLabel{get;set;}
    public String transactionLabel{get;set;}

    public IADPendingPaymentController () 
    {
        dayview = IADSGVIconStrings.dayview;
        theId = ApexPages.currentPage().getParameters().get('id');
        orderId = ApexPages.currentPage().getParameters().get('orderid');
        transactionType = ApexPages.currentPage().getParameters().get('transactionType');
        paymentService  = new IADPaymentService();
        thePayment = new IADContractBeans.IADPaymentBean();
        theOriginalPayment = new IADContractBeans.IADPaymentBean();
        getProfileService = new IADEditPaymentService();
    }
  
    
    public Object populatePayments()
    {
        
        Object continuationObject;
        try
        {
            String objectId = theId;
            if(transactionType == '1') //Payments
            {
                paymentService.initWrapper(IADPaymentService.GETPAYMENTBYPAYMENTID, 'processPaymentResponse');
                continuationObject = paymentService.getPaymentByPaymentId(objectId);
                transactionTypeLabel = 'Payment';
            }
            else if(transactionType == '2') //Refunds
            {
                paymentService.initWrapper(IADPaymentService.GETREFUNDBYREFUNDID, 'processPaymentResponse');
                continuationObject = paymentService.getRefundByRefundId(objectId);
                transactionTypeLabel = 'Refund';
            }
        }
        catch(IADException theException)
        {
            paymentService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            paymentService.populateErrorMessage(theException.getMessage());
        }
        
        return continuationObject; 
       
    }
    
    //Callback method for Asynchronous
    public Object processPaymentResponse()  
    {   
        try
        {
            if(transactionType == '1') //Payment
            {
                paymentService.initHTTPResponse(IADPaymentService.GETPAYMENTBYPAYMENTID);
                paymentService.populatePayments();
            }
            else if(transactionType == '2') //Refund
            {
                paymentService.initHTTPResponse(IADPaymentService.GETREFUNDBYREFUNDID);   
                paymentService.populateRefund();
            }
            thePayment = paymentService.thePayment;
        }
        catch(IADException theException)
        {
            paymentService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            paymentService.populateErrorMessage(theException.getMessage());
        }
         
        return null;
    }
    public Object populateOriginalPayment()
    {

        Object continuationObject;
        try
        {
            String objectId = thePayment.parentId;
            paymentService.initWrapper(IADPaymentService.GETPAYMENTBYPAYMENTID, 'processOriginalPaymentResponse');
            continuationObject = paymentService.getPaymentByPaymentId(objectId);
            //Saved for if logic gets separated out to separate API, otherwise continue using the above
//            if(UtilityLibrary.paymentTypeToNameMap.get(thePayment.paymentType) == 'Credit Card') //Credit Card Payment
//            {
//                paymentService.initWrapper(IADPaymentService.GETPAYMENTBYPAYMENTID, 'processOriginalPaymentResponse');
//                continuationObject = paymentService.getPaymentByPaymentId(objectId);
//                transactionTypeLabel = 'Payment';
//            }
//            else if(UtilityLibrary.paymentTypeToNameMap.get(thePayment.paymentType) == 'Store Credit') //Store Credit
//            {
//                paymentService.initWrapper(IADPaymentService.SOMEAPI, 'processOriginalPaymentResponse');
//                continuationObject = paymentService.getPaymentByPaymentId(objectId);
//                transactionTypeLabel = 'Store Credit';
//            }
        }
        catch(IADException theException)
        {
            paymentService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            paymentService.populateErrorMessage(theException.getMessage());
        }

        return continuationObject;

    }

    //Callback method for Asynchronous
    public Object processOriginalPaymentResponse()
    {
        try
        {
            paymentService.initHTTPResponse(IADPaymentService.GETPAYMENTBYPAYMENTID);
            paymentService.populatePayments();

            //Saved for if logic gets separated out to separate API, otherwise continue using the above
//            if(UtilityLibrary.paymentTypeToNameMap.get(thePayment.paymentType) == 'Credit Card') //Credit Card Payment
//            {
//                paymentService.initHTTPResponse(IADPaymentService.GETPAYMENTBYPAYMENTID);
//                paymentService.populatePayments();
//            }
//            else if(UtilityLibrary.paymentTypeToNameMap.get(thePayment.paymentType) == 'Store Credit') //Store Credit
//            {
//                paymentService.initHTTPResponse(IADPaymentService.SOMEAPI);
//                paymentService.populatePayments();
//            }
            theOriginalPayment = paymentService.thePayment;
        }
        catch(IADException theException)
        {
            paymentService.populateErrorMessage(theException.getMessage());
        }
        catch(Exception theException)
        {
            paymentService.populateErrorMessage(theException.getMessage());
        }

        return null;
    }
    public Object populateOriginalPaymentProfile()
    {
        Object continuationObject;
        try
        {
            system.debug('populatepaymentprofile');
            getProfileService.initWrapper(IADEditPaymentService.GETPROFILEBYID, 'processOriginalProfile');

            if(theOriginalPayment.paymentProfileId != null && theOriginalPayment.paymentProfileId != '' && theOriginalPayment.paymentProfileId != '0')
                continuationObject = getProfileService.getPaymentProfileById(theOriginalPayment.paymentProfileId);
        }
        catch(IADException theException)
        {
            getProfileService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            getProfileService.populateErrorMessage(theException);
        }
        return continuationObject;


    }
    public Object processOriginalProfile()
    {
        try
        {
            system.debug('populatepaymentprofile response');
            getProfileService.populateProfileById();

            if(getProfileService.theProfile!= null)
            {
                if(UtilityLibrary.paymentTypeToNameMap.get(thePayment.paymentType) == 'Credit Card') //Credit Card Payment
                {
                    transactionLabel = theOriginalPayment.paymentTransactionId + ': '
                            + UtilityLibrary.profileAccountTypeToNameMap.get(getProfileService.theProfile.AccountType)
                            + ' - ' + getProfileService.theProfile.last4Digits + ' - $' + theOriginalPayment.amount;
                }
//                else if(UtilityLibrary.paymentTypeToNameMap.get(thePayment.paymentType) == 'Store Credit') //Store Credit
//                {
//                    //Todo when store credit contract errors are solved, create a proper label with this information
//                    transactionLabel = theOriginalPayment.paymentTransactionId + ': '
//                            + UtilityLibrary.profileAccountTypeToNameMap.get(getProfileService.theProfile.AccountType)
//                            + ' - ' + getProfileService.theProfile.last4Digits + ' - $' + theOriginalPayment.amount;
//                }

            }


        }
        catch(IADException theException)
        {
            getProfileService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            getProfileService.populateErrorMessage(theException);
        }
        return null;
    }

  
}