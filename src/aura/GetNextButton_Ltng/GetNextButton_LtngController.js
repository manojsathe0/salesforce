/*
Created per story: B-25556	
By: Artyom M.
Migration of GetNext functionality to Lightning.  
*/

({
	doInit : function(component, event, helper) {

	},
    getNext : function(component, event, helper) {
        helper.processGetNext(component, helper);
    },
    
    
    closeMessage : function(component, event, helper) {
        component.set("v.displayMessage", false);
    },
    
    
    
})