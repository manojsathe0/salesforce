({
    doInitRefund: function (component, event, helper) {
        console.log('inside refunddddd component init method');
        window.setTimeout(
            $A.getCallback(
                function () {
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.getFocusedTabInfo().then(function (response) {
                        console.log('tab info: ' + response);
                        console.log('subtab id: ' + response.tabId);
                        workspaceAPI.getTabURL({
                            tabId: response.tabId
                        }).then(function (response) {
                            console.log('subTabUrl: ' + response);
                            var subTabUrl = response;
                            console.log('subTabUrl: subTabUrl.includes("?")' + subTabUrl.includes("?"));
                            if (response.includes("?")) {
                                var sURLAndParams = response.split('?');
                                console.log('sURLAndParams: ' + sURLAndParams);
                                var sParams = sURLAndParams[1].split('&');
                                console.log('sParams: ' + sParams);
                                var sParameterName;
                                var amount;
                                var orderId;
                                var customerId;
                                var invokingPage;
                                var invokingPageId;
                                var storecreditId;

                                for (var i = 0; i < sParams.length; i++) {
                                    sParameterName = sParams[i].split('='); //to split the key from the value.
                                    console.log('sParameterName: ' + sParameterName);
                                    if (sParameterName[0] === 'amount') {
                                        amount = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                    } else if (sParameterName[0] === 'orderId') {
                                        orderId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                    } else if (sParameterName[0] === 'customerId') {
                                        customerId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                    } else if (sParameterName[0] === 'invokingPage') {
                                        invokingPage = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                    } else if (sParameterName[0] === 'invokingPageId') {
                                        invokingPageId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                    } else if (sParameterName[0] === 'storecreditId') {
                                        storecreditId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                    }
                                }

                                if (amount && amount.includes("-")) {
                                    amount = amount.replace("-", "");
                                }
                                console.log('im ready to invoke populate default value method');
                                console.log('invokingPage--->' + invokingPage);
                                console.log('storecreditId--->' + storecreditId);
                                component.set("v.orderId", orderId);
                                component.set("v.customerId", customerId);
                                component.set("v.invokingPage", invokingPage);
                                component.set("v.invokingPageId", invokingPageId);
                                component.set("v.storecreditId", storecreditId);

                                if (component.get("v.invokingPage") == 'StoreCredit' || component.get("v.invokingPage") == 'StoreCreditToMC') {
                                    var refundTransactionId = component.find("refundTransactionId");
                                    $A.util.addClass(refundTransactionId, "slds-hide");
                                    $A.util.removeClass(refundTransactionId, "slds-form-element__row");

                                    var addOthrAmt = component.find("addOtherAmount");
                                    $A.util.addClass(addOthrAmt, "slds-hide");

                                    var refundMethodId = component.find("refundMethodId");
                                    $A.util.addClass(refundMethodId, "slds-hide");
                                    $A.util.removeClass(refundMethodId, "slds-form-element__row");

                                    component.set("v.amountDue", amount);
                                    component.set("v.amount", amount);
                                    component.set("v.processTotal", amount);
                                    component.set("v.amtCheckbox", true);

                                    if (component.get("v.invokingPage") == 'StoreCreditToMC') {
                                        component.set('v.manualsection', true);
                                    }
                                }
                                helper.populateDefaultValues(component, event, helper);
                            }
                        });
                    })
                        .catch(function (error) {
                            console.log(error);
                        });

                }
            ),
            1000
        );
    },

    setOrUnsetProcessTotalToAmount: function (component, event, helper) {
        var amount = component.get("v.amount");
        console.log('checkbox: ' + component.get("v.amtCheckbox"));
        if (component.get("v.amtCheckbox")) {
            component.set("v.processTotal", amount);
            component.set("v.othrAmtCheckbox", false);
        } else {
            component.set("v.processTotal", 0.00);
        }
    },

    setOrUnsetProcessTotalToOtherAmount: function (component, event, helper) {
        var otherAmount = component.get("v.otherAmount");
        console.log('other amt: ' + component.get("v.otherAmount"));
        if (component.get("v.othrAmtCheckbox")) {
            console.log('im setting process total to other amount');
            component.set("v.processTotal", otherAmount);
            component.set("v.amtCheckbox", false);
        } else {
            console.log('im setting process total to zero');
            component.set("v.processTotal", 0.00);
        }
    },

    hideAddOtherAmtLinkAndShowOthrAmt: function (component, event, helper) {
        console.log('inside hideAddOtherAmtLinkAndShowOthrAmt method');
        var addOthrAmt = component.find("addOtherAmount");
        $A.util.addClass(addOthrAmt, "slds-hide");

        var otherAmount = component.find("otherAmount");
        $A.util.removeClass(otherAmount, "slds-hide");

        component.set("v.amtCheckbox", false);
        component.set("v.othrAmtCheckbox", true);
        component.set("v.processTotal", 0.00);
    },

    hideUnhideEditButton: function (component, event, helper) {
        var editbutton;
        var profileId = component.get("v.currentRefundOptionId");
        console.log('profileId: ' + profileId);
        console.log(profileId.includes("refundToStoreCredit"));
        console.log(profileId.includes("newPayment"));
        if (profileId.includes("refundToStoreCredit") || profileId.includes("newPayment") || profileId.includes("manualCheck")) {
            editbutton = component.find("editbutton");
            $A.util.addClass(editbutton, "slds-hide");
        } else {
            editbutton = component.find("editbutton");
            $A.util.removeClass(editbutton, "slds-hide");
        }

        if (profileId == 'newPayment') {
            var subtaburl = '/lightning/n/AddNewPayment?customerid=' + component.get("v.customerId") + '&orderid=' + component.get("v.orderId") + '&orderRecordId=' + component.get("v.invokingPageId");
            var tabLabel = 'AddNewPayment';
            var tabIcon = 'custom17';
            helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
        }

        if (profileId == 'refundinstallment') {
            var subtaburl = '/lightning/n/Refund_To_Installment?amount=' + component.get("v.amount") + '&orderid=' + component.get("v.orderId") + '&orderRecordId=' + component.get("v.invokingPageId");
            var tabLabel = 'Installmentrefund';
            var tabIcon = 'custom17';
            helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
        }

        if (profileId == 'manualCheck') {
            component.set('v.manualsection', true);
        }
        if (profileId != 'manualCheck') {
            component.set('v.manualsection', false);
        }
    },

    setRefundMethod: function (component, event, helper) {
        var currentRefundId = component.get("v.currentRefundTransactionOptionId");
        var pTransactionToProfileIdMap = component.get("v.pTransactionToProfileId");
        var refundId;
        if (currentRefundId && currentRefundId != "0") {
            refundId = pTransactionToProfileIdMap[currentRefundId];
        }
        console.log(JSON.stringify(component.get("v.pTransactionToProfileId")));
        console.log('refundId: ' + refundId);
        if (refundId && refundId != '0') {
            component.set("v.currentRefundOptionId", 'pp' + refundId);
        } else {
            console.log("setting refund id to zero");
            component.set("v.currentRefundOptionId", '0');
        }
        console.log(refundId);
    },

    validateFormAndPostRefund: function (component, event, helper) {
        console.log('inside validateFormAndPostRefund');
        var validPaymentForm = component.find('refundForm').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (validPaymentForm) {
            var title;
            var type;
            var message;
            var processTotal = component.get("v.processTotal");
            console.log('processTotal: ' + processTotal);
            var dueAmount = component.get("v.amountDue");
            console.log('amount due: ' + dueAmount);
            var refundTransactId = component.get("v.currentRefundTransactionOptionId");
            console.log('refundTransactId: ' + refundTransactId);
            var profileId = component.get("v.currentRefundOptionId");
            console.log('profileId: ' + profileId);
            if (processTotal <= 0 && processTotal < dueAmount) {
                title = "Error!";
                type = "error";
                message = 'Not a valid amount.';
                helper.showToast(component, event, helper, title, type, message);
            }
            else if (processTotal > dueAmount) {
                title = "Error!";
                type = "error";
                message = 'Process amount is greater than amount due.';
                helper.showToast(component, event, helper, title, type, message);
            } else if (refundTransactId == "0" && (profileId != "refundToStoreCredit" && profileId != "newPayment")) {
                title = "Error!";
                type = "error";
                message = 'Please select a transaction for refund and a refund method.';
                helper.showToast(component, event, helper, title, type, message);
            } else if (profileId == "0") {
                title = "Error!";
                type = "error";
                message = 'Please select a refund method.';
                helper.showToast(component, event, helper, title, type, message);
            } else if (refundTransactId && refundTransactId != "0" && component.get("v.pTransactionToAmount")) {
                var pasTransactionMap = component.get("v.pTransactionToAmount");
                var pastTransactionAmount = pasTransactionMap[refundTransactId];
                console.log('processTotal: ' + processTotal);
                console.log('pastTransactionAmount-->: ' + parseFloat(pastTransactionAmount));
                console.log(processTotal > parseFloat(pastTransactionAmount));
                if (processTotal > parseFloat(pastTransactionAmount)) {
                    title = "Error!";
                    type = "error";
                    message = 'Refund amount is greater than the selected transaction. Please use Other Amount to refund the $' + pastTransactionAmount + ' value. ';
                    helper.showToast(component, event, helper, title, type, message);
                } else {
                    helper.showSpinner(component, event, helper);
                    helper.postRefund(component, event, helper);
                }
            } else if (component.get("v.invokingPage") == 'StoreCredit' || component.get("v.invokingPage") == 'StoreCreditToMC') {
                helper.showSpinner(component, event, helper);
                helper.postRefund(component, event, helper);
            } else {
                title = "Error!";
                type = "error";
                message = 'Something went wrong. Contact tech support for assistance!';
                helper.showToast(component, event, helper, title, type, message);
            }
        }
    },

    openEditPayment: function (component, event, helper) {
        var profileId = component.get("v.currentRefundOptionId");
        console.log('profileId: ' + profileId);
        var subtaburl = '/lightning/n/EditPayment?profileid=' + profileId.substring(2);
        var tabLabel = 'EditPaymentPage';
        var tabIcon = 'custom17';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    },

    closeFocusedTab: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({ tabId: focusedTabId });
        })
            .catch(function (error) {
                console.log(error);
            });
    },
    /*<!--    STORY B-39538 -->*/
    handleMCCloser: function (component, event, helper) {
        helper.handleMCCloserHelper(component);
    },
    handleMCSuccess: function (component, event, helper) {
        helper.handleMCSuccessHelper(component, event, helper);
    }
    /*<!--    STORY B-39538 -->*/
})