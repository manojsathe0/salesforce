({
    doInit : function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(
                function(){
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.getFocusedTabInfo().then(function(response) { 
                        console.log('tab info: '+response);
                        console.log('subtab id: '+response.tabId);
                        workspaceAPI.getTabURL({
                            tabId: response.tabId
                        }).then(function(response) {
                            console.log('subTabUrl: '+ response);
                            var subTabUrl = response;
                            console.log('subTabUrl: subTabUrl.includes("?")'+subTabUrl.includes("?"));
                            if(response.includes("?")){
                                var sURLAndParams = response.split('?');
                                console.log('sURLAndParams: '+sURLAndParams);
                                var sParams = sURLAndParams[1].split('&');
                                console.log('sParams: '+sParams);
                                var sParameterName;
                                var orderId;
                                var orderSubTotal;
                                
                                for (var i = 0; i < sParams.length; i++) {
                                    sParameterName = sParams[i].split('='); //to split the key from the value.
                                    console.log('sParameterName: '+sParameterName);
                                    if(sParameterName[0] === 'orderId'){
                                        orderId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                    }else if(sParameterName[0] === 'orderSubTotal'){
                                        orderSubTotal = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                    }
                                }
                                
                                component.set("v.orderId", orderId);
                                component.set("v.orderSubTotal", orderSubTotal);
                                helper.refreshExistingDiscounts(component, event, helper);
                            } 
                        }); 
                    })
                    .catch(function(error) { 
                        console.log(error);
                    }); 
                }
            ),
            1000
        );
   	},
    
    validateFormAndApplyDiscount : function(component, event, helper){
        console.log('validating form');
        var validContact = component.find('discountform').reduce(function (validSoFar, inputCmp) { 
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validContact){
            var isDiscountOverTenPercent = component.get("v.discountAmount") >= ( component.get("v.orderSubTotal") * 10 ) / 100;
            console.log("isDiscountOverTenPercent--->"+isDiscountOverTenPercent);
            if(isDiscountOverTenPercent){
                var managerCredPanel = component.find('managerCredPanel');
                console.log(managerCredPanel);
                managerCredPanel.getElement().style.display = 'block';
            }else{
                helper.showSpinner(component, event, helper);
                helper.applyDiscount(component, event, helper);
            }
        }
    }, 
    
    validateManagerCredentialAndApproveDiscount : function(component, event, helper){
        console.log('validating form');
        var validData = component.find('approvalForm').reduce(function (validSoFar, inputCmp) { 
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validData){
            helper.showSpinner(component, event, helper);
            helper.validateManagerCredential(component, event, helper);
        }
    },    
    
    hideManagerCredPanel : function(component, event, helper){
        component.set("v.usrn", "");
        component.set("v.pwd", "");
        var managerCredPanel = component.find('managerCredPanel');
        console.log(managerCredPanel);
        managerCredPanel.getElement().style.display = 'none';
    },
    
    showConfirmation : function(component, event, helper) {
        var discountId = event.target.id;
        component.set("v.discountToCancelId", discountId);
        
        var cancelDiscount = component.find("cancelDiscount");
        $A.util.toggleClass(cancelDiscount, "slds-hide");
    },
    
    closeConfirmation : function(component, event, helper) {
        var cancelDiscount = component.find("cancelDiscount");
        $A.util.toggleClass(cancelDiscount, "slds-hide");
    },
    
    cancelExistingDiscount : function(component, event, helper) {
        helper.showSpinner(component, event, helper);
        var discountId = component.get("v.discountToCancelId");
        var orderId = component.get("v.orderId");
        
        var action = component.get("c.cancelDiscount");
        action.setParams({
            "orderId" : orderId, 
            "OrderDiscountId" : discountId
        });
        action.setCallback(this, function(response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state === "SUCCESS") {
                var iadServiceMessages = response.getReturnValue().iadServiceMessages;
                if(iadServiceMessages){
                    for (var i = 0; i < iadServiceMessages.length; i++) {
                        title = iadServiceMessages[i].msgType; 
                        type = iadServiceMessages[i].msgType;
                        message = iadServiceMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
                helper.refreshExistingDiscounts(component, event, helper);
                var cancelDiscount = component.find("cancelDiscount");
        		$A.util.toggleClass(cancelDiscount, "slds-hide");
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to cancel discount: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    toggleIconsAndTable : function(component, evnet, helper){
        var downIcon = component.find("downIcon");
        var rightIcon = component.find("rightIcon");
        var discountsTable = component.find("discountsTable");
        
        $A.util.toggleClass(downIcon, "slds-hide");
        $A.util.toggleClass(rightIcon, "slds-hide");
        $A.util.toggleClass(discountsTable, "slds-hide");
    },
    
    closeFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})