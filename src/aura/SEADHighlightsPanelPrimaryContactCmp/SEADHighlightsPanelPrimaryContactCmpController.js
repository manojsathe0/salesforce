({
	doInit : function(component, event, helper){
        helper.loadData(component, event, helper);
    },
    
    openBoxPage : function(component, event, helper) {
        var boxURL = component.get("v.boxURL");
        $A.get("e.force:navigateToURL").setParams({ 
       "url": boxURL
    }).fire();

    }
    
})