({
    refreshExistingDiscounts : function(component, event, helper) {
    	var action = component.get("c.getExistingDiscounts");
    	var orderId = component.get("v.orderId");
        action.setParams({
            "orderId" : orderId
        });
        
        action.setCallback(this, function(response) {
            var title;
            var type;
            var message;
            var state = response.getState();
          	if (state === "SUCCESS") {
                console.log('return value');
                console.log(JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                var discountReasons = [];
                var discountReasonMap = result.discountReasonMap;
                //console.log("discountReasonMap: "+JSON.stringify(discountReasonMap));
                for ( var key in discountReasonMap ) {
                    discountReasons.push({value:discountReasonMap[key], key:key});
                }
                component.set("v.reasonsForDiscount", discountReasons);
                console.log("discountDetails: "+JSON.stringify(result.discountService.discountDetails));
                component.set("v.existingDiscounts", result.discountService.discountDetails);
                component.set("v.discountAmount", 0);
                component.set("v.comments", "");
                if(discountReasons.length > 0){
                    component.set("v.selectedDiscountReason", discountReasons[0].key);
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
                message = "An error occured when trying to retrive existing discounts: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    validateManagerCredential : function(component, event, helper){
        var action = component.get("c.isValidateManagerCredential");
        action.setParams({
            "usrn" : component.get("v.usrn"), 
            "pwd" : component.get("v.pwd")
        });
        action.setCallback(this, function(response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Is valid credential--->'+JSON.stringify(response.getReturnValue()));
                
                if(response.getReturnValue()){
                    var managerCredPanel = component.find('managerCredPanel');
                    console.log(managerCredPanel);
                    managerCredPanel.getElement().style.display = 'none';
                    helper.applyDiscount(component, event, helper);
                }else{
                    title = "Failure"; 
                    type = "Error";
                    message = "Invalid username or password. Please try again! ";
                    helper.showToast(component, event, helper, title, type, message);
                    helper.hideSpinner(component, event, helper);
                }
                
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to validate manager credentials. Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    applyDiscount : function(component, event, helper) {
        var orderId = component.get("v.orderId");
        var discountAmount = component.get("v.discountAmount");
        var comments = component.get("v.comments");
        var discountReason = component.get("v.selectedDiscountReason");
        var approvedBy = component.get("v.usrn");
        if(approvedBy){
            approvedBy = approvedBy.substring(1, approvedBy.indexOf("@"));
        	console.log('approvedBy--->'+approvedBy);
        }else{
            approvedBy = "";
        }       
        
        var action = component.get("c.applyOrderDiscount");
        action.setParams({
            "orderId" : orderId, 
            "discountAmount" : discountAmount, 
            "comments" : comments, 
            "discountReason" : discountReason,
            "approvedBy" : approvedBy
        });
        action.setCallback(this, function(response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('response from applying discount');
                console.log(JSON.stringify(response.getReturnValue()));
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
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to rerender existing discounts: Please try again!";
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
        $A.util.toggleClass(spinner, "slds-hide");
    },
    
    showSpinner : function(component, event, helper) {
        console.log('inside show spinner method');
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, "slds-hide");
    },
})