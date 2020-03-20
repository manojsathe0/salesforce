({
    raRenewalTabInfo: function (component, event, helper) {
        console.log('inside raRenewalTabInfo component init method');
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            console.log('tab info: ' + response);
            console.log('subtab id: ' + response.tabId);
            workspaceAPI.getTabURL({
                tabId: response.tabId
            }).then(function (response) {
                console.log('subTabUrl: ' + response);
                if (response.includes("?")) {
                    var sURLAndParams = response.split('?');
                    console.log('sURLAndParams: ' + sURLAndParams);
                    var sParams = sURLAndParams[1].split('&');
                    console.log('sParams: ' + sParams);
                    var sParameterName;
                    var orderId;
                    var customerId;
                    var orderRecordId;
                    var parentTabId;
                    for (var i = 0; i < sParams.length; i++) {
                        sParameterName = sParams[i].split('='); //to split the key from the value.
                        console.log('sParameterName: ' + sParameterName);
                        if (sParameterName[0] === 'orderId') {
                            orderId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                        } else if (sParameterName[0] === 'customerId') {
                            customerId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                        } else if (sParameterName[0] === 'orderRecordId') {
                            orderRecordId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                        } else if (sParameterName[0] === 'parentTabId') {
                            parentTabId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                        }
                    }
                    component.set("v.orderNumber", orderId);
                    component.set("v.customerId", customerId);
                    component.set("v.orderRecordId", orderRecordId);
                    component.set("v.parentTabId", parentTabId);
                    if (orderId) {
                        console.log('im ready to load the order for renewals');
                        helper.loadData(component, event, helper);
                    }
                }
            })
                .catch(function (error) {
                    console.log('error loading the order');
                    console.log(error);
                });
        })
            .catch(function (error) {
                console.log(error);
            });
    },


    loadData: function (component, event, helper) {
        console.log('inside loadData: ' + component.get("v.orderRecordId"));
        var action = component.get("c.getOrderByOrderId");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "orderNumber": component.get("v.orderNumber")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state inside loadData: ' + state);
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                var modifiedOrderItemWrappers = '';

                component.set("v.orderWrapper", returnValue);
                console.log('<----returnValue Order Wrapper---->');
                console.log(JSON.stringify(returnValue));
                console.log('true if --->' + (JSON.stringify(returnValue)).includes("Registered Agent Service"));
                component.set("v.isRA", (JSON.stringify(returnValue)).includes("Registered Agent Service"));
                component.set("v.orderItemIdToProductConfigurationId", returnValue.orderItemIdToProductConfigurationId);
                component.set("v.orderItemIdToProductName", returnValue.orderItemIdToProductName);
                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if (exceptionMessages) {
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType;
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }

                this.getOrderBalanceDetails(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate order details: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    getOrderBalanceDetails: function (component, event, helper) {
        console.log('inside getOrderBalanceDetails');
        var action = component.get("c.getOrderBalanceByOrderId");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "orderNumber": component.get("v.orderNumber")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state inside getOrderBalanceDetails: ' + state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.orderBalanceWrapper", result);

                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if (exceptionMessages) {
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType;
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }

                this.getOrderDetails(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate order balance: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    getOrderDetails: function (component, event, helper) {
        console.log('inside getOrderDetails');
        var action = component.get("c.init");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "orderNumber": component.get("v.orderNumber")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.ctrl", result);

                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if (exceptionMessages) {
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType;
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }

                this.getOrderTags(component, event, helper, true);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate order details: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    getOrderTags: function (component, event, helper, isOnload) {
        console.log('im inside getOrderTags');
        var action = component.get("c.getOrderTags");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "orderNumber": component.get("v.orderNumber")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state inside getOrderTags: ' + state);
            if (state == "SUCCESS") {
                var returnValue = response.getReturnValue().orderTagMap;
                console.log('Order tag map: ' + JSON.stringify(returnValue));
                var orderTags = [];
                for (var key in returnValue) {
                    var value = returnValue[key];
                    orderTags.push({ value: key, key: value });
                }
                component.set("v.theOrderTagList", orderTags);

                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if (exceptionMessages) {
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType;
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                if (isOnload) {
                    this.getShipmentsByOrderId(component, event, helper);
                }
                else {
                    this.toggleSpinner(component, event, helper);
                }
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate order tags: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    getShipmentsByOrderId: function (component, event, helper) {
        console.log('im inside getShipmentsByOrderId');
        var action = component.get("c.getShipmentsByOrderId");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "orderNumber": component.get("v.orderNumber")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state inside getShipmentsByOrderId: ' + state);
            if (state == "SUCCESS") {
                var result = response.getReturnValue().finalOrderItemShipmentsMap;
                console.log('shipment map:----> ' + result);
                console.log(JSON.stringify(result));
                var shipments = [];
                for (var key in result) {
                    var value = result[key];
                    shipments.push({ value: value, key: key });
                }
                component.set("v.theOrderItemShipments", shipments);
                console.log('theOrderItemShipments--->');
                console.log(JSON.stringify(shipments));
                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if (exceptionMessages) {
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType;
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }

                this.toggleSpinner(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate shipment details: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    deleteOT: function (component, event, helper) {
        var action = component.get("c.deleteOrderTags");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "tagName": event.target.dataset.ordertag,
            "orderNumber": component.get("v.orderNumber")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state == "SUCCESS") {
                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if (exceptionMessages) {
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType;
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                this.getOrderTags(component, event, helper, false);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to delete order tag: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    createOT: function (component, event, helper) {
        var action = component.get("c.createOrderTags");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "tagName": event.target.value,
            "orderNumber": component.get("v.orderNumber")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state == "SUCCESS") {
                this.getOrderTags(component, event, helper, false);
                event.target.value = '';
                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if (exceptionMessages) {
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType;
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to create order tag: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    getOrderHistory: function (component, event, helper) {
        console.log("Element");
        console.log(component.find("orderHistory").getElement().style);
        console.log(component.find("orderHistory").getElement().style.display);
        console.log(component.find("orderHistory").getElement().style.marginLeft);
        var orderHistory = component.find('orderHistory');
        console.log(orderHistory);
        console.log('orderHistory style: ');
        console.log(JSON.stringify(component.get("v.orderItemIdToProductName")));
        var action = component.get("c.populateOrderHistory");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "orderNumber": component.get("v.orderNumber"),
            "orderItemIdToPdtNameMap": component.get("v.orderItemIdToProductName")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.theOrderHistory", result);
                console.log(event);
                $A.util.removeClass(orderHistory, 'hideOrderHistory');
                $A.util.addClass(orderHistory, 'showOrderHistory');

                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if (exceptionMessages) {
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType;
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }

                this.toggleSpinner(component, event, helper);
            }
            else {
                var title = "Error";
                var type = "error";
                var message = "An error occured when trying to get OrderHistory: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    populateActionItems: function (component, event, helper) {
        console.log('yo yo: populateActionItems');
        var orderItemDiv = component.find('orderItemDiv');
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');
        var orderItemId = event.currentTarget.dataset.orderitemid;
        var actionType = component.get("v.actionType");
        console.log('actionType---->' + actionType);
        var action = component.get("c.populateActionItemsByOrderItemId");
        action.setParams({
            "orderItemId": orderItemId,
            "actionType": actionType,
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state: ' + state);
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log('returnValue: ' + JSON.stringify(returnValue));

                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                console.log('exceptionMessages: ' + JSON.stringify(exceptionMessages));

                if ($A.util.isEmpty(actionType)) {
                    if (returnValue.currentActionItems.length > 0) {
                        component.set("v.actionItemsWrapper", returnValue.currentActionItems);
                        var left = event.pageX - 926;
                        orderItemDiv.getElement().style.left = left + 'px';
                        var top = event.pageY;
                        top = event.pageY - 167;
                        console.log('top after------>' + top);
                        orderItemDiv.getElement().style.top = top + 'px';
                        orderItemDiv.getElement().style.display = 'block';
                    } else {
                        orderItemDiv.getElement().style.display = 'none';
                    }
                    console.log('orderItemDiv.getElement().scrollTop: ' + orderItemDiv.getElement().scrollTop);
                }
                else if (actionType == 'changePackage') {
                    component.set("v.availablePackagesWrapper", returnValue.currentActionItems);
                    var availablePackages = component.find("availDropdown");
                    availablePackages.getElement().style.display = 'block';
                }
                else if (actionType == 'addItem') {
                    component.set("v.newOrderItemsWrapper", returnValue.currentActionItems);
                    var newOrderItems = component.find("addNewDropdown");
                    newOrderItems.getElement().style.display = 'block';
                }
                //var empty = '';
                component.set("v.productConfigurationIdToActionItem", returnValue.productConfigurationIdToActionItem);
                //component.set("v.actionType", empty);
                component.set("v.actionType", "");

                if (exceptionMessages) {
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType;
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                this.toggleSpinner(component, event, helper);
            }
            else {
                console.log('Error when trying to populate action items: Please try again!');
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate action items: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
            console.log('yo yo: End of populateActionItems');
        });
        $A.enqueueAction(action);
    },

    createMiscellaneousItems: function (component, event, helper) {
        var action = component.get("c.createMiscItem");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "itemQuantity": component.get("v.itemQuantity"),
            "itemPricePerUnit": component.get("v.itemPricePerUnit"),
            "itemDescription": component.get("v.itemDescription"),
            "orderNumber": component.get("v.orderNumber")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state == "SUCCESS") {
                var returnValue = response.getReturnValue().modifiedOrderItemWrappers;
                var modifiedItems = component.get("v.theModifiedOrderItemWrappers");
                var newItemJsonArray;
                console.log('resturn value inside misc item:');
                console.log(JSON.stringify(returnValue));
                if (returnValue.length > 0) {
                    console.log('ready to add a new product line to the list of modified items');
                    newItemJsonArray = { 'productName': returnValue[0].productName, 'processingOrderId': returnValue[0].processingOrderId, 'orderItemId': returnValue[0].orderItemId, 'dateTimeCreatedInString': returnValue[0].dateTimeCreatedInString, 'modificationType': returnValue[0].modificationType };
                }
                if (modifiedItems.length > 0 && newItemJsonArray) {
                    modifiedItems.push(newItemJsonArray);
                } else {
                    modifiedItems = returnValue;
                }
                component.set("v.theModifiedOrderItemWrappers", modifiedItems);
                this.loadData(component, event, helper);
                this.hideAvailablePackagesOrderItemsAndMiscItemDlg(component, event, helper);
                this.closeActionItemsPopover(component, event, helper);

                console.log('isNewOrderAdded-->' + response.getReturnValue().isNewOrderAdded)
                if (response.getReturnValue().isNewOrderAdded) {
                    console.log('ready to Open renewal order: ' + response.getReturnValue().isNewOrderAdded);
                    var orderNumber = response.getReturnValue().newOrderId;
                    var ctrlRef = component.get("v.ctrl");
                    var customerId;
                    if (component.get("v.customerId")) {
                        customerId = component.get("v.customerId");
                    } else {
                        customerId = ctrlRef.customerId;
                    }
                    var subtaburl = '/lightning/n/RA_Renewal?orderId=' + orderNumber + '&customerId=' + customerId + '&parentOrderRecordId=' + component.get("v.orderRecordId");
                    var tabLabel = orderNumber;
                    var tabIcon = 'custom17';
                    helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
                }
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to create Miscellaneous Items: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    toggleSpinner: function (component, event, helper) {
        console.log('ready to close the spinner');
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, 'showSpinner');
        $A.util.addClass(spinner, 'hideSpinner');
    },

    closeActionItemsPopover: function (component, event, helper) {
        var orderItemDiv = component.find('orderItemDiv');
        console.log('orderItemDiv: ' + orderItemDiv);
        orderItemDiv.getElement().style.display = 'none';
    },

    hideAvailablePackagesOrderItemsAndMiscItemDlg: function (component, event, helper) {
        var miscItemPanel = component.find('miscItemPanel');
        miscItemPanel.getElement().style.display = 'none';
        var availablePackages = component.find("availDropdown");
        availablePackages.getElement().style.display = 'none';
        var newOrderItems = component.find("addNewDropdown");
        newOrderItems.getElement().style.display = 'none';
        var processingpanel = component.find('processingpanel');
        processingpanel.getElement().style.display = 'none';
        var Quantitypanel = component.find('Quanitypanel');
        Quantitypanel.getElement().style.display = 'none';
    },

    retrieveDocumentsByProcessingOrderId: function (component, event, helper) {
        console.log('inside retrieve order contacts');
        var processingOrderId = event.currentTarget.dataset.processingnumber;
        component.set("v.currentProcessingOrderId", processingOrderId);
        var action = component.get("c.getDocumentsByProcessingOrderId");
        action.setParams({
            "processingOrderId": processingOrderId
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                console.log(JSON.stringify(returnValue));

                component.set("v.documentsList", returnValue);
                component.set("v.documentsListJSON", JSON.stringify(returnValue));
                var orderContactPanel = component.find('documentsPanel');
                orderContactPanel.getElement().style.display = 'block';
                helper.toggleSpinner(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to retrieve documents: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    getEin: function (component, event, helper, pid) {
        var action = component.get("c.getEininfo");
        action.setParams({
            "processingid": pid,

        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state == "SUCCESS") {

                component.set("v.EinData", response.getReturnValue().deserialzedEntity);
                if (response.getReturnValue().deserialzedEntity != null) {
                    var popEin = document.getElementById(pid);

                    $A.util.removeClass(popEin, 'slds-hide');
                    $A.util.addClass(popEin, 'slds-show');
                }

                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if (exceptionMessages) {
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = 'Not Found';
                        type = 'info';
                        message = 'There is No Additional Information Available ';
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to Load EIN: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
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

    openTab: function (component, event, helper, taburl, tabLabel, tabIcon) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: taburl,
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
    },

    openSubTab: function (component, event, helper, subtaburl, tabLabel, tabIcon) {
        console.log('path url: ' + window.location.href);

        var parentTabUrl = '/lightning/r/Order__c/' + component.get("v.orderRecordId") + '/view';
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
                })
            }).catch(function (error) {
                console.log('Error: ' + error);
            });
        })
            .catch(function (error) {
                console.log('Error: ' + error);
            });
    },

    createProcessingAddon: function (component, event, helper) {
        var action = component.get("c.createExpedite");

        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "pdfcnfgid": component.get("v.pdtcnfid"),
            "itemQuantity": component.get("v.quantityfilling"),
            "orderNumber": component.get("v.orderNumber"),
            "price": component.get("v.expediteprice")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state == "SUCCESS") {
                var returnValue = response.getReturnValue();
                var modifiedItems = component.get("v.theModifiedOrderItemWrappers");

                var newItemJsonArray;
                console.log('resturn value inside misc item:');
                console.log(JSON.stringify(returnValue));
                if (returnValue.length > 0) {
                    console.log('ready to add a new product line to the list of modified items');
                    newItemJsonArray = { 'productName': returnValue[0].productName, 'processingOrderId': returnValue[0].processingOrderId, 'orderItemId': returnValue[0].orderItemId, 'dateTimeCreatedInString': returnValue[0].dateTimeCreatedInString, 'modificationType': returnValue[0].modificationType };
                }
                if (modifiedItems.length > 0 && newItemJsonArray) {
                    modifiedItems.push(newItemJsonArray);
                } else {
                    modifiedItems = returnValue;
                }

                component.set("v.theModifiedOrderItemWrappers", modifiedItems);
                this.loadData(component, event, helper);
                this.hideAvailablePackagesOrderItemsAndMiscItemDlg(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to create Expedite Items: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    createfillingfee: function (component, event, helper) {
        var action = component.get("c.createFiling");
        console.log('the quantity' + component.get("v.quantityfilling"));
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "pdfcnfgid": component.get("v.pdtcnfid"),
            "itemQuantity": component.get("v.quantityfilling"),
            "orderNumber": component.get("v.orderNumber")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state == "SUCCESS") {
                var returnValue = response.getReturnValue();
                var modifiedItems = component.get("v.theModifiedOrderItemWrappers");
                var newItemJsonArray;
                console.log('resturn value inside misc item:');
                console.log(JSON.stringify(returnValue));
                if (returnValue.length > 0) {
                    console.log('ready to add a new product line to the list of modified items');
                    newItemJsonArray = { 'productName': returnValue[0].productName, 'processingOrderId': returnValue[0].processingOrderId, 'orderItemId': returnValue[0].orderItemId, 'dateTimeCreatedInString': returnValue[0].dateTimeCreatedInString, 'modificationType': returnValue[0].modificationType };
                }
                if (modifiedItems.length > 0 && newItemJsonArray) {
                    modifiedItems.push(newItemJsonArray);
                } else {
                    modifiedItems = returnValue;
                }
                component.set("v.theModifiedOrderItemWrappers", modifiedItems);
                this.loadData(component, event, helper);
                this.hideAvailablePackagesOrderItemsAndMiscItemDlg(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to create Filing items Items: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    displayUpgradeDowngradePanel: function (component, event, helper, prodCompId, orderItemId) {
        console.log('Inside displayUpgradeDowngradePanel');
        var cancelOrder = component.find('upgradeDowngradePanel');
        cancelOrder.getElement().style.display = 'block';

        var action = component.get("c.subscriptionChangeOptions");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "productComponentId": prodCompId,
            "orderItemId": orderItemId
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('State inside displayUpgradeDowngradePanel-->' + state);
            if (state == "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log('subChangeOptions-->' + JSON.stringify(returnValue.subChangeOptions));
                if (returnValue) {
                    component.set("v.subUpgradeDowngradeAndRenewalTermOptions", returnValue.subChangeOptions);
                    component.set("v.customerName", returnValue.customerName);
                }
                helper.hideAvailablePackagesOrderItemsAndMiscItemDlg(component, event, helper);
                helper.toggleSpinner(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to retrieve subscription change options: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    retrieveProratedSubscriptionTermData: function (component, event, helper, prodCompId, orderItemId) {
        console.log('Inside retrieveProratedSubscriptionTermData');
        var action = component.get("c.proratedSubscriptionTermInfo");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "orderId": component.get("v.orderNumber"),
            "orderItemId": component.get("v.raUpgradeOrderItemId"),
            "renewalProductConfigurationId": component.get("v.productConfigurationId")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('State inside retrieveProratedSubscriptionTermData-->' + state);
            if (state == "SUCCESS") {
                var proratedSubSection = component.find('prorationSection');
                $A.util.removeClass(proratedSubSection, 'slds-hide');
                $A.util.addClass(proratedSubSection, 'slds-show');

                var returnValue = response.getReturnValue();
                console.log('returnValue-->');
                console.log(JSON.stringify(returnValue));
                console.log('proratedSubInfo-->');
                console.log(JSON.stringify(returnValue.proratedSubInfo));
                console.log(returnValue.proratedSubInfo.orderId)
                if (returnValue && returnValue.proratedSubInfo.orderId) {
                    var serviceTermRemainingStartDate = returnValue.proratedSubInfo.currentSubscriptionSummary.serviceTermRemainingStartDate;
                    var serviceTermRemainingEndDate = returnValue.proratedSubInfo.currentSubscriptionSummary.serviceTermRemainingEndDate;
                    var newEndDate = returnValue.proratedSubInfo.currentSubscriptionSummary.newEndDate;
                    var serviceStartDate = returnValue.proratedSubInfo.changeSubscriptionSummary.serviceStartDate;
                    var renewalDate = returnValue.proratedSubInfo.changeSubscriptionSummary.renewalDate;

                    console.log('serviceTermRemainingStartDate' + serviceTermRemainingStartDate);
                    console.log('serviceTermRemainingEndDate' + serviceTermRemainingEndDate);
                    console.log('newEndDate' + newEndDate);
                    console.log('serviceStartDate' + serviceStartDate);
                    console.log('renewalDate' + renewalDate);

                    returnValue.proratedSubInfo.currentSubscriptionSummary.serviceTermRemainingStartDate = serviceTermRemainingStartDate.substr(0, serviceTermRemainingStartDate.lastIndexOf("T"));
                    returnValue.proratedSubInfo.currentSubscriptionSummary.serviceTermRemainingEndDate = serviceTermRemainingEndDate.substr(0, serviceTermRemainingEndDate.lastIndexOf("T"));
                    returnValue.proratedSubInfo.currentSubscriptionSummary.newEndDate = newEndDate.substr(0, newEndDate.lastIndexOf("T"));
                    returnValue.proratedSubInfo.changeSubscriptionSummary.serviceStartDate = serviceStartDate.substr(0, serviceStartDate.lastIndexOf("T"));
                    returnValue.proratedSubInfo.changeSubscriptionSummary.renewalDate = renewalDate.substr(0, renewalDate.lastIndexOf("T"));

                    component.set("v.proratedSubscriptionInfo", returnValue.proratedSubInfo);
                    component.set("v.subscriptionId", returnValue.proratedSubInfo.currentSubscriptionSummary.subscriptionId);
                    console.log("Subscription Id-->" + component.get("v.subscriptionId"));
                }
                var exceptionMessages = returnValue.iadServiceMessages;
                for (var i = 0; i < exceptionMessages.length; i++) {
                    title = exceptionMessages[i].msgType;
                    type = exceptionMessages[i].msgType;
                    message = exceptionMessages[i].message;
                    helper.showToast(component, event, helper, title, type, message);
                }
                this.toggleSpinner(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to retrieve subscription change options: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    upgradeSubscription: function (component, event, helper) {
        console.log('Inside upgradeSubscription');
        var action = component.get("c.upgradeSubscritionPackage");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "subscriptionId": component.get("v.subscriptionId"),
            "orderItemId": component.get("v.raUpgradeOrderItemId"),
            "targetPackage": component.get("v.targetPackage"),
            "newProductComponentId": component.get("v.newProductComponentId"),
            "renewalProductConfigurationId": component.get("v.productConfigurationId")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('State inside upgradeSubscription-->' + state);
            if (state == "SUCCESS") {
                var orderInfo = response.getReturnValue().newOrderInfo;
                console.log('orderInfo--->' + JSON.stringify(orderInfo));
                if (orderInfo) {
                    component.set("v.subscriptionOrder", orderInfo);
                    console.log('orderInfo.orderId-->' + orderInfo.orderId);
                    if (orderInfo.orderId) {
                        var orderNumber = orderInfo.orderId;
                        var ctrlRef = component.get("v.ctrl");
                        var customerId;
                        if (component.get("v.customerId")) {
                            customerId = component.get("v.customerId");
                        } else {
                            customerId = ctrlRef.customerId;
                        }
                        var subtaburl = '/lightning/n/RA_Renewal?orderId=' + orderNumber + '&customerId=' + customerId + '&parentOrderRecordId=' + component.get("v.orderRecordId");
                        var tabLabel = orderNumber;
                        var tabIcon = 'custom17';
                        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
                    }
                    this.closeUpgradeDowngradePanel(component, event, helper);
                }
                this.toggleSpinner(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to retrieve subscription change options: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    closeUpgradeDowngradePanel: function (component, event, helper) {
        var cancelOrder = component.find('upgradeDowngradePanel');
        cancelOrder.getElement().style.display = 'none';

        component.set("v.renewalTermOptions", "");
        component.set("v.productConfigurationExtendedPrice", "empty");
        component.set("v.subUpgradeDowngradeAndRenewalTermOptions", "");
        component.set("v.subscriptionChangeToConfiguration", "empty");

        var proratedSubSection = component.find('prorationSection');
        $A.util.removeClass(proratedSubSection, 'slds-show');
        $A.util.addClass(proratedSubSection, 'slds-hide');
    },


    PostProcessingstatus: function (component, event, helper, pid) {
        var action = component.get("c.updateProcessingStatus");
        console.log('the jcldnc' + pid);
        action.setParams({
            "processingnumber": pid

        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state == "SUCCESS") {


                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if (exceptionMessages) {
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType;
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                    var processingupdatepanel = component.find('updateprocessing');
                    processingupdatepanel.getElement().style.display = 'none';
                    helper.loadData(component, event, helper);
                }
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to update Processing status  Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    /*<!--    STORY B-39539  -->*/
    handleMCCloserHelper: function (component) {
        component.set("v.openManagerCredentialModal", false);
        component.set("v.managerApprovedBy", null);
        component.set("v.refundApprovedByManager", null); // Added for /* <!-- STORY B-39537 --> */
    },

    handleMCSuccessHelper: function (component, event) {
        component.set("v.openManagerCredentialModal", false);
        var msg = event.getParam('userName') || '';
        if (!$A.util.isEmpty(msg)) {
            // Added for /* <!-- STORY B-39537 --> */
            if (component.get("v.mcCheckTypeIsRefund")) {
                component.set("v.refundApprovedByManager", msg);
                this.openRefundsPageHelper(component, event, this);
            } else {
                component.set("v.managerApprovedBy", msg);
                this.displayCancelOrderHelper(component);
            }
            // Added for /* <!-- STORY B-39537 --> */
            //component.set("v.managerApprovedBy",msg); // commented for /* <!-- STORY B-39537 --> */
        } else {
            component.set("v.managerApprovedBy", null);
            component.set("v.refundApprovedByManager", null);// Added for /* <!-- STORY B-39537 --> */
        }
        //this.displayCancelOrderHelper(component);// commented for /* <!-- STORY B-39537 --> */
    },

    displayCancelOrderHelper: function (component) {
        var cancelOrder = component.find('cancelOrder');
        if (!$A.util.isEmpty(cancelOrder)) {
            cancelOrder.getElement().style.display = 'block';
        }
    },

    handleCancelOrderApex: function (component, event, helper) {
        try {
            var state;
            var resp;
            var action;
            component.set("v.spinnerFlag", true); // Start spinner
            let parameterObject = {
                approvedBy: component.get("v.managerApprovedBy"),
                updatedBy: null
            };
            action = component.get('c.updateOrderToCancel');
            action.setParams({
                cRWrap: parameterObject,
                orderId: component.get("v.orderNumber")
            });
            action.setCallback(this, function (response) {
                state = response.getState();
                resp = response.getReturnValue();
                if ((state === "SUCCESS") ? ((!$A.util.isEmpty(resp)) ? (resp === 'SUCCESS') : false) : false) {
                    component.set("v.cancelOrder", true);
                    component.set("v.uncancelOrder", true);
                    this.showToast('', '', '', 'SUCCESS', 'success', 'Success! Order Cancelled Successfully.');
                } else if ((state === "SUCCESS") ? (($A.util.isEmpty(resp)) ? true : (resp === 'FAILURE')) : true) {
                    this.showToast('', '', '', 'Fail', 'error', 'Failed! Unable to canel order at this time.');
                } else {
                    this.showToast('', '', '', 'Fail', 'error', 'Failed! Unable to canel order at this time : ' + resp);
                }
                // reload Component
                this.loadData(component, event, helper);
                component.set("v.spinnerFlag", false); // stop spinner
            });
            $A.enqueueAction(action);
        } catch (Err) {
            this.showToast('', '', '', 'Fail', 'error', 'Failed! Unable to canel order at this time : ' + JSON.stringify(Err));
            component.set("v.spinnerFlag", false); // stop spinner
        }
    },
    /*<!--    STORY B-39539  -->*/
    /* <!-- STORY B-39537 --> */
    openRefundsPageHelper: function (component, event, helper) {
        try {
            var orderBalance = component.get("v.orderBalanceWrapper");
            var amount = orderBalance.theOrderBalance.orderBalanceAmount;
            var ctrlRef = component.get("v.ctrl");
            var orderNumber = ctrlRef.orderNumber;
            var customerId;
            if (amount < -800 && $A.util.isEmpty(component.get("v.refundApprovedByManager"))) {
                component.set("v.openManagerCredentialModal", true);
                component.set("v.mcCheckTypeIsRefund", true);
                return;
            }
            if (component.get("v.customerId")) {
                customerId = component.get("v.customerId")
            } else {
                customerId = ctrlRef.customerId;
            }
            //var subtaburl = '/lightning/n/Make_a_Refund?amount=' + amount + '&orderId=' + orderNumber + '&customerId=' + customerId + '&invokingPage=Order&invokingPageId=' + component.get("v.orderRecordId");
            var subtaburl = '/lightning/n/Make_a_Refund?amount=' + amount + '&orderId=' + orderNumber + '&customerId=' + customerId + '&invokingPage=Order&invokingPageId=' + component.get("v.orderRecordId") + '&approvedBy=' + component.get("v.refundApprovedByManager");
            var tabLabel = 'Refund';
            var tabIcon = 'custom17';
            helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
            component.set("v.refundApprovedByManager", null);
        } catch (Err) {
            console.log('Error in openRefundsPageHelper ~~~~~> ' + JSON.stringify(Err));
        }
    },
    /* <!-- STORY B-39537 --> */
})