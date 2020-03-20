({
    getorder : function(cmp,event,helper) {
        console.log('inside getorder-->'+cmp.get("v.recordId"));
        var action = cmp.get("c.getOrders");
        action.setParams({ 
            recid : cmp.get("v.recordId") 
        });
        action.setCallback(this ,function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('State inside getorder--->'+state);
            if (state === "SUCCESS") 
            {  
                console.log(JSON.stringify(response.getReturnValue().orderWrappers));
                cmp.set("v.hasOrders",response.getReturnValue().hasOrders);
                cmp.set("v.orderWrappers",response.getReturnValue().orderWrappers);
                cmp.set("v.customerid",response.getReturnValue().theCustId)
                
                var revisions = [];
                var revision = response.getReturnValue().processNumberToOrderRevisions;
                for(var key in revision){
                    revisions.push({ key:key,value:revision[key]});
                }
                cmp.set("v.processNumberToOrderRevisions",revisions);
                helper.getincomplete(cmp,event,helper);
            }
            else
            {
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    getincomplete : function(cmp,event,helper) {
        
        var action =cmp.get("c.populateIncompleteOrders");
        action.setParams({ recid : cmp.get("v.recordId") });
        
        action.setCallback(this ,function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            var  exceptionMessages =response.getReturnValue().exceptions;
            if (state === "SUCCESS") {  
                cmp.set("v.incompleteOrders",response.getReturnValue().incompleteOrders);
                console.log('the inorders are '+JSON.stringify(response.getReturnValue()));                    
                helper.toggle(cmp,event);              
            }
            else if(state === 'ERROR'){
                
                title = "Error";
                type = "error";
                message = "An error occured when trying to load incomplete orders";
                helper.showToast(component, event, helper, title, type, message);
                helper.toggle(cmp,event);
            }
            if(exceptionMessages){                
                for (var i = 0; i < exceptionMessages.length; i++) {
                    title = exceptionMessages[i].msgType; 
                    type = exceptionMessages[i].msgType;
                    message = exceptionMessages[i].message;
                    helper.showToast(cmp, event, helper, title, type, message);
                }
                
                helper.toggle(cmp,event);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    toggle: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    showToast : function(component, event, helper, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        console.log('toastEvent: ');
        console.log(toastEvent);
        toastEvent.setParams({
            title: title,
            type: type,
            message: message
        });
        toastEvent.fire();
    }
    
})