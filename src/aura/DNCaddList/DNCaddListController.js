({
    //Getting values from reasons
    loadOptions: function (component, event, helper) {
        var opts = [
            { value: "Phone", label: "Phone" },
            { value: "Email", label: "Email" },
            { value: "Text Message", label: "Text Message" },
            { value: "Chat", label: "Chat" },
            { value: "Other - please specify", label: "Other - please specify" }
            
        ];
        component.set("v.options", opts);
        helper.checkinternaldisplay(component, event, helper);
    },
    
    toggleModal: function (component, event, helper) {
        // var displayqc = component.find('qcmodal');
        // displayqc.getElement().style.display = 'block';
        helper.toggleModalHelper(component);
    },
    
    
    hidedeactivatemodal : function(component, event, helper) {
        var displayqc = component.find('qcmodal');
        displayqc.getElement().style.display = 'none';
        
    },
    
    
    save: function(component, event, helper){
        var option = component.get("v.selectedValue");
        var reason = component.get("v.otherreason");
        reason = reason ? reason.trimStart().trimEnd() : reason;
        if(option==='Other - please specify' && !reason)
        {
              helper.showToast(component, event, helper, 'Error', 'error', 'Please specify Reason');  
        }
        else
        {
            helper.toggleSpinner(component,event);
             helper.saveToDNC(component, event, helper, reason);
        }
    }
})