public class RelatedOrdersService_ltng extends IADServiceBase_ltng {
    @AuraEnabled public String customerid{get;set;}
     public final static String GETORDERBYORDERID = 'GetOrderByOrderId';
     public final static String GETRELATEDORDERSBYORDERID = 'GetRelatedorders';
    @AuraEnabled public static List<IADMessage_ltng> iadServiceMessages{get;set;}
    @AuraEnabled public static transient IADContractBeans_ltng.IADOrderBeanWrapper theOrder{get;set;}
    @AuraEnabled public static IADContractBeans_ltng.IADRelatedOrders thegrouporders{get;set;}
    
    
     public RelatedOrdersService_ltng()
    {
        super();
        
        List<String> endpoints = new List<String>();
        endpoints.add(GETORDERBYORDERID);
       endpoints.add(GETRELATEDORDERSBYORDERID);
        initEndpoints(endpoints);
        
      
    }
    
    public static void getOrderByOrderId(String orderId)
    {
      
        
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETORDERBYORDERID).endPointConfig.link__c + OrderID+'?showOrderItemTree=true';
        IADServiceBase_ltng.APItoWrapper.get(GETORDERBYORDERID).setInfo(APIRequestResponseWrapper_ltng.ORDER, orderId);
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETORDERBYORDERID, '');
        system.debug('get order by order Id:');
        system.debug('calloutURL: '+calloutURL);
        populateOrder();
      
    }
    
    public Static void populateOrder()
    {        
        
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETORDERBYORDERID);
            system.debug('get order by order Id: theResponse: ');
            system.debug(theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                    IADContractBeans_ltng.IADOrderBeanWrapper deSerializedResponse  = (IADContractBeans_ltng.IADOrderBeanWrapper) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADOrderBeanWrapper.class);
                    system.debug('deSerializedResponse');
                    system.debug(deSerializedResponse);
                   
                    for(IADContractBeans_ltng.IADOrderItem theItem : deSerializedResponse.Order.orderItems)
                    {
                        theItem.dateTimeCreatedInString = UtilityLibrary.getIADDateTime(theItem.dateCreated);//takes String
                    }
                    theResponse.resultObjects = new List<Object>{deSerializedResponse};
                        if(theResponse.resultObjects != null && !theResponse.resultObjects.isEmpty())
                    {
                        theOrder = (IADContractBeans_ltng.IADOrderBeanWrapper)IADServiceBase_ltng.APItoWrapper.get(GETORDERBYORDERID).resultObjects[0];
                        
                        theOrder.Order.dateCreatedDatetime = UtilityLibrary.parseIADDatetime(theOrder.Order.dateCreated);
                    }
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
            
        }
        
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed Displaying Order: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
    public static void getRelatedOrders(String ordergroupid)
    {
      
        String calloutURL = IADServiceBase_ltng.APItoWrapper.get(GETRELATEDORDERSBYORDERID).endPointConfig.link__c.replace('{orderGroupId}',ordergroupid);
        
        IADServiceBase_ltng.makeRequestMulti(calloutURL, GETRELATEDORDERSBYORDERID, '');
       
        populateRelatedOrder();
      
    }
    
    public Static void populateRelatedOrder()
    {        
        
        try
        {
            APIRequestResponseWrapper_ltng theResponse = IADServiceBase_ltng.APItoWrapper.get(GETRELATEDORDERSBYORDERID);
            system.debug('get order by order Id: theResponse: ');
            system.debug(theResponse);
            if(theResponse.checkIsValidResponse())
            {
                if(theResponse.responseData != null)
                {
                  Map<string ,string > Orderidmap = new Map<string ,string >();
                  set<String> orderids = new set<String>();
                    thegrouporders  = (IADContractBeans_ltng.IADRelatedOrders) JSON.deserialize(theResponse.responseData , IADContractBeans_ltng.IADrelatedorders.class);
                   List<IADContractBeans_ltng.Orders> ordergrouplist =thegrouporders.orders;
                   for(IADContractBeans_ltng.Orders grouporder :ordergrouplist)
                   {
                    orderids.add(String.valueof(grouporder.orderId));
                   }
                   for(Order__c orderlist:[select id ,name   from order__c where name IN:orderids])
                   {
                   orderidmap.put(orderlist.name ,orderlist.id);
                   }
                   
                   for(IADContractBeans_ltng.Orders grouporder :ordergrouplist)
                   {
                   if(orderidmap.get(String.valueof(grouporder.orderId))!=null)
                    grouporder.orderrecordid=orderidmap.get(String.valueof(grouporder.orderId));
                   }
                   
                }
                else
                {
                    IADServiceBase_ltng.populateNullErrorMessage(theResponse);
                    iadServiceMessages = IADServiceBase_ltng.iadMessages;
                }
            }
            else
            {
                IADServiceBase_ltng.populateErrorMessage(theResponse);
                iadServiceMessages = IADServiceBase_ltng.iadMessages;
            }
            
        }
        
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage('Failed Displaying  group Orders: '+theException.getMessage());
            iadServiceMessages = IADServiceBase_ltng.iadMessages;
        }
    }
    
}