({

	closeMessage : function(component, event, helper) {
        helper.closeMessage(component, event, helper);
    },
    
    checkRelaunchEligibility : function(component, event, helper) {
    	console.log("In checkRelaunchEligibility");
    	component.set("v.buttonDisabled", true);
    	var action = component.get("c.checkIfRelaunchEligible");
    	var idParam = component.get("v.recordId");
    	action.setParams({
            "recordId" : idParam
        });
        console.log("v.recordId: " + idParam);
        action.setCallback(this, function(response) {
			var state = response.getState();
			console.log("State: " + state);
	        if (state === "SUCCESS") {
	        	var responseObject = response.getReturnValue();
	        	console.log("thereAreErrors: " + responseObject.thereAreErrors);
	        	console.log("errorMessage: " + responseObject.errorMessage);
	        	console.log("relaunchEligible: " + responseObject.relaunchEligible);
	        	
	        	if (responseObject.thereAreErrors != true) {
	        		if (responseObject.relaunchEligible) {
	        			component.set("v.buttonDisabled", false);
	        		}
	        	}
	        	else {
	        		component.set("v.buttonDisabled", true);
					var title = "Error";
                    var type = "error";
                	var message = responseObject.errorMessage;
                	helper.showToast(component, event, helper, title, type, message);
	        	}
                //helper.toggleSpinner(component, event, helper);
	        }
	        else {
	        	console.log("Failed with state: " + state);
                //helper.toggleSpinner(component, event, helper);
	        }                	    
	    });
		$A.enqueueAction(action);
    
    },
    
    showDialog : function(component, event, helper) {
        var action = component.get("c.getOrderData");
    	var idParam = component.get("v.recordId");
    	action.setParams({
            "recordId" : idParam
        });
    	console.log("v.recordId: " + idParam);
    	action.setCallback(this, function(response) {
			var state = response.getState();
			console.log("State: " + state);
	        if (state === "SUCCESS") {
	        	var responseObject = response.getReturnValue();
	        	console.log("thereAreErrors: " + responseObject.thereAreErrors);
	        	console.log("errorMessage: " + responseObject.errorMessage);
	        	console.log("validResponse: " + responseObject.orderNumber);
	        	console.log("validResponse: " + responseObject.processingNumber);
	        	
	        	if (responseObject.thereAreErrors != true) {
	        		component.set("v.orderNumber", responseObject.orderNumber);
	        		component.set("v.processingNumber", responseObject.processingNumber);
                    helper.showMessage(component, event, helper);
	        	}
	        	else 
                {
					var title = "Error";
                    var type = "error";
                	var message = responseObject.errorMessage;
                	helper.showToast(component, event, helper, title, type, message);
	        	}
                //helper.toggleSpinner(component, event, helper);
	        }
	        else {
	        	console.log("Failed with state: " + state);
                //helper.toggleSpinner(component, event, helper);
	        }                	    
	    });
		$A.enqueueAction(action);
	},
    
    processInjection : function(component, event, helper) {
        var orderNumber = component.get("v.orderNumber");
        var processingNumber = component.get("v.processingNumber");
        console.log('OrderNumber-->'+orderNumber);
        var action = component.get("c.injectProcessingNumber");
        action.setParams({
            "orderNumber" : orderNumber, 
            "processingNumber" : processingNumber,
            "orderItemSFId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
       
        	var state = response.getState();
			console.log("State: " + state);
			if (state === "SUCCESS") {
	        	var responseObject = response.getReturnValue();
	        		        	
	        	if (responseObject != true) {
	        		var title = "Success";
                    var type = "success";
                	var message = "Re-launch Success.";
                	helper.showToast(component, event, helper, title, type, message);
	        	}
	        	else {
					var title = "Error";
                    var type = "error";
                	var message = "Re-launch Failed.";
                	helper.showToast(component, event, helper, title, type, message);
	        	}
                component.set("v.displayMessage", false);
                helper.toggleSpinner(component, event, helper);
	        }
	        else {
	        	let errors = response.getError();
	        	
	        	var title = "Error";
	        	var type = "error";
                var message = "Fatal: " + errors[0].message;
                helper.showToast(component, event, helper, title, type, message);
	        	console.log("Failed with state: " + state);
                helper.toggleSpinner(component, event, helper);
	        }
		});
        $A.enqueueAction(action);
	}
   
})