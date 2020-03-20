({
	hideSpinner : function(component, event, helper) {
        console.log('inside hide spinner method');
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "slds-hide");
        $A.util.removeClass(spinner, "slds-show");
    },
    
    showSpinner : function(component, event, helper) {
        console.log('inside show spinner method');
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "slds-show");
        $A.util.removeClass(spinner, "slds-hide");
    }
})