({
	 setFocusedTabLabel : function(component, event, helper) {
        var res;
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            
            var taburl =response.url;
            res = taburl.split("?");
            var sParams =res[1].split("&");
            var sParameterName;
            var amount;
            var orderid;
            
            for (var i = 0; i < sParams.length; i++) {
                sParameterName = sParams[i].split('='); //to split the key from the value.
                console.log('sParameterName: '+sParameterName);
                if(sParameterName[0] === 'amount'){
                    amount = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                }else if(sParameterName[0] === 'orderRecordId'){
                    orderid = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                }
            }
         
            component.set("v.orderrecordid",orderid );
            component.set("v.amount",amount);
            component.set("v.amounttorefund",amount);
            helper.loadInstallments(component,event,helper);
            
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    loadInstallments : function(component, event, helper){
        console.log("ready to load installments");
        var title;
            var type;
            var message;
        
        var action = component.get("c.populateInstallments");
        action.setParams({
            "orderRecordId": component.get("v.orderrecordid")
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            console.log('state inside loadInstallments: '+state);
            if (state === "SUCCESS") { 
                var returnValue = response.getReturnValue();
                component.set("v.installmentamount",returnValue.theOrderBalance.subTotalInstallmentBalance);
                console.log("Stringified response");
                console.log(JSON.stringify(returnValue));
                 var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                helper.hideSpinner(component, event, helper);
            }
            else
            {
            
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate order balance Installment amount: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
                
            }
        });
        $A.enqueueAction(action);
    },
     hideSpinner : function(component, event, helper) {
        console.log('inside hide spinner method');
        var spinner = component.find('mySpinner');
        $A.util.addClass(spinner, "slds-hide");
    },
    
    
    processrefund : function(component, event, helper){
        console.log("ready to load installments");
        
        var action = component.get("c.processrefund");
        action.setParams({
            "orderRecordId": component.get("v.orderrecordid"),
            "amount":component.get("v.amounttorefund")
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            console.log('state inside loadInstallments: '+state);
            if (state === "SUCCESS") { 
                var returnValue = response.getReturnValue();
            var title;
            var type;
            var message;
                console.log("Stringified response");
                console.log(JSON.stringify(returnValue));
                var messages = response.getReturnValue().iadServiceMessages;
                if(messages && messages.length > 0){
                    for (var i = 0; i < messages.length; i++) {
                        title = messages[i].msgType; 
                        type = messages[i].msgType;
                        message = messages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
               helper.hideSpinner(component, event, helper);
            }
            
        });
        $A.enqueueAction(action);
    },
     
     showToast : function(component, event, helper, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        console.log('toastEvent: ');
        console.log(toastEvent);
        toastEvent.setParams({
            title: title,
            type: type,
            message: message
        });
        toastEvent.fire();
    },
    
     showSpinner : function(component, event, helper) {
        console.log('inside show spinner method');
        var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-hide");
    },
})