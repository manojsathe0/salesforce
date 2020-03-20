global class OrderItemMatchingBatch implements Database.Batchable<sObject>
{ 
   String Query;
   
   global OrderItemMatchingBatch(String timeFrame)
   {
      String theQuery;
      Set<Id> conIdSet = new Set<Id>();
      //List<Contact> contList = [select id,name,(SELECT ID, Agent__c , Activity_Created_By__c , Activity_Created_DateTime__c ,Order__c, Contact__c FROM Order_Matching_Activities__r Where Activity_Commission_Eligible__c = true and createdDate >= last_90_days) from contact where id in (select contact__c from Order__c where createdDate >= last_90_days)];
      List<Order_matching_activity__c> omList = [SELECT ID, Agent__c , Activity_Created_By__c , Activity_Created_DateTime__c ,Order__c, Contact__c,Contact__r.name FROM Order_Matching_Activity__c Where Activity_Commission_Eligible__c = true and contact__c != null and createdDate >= this_month];
      //if(!conIdSet.isEmpty()){
        // theQuery = 'select id,Is_First_Subscription_Renewal__c,Parent_Commission_Ignore__c,Parent__c,Order__c,LZ_Order_Item_Id__c from Order_Item__c where Order__r.Contact__c in :conIdSet';
      //}
      theQuery = 'SELECT ID, Agent__c , Activity_Created_By__c , Activity_Created_DateTime__c ,Order__c, Contact__c,Contact__r.name FROM Order_Matching_Activity__c Where Activity_Commission_Eligible__c = true and contact__c != null and createdDate >= '+timeFrame;
      System.debug('query #### '+theQuery);
       Query= theQuery;
   }
   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      return Database.getQueryLocator(query);
   }
        
   global void execute(Database.BatchableContext info, List<sObject> scope)
   {
      List<Order_matching_activity__c> orderMatchAct = new List<Order_matching_activity__C>((List<Order_matching_activity__C>)scope);
      Set<Id> conIdSet = new Set<Id>();
      for(Order_Matching_Activity__c oma : orderMatchAct){
         conIdSet.add(oma.contact__c);
      }
      List<Id> conIdList = new List<Id>(conIdSet);
      System.debug('conidset size ### '+conIdSet.size());
      List<Order_Item__c> orderItems = new List<Order_Item__c>();
      orderItems = [select id,Is_First_Subscription_Renewal__c,Parent_Commission_Ignore__c,Parent__c,Order__c,LZ_Order_Item_Id__c from Order_Item__c where Order__r.Contact__c in :conIdList];
      OrderItemMatcher theOrderItemmatcher = new OrderItemMatcher();
      theOrderItemmatcher.processOrderItemsForCommission(orderItems );
   }     
   
   global void finish(Database.BatchableContext info)
   {     
        System.debug('Am I done?');
   } 
}