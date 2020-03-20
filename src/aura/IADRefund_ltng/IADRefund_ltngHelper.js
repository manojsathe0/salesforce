({
    populateDefaultValues: function (component, event, helper) {
        console.log('im ready to populate default items');
        var action = component.get("c.initCtrl");
        action.setParams({
            "amount": component.get("v.amount"),
            "orderId": component.get("v.orderId"),
            "customerId": component.get("v.customerId"),
            "invokingPage": component.get("v.invokingPage"),
            "invokingPageId": component.get("v.invokingPageId"),
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            //console.log('state inside populateDefaultValues: '+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var refundReasons = [];
                var refundReasonMap = response.getReturnValue().refundReasons;
                for (var key in refundReasonMap) {
                    refundReasons.push({ value: key, key: refundReasonMap[key] });
                }
                component.set("v.refundReasons", refundReasons);
                var statesvalue = [];
                var statesmap = response.getReturnValue().states;
                for (var key in statesmap) {
                    statesvalue.push({ value: key, key: statesmap[key] });
                }
                //statesvalue.sort(function(a, b){return a.key- b.key});

                component.set("v.statelist", statesvalue);
                console.log('the states' + JSON.stringify(statesvalue));

                var manualrefundReasons = [];
                var manualrefundReasonMap = response.getReturnValue().manualrefundReasons;
                for (var key in manualrefundReasonMap) {
                    manualrefundReasons.push({ value: key, key: manualrefundReasonMap[key] });
                }

                if (manualrefundReasons.length > 0 && component.get("v.invokingPage") == 'StoreCreditToMC') {
                    component.set("v.manualcheckreasonid", manualrefundReasons[0].key);
                }

                component.set("v.manualrefundReasons", manualrefundReasons);
                var ordercontact = response.getReturnValue().ordercontact;
                if (ordercontact != null) {
                    component.set("v.firstname", ordercontact.Contact__r.FirstName);
                    component.set("v.lastname", ordercontact.Contact__r.LastName);
                    component.set("v.address", ordercontact.Contact__r.MailingStreet);
                    component.set("v.city", ordercontact.Contact__r.MailingCity);
                    component.set("v.zipcode", ordercontact.Contact__r.MailingPostalCode);
                    component.set("v.currentstate", response.getReturnValue().statecode);
                }

                if (refundReasons.length > 0) {
                    console.log('refundReasons[0].key: ' + refundReasons[0].key);
                    component.set("v.currentRefundReasonId", refundReasons[0].key);
                }
                component.set("v.notificationEmail", result.email);
                if (component.get("v.invokingPage") != 'StoreCredit' && component.get("v.invokingPage") != 'StoreCreditToMC') {
                    helper.populateRefundMethods(component, event, helper);
                }
                else {
                    helper.hideSpinner(component, event, helper);
                }
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate refund reasons: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    populateRefundMethods: function (component, event, helper) {
        console.log('ready to populate refund methods');
        var action = component.get("c.populateRefundOptions");
        action.setParams({
            "customerId": component.get("v.customerId"),
            "pageType": "MakeRefund"
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            //console.log("state inside populateRefundOptions: "+state);
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                //console.log('returnValue: '+JSON.stringify(returnValue));
                var refundOptions = [];
                var refundOptionsMap = response.getReturnValue().paymentOptions;
                for (var key in refundOptionsMap) {
                    refundOptions.push({ value: refundOptionsMap[key], key: key });
                }
                component.set("v.refundOptions", refundOptions);
                component.set("v.currentRefundOptionId", "0");
                console.log("currentRefundOptionId: " + component.get("v.currentRefundOptionId"));
                helper.populateRefundTransactions(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate refund options: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    populateRefundTransactions: function (component, event, helper) {
        console.log('ready to populateRefundTransactionsssss');
        var action = component.get("c.getPaymentProfilesByUserId");
        action.setParams({
            "customerId": component.get("v.customerId"),
            "orderNumber": component.get("v.orderId")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log("state inside populateRefundTransactions: " + state);
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                //console.log('returnValue: '+JSON.stringify(returnValue));
                console.log('pastPaymentOptions: ' + JSON.stringify(response.getReturnValue().pastPaymentOptions));
                var pTransactionToProfileId = response.getReturnValue().pTransactionToProfileId;
                console.log('pTransactionToProfileId: ' + JSON.stringify(response.getReturnValue().pTransactionToProfileId));
                var pTransactionToAmount = response.getReturnValue().pTransactionToAmount;
                console.log('pTransactionToAmount: ' + JSON.stringify(response.getReturnValue().pTransactionToAmount));
                var refundTransactions = [];
                var refundTransactionsMap = response.getReturnValue().pastPaymentOptions;
                for (var key in refundTransactionsMap) {
                    console.log('key: ' + key);
                    refundTransactions.push({ value: refundTransactionsMap[key], key: key });
                }
                console.log("refundTransactions: " + JSON.stringify(refundTransactions));
                component.set("v.refundTransactions", refundTransactions);
                component.set("v.currentRefundTransactionOptionId", "0");
                component.set("v.pTransactionToProfileId", pTransactionToProfileId);
                component.set("v.pTransactionToAmount", pTransactionToAmount);
                console.log('refund transaction id: ' + component.get("v.currentRefundTransactionOptionId"));

                var iadServiceMessages = response.getReturnValue().messages;
                console.log('iadServiceMessages: ' + iadServiceMessages);
                if (iadServiceMessages) {
                    for (var i = 0; i < iadServiceMessages.length; i++) {
                        title = iadServiceMessages[i].msgType;
                        type = iadServiceMessages[i].msgType;
                        message = iadServiceMessages[i].message;
                    }
                    helper.showToast(component, event, helper, title, type, message);
                }

                helper.retrieveOrderBalanceByOrderId(component, event, helper, true);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate refund transactions: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    postRefund: function (component, event, helper) {
        /*<!--    STORY B-39538 -->*/
        var approvalNeed = this.handleApproval(component);

        if (approvalNeed === true) {
            return;
        }

        /*<!--    STORY B-39538 -->*/
        console.log('inside post refund' + component.get("v.storecreditId"));
        var action = component.get("c.processRefund");
        var selectedProfileId = component.get("v.currentRefundOptionId");
        if (selectedProfileId) {
            selectedProfileId = selectedProfileId.replace("pp", "");
        }
        console.log("selectedProfileId: " + selectedProfileId);
        console.log("currentRefundTransactionOptionId: " + component.get("v.currentRefundTransactionOptionId"));
        console.log("orderNumber: " + component.get("v.orderId"));
        console.log("customerId: " + component.get("v.customerId"));
        action.setParams({
            "amountDue": component.get("v.amountDue"),
            "processAmount": component.get("v.processTotal"),
            "orderNumber": component.get("v.orderId"),
            "customerId": component.get("v.customerId"),
            "profileId": selectedProfileId,
            "comments": component.get("v.comments"),
            "selectedReasonForRefund": component.get("v.currentRefundReasonId"),
            "email": component.get("v.notificationEmail"),
            "selectedPaymentTransaction": component.get("v.currentRefundTransactionOptionId"),
            "invokingPage": component.get("v.invokingPage"),
            "storeCreditId": component.get("v.storecreditId"),
            "manualcheck": component.get("v.currentRefundOptionId"),
            "address": component.get("v.address"),
            "firstname": component.get("v.firstname"),
            "lastname": component.get("v.lastname"),
            "city": component.get("v.city"),
            "zipcode": component.get("v.zipcode"),
            "manualcheckreasonid": component.get("v.manualcheckreasonid"),
            "state": component.get("v.currentstate"),
            "approvedBy": component.get("v.managerApprovedBy") // STORY B-39538
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = action.getState();
            console.log('state inside post refund: ' + state);
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log('returnValue: ' + JSON.stringify(returnValue));
                var isRefundProcessed = response.getReturnValue().isRefundProcessed;
                var messages = response.getReturnValue().messages;
                if (messages && messages.length > 0) {
                    for (var i = 0; i < messages.length; i++) {
                        title = messages[i].msgType;
                        type = messages[i].msgType;
                        message = messages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                if (component.get("v.invokingPage") != 'StoreCredit' && component.get("v.invokingPage") != 'StoreCreditToMC') {
                    helper.retrieveOrderBalanceByOrderId(component, event, helper, false);
                }
                else {
                    if (isRefundProcessed) {
                        component.set("v.isRefundProcessed", isRefundProcessed);
                        component.set("v.processTotal", 0.00);
                        component.set("v.amount", 0.00);
                        component.set("v.amountDue", 0.00);
                        component.set("v.amtCheckbox", false);
                    }
                    helper.hideSpinner(component, event, helper);
                }
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to post refund: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        })
        $A.enqueueAction(action);
    },

    retrieveOrderBalanceByOrderId: function (component, event, helper, onload) {
        console.log('im ready to retrieve order balance');
        var action = component.get("c.getOrderBalanceByOrderId");
        action.setParams({
            "orderNumber": component.get("v.orderId")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = action.getState();
            console.log('state inside retrieveOrderBalanceByOrderId: ' + state);
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                var amount = response.getReturnValue().amount;
                var amountDue = response.getReturnValue().amountDue;
                console.log('returnValue: ' + JSON.stringify(returnValue));
                component.set("v.amountDue", amountDue);
                component.set("v.amount", amount);
                if (onload) {
                    component.set("v.processTotal", amount);
                    component.set("v.amtCheckbox", true);
                } else {
                    component.set("v.processTotal", 0.00);
                    component.set("v.otherAmount", 0.00);
                    component.set("v.amtCheckbox", false);
                    component.set("v.othrAmtCheckbox", true);
                }

                var messages = response.getReturnValue().messages;
                if (messages && messages.length > 0) {
                    for (var i = 0; i < messages.length; i++) {
                        title = messages[i].msgType;
                        type = messages[i].msgType;
                        message = messages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }

                helper.hideSpinner(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to retrieve order balance: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        })
        $A.enqueueAction(action);
    },

    openSubTab: function (component, event, helper, subtaburl, tabLabel, tabIcon) {
        var parentTabUrl = '/lightning/r/Order__c/' + component.get("v.invokingPageId") + '/view';
        console.log('parentTabUrl: ' + parentTabUrl);
        console.log('subtaburl: ' + subtaburl);

        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: parentTabUrl,
            focus: false
        }).then(function (response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: subtaburl,
                focus: true
            }).then(function (response) {
                console.log('focused tab id: ' + response);
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: tabLabel
                }).then(function (response) {
                    console.log('the tab Id to set label' + response.tabId);
                    workspaceAPI.setTabIcon({
                        tabId: response.tabId,
                        icon: tabIcon,
                        iconAlt: tabIcon
                    });
                }).catch(function (error) {
                    console.log('Error: ' + error);
                });
            }).catch(function (error) {
                console.log('Error: ' + error);
            });
        })
            .catch(function (error) {
                console.log('Error: ' + error);
            });
    },

    showToast: function (component, event, helper, title, type, message) {
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

    hideSpinner: function (component, event, helper) {
        console.log('inside hide spinner method');
        var spinner = component.find('mySpinner');
        $A.util.addClass(spinner, "slds-hide");
    },

    showSpinner: function (component, event, helper) {
        console.log('inside show spinner method');
        var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-hide");
    },
    /*<!--    STORY B-39538 -->*/
    handleMCSuccessHelper: function (component, event, helper) {
        component.set("v.openModal", false);
        var msg = event.getParam('userName') || '';
        if (!$A.util.isEmpty(msg)) {
            component.set("v.managerApprovedBy", msg);
            this.postRefund(component, event, helper);
        } else {
            component.set("v.managerApprovedBy", null);
        }
    },
    handleApproval: function (component) {
        if (component.get("v.manualsection") === true && $A.util.isEmpty(component.get("v.managerApprovedBy"))) {
            component.set("v.openModal", true);
            return true;
        }
        return false;
    },
    handleMCCloserHelper: function (component) {
        component.set("v.openModal", false);
        component.set("v.managerApprovedBy", null);
    },
    /*<!--    STORY B-39538 -->*/
})