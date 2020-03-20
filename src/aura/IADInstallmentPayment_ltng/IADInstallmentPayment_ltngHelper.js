({
	populateDefaultValues : function(component, event, helper) {
        console.log('im ready to populate default items');
		var action = component.get("c.initCtrl");
        action.setParams({
            "orderId" : component.get("v.orderId"),
            "customerId" : component.get("v.customerId"),
            "invokingPage" : component.get("v.invokingPage"),
            "invokingPageId" : component.get("v.invokingPageId")
        }); 
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state inside populateDefaultValues: '+state);
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result: initCtrl '+JSON.stringify(result)); 
                var paymentReasons = [];
                var paymentReasonsMap = response.getReturnValue().paymentReasons;
                for ( var key in paymentReasonsMap ) {
                    paymentReasons.push({value:key, key:paymentReasonsMap[key]});
                }
                component.set("v.paymentReasons", paymentReasons);
                if(paymentReasons.length > 0){
                    console.log('paymentOptions[0].key: '+paymentReasons[0].key);
                    component.set("v.currentPaymentReasonId", paymentReasons[0].key);
                }	
                component.set("v.notificationEmail", result.email)
            	helper.populatePaymentMethods(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate payment reasons: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
	},
    
    populatePaymentMethods : function(component, event, helper){
    	console.log('ready to populate payment methods');
        var action = component.get("c.populateProfiles");
        action.setParams({
            "customerId" : component.get("v.customerId"),
            "pageType" : "MakePayment"
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log("state inside populatePaymentMethods: "+state);
            if(state ==="SUCCESS"){
                var iadServiceMessages = response.getReturnValue().messages;
            	console.log('iadServiceMessages: '+iadServiceMessages);
                var returnValue = response.getReturnValue();
                console.log('returnValue: '+JSON.stringify(returnValue));
                var paymentOptions = [];
            	var paymentOptionsMap = response.getReturnValue().paymentOptions;
                for ( var key in paymentOptionsMap ) {
                    paymentOptions.push({value:paymentOptionsMap[key], key:key});
                }
                component.set("v.paymentOptions", paymentOptions);
                if(paymentOptions.length > 0){
                    console.log('paymentOptions[0].key: '+paymentOptions[0].key);
                    component.set("v.currentPaymentOptionId", paymentOptions[0].key);
                }else{
                    component.set("v.currentPaymentOptionId", "none");
                }
                if(iadServiceMessages){                
                    for (var i = 0; i < iadServiceMessages.length; i++) {
                        title = iadServiceMessages[i].msgType; 
                        type = iadServiceMessages[i].msgType;
                        message = iadServiceMessages[i].message;
                    }
                    helper.showToast(component, event, helper, title, type, message);
                }
                if(component.get("v.invokingPage") == 'Installment')
                {
                    helper.hideSpinner(component, event, helper);
                }
                else
                {
                    helper.retrieveOrderBalanceByOrderId(component, event, helper, true);
                }                
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate payment methods: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
	},
    
    postPaymentForOrder : function(component, event, helper){
    	var action = component.get("c.postPayment");
        console.log('invoking page-----> '+component.get("v.invokingPage"));
        action.setParams({
            "orderNumber" : component.get("v.orderId"),
            "processAmount" : component.get("v.processTotal"),
            "dueAmount" : component.get("v.amountDue"),
            "invokingPage" : component.get("v.invokingPage"),
            "selectedReason" : component.get("v.currentPaymentReasonId"),
            "comments" : component.get("v.comments"),
            "profileId" : component.get("v.currentPaymentOptionId"),
            "email" : component.get("v.notificationEmail"),
            "installmentId" : component.get("v.installmentId"),
            "firstname" :component.get("v.firstname"),
            "lastname" :component.get("v.lastname"),
            "bankname" :component.get("v.bankname"),
            "checknumber" :component.get("v.checknumber")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state: '+state);
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
                console.log('returnValue: '+JSON.stringify(returnValue));
                var messages = response.getReturnValue().messages;
                var isPaymentProcessed = response.getReturnValue().isPaymentProcessed;
                console.log("isPaymentProcessed: "+isPaymentProcessed);
                console.log('messages:');
                console.log(messages);
                if(messages)
                {    
                    for (var i = 0; i < messages.length; i++) {
                        title = messages[i].msgType; 
                        type = messages[i].msgType;
                        message = messages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                if(component.get("v.invokingPage") == 'Installment')
                {
                    if(isPaymentProcessed){
                        component.set("v.isPaymentProcessed", isPaymentProcessed);
                        component.set("v.processTotal", 0.00);
                        component.set("v.amount", 0.00);
                        component.set("v.amountDue", 0.00);
                        component.set("v.amtCheckbox", false);
                    }
                    helper.hideSpinner(component, event, helper);
                }
                else
                {
                    helper.retrieveOrderBalanceByOrderId(component, event, helper, false);
                }   
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to post payment: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
	},
    
    setInstallmentAmount : function(component, event, helper){
        component.set("v.processTotal", installmentAmount);
        component.set("v.amount", installmentAmount);
        component.set("v.amtCheckbox", true);
    },
    
    retrieveOrderBalanceByOrderId : function(component, event, helper, onload){
        console.log('im ready to retrieve order balance');
        var action = component.get("c.populateOrderBalances");
        action.setParams({
            "orderNumber" : component.get("v.orderId")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = action.getState();
            console.log('state inside retrieveOrderBalanceByOrderId: '+state);
            if(state === "SUCCESS"){
                var returnValue = action.getReturnValue();
                var amount = action.getReturnValue().amount;
                var amountDue = action.getReturnValue().amountDue;
                console.log('returnValue: '+JSON.stringify(returnValue)); 
                console.log('amount: '+amount);
                console.log('amountDue: '+amountDue);
                component.set("v.amountDue", amountDue);
                component.set("v.amount", amount);
                
                if(onload){
                    component.set("v.processTotal", amount);
                	component.set("v.amtCheckbox", true);
                }else{
                    component.set("v.processTotal", 0.00);
                    component.set("v.otherAmount", 0.00);
                    component.set("v.amtCheckbox", false);
                    component.set("v.othrAmtCheckbox", true);
                }               
                
                var messages = response.getReturnValue().messages;
                if(messages)
                {    
                    for (var i = 0; i < messages.length; i++) {
                        title = messages[i].msgType; 
                        type = messages[i].msgType;
                        message = messages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                helper.hideSpinner(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate order balance: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        })
        $A.enqueueAction(action);
    },
    
    openSubTab : function(component, event, helper, subtaburl, tabLabel, tabIcon){
        var parentTabUrl = '/lightning/r/Order__c/' + component.get("v.invokingPageId") + '/view';
        console.log('parentTabUrl: '+parentTabUrl);
        console.log('subtaburl: '+subtaburl);
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: parentTabUrl,
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
    
    hideSpinner : function(component, event, helper) {
        console.log('inside hide spinner method');
        var spinner = component.find('mySpinner');
        $A.util.addClass(spinner, "slds-hide");
    },
    
    showSpinner : function(component, event, helper) {
        console.log('inside show spinner method');
        var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-hide");
    },
})