public with sharing class IADDiscountController 
{
   
    public IADDiscountService discountService{get;set;}
    public IADOrderWithOrderItemsService orderService{get;set;}
    
    public String discountAmount{get;set;}
    public String selectedDiscountReason{get;set;}
    public String comments{get;set;}
    public String orderId{get;set;}
    public Map<Integer,String> discountReasonMap = new Map<Integer,String>();
    public String orderDiscountId{get;set;}
    
    public IADDiscountController ()
    {
        discountService = new IADDiscountService();
        orderService  = new IADOrderWithOrderItemsService();
        orderId = ApexPages.currentPage().getParameters().get('orderId');
        /*
        Removing several values per story Story B-21034
        By Artyom M.
        */
        discountReasonMap.put(1,'Customer Satisfaction');
        discountReasonMap.put(2,'Subscription Cancellation');
        discountReasonMap.put(3,'Customer Overcharged');
        discountReasonMap.put(4,'Change to Order');
        discountReasonMap.put(9,'Managed Plan Adjustment');
        /*
        discountReasonMap.put(4,'Change to Order (pre 2.5)');
        discountReasonMap.put(5,'Downgrade/Remove Items (pre 2.5)');
        discountReasonMap.put(6,'Downgrade/Changes to Order (pre 2.5)');
        discountReasonMap.put(7,'Third Party Dormancy');
        discountReasonMap.put(8,'Third Party Cancellation');
        discountReasonMap.put(10,'Subscription Level  Change');
        */
        
    }
   
    public List<selectOption> getReasonsForDiscount()
    {
        List<selectOption> options = new List<selectOption>();
        for(Integer key : discountReasonMap.keySet())
        {
            options.add(new SelectOption(key+'', discountReasonMap.get(key)));
        }       
        return options;
    }

    public Object applyOrderDiscount()
    {
        discountService.isDiscountSuccess = false;
        discountService.clearMessages();
        if(discountAmount == '' || discountAmount == null)
        {
            discountService.populateErrorMessage('Please Provide Discount Amount');
            return null;
        }
        else
        {
            try
            {
                Decimal dAmtDecimal = Decimal.valueOf(discountAmount);
            }
            catch(Exception exp)
            {
                discountService.populateErrorMessage('Please Enter Valid Amount');
                return null;
            }
        }

        if(comments == '' || comments == null)
        {
            discountService.populateErrorMessage('Please Provide Comments');
            return null;
        }

        Object continuationObject;
        try
        {
           
            discountService.initWrapper(IADDiscountService.POSTORDERSORDERDISCOUNTS, 'processApplyDiscount');
            Integer theReasonId = Integer.valueOf(selectedDiscountReason); 
            continuationObject = discountService.applyOrderDiscounts(orderId , discountAmount , comments ,theReasonId);
          
        }
        catch(IADException theException)
        {
            discountService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            discountService.populateErrorMessage(theException);
        }
        return continuationObject;


    }

    public Object processApplyDiscount()
    {
        try
        {
            discountService.processApplyDiscount();
        }
        catch(IADException theException)
        {
            discountService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            discountService.populateErrorMessage(theException);
        }
        return null;
    }
    
    public Object populateDiscountDetails()
    {
            
        Object continuationObject;
        try
        {
            orderService.initWrapper(IADOrderWithOrderItemsService.GETORDERBALANCESBYORDERID, 'processOrderBalancesResponse');
            continuationObject = (Continuation)orderService.getOrderBalanceByOrderId(orderId);
             
        }
        catch(IADException theException)
        {
            discountService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            discountService.populateErrorMessage(theException);
        }
   
        return continuationObject;
    }
    
    public Object processOrderBalancesResponse()
    {
        try
        {
            orderService.populateOrderBalance();
            discountService.populateDiscountList(orderService.theOrderBalance);
        }
        catch(IADException theException)
        {
            discountService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            discountService.populateErrorMessage(theException);
        }
        return null;
    }

    public Object cancelDiscount()
    {
        discountService.isDiscountSuccess = false;
        discountService.clearMessages();
        Object continuationObject;
        try
        {
         
            discountService.initWrapper(IADDiscountService.POSTCANCELDISCOUNTBYDISCOUNTID, 'processCancelDiscount');
            continuationObject = discountService.cancelDiscount(orderId , orderDiscountId);
          
        }
        catch(IADException theException)
        {
            discountService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            discountService.populateErrorMessage(theException);
        }
        return continuationObject;
    }

    public void setOrderDiscountId()
    {
        discountService.clearMessages();
        orderDiscountId = ApexPages.currentPage().getParameters().get('orderDiscountId');
    }

    public Object processCancelDiscount()
    {
        try
        {
            discountService.processCancelDiscount();
        }
        catch(IADException theException)
        {
            discountService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            discountService.populateErrorMessage(theException);
        }
        return null;
    }


}