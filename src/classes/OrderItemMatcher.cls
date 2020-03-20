public with sharing class OrderItemMatcher
{
    public Map<Id,List<Order_Item__c>> contactToNewOrderItems = new Map<Id, List<Order_Item__c>>();
    public Map<Id,List<Order_Matching_Activity__c>> contactToListOfOMA = new Map<Id, List<Order_Matching_Activity__c>>();
    public Map<Id,Id> orderIdtoContactId = new Map<Id,Id>();
    public List<Order360__c> order360ToInsert = new List<Order360__c>();

    public final static String RENEWAL = 'Renewal';
    public final static String RBE = 'RB.ConsoleApp';
    public final static String REGISTERED_AGENT = 'Registered Agent';
    public final static String CROSS_SELL = 'Cross-Sell';
    public final static String THE_PACKAGE = 'Package';
    
    public List<Order__c> ordersToUpdate = new List<Order__c>();
    public List<Order_Item__c> otherOrderItems;
    public static DateTime dateRange
    {
        get
        {
            if(dateRange == null)
            {
                if(System.isBatch())
                {
                    List<Rematching_Days__c> rematchingDays = Rematching_Days__c.getall().values();
                    if(!rematchingDays.isEmpty())
                        dateRange = DateTime.now().addDays(Integer.valueOf((rematchingDays[0].Number_of_Days__c)*(-1)));
                }
                else
                    dateRange = DateTime.now().addDays(-91);
            }
            return dateRange;
        }
        set;
    }
      
    public OrderItemMatcher()
    {
        otherOrderItems = new List<Order_Item__c>();//Regular Commission Matching
    }

    public void processOrderItemsForCommission(List<Order_Item__C> newOrderItems)
    {
        
        //If the context is batch
        if(System.isBatch())
        {
            List<Order360__c> order360ToDelete = [SELECT ID FROM Order360__c WHERE Parent_Order_Item__c = null AND Order_Item__c IN: newOrderItems];
            if(!order360ToDelete.isEmpty())
                delete order360ToDelete;
        }

        List<Order_Item__c> firstRenewalOrderItems = new List<Order_Item__c>(); //Renewal Matching
      
        for(Order_Item__C theOrderItem : newOrderItems)
        {
           

            if(theOrderItem.Is_First_Subscription_Renewal__c)
            {
           
                if(theOrderItem.Parent_Commission_Ignore__c)
                {
                    if(theOrderItem.Parent__c != null) 
                        firstRenewalOrderItems.add(theOrderItem);
                }
                else 
                {
                    //Just Ignore
                }
            }
            else 
            {
                otherOrderItems.add(theOrderItem);  
            }
            
        }
      
           
        if(!firstRenewalOrderItems.isEmpty())
        {
            processFirstRenewalOrderItems(firstRenewalOrderItems);        
        }
        if(!otherOrderItems.isEmpty())
        {
            processRegularOrderItems(otherOrderItems);
        }
        
  
        Set<Order__C> salesOrders = new Set<Order__c>();
        for(Order360__c newAR : order360ToInsert)
        {
            Order__c orderToUpdate = new  Order__c(Id = newAR.Order__c);
            orderToUpdate.Is_Sales_Order__c = true;
            salesOrders.add(orderToUpdate);
        }
        ordersToUpdate.addAll(salesOrders);

        System.debug('Order360 '+order360ToInsert);
        try
        {
            system.debug(order360ToInsert);
            if(!order360ToInsert.isEmpty())
                insert order360ToInsert;
            system.debug(order360ToInsert);
            system.debug(ordersToUpdate);
            if(!ordersToUpdate.isEmpty())
                update ordersToUpdate;
             system.debug(ordersToUpdate);
            
        }catch(DmlException exp)
        {
            SendExceptionEmail.sendDMLExceptionEmail(exp, 'Error in Order Item Matching');
        }
    }

    public void processRegularOrderItems(List<Order_Item__c> otherOrderItems)
    {

        Set<Id> orderIds = new Set<Id>();
        for(Order_Item__c theOrderItem : otherOrderItems)
        {
            orderIds.add(theOrderItem.Order__c);
        }
       
        //query orders with all the required information
        List<Order__c> newQueriedOrders = new List<Order__c>();
        if(!orderIds.isEmpty())
            newQueriedOrders = [SELECT Id, Contact__c  FROM Order__c WHERE Id IN :orderIds];
        
      
        for(Order__c theOrder : newQueriedOrders)
        {
            if(theOrder.Contact__c != null)
                orderIdToContactId.put(theOrder.Id , theOrder.Contact__c);
        }

        for(Order_Item__c theOrderItem : otherOrderItems)
        {
          
            if(orderIdtoContactId.containsKey(theOrderItem.Order__c))
            {
                if(!contactToNewOrderItems.containsKey(orderIdtoContactId.get(theOrderItem.Order__c)))
                    contactToNewOrderItems.put(orderIdtoContactId.get(theOrderItem.Order__c) , new List<Order_Item__c>());
                contactToNewOrderItems.get(orderIdtoContactId.get(theOrderItem.Order__c)).add(theOrderItem);
            }
        }
        List<Contact> queriedContacts = new List<Contact>();
        if(!orderIdtoContactId.values().isEmpty())
            queriedContacts =  [SELECT ID , (SELECT ID, Agent__c , Activity_Created_By__c , Activity_Created_DateTime__c ,Order__c, Contact__c FROM Order_Matching_Activities__r Where Activity_Commission_Eligible__c = true
            AND (Not CreatedBy.Name Like '%Integration User%') AND CreatedDate >=: dateRange AND CreatedDate <=: system.Now() ORDER BY CreatedDate DESC)
            FROM Contact Where ID IN: orderIdtoContactId.values()]; ////replaced CreatedById !=: CampaignMemberService.INTEGRATION_USER_ID to CreatedById !=: UtilityLibrary.integrationUser.id: in accordance with ticket B-38758

        //try to make this a map
        for(Contact theContact : queriedContacts)
        {
            if(!theContact.Order_Matching_Activities__r.isEmpty())
                contactToListOfOMA.put(theContact.Id , theContact.Order_Matching_Activities__r);
        }

        Set<Order_Matching_Activity__c> matchedOMA = new Set<Order_Matching_Activity__c>();
       
        for(Id theContactId : contactToListOfOMA.keySet())
        {
            if(contactToListOfOMA.containsKey(theContactId))
            {
                if(!contactToListOfOMA.get(theContactId).isEmpty()) 
                {
                    if(contactToListOfOMA.get(theContactId)[0].Activity_Created_DateTime__c >= System.today().addDays(-30))
                    {
                        matchedOMA.add(contactToListOfOMA.get(theContactId)[0]); 
                        contactToListOfOMA.get(theContactId).remove(0);
                    }
                }
            }
        }

        for(Order_Matching_Activity__c theMatchedOMA : matchedOMA)
        {
            order360ToInsert.addAll(createMatchedOrder360(theMatchedOMA));
           
        }

        for(Id theContactId : contactToListOfOMA.keySet())
        {
            for(Order_Matching_Activity__c theOMA : contactToListOfOMA.get(theContactId))
            {
                if(!matchedOMA.contains(theOMA)) //make sure object reference works
                    order360ToInsert.addAll(createUnMatchedOrder360(theOMA));
            }
        }
    }

    public Set<Order360__c> createMatchedOrder360 (Order_Matching_Activity__c theOMA)
    {
        Set<Order360__c> newOrder360s = new Set<Order360__c>();
        for(Order_Item__c theItem : contactToNewOrderItems.get(theOMA.Contact__c))
        {
            Order360__c newOrder360 = new Order360__c();
            newOrder360.LZ_Order_Item_Id__c = theItem.LZ_Order_Item_Id__c;
            newOrder360.Order_Item__c = theItem.Id; 
            newOrder360.Order_Matching_Activity__c = theOMA.Id;
            newOrder360.Order__c = theItem.Order__c;
            newOrder360.Agent__c = 'Agent 1';
            newOrder360.New_Logic__c = true;
            newOrder360s.add(newOrder360);
        }
        return newOrder360s;
    }

    public Set<Order360__c> createUnMatchedOrder360 (Order_Matching_Activity__c theOMA)
    {
        Set<Order360__c> newOrder360s = new Set<Order360__c>();
        for(Order_Item__c theItem : contactToNewOrderItems.get(theOMA.Contact__c))
        {
            Order360__c newOrder360 = new Order360__c();
            newOrder360.LZ_Order_Item_Id__c = theItem.LZ_Order_Item_Id__c;
            newOrder360.Order_Item__c = theItem.Id; 
            newOrder360.Order_Matching_Activity__c = theOMA.Id;
            newOrder360.Order__c = theItem.Order__c;
            newOrder360.New_Logic__c = true;
            newOrder360s.add(newOrder360);
        }
        return newOrder360s;
    }

    

    public void processFirstRenewalOrderItems(List<Order_Item__c> firstRenewalOrderItems)
    {
        Map<Id,Id> orderItemIdToParentOrderItemId = new Map<Id,Id>();
        Map<Id,List<Order_Item__c>> parentOrderItemToChildItems = new Map<Id,List<Order_Item__c>>();
        for(Order_Item__c theItem : firstRenewalOrderItems)
        {
            if(theItem.Parent__c != null)
            {
                if(!parentOrderItemToChildItems.containsKey(theItem.Parent__c))
                    parentOrderItemToChildItems.put(theItem.Parent__c , new List<Order_Item__c>());
                parentOrderItemToChildItems.get(theItem.Parent__c).add(theItem);
                orderItemIdToParentOrderItemId.put(theItem.Id , theItem.Parent__c);
            }
        }
        Map<Id,Id> orderItemIdtoOmaId = new Map<Id,Id>();//Just get One OMA
        for(Order360__c theRecord : [SELECT Id , Order_Item__c , Order_Item__r.Commission_Ignore__c, Order_Matching_Activity__c FROM Order360__c Where Order_Item__c IN: orderItemIdToParentOrderItemId.values() AND Agent__c = 'Agent 1']) 
        {
            if(theRecord.Order_Item__r.Commission_Ignore__c)
                orderItemIdtoOmaId.put(theRecord.Order_Item__c , theRecord.Order_Matching_Activity__c);
         
        }

        for(Order_Item__c theItem : firstRenewalOrderItems)
        {
           
            if(orderItemIdtoOmaId.containsKey(orderItemIdToParentOrderItemId.get(theItem.Id)))
            {
                Order360__c newOrder360 = new Order360__c();
                newOrder360.LZ_Order_Item_Id__c = theItem.LZ_Order_Item_Id__c;
                newOrder360.Order_Item__c = theItem.Id; 
                newOrder360.Order_Matching_Activity__c = orderItemIdtoOmaId.get(orderItemIdToParentOrderItemId.get(theItem.Id));
                newOrder360.Order__c = theItem.Order__c;
                newOrder360.Agent__c = 'Agent 1';
                newOrder360.New_Logic__c = true;
                order360ToInsert.add(newOrder360); 
            }
           
        }
    }

     Integer i = 0;
    Integer j = 0;
    Integer k = 0;
    Integer l = 0;
    Integer m = 0;
    Integer n = 0;
    Integer ii = 0;
    Integer jj = 0;
    Integer kk = 0;
    Integer ll = 0;
    Integer mm = 0;
    Integer nn = 0;
    Integer oo = 0;
    Integer pp = 0;
    Integer qq = 0;
    Integer o = 0;
    Integer p = 0;
    Integer q = 0;
    Integer r = 0;
    Integer s = 0;
    Integer t = 0;
    Integer u = 0;
    Integer v = 0;
    Integer w = 0;
    Integer rr = 0;
    Integer ss = 0;
    Integer tt = 0;
    Integer uu = 0;
    Integer a = 0;
    Integer aa = 0;
    Integer b = 0;
    Integer bb = 0;
    Integer cc = 0;
    Integer dd = 0;
    Integer d = 0;
    Integer e = 0;
    Integer ee = 0;
    Integer f = 0;
    Integer ff = 0;
    Integer g = 0;
    Integer gg = 0;
    Integer h = 0;
    Integer hh = 0;
    Integer x = 0;
    Integer xx = 0;
    Integer ttt = 0;
    Integer uuu = 0;
    Integer vvv = 0;
	
	
}