({
    doInit : function(cmp, event, helper) {
        window.setTimeout(
            $A.getCallback(
                function(){
                    helper.setFocusedTabLabel(cmp, event ,helper);
                }
            ),
            1000
        );
    },
    
    sorting: function(component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        helper.sortBy(component, id_str);
    },
    
    handleClick: function (component, event, helper) {
        
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id_str
        });
        navEvt.fire();
    }
})