global class POR_PNInjectionButtonController_Ltng {
	@AuraEnabled public static String orderName{get;set;}
	@AuraEnabled public static POR_DDSWorkflowOrderInjectionService responseObject{get;set;}
    public static boolean relaunch;
	@AuraEnabled
	public static POR_DDSWorkflowOrderInjectionService getOrderData(Id recordId) {
		responseObject = new POR_DDSWorkflowOrderInjectionService();
		POR_DDSWorkflowOrderInjectionService.getOrderNumberByRecordId(recordId);
		return responseObject;
	}
    
    @future (callout=true)
    public static void TriggerDDS (String OrderNum, String Procnum) {
        System.Debug('Trigger DDS');
        injectProcessingNumber(OrderNum, Procnum, '');
    }
    @AuraEnabled
    public static POR_DDSWorkflowOrderInjectionService checkIfRelaunchEligible(Id recordId) {
    	responseObject = new POR_DDSWorkflowOrderInjectionService();
		POR_DDSWorkflowOrderInjectionService.checkIfOrderItemRelaunchEligible(recordId);
		return responseObject;
    }
    
    
    @AuraEnabled
    webservice static Boolean injectProcessingNumber(String orderNumber, String processingNumber, String orderItemSFId) { //return type -- > POR_DDSWorkflowOrderInjectionService
    	System.Debug('Inside injectProcessingNumber = ' + orderNumber + ' and ' + processingNumber);
        if(orderItemSFId != '' && orderItemSFId !=null){
            relaunch=true;
        }
        else{
            relaunch=false;
        }
        
    	try {
			responseObject = new POR_DDSWorkflowOrderInjectionService();
			IADServiceBase_ltng.initWrapper(POR_DDSWorkflowOrderInjectionService.DDSORDERCOMPLETE);
	    	POR_DDSWorkflowOrderInjectionService.injectProcessingNumberIntoDDSFlow(orderNumber, processingNumber);
            
            
            //padma added
            IF(orderItemSFId != null && orderItemSFId != ''){
                InBinDateService_ltng.updateProcessingstatus(processingNumber,'Started');
                 if(processingNumber!=null && processingnumber!='' ){
                    List<Order_Exception__c> orderexp = new List<Order_Exception__c>([SELECT  id, Reinjection_Request_Submitted__c, Trigger_Order_due_date__c, Processing_Number__c FROM Order_Exception__c WHERE Processing_Number__c =:processingNumber LIMIT 1]);
                    if(!orderexp.isEmpty()){
                        orderexp[0].Reinjection_Request_Submitted__c = true;
                        String ruleStatus = POR_OrderExceptionStatusController_Ltng.getOverAsllStatus(processingNumber);
                        if(ruleStatus =='Failed'){
                            orderexp[0].Trigger_Order_due_date__c=true;
                        }
                        update orderexp;
                    }
                     //set the order status to started when Relaunch button is clicked by sales for declined orders as they never went through dds
                    /* Id profileId=userinfo.getProfileId();
                     String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
                     if(profileName.containsIgnoreCase('Sales')){
                          InBinDateService_ltng inbindateservice = new InBinDateService_ltng();
                         InBinDateService_ltng.updateProcessingstatus(processingNumber,'Started');
                     }*/
        			
                }
                
            }
            if(!POR_DDSWorkflowOrderInjectionService.thereAreErrors && String.isNotBlank(orderItemSFId)){
                Order_Item__c odrItm = [Select Id, DDS_Triggered_By__c, DDS_Triggered_Time__c From Order_Item__c Where Id =: orderItemSFId];
                odrItm.DDS_Triggered_By__c = UserInfo.getUserId();
                odrItm.DDS_Triggered_Time__c = System.Now();
                
                Update odrItm;
            }
           
            
		}
		catch(Exception theException) {
        	System.Debug('theException: ' + theException.getMessage());
        	//throw new AuraHandledException('From getQuestionnaireVersionsByProcessingNumber: ' + theException.getMessage());
        }
        system.debug('responseObject--->'+responseObject);
        
        return POR_DDSWorkflowOrderInjectionService.thereAreErrors; //return value --> responseObject
    }
    
}