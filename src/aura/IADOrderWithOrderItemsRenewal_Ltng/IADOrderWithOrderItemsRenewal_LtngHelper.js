({
    raRenewalTabInfo : function(component, event, helper) {
        console.log('inside raRenewalTabInfo component init method');
        console.log(window.location.href);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            console.log('tab info: '+response);
            console.log('subtab id: '+response.tabId);
            workspaceAPI.getTabURL({
                tabId: response.tabId
            }).then(function(response) {
                console.log('subTabUrl: '+ response);
                if(response.includes("?")){
                    var sURLAndParams = response.split('?');
                    console.log('sURLAndParams: '+sURLAndParams);
                    var sParams = sURLAndParams[1].split('&');
                    console.log('sParams: '+sParams);
                    var sParameterName;
                    var orderId;
                    var customerId;
                    var orderRecordId;
                    for (var i = 0; i < sParams.length; i++) {
                        sParameterName = sParams[i].split('='); //to split the key from the value.
                        console.log('sParameterName: '+sParameterName);
                        if(sParameterName[0] === 'orderId'){
                            orderId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                        }else if(sParameterName[0] === 'customerId'){
                            customerId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                        }else if(sParameterName[0] === 'orderRecordId'){
                            orderRecordId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                        }
                    }
                    component.set("v.orderNumber", orderId);
                    component.set("v.customerId", customerId);
                    component.set("v.orderRecordId", orderRecordId);
                    if(orderId){
                        console.log('im ready to load the order for renewals');
                        helper.loadData(component, event, helper);
                    }
                }
                else{ 
                    console.log('im ready to load the order');
                    helper.loadData(component, event, helper);
                }
            })
            .catch(function(error) { 
                console.log('error loading the order');
                console.log(error);
            }); 
        })
        .catch(function(error) { 
            console.log(error);
        }); 
    },
    
    loadData : function(component, event, helper) {
        console.log('inside loadData: '+component.get("v.orderRecordId"));
        var action = component.get("c.getOrderByOrderId");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "orderNumber" : component.get("v.orderNumber")
        });
        action.setCallback(this, function(response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state inside loadData: '+state);
            if (state === "SUCCESS") 
            { 
                var returnValue = response.getReturnValue();                
                var modifiedOrderItemWrappers = '';            
                
                component.set("v.orderWrapper", returnValue );
                component.set("v.orderItemIdToProductConfigurationId", returnValue.orderItemIdToProductConfigurationId);
                
                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                
                this.getOrderBalanceDetails(component, event, helper);                
            }
            else
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate order details: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    getOrderBalanceDetails : function(component, event, helper){
        console.log('inside getOrderBalanceDetails');
        var action = component.get("c.getOrderBalanceByOrderId");
        action.setParams({
            "orderRecordId" : component.get("v.orderRecordId"),
            "orderNumber" : component.get("v.orderNumber")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state inside getOrderBalanceDetails: '+state);
            if (state === "SUCCESS") 
            { 
                var result = response.getReturnValue();
            	component.set("v.orderBalanceWrapper", result);
                
                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                
                this.getOrderDetails(component, event, helper);
            }
            else
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate order balance: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    getOrderDetails : function(component, event, helper){
        console.log('inside getOrderDetails');
        var action = component.get("c.init");
        action.setParams({
            "orderRecordId" : component.get("v.orderRecordId"),
            "orderNumber" : component.get("v.orderNumber")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();            
            if (state === "SUCCESS") 
            { 
                var result = response.getReturnValue();
                component.set("v.ctrl", result);
                
                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                
                this.getOrderTags(component, event, helper);
            }
            else
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate order details: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    getOrderTags : function(component, event, helper){
        console.log('im inside getOrderTags');
        var action = component.get("c.getOrderTags");
        action.setParams({
            "orderRecordId" : component.get("v.orderRecordId"),
            "orderNumber" : component.get("v.orderNumber")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state inside getOrderTags: '+state);
            if(state == "SUCCESS"){
                var result = response.getReturnValue().orderTagList;
            	component.set("v.orderTagArray", result);
                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                this.getShipmentsByOrderId(component, event, helper);
            }
            else
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate order tags: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    getShipmentsByOrderId : function(component, event, helper){
        console.log('im inside getShipmentsByOrderId');
        var action = component.get("c.getShipmentsByOrderId");
        action.setParams({
            "orderRecordId" : component.get("v.orderRecordId"),
            "orderNumber" : component.get("v.orderNumber")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state inside getShipmentsByOrderId: '+state);
            if(state == "SUCCESS"){
                var result = response.getReturnValue().finalOrderItemShipmentsMap;  
                console.log('shipment map: '+result);            
                var shipments = [];
                for (var key in result) {
                    var value = result[key];
                    shipments.push({value:value, key:key});
                }
                component.set("v.theOrderItemShipments", shipments);
                
                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                
                this.toggleSpinner(component, event, helper);
            }
            else
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate shipment details: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteOT : function(component, event, helper)    {
        var action = component.get("c.deleteOrderTags");
        action.setParams({
            "orderRecordId" : component.get("v.orderRecordId"),
            "tagName" : event.target.dataset.ordertag,
            "orderNumber" : component.get("v.orderNumber")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            if(state == "SUCCESS"){
                this.getOrderTags(component, event, helper);
            }
            else
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to delete order tag: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    createOT : function(component, event, helper)    {
        var action = component.get("c.createOrderTags");
        action.setParams({
            "orderRecordId" : component.get("v.orderRecordId"),
            "tagName" : event.target.value,
            "orderNumber" : component.get("v.orderNumber")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            if(state == "SUCCESS"){                
                this.getOrderTags(component, event, helper);
                event.target.value = '';
            }
            else
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to create order tag: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    getOrderHistory : function(component, event, helper){
        console.log("Element");
        console.log(component.find("orderHistory").getElement().style);
        console.log(component.find("orderHistory").getElement().style.display);
        console.log(component.find("orderHistory").getElement().style.marginLeft);
        var orderHistory = component.find('orderHistory');
        console.log(orderHistory);
        console.log('orderHistory style: ');
        var action = component.get("c.populateOrderHistory");
        action.setParams({
            "orderRecordId" : component.get("v.orderRecordId"),
            "orderNumber" : component.get("v.orderNumber")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            if(state == "SUCCESS"){
                var result = response.getReturnValue();                
                component.set("v.theOrderHistory", result);
                console.log(event);
                $A.util.removeClass(orderHistory, 'hideOrderHistory');
                $A.util.addClass(orderHistory, 'showOrderHistory');
                
                var exceptionMessages = response.getReturnValue().iadServiceMessages;
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                
                this.toggleSpinner(component, event, helper);
            }
            else
            {
                var title = "Error";
                var type = "error";
                var message = "An error occured when trying to get OrderHistory: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    populateActionItems : function(component, event, helper){
        console.log('yo yo: populateActionItems');
        var orderItemDiv = component.find('orderItemDiv');
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'showSpinner'); 
        var orderItemId = event.currentTarget.dataset.orderitemid;
        var actionType = component.get("v.actionType");
        
        var action = component.get("c.populateActionItemsByOrderItemId");
        action.setParams({
            "orderItemId": orderItemId,
            "actionType" : actionType,
        });
        action.setCallback(this, function(response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state: '+state);
            if (state === "SUCCESS") 
            {
                var returnValue = response.getReturnValue();
            	console.log('returnValue: '+JSON.stringify(returnValue));
            
                var exceptionMessages = response.getReturnValue().iadServiceMessages;
            	console.log('exceptionMessages: '+JSON.stringify(exceptionMessages));
            	
                if($A.util.isEmpty(actionType))
                {
                    if(returnValue.currentActionItems.length > 0 ){
                        component.set("v.actionItemsWrapper", returnValue.currentActionItems);
                        //var left = event.pageX - 449;
                        var left = event.pageX - 926;
                        orderItemDiv.getElement().style.left = left + 'px';
                        //var top = event.pageY - 140;
                        //var top = event.pageY - 424;
                        var top = event.pageY;
                        top = event.pageY - 243;
                        orderItemDiv.getElement().style.top = top + 'px';
                        orderItemDiv.getElement().style.display = 'block';
                    }else{
                        orderItemDiv.getElement().style.display = 'none';
                    }
                }
                else if(actionType == 'changePackage')
                {
                    component.set("v.availablePackagesWrapper", returnValue.currentActionItems);
                    var availablePackages = component.find("availDropdown");
                    availablePackages.getElement().style.display = 'block';
                }
                else if(actionType == 'addItem')
                {
                    component.set("v.newOrderItemsWrapper", returnValue.currentActionItems);
                    var newOrderItems = component.find("addNewDropdown");
                    newOrderItems.getElement().style.display = 'block';
                }
                //var empty = '';
                component.set("v.productConfigurationIdToActionItem", returnValue.productConfigurationIdToActionItem);
                //component.set("v.actionType", empty);
                component.set("v.actionType", "");
                
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                this.toggleSpinner(component, event, helper);
            }
            else
            {
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
    
    createMiscellaneousItems : function(component, event, helper){
        var action = component.get("c.createMiscItem");
        action.setParams({
            "orderRecordId": component.get("v.orderRecordId"),
            "itemQuantity" : component.get("v.itemQuantity"),
            "itemPricePerUnit" : component.get("v.itemPricePerUnit"), 
            "itemDescription" : component.get("v.itemDescription"),
            "orderNumber" : component.get("v.orderNumber")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            if(state == "SUCCESS"){
                var returnValue = response.getReturnValue();
            	var modifiedItems = component.get("v.theModifiedOrderItemWrappers");
                var newItemJsonArray = {'productName':returnValue[0].productName, 'processingOrderId' : returnValue[0].processingOrderId, 'orderItemId':returnValue[0].orderItemId, 'dateTimeCreatedInString':returnValue[0].dateTimeCreatedInString, 'modificationType':returnValue[0].modificationType};
                if(modifiedItems.length > 0){
                    modifiedItems.push(newItemJsonArray);
                }else{
                    modifiedItems = returnValue;
                }
                component.set("v.theModifiedOrderItemWrappers", modifiedItems);
                this.loadData(component, event, helper); 
                this.hideAvailablePackagesOrderItemsAndMiscItemDlg(component, event, helper);
            }
            else
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to create Miscellaneous Items: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                this.toggleSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    toggleSpinner : function(component, event, helper) {
        console.log('ready to close the spinner');
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, 'showSpinner');
        $A.util.addClass(spinner, 'hideSpinner');
    },
    
    closeActionItemsPopover : function(component, event, helper){
        var orderItemDiv = component.find('orderItemDiv');
        console.log('orderItemDiv: '+orderItemDiv);
        orderItemDiv.getElement().style.display = 'none';
    },
    
    hideAvailablePackagesOrderItemsAndMiscItemDlg : function(component, event, helper){
        var miscItemPanel = component.find('miscItemPanel');
        miscItemPanel.getElement().style.display = 'none';
        var availablePackages = component.find("availDropdown");
        availablePackages.getElement().style.display = 'none';
        var newOrderItems = component.find("addNewDropdown");
        newOrderItems.getElement().style.display = 'none';
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
    
    openTab : function(component, event, helper, taburl, tabLabel, tabIcon) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: taburl,        
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
    },
    
    openSubTab : function(component, event, helper, subtaburl, tabLabel, tabIcon){
        console.log('path url: '+window.location.href);
        
        var url = window.location.href;
        var subString = url.substring(url.indexOf('.com/')+4);
        console.log('sub: '+subString);
        console.log('subtaburl: '+subtaburl);
        var workspaceAPI = component.find("workspace");
        console.log('Ctrl reference: '+JSON.stringify(component.get("v.ctrl")));
        workspaceAPI.openTab({
            url: subString,
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
})