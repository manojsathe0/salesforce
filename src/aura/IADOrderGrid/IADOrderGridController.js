({
    doInit : function(cmp, event, helper) {
        window.setTimeout(
            $A.getCallback(
                function(){
                    helper.setFocusedTabLabel(cmp,event,helper);
                }
            ),
            1000
        );
    },
    
    openorder : function(component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        helper.createorder(component,event,helper,id_str);
    }
})