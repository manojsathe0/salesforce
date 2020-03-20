({
    doInit: function (component, event, helper) {
        window.setTimeout(
            $A.getCallback(
                function () {
                    helper.raRenewalTabInfo(component, event, helper);
                }
            ),
            1500
        );
    },

    openRADashboard: function (component, event, helper) {
        var orderNumber = component.get("v.orderNumber");
        console.log('orderNumber: ' + orderNumber);
        if (orderNumber) {
            var url = 'http://lzportal/RegisteredAgentTools/CompanySearch/UpdateCompanyStatus.aspx?OrderId=' + orderNumber;
            console.log(url);
            window.open(url);
        }
    },


    reloadOrderScreen: function (component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');
        helper.loadData(component, event, helper);
    },

    openFileNet: function (component, event, helper) {
        var processingOrderId = event.currentTarget.dataset.processingorderid;
        console.log("processingOrderId: " + processingOrderId);
        window.open("http://filenetweb.legalzoom.com/navigator/_lz/DisplayOrderFilenet.jsp?fkUserOrder=" + processingOrderId + "&problem=1");
    },

    displayContentInFilenet: function (component, event, helper) {
        var processingOrderId = event.currentTarget.dataset.processingorderid;
        console.log('processingOrderId--->' + processingOrderId);
        var url = 'http://filenetweb.legalzoom.com/navigator/?orderNumber=' + processingOrderId;
        window.open(url);
    },

    openProofer: function (component, event, helper) {
        var processingOrderId = event.currentTarget.dataset.processingorderid;
        console.log("processingOrderId: " + processingOrderId);
        window.open("http://lzapps/proofer/" + processingOrderId);
    },

    openOrderstatus: function (component, event, helper) {
        var processingOrderId = event.currentTarget.dataset.processingnumber;
        console.log("processingOrderId: " + processingOrderId);
        window.open("/apex/IADOrderStatus?processingNumber=" + processingOrderId, "mywindow", 'height=' + screen.height + ', width=' + screen.width);
    },

    deleteOrderTag: function (component, event, helper) {
        console.log(event);
        console.log('tagName: ' + event.target.dataset.ordertag);
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');
        helper.deleteOT(component, event, helper);
    },

    createOrderTag: function (component, event, helper) {
        console.log(event.keyCode);
        console.log('tagName: ' + event.target.value);
        if (event.keyCode == '13' && event.target.value != '') {
            var spinner = component.find('spinner');
            $A.util.addClass(spinner, 'showSpinner');
            helper.createOT(component, event, helper);
        }
    },

    showCancelledItems: function (component, event, helper) {
        if (event.target.checked) {
            component.set('v.displayCancelledItems', true);
        } else {
            component.set('v.displayCancelledItems', false);
        }
    },

    displayOrderHistory: function (component, event, helper) {
        console.log('inside displayOrderHistory');
        var spinner = component.find('spinner');
        console.log(spinner);
        $A.util.addClass(spinner, 'showSpinner');
        helper.getOrderHistory(component, event, helper);
    },

    closeOrderHistory: function (component, event, helper) {
        var orderHistory = component.find('orderHistory');
        console.log(orderHistory);
        $A.util.addClass(orderHistory, 'hideOrderHistory');
        $A.util.removeClass(orderHistory, 'showOrderHistory');
    },

    closeTOSModal: function (component, event, helper) {
        var tosModalPanel = component.find('tosModalPanel');
        console.log(tosModalPanel);
        $A.util.addClass(tosModalPanel, 'slds-hide');
    },

    showAvailPackages: function (component, event, helper) {
        component.set("v.dispNameSubChange", component.get("v.orderWrapper").baseProductName);
        component.set("v.actionType", "changePackage");
        helper.populateActionItems(component, event, helper);
    },

    showNewOrderItems: function (component, event, helper) {
        component.set("v.actionType", "addItem");
        helper.populateActionItems(component, event, helper);
    },

    retrieveActionItems: function (component, event, helper) {
        var dispName = event.currentTarget.dataset.dispname;
        console.log('dispName--->' + dispName);
        if (dispName) {
            component.set("v.dispNameSubChange", dispName);
        } else {
            component.set("v.dispNameSubChange", component.get("v.orderWrapper").baseProductName);
        }

        helper.populateActionItems(component, event, helper);
    },

    hideActionItems: function (component, event, helper) {
        helper.closeActionItemsPopover(component, event, helper);
    },

    modifyCurrentOrderItem: function (component, event, helper) {
        console.log('modify order item');
        var pdtCnfgActionItem = component.get("v.productConfigurationIdToActionItem");
        var orderItemIdToPdtCnfgId = component.get("v.orderItemIdToProductConfigurationId");
        component.set("v.pdtcnfid", event.currentTarget.dataset.pdtcnfgid);
        console.log('description--->' + event.currentTarget.dataset.description);
        console.log('event.currentTarget.dataset.pdtcnfgactionitem--->' + event.currentTarget.dataset.pdtcnfgactionitem);
        console.log('check 1-->' + (event.currentTarget.dataset.pdtcnfgactionitem == '1222' || event.currentTarget.dataset.pdtcnfgactionitem == '1219'));
        console.log('check 2-->' + event.currentTarget.dataset.description.includes('Cancel'));
        console.log('is additonal deed transfer fee being added-->' + ((event.currentTarget.dataset.pdtcnfgactionitem == '1222' || event.currentTarget.dataset.pdtcnfgactionitem == '1219') && event.currentTarget.dataset.description.includes('Cancel')));
        if ((event.currentTarget.dataset.pdtcnfgactionitem != '1222' && event.currentTarget.dataset.pdtcnfgactionitem != '1221'
            && event.currentTarget.dataset.pdtcnfgactionitem != '1892' && event.currentTarget.dataset.pdtcnfgactionitem != '178'
            && event.currentTarget.dataset.pdtcnfgactionitem != '1892' && event.currentTarget.dataset.pdtcnfgactionitem != '1998'
            && event.currentTarget.dataset.pdtcnfgactionitem != '1219' && event.currentTarget.dataset.pdtcnfgactionitem != '1751'
            && event.currentTarget.dataset.description != 'Change Subscription Level')
            || ((event.currentTarget.dataset.pdtcnfgactionitem == '1222' || event.currentTarget.dataset.pdtcnfgactionitem == '1219' || event.currentTarget.dataset.pdtcnfgactionitem == '1751') && event.currentTarget.dataset.description.includes('Cancel'))) {
            console.log('inside if loop -- modifyItem');
            var spinner = component.find('spinner');
            $A.util.addClass(spinner, 'showSpinner');
            var action = component.get("c.modifyOrderItem");
            action.setParams({
                "productConfigurationId": event.currentTarget.dataset.pdtcnfgid,
                "orderItemId": event.currentTarget.dataset.orderitemid,
                "orderRecordId": component.get("v.orderRecordId"),
                "orderNumber": component.get("v.orderNumber"),
                "pdtCnfgActionItem": pdtCnfgActionItem,
                "orderItemIdToPdtCnfgId": orderItemIdToPdtCnfgId
            });
            action.setCallback(this, function (response) {
                var title;
                var type;
                var message;
                var state = response.getState();
                console.log('State inside if loop -- modifyItem' + state);
                if (state === "SUCCESS") {
                    var newItemJsonArray;
                    var returnValue = response.getReturnValue().modifiedOrderItemWrappers;
                    var exceptionMessages = response.getReturnValue().iadServiceMessages;

                    if (returnValue && returnValue.length > 0) {
                        var modifiedItems = component.get("v.theModifiedOrderItemWrappers");
                        console.log('stringified modifiedItems: ' + JSON.stringify(modifiedItems));
                        if (modifiedItems.length > 0) {
                            newItemJsonArray = { 'productName': returnValue[0].productName, 'processingOrderId': returnValue[0].processingOrderId, 'orderItemId': returnValue[0].orderItemId, 'dateTimeCreatedInString': returnValue[0].dateTimeCreatedInString, 'modificationType': returnValue[0].modificationType };
                            modifiedItems.push(newItemJsonArray);
                        } else {
                            modifiedItems = returnValue;
                        }

                        helper.loadData(component, event, helper);
                        helper.closeActionItemsPopover(component, event, helper);
                        helper.hideAvailablePackagesOrderItemsAndMiscItemDlg(component, event, helper);

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

                            // Event fires on Renewal 
                            var RefreshEvent = $A.get("e.c:RefreshRelatedOrders_ltng");
                            RefreshEvent.fire();

                        }
                    }
                    if (exceptionMessages) {
                        for (var i = 0; i < exceptionMessages.length; i++) {
                            title = exceptionMessages[i].msgType;
                            type = exceptionMessages[i].msgType;
                            message = exceptionMessages[i].message;
                            helper.showToast(component, event, helper, title, type, message);
                        }
                    }
                    helper.closeActionItemsPopover(component, event, helper);
                    helper.hideAvailablePackagesOrderItemsAndMiscItemDlg(component, event, helper);
                    helper.toggleSpinner(component, event, helper);
                }
                else {
                    title = "Error";
                    type = "error";
                    message = "An error occured when trying to modify order item: Please try again!";
                    helper.showToast(component, event, helper, title, type, message);
                    helper.toggleSpinner(component, event, helper);
                }
            });
            $A.enqueueAction(action);
        }
        else {
            console.log('inside else loop -- modifyItem');
            if (event.currentTarget.dataset.pdtcnfgactionitem == '1222') {
                var miscItemPanel = component.find('miscItemPanel');
                miscItemPanel.getElement().style.display = 'block';
            }
            else if (event.currentTarget.dataset.pdtcnfgactionitem == '1751' || event.currentTarget.dataset.pdtcnfgactionitem == '1219' || event.currentTarget.dataset.pdtcnfgactionitem == '1221' || event.currentTarget.dataset.pdtcnfgactionitem == '1892') {
                if (event.currentTarget.dataset.pdtcnfgactionitem == '1221') {
                    component.set("v.descriptionorderitem", "Expedited Processing (LegalZoom)")
                }

                if (event.currentTarget.dataset.pdtcnfgactionitem == '1892') {
                    component.set("v.descriptionorderitem", "Expedited Processing Plus (LegalZoom)")
                }

                if (event.currentTarget.dataset.pdtcnfgactionitem == '1219') {
                    component.set("v.descriptionorderitem", "Deed Transfer - Post-sale Add-on")
                }

                if (event.currentTarget.dataset.pdtcnfgactionitem == '1751') {
                    component.set("v.descriptionorderitem", "Deed Transfer - Post-sale Add-on")
                }
                var miscItemPanel = component.find('processingpanel');
                miscItemPanel.getElement().style.display = 'block';
            }
            else if (event.currentTarget.dataset.pdtcnfgactionitem == '1998' || event.currentTarget.dataset.pdtcnfgactionitem == '178') {
                component.set("v.quantityfilling", "1");
                if (event.currentTarget.dataset.pdtcnfgactionitem == '1998') {
                    component.set("v.descriptionorderitem", " Trademark Add Additional Class Filing Fee ")
                }

                if (event.currentTarget.dataset.pdtcnfgactionitem == '178') {
                    component.set("v.descriptionorderitem", " Trademark Add Additional Class Processing ")
                }
                var miscItemPanel = component.find('Quanitypanel');
                miscItemPanel.getElement().style.display = 'block';
            }
            else if (event.currentTarget.dataset.description == 'Change Subscription Level') {
                var prodCompId = event.currentTarget.dataset.pdtcompid;
                component.set("v.raPdtCmpId", prodCompId);
                var orderItemId = event.currentTarget.dataset.orderitemid;
                component.set("v.raUpgradeOrderItemId", orderItemId);
                console.log('product component id: ' + prodCompId);
                console.log('Order Item Id: ' + orderItemId);

                var spinner = component.find('spinner');
                $A.util.addClass(spinner, 'showSpinner');

                helper.displayUpgradeDowngradePanel(component, event, helper, prodCompId, orderItemId);
            }
        }
    },

    displayCancelOrder: function (component, event, helper) {
        /*<!--    STORY B-39539  -->*/
        /* Moved the code to displayCancelOrderHelper function in Helper file
        var cancelOrder = component.find('cancelOrder');
        cancelOrder.getElement().style.display = 'block';
        */
        component.set("v.openManagerCredentialModal", true);
        /*<!--    STORY B-39539  -->*/
    },

    hideCancelOrder: function (component, event, helper) {
        var cancelOrder = component.find('cancelOrder');
        cancelOrder.getElement().style.display = 'none';
    },

    displayUncancelOrder: function (component, event, helper) {
        var uncancelOrder = component.find('uncancelOrder');
        uncancelOrder.getElement().style.display = 'block';
    },

    hideUncancelOrder: function (component, event, helper) {
        var uncancelOrder = component.find('uncancelOrder');
        uncancelOrder.getElement().style.display = 'none';
    },

    invokeCancelOrder: function (component, event, helper) {
        helper.handleCancelOrderApex(component, event, helper); // Added for STORY B-39539 
        /* //  STORY B-39539 Commented for this Story
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');
        var action = component.get("c.callCancelOrder");
        action.setParams({
            "orderRecordId" : component.get("v.orderRecordId"),
            "orderNumber" : component.get("v.orderNumber")
        });
        console.log('OrderRecordId: '+component.get("v.orderRecordId"));
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();            
            if(state == "SUCCESS")
            {
                var result = response.getReturnValue().iadServiceMessages;
                component.set("v.cancelOrder", true);
                component.set("v.uncancelOrder", true);
                if(result)
                {    
                    for (var i = 0; i < result.length; i++) {
                        title = result[i].msgType; 
                        type = result[i].msgType;
                        message = result[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                helper.loadData(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to cancel order: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
        */
    },

    invokeUncancelOrder: function (component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');
        var action = component.get("c.callUncancelOrder");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "orderNumber": component.get("v.orderNumber")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state == "SUCCESS") {
                var result = response.getReturnValue().iadServiceMessages;
                component.set("v.uncancelOrder", false);
                component.set("v.cancelOrder", false);
                var uncancelOrder = component.find('uncancelOrder');
                uncancelOrder.getElement().style.display = 'none';
                if (result) {
                    for (var i = 0; i < result.length; i++) {
                        title = result[i].msgType;
                        type = result[i].msgType;
                        message = result[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                helper.loadData(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to Uncancel order: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    hideMiscItemPanel: function (component, event, helper) {
        var miscItemPanel = component.find('miscItemPanel');
        console.log(miscItemPanel);
        miscItemPanel.getElement().style.display = 'none';
    },

    validateAndCreateMiscItem: function (component, event, helper) {
        console.log('createMiscItem');
        var validItem = component.find('miscform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if (validItem) {
            var spinner = component.find('spinner');
            $A.util.addClass(spinner, 'showSpinner');
            helper.createMiscellaneousItems(component, event, helper);
        }
    },

    hideAvailablePackages: function (component, event, helper) {
        var availablePackages = component.find("availDropdown");
        availablePackages.getElement().style.display = 'none';
    },

    hideNewOrderItems: function (component, event, helper) {
        var newOrderItems = component.find("addNewDropdown");
        newOrderItems.getElement().style.display = 'none';
    },

    displayConvert3Pay: function (component, event, helper) {
        var threepay = component.find("threePayPanel");
        threepay.getElement().style.display = 'block';
    },

    hideConvertTo3Pay: function (component, event, helper) {
        var threepay = component.find("threePayPanel");
        threepay.getElement().style.display = 'none';
    },

    show3Pay: function (component, event, helper) {
        console.log('inside 3 pay conversion');
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');
        var action = component.get("c.convertOrderToThreePay");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId")
        });
        console.log('Params set');
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state of 3 pay conversion: ' + state);
            var threepay = component.find("threePayPanel");
            threepay.getElement().style.display = 'none';
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue().modifiedOrderItemWrappers;
                var iadServiceMessages = response.getReturnValue().iadServiceMessages;
                var modifiedItems = component.get("v.theModifiedOrderItemWrappers");
                console.log(JSON.stringify(returnValue));
                console.log(JSON.stringify(iadServiceMessages));
                console.log(JSON.stringify(modifiedItems));
                if (modifiedItems && returnValue && returnValue.length > 0) {
                    var newItemJsonArray = { 'productName': returnValue[0].productName, 'processingOrderId': returnValue[0].processingOrderId, 'orderItemId': returnValue[0].orderItemId, 'dateTimeCreatedInString': returnValue[0].dateTimeCreatedInString, 'modificationType': returnValue[0].modificationType };
                    modifiedItems.push(newItemJsonArray);
                }
                else {
                    modifiedItems = returnValue;
                }
                console.log(JSON.stringify(modifiedItems));
                component.set("v.theModifiedOrderItemWrappers", modifiedItems);
                if (iadServiceMessages) {
                    for (var i = 0; i < iadServiceMessages.length; i++) {
                        title = iadServiceMessages[i].msgType;
                        type = iadServiceMessages[i].msgType;
                        message = iadServiceMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                helper.loadData(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to load 3Pay: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    editShippingAddress: function (component, event, helper) {
        console.log('inside editShippingAddress: iad screen');
        var isdeletable = event.currentTarget.dataset.isdeletable;
        console.log('isdeletable: ' + isdeletable);

        var authorizedcontactid = event.currentTarget.dataset.authorizedcontactid;
        console.log('authorizedcontactid-->' + authorizedcontactid);
        var iadCtrlRef = component.get("v.ctrl");
        var orderNumber = iadCtrlRef.orderNumber;
        var orderContactId;
        if (iadCtrlRef.authorizedContacts.length > 0 && iadCtrlRef.authorizedContacts[0].Contact__r.LZ_Order_Contact_ID__c != null) {
            orderContactId = iadCtrlRef.authorizedContacts[0].Contact__r.LZ_Order_Contact_ID__c;
        }
        else {
            orderContactId = "";
        }
        var subtaburl = '/lightning/n/Edit_Shipping_Address?id=' + orderNumber + '&orderContactId=' + orderContactId + '&isDeletable=' + isdeletable + '&authorizedcontactid=' + authorizedcontactid;
        var tabLabel = 'Edit Shipping Address';
        var tabIcon = 'edit';
        console.log('subtaburl: ' + subtaburl);
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    },

    createOrderSpecificContact: function (component, event, helper) {
        var iadCtrlRef = component.get("v.ctrl");
        var orderNumber = iadCtrlRef.orderNumber;
        var subtaburl = '/lightning/n/Add_Order_Specific_Contact?id=' + orderNumber + '&isNew=true';
        var tabLabel = 'Add Order Specific Contact';
        var tabIcon = 'page';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    },

    openPaymentsPage: function (component, event, helper) {
        var orderBalance = component.get("v.orderBalanceWrapper");
        console.log('orderBalance: ' + JSON.stringify(orderBalance));
        var amount = orderBalance.theOrderBalance.orderBalanceAmount;
        console.log('amount: ' + amount);

        var ctrlRef = component.get("v.ctrl");
        console.log('ctrlRef: ' + JSON.stringify(ctrlRef));
        var orderNumber = ctrlRef.orderNumber;
        var customerId;
        if (component.get("v.customerId")) {
            customerId = component.get("v.customerId")
        } else {
            customerId = ctrlRef.customerId;
        }
        var subtaburl = '/lightning/n/Make_a_Payment?amountdue=1&amount=' + amount + '&orderId=' + orderNumber + '&customerId=' + customerId + '&invokingPage=Order&invokingPageId=' + component.get("v.orderRecordId");
        var tabLabel = 'Payment';
        var tabIcon = 'custom17';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    },

    openRefundsPage: function (component, event, helper) {
        helper.openRefundsPageHelper(component, event, helper); // Added for STORY B-39537
        // commented below code for STORY B-39537 and mode into helper file - Method Name - OpenRefundsPageHelper
        /*
  var orderBalance = component.get("v.orderBalanceWrapper");
  console.log('orderBalance: ' + JSON.stringify(orderBalance));
  var amount = orderBalance.theOrderBalance.orderBalanceAmount;
  console.log('amount: ' + amount);

  var ctrlRef = component.get("v.ctrl");
  console.log('ctrlRef: ' + JSON.stringify(ctrlRef));
  var orderNumber = ctrlRef.orderNumber;
  var customerId;
  if (component.get("v.customerId")) {
      customerId = component.get("v.customerId")
  } else {
      customerId = ctrlRef.customerId;
  }
  var subtaburl = '/lightning/n/Make_a_Refund?amount=' + amount + '&orderId=' + orderNumber + '&customerId=' + customerId + '&invokingPage=Order&invokingPageId=' + component.get("v.orderRecordId");
  var tabLabel = 'Refund';
  var tabIcon = 'custom17';
  helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
  */
    },

    openDiscountPage: function (component, event, helper) {
        var ctrlRef = component.get("v.ctrl");
        var orderNumber = ctrlRef.orderNumber;
        var orderSubTotal = component.get("v.orderBalanceWrapper").theOrderBalance.subTotalCharges;
        console.log('order sub total-->' + orderSubTotal);
        var subtaburl = '/lightning/n/Add_Discount?orderId=' + orderNumber + '&orderSubTotal=' + orderSubTotal;
        var tabLabel = 'Add Discount';
        var tabIcon = 'custom17';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    },

    openPromoPage: function (component, event, helper) {
        var ctrlRef = component.get("v.ctrl");
        var orderNumber = ctrlRef.orderNumber;
        var subtaburl = '/lightning/n/Add_Promo?orderId=' + orderNumber;
        var tabLabel = 'Add Promo';
        var tabIcon = 'custom17';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    },

    openQuestionnaire: function (component, event, helper) {
        console.log("openQuestionnaire");
        var processingorderid = event.currentTarget.dataset.processingorderid;
        component.set("v.poId", processingorderid);
        console.log("processingorderid = " + processingorderid);
        var QuestionnaireVersionsModal = component.find('QuestionnaireVersionsModal');
        QuestionnaireVersionsModal.openQuestionnaireVersions(processingorderid);
    },

    openNextPadModal: function (component, event, helper) {
        console.log("openNextPadModal");
        var processingNumber = event.currentTarget.dataset.processingnumber;
        var customerOrderNumber = event.currentTarget.dataset.customerordernumber;
        var orderItemNumber = event.currentTarget.dataset.orderitemnumber;
        var NextPadModal = component.find('NextPadModal');

        NextPadModal.openNextPadModal(processingNumber, customerOrderNumber, orderItemNumber, component.get("v.orderRecordId"));
    },

    automateDocs: function (component, event, helper) {
        console.log("automateDocs");
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');
        var processingNumber = event.currentTarget.dataset.processingnumber;
        console.log('processing number-->' + processingNumber);
        var action = component.get("c.reAutomateOrder");
        action.setParams({
            "processingOrderId": processingNumber
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                console.log('returnValue');
                console.log(JSON.stringify(returnValue));
                var serviceMessage = response.getReturnValue().iadServiceMessages;
                console.log(serviceMessage);
                if (serviceMessage) {
                    for (var i = 0; i < serviceMessage.length; i++) {
                        title = serviceMessage[i].msgType;
                        type = serviceMessage[i].msgType;
                        message = serviceMessage[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                helper.toggleSpinner(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to re-Automate Order: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    retrieveDocuments: function (component, event, helper) {
        console.log('inside call send documents');
        //var availablePackages = component.find("customerContactPanel");
        //availablePackages.getElement().style.display = 'none';
        var empty = [];
        component.set("v.selectedDocuments", empty);

        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');

        var processId = event.currentTarget.dataset.processid;
        if (processId) {
            component.set("v.processId", processId);
            console.log('processId--->' + processId);
        }

        var processName = event.currentTarget.dataset.processname;
        if (processName) {
            component.set("v.processName", processName);
            console.log('processName--->' + processName);
        }
        helper.retrieveDocumentsByProcessingOrderId(component, event, helper);
    },

    hideDocumentsPanel: function (component, event, helper) {
        var availablePackages = component.find("documentsPanel");
        availablePackages.getElement().style.display = 'none';
    },

    updateSelectedDocumentsList: function (component, event, helper) {
        // create array[list] type temp. variable for store child record's id's from selected checkboxes.  
        var tempIDs = [];

        console.log('selected documents before-->' + component.get("v.selectedDocuments"));

        // get(find) all checkboxes with aura:id "documents"
        var getAllId = component.find("documentsCheck");
        console.log('getAllId-->' + getAllId);
        console.log('getAllId.length-->' + getAllId.length);
        // play a for loop and check every checkbox values 
        // if value is checked(true) then add those Id (store in Text attribute on checkbox) in tempIDs var.
        for (var i = 0; i < getAllId.length; i++) {
            console.log('getAllId-->' + getAllId[i]);
            if (getAllId[i].get("v.checked") == true) {
                tempIDs.push(getAllId[i].get("v.name"));
            }
        }
        component.set("v.selectedDocuments", tempIDs);
        console.log('tempIds-->' + component.get("v.selectedDocuments"));
        console.log(tempIDs);
    },

    shareDocuments: function (component, event, helper) {
        console.log('inside shareDocuments');
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');

        var action = component.get("c.shareDocumentsByProcessingOrderId");
        action.setParams({
            "customerId": component.get("v.customerId"),
            "processingOrderId": component.get("v.currentProcessingOrderId"),
            "processId": component.get("v.processId"),
            "processName": component.get("v.processName"),
            "contactType": "primary",
            "documentList": component.get("v.documentsListJSON"),
            "selectedDocuments": component.get("v.selectedDocuments")
        });
        action.setCallback(this, function (response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                console.log(JSON.stringify(returnValue));

                var serviceMessage = response.getReturnValue().iadServiceMessages;
                console.log(serviceMessage);

                var isDocDeliverySuccessfull = response.getReturnValue().documentsQueuedSuccessfully;
                console.log('isDocDeliverySuccessfull--->' + isDocDeliverySuccessfull);
                if (isDocDeliverySuccessfull) {
                    component.set("v.docDeliveryResponse", "Documents are queued for delivery!");

                    var orderContactPanel = component.find('documentsPanel');
                    orderContactPanel.getElement().style.display = 'none';

                    var documentsSentPanel = component.find('documentsSentPanel');
                    documentsSentPanel.getElement().style.display = 'block';
                }
                else if (serviceMessage) {
                    component.set("v.docDeliveryResponse", serviceMessage);

                    for (var i = 0; i < serviceMessage.length; i++) {
                        title = serviceMessage[i].msgType;
                        type = serviceMessage[i].msgType;
                        message = serviceMessage[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                helper.toggleSpinner(component, event, helper);
            }
            else {
                title = "Error";
                type = "error";
                message = "An error occured when trying to share documents: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    hideDocumentsSentPanel: function (component, event, helper) {
        var documentsSentPanel = component.find("documentsSentPanel");
        documentsSentPanel.getElement().style.display = 'none';
    },

    openEIN: function (component, event, helper) {
        var target = event.getSource();
        var txtVal = target.get("v.value");
        helper.getEin(component, event, helper, txtVal);
    },

    closeEin: function (component, event, helper) {
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.processingid;
        var popEin = document.getElementById(recId);
        $A.util.removeClass(popEin, 'slds-show');
        $A.util.addClass(popEin, 'slds-hide');
    },

    CreateProcessing: function (component, event, helper) {

        // If we pass error checking, do some real work
        var validItem = component.find('expediteform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (validItem) {
            var spinner = component.find('spinner');
            $A.util.addClass(spinner, 'showSpinner');
            helper.createProcessingAddon(component, event, helper);
        }
    },

    closeprocessing: function (component, event, helper) {

        var miscItemPanel = component.find('processingpanel');
        miscItemPanel.getElement().style.display = 'none';
    },

    Quantityfilling: function (component, event, helper) {

        // If we pass error checking, do some real work
        //    // If we pass error checking, do some real work
        var validItem = component.find('filingandprocessing').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (validItem) {
            var spinner = component.find('spinner');
            $A.util.addClass(spinner, 'showSpinner');
            helper.createfillingfee(component, event, helper);
        }
    },

    closefiling: function (component, event, helper) {

        var miscItemPanel = component.find('Quanitypanel');
        miscItemPanel.getElement().style.display = 'none';
    },

    hideUpgradeDowngradePanel: function (component, event, helper) {
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

    setRenewalTermPicklist: function (component, event, helper) {
        console.log('inside setRenewalTermPicklist');
        if (component.get("v.subscriptionChangeToConfiguration") != 'empty') {
            var proratedSubSection = component.find('prorationSection');
            $A.util.removeClass(proratedSubSection, 'slds-show');
            $A.util.addClass(proratedSubSection, 'slds-hide');

            var subCnfgCmpId = component.get("v.subscriptionChangeToConfiguration");
            console.log('subCnfgCmpId-->' + subCnfgCmpId);
            var params = subCnfgCmpId.split('-');
            for (var i = 0; i < params.length; i++) {
                console.log('param' + i + ':' + params[i])
                if (i == 0) {
                    component.set("v.targetPackage", params[i]);
                } else if (i == 1) {
                    component.set("v.newProductComponentId", params[i]);
                } else if (i == 2) {
                    component.set("v.subscriptionChangeToName", params[i]);
                }
            }

            component.set("v.productConfigurationExtendedPrice", "empty");
            console.log("v.targetPackage" + component.get("v.targetPackage"));
            console.log("v.newProductComponentId" + component.get("v.newProductComponentId"));

            var subChangeOptions = component.get("v.subUpgradeDowngradeAndRenewalTermOptions").subscriptionChangeOptions;
            for (var key in subChangeOptions) {
                console.log('key-->' + key);
                console.log(subChangeOptions[key]);
                console.log(subChangeOptions[key].subscriptionChangeToConfiguration);
                console.log(subChangeOptions[key].availableRenewalTerm);
                if (subChangeOptions[key].subscriptionChangeToConfiguration == component.get("v.targetPackage")) {
                    component.set("v.renewalTermOptions", subChangeOptions[key].availableRenewalTerm);
                }
            }
        }
        else {
            component.set("v.renewalTermOptions", "");
            component.set("v.productConfigurationExtendedPrice", "empty");
            var proratedSubSection = component.find('prorationSection');
            $A.util.removeClass(proratedSubSection, 'slds-show');
            $A.util.addClass(proratedSubSection, 'slds-hide');
        }
    },

    reRenderProrationSection: function (component, event, helper) {
        if (component.get("v.productConfigurationExtendedPrice") != 'empty') {
            var spinner = component.find('spinner');
            $A.util.addClass(spinner, 'showSpinner');
            component.set("v.subscriptionId", "");

            var pdtCnfgIdExtndPrice = component.get("v.productConfigurationExtendedPrice");
            console.log('pdtCnfgIdExtndPrice-->' + pdtCnfgIdExtndPrice);
            var params = pdtCnfgIdExtndPrice.split('-');
            for (var i = 0; i < params.length; i++) {
                console.log('param' + i + ':' + params[i])
                if (i == 0) {
                    component.set("v.productConfigurationId", params[i]);
                } else if (i == 1) {
                    component.set("v.extendedPrice", params[i]);
                }
            }

            helper.retrieveProratedSubscriptionTermData(component, event, helper);
        }
        else {
            var proratedSubSection = component.find('prorationSection');
            $A.util.removeClass(proratedSubSection, 'slds-show');
            $A.util.addClass(proratedSubSection, 'slds-hide');
        }
    },

    validateAndUpgradeSubscription: function (component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');
        helper.upgradeSubscription(component, event, helper);
    },
    //anvesh
    UpdateProcessingStatus: function (component, event, helper) {


        var processingupdatepanel = component.find('updateprocessing');
        processingupdatepanel.getElement().style.display = 'block';
        var selectedprocess = event.currentTarget;
        var recId = selectedprocess.dataset.lifeplanprocess;
        console.log(recId);
        component.set("v.lifeplanprocessingstatus", recId);
    },

    updatelifeplanprocess: function (component, event, helper) {
        console.log(component.get("v.lifeplanprocessingstatus"));

        helper.PostProcessingstatus(component, event, helper, component.get("v.lifeplanprocessingstatus"));

    },

    hideprocessmodal: function (component, event, helper) {

        var processingupdatepanel = component.find('updateprocessing');
        processingupdatepanel.getElement().style.display = 'none';

    },
    /*<!--    STORY B-39539  -->*/
    handleMCCloser: function (component, event, helper) {
        helper.handleMCCloserHelper(component);
    },
    handleMCSuccess: function (component, event, helper) {
        helper.handleMCSuccessHelper(component, event);
    },
    /*<!--  STORY B-39539  -->*/
})