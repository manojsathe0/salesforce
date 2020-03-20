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
                                
                                for (var i = 0; i < sParams.length; i++) {
                                    sParameterName = sParams[i].split('='); //to split the key from the value.
                                    console.log('sParameterName: '+sParameterName);
                                    if(sParameterName[0] === 'orderId'){
                                        orderId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                    }
                                }
                                console.log('test.....');
                                console.log('orderId----->'+orderId);
                                component.set("v.orderId", orderId);
                                helper.showSpinner(component, event, helper);
                                helper.isPromoCodeAppliedAlready(component, event, helper);
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
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var title;
                var type;
                var message;
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
            }
            else {
                console.log("Failed with state: " + state);
            }
            helper.hideSpinner(component, event, helper);
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