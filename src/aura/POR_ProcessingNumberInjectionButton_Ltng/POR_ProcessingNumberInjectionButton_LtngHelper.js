({
    showMessage : function(component, event, helper) {
        //component.set("v.messageToDisplay", "Test");
        component.set("v.displayMessage", true);
    },
    
    closeMessage : function(component, event, helper) {
        component.set("v.displayMessage", false);
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
     
    toggleSpinner : function(component, event, helper) {
        console.log('ready to close the spinner');
        var spinner = component.find("spinner");
        console.log(spinner);
        $A.util.removeClass(spinner, "showSpinner");
        $A.util.addClass(spinner, "hideSpinner");
    }
})