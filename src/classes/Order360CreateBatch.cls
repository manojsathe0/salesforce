global class Order360CreateBatch implements Database.Batchable<sObject>
{ 
   String Query;
   
   global Order360CreateBatch(String theQuery)
   {
       Query= theQuery;
       
   }
   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      return Database.getQueryLocator(query);
   }
        
   global void execute(Database.BatchableContext info, List<sObject> scope)
   {
     OrderItemService.associateOrderMatchingWithOrderItem((List<Order_Item__c>)scope);       
   }     
   
   global void finish(Database.BatchableContext info)
   {     
        System.debug('Am I done?');
   } 
}