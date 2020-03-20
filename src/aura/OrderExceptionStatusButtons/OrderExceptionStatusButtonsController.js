({
	doInit : function(component, event, helper) {
		
		helper.loadHoldField(component, event, helper);
		helper.checkCases(component, event, helper);
	},
	putOnHoldStatus : function(component, event, helper) {
		var action = component.get("c.putOnHold");
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
				if (responseObject === true) {
					component.set("v.isOnHold", true);
				}
				else {
					//alert('putOnHoldStatus Bad');
				}
				
			}
			else {
			
			}
            
			helper.toggleSpinner(component, event, helper);
			$A.get('e.force:refreshView').fire();
    	});
    	$A.enqueueAction(action);
	},
	removeFromHoldStatus : function(component, event, helper) {
		var action = component.get("c.removeFromHold");
    	var recordId = component.get("v.recordId");
    	
    	var spinner = component.find('spinner');
        console.log(spinner);
        $A.util.addClass(spinner, 'showSpinner');
        
    	action.setParams({"recordId" : recordId});
    	console.log("in removeFromHold with recordId: " + recordId);
    	action.setCallback(this, function(response) {
    		var state = response.getState();
			console.log("State: " + state);
			if (state === "SUCCESS") {
				var responseObject = response.getReturnValue();
				if (responseObject === true) {
					component.set("v.isOnHold", false);
					
				}
				else {
					alert('removeFromHoldStatus Bad');
				}
				
				
			}
			else {
			
			}
			helper.toggleSpinner(component, event, helper);
            $A.get('e.force:refreshView').fire();
    	
    	});
    	$A.enqueueAction(action);
	}
})