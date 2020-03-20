({
	openTab : function(component, event, helper, taburl) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({ 
            url: taburl,        
            focus: true
        }).catch(function(error) {
            console.log('Error: '+error);
        });
    },
    
    showToast : function(component, event, helper, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            type: type,
            message: message
        });
        toastEvent.fire();
    },
    
   	showSpinner: function(component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'slds-show');
        $A.util.removeClass(spinner, 'slds-hide');
    },
    
    hideSpinner : function(component,event,helper){
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, 'slds-show');
        $A.util.addClass(spinner, 'slds-hide');
    }
})