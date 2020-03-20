({

	doInit : function(component, event, helper) {
		var getContactStatus = component.get("c.getContactStatusValues");
		getContactStatus.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.contactStatusValues", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(getContactStatus);
        
        var getReasonForContact = component.get("c.getReasonForContactValues");
		getReasonForContact.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.reasonForContactValues", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(getReasonForContact);
        
        var getReasonForTrasnfer = component.get("c.getReasonForTransferValues");
		getReasonForTrasnfer.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.reasonForTransferValues", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(getReasonForTrasnfer);
	
	},
    submit :  function(component, event, helper) {
        component.set("v.success", false);
        component.set("v.hasErrors", false);
        var contStatus = component.find("contStatus");
        var rsnContact = component.find("rsnContact");
        var rsnTransfer = component.find("rsnTransfer");
        var otherRsn = component.find("otherRsn");
        var comment = component.find("comment");
        //alert(contStatus.get("v.value") );
        
        if (contStatus.get("v.value") == "--None--" || contStatus.get("v.value") == undefined) {
            contStatus.set("v.errors", [{message: "You must enter a value"}]);
            return;
        }
        else {
            contStatus.set("v.errors", null);
        }
        
        if (rsnContact.get("v.value") == "--None--" || rsnContact.get("v.value") == undefined) {
            rsnContact.set("v.errors", [{message: "You must enter a value"}]);
            return;
        }
        else {
            rsnContact.set("v.errors", null);
        }
       
        if (comment.get("v.value") == undefined) {
            comment.set("v.errors", [{message: "You must enter a value"}]);
            return;
        }
        else {
            comment.set("v.errors", null);
        }
        
        
        if (rsnContact.get("v.value") == "Transfer") {
            if (rsnTransfer.get("v.value") == "--None--" || rsnTransfer.get("v.value") == undefined) {
                rsnTransfer.set("v.errors", [{message: "You must enter a value"}]);
                return;
            }
            else {
                rsnTransfer.set("v.errors", null);
            }
        }
        
        if (rsnContact.get("v.value") == "Other") {
            if (otherRsn.get("v.value") == undefined) {
                otherRsn.set("v.errors", [{message: "You must enter a value"}]);
                return;
            }
            else {
                otherRsn.set("v.errors", null);
            }
        }
        var recordId = component.get("v.recordId");
        if (recordId.indexOf("006") === 0) {
       		var doSubmitOpp = component.get("c.createTaskOpp");
            doSubmitOpp.setParams({"oppId" : component.get("v.recordId"), "contactStatus" : component.get("v.contactStatusSelected")
                                  , "reasonForContact" : component.get("v.reasonForContactSelected"), "reasonForTransfer" : component.get("v.reasonForTransferSelected")
                                  , "otherReason" : component.get("v.otherReason"), "description" : component.get("v.description")});
            doSubmitOpp.setCallback(this, function(response) {
                var state = response.getState();
                //alert(state);
                //alert(response.getReturnValue());
                if (state === "SUCCESS") {
                    component.set("v.success", true);
                    component.set("v.message", response.getReturnValue());
                    //component.set("v.reasonForTransferValues", );
                }
                else {
                    var errors = response.getError();
					var message = 'Unknown error';
					if (errors && Array.isArray(errors) && errors.length > 0) {
    					message = errors[0].message;
                        component.set("v.hasErrors", true);
                        component.set("v.message", message);
					}
                    console.log("Failed with state: " + state);
                }
            });
            $A.enqueueAction(doSubmitOpp); 
        }
        
       

        
       	if (recordId.indexOf("00Q") === 0) {
       		var doSubmitLead = component.get("c.createTaskLead");
            doSubmitLead.setParams({"leadId" : component.get("v.recordId"), "contactStatus" : component.get("v.contactStatusSelected")
                                  , "reasonForContact" : component.get("v.reasonForContactSelected"), "reasonForTransfer" : component.get("v.reasonForTransferSelected")
                                  , "otherReason" : component.get("v.otherReason"), "description" : component.get("v.description")});
            doSubmitLead.setCallback(this, function(response) {
                var state = response.getState();
                //alert(state);
                //alert(response.getReturnValue());
                if (state === "SUCCESS") {
                    component.set("v.success", true);
                    component.set("v.message", response.getReturnValue());
                    //component.set("v.reasonForTransferValues", );
                }
                else {
                    var errors = response.getError();
					var message = 'Unknown error';
					if (errors && Array.isArray(errors) && errors.length > 0) {
    					message = errors[0].message;
                        component.set("v.hasErrors", true);
                        component.set("v.message", message);
					}
                    console.log("Failed with state: " + state);
                }
            });
            $A.enqueueAction(doSubmitLead);     
        }
    
        
    },

	handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})