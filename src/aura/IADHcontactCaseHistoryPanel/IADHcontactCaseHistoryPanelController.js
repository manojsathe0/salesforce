({
    doInit : function(cmp, event, helper) {
        helper.getIntial(cmp,event);
        
    },
    
    handleClick: function (component, event, helper) {
        
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id_str
        });
        navEvt.fire();
    },
    
    
    
    openTabWithSubtab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '/lightning/r/Case/'+component.get("v.recordId")+'/view',
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: '/lightning/n/All_Cases?contactid'+'='+component.get("v.recordId"),
                focus: true
            })
        })
        .catch(function(error) {
            console.log(error);
        });
    }
    
})