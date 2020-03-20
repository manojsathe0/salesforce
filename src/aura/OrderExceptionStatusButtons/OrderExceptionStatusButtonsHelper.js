({
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
    toggleSpinner : function(component, event, helper) {
        console.log('ready to close the spinner');
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, 'showSpinner');
        $A.util.addClass(spinner, 'hideSpinner');
    },
    
    loadHoldField : function(component, event, helper) {
    	var action = component.get("c.loadHoldStatusField");
    	var recordId = component.get("v.recordId");
    	var spinner = component.find('spinner');
        console.log(spinner);
        $A.util.addClass(spinner, 'showSpinner');
    	
    	action.setParams({"recordId" : recordId});
    	console.log("v.recordId: " + recordId);
    	action.setCallback(this, function(response) {
    		var state = response.getState();
			console.log("State: " + state);
			if (state === "SUCCESS") {
				var responseObject = response.getReturnValue();
				if (responseObject != null) {
					if (responseObject.Status__c === "Hold") {
						component.set("v.isOnHold", true);
					}
					
				}
				else {
					
				}
				
			}
			else {
			
			}
			helper.toggleSpinner(component, event, helper);
    	});
    	$A.enqueueAction(action);
    },
    
    checkCases : function(component, event, helper) {
    	var action = component.get("c.checkExistingCases");
    	var recordId = component.get("v.recordId");
    	action.setParams({"recordId" : recordId});
    	console.log("v.recordId: " + recordId);
    	action.setCallback(this, function(response) {
    		var state = response.getState();
			console.log("State: " + state);
			if (state === "SUCCESS") {
				var responseObject = response.getReturnValue();
				if (responseObject != null) {
					if (responseObject === true) {
						component.set("v.thereAreOpenCases", true);
					}
					else {
						component.set("v.thereAreOpenCases", false);
					}
					
				}
				else {
					
				}
				
			}
			else {
			
			}
    	
    	});
    	$A.enqueueAction(action);
    }
})