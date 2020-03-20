({
	myAction : function(component, event, helper) {
		
	},
    showlogacall: function(component, event, helper){
        //component.set("v.displaylogacall", true);
        var addEditBlock = component.find("SETlogacall");
        $A.util.toggleClass(addEditBlock, "slds-show");
		$A.util.toggleClass(addEditBlock, "slds-hide");
    },
    handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    closeModal:function(component,event,helper){    
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    openmodal: function(component,event,helper) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    }
})