({
	loadPayments : function(component, event, helper){
        console.log("ready to load installments");
        console.log('recordId: '+component.get("v.recordId"));
        var action = component.get("c.populatePayments");
        action.setParams({
            "orderRecordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            console.log('state inside loadInstallments: '+state);
            if (state === "SUCCESS") { 
                var returnValue = response.getReturnValue();
                console.log("Stringified response");
                console.log(JSON.stringify(returnValue));
                console.log(returnValue.hasPayments);
                component.set("v.pendingPaymentService", returnValue);
                component.set("v.hasPayments", returnValue.hasPayments)
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
   openPaymentDetail : function(component, event, helper, transactionid ,transactiontype){
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url:'/lightning/r/Order__c/'+component.get("v.recordId")+'/view',
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: '/lightning/n/PaymentRefund?transactionid='+transactionid+'&transactiontype='+transactiontype,
                focus: true
            }).then(function(response){
                console.log('focused tab id: '+response);
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: transactionid
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