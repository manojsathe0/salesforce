({
	searchOrder : function(component, event, helper) {
        var title;
        var type; 
        var message;
        var input = component.get("v.orderNumber");
        console.log('orderNumber-->'+input);
        
        helper.showSpinner(component, event, helper);
        
        if(isNaN(input)){
            title = "Error";
            type = "error";
            message = "Enter a valid number!";
            helper.showToast(component, event, helper, title, type, message);
            helper.hideSpinner(component, event, helper);
        }
        else{
            var action = component.get("c.validateOrderByOrderId");
            action.setParams({
                orderNumber : component.get("v.orderNumber") 
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('Inside search order-->'+state);
                if(state === 'SUCCESS'){
                    var returnValue = response.getReturnValue();
                    console.log('Search Order-->');
                    console.log(JSON.stringify(returnValue));
                    console.log(JSON.stringify(returnValue.order));
                    console.log(JSON.stringify(returnValue.orderId));
                    console.log(JSON.stringify(returnValue.customerId));
                    console.log(JSON.stringify(returnValue.orderFoundInSalesforce));
                    console.log(JSON.stringify(returnValue.orderFoundViaApi));
                    if(returnValue.orderFoundInSalesforce || returnValue.orderFoundViaApi){
                        console.log('Assigning data to all attributes-->');
                        component.set("v.orderWrapper", returnValue.order);
                        component.set("v.orderNumber", returnValue.orderId);
                        component.set("v.customerId", returnValue.customerId);
                        component.set("v.orderFound", true);
                    }else{
                        component.set("v.orderFound", false);
                    }
                    var exceptionMessages = response.getReturnValue().serviceMessages;
                    if(exceptionMessages){
                        for (var i = 0; i < exceptionMessages.length; i++) 
                        {
                            title = exceptionMessages[i].msgType; 
                            type = exceptionMessages[i].msgType;
                            message = exceptionMessages[i].message;
                            helper.showToast(component, event, helper, title, type, message);
                        }
                    }
                }else{
                    title = "Error";
                    type = "error";
                    message = "An error occured, please try again!";
                    helper.showToast(component, event, helper, title, type, message);
                }
                helper.hideSpinner(component, event, helper);
            });
            $A.enqueueAction(action);
        }        
    },
    
    openOrderDetails : function(component, event, helper) {
        var orderRecordId = event.currentTarget.dataset.orderrecordid;
        var tabUrl = '/lightning/r/Order__c/' + orderRecordId + '/view';
        helper.openTab(component, event, helper, tabUrl);
    }
})