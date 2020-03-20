public class RelatedOrdersController_ltng {
     
    @AuraEnabled public String orderNumber{get;set;}    
    
    @AuraEnabled public Order__c thisOrder {get;set;}
    @AuraEnabled public static RelatedOrdersService_ltng  relatedService{get;set;}
    
    @AuraEnabled public List<Authorized_Contact__c> authorizedContacts{get;set;}
    @AuraEnabled public  String customerId{get;set;}     
    
   
    
    @AuraEnabled public static  RelatedOrdersController_ltng ctrl {get; set;}
    
     
    public static void init(String orderRecordId)
    {
         ctrl = new RelatedOrdersController_ltng();
               
        if(String.isNotBlank(orderRecordId))
        {
            ctrl.thisOrder = [SELECT Id , Name , OrderID__c , Contact__r.FkUser__c,Language_Preferance__c, Order_Date_Time_Created__c, Date_Time_TOS_Accepted__c, TOS_Accepted__c, OrderTerms__c, CreatedBy.Name, LastModifiedBy.Name FROM Order__c WHERE Id = :orderRecordId limit 1][0];
            ctrl.orderNumber = ctrl.thisOrder.Name;
            ctrl.customerId = ctrl.thisOrder.Contact__r.FkUser__c;
            
            
        }
       
        
    }
    
    @AuraEnabled
    public static RelatedOrdersService_ltng getOrderByOrderId(String orderRecordId) 
    {   
        system.debug('orderRecordId: '+orderRecordId);
        
        relatedservice  = new RelatedOrdersService_ltng();
             
        init(orderRecordId);
        relatedservice.customerid=ctrl.customerId;
        
        try
        {   
            IADServiceBase_ltng.initWrapper(RelatedOrdersService_ltng.GETORDERBYORDERID);
            RelatedOrdersService_ltng.getOrderByOrderId(ctrl.orderNumber);            
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in startRequestsInParallel');
            IADServiceBase_ltng.populateErrorMessage(theException);
            RelatedOrdersService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        
       
        return relatedservice;        
    }
    
@AuraEnabled
    public static RelatedOrdersService_ltng getRelatedOrders(String ordergroupid) 
    {   
        
        
        relatedservice  = new RelatedOrdersService_ltng();
        
       
        
        try
        {   
            IADServiceBase_ltng.initWrapper(RelatedOrdersService_ltng.GETRELATEDORDERSBYORDERID);
          RelatedOrdersService_ltng.getRelatedOrders(ordergroupid);            
        }
        catch(Exception theException)
        {
            system.debug('exception thrown in startRequestsInParallel');
            IADServiceBase_ltng.populateErrorMessage(theException);
            RelatedOrdersService_ltng.iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
        
       
        return relatedservice;        
    }
    
}