({
	loadSubscriptionServices : function(component, event, helper){
        console.log("ready to loadSubscriptionServices");
        console.log('recordId: '+component.get("v.recordId"));
        var action = component.get("c.populateSubscriptions");
        action.setParams({
            "orderRecordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            console.log('state inside loadSubscriptionServices: '+state);
            if (state === "SUCCESS") { 
                var returnValue = response.getReturnValue();
                console.log("Stringified response");
                console.log(JSON.stringify(returnValue));
                console.log(returnValue.hasSubscriptions);
                console.log('orderIdEntityNameMap');
                console.log(JSON.stringify(returnValue.orderIdEntityNameMap));
                
                var orderIdEntityName = [];
                var orderIdEntityNameMap = returnValue.orderIdEntityNameMap;
                for ( var key in orderIdEntityNameMap ) {
                    console.log('key--->'+key);
                    console.log('value--->'+orderIdEntityNameMap[key]);
                    orderIdEntityName.push({value:orderIdEntityNameMap[key], key:key});
                }
                console.log(JSON.stringify(orderIdEntityName));
                component.set("v.orderIdEntityNameMap", orderIdEntityName);
                component.set("v.subscriptionService", returnValue);
                component.set("v.hasSubscriptions", returnValue.hasSubscriptions);
                component.set("v.orderId", returnValue.orderId);
                component.set("v.customerId", returnValue.customerId);
                console.log(returnValue.orderId);
            }
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    retriveOrderDetails : function(component, event, helper, subtaburl, tabLabel, tabIcon, orderNumber){
        console.log("ready to retriveOrderDetails");
        var action = component.get("c.retriveOrderDetail");
        action.setParams({
            "orderNumber": orderNumber
        });
        action.setCallback(this, function(response) { 
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state inside retriveOrderDetails: '+state);
            if (state === "SUCCESS") { 
                var orderRecordId;
                var returnValue = response.getReturnValue();
                console.log("Stringified response");
                console.log(JSON.stringify(returnValue));
                if(returnValue.length > 0)
                {    
                    orderRecordId = returnValue[0].Id;
                    subtaburl =  subtaburl + '&orderRecordId=' + orderRecordId;
                    console.log('OrderRecordId-->'+orderRecordId);
                    console.log('subtaburl-->'+subtaburl);
                	helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon, orderRecordId, false);
                }
                else
                {
                    title = "Error";
                    type = "error";
                    message = "The order record could not be located in salesforce: Please try again after sometime!";
                    helper.showToast(component, event, helper, title, type, message);
                }                
            }
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    openSubTab : function(component, event, helper, subtaburl, tabLabel, tabIcon, orderRecordId, isSubscription){
        var subString;
        if(isSubscription)
        {    
        	subString = '/lightning/r/Order__c/' + component.get("v.recordId") + '/view';
        }
        else
        {
            subString = '/lightning/r/Order__c/' + orderRecordId + '/view';
        }
        console.log('sub: '+subString);
        console.log('subtaburl: '+subtaburl);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: subString,
            focus: false
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: subtaburl,
                focus: true
            }).then(function(response){
                console.log('focused tab id: '+response);
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: tabLabel
                }).then(function(response){
                    console.log('the tab Id to set label'+response.tabId);
                    workspaceAPI.setTabIcon({
                        tabId: response.tabId,
                        icon: tabIcon,
                        iconAlt: tabIcon
                    });
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
    },
    
    hideSpinner : function(component, event, helper) {
        console.log('inside hide spinner method');
        var spinner = component.find('mySpinner');
        $A.util.addClass(spinner, "slds-hide");
    },
})