({
	
    doInitRenewal : function(component, event, helper){
        helper.raRenewalTabInfo(component, event, helper);
    },
    
    openRADashboard : function(component, event, helper){
        var orderNumber = component.get("v.orderNumber");
        console.log('orderNumber: '+orderNumber);
        if(orderNumber){
            var url = 'http://dev-lzportal/RegisteredAgentTools/CompanySearch/UpdateCompanyStatus.aspx?OrderId='+orderNumber;
            console.log(url);
            window.open(url);
        }
    },
    
    reloadOrderScreen : function(component, event, helper){
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');
        helper.loadData(component, event, helper);
    },
    
    openFileNet : function(component, event, helper){
        var processingOrderId = event.currentTarget.dataset.processingorderid;
        console.log("processingOrderId: "+processingOrderId);
        window.open("http://filenetweb.legalzoom.com/navigator/_lz/DisplayOrderFilenet.jsp?fkUserOrder=" + processingOrderId + "&problem=1");
    },
    
    openProofer : function(component, event, helper){
        var processingOrderId = event.currentTarget.dataset.processingorderid;
        console.log("processingOrderId: "+processingOrderId);
        window.open("http://dev-lzapps/proofer/" + processingOrderId);
    },
    
    deleteOrderTag : function(component, event, helper){
      	console.log(event);
        console.log('tagName: '+event.target.dataset.ordertag);        
        helper.deleteOT(component, event, helper);        
    },
    
    createOrderTag : function(component, event, helper){
      	console.log(event.keyCode);
        console.log('tagName: '+event.target.value);
        if(event.keyCode == '13' && event.target.value != ''){
            helper.createOT(component, event, helper);
        }
    },
    
    showCancelledItems : function(component, event, helper){
        if(event.target.checked){
        	component.set('v.displayCancelledItems', true);
        }else{
            component.set('v.displayCancelledItems', false);
        }
    },
    
    displayOrderHistory : function(component, event, helper){
        console.log('inside displayOrderHistory');
        var spinner = component.find('spinner');
        console.log(spinner);
        $A.util.addClass(spinner, 'showSpinner');
        helper.getOrderHistory(component, event, helper);
    },
    
    closeOrderHistory : function(component, event, helper){
        var orderHistory = component.find('orderHistory');
        console.log(orderHistory);
        $A.util.addClass(orderHistory, 'hideOrderHistory');
        $A.util.removeClass(orderHistory, 'showOrderHistory');
    },
    
    closeTOSModal : function(component, event, helper){
        var tosModalPanel = component.find('tosModalPanel');
        console.log(tosModalPanel);
        $A.util.addClass(tosModalPanel, 'slds-hide');
    },
    
    showAvailPackages : function(component, event, helper){
        component.set("v.actionType", "changePackage");
        helper.populateActionItems(component, event, helper);
    },
    
    showNewOrderItems : function(component, event, helper){
        component.set("v.actionType", "addItem");
        helper.populateActionItems(component, event, helper);
    },
    
    retrieveActionItems : function(component, event, helper){
        helper.populateActionItems(component, event, helper);         
    },
    
    hideActionItems : function(component, event, helper){
        helper.closeActionItemsPopover(component, event, helper);
    },
    
    modifyCurrentOrderItem : function(component, event, helper){
        console.log('modify order item');
        var pdtCnfgActionItem = component.get("v.productConfigurationIdToActionItem");
        var orderItemIdToPdtCnfgId = component.get("v.orderItemIdToProductConfigurationId");
        
        if(event.currentTarget.dataset.pdtcnfgactionitem != '1222'){
            var spinner = component.find('spinner');
        	$A.util.addClass(spinner, 'showSpinner');
            var action = component.get("c.modifyOrderItem");
            action.setParams({
                "productConfigurationId" : event.currentTarget.dataset.pdtcnfgid,
                "orderItemId" : event.currentTarget.dataset.orderitemid,
                "orderRecordId" : component.get("v.orderRecordId"),
                "orderNumber" : component.get("v.orderNumber"),
                "pdtCnfgActionItem" : pdtCnfgActionItem,
                "orderItemIdToPdtCnfgId" : orderItemIdToPdtCnfgId
            });
            action.setCallback(this, function(response) { 
                var title;
                var type;
                var message;
                var state = response.getState();
                if (state === "SUCCESS") {
                    var newItemJsonArray;
                    var returnValue = response.getReturnValue().modifiedOrderItemWrappers;
                    if(returnValue && returnValue.length > 0)
                    {    
                        var exceptionMessages = response.getReturnValue().iadServiceMessages;
                    
                        var modifiedItems = component.get("v.theModifiedOrderItemWrappers");
                        console.log('stringified modifiedItems: '+JSON.stringify(modifiedItems)); 
                        if(modifiedItems.length > 0)
                        {
                            newItemJsonArray = {'productName':returnValue[0].productName, 'processingOrderId' : returnValue[0].processingOrderId, 'orderItemId':returnValue[0].orderItemId, 'dateTimeCreatedInString':returnValue[0].dateTimeCreatedInString, 'modificationType':returnValue[0].modificationType};
                            modifiedItems.push(newItemJsonArray);
                        }else
                        {
                            modifiedItems = returnValue;
                        }
                        if(exceptionMessages){
                            for (var i = 0; i < exceptionMessages.length; i++) 
                            {
                                title = exceptionMessages[i].msgType; 
                                type = exceptionMessages[i].msgType;
                                message = exceptionMessages[i].message;
                                helper.showToast(component, event, helper, title, type, message);
                            }
                        }                        
                        helper.loadData(component, event, helper);
                        helper.closeActionItemsPopover(component, event, helper);
                        helper.hideAvailablePackagesOrderItemsAndMiscItemDlg(component, event, helper);               
                        
                        if(response.getReturnValue().isNewOrderAdded)
                        {
                            console.log('ready to Open renewal order: '+response.getReturnValue().isNewOrderAdded);
                            var orderNumber = response.getReturnValue().newOrderId;
                            var ctrlRef = component.get("v.ctrl");
                            var customerId;
                            if(component.get("v.customerId"))
                            {
                                customerId = component.get("v.customerId");
                            }else
                            {
                                customerId = ctrlRef.customerId;
                            }
                            var subtaburl = '#/n/RA_Renewal?orderId=' + orderNumber + '&customerId=' +customerId;
                            var tabLabel = orderNumber;
                            var tabIcon = 'custom17';
                            helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
                        }
                    }
                }
                else 
                {
                    title = "Error";
                    type = "error";
                    message = "An error occured when trying to modify order item: Please try again!";
                    helper.showToast(component, event, helper, title, type, message);
                    helper.toggleSpinner(component, event, helper);
                }
            });
            $A.enqueueAction(action); 
        }
        else
        {
            var miscItemPanel = component.find('miscItemPanel');
        	miscItemPanel.getElement().style.display = 'block';
        }
    },
    
    displayCancelOrder : function(component, event, helper){
        var cancelOrder = component.find('cancelOrder');
        cancelOrder.getElement().style.display = 'block';
    },
    
    hideCancelOrder : function(component, event, helper){
        var cancelOrder = component.find('cancelOrder');
        cancelOrder.getElement().style.display = 'none';
    },
    
    displayUncancelOrder : function(component, event, helper){
        var uncancelOrder = component.find('uncancelOrder');
        uncancelOrder.getElement().style.display = 'block';
    },
    
    hideUncancelOrder : function(component, event, helper){
        var uncancelOrder = component.find('uncancelOrder');
        uncancelOrder.getElement().style.display = 'none';
    },
    
    invokeCancelOrder : function(component, event, helper){
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
    },
    
    invokeUncancelOrder : function(component, event, helper){
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');
        var action = component.get("c.callUncancelOrder");
        action.setParams({
            "orderRecordId" : component.get("v.orderRecordId"),
            "orderNumber" : component.get("v.orderNumber")
        });
        action.setCallback(this, function(response){
           	var title;
            var type;
            var message;
            var state = response.getState();
            if(state == "SUCCESS")
            {
                var result = response.getReturnValue().iadServiceMessages;
            	component.set("v.uncancelOrder", false);
                component.set("v.cancelOrder", false);
                var uncancelOrder = component.find('uncancelOrder');
        		uncancelOrder.getElement().style.display = 'none';
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
                message = "An error occured when trying to Uncancel order: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    hideMiscItemPanel : function(component, event, helper){
        var miscItemPanel = component.find('miscItemPanel');
        console.log(miscItemPanel);
        miscItemPanel.getElement().style.display = 'none';
    },
    
    validateAndCreateMiscItem : function(component, event, helper){
        console.log('createMiscItem');
        var validItem = component.find('miscform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validItem){
            var spinner = component.find('spinner');
        	$A.util.addClass(spinner, 'showSpinner');
            helper.createMiscellaneousItems(component, event, helper);
        }
    },
    
    hideAvailablePackages : function(component, event, helper){
        var availablePackages = component.find("availDropdown");
        availablePackages.getElement().style.display = 'none';
    },
    
    hideNewOrderItems : function(component, event, helper){
        var newOrderItems = component.find("addNewDropdown");
        newOrderItems.getElement().style.display = 'none';
    },
    
    displayConvert3Pay : function(component, event, helper){
        var threepay = component.find("threePayPanel");
        threepay.getElement().style.display = 'block';
    },
    
    hideConvertTo3Pay : function(component, event, helper){
        var threepay = component.find("threePayPanel");
        threepay.getElement().style.display = 'none';
    },
    
    show3Pay : function(component, event, helper){
        console.log('inside 3 pay conversion');
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner');
        var action = component.get("c.convertOrderToThreePay");
        action.setParams({
            "orderRecordId" : component.get("v.orderRecordId")
        });
        console.log('Params set');
        action.setCallback(this, function(response){
           	var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state of 3 pay conversion: '+state);
            var returnValue = response.getReturnValue().modifiedOrderItemWrappers;
            var iadServiceMessages = response.getReturnValue().iadServiceMessages;
            var threepay = component.find("threePayPanel");
            threepay.getElement().style.display = 'none';    
            if(state === "SUCCESS" && returnValue.length > 0)
            {
                var modifiedItems = component.get("v.theModifiedOrderItemWrappers");
                if(modifiedItems.length > 0)
                {
                    var newItemJsonArray = {'productName':returnValue[0].productName, 'processingOrderId' : returnValue[0].processingOrderId, 'orderItemId':returnValue[0].orderItemId, 'dateTimeCreatedInString':returnValue[0].dateTimeCreatedInString, 'modificationType':returnValue[0].modificationType};
                    modifiedItems.push(newItemJsonArray);
                }else
                {
                    modifiedItems = returnValue;
                }
                component.set("v.theModifiedOrderItemWrappers", modifiedItems);
                if(iadServiceMessages)
                {    
                    for (var i = 0; i < iadServiceMessages.length; i++) {
                        title = iadServiceMessages[i].msgType; 
                        type = iadServiceMessages[i].msgType;
                        message = iadServiceMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                helper.loadData(component, event, helper);
            }
            else
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to load 3Pay: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    editShippingAddress : function(component, event, helper){
        console.log('inside editShippingAddress: iad screen');
        var iadCtrlRef = component.get("v.ctrl");
        var orderNumber = iadCtrlRef.orderNumber;
        var orderContactId;
        if(iadCtrlRef.authorizedContacts.length > 0 && iadCtrlRef.authorizedContacts[0].Contact__r.LZ_Order_Contact_ID__c != null)
        {
        	orderContactId = iadCtrlRef.authorizedContacts[0].Contact__r.LZ_Order_Contact_ID__c;
        }
        else
        {
            orderContactId = "";
        }
        var subtaburl = '#/n/Edit_Shipping_Address?id=' + orderNumber + '&orderContactId=' + orderContactId;
        var tabLabel = 'Edit Shipping Address';
        var tabIcon = 'edit';
        console.log('subtaburl: '+subtaburl);
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    },
    
    createOrderSpecificContact : function(component, event, helper){
        var iadCtrlRef = component.get("v.ctrl");
        var orderNumber = iadCtrlRef.orderNumber;
        var subtaburl = '#/n/Add_Order_Specific_Contact?id=' + orderNumber + '&isNew=true';
        var tabLabel = 'Add Order Specific Contact';
        var tabIcon = 'page';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    },
    
    openPaymentsPage : function(component, event, helper){
        var orderBalance = component.get("v.orderBalanceWrapper");
        console.log('orderBalance: '+JSON.stringify(orderBalance));
        var amount = orderBalance.theOrderBalance.orderBalanceAmount;
        console.log('amount: '+amount);
        
        var ctrlRef = component.get("v.ctrl");
        console.log('ctrlRef: '+JSON.stringify(ctrlRef));
        var orderNumber = ctrlRef.orderNumber;
        var customerId;
        if(component.get("v.customerId")){
        	customerId = component.get("v.customerId")
        }else{
            customerId = ctrlRef.customerId;
        }
        var subtaburl = '#/n/Make_a_Payment?amountdue=1&amount=' + amount + '&orderId=' + orderNumber + '&customerId=' + customerId + '&invokingPage=Order&invokingPageId=' + orderNumber;
        var tabLabel = 'Payment';
        var tabIcon = 'custom17';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    },
    
    openRefundsPage : function(component, event, helper){
        var orderBalance = component.get("v.orderBalanceWrapper");
        console.log('orderBalance: '+JSON.stringify(orderBalance));
        var amount = orderBalance.theOrderBalance.orderBalanceAmount;
        console.log('amount: '+amount);
        
        var ctrlRef = component.get("v.ctrl");
        console.log('ctrlRef: '+JSON.stringify(ctrlRef));
        var orderNumber = ctrlRef.orderNumber;
        var customerId;
        if(component.get("v.customerId")){
        	customerId = component.get("v.customerId")
        }else{
            customerId = ctrlRef.customerId;
        }
        var subtaburl = '#/n/Make_a_Refund?amount=' + amount + '&orderId=' + orderNumber + '&customerId=' + customerId + '&invokingPage=Order&invokingPageId=' + orderNumber;
        var tabLabel = 'Refund';
        var tabIcon = 'custom17';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    }, 
    
    openDiscountPage : function(component, event, helper){
        var ctrlRef = component.get("v.ctrl");
        var orderNumber = ctrlRef.orderNumber;
        var subtaburl = '#/n/Add_Discount?orderId=' + orderNumber;
        var tabLabel = 'Add Discount';
        var tabIcon = 'custom17';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    }, 
    
    openPromoPage : function(component, event, helper){
        var ctrlRef = component.get("v.ctrl");
        var orderNumber = ctrlRef.orderNumber;
        var subtaburl = '#/n/Add_Promo?orderId=' + orderNumber;
        var tabLabel = 'Add Promo';
        var tabIcon = 'custom17';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    }, 
    
    openQuestionnaire : function(component, event, helper){
        console.log("openQuestionnaire");
        var processingorderid = event.currentTarget.dataset.processingorderid;
        component.set("v.poId", processingorderid);
        console.log("processingorderid = " + processingorderid);
        var QuestionnaireVersionsModal = component.find('QuestionnaireVersionsModal');
		QuestionnaireVersionsModal.openQuestionnaireVersions(processingorderid);
    },
    
    openNextPadModal : function(component, event, helper) {
        console.log("openNextPadModal");
        var processingNumber = event.currentTarget.dataset.processingnumber;
        var customerOrderNumber = event.currentTarget.dataset.customerordernumber;
        var orderItemNumber = event.currentTarget.dataset.orderitemnumber;
		var NextPadModal = component.find('NextPadModal');
        
		NextPadModal.openNextPadModal(processingNumber, customerOrderNumber, orderItemNumber);
	}
})