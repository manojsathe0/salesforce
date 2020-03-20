public with sharing class IADOrderPanelController
{
    public String theId{get;set;}
    public String theCustId{get;set;}
    public List<Order__c> orders {get;set;}
    public List<OrderWrapper> orderWrappers {get;set;}
    public Map<Id, OrderWrapper> orderIdToOrderWrapper {get;set;}
    public Map<String, OrderWrapper> procNumberToOrderWrapper{get;set;}
    public Map<Id, Order__c> orderIdToOrders {get;set;}
    public Boolean hasOrders{get;set;}
    public Map<String, List<OrderRevisionWrapper>> processNumberToOrderRevisions {get;set;}
    public Map<String, AggregateResult> dupeProcessingNumbers {get;set;}
    //public IADContractBeans.IncompleteOrdersBean incompleteOrders{get;set;}
    public IADOrderPanelService incompleteOrderService{get;set;}
    //public final static String GETINCOMPLETEORDERSBYCUSTOMERID = 'GetIncompleteOrdersByCustomerID';
    public String orderIcon{get;set;} 

    public IADOrderPanelController () 
    {
       
          
        orderIcon = IADSGVIconStrings.orderIcon;
        theId = ApexPages.currentPage().getParameters().get('id');
        hasOrders = false;
        orderWrappers = new List<OrderWrapper> ();
        orderIdToOrderWrapper = new Map<Id, OrderWrapper>();
        procNumberToOrderWrapper = new Map<String, OrderWrapper>();
        getOrders();
        if(orderIdToOrders.size() > 0)
            hasOrders = true;

        incompleteOrderService = new IADOrderPanelService();
        theCustId = [SELECT FkUser__c FROM Contact WHERE ID =: theId].FkUser__c;
        
    }
    
    public void getOrders()
    {
        if(theId != null && theId != '')
        {
            orderIdToOrders = new Map<Id, Order__c>([SELECT Id, Name, Entity_Name__c, Base_Product_Name__c, Contact__c, Gross_Total__c, User_Order_ID__c, Processing_Status__c, Order_Date_Time_Created__c, State_Of_Formation__c 
                                        FROM Order__c  WHERE Contact__c = :theId and User_Order_ID__c != null and User_Order_ID__c != '' ORDER BY Name DESC]);
             
             
                                        
            dupeProcessingNumbers = new Map<String, AggregateResult>([SELECT User_Order_ID__c Id, count(Id) FROM Order__c where Id in : orderIdToOrders.keySet()
                                                                                            GROUP BY User_Order_ID__c HAVING count(Id)>1]); 
                                                                                            
            processNumberToOrderRevisions = new Map<String, List<OrderRevisionWrapper>>();
            
            for(Order__c o : orderIdToOrders.values())
            {
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
        }
    }
    
    public class OrderWrapper implements Comparable
    {
        public Order__c theOrder{get;set;}
        public Datetime latestRevisionDate{get;set;}
        public String entityName{get;set;}
        
        public OrderWrapper(Order__c op, Datetime revisionDate) 
        {
            theOrder = op;
            latestRevisionDate = revisionDate;
            if(op.Entity_Name__c != null && op.Entity_Name__c != 'none')
            {
                entityName = op.Entity_Name__c;
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
        public Order__c theOrder{get;set;}
        
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
    /*
    public Object populateIncompleteOrders()
    {
        system.debug('inside controller method');
        Object continuationObject;
        try
        {
            APIRequestResponseWrapper theWrapper = new APIRequestResponseWrapper();
            theWrapper.endPointConfig = apitoEndpoint.get(GETINCOMPLETEORDERSBYCUSTOMERID);
            theWrapper.isAsync =  apiToIsAsync.get(GETINCOMPLETEORDERSBYCUSTOMERID);
            theWrapper.callBackMethod = 'processIncompleteOrderResponse';
   
            incompleteOrderService.incompleteOrderResponse = theWrapper; //set the wrapper object
            continuationObject = incompleteOrderService.getIncompleteOrders(theCustId);
            
            if(incompleteOrderService.hasIncompleteOrders)
              incompleteOrders = ( IADContractBeans.IncompleteOrdersBean)incompleteOrderService.incompleteOrderResponse.resultObjects[0]; 
        }
        catch(IADException theException)
        {
            incompleteOrderService.iadMessages.add(IADMessageFactory.createMessage('error' , theException.getMessage()));             
                   
        }
        catch(Exception theException)
        {
            incompleteOrderService.iadMessages.add(IADMessageFactory.createMessage('error' , theException.getMessage() + theException.getStackTraceString()));
        }
        system.debug(incompleteOrderService.iadMessages);
        return continuationObject; 
       
    }
    
    //Callback method for Asynchronous
    public Object processIncompleteOrderResponse() 
    {   
          try
          {
              HttpResponse response = Continuation.getResponse(incompleteOrderService.incompleteOrderResponse.requestLabelContinuation);
              incompleteOrderService.incompleteOrderResponse.responseData = response.getBody();
              incompleteOrderService.incompleteOrderResponse.statusCode = response.getStatusCode()+'';
           
              incompleteOrderService.populateIncompleteOrders();
              
              if(incompleteOrderService.hasIncompleteOrders)
                  incompleteOrders = ( IADContractBeans.IncompleteOrdersBean)incompleteOrderService.incompleteOrderResponse.resultObjects[0]; 
          }
          catch(IADException theException)
          {
                 incompleteOrderService.iadMessages.add(IADMessageFactory.createMessage('error' , theException.getMessage()));
          }
          catch(Exception theException)
          {
                incompleteOrderService.iadMessages.add(IADMessageFactory.createMessage('error' , theException.getMessage() + theException.getStackTraceString()));              
          }
          system.debug(incompleteOrders);
          return null;
    }
    
    */

    
}