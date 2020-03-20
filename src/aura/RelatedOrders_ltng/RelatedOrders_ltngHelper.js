({
	getorder : function(cmp,event,helper) {
        console.log('inside getorder-->'+cmp.get("v.recordId"));
        var action = cmp.get("c.getOrderByOrderId");
        action.setParams({ 
            orderRecordId : cmp.get("v.recordId") 
        });
        action.setCallback(this ,function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('State inside getorder--->'+state);
            if (state === "SUCCESS") 
            {  
                console.log(JSON.stringify(response.getReturnValue()));
                cmp.set("v.customerId",response.getReturnValue().customerid);
                cmp.set("v.ordergroupId",response.getReturnValue().theOrder.Order.orderGroupId);
                helper.getRelatedorder(cmp,event,helper);
                
            }
            else
            {
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    getRelatedorder : function(cmp,event,helper) {
        console.log('inside getorder-->'+cmp.get("v.ordergroupId"));
        var action = cmp.get("c.getRelatedOrders");
        action.setParams({ 
            ordergroupid : cmp.get("v.ordergroupId") 
        });
        action.setCallback(this ,function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('State inside getorder--->'+state);
            if (state === "SUCCESS") 
            {  
                console.log('hi relTED'+JSON.stringify(response.getReturnValue()));
                cmp.set("v.ordergroups",response.getReturnValue().thegrouporders.orders);
                  if(response.getReturnValue().thegrouporders.orders.length>0)  
                  {
                   cmp.set("v.hasrelatedorders","true");  
                  }
                          
              helper.hideSpinner(cmp, event, helper);        
            }
            else
            {
             helper.hideSpinner(cmp, event, helper);   
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    hideSpinner : function(component, event, helper) {
        console.log('inside hide spinner method');
        var spinner = component.find('mySpinner');
        $A.util.addClass(spinner, "slds-hide");
    },
})