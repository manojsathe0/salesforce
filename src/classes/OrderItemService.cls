public with sharing class OrderItemService 
{
  final static String RENEWAL = 'Renewal';
  static Set<String> RELATIONSHIPTYPE_FOR_UOE_MATCHING = new Set<String>{'Package', 'SubscriptionUsage','Revision'};
  public static void populateOrderItemLookUp(List<Order_Item__c> orderItems)
  {

      Set<String> lzParentOrderItemIds = new Set<String>();
      for(Order_Item__c theItem : orderItems)
      {

          if(theItem.LZ_Parent_Order_Item_Id__c != null && theItem.LZ_Order_Item_ID__c != null)
          {
              lzParentOrderItemIds.add(theItem.LZ_Parent_Order_Item_Id__c);
          }
      }
      List<Order_Item__c> queriedOrderItems = new List<Order_Item__c>();
      if(!lzParentOrderItemIds.isEmpty())
          queriedOrderItems = [SELECT Id, LZ_Order_Item_ID__c  FROM Order_Item__c  WHERE LZ_Order_Item_ID__c IN :lzParentOrderItemIds];
      Map<String,Id> lzItemIdToSFDCId = new Map<String,Id>();

      for(Order_Item__c theItem : queriedOrderItems)
      {
        lzItemIdToSFDCId.put(theItem.LZ_Order_Item_ID__c, theItem.Id);
      }
      for(Order_Item__c theItem : orderItems)
      {
        if(theItem.LZ_Parent_Order_Item_Id__c != null && lzItemIdToSFDCId.containsKey(theItem.LZ_Parent_Order_Item_Id__c))
        {
          theItem.Parent__c = lzItemIdToSFDCId.get(theItem.LZ_Parent_Order_Item_Id__c);
        }
      }
  }
   
  
  public static void associateOrderMatchingWithOrderItem(List<Order_Item__c> orderItems)
  {
    Set<String> lzOrderItemIds = new Set<String>();
    Map<Id,List<Order_Item__c>> orderIdToListOfOrderItems = new Map<Id,List<Order_Item__c>>();
    for(Order_Item__c theItem : orderItems)
    {
      if(theItem.Order__c != null)
      {
          if(!orderIdToListOfOrderItems.containsKey(theItem.Order__c))
          {
            orderIdToListOfOrderItems.put(theItem.Order__c, new List<Order_Item__c>());
          }
          orderIdToListOfOrderItems.get(theItem.Order__c).add(theItem); 
      }
      if(theItem.LZ_Order_Item_ID__c != null)
        lzOrderItemIds.add(theItem.LZ_Order_Item_ID__c);  
    }
   
    Map<Id,Order__c> allOrders = new Map<Id,Order__c>([SELECT Id, 
                                                        (SELECT Id FROM OrderLeadOpportunitys__r) 
                                                       FROM Order__c 
                                                       WHERE Id IN :orderIdToListOfOrderItems.keySet()]);
    Savepoint sp = Database.setSavepoint();
    try
    {
       
        if(!lzOrderItemIds.isEmpty())
            delete [SELECT Id FROM Order360__c WHERE LZ_Order_Item_Id__c IN :lzOrderItemIds AND Parent_Order_Item__c = null AND  New_Logic__c = false];
       
        List<Order360__c> order360ToCreate = new List<Order360__c>();
        for(Order__c theOrder : allOrders.values())
        {
            List<Order_Item__c> orderItemsPerOrder = orderIdToListOfOrderItems.get(theOrder.Id);
            for(Order_Item__c theItem : orderItemsPerOrder)
            {
                for(Order_Matching_Activity__c matchingActivity : theOrder.OrderLeadOpportunitys__r)
                {
                    order360ToCreate.add(new Order360__c(LZ_Order_Item_Id__c = theItem.LZ_Order_Item_ID__c, 
                                                         Order_Item__c = theItem.Id, 
                                                         Order_Matching_Activity__c = matchingActivity.Id, 
                                                         Order__c = theOrder.Id));
                }
            }
        }
        system.debug(order360ToCreate);
        insert order360ToCreate;
    }
    catch(DMLException dmlEx)
    {
        sendEmailMessage(dmlEx, 'Failed Creating Order360 records');
        Database.rollback(sp);
    }
    
  }
  
  public static void removeOrderItemAndOrder360Records(List<Order_Item__c> orderItems)
  {
    List<Dummy_Order_For_OrderItem__c> dummyOrderName = Dummy_Order_For_OrderItem__c.getAll().values();
    String orderName = '';
    if(!dummyOrderName.isEmpty())
    {
        orderName = dummyOrderName[0].Name;
    }
    List<Order__c> dummyOrders = new List<Order__c>();
    if(orderName != '')
        dummyOrders = [SELECT Id FROM Order__c WHERE Name = :orderName];
    Id dummyOrderId;
    if(!dummyOrders.isEmpty())
    {
        dummyOrderId = dummyOrders[0].Id;
    }
    Map<Id,Order_Item__c> orderItemsToDelete = new Map<Id,Order_Item__c>();
    for(Order_Item__c theItem : orderItems)
    {
        if(theItem.Order__c == dummyOrderId)
        {
            orderItemsToDelete.put(theItem.Id, theItem);
        }
    }
    if(!orderItemsToDelete.isEmpty())
    {
        for(List<Order360__c> order360s : [SELECT Id FROM Order360__c WHERE Order_Item__c IN :orderItemsToDelete.keySet()]) //retrieves 200 at a time
        {
            for(Order360__c the360Record : order360s)
            {
                the360Record.Order__c = dummyOrderId;
            }       
            update order360s;//this handles the batch as salesforce batches each list to 200.So, DML inside loop is fine here
        }
    }
    
    if(!orderItemsToDelete.isEmpty())
    {
        removeOrderItems(orderItemsToDelete.keySet());
    }
  }
  
  
  public static void removeOrderItems(Set<Id> orderItemIds)
  {
    if(!orderItemIds.isEmpty())
    {
        delete [SELECT Id FROM Order360__c WHERE Order_Item__c IN :orderItemIds];
        delete [SELECT Id FROM Order_Item__c WHERE Id IN :orderItemIds];
    }  
  }
  
  public static void sendEmailMessage(DMLException dmlEx, String displayMessage)
  {
       Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {'salesforceteam@legalzoom.com'};
       mail.setToAddresses(toAddresses);
       mail.setSenderDisplayName(displayMessage);
       mail.setSubject('Error from Org : ' + UserInfo.getOrganizationName());
       String errorMessage = '';
       for(Integer i =0;i<dmlEx.getNumDml();++i)
       {
         errorMessage += dmlEx.getDmlMessage(i)+'---';
         errorMessage += 'Id of the record causing error '+ dmlEx.getDmlId(i)+'----';
         errorMessage += 'Field causing error -> ';
         String fieldNames = '';
         for(String fieldName : dmlEx.getDmlFieldNames(i))
         {
           fieldNames += fieldName+',';
         }
         errorMessage += fieldNames;
       }
       mail.setPlainTextBody(errorMessage);
       
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
   }
  
    
    
    //this method populates the UserOrderExtensionLookUp on the Order before update if the User order Extension look up on Order Item is populated
    public static void populateUserOrderExtensionLookUpOnOrderOnInsert(List<Order_Item__c> newOrderItems)
    {
        Map<Id,Order__c> ordersToUpdate = new Map<Id,Order__c>();
        
        for(Order_Item__c theItem : [SELECT Id , User_Order_Extension__r.Entity_Name__c , User_Order_Extension__c , Relationship_Type_Text__c ,Order__c FROM Order_Item__c WHERE Id IN :newOrderItems])
        {
            if(theItem.User_Order_Extension__c != null && RELATIONSHIPTYPE_FOR_UOE_MATCHING.contains(theItem.Relationship_Type_Text__c))
            {
                ordersToUpdate.put(theItem.Order__c, new Order__c(Id = theItem.Order__c, User_Order_Extension__c = theItem.User_Order_Extension__c , Entity_Name__c = theItem.User_Order_Extension__r.Entity_Name__c));
            }
        }
        if(!ordersToUpdate.isEmpty())
        {
            update ordersToUpdate.values();
        }       
    }
    
    public static void populateUserOrderExtensionLookUpOnOrderOnUpdate(List<Order_Item__c> newOrderItems)
    {
        List<Order_Item__c> orderItemsToConsider = new List<Order_Item__c>();
        Set<Id> orderIds = new Set<Id>();
        for(Order_Item__c theItem : newOrderItems)
        {
            if(theItem.Order__r.User_Order_Extension__c ==null) //Padma @B-37842
            
          orderIds.add(theItem.Order__c);
        }

        if(!orderIds.isEmpty()){
        Map<Id,Order__c> orders = new Map<Id,Order__c>([SELECT Id , Entity_Name__c FROM Order__c WHERE Id IN :orderIds]);
        
        for(Order_Item__c newItem : [SELECT Id , User_Order_Extension__r.Entity_Name__c , User_Order_Extension__c ,Order__c ,Relationship_Type_Text__c FROM Order_Item__c WHERE Id IN :newOrderItems])
        {
            String orderEntityName = orders.get(newItem.Order__c).Entity_Name__c;

            if(newItem.User_Order_Extension__c != null && newItem.User_Order_Extension__r.Entity_Name__c != orderEntityName)
            {
                orderItemsToConsider.add(newItem);
            }
        }
        if(!orderItemsToConsider.isEmpty())
        {
            Map<Id,Order__c> ordersToUpdate = new Map<Id,Order__c>();
            for(Order_Item__c theItem : orderItemsToConsider)
            {
                if(theItem.User_Order_Extension__c != null && RELATIONSHIPTYPE_FOR_UOE_MATCHING.contains(theItem.Relationship_Type_Text__c))
                {
                    ordersToUpdate.put(theItem.Order__c, new Order__c(Id = theItem.Order__c, User_Order_Extension__c = theItem.User_Order_Extension__c , Entity_Name__c = theItem.User_Order_Extension__r.Entity_Name__c));
                }
            }
            if(!ordersToUpdate.isEmpty())
            {
                update ordersToUpdate.values();
            }
        }       
    }
    
    }
    
    public static void populatePackageOrderItemsAndLzOrderItems(Order_Item__c[] newOrderItems, Order_Item__c[] packageOrderItems, Set<String> lzOrderItems)
    {
        for(Order_Item__c theItem : newOrderItems)
        {
            if(theItem.LZ_Order_Item_ID__c != null && RELATIONSHIPTYPE_FOR_UOE_MATCHING.contains(theItem.Relationship_Type_Text__c))
            {
                packageOrderItems.add(theItem);
                lzOrderItems.add(theItem.LZ_Order_Item_ID__c);
            }
        }
    }
    
        
    //this method populates the UserOrderExtensionLookUp on the OrderItem before insert
    public static void populateUserOrderExtensionLookUpOnOrderItem(List<Order_Item__c> newOrderItems)
    {
        List<Order_Item__c> packageOrderItems = new List<Order_Item__c>();
        Set<String> lzOrderItems = new Set<String>();
        populatePackageOrderItemsAndLzOrderItems(newOrderItems, packageOrderItems, lzOrderItems);
        
        if(!lzOrderItems.isEmpty())
        {
            Map<String,Id> lzOrderItemToUserOrderExtensionId = new Map<String,Id>();
        
            for(User_Order_Extension__c theExtension : [SELECT Id,LZ_Order_Item_ID__c FROM User_Order_Extension__c WHERE LZ_Order_Item_ID__c 
                                                            IN :lzOrderItems])
            {
                if(theExtension.LZ_Order_Item_ID__c != null)
                    lzOrderItemToUserOrderExtensionId.put(theExtension.LZ_Order_Item_ID__c, theExtension.Id);
            }   
            for(Order_Item__c theOrderItem : packageOrderItems)
            {
                if(lzOrderItemToUserOrderExtensionId.containsKey(theOrderItem.LZ_Order_Item_ID__c))
                {
                    theOrderItem.User_Order_Extension__c = lzOrderItemToUserOrderExtensionId.get(theOrderItem.LZ_Order_Item_ID__c);
                }
            }
                
        }
        
    }
    
    public static void processForCampaigns(Set<Id> orderItemIds)
    {
       CampaignFutureHandler.addCampaignMemberForPostPurchase(orderItemIds);
    }   
    
     public static void populateOrderItemLookUpForSubscriptionSaveActiveRevenue(List<Order_Item__c> orderItems)
     {
     List<Id> renewalItems = new List<Id>();
     Map<Id,Order_Item__c> parentIdToChildId = new Map<Id,Order_Item__c>();
     for(Order_Item__c renewalItem : [SELECT Id ,Parent__c,LZ_Order_Item_Id__c  FROM Order_Item__c WHERE Id IN :orderItems AND Relationship_Type_Text__c = 'Renewal'])
     {
        if(renewalItem.Parent__c != null)
        {
            parentIdToChildId.put(renewalItem.Parent__c , renewalItem);
        }
     }
     System.debug('ParentIdToChild '+parentIdToChildId);
     List<Order360__c> activeRevenues = [SELECT Id , Order_Item__c, Parent_Order_Item__c FROM Order360__c WHERE Parent_Order_Item__c IN :parentIdToChildId.keySet()];
     Map<Id,List<Order360__c>> parentIdToActiveRevenues = new Map<Id,List<Order360__c>>();

     for(Order360__c theActiveRevenue : activeRevenues)
     {
        if(theActiveRevenue.Order_Item__c == null)
        {
          if(!parentIdToActiveRevenues.containsKey(theActiveRevenue.Parent_Order_Item__c))
              parentIdToActiveRevenues.put(theActiveRevenue.Parent_Order_Item__c , new List<Order360__c>());
          parentIdToActiveRevenues.get(theActiveRevenue.Parent_Order_Item__c).add(theActiveRevenue);
        }
     }
     
     System.debug('ParentIdToActiveRevenue '+parentIdToActiveRevenues);
     List<Order360__c> activeRevenuesToUpdate = new List<Order360__c>();
     for(Id parentId : parentIdToChildId.keySet())
     {
       if(parentIdToActiveRevenues.containsKey(parentId))
       {
          for(Order360__c theActiveRevenue : parentIdToActiveRevenues.get(parentId))
          {
              theActiveRevenue.Order_Item__c = parentIdToChildId.get(parentId).Id;
              if(parentIdToChildId.get(parentId).LZ_Order_Item_Id__c != null)
                  theActiveRevenue.LZ_Order_Item_Id__c = parentIdToChildId.get(parentId).LZ_Order_Item_Id__c;
              activeRevenuesToUpdate.add(theActiveRevenue);
          }
       }
     }
    System.debug('To Update '+activeRevenuesToUpdate);
     if(!activeRevenuesToUpdate.isEmpty())
     {
          try
          {
            update activeRevenuesToUpdate;
          }
          catch(DMLException dmlEx)
          {
              SendExceptionEmail.sendDMLExceptionEmail(dmlEx , 'Error associating Order360-Subscription with Renewal Item');
          }
    }
  }

  public static void markFirstSubscriptionRenewalOrderItem(List<Order_Item__c> childOrderItems)
  {
      Map<Id,List<Order_Item__c>> parentOrderItemIdToChildItems = new Map<Id,List<Order_Item__c>>();
      for(Order_Item__c theItem : childOrderItems)
      {
          if(theItem.Parent__c != null && theItem.Relationship_Type_Text__c == 'Renewal')
          {
              if(!parentOrderItemIdToChildItems.containsKey(theItem.Parent__c))
                parentOrderItemIdToChildItems.put(theItem.Parent__c , new List<Order_Item__c>());
              parentOrderItemIdToChildItems.get(theItem.Parent__c).add(theItem);
          }
      }
      if(!parentOrderItemIdToChildItems.isEmpty())
      {
          for(Order_Item__c parentOrderItem : [SELECT Id ,LZ_Order_Item_ID__c,Commission_Ignore__c ,  (SELECT Id FROM Order_Items__r WHERE Relationship_Type_Text__c = 'Renewal') FROM Order_Item__c WHERE Id IN :parentOrderItemIdToChildItems.keySet()])
          {
             if(parentOrderItem.Order_Items__r.isEmpty())
             {
                 if(!parentOrderItemIdToChildItems.get(parentOrderItem.Id).isEmpty())
                 {
                     parentOrderItemIdToChildItems.get(parentOrderItem.Id)[0].Is_First_Subscription_Renewal__c = true;
                 }       
             }
          }
      }
  }
}