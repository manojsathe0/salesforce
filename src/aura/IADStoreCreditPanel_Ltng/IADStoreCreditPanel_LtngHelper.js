({
	loadStoreCredits : function(component, event, helper){
        console.log("ready to load installments");
        console.log('recordId: '+component.get("v.recordId"));
        var action = component.get("c.populateStoreCredits");
        action.setParams({
            "orderRecordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            console.log('state inside loadStoreCredits: '+state);
            if (state === "SUCCESS") { 
                var returnValue = response.getReturnValue();
                console.log("Stringified response");
                console.log(JSON.stringify(returnValue));
                console.log(returnValue.hasStoreCredit);
                component.set("v.storeCreditPanelService", returnValue);
                component.set("v.hasStoreCredit", returnValue.hasStoreCredit);
                component.set("v.orderId",returnValue.orderId);
                component.set("v.customerId",returnValue.customerId);
                
            }
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    hideSpinner : function(component, event, helper) {
        console.log('inside hide spinner method');
        var spinner = component.find('mySpinner');
        $A.util.addClass(spinner, "slds-hide");
    },
    openStoreCreditDetail : function(component,event,helper ,storecredit,storecode)
    {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '/lightning/r/Order__c/'+component.get("v.recordId")+'/view',
            focus: true
            
        }).then(function(response) {
            console.log('the res'+response);
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: '/lightning/n/StoreDetail?storecreditid='+storecredit+'&orderrecordid='+component.get("v.recordId")+"&orderid="+component.get("v.orderId")+"&customerid="+component.get("v.customerId"),
                focus: true
            }).then(function(response){
                console.log('focused tab id: '+response);
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: storecode
                }).then(function(response){
                    console.log('the tab Id to set label'+response.tabId);
                   
                }).catch(function(error) {
                    console.log('Error: '+error);
                });
            }).catch(function(error) {
                console.log('Error: '+error);
            });
        })
        .catch(function(error) {
            console.log('Error: '+error);
        });
    }
    
})