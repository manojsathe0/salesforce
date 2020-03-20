({

	doInit : function(component, event, helper) {
        console.log('inside onload: ');
        console.log('record Id: '+component.get("v.recordId"));
		var action = component.get("c.onload");
        action.setParams({
            "contactId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
           	var state = response.getState();
            console.log('state inside onload: '+state);
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result:');
                console.log(JSON.stringify(result));
                component.set("v.states", result.statePicklist);
                console.log(result.statePicklist);
                component.set("v.newContact", result.newContact);
                console.log(result.newContact);
                component.set("v.orderAuthorizedContact", result.orderAuthorizedContact);
                if(result.orderAuthorizedContact || result.newContact.Duplicate__c){
                    component.set("v.displayContactForm", true);
                }
                if(result.newContact.Duplicate__c){
                    component.set("v.orderAuthorizedContact", false);
                }
                component.set("v.fkUser", result.newContact.FkUser__c);
                console.log('FkUser__c');
                console.log(result.newContact.FkUser__c);
                console.log(result.newContact); 
                component.set("v.contactType", result.contactType);
           }
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(action);
	},
    
    contactUpdate : function(component, event, helper){
        helper.showSpinner(component, event, helper);
        var action = component.get("c.updateContact");
        action.setParams({
            "contactId" : component.get("v.recordId"),
            "newContact" : component.get("v.newContact"),
            "contactType" : component.get("v.contactType")
        });
        action.setCallback(this, function(response){
            var contactId;
            var title;
            var type;
            var message;
           	var state = response.getState();
            console.log('state inside update contact: '+state);
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log("result: "+JSON.stringify(result));
                if(result.returnId){
                    contactId = result.returnId;
                    console.log('returnId: '+contactId);
                }
                var messages = result.messages;
                if(messages && messages.length > 0){
                    for (var i = 0; i < messages.length; i++) {
                        title = messages[i].msgType; 
                        type = messages[i].msgType;
                        message = messages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                	}
                }
                if(contactId && contactId != component.get("v.recordId")){
                    console.log('ready to redirectToContactDetail');
                    helper.redirectToContactDetail(component, event, helper, contactId);
                }
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire()
            }
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(action);
    },    
    
    
    /*
    createContact : function(component, event, helper){
        helper.showSpinner(component, event, helper);
        var action = component.get("c.createNewContact");
        action.setParams({
            "contactId" : component.get("v.recordId"),
            "fkUser" : component.get("v.fkUser")
        });
        action.setCallback(this, function(response){
           	var state = response.getState();
            console.log('state inside create contact: '+state);
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log("result: "+JSON.stringify(result));
            }
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    */
})