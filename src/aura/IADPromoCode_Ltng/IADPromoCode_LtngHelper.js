({
	isPromoCodeAppliedAlready :  function(component, event, helper) {
    	var action = component.get("c.displayPromoCode");
    	action.setParams({
            "orderId": component.get("v.orderId")
        });
		action.setCallback(this, function(response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state === "SUCCESS") {
            	var promoCodeService = response.getReturnValue();
                console.log('promoCodeService: onload');
                console.log(JSON.stringify(promoCodeService));
                if(promoCodeService.hasPromoCode){
                    component.set("v.promoApplied", promoCodeService.hasPromoCode);
                    component.set("v.currentPromoCode", promoCodeService.currentPromoCode);
                    component.set("v.promoAppliedAmount", promoCodeService.currentAmount);
                }
                
                var iadServiceMessages = response.getReturnValue().iadServiceMessages;
            	console.log('iadServiceMessages: '+iadServiceMessages);
                if(iadServiceMessages){                
                    for (var i = 0; i < iadServiceMessages.length; i++) {
                        title = iadServiceMessages[i].msgType; 
                        type = iadServiceMessages[i].msgType;
                        message = iadServiceMessages[i].message;
                    }
                    helper.showToast(component, event, helper, title, type, message);
                }
                helper.hideSpinner(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to retrieve promo code: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }            
        });
        $A.enqueueAction(action);
    },
    
    validatePromoCode : function(component, event, helper){
        var action = component.get("c.checkPromoCode");
        action.setParams({
            "orderId": component.get("v.orderId"), 
            "promoCode" : component.get("v.promoCode")
        });
		action.setCallback(this, function(response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state === "SUCCESS") {
                var promoCodeService = response.getReturnValue();
                var iadServiceMessages = response.getReturnValue().iadServiceMessages;
                console.log('promocodeservice: oncheck');
                console.log(promoCodeService);
            	if (promoCodeService.isPromoCodeValid) 
                {
            		component.set("v.promoValue", promoCodeService.promoCodeValue);
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
                message = "An error occured when trying to validate promo code: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    applyPromotionalCode : function(component, event, helper) {
    	var action = component.get("c.applyPromoCode");
        action.setParams({
            "orderId": component.get("v.orderId"), 
            "promoCode" : component.get("v.promoCode"), 
            "comments" : component.get("v.comments")
        });
		action.setCallback(this, function(response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state === "SUCCESS") {
                var promoCodeService = response.getReturnValue();
                var iadServiceMessages = response.getReturnValue().iadServiceMessages;
            	if (promoCodeService.isPromoCodeApplied) {
            		helper.isPromoCodeAppliedAlready(component, event, helper);
            	}
            	else {
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
                message = "An error occured when trying to apply promo code: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    
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
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "slds-hide");
    },
    
    showSpinner : function(component, event, helper) {
        console.log('inside show spinner method');
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, "slds-hide");
    },
    
})