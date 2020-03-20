({
    doInit : function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(
                function(){
                    helper.setFocusedTabLabel(component,event,helper);
                }
            ),
            1000
        );
    },
    
    updateprofile:function(component, event, helper)
    {
        helper.updateProfile(component,event,helper);
    },
    
    setFocusedTabLabel : function(component, event, helper) {
        var res;
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            
            var taburl =response.url;
            res = taburl.split("=");
            component.set("v.profileid",res[1])
            helper.getintial(component,event,helper);
            
            
        })
        .catch(function(error) {
            console.log(error);
        });
        
    },
    closeFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
     deleteprofile:function(component, event, helper)
    {
        
        helper.deleteProfile(component,event,helper);
    }
})