({
	openTabWithRecordId : function(component, recordId) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
        	url: "#/sObject/" + recordId + "/view",        
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
            }).then(function(tabInfo) {
	            console.log("The recordId for this tab is: " + tabInfo.recordId);
            });
        }).catch(function(error) {
                console.log(error);
        });
    },
    
    processGetNext : function(component, helper) {
    	var action = component.get("c.getNextAbandoner");
    	action.setCallback(this, function(response) {
			var state = response.getState();
			
	        if (state === "SUCCESS") {
	        	var responseStatus = response.getReturnValue();
	        	if (!responseStatus.thereAreErrors) {
	        		helper.openTabWithRecordId(component, responseStatus.recordId);
	        	}
	        	else {
	        		helper.showMessage(component, responseStatus.errorMessage);
	        	}
	        	
	        }
	        else {
	        	console.log("Failed with state: " + state);
	        }
	    });
		$A.enqueueAction(action);
    },
    
    showMessage : function(component, message) {
    	component.set("v.messageToDisplay", message);
        component.set("v.displayMessage", true);
    }
})