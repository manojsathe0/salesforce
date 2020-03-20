public with sharing class IADDiscountService_Ltng  extends IADServiceBase_ltng {
    public final static String POSTORDERSORDERDISCOUNTS = 'PostOrdersOrderDiscounts';
    public final static String POSTCANCELDISCOUNTBYDISCOUNTID = 'PostCancelDiscountByDiscountId';
    @AuraEnabled public Static List<IADContractBeans_ltng.IADDiscountDetail> discountDetails {get;set;}
    
    public static Boolean isDiscountSuccess{get;set;}
    
    public IADDiscountService_Ltng() {
        super();
        List <String> endpoints = new List <String>();
        endpoints.add(POSTORDERSORDERDISCOUNTS);
        endpoints.add(POSTCANCELDISCOUNTBYDISCOUNTID);
        initEndpoints(endpoints);
        isDiscountSuccess = false;
        discountDetails = new List<IADContractBeans_ltng.IADDiscountDetail>();
    }
    
    public static void applyOrderDiscounts(String orderId , String discountAmount , String comments , Integer discountReason, String approvedBy) {
        System.Debug('Inside applyOrderDiscounts');
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTORDERSORDERDISCOUNTS).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}',orderId);
        
        DiscountPost theDiscountPost = new DiscountPost();
        theDiscountPost.discountValue = Decimal.valueOf(discountAmount);
        theDiscountPost.comments = comments;
        theDiscountPost.createdBy = UtilityLibrary.generateUpdatedBy();
        theDiscountPost.approvedBy = String.isNotBlank(approvedBy) ? approvedBy : UtilityLibrary.generateUpdatedBy();
        theDiscountPost.discountReason = discountReason;
        
        IADServiceBase_ltng.APItoWrapper.get(POSTORDERSORDERDISCOUNTS).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTORDERSORDERDISCOUNTS , JSON.serialize(theDiscountPost));
        processApplyDiscount();
        
    }
    
    public static void processApplyDiscount() {
        System.Debug('Inside processApplyDiscount');
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(POSTORDERSORDERDISCOUNTS);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    IADServiceBase_ltng.populateSuccessMessage('Discount Applied Successfully!!!');
                    isDiscountSuccess = true;
                    IADDiscountController_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    IADDiscountController_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                IADDiscountController_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Error processing Response + ' + theException.getStackTraceString());
            IADDiscountController_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void populateDiscountList(IADContractBeans_ltng.IADOrderBalance theOrderBalance) {
        for(IADContractBeans_ltng.IADDiscountDetail theDiscount : theOrderBalance.discountDetails)
        {
            if(theDiscount.discountType.discountTypeId != 2) //Exclude Group Discount which comes in Promo Code
            {
                theDiscount.adjDateEntered= UtilityLibrary.getIADDateTime(theDiscount.dateEntered);
                theDiscount.adjDateEnteredDT = UtilityLibrary.getIADDateTimeDT(theDiscount.dateEntered);
                discountDetails.add(theDiscount);
            }
        }
        discountDetails.sort();
    }
    
    public static void cancelDiscount(String orderId , String orderDiscountId) {
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(POSTCANCELDISCOUNTBYDISCOUNTID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}',orderId);
        String jsonRequest = '{"orderDiscountId":'+orderDiscountId+',"updatedBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
        IADServiceBase_ltng.APItoWrapper.get(POSTCANCELDISCOUNTBYDISCOUNTID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, POSTCANCELDISCOUNTBYDISCOUNTID, jsonRequest);
        processCancelDiscount();
    }
    
    public static void processCancelDiscount() {
        try {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(POSTCANCELDISCOUNTBYDISCOUNTID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    IADServiceBase_ltng.populateSuccessMessage('Discount Cancelled Successfully!!!');
                    isDiscountSuccess = true;
                    IADDiscountController_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    IADDiscountController_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                IADDiscountController_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Error processing Response + ' + theException.getStackTraceString());
            IADDiscountController_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public class DiscountPost {
        public Decimal discountValue{get;set;}
        public String comments{get;set;}
        public String createdBy{get;set;}
        public String approvedBy{get;set;}
        public Integer discountReason{get;set;}
    }
    
}