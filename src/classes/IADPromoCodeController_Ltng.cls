public class IADPromoCodeController_Ltng {
	@AuraEnabled public static IADOrderWithOrderItemsController_ltng ctrlRef {get; set;}
    @AuraEnabled public static IADPromoCodeService_Ltng promoCodeService {get; set;}
    
    @AuraEnabled
    public static IADPromoCodeService_Ltng applyPromoCode(String orderId , String promoCode , String comments) {
    	try 
        {
            promoCodeService = new IADPromoCodeService_Ltng();

    		IADServiceBase_ltng.initWrapper(IADPromoCodeService_Ltng.POSTAPPLYPROMOCODEBYORDERID);
    		IADPromoCodeService_Ltng.applyPromoCode(orderId, promoCode, comments);
    		System.Debug('Valid? = ' + IADPromoCodeService_Ltng.isPromoCodeApplied);
    		System.Debug('Valid? = ' + IADPromoCodeService_Ltng.promoCodeValue);
    	}
    	catch(IADException theException) {
        	System.Debug('theException: ' + theException.getMessage());
        	IADServiceBase_ltng.populateErrorMessage(theException);
            IADPromoCodeService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException) {
        	System.Debug('theException2: ' + theException.getMessage());
        	IADServiceBase_ltng.populateErrorMessage(theException);
            IADPromoCodeService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        
        return promoCodeService;
    }
    
    @AuraEnabled
    public static IADPromoCodeService_Ltng cancelPromoCode(String orderId , String currentPromoCode) {
    	try {
    		promoCodeService = new IADPromoCodeService_Ltng();

    		IADServiceBase_ltng.initWrapper(IADPromoCodeService_Ltng.POSTCANCELPROMOCODEBYORDERID);
    		IADPromoCodeService_Ltng.cancelPromoCode(orderId, currentPromoCode);
    		System.Debug('Valid? = ' + IADPromoCodeService_Ltng.isPromoCodeApplied);
    		System.Debug('Valid? = ' + IADPromoCodeService_Ltng.promoCodeValue);
    	}
    	catch(IADException theException) {
        	System.Debug('theException: ' + theException.getMessage());
        	IADServiceBase_ltng.populateErrorMessage(theException);
            IADPromoCodeService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException) {
        	System.Debug('theException2: ' + theException.getMessage());
            IADServiceBase_ltng.populateErrorMessage(theException);
        	IADPromoCodeService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        return promoCodeService;
    }
    
    @AuraEnabled
    public static IADPromoCodeService_Ltng checkPromoCode(String orderId , String promoCode) {
        system.debug('OrderId: '+orderId);
        system.debug('promocode: '+promoCode);
    	try 
        {
    		promoCodeService = new IADPromoCodeService_Ltng();

    		IADServiceBase_ltng.initWrapper(IADPromoCodeService_Ltng.GETVALIDATEPROMOCODEBYORDERID);
    		IADPromoCodeService_Ltng.checkPromoCode(orderId, promoCode);
    		System.Debug('Valid? = ' + IADPromoCodeService_Ltng.isPromoCodeValid);
    		System.Debug('Valid? = ' + IADPromoCodeService_Ltng.promoCodeValue);
    	}
    	catch(IADException theException) {
        	System.Debug('theException: ' + theException.getMessage());
        	IADServiceBase_ltng.populateErrorMessage(theException);
            IADPromoCodeService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException) {
        	System.Debug('theException2: ' + theException.getMessage());
        	IADServiceBase_ltng.populateErrorMessage(theException);
            IADPromoCodeService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('promoCodeService');
        system.debug(promoCodeService);
        return promoCodeService;
    }
    
    @AuraEnabled
    public static IADPromoCodeService_Ltng displayPromoCode(String orderId) {
    	promoCodeService = new IADPromoCodeService_Ltng();

    	try {
    		IADServiceBase_ltng.initWrapper(IADPromoCodeService_Ltng.GETPROMOCODESBYORDERID);
    		IADPromoCodeService_Ltng.displayPromoCode(orderId);
    		System.Debug('currentPromoCode? = ' + IADPromoCodeService_Ltng.currentPromoCode);
    		System.Debug('currentAmount? = ' + IADPromoCodeService_Ltng.currentAmount);
    		System.Debug('hasPromoCode? = ' + IADPromoCodeService_Ltng.hasPromoCode);
    	}
    	catch(IADException theException) {
        	System.Debug('theException: ' + theException.getMessage());
        	IADServiceBase_ltng.populateErrorMessage(theException);
            IADPromoCodeService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException) {
        	System.Debug('theException2: ' + theException.getMessage());
        	IADServiceBase_ltng.populateErrorMessage(theException);
            IADPromoCodeService_Ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        return promoCodeService;
    }
}