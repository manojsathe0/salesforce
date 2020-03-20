public with sharing class IADOrderPanelController_ltng
{
    @AuraEnabled public static String theId{get;set;}
    @AuraEnabled public static String theCustId{get;set;}
    @AuraEnabled public static List<Order__c> orders {get;set;}
    @AuraEnabled public static List<OrderWrapper> orderWrappers {get;set;}
    @AuraEnabled public static Map<Id, OrderWrapper> orderIdToOrderWrapper {get;set;}
    @AuraEnabled public static Map<String, OrderWrapper> procNumberToOrderWrapper{get;set;}
    @AuraEnabled public static Map<Id, Order__c> orderIdToOrders {get;set;}
    @AuraEnabled public static Boolean hasOrders{get;set;}
    @AuraEnabled public static Map<String, List<OrderRevisionWrapper>> processNumberToOrderRevisions {get;set;}
    @AuraEnabled public static Map<String, AggregateResult> dupeProcessingNumbers {get;set;}
    @AuraEnabled public static IADOrderPanelService_ltng.incompletedWrapperList incompleteOrders{get;set;}
    @AuraEnabled public static List<List<OrderRevisionWrapper>> orderrevisions {get;set;}
    @AuraEnabled public static List<IADMessage_ltng> exceptions {get;set;}
    // @AuraEnabled  public IADOrderPanelService incompleteOrderService{get;set;}
    
    public String orderIcon{get;set;}     
    
    @AuraEnabled 
    public static IADOrderPanelController_ltng getOrders(string recid)
    {
        system.debug('Inside getOrders');
        IADOrderPanelController_ltng iadorder = new IADOrderPanelController_ltng();
        theId= recid;
        hasOrders = false;
        orderWrappers = new List<OrderWrapper> ();
        orderIdToOrderWrapper = new Map<Id, OrderWrapper>();
        procNumberToOrderWrapper = new Map<String, OrderWrapper>();
        theCustId = [SELECT FkUser__c FROM Contact WHERE ID =: theId].FkUser__c;
        
        if(theId != null && theId != '')
        {
            orderIdToOrders = new Map<Id, Order__c>([SELECT Id, Name, Order_Payment_Status_Text__c,Entity_Name__c, Base_Product_Name__c, Contact__c, Gross_Total__c, User_Order_ID__c, Processing_Status__c, Order_Date_Time_Created__c, State_Of_Formation__c,
                                                     (SELECT Id, Entity_Name__c, Trademark_Copyright_Name__c, User_Order_ID__c FROM Order_Items__r)
                                                     FROM Order__c  WHERE Contact__c = :theId and User_Order_ID__c != null and User_Order_ID__c != '' ORDER BY Name DESC]);
            
            dupeProcessingNumbers = new Map<String, AggregateResult>([SELECT User_Order_ID__c Id, count(Id) FROM Order__c where Id in : orderIdToOrders.keySet()
                                                                      GROUP BY User_Order_ID__c HAVING count(Id)>1]); 
            
            processNumberToOrderRevisions = new Map<String, List<OrderRevisionWrapper>>();
            
            for(Order__c o : orderIdToOrders.values())
            {
                system.debug('OrderItems--->');
                system.debug(o.Order_Items__r);
                OrderWrapper orderWrap = new OrderWrapper(o, o.Order_Date_Time_Created__c);
                orderIdToOrderWrapper.put(o.Id, orderWrap);
                procNumberToOrderWrapper.put(o.User_Order_ID__c, orderWrap);
                if(dupeProcessingNumbers.get(o.User_Order_ID__c) != null)
                {
                    List<OrderRevisionWrapper> revisionWrappers = processNumberToOrderRevisions.get(o.User_Order_ID__c);
                    if(revisionWrappers != null)
                    {
                        revisionWrappers.add(new OrderRevisionWrapper(o));
                    }
                    else
                    {
                        revisionWrappers = new List<OrderRevisionWrapper>();
                        revisionWrappers.add(new OrderRevisionWrapper(o));
                        processNumberToOrderRevisions.put(o.User_Order_ID__c, revisionWrappers);
                    }
                }
            } 
            for(String procNumber : processNumberToOrderRevisions.keySet())
            {
                List<OrderRevisionWrapper> revisionWrappers = processNumberToOrderRevisions.get(procNumber);
                revisionWrappers.sort();
                
                Integer index = 0;
                OrderRevisionWrapper latestRevision;
                
                OrderWrapper orderWrap;
                for(OrderRevisionWrapper wrap : revisionWrappers)
                {
                    if(index==0)
                    {
                        orderWrap = orderIdToOrderWrapper.get(wrap.theOrder.Id);
                    }
                    //remove all revisions from outer order list
                    else if(index!=0)
                    {
                        orderIdToOrders.remove(wrap.theOrder.Id);
                    }
                    index++;
                    latestRevision = wrap;
                }
                //set to latest revision's date to sort effectively
                orderWrap.latestRevisionDate = latestRevision.theOrder.Order_Date_Time_Created__c;
                procNumberToOrderWrapper.put(orderWrap.theOrder.User_Order_ID__c, orderWrap);
                
                //remove first instance since it's used in the outter order list
                revisionWrappers.remove(0);
            }
            //using a list for vfp because maps act screwy
            orderWrappers = procNumberToOrderWrapper.values();
            orderWrappers.sort();
            system.debug('orderWrappers---->');
            system.debug(orderWrappers);
        }
        
        if(orderIdToOrders.size() > 0)
        {    
            hasOrders = true;
        }
        orderrevisions = processNumberToOrderRevisions.values();
        return iadorder;
    }
    
    public class OrderWrapper implements Comparable
    {
        @AuraEnabled public Order__c theOrder{get;set;}
        @AuraEnabled public Datetime latestRevisionDate{get;set;}
        @AuraEnabled public String entityName{get;set;}
        @AuraEnabled public String tradeMarkCopyrightName{get;set;}
        
        public OrderWrapper(Order__c op, Datetime revisionDate) 
        {
            theOrder = op;
            latestRevisionDate = revisionDate;
            /*
            if(op.Entity_Name__c != null && op.Entity_Name__c != 'none')
            {
                entityName = op.Entity_Name__c;
            }
            */
            for(Order_Item__c oi : op.Order_Items__r){
                if(oi.User_Order_ID__c == op.User_Order_ID__c){
                    entityName = oi.Entity_Name__c;
                    tradeMarkCopyrightName = oi.Trademark_Copyright_Name__c;
                }
            }
        }
        
        public Integer compareTo(Object compareTo) 
        {
            OrderWrapper compareToOrder = (OrderWrapper)compareTo;
            
            Integer returnValue = 0;
            if (latestRevisionDate < compareToOrder.latestRevisionDate) 
            {
                returnValue = 1;
            } 
            else if (latestRevisionDate > compareToOrder.latestRevisionDate) 
            {
                returnValue = -1;
            }
            
            return returnValue;       
        }
    }
    
    public class OrderRevisionWrapper implements Comparable 
    {
        @AuraEnabled public Order__c theOrder{get;set;}
        
        public OrderRevisionWrapper(Order__c op) 
        {
            theOrder = op;
        }
        
        public Integer compareTo(Object compareTo) 
        {
            OrderRevisionWrapper compareToOrder = (OrderRevisionWrapper)compareTo;
            
            Integer returnValue = 0;
            if (theOrder.Order_Date_Time_Created__c > compareToOrder.theOrder.Order_Date_Time_Created__c) 
            {
                returnValue = 1;
            } 
            else if (theOrder.Order_Date_Time_Created__c < compareToOrder.theOrder.Order_Date_Time_Created__c) 
            {
                returnValue = -1;
            }
            
            return returnValue;       
        }
    }
    @AuraEnabled
    public static  IADOrderPanelController_ltng   populateIncompleteOrders(string recid)
    {
        theId= recid;
        IADOrderPanelController_ltng iadorder = new IADOrderPanelController_ltng();
        IADOrderPanelService_ltng  incompleteOrderService = new IADOrderPanelService_ltng();
        exceptions = new List<IADMessage_ltng>();
        
        theCustId = [SELECT FkUser__c FROM Contact WHERE ID =: theId].FkUser__c;
        system.debug('inside controller method');
        // Object continuationObject;
        try
        {
            
            IADServiceBase_ltng.initWrapper(IADOrderPanelService_ltng.GETINCOMPLETEORDERSBYCUSTOMERID);
            IADOrderPanelService_ltng.getIncompleteOrders(theCustId);
            if(IADOrderPanelService_ltng.hasIncompleteOrders)
            {
                processIncompleteOrderResponse();
            }
            
            
            
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.iadMessages.add(IADMessageFactory_ltng.createMessage('error' , theException.getMessage()));
            exceptions = IADServiceBase_ltng.iadMessages;            
            
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.iadMessages.add(IADMessageFactory_ltng.createMessage('error' , theException.getMessage() + theException.getStackTraceString()));
            exceptions = IADServiceBase_ltng.iadMessages; 
        }
        //system.debug(incompleteOrderService.iadMessages);
        //return continuationObject; 
        return   iadorder;
    }
    
    //Callback method for Asynchronous
    public static void  processIncompleteOrderResponse() 
    {   
        try
        {
            
            //IADOrderPanelService_ltng.populateIncompleteOrders();
            
            if(IADOrderPanelService_ltng.hasIncompleteOrders){
                //incompleteOrders = ( IADContractBeans_ltng.IncompleteOrdersBean)IADOrderPanelService_ltng.incompleteOrderResponse.resultObjects[0]; 
                set<decimal> pids = new set<decimal>();
                map<string,string> pdt = new map<string,string>();
                
                for(IADOrderPanelService_ltng.incompleteWrapper a : IADOrderPanelService_ltng.incompleteOrdersService.processingOrders){
                    pids.add(decimal.valueof(a.processId));
                }
                for(Process__c p : [select id,name,Process_ID__c from Process__c where Process_ID__c in :pids]){
                    pdt.put(string.valueof(p.Process_ID__c),p.name);
                }
                List<IADOrderPanelService_ltng.incompleteWrapper> processingOrders = new List<IADOrderPanelService_ltng.incompleteWrapper>();
                for(IADOrderPanelService_ltng.incompleteWrapper a : IADOrderPanelService_ltng.incompleteOrdersService.processingOrders){
                    if(!a.isQuestionnaireCompleted && a.lastPageVisited != '0'){
                        a.productName = pdt.get(a.processId);
                        processingOrders.add(a);
                    }
                }
                //  system.debug('ProcessingOrder1-->'+incompleteOrderService.incompleteOrdersService.processingOrders);
                // system.debug('ProcessingOrder2-->'+processingOrders);
                if(processingOrders.size()>0){
                    IADOrderPanelService_ltng.incompleteOrdersService.processingOrders = processingOrders;
                    incompleteOrders = ( IADOrderPanelService_ltng.incompletedWrapperList)IADOrderPanelService_ltng.incompleteOrdersService; 
                }
                
            }
            //incompleteOrders = ( IADOrderPanelService.incompletedWrapperList)incompleteOrderService.incompleteOrdersService; 
        }
        catch(IADException theException)
        {
            IADServiceBase_ltng.iadMessages.add(IADMessageFactory_ltng.createMessage('error' , theException.getMessage()));
            exceptions = IADServiceBase_ltng.iadMessages; 
        }
        catch(Exception theException)
        {
            IADServiceBase_ltng.iadMessages.add(IADMessageFactory_ltng.createMessage('error' , theException.getMessage() + theException.getStackTraceString()));   
            exceptions = IADServiceBase_ltng.iadMessages;            
        }
        system.debug(incompleteOrders);
        
    }
    
    
    
    
}