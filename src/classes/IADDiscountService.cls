public with sharing class IADDiscountService extends IADServiceBase
{
    public final static String POSTORDERSORDERDISCOUNTS = 'PostOrdersOrderDiscounts';
    public final static String POSTCANCELDISCOUNTBYDISCOUNTID = 'PostCancelDiscountByDiscountId';
    public List<IADContractBeans.IADDiscountDetail> discountDetails{get;set;}
    
    public Boolean isDiscountSuccess{get;set;}

    public IADDiscountService() {
        super();
        List <String> endpoints = new List <String>();
        endpoints.add(POSTORDERSORDERDISCOUNTS);
        endpoints.add(POSTCANCELDISCOUNTBYDISCOUNTID);
        initEndpoints(endpoints);
        isDiscountSuccess = false;
        discountDetails = new List<IADContractBeans.IADDiscountDetail>();

    }

    public Object applyOrderDiscounts(String orderId , String discountAmount , String comments , Integer discountReason)
    {
        String calloutURL = APItoWrapper.get(POSTORDERSORDERDISCOUNTS).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}',orderId);
        
        DiscountPost theDiscountPost = new DiscountPost();
        theDiscountPost.discountValue = Decimal.valueOf(discountAmount);
        theDiscountPost.comments = comments;
        theDiscountPost.createdBy = UtilityLibrary.generateUpdatedBy();
        theDiscountPost.approvedBy = UtilityLibrary.generateUpdatedBy();
        theDiscountPost.discountReason = discountReason;

        APItoWrapper.get(POSTORDERSORDERDISCOUNTS).setInfo(APIRequestResponseWrapper.ORDER, orderId);

        Object continuationObject = makeRequest(calloutURL, POSTORDERSORDERDISCOUNTS , JSON.serialize(theDiscountPost));
        if(!APItoWrapper.get(POSTORDERSORDERDISCOUNTS).isAsync)
        {
            processApplyDiscount();
        }
        return continuationObject;

    }

    public void processApplyDiscount()
    {
        try
        {
            initHTTPResponse(POSTORDERSORDERDISCOUNTS); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(POSTORDERSORDERDISCOUNTS);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                   
                     populateSuccessMessage('Discount Applied Successfully!!!');
                     isDiscountSuccess = true;
                    
                }
                else
                {
                    populateNullErrorMessage(theResponse);
                }
            }
            else
            {
                populateErrorMessage(theResponse);
            }
        }
        catch(Exception theException)
        {
            populateErrorMessage('Error processing Response + ' + theException.getStackTraceString());
        }
    }

    public Object cancelDiscount(String orderId , String orderDiscountId)
    {
        String calloutURL = APItoWrapper.get(POSTCANCELDISCOUNTBYDISCOUNTID).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}',orderId);
        String jsonRequest = '{"orderDiscountId":'+orderDiscountId+',"updatedBy":"'+UtilityLibrary.generateUpdatedBy()+'"}';
        APItoWrapper.get(POSTCANCELDISCOUNTBYDISCOUNTID).setInfo(APIRequestResponseWrapper.ORDER, orderId);
        Object continuationObject = makeRequest(calloutURL, POSTCANCELDISCOUNTBYDISCOUNTID , jsonRequest);
        if(!APItoWrapper.get(POSTCANCELDISCOUNTBYDISCOUNTID).isAsync)
        {
            processCancelDiscount();
        }
        return continuationObject;

    }

    public void processCancelDiscount()
    {
        try
        {
            initHTTPResponse(POSTCANCELDISCOUNTBYDISCOUNTID); //sets the responseData and statusCode on the wrapper
            APIRequestResponseWrapper theResponse = APItoWrapper.get(POSTCANCELDISCOUNTBYDISCOUNTID);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null) //Only check this if you need the response body
                {
                    populateSuccessMessage('Discount has been cancelled');
                    isDiscountSuccess = true;
                }
                else
                {
                    populateNullErrorMessage(theResponse);
                }
            }
            else
            {
                populateErrorMessage(theResponse);
            }
        }
        catch(Exception theException)
        {
            populateErrorMessage('Error processing Response + ' + theException.getStackTraceString());
        }
    }


    
   public void populateDiscountList(IADContractBeans.IADOrderBalance theOrderBalance)
   {
        for(IADContractBeans.IADDiscountDetail theDiscount : theOrderBalance.discountDetails)
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
    
        
    public class DiscountPost
    {
        
        public Decimal discountValue{get;set;}
        public String  comments{get;set;}
        public String  createdBy{get;set;}
        public String approvedBy{get;set;}
        public Integer discountReason{get;set;}
    }

}