({
	doInit : function(component, event, helper) {
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
                    var sParams = sURLAndParams[1].split('=');
                    console.log('sParams: '+sParams);
                    var sParameterName;
                    var orderId;
                    
                    if(sParams.length > 0 && sParams[0] === 'orderId') {
                        orderId = (sParams[1] != null || sParams[1] != '' || sParams[1] != undefined) ? sParams[1] : '';
                    }
                    component.set("v.orderId", orderId);
                    helper.showSpinner(component, event, helper);
                    helper.isPromoCodeAppliedAlready(component, event, helper);
                } 
            }); 
        })
        .catch(function(error) { 
            console.log(error);
        }); 
    },
    
    validateFormAndApplyPromoCode : function(component, event, helper){
        console.log('validating promocode form');
        var validContact = component.find('promoForm').reduce(function (validSoFar, inputCmp) { 
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validContact){
            helper.showSpinner(component, event, helper);
            helper.applyPromotionalCode(component, event, helper);
        }
    },
    
    checkPromo : function(component, event, helper) {
        var title = "Error";
        var type = "Error";
        var message = "Please Provide Promo Code";
    	var promoCode = component.get("v.promoCode");
    	if(promoCode) 
        {
            console.log('ready to validate the promo code');
            helper.showSpinner(component, event, helper);
    		helper.validatePromoCode(component, event, helper);
    	}
    	else
        {
            helper.showToast(component, event, helper, title, type, message);
        }
    },
    
    cancelPromotionalCode : function(component, event, helper) {
        helper.showSpinner(component, event, helper);
    	var action = component.get("c.cancelPromoCode");
        action.setParams({
            "orderId": component.get("v.orderId"), 
            "currentPromoCode" : component.get("v.currentPromoCode")
        });
		action.setCallback(this, function(response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var promoCodeService = response.getReturnValue();
                var iadServiceMessages = response.getReturnValue().iadServiceMessages;
            	if (promoCodeService.isPromoCodeCancelled) 
                {
                    component.set("v.comments", null);
                    component.set("v.promoCode", null);
                    component.set("v.currentPromoCode", null);
                    component.set("v.promoAppliedAmount", null);
                    component.set("v.promoApplied", false);
            	}
            	else 
                {
            		component.set("v.promoValue", null);
            	}
                if(iadServiceMessages){
                    for (var i = 0; i < iadServiceMessages.length; i++) {
                        title = iadServiceMessages[i].msgType; 
                        type = iadServiceMessages[i].msgType;
                        message = iadServiceMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                	}
                }
                helper.hideSpinner(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to cancel promo code: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            } 
        });
        $A.enqueueAction(action);
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