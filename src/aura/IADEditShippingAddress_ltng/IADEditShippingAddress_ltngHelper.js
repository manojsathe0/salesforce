({
    createOsContact : function(component, event, helper, orderNumber, orderContactId, isNewOrderSpecificContact) {
		console.log('inside createOrderSpecificContact');
        var action = component.get("c.createContact");
        action.setParams({
            "orderNumber" : component.get("v.orderNumber"),
            "ocId" : component.get("v.orderContactId"),
            "isNewOsContact" : component.get("v.isNewOrderSpecificContact"),
            "localContact" : component.get("v.shippingContact")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state: '+state);
            if(state === 'SUCCESS'){
                console.log('Success');
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
                message = "An error occured when trying to create order specific contact: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action); 
	},
    
    updateOsContact : function(component, event, helper) {
		console.log('inside update contact');
        console.log('v.shippingContact: '+JSON.stringify(component.get("v.shippingContact")));
        var action = component.get("c.updateContact");
        action.setParams({
            "orderNumber" : component.get("v.orderNumber"),
            "ocId" : component.get("v.orderContactId"),
            "isNewOsContact" : component.get("v.isNewOrderSpecificContact"),
            "localContact" : component.get("v.shippingContact")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            console.log('state: '+state);
            if(state === 'SUCCESS'){
                console.log('Success');
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
                message = "An error occured when trying to update order specific contact: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    deleteOsContact : function(component, event, helper, orderNumber, orderContactId) {
		console.log('inside delete contact');
        var action = component.get("c.deleteContact");
        console.log('Order Number: '+component.get("v.orderNumber"));
        console.log('Order Contact Id: '+component.get("v.orderContactId"));
        action.setParams({
            "orderNumber" : component.get("v.orderNumber"),
            "ocId" : component.get("v.orderContactId"),
            "authid" :component.get("v.authorizedid")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            var iadServiceMessages = response.getReturnValue().iadServiceMessages;
            console.log('iadServiceMessages: '+iadServiceMessages);
            console.log('state: '+state);
            if(state === 'SUCCESS'){
                console.log('Success');
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
                message = "An error occured when trying to delete order specific contact: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
	},
    
    getShippingAddress : function(component, event, helper, orderNumber, orderContactId, isNewOrderSpecificContact){
        console.log('im inside shipping address controller function');
        console.log(orderNumber+'......'+orderContactId);
        var action = component.get("c.populateShippingAddress");
        action.setParams({
            "orderNumber" : orderNumber,
            "ocId" : orderContactId,
            "isNewOsContact" : isNewOrderSpecificContact
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
                
            if(state === "SUCCESS"){
                var result = response.getReturnValue().shippingContact;
                var shippingStates = response.getReturnValue().statePicklist;
                var iadServiceMessages = response.getReturnValue().iadServiceMessages;
                console.log('edit shipping address controller function: state '+state);
                console.log('shipping address stringified: '+JSON.stringify(result));
                console.log('shipping states: '+JSON.stringify(shippingStates));
                component.set("v.shippingContact", result);
                component.set("v.states", shippingStates);
                
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
                message = "An error occured when trying to retrieve order specific contact: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }
                       
        });
        $A.enqueueAction(action);
    },
	
	getCtrlRef : function(component, event, helper, orderNumber, orderContactId, isNewOrderSpecificContact){
        console.log('im inside getCtrlRef');
        console.log(orderNumber+'......'+orderContactId);
        var action = component.get("c.init");
        action.setParams({
            "orderNumber" : orderNumber,
            "ocId" : orderContactId,
            "isNewOsContact" : isNewOrderSpecificContact
        });
        action.setCallback(this, function(response){
            var state = response.getState();
                
            if(state === "SUCCESS"){
                var result = response.getReturnValue().shippingContact;
                var shippingStates = response.getReturnValue().statePicklist;
                component.set("v.shippingContact", result);
                component.set("v.states", shippingStates);
                console.log('result: '+result);
                console.log('states: '+shippingStates);
                helper.hideSpinner(component, event, helper);
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate default values: Please try again!";
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
        var spinner = component.find('mySpinner');
        $A.util.toggleClass(spinner, "slds-hide");
    },
    
    showSpinner : function(component, event, helper) {
        console.log('inside show spinner method');
        var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-hide");
    },
})