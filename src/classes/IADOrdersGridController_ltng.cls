/**
 * Created by jboles on 1/19/2017.
 */

public with sharing class IADOrdersGridController_ltng
{
    public static String theId{get;set;}
    public static String orderIcon{get;Set;}
    public static String sortIcon{get;Set;}
    public static  String oldOrderNum{get;set;}
   @AuraEnabled  public  static String oldOrderId{get;set;}
    public  static String contactId{get;set;}
   // public static IADOrderPanelService orderService{get;set;}
    @AuraEnabled public static  List<IADContractBeans_ltng.IADOrderBean> theOrders {get;set;}
   @AuraEnabled public static  Map<String, IADContractBeans_ltng.IADOrderBean> orderIdToOrderMap{get;set;}
   @AuraEnabled public static List<IADMessage_ltng> exceptions {get;set;}

    public IADOrdersGridController_ltng ()
    {
       // theId = ApexPages.currentPage().getParameters().get('id');
       // system.debug('theId ' + theId);
        //orderIcon = IADSGVIconStrings.orderIcon;
        //sortIcon = IADSGVIconStrings.sortIcon;

        //orderService = new IADOrderPanelService();
        theOrders =  new List<IADContractBeans_ltng.IADOrderBean>();
        orderIdToOrderMap = new Map<String, IADContractBeans_ltng.IADOrderBean>();

        
    }
    @AuraEnabled
    public static IADOrdersGridController_ltng populateOrders(string recid)
    {
      IADOrdersGridController_ltng orders = new IADOrdersGridController_ltng();
     IADOrderPanelService_ltng  incompleteOrderService = new IADOrderPanelService_ltng();
         exceptions  = new List<IADMessage_ltng>();
        
       theId=recid;
        theOrders =  new List<IADContractBeans_ltng.IADOrderBean>();
        orderIdToOrderMap = new Map<String, IADContractBeans_ltng.IADOrderBean>();

        contactId = [select id from contact where fkUser__c =: theId limit 1].id;
        Object continuationObject;
        try
        {
            IADServiceBase_ltng.initWrapper(IADOrderPanelService_ltng.GETORDERSBYCUSTOMERID);
           // continuationObject = orderService.getOrdersByCustomerId(theId);
           IADOrderPanelService_ltng.getOrdersByCustomerId(theId);
           processOrdersResponse();
        }
        catch(IADException theException)
        {
           IADServiceBase_ltng.populateErrorMessage(theException);
           exceptions = IADServiceBase_ltng.iadMessages; 
        }
        catch(Exception theException)
        {
           IADServiceBase_ltng.populateErrorMessage(theException);
           exceptions = IADServiceBase_ltng.iadMessages; 
        }
        
      return orders;
    }

    //Callback method for Asynchronous
    public  static void processOrdersResponse()
    {
        try
        {
            IADOrderPanelService_ltng.populateOrders();
            List<Order__c> sfOrders = [SELECT OrderID__c FROM Order__c WHERE Contact__r.FkUser__c = :theId ORDER BY Name DESC];

            List<AggregateResult> agg = [select OrderID__c, Max(Order_Date_Time_Created__c) maxMod from Order__c WHERE Contact__r.FkUser__c = :theId group by OrderID__c];
            Datetime maxDatetimeSF;
            if(agg.size()>0)
            {
                String theDate = String.valueOf(agg[0].get('maxMod'));
                if(UtilityLibrary.isNotNullOrBlank(theDate))
                    maxDatetimeSF = Datetime.valueOfGMT(theDate);
            }

            Set<String> sfOrderNums = new Set<String>();
            for(Order__c sfOrder : sfOrders)
            {
                sfOrderNums.add(sfOrder.OrderID__c);
            }
            if(IADOrderPanelService_ltng.theOrders!=null){
            for(IADContractBeans_ltng.IADOrderBean customerOrder : IADOrderPanelService_ltng.theOrders)
            {
                if(sfOrderNums.size() > 0 && sfOrderNums.contains(customerOrder.orderId))
                {
                    system.debug('removing orderid ' + customerOrder.orderId);
                    IADOrderPanelService_ltng.theOrders.remove(customerOrder);
                }
                else if(maxDatetimeSF != null && customerOrder.dateCreatedDatetime > maxDatetimeSF)
                {
                    system.debug('customerOrder.dateCreatedDatetime ' + customerOrder.dateCreatedDatetime);
                    system.debug('maxDatetimeSF ' + maxDatetimeSF);
                    system.debug('removing orderid ' + customerOrder.orderId);
                    IADOrderPanelService_ltng.theOrders.remove(customerOrder);
                }
                else
                {
                    orderIdToOrderMap.put(customerOrder.orderId, customerOrder);
                }
            }
            for(IADContractBeans_ltng.IADOrderBean filteredOrder : IADOrderPanelService_ltng.theOrders)
            {
                theOrders.add(filteredOrder);
            }
            }
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages; 
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.populateErrorMessage(theException);
            exceptions = IADServiceBase_ltng.iadMessages; 
        }

       // return null;
    }
    
    @AuraEnabled
    public static IADOrdersGridController_ltng createOrder(string ordernum,   string  orderidmap,string customerid)
    {
    
       IADOrdersGridController_ltng ordercreated = new IADOrdersGridController_ltng();
         exceptions  = new List<IADMessage_ltng>();
       map<string,object> iitem;
       contactId = [select id from contact where fkUser__c =: customerid limit 1].id;
        try
        { 
        
        
        
        
         
        
         //  orderIdToOrderMap =   orderidmap;
            //system.debug('oldOrderNum ' + oldOrderNum);
            if(UtilityLibrary.isNotNullOrBlank(ordernum))
            {
                List<Order__c> oldOrders = [select id from Order__c where OrderID__c =:ordernum];

                if(oldOrders.size() == 0)
                {
                map<string,object> resData = (map<string,object>)JSON.deserializeUntyped(orderidmap);
         object oitem =(object)resData.get(ordernum);
          iitem = (map<string,object>)oitem;
          string ordernumid =string.valueof(iitem.get('orderId'));
          string ordername =string.valueof(iitem.get('orderId'));
                list<object>orderitems = (list<object>)iitem.get('orderItems');
                map<string,object> orderitem = (map<string,object>)orderitems[0];
                object processingnumber = (object)orderitem.get('processingOrder');
                map<string,object> processingorders =( map<string,object> )processingnumber;
                   string procnumber =string.valueof(processingorders.get('processingOrderId'));
                   
                    Order__c oldOrder = new Order__c(Name = ordernumid , OrderID__c = ordernumid, Contact__c = contactId, User_Order_ID__c=procnumber);
                   insert oldOrder;
                   oldOrderId = oldOrder.Id;
                }
                else
                {
                    oldOrderId = oldOrders[0].id;
                }
            }
        }
        catch(Exception theException)
        {
          IADServiceBase_ltng.populateErrorMessage(theException);
          exceptions = IADServiceBase_ltng.iadMessages; 
         
        }
       
        return ordercreated;
    }
}