({
    doInit : function(component, event, helper){
        helper.loadSubscriptionServices(component, event, helper);
    },
    
    openSupscription : function(component, event, helper){
        var orderRecordId = component.get("v.recordId");
        var orderNumber = component.get("v.orderId");
        var customerId = component.get("v.customerId");
        var orderItemId = event.currentTarget.dataset.orderitemid;
        var subscriptionId = event.currentTarget.dataset.subscriptionid;
        if(!orderNumber)
        {
            orderNumber= event.currentTarget.dataset.orderidfromsub; 
        }
        console.log(orderNumber);
        console.log(orderItemId);
        console.log(subscriptionId);
        var subtaburl = '/lightning/n/Subscriptions?orderId=' + orderNumber + '&customerId=' + customerId + '&orderItemId=' + orderItemId + '&subscriptionId=' + subscriptionId + '&orderRecordId=' + component.get("v.recordId");
        var tabLabel = subscriptionId;
        var tabIcon = 'custom17';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon, orderRecordId, true);
    },
    
    openOrderDetails : function(component, event, helper){
        var customerId = component.get("v.customerId");
        var orderNumber = event.currentTarget.dataset.orderidfromsub;
        var orderItemId = event.currentTarget.dataset.orderitemid;
        var subscriptionId = event.currentTarget.dataset.subscriptionid;
        
        console.log(customerId);
        console.log(orderNumber);
        console.log(orderItemId);
        console.log(subscriptionId);
        
        var subtaburl = '/lightning/n/Order_Details?orderId=' + orderNumber + '&customerId=' + customerId;
        var tabLabel = orderNumber;
        var tabIcon = 'custom17';
		
        helper.retriveOrderDetails(component, event, helper, subtaburl, tabLabel, tabIcon, orderNumber);        
    },
})