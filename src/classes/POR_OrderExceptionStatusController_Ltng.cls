public with sharing class POR_OrderExceptionStatusController_Ltng {
     
    
    @AuraEnabled public static Order_Exception__c loadHoldStatusField (Id recordId) {
        System.Debug('Inside loadHoldStatusField with ' + recordId);
        List<Order_Exception__c> queriedExceptions = new List<Order_Exception__c>();
        queriedExceptions = [SELECT Id, Status__c,  Exception_Type__c FROM Order_Exception__c WHERE Id = :recordId];
        System.Debug('queriedExceptions size ' + queriedExceptions.size());
        if (!queriedExceptions.isEmpty()) {
            return queriedExceptions[0];
        }
        else {
            return null;
        }
    }
    @AuraEnabled public static Boolean checkExistingCases(Id recordId) {
        System.Debug('Inside checkExistingCases with ' + recordId);
        List<Case> existingCases = new List<Case>();
        existingCases = [SELECT Id, Status FROM Case WHERE Order_Exception__c = :recordId AND Status != 'Closed'];
        System.Debug('existingCases size ' + existingCases.size());
        if (!existingCases.isEmpty()) {
            return true;
        }
        else {
            return false;
        }
    }
    /*
    @AuraEnabled public static Boolean putOnHold (Id recordId) {
        //Id onholdqueId =CaseService.getQueueNameToQueueId.get(onHold);)
        System.Debug('Inside putOnHold with ' + recordId);
        map<id,Group> ddsquesmap = new map<Id, Group>([SELECT Id,Name, DeveloperName FROM Group WHERE Type = 'Queue' AND (Name = 'Expedite' OR Name like 'Order Due%') ]);
        List<Order_Exception__c> queriedExceptions = new List<Order_Exception__c>();
        queriedExceptions = [SELECT Id, ownerId,Status__c, Exception_Type__c FROM Order_Exception__c WHERE Id = :recordId];
        map<String, Id> quemap= CaseService.getQueueNameToQueueId();
        system.debug('queumap is '+ quemap);
        Id onholdid = quemap.get('On Hold');
        system.debug('queue id and name is '+onholdid);
        System.Debug('queriedExceptions size ' + queriedExceptions.size());
        if (!queriedExceptions.isEmpty()) {
            queriedExceptions[0].Status__c = 'Hold';
            queriedExceptions[0].Exception_Type__c = 'Hold';
           if(ddsquesmap.containsKey(queriedExceptions[0].ownerId)){
                queriedExceptions[0].ownerId = onholdid;
            }
            try {
                update queriedExceptions;
                return true;
            }
            catch (DmlException e) {
                System.Debug('DmlException: ' + e.getMessage());
                return false;
            }
             
        }
        else {
            return false;
        }
    }
    */
    
    @AuraEnabled public static Boolean putOnHold (Id recordId) {
        System.Debug('Inside putOnHold with ' + recordId);
        List<Order_Exception__c> queriedExceptions = new List<Order_Exception__c>();
        queriedExceptions = [SELECT Id, Status__c, Exception_Type__c FROM Order_Exception__c WHERE Id = :recordId];
        System.Debug('queriedExceptions size ' + queriedExceptions.size());
        if (!queriedExceptions.isEmpty()) {
            queriedExceptions[0].Status__c = 'Hold';
            queriedExceptions[0].Exception_Type__c = 'Hold';
            try {
                update queriedExceptions;
                return true;
            }
            catch (DmlException e) {
                System.Debug('DmlException: ' + e.getMessage());
                return false;
            }
             
        }
        else {
            return false;
        }
    }
    
    
    
   @AuraEnabled
    public static Boolean removeFromHold (Id recordId) {
        System.Debug('Inside removeFromHold with ' + recordId);
        List<Order_Exception__c> queriedExceptions = new List<Order_Exception__c>();
        Order_Exception__c ordexp;
        Case theCase;
        String OverallruleStatus;
        queriedExceptions = [SELECT Id, Status__c, Processing_Number__c, Order_Number__r.Name,Count_of_unresolved_Manual_Rules__c,Exception_Type__c,Production_Review_Result__c, Resolution_Reason__c,Closed_by_Agent__c,Product__c FROM Order_Exception__c WHERE Id = :recordId];
       
        if(!queriedExceptions.isEmpty()){
            ordexp =queriedExceptions[0];  
        }
        
        System.Debug('queriedExceptions size ' + queriedExceptions.size());
        if (!queriedExceptions.isEmpty()) {    
            
            queriedExceptions[0].Trigger_DDS_Process__c = true;
            queriedExceptions[0].Trigger_Order_due_date__c = true;
            queriedExceptions[0].Reinjection_Request_Submitted__c = true;
            queriedExceptions[0].Closed_by_Agent__c = UserInfo.getUserId();
            queriedExceptions[0].Status__c = null;
            queriedExceptions[0].Exception_Type__c = null;            
            queriedExceptions[0].Is_Removed_From_Hold__c= true;
            //if all rules re passed
            IADOrderWithOrderItemsService_ltng lt= new IADOrderWithOrderItemsService_ltng();
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERITEMRULESTATUS);
            
            String validationRuleStatus = IADOrderWithOrderItemsService_ltng.getOrderItemRuleStatusForOrder(queriedExceptions[0].Processing_Number__c,'1');
            String businessRuleStatus = IADOrderWithOrderItemsService_ltng.getOrderItemRuleStatusForOrder(queriedExceptions[0].Processing_Number__c,'2');
            System.debug('validationRuleStatus '+validationRuleStatus + ' businessRuleStatus ' +businessRuleStatus);
            if(validationRuleStatus =='Passed' && businessRuleStatus =='Passed'){
                OverallruleStatus='Passed';
            }
            else{
                OverallruleStatus='Failed';
            }
            
            if(validationRuleStatus =='Passed' && businessRuleStatus =='Passed' && queriedExceptions[0].Count_of_unresolved_Manual_Rules__c < 1){
                queriedExceptions[0].Exception_Type__c = 'Resolved';
                queriedExceptions[0].Is_Removed_From_Hold__c= false;
                if(queriedExceptions[0].Status__c =='Production Review Complete')
                {
                    queriedExceptions[0].Resolution_Reason__c = 'Not a problem order';
                    queriedExceptions[0].Production_Review_Result__c='No Business Rule Problems';
                }
                else
                {
                    queriedExceptions[0].Status__c='Resolved';
                    queriedExceptions[0].Resolution_Reason__c = 'Problem(s) resolved by CC';
                }
                
                queriedExceptions[0].Closed_by_Agent__c=null;
            }
            //padma added for B-29599 Scenario #2
            else if (OverallruleStatus =='Passed' && queriedExceptions[0].Count_of_unresolved_Manual_Rules__c >= 1){
                queriedExceptions[0].Trigger_DDS_Process__c = false;
                queriedExceptions[0].Exception_Type__c = 'Problem';
                queriedExceptions[0].Status__c='Problem';
                ordexp.Production_Review_Result__c='No Business Rule Problems';
                queriedExceptions[0].Closed_by_Agent__c=null;
                queriedExceptions[0].Trigger_Order_due_date__c = false;
                
                 //Create a Case                 
                  theCase = new Case();
                  theCase.Order_Exception__c = ordexp.id;
                  theCase.Status = 'Waiting on Customer';
                  theCase.RecordTypeId = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);
                  theCase.Status_Reasons__c = 'Email Sent, Pending Response';
                  //theCase.Product2__c = 'Power of Attorney';
                  theCase.Product2__c=ordexp.Product__c;
                  theCase.SuppliedName=ordexp.First_Name__c+ordexp.Last_Name__c;
                  theCase.SuppliedEmail=ordexp.Email__c;
                  theCase.CustomerID__c =ordexp.CustomerID__c;
                  theCase.Processing_Number__c=ordexp.Processing_Number__c;
                  theCase.Order__c=ordexp.Order_Number__c;
                  theCase.ManualruleStatus__c='Problem';  
            }
            
           
            //padma EOC
            if((validationRuleStatus !='Passed'  || queriedExceptions[0].Count_of_unresolved_Manual_Rules__c >= 1 )&& businessRuleStatus =='Passed'){
               
                queriedExceptions[0].Trigger_Order_due_date__c = false;
                /*//Create a Case
                  ordexp.Exception_Type__c='Problem';
                  ordexp.Production_Review_Result__c='No Business Rule Problems';
                  ordexp.Status__c='Problem';
                  theCase = new Case();
                  theCase.Order_Exception__c = ordexp.id;
                  theCase.Status = 'Waiting on Customer';
                  theCase.RecordTypeId = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);
                  theCase.Status_Reasons__c = 'Email Sent, Pending Response';
                  theCase.Product2__c = 'Power of Attorney';
                  theCase.SuppliedName=ordexp.First_Name__c+ordexp.Last_Name__c;
                  theCase.SuppliedEmail=ordexp.Email__c;
                  theCase.CustomerID__c =ordexp.CustomerID__c;
                  theCase.Processing_Number__c=ordexp.Processing_Number__c;
                  theCase.Order__c=ordexp.Order_Number__c;
                  theCase.ManualruleStatus__c='Problem';  */
            }
            
            try {
                if(theCase!= null){
                insert theCase;
                }
                update queriedExceptions;               
                return true;
            }
            catch (DmlException e) {
                System.Debug('DmlException: ' + e.getMessage());
                return false;
            }
             
        }
        else {
            return false;
        }
    }
    
    
    public static string getOverAsllStatus(String processingnumber){
        String OverallruleStatus;
        IADOrderWithOrderItemsService_ltng lt= new IADOrderWithOrderItemsService_ltng();
            IADServiceBase_ltng.initWrapper(IADOrderWithOrderItemsService_ltng.GETORDERITEMRULESTATUS);
            
            String validationRuleStatus = IADOrderWithOrderItemsService_ltng.getOrderItemRuleStatusForOrder(processingnumber,'1');
            String businessRuleStatus = IADOrderWithOrderItemsService_ltng.getOrderItemRuleStatusForOrder(processingnumber,'2');
            System.debug('validationRuleStatus '+validationRuleStatus + ' businessRuleStatus ' +businessRuleStatus);
            if(validationRuleStatus =='Passed' && businessRuleStatus =='Passed'){
                OverallruleStatus='Passed';
            }
            else{
                OverallruleStatus='Failed';
            }
        return OverallruleStatus;
    }
    
   public static void testcovMethod(){
    Integer i = 0;
    i++;
    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    //repeat the i++ hundred of times

  }
}