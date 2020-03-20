({
    getOrderDetails : function(component, event, helper){
        console.log('inside getOrderDetails');
        var action = component.get("c.init");
        action.setParams({
            "orderRecordId" : component.get("v.recordId"),
            "orderNumber" : component.get("v.orderNumber")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('@@@@'+ result);
            console.log('state inside getOrderDetails: '+state);
            
            if (state === "SUCCESS") {
                component.set("v.ctrl", result);
                this.loadOrderDetails(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadOrderDetails : function(component, event, helper){
        //console.log('inside loadOrderDetails');
        var ctrlRef = component.get("v.ctrl");
        //console.log('ctrlRef');
        //console.log(JSON.stringify(ctrlRef));
        var customerId = ctrlRef.customerId;
        var orderNumber = ctrlRef.orderNumber;
        var tabLabel = 'Order Details';
        var tabIcon = 'custom17';
        var subtaburl = '/lightning/n/Order_Details?orderId=' + orderNumber + '&customerId=' + customerId + '&orderRecordId=' + component.get("v.recordId");
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    },
    
    openSubTab : function(component, event, helper, subtaburl, tabLabel, tabIcon){
        var primaryTabUrl = '/lightning/r/Order__c/' + component.get("v.recordId") + '/view';
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: primaryTabUrl,
            focus: false
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: subtaburl,
                focus: true
            }).then($A.getCallback(function(response){
                console.log("now setting label");
                console.log('focused tab id: '+response);
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: tabLabel
                }).then(function(response){
                    console.log("now setting icon");
                    console.log('the tab Id to set label'+response.tabId);
                    workspaceAPI.setTabIcon({
                        tabId: response.tabId,
                        icon: tabIcon,
                        iconAlt: tabIcon
                    });
                }).catch(function(error) {
                    console.log("icon setting error");
                    console.log('Error inside IADOrderLinks Panel: 1'+error);
                });
            })).catch(function(error) {
                console.log("label setting error");
                console.log('Error inside IADOrderLinks Panel: 2'+error);
            });
        })
        .catch(function(error) {
            console.log("sub tab open error");
            console.log('Error inside IADOrderLinks Panel: '+error);
        });
    }
})