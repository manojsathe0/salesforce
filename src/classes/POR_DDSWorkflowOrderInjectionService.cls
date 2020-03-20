global class POR_DDSWorkflowOrderInjectionService extends IADServiceBase_ltng {
    public final static String DDSORDERCOMPLETE = 'DDSOrderComplete';
    
    @AuraEnabled public static Boolean thereAreErrors{get;set;}
    @AuraEnabled public static String errorMessage{get;set;}
    @AuraEnabled public static String validResponse{get;set;}
    
    @AuraEnabled public static InjectionResponseWrapper responseWrapper{get;set;}
    @AuraEnabled public static String orderNumber{get;set;}
    @AuraEnabled public static String processingNumber{get;set;}
    
    @AuraEnabled public static Boolean relaunchEligible{get;set;}
    
    public POR_DDSWorkflowOrderInjectionService() {
        super();
        List <String> endpoints = new List <String> ();
        endpoints.add(DDSORDERCOMPLETE);
        initEndpoints(endpoints);
        responseWrapper = new InjectionResponseWrapper();
        thereAreErrors = true;
        errorMessage = '';
        validResponse = '';
        relaunchEligible = false;
    }
    public static void injectProcessingNumberIntoDDSFlow(String orderNumber, String processingNumber) {
        System.Debug('Inside injectProcessingNumberIntoDDSFlow');
        //padma added per B-29577
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        POR_DDSContractBeans.OrderComplete orderData = new POR_DDSContractBeans.OrderComplete();
        orderData.requestedBy = UserInfo.getName();
        orderData.processingOrderId = processingNumber;
        POR_PNInjectionButtonController_Ltng rl = new POR_PNInjectionButtonController_Ltng();
          
       /*   if(profileName.containsIgnoreCase('Sales') || POR_PNInjectionButtonController_Ltng.relaunch){
            system.debug('padma inside relaunch');
            orderData.revisionType = 'Unset';
            //InBinDateService_ltng.updateProcessingstatus(processingNumber,'Started');
        }
        else{
            orderData.revisionType = 'MinorRevision';
        }*/
        orderData.revisionType = 'MinorRevision';
        
        String orderDataInJSON;
        try {
            orderDataInJSON = JSON.serialize(orderData);
        }
        catch (JSONException e) {
            System.Debug(e);
            thereAreErrors = true;
            errorMessage = e.getMessage();
        }
        
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(DDSORDERCOMPLETE).endPointConfig.link__c;
        calloutURL = calloutURL.replace('{orderId}', orderNumber);
        IADServiceBase_ltng.APItoWrapper.get(DDSORDERCOMPLETE).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderNumber);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, DDSORDERCOMPLETE, orderDataInJSON);
        populateResponseOnInjectProcessingNumber();
    }
    public static void populateResponseOnInjectProcessingNumber () {
        System.Debug('Inside populateResponseOnInjectProcessingNumber');
        try {
            responseWrapper = new InjectionResponseWrapper();
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(DDSORDERCOMPLETE);
            System.Debug('theResponse: '+ theResponse);
            if(theResponse.checkIsValidResponse() && theResponse.responseData != null) {
                responseWrapper = (InjectionResponseWrapper) JSON.deserialize(theResponse.responseData, InjectionResponseWrapper.class);
                system.debug('responseWrapper.ordersComplete.success-->'+responseWrapper.ordersComplete.success);
                if (responseWrapper.ordersComplete.success == true) {
                    thereAreErrors = false;
                    errorMessage = '';
                    validResponse = theResponse.responseData;
                }
                else {
                    thereAreErrors = true;
                    errorMessage = 'Something went wrong.';
                    validResponse = '';
                }
                    
            }
            else {
                thereAreErrors = true;
                errorMessage = 'Something went wrong. Invalid response!';
                validResponse = '';
            }
        }
        catch (Exception theException) {
            thereAreErrors = true;
            System.Debug('theException.getMessage() = ' + theException.getMessage());
            errorMessage = theException.getMessage();
            validResponse = '';
        }
    }
    public static void checkIfOrderItemRelaunchEligible(String recordId) {
    	System.Debug('In checkIfOrderItemRelaunchable with recordId = ' + recordId);
    	List<Order_Item__c> orderItemList = new List<Order_Item__c>();
    	List<Date_Reference__mdt> releaseDates = new List<Date_Reference__mdt>();
    	try {
        	releaseDates = [SELECT DeveloperName, Product_Name_Aliases__c, Date__c FROM Date_Reference__mdt WHERE DeveloperName LIKE 'DDS%' LIMIT 100];
    		orderItemList = [SELECT Product_Name__c, Processing_Status_Creation_Date__c FROM Order_Item__c WHERE Id = :recordId AND User_Order_ID__c != null LIMIT 1];

    		if (!orderItemList.isEmpty()) {
    			Order_Item__c thisOrderItem = orderItemList[0];
    			for (Date_Reference__mdt rlsDateMtd : releaseDates) {
    				System.debug(thisOrderItem.Product_Name__c);
    				System.debug(thisOrderItem.Processing_Status_Creation_Date__c);
    				
    				List<String> productNameAliasesList = new List<String>();
    				if (String.isNotBlank(rlsDateMtd.Product_Name_Aliases__c)) {
    					productNameAliasesList = rlsDateMtd.Product_Name_Aliases__c.split(';');
    				}
    				if (String.isNotBlank(thisOrderItem.Product_Name__c) && !productNameAliasesList.isEmpty()) {
    					System.debug('productNameAliasesList = ' + productNameAliasesList);
    					for (String nameAlias : productNameAliasesList) {
    						System.debug('nameAlias = ' + nameAlias);
    						if (thisOrderItem.Product_Name__c.contains(nameAlias)) {
    							System.debug('Product match found: ' + nameAlias);
    							if (thisOrderItem.Processing_Status_Creation_Date__c > rlsDateMtd.Date__c) {
    								thereAreErrors = false;
                					errorMessage = '';
    								relaunchEligible = true;
    								System.debug('relaunchEligible is set to ' + relaunchEligible);
    								return;
    							}
    							else {
    								relaunchEligible = false;
    								System.debug('relaunchEligible is set to ' + relaunchEligible);
    							}
    							
    						}
    					}				

    				}
    				
    			}
    		}
    		
    	
    	}
    	catch (Exception e) {
            System.Debug(e);
            thereAreErrors = true;
            errorMessage = e.getMessage();
        }
    }
    public static void getOrderNumberByRecordId(String recordId) {
        System.Debug('recordId = ' + recordId);
        List<Order_Item__c> orderItemList = new List<Order_Item__c>();
        try {
        	orderItemList = [SELECT Id, Order__r.OrderID__c, Product__r.LZ_Process_ID__c , User_Order_ID__c, Processing_Status_Creation_Date__c FROM Order_Item__c WHERE Id = :recordId];
        }
        catch (QueryException e) {
            thereAreErrors = true;
            errorMessage = e.getMessage();
            System.Debug(e);
        }
        if (!orderItemList.isEmpty()) {
            if(orderItemList[0].User_Order_ID__c != null) {
                thereAreErrors = false;
                errorMessage = '';
                orderNumber = orderItemList[0].Order__r.OrderID__c;
                processingNumber = orderItemList[0].User_Order_ID__c;
            }
            else{
                thereAreErrors = true;
                errorMessage = 'There is no processing number to relaunch the order.';
            }
        }
        else {
            thereAreErrors = true;
            errorMessage = 'This action cannot be taken for this processing order number.';
        }
    }
    
    class InjectionResponseWrapper {
        OrdersCompleteWrapper ordersComplete{get;set;}
    }
    
    class OrdersCompleteWrapper {
        Boolean success{get;set;}
    }
        
}