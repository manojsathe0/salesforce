({
    doInit : function(cmp, event, helper) {
        console.log('ready to invoke getOrder');
        helper.getorder(cmp,event,helper);
    },
    
	openorder : function(component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            recordId: id_str,
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
            }).then(function(tabInfo) {
                //console.log(“The url for this tab is: “ + tabInfo.url);
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    openSubTab : function(component, event, helper, subtaburl, tabLabel, tabIcon){
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '/lightning/r/Order__c/'+component.get("v.recordId")+'/view',
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: '/lightning/n/Old_Orders?custid'+'='+component.get("v.customerid"),
                focus: true
            })
     .catch(function(error) {
                console.log('Error: '+error);
            });
        })
        .catch(function(error) {
            console.log('Error: '+error);
        });
    }
})