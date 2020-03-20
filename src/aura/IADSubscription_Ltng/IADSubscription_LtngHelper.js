({
    populateDefaultValues : function(component, event, helper){
        console.log('ready to populate default values');
        var action = component.get("c.populateSubscription");
        action.setParams({
            "subId" : component.get("v.subscriptionId"),
            "custId" : component.get("v.customerId")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log("state inside populateDefaultValues: "+state);
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
                
                console.log(JSON.stringify(returnValue));
                
                component.set("v.subscriptionService", returnValue);
                
                if(returnValue.subscriptionSingleItem.subscription.autoRenew == 'Yes'){
                    component.set("v.isAutoRenewable", "1");
                }else{
                    component.set("v.isAutoRenewable", "0");
                }
                
                console.log('autorenewflag--->'+component.get("v.subscriptionService.subscriptionSingleItem.subscription.autoRenew"));
                console.log("autorenewflag "+returnValue.subscriptionSingleItem.subscription.autoRenew);
                
                for(var subservice in returnValue.subscriptionSingleItem) {
                    if(returnValue.subscriptionSingleItem.hasOwnProperty(subservice)){
                        component.set("v.productComponentId", returnValue.subscriptionSingleItem.subscription.productComponent);
                        console.log('productComponentId-->'+component.get("v.productComponentId"));
                        
                        component.set("v.productConfigId", returnValue.subscriptionSingleItem.subscription.renewalProductConfiguration);
                        console.log('productConfigId-->'+component.get("v.productConfigId"));
                        
                        console.log('ready to set the profile id and current payment option Id');
                        component.set("v.profileId", returnValue.subscriptionSingleItem.subscription.userPaymentProfile);
                        helper.fireIADPaymentProfileLabelEvent(component, event, helper);
                    }
                }
                
                component.set("v.subscriptionInfoDetails", returnValue.subscriptionInfoDetails);
                
                console.log("subscriptionInfoDetails: ");
                console.log(JSON.stringify(returnValue.subscriptionInfoDetails));
                
                component.set("v.subInfoDetailsSize", returnValue.subscriptionInfoDetails.length);
                
                console.log("subInfoDetailsSize: ");
                console.log(returnValue.subscriptionInfoDetails.length);
                
                component.set("v.lastestSubInfoDetail", returnValue.lastestSubscriptionInfoDetail);
                
                console.log("lastestSubscriptionInfoDetail: ");
                console.log(returnValue.lastestSubscriptionInfoDetail);
                console.log(JSON.stringify(component.get("v.lastestSubInfoDetail")));
                
                if(returnValue.iadServiceMessages)
                {
                    var iadMessages = returnValue.iadServiceMessages;
                    for (var i = 0; i < iadMessages.length; i++) {
                        title = iadMessages[i].msgType; 
                        type = iadMessages[i].msgType;
                        message = iadMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                /*
                if(returnValue.subscriptionSingleItem.subscription.userPaymentProfile){
                    
                }*/
                helper.populatePaymentMethods(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate subscription details: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    fireIADPaymentProfileLabelEvent : function(component, event, helper){
        var iadPayProfile = $A.get("e.c:IADPaymentProfileLabel");
        iadPayProfile.setParams({
            "payProfileId": component.get("v.profileId")
        });
        iadPayProfile.fire(); 
        console.log('event fired successfully');
    },
    
    populatePaymentMethods : function(component, event, helper){
        console.log('ready to populate payment methods');
        var action = component.get("c.populateProfiles");
        action.setParams({
            "customerId" : component.get("v.customerId"),
            "pageType" : "subscription"
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log("state inside populatePaymentMethods: "+state);
            if(state ==="SUCCESS"){
                var returnValue = response.getReturnValue();
                console.log('returnValue: '+JSON.stringify(returnValue));
                var paymentOptions = [];
                var paymentOptionsMap = response.getReturnValue().paymentOptions;
                for ( var key in paymentOptionsMap ) {
                    paymentOptions.push({value:paymentOptionsMap[key], key:key});
                }
                component.set("v.paymentOptions", paymentOptions);
                /*
                if(paymentOptions.length > 0){
                    console.log('paymentOptions[0].key: '+paymentOptions[0].key);
                    component.set("v.currentPaymentOptionId", paymentOptions[0].key);
                }else{
                    component.set("v.currentPaymentOptionId", "none");
                }
                */
                component.set("v.currentPaymentOptionId", 'pp'+component.get("v.profileId"));
                //helper.populateCurrentTerm(component, event, helper);
               // helper.subscriptionRenewalTerms(component, event, helper, false);
               helper.hideSpinner(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate payment method: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },  
    /*
    populateCurrentTerm : function(component, event, helper){
        console.log('ready to populateCurrentTerm');
        console.log(JSON.stringify(component.get("v.lastestSubInfoDetail")));
        var action = component.get("c.processSubscription");
        action.setParams({
            "subId" : component.get("v.subscriptionId"),
            "custId" : component.get("v.customerId"),
            "orderItemId" : component.get("v.orderItemId"),
            "lSID" :  JSON.stringify(component.get("v.lastestSubInfoDetail"))
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log("state inside populateCurrentTerm: "+state);
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
                console.log(JSON.stringify(returnValue));
                component.set("v.currentSubscription", returnValue.subscriptionSingleItemWrapped);
                console.log("currentSubscription: ");
                console.log(JSON.stringify(returnValue.subscriptionSingleItemWrapped));
                //console.log('associatedSFDCRecordId: '+JSON.stringify(returnValue.subscriptionSingleItemWrapped.associatedSFDCRecordId));
                //this.getTermRows(component, event, helper);
                if(returnValue.iadServiceMessages)
                {
                    var iadMessages = returnValue.iadServiceMessages;
                    for (var i = 0; i < iadMessages.length; i++) {
                        title = iadMessages[i].msgType; 
                        type = iadMessages[i].msgType;
                        message = iadMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                this.retrieveOrderNumberFromOrderItemNumber(component, event, helper);
                //helper.hideSpinner(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate current term: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    retrieveOrderNumberFromOrderItemNumber : function(component, event, helper){
        console.log('ready to retrieveOrderNumberFromOrderItemNumber');
        //console.log('Inside retrieveOrderNumberFromOrderItemNumber: ' + index);
        var action = component.get("c.getOrderNumberFromOrderItemNumber");
        console.log("\"subscriptionInfoDetails\" : " + JSON.stringify(component.get("v.subscriptionInfoDetails")));
        var sidList = "{\"subscriptionInfoDetails\" : " + JSON.stringify(component.get("v.subscriptionInfoDetails"))+"}";
        action.setParams({
            "subId"  : component.get("v.subscriptionId"),
            "custId" : component.get("v.customerId"),
            "listOfSubInfoDetails" : sidList,
            "noOfPastSubs" : component.get("v.subInfoDetailsSize")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("state inside retrieveOrderNumberFromOrderItemNumber: "+state);
            if(state === 'SUCCESS'){
                var title;
                var type;
                var message;
                var returnValue = response.getReturnValue();
                component.set("v.subscriptionTerms", returnValue.subscriptionInfoDetailsWrapped);
                //helper.getTermRows(component, event, helper);
                //console.log('subscriptionTerms: '+index);
                console.log(returnValue.subscriptionInfoDetailsWrapped);
                if(returnValue.iadServiceMessages)
                {
                    var iadMessages = returnValue.iadServiceMessages;
                    for (var i = 0; i < iadMessages.length; i++) {
                        title = iadMessages[i].msgType; 
                        type = iadMessages[i].msgType;
                        message = iadMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                helper.subscriptionRenewalTerms(component, event, helper, false);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate previous term: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }            
        });
        $A.enqueueAction(action);
    },
    */
    subscriptionRenewalTerms : function(component, event, helper){
        console.log('ready to get subscriptionRenewalTerms');
         helper.showSpinner(component, event, helper);
        var action = component.get("c.getSubscriptionRenewalTerms");
        action.setParams({
            "subscriptionId"  : component.get("v.subscriptionId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("state inside subscriptionRenewalTerms: "+state);
            if(state === 'SUCCESS'){
                var title;
                var type;
                var message;
                var returnValue = response.getReturnValue();
                component.set("v.subscriptionRenewalTerms", returnValue.subscriptionRenewalTerms);
                console.log(JSON.stringify(returnValue.subscriptionRenewalTerms));
                if(returnValue.iadServiceMessages)
                {
                    var iadMessages = returnValue.iadServiceMessages;
                    for (var i = 0; i < iadMessages.length; i++) {
                        title = iadMessages[i].msgType; 
                        type = iadMessages[i].msgType;
                        message = iadMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                //helper.nextSubscriptionModification(component, event, helper);     
                helper.hideSpinner(component, event, helper);        
                 component.set("v.renewalcall",false);   
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate previous term: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }            
        });
        $A.enqueueAction(action);
    },
    
    nextSubscriptionModification : function(component, event, helper){
        console.log('ready to get subscriptionRenewalTerms');
        helper.showSpinner(component, event, helper);
        var action = component.get("c.getNextSubscriptionModification");
        action.setParams({
            "subscriptionId"  : component.get("v.subscriptionId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("state inside nextSubscriptionModification: "+state);
            if(state === 'SUCCESS'){
                var title;
                var type;
                var message;
                var returnValue = response.getReturnValue();
                console.log('returnValue-->'+JSON.stringify(returnValue));
                
                var scheduledUpgrade = returnValue.scheduledUpgrade.scheduledUpgrade;
                console.log('scheduledUpgrade-->'+JSON.stringify(scheduledUpgrade));
                
                if(scheduledUpgrade){
                    console.log('renewalPackageName-->'+JSON.stringify(scheduledUpgrade.renewalPackageName));
                	component.set("v.nxtSubModification", scheduledUpgrade.renewalPackageName);
                    component.set("v.scheduleId", ""+scheduledUpgrade.id);
                    console.log('schedule Id--->'+scheduledUpgrade.id);
                    if(returnValue.status == 1){
                        component.set("v.isCancellable", false);
                    }else{
                        component.set("v.isCancellable", true);
                    }
                }else{
                    component.set("v.nxtSubModification", "No changes scheduled");
                }                
                
                if(returnValue.iadServiceMessages)
                {
                    var iadMessages = returnValue.iadServiceMessages;
                    for (var i = 0; i < iadMessages.length; i++) {
                        title = iadMessages[i].msgType; 
                        type = iadMessages[i].msgType;
                        message = iadMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                component.set("v.nextsubmod",false);
                helper.hideSpinner(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate previous term: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }            
        });
        $A.enqueueAction(action);
    },
    
    subscriptionUpdate : function(component, event, helper) {
        console.log('ready to subscriptionUpdate');
        component.set("v.profileId", component.get("v.currentPaymentOptionId"));
        var action = component.get("c.updateSubscription");
        action.setParams({
            "subId" : component.get("v.subscriptionId"),
            "renewChoice" : component.get("v.isAutoRenewable"),
            "profileId" : component.get("v.currentPaymentOptionId"),//component.get("v.profileId"),
            "productComponentId" : component.get("v.productComponentId"),
            "productConfigId" : component.get("v.productConfigId"),
            "extendedPrice" : component.get("v.extendedPrice")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log("state inside subscriptionUpdate: "+state);
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
                console.log("return value: ");
                component.set("v.isNotUpdatable", true);
                var editSubscription = component.find("editSubscription");
        		$A.util.removeClass(editSubscription, "slds-hide");
                helper.fireIADPaymentProfileLabelEvent(component, event, helper);
                if(returnValue.iadServiceMessages)
                {
                    var iadMessages = returnValue.iadServiceMessages;
                    for (var i = 0; i < iadMessages.length; i++) {
                        title = iadMessages[i].msgType; 
                        type = iadMessages[i].msgType;
                        message = iadMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                helper.hideSpinner(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate previous term: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }             
        });
        $A.enqueueAction(action);
    },
    
    populateProratedRefundAmount : function(component, event, helper){
        console.log('ready to populateProratedRefundAmount');
      	var action = component.get("c.populateProratedRefund");
        action.setParams({
            "subId"  : component.get("v.subscriptionId"),
            "custId" : component.get("v.customerId"),
            "isPartial" : component.get("v.isPartialCancel"),
            "currentOrderItemId" : component.get("v.currentOrderItemId")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log("state inside populateProratedRefundAmount: "+state);
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
				console.log(JSON.stringify(returnValue));
                component.set("v.proratedDateAmountMap", returnValue.dayToProRatedAmount);
                var iadMessages = returnValue.iadServiceMessages;                    
                if(iadMessages.length > 0)
                {
                    for (var i = 0; i < iadMessages.length; i++) {
                        title = iadMessages[i].msgType; 
                        type = iadMessages[i].msgType;
                        message = iadMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                    component.set("v.isCancellationSectionHidden", true);
                }     
                helper.hideSpinner(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate prorated term rates: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }  
        });
        $A.enqueueAction(action);
    },
    
    cancelSubRenewal : function(component, event, helper){
        console.log('ready to cancelSubRenewal');
      	var action = component.get("c.cancelSubscriptionRenewal");
        action.setParams({
            "refundAmount" : component.get("v.refundAmount"),
            "subId"  : component.get("v.subscriptionId"),
            "custId" : component.get("v.customerId"),
            "isPartial" : component.get("v.isPartialCancel"),
            "orderItemId" : component.get("v.currentOrderItemId"),
            "subscriptionEndDate" : component.get("v.subEndDate"),
            "comments" : component.get("v.comments")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log("state inside cancelSubRenewal: "+state);
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
				console.log(JSON.stringify(returnValue));
                
                var renewalOrderId = returnValue.renewalOrderId;
                component.set("v.renewalOrderId", renewalOrderId);
                console.log('renewalOrderId: '+renewalOrderId);
                
                var isCancelSuccess = returnValue.isCancelSuccess;
                console.log('isCancelSuccess: '+isCancelSuccess);
                
                if(isCancelSuccess)
                {
                    component.set("v.isCancelSuccess", isCancelSuccess);
                }
                if(returnValue.iadServiceMessages)
                {
                    var iadMessages = returnValue.iadServiceMessages;
                    for (var i = 0; i < iadMessages.length; i++) {
                        title = iadMessages[i].msgType; 
                        type = iadMessages[i].msgType;
                        message = iadMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                //helper.hideSpinner(component, event, helper);
                helper.populateDefaultValues(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to cancel subscription: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            } 
        });
        $A.enqueueAction(action);
    },    
    
    openTab : function(component, event, helper, taburl) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: taburl,        
            focus: true
        }).catch(function(error) {
            console.log('Error: '+error);
        });
    },
    
    openSubTab : function(component, event, helper, subtaburl, tabLabel, tabIcon){
        console.log('path url: '+window.location.href);
        var parentTabUrl;
        var isContact = component.get("v.orderRecordId").startsWith("003");
        console.log('isContact-->'+isContact);
        
        if(isContact) {
            parentTabUrl= '/lightning/r/Contact/'+component.get("v.orderRecordId")+'/view';
        }  
        else{
            parentTabUrl= '/lightning/r/Order__c/'+component.get("v.orderRecordId")+'/view';
        }
        
        console.log('parentTabUrl: '+parentTabUrl);
        console.log('subtaburl: '+subtaburl);
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.openTab({
            url: parentTabUrl,
            focus: true
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
        $A.util.addClass(spinner, "slds-show");
        
    },
})