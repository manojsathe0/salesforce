public with sharing class IADPromoCodeController
{
    public IADPromoCodeService promoCodeService{get;set;}
    public String promoCode{get;set;}
    public String comments{get;set;}
    public String orderId{get;set;}
  
    
    public IADPromoCodeController()
    {
        promoCodeService = new IADPromoCodeService();
        orderId = ApexPages.currentPage().getParameters().get('orderId');
            
    }
   
   
    public Object applyPromoCode()
    {
        promoCodeService.isPromoCodeApplied = false;
        promoCodeService.clearMessages();
        if(promoCode == '' || promoCode == null)
        {
            promoCodeService.populateErrorMessage('Please Provide Promo Code');
            return null;
        }

        if(comments == '' || comments == null)
        {
            promoCodeService.populateErrorMessage('Please Provide Comments');
            return null;
        }
        Object continuationObject;
        try
        {
           
            promoCodeService.initWrapper(IADPromoCodeService.POSTAPPLYPROMOCODEBYORDERID, 'processApplyPromoCode');
            continuationObject = promoCodeService.applyPromoCode(orderId , promoCode , comments);
          
        }
        catch(IADException theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        return continuationObject;


    }

    public Object processApplyPromoCode()
    {
        try
        {
            promoCodeService.processApplyPromoCode();
        }
        catch(IADException theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        return null;
    }

    public Object displayPromoCode()
    {
        promoCodeService.clearMessages();
        Object continuationObject;
        try
        {
           
            promoCodeService.initWrapper(IADPromoCodeService.GETPROMOCODESBYORDERID, 'processDisplayPromoCode');
            continuationObject = promoCodeService.displayPromoCode(orderId);
          
        }
        catch(IADException theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        return continuationObject;


    }

    public Object processDisplayPromoCode()
    {
        try
        {
            promoCodeService.processDisplayPromoCode();
        }
        catch(IADException theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        return null;
    }

    public Object checkPromoCode()
    {
        promoCodeService.clearMessages();
        if(promoCode == '' || promoCode == null)
        {
            promoCodeService.populateErrorMessage('Please Provide Promo Code');
            return null;
        }
      

        Object continuationObject;
        try
        {
           
            promoCodeService.initWrapper(IADPromoCodeService.GETVALIDATEPROMOCODEBYORDERID, 'processCheckPromoCode');
            continuationObject = promoCodeService.checkPromoCode(orderId , promoCode);
          
        }
        catch(IADException theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        return continuationObject;


    }

    public Object processCheckPromoCode()
    {
        try
        {
            promoCodeService.processCheckPromoCode();
        }
        catch(IADException theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        return null;
    }

    public Object cancelPromoCode()
    {
        promoCodeService.isPromoCodeCancelled = false;
        promoCodeService.clearMessages();
           

        Object continuationObject;
        try
        {
           
            promoCodeService.initWrapper(IADPromoCodeService.POSTCANCELPROMOCODEBYORDERID, 'processCancelPromoCode');
            continuationObject = promoCodeService.cancelPromoCode(orderId , promoCodeService.currentPromoCode);
          
        }
        catch(IADException theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        return continuationObject;


    }

    public Object processCancelPromoCode()
    {
        try
        {
            promoCodeService.processCancelPromoCode();
        }
        catch(IADException theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            promoCodeService.populateErrorMessage(theException);
        }
        return null;
    }
}