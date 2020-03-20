public class IADDiscountController_Ltng {
    @AuraEnabled public static IADDiscountService_Ltng discountService{get;set;}
	@AuraEnabled public static IADOrderWithOrderItemsService_ltng  orderService{get;set;}
    @AuraEnabled public static IADOrderWithOrderItemsController_ltng ctrlRef {get;set;}
    @AuraEnabled public static List<IADMessage_ltng> iadServiceMessages{get;set;}
    
    @AuraEnabled
    public static Map<Integer,String> discountReasonMap
    {
        get{
            discountReasonMap = new Map<Integer,String>();
            discountReasonMap.put(1,'Customer Satisfaction');
            discountReasonMap.put(2,'Subscription Cancellation');
            discountReasonMap.put(3,'Customer Overcharged');
            discountReasonMap.put(4,'Change to Order');
            discountReasonMap.put(9,'Managed Plan Adjustment');
            return discountReasonMap;
        }
        set;
    }     
    
    @AuraEnabled
    public static IADDiscountController_Ltng applyOrderDiscount(String orderId, String discountAmount, String comments, Integer discountReason, String approvedBy) {
    	System.Debug('Arguments: ' + orderId + ' ' + discountAmount + ' ' + comments  + ' ' + discountReason + ' ' + approvedBy);
    	IADDiscountService_Ltng.isDiscountSuccess = false;
        IADDiscountService_Ltng discountService = new IADDiscountService_Ltng();
    	IADDiscountController_Ltng ctrlRef = new IADDiscountController_Ltng();
    	try {
    		IADServiceBase_ltng.initWrapper(IADDiscountService_Ltng.POSTORDERSORDERDISCOUNTS);
    		IADDiscountService_Ltng.applyOrderDiscounts(orderId, discountAmount, comments, discountReason, approvedBy);
    	}
        catch(IADException theException) {
        	System.Debug('theException: ' + theException.getMessage());
        	IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException) {
        	System.Debug('theException2: ' + theException.getMessage());
        	IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        system.debug('controller ref: '+ctrlRef);
        return ctrlRef;
    }    
    
    @AuraEnabled
    public static IADDiscountController_Ltng getExistingDiscounts(String orderId) {
    	System.Debug('Inaside getExistingDiscounts: ' + orderId);
    	IADDiscountController_Ltng ctrlRef = new IADDiscountController_Ltng();
        discountService = new IADDiscountService_Ltng();
    	orderService = new IADOrderWithOrderItemsService_ltng();
    	
        try {	
    		
    		IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERBALANCESBYORDERID);
    		IADOrderWithOrderItemsService_ltng.getOrderBalanceByOrderId(orderId);
        	
        	System.Debug('theOrderBalance: ' + IADOrderWithOrderItemsService_ltng.theOrderBalance);
            IADDiscountService_Ltng.populateDiscountList(IADOrderWithOrderItemsService_ltng.theOrderBalance);
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    	
    	System.Debug('Result: ' + IADDiscountService_Ltng.discountDetails);
		System.debug('orderService: ');
        System.debug(orderService);
    	//return IADDiscountService_Ltng.discountDetails;
    	return ctrlRef;
    }
    
    @AuraEnabled
    public static IADDiscountController_Ltng cancelDiscount(String orderId, String OrderDiscountId) {
        IADDiscountController_Ltng ctrlRef = new IADDiscountController_Ltng();
        IADDiscountService_Ltng.isDiscountSuccess = false;
    	discountService = new IADDiscountService_Ltng();
        
        try {
    		IADServiceBase_ltng.initWrapper(IADDiscountService_Ltng.POSTCANCELDISCOUNTBYDISCOUNTID);
    		IADDiscountService_Ltng.cancelDiscount(orderId, OrderDiscountId);
    	}
        catch(IADException theException) {
        	System.Debug('theException: ' + theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        catch(Exception theException) {
        	System.Debug('theException2: ' + theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        return ctrlRef;
    }
    
    
//STORY B-41395 - Commented 
    /*
    @AuraEnabled
    public static Boolean isValidateManagerCredential(String usrn, String pwd) {   
        List<Manager_Credential__c> mgrCred = [SELECT Id, User__c, Password__c FROM Manager_Credential__c WHERE User__r.Username =: usrn AND Password__c =: pwd AND User__r.isActive = true];
        if(mgrCred.size() > 0){
            return true; 
        }
        
        return false;
    }
    */
    //STORY B-41395 - Starts Here
    @AuraEnabled
    public static Boolean isValidateManagerCredential(String usrn, String pwd) {
        string currentUserEmail = '';
        string domainAddress = '';
        List<Manager_Credential__c> mgrCred;
        try{
            if(string.isBlank(usrn)||string.isBlank(pwd)){throw new customException('Input Params are Blank');}
            currentUserEmail = UserInfo.getUserEmail();
            domainAddress = currentUserEmail.substring(currentUserEmail.indexOf('@'));
            usrn = usrn.containsIgnoreCase(domainAddress) ? usrn : usrn + domainAddress;
            mgrCred = new List<Manager_Credential__c>();
            mgrCred = [SELECT Id, User__c, Password__c FROM Manager_Credential__c WHERE User__r.Email =: usrn AND Password__c =: pwd AND User__r.isActive = true];
            return mgrCred.size()>0;
        } catch (Exception e){
            system.debug('Exception Message ~~~~> '+e.getMessage() +' <~~~~Exception Line ~~~~> ' +e.getLineNumber() + '<~~~~~ Exception Type ~~~~~> '+ e.getMessage());
            return false;
        }
    }
    @TestVisible private class customException extends Exception {}
    //STORY B-41395 - Ends Here
}