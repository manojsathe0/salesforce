({	
	openTabWithPartialURL : function(component, partialURL) {
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
	showMessage : function(component, message) {
    	component.set("v.messageToDisplay", message);
        component.set("v.displayMessage", true);
    },
    
    gotoURL : function (component, URL) {
    	//alert(URL);
        window.location.href = URL;
        /*
	    var urlEvent = $A.get("e.force:navigateToURL");
	    urlEvent.setParams({
	      "url": URL
	    });
	    urlEvent.fire();
        */
    }
    
    
})