trigger Order_Item on Order_Item__c (before insert , before update , after insert , before delete , after update) 
{
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        OrderItemService.populateOrderItemLookUp(Trigger.new);
        if(Trigger.isInsert)
        {
            OrderItemService.markFirstSubscriptionRenewalOrderItem(Trigger.new);
        }
         //Padma updated @  B-37842
        List<Order_Item__c> OTList = new List<Order_Item__c>();
        for (Order_Item__c OT: Trigger.new){
            if(OT.User_Order_Extension__c == null  ){
            	
            	 OTList.add(OT);
                 
            }
        }
        OrderItemService.populateUserOrderExtensionLookUpOnOrderItem(OTList);
    }
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        
        OrderItemService.populateUserOrderExtensionLookUpOnOrderOnInsert(Trigger.new);
         if(Test.isRunningTest())
        {
            OrderItemService.associateOrderMatchingWithOrderItem(Trigger.new);
        }
       
        
        ProblemOrderRoutingService.closeRelatedOpenCasesForRevisedOrder(Trigger.new);
        OrderItemMatcher theOrderItemmatcher = new OrderItemMatcher();
        theOrderItemmatcher.processOrderItemsForCommission(Trigger.new);
        OrderItemService.populateOrderItemLookUpForSubscriptionSaveActiveRevenue(Trigger.new);
        OrderItemService.processForCampaigns(Trigger.newMap.keySet());
    }
    
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)) {
         OrderItemService.removeOrderItemAndOrder360Records(Trigger.new);
    	OrderItemService.populateUserOrderExtensionLookUpOnOrderOnUpdate(Trigger.new);//Padma updated @  B-37842
        
    }
       
    
}