({
	loadSubscriptionServices : function(component, event, helper){
        console.log("ready to load subscription services");
        var action = component.get("c.getSubscriptionServicesByCustomerId");
        action.setParams({
            "conRecordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) { 
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state inside loadSubscriptionServices: '+state);
            if (state === "SUCCESS") { 
                var returnValue = response.getReturnValue();
                console.log("Stringified response");
                //console.log(JSON.stringify(returnValue));
                console.log(JSON.stringify(returnValue.serviceWrapper));
                component.set("v.subscriptionServices", returnValue.serviceWrapper);
                component.set("v.hasSubscriptionServices", returnValue.hasSubscriptionServices);
                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
			}
            else
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to Load Subscription Services!";
                helper.showToast(component, event, helper, title, type, message);
            }
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    hideSpinner : function(component, event, helper) {
        console.log('inside hide spinner method');
        var spinner = component.find('mySpinner');
        $A.util.addClass(spinner, "slds-hide");
    },
    
    showSpinner : function(component, event, helper) {
        console.log('inside show spinner method');
        var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
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
    },
})