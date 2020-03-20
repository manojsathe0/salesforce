/**
 * Created by jboles on 1/19/2017.
 */

public with sharing class IADOrdersGridController
{
    public String theId{get;set;}
    public String orderIcon{get;Set;}
    public String sortIcon{get;Set;}
    public String oldOrderNum{get;set;}
    public String oldOrderId{get;set;}
    public String contactId{get;set;}
    public IADOrderPanelService orderService{get;set;}
    public List<IADContractBeans.IADOrderBean> theOrders {get;set;}
    public Map<String, IADContractBeans.IADOrderBean> orderIdToOrderMap{get;set;}

    public IADOrdersGridController ()
    {
        theId = ApexPages.currentPage().getParameters().get('id');
        system.debug('theId ' + theId);
        orderIcon = IADSGVIconStrings.orderIcon;
        sortIcon = IADSGVIconStrings.sortIcon;

        orderService = new IADOrderPanelService();
        theOrders =  new List<IADContractBeans.IADOrderBean>();
        orderIdToOrderMap = new Map<String, IADContractBeans.IADOrderBean>();

        contactId = [select id from contact where fkUser__c =: theId limit 1].id;
    }
    public Object populateOrders()
    {
        Object continuationObject;
        try
        {
            orderService.initWrapper(IADOrderPanelService.GETORDERSBYCUSTOMERID, 'processOrdersResponse');
            continuationObject = orderService.getOrdersByCustomerId(theId);
        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }
        return continuationObject;

    }

    //Callback method for Asynchronous
    public Object processOrdersResponse()
    {
        try
        {
            orderService.populateOrders();
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
            for(IADContractBeans.IADOrderBean customerOrder : orderService.theOrders)
            {
                if(sfOrderNums.size() > 0 && sfOrderNums.contains(customerOrder.orderId))
                {
                    system.debug('removing orderid ' + customerOrder.orderId);
                    orderService.theOrders.remove(customerOrder);
                }
                else if(maxDatetimeSF != null && customerOrder.dateCreatedDatetime > maxDatetimeSF)
                {
                    system.debug('customerOrder.dateCreatedDatetime ' + customerOrder.dateCreatedDatetime);
                    system.debug('maxDatetimeSF ' + maxDatetimeSF);
                    system.debug('removing orderid ' + customerOrder.orderId);
                    orderService.theOrders.remove(customerOrder);
                }
                else
                {
                    orderIdToOrderMap.put(customerOrder.orderId, customerOrder);
                }
            }
            for(IADContractBeans.IADOrderBean filteredOrder : orderService.theOrders)
            {
                theOrders.add(filteredOrder);
            }

        }
        catch(IADException theException)
        {
            orderService.populateErrorMessage(theException);
        }
        catch(Exception theException)
        {
            orderService.populateErrorMessage(theException);
        }

        return null;
    }
    public void createOrder()
    {
        try
        {
            system.debug('oldOrderNum ' + oldOrderNum);
            if(UtilityLibrary.isNotNullOrBlank(oldOrderNum))
            {
                List<Order__c> oldOrders = [select id from Order__c where OrderID__c =:oldOrderNum];

                if(oldOrders.size() == 0)
                {
                    IADContractBeans.IADOrderBean theOldOrder = orderIdToOrderMap.get(oldOrderNum);
                    Order__c oldOrder = new Order__c(Name = theOldOrder.orderId, OrderID__c = theOldOrder.orderId, Contact__c = contactId, User_Order_ID__c=theOldOrder.orderItems[0].processingOrder.processingOrderId);
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
            orderService.populateErrorMessage(theException);
        }
    }
}