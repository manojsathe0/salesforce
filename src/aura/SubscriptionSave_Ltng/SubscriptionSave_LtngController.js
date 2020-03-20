/*
Subscription Save application.
Created by Artyom M.
Per Story: B-24904
*/

({
	doInit : function(component, event, helper) {
		var getRelatetOrderItems = component.get("c.getRelatetOrderItems");
		getRelatetOrderItems.setParams({"contactId" : component.get("v.recordId")});
		getRelatetOrderItems.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.state", response.getReturnValue());
            
            if (state === "SUCCESS") {
                component.set("v.subscriptionItems", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
		$A.enqueueAction(getRelatetOrderItems);
		
		var getCancellationReasons = component.get("c.getCancellationReasons");
		getCancellationReasons.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.state", response.getReturnValue());
            
            if (state === "SUCCESS") {
                component.set("v.cancellationReasons", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(getCancellationReasons);
        
        var checkForCall = component.get("c.checkForCall");
        checkForCall.setParams({"contactId" : component.get("v.recordId")});
		checkForCall.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.state", response.getReturnValue());
            
            if (state === "SUCCESS") {
                component.set("v.IsThereLoggedCall", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
		$A.enqueueAction(checkForCall);
	},
	submit : function(component, event, helper) {
		var subscriptionItems = component.get("v.subscriptionItems");
		var thereIsError = false;
		
		var i = 0;
		var selected = 0;
		
		for (; i < subscriptionItems.length; i++) {
			if (subscriptionItems[i].isSelected) {
				selected++;
			}
		}
		if (selected === 0) {
			component.find("warningArea").set("v.value","You must select at least one subscription.");
            thereIsError = true;
		}
		else{
			component.find("warningArea").set("v.value",null);
            thereIsError = false;
        }
        var selected_arr = [];
        for (i = 0; i < subscriptionItems.length; i++) {
			if (subscriptionItems[i].isSelected) {
                if (subscriptionItems[i].cancellationReason === "--None--") {
                    component.find("warningArea").set("v.value","You must select the reason for cancellation.");
            		thereIsError = true;
                }
                else {
                	selected_arr.push(subscriptionItems[i]);
                }
			}
		}
		
		
        if (!thereIsError && selected_arr.length > 0) {
			var createActiveRevenue = component.get("c.doSubmit");
			createActiveRevenue.setParams({"contactId" : component.get("v.recordId"), "selected" : JSON.stringify(selected_arr)});
			//component.set("v.state", JSON.stringify(selected_arr));
			createActiveRevenue.setCallback(this, function(response) {
				var state = response.getState();
				//component.set("v.state", state);
				if (state === "SUCCESS") {
					component.set("v.state", "SUCCESS");
	            }
	            else {
	                console.log("Failed with state:( " + state);
	            }
				//component.set("v.state", response.getReturnValue());
			});
			$A.enqueueAction(createActiveRevenue);
/**/
		}
	
	},
    handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }

})