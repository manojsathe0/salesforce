({
	doInit : function(component, event, helper) {
		
	},
	handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    submit :  function(component, event, helper) {
    	component.set("v.success", false);
        component.set("v.hasErrors", false);
		
    	var emailField = component.find("emailId");
    	var emailAddress = emailField.get("v.value");
    	
    	if (emailAddress == undefined) {
            emailField.set("v.errors", [{message: "You must enter a value"}]);
            return;
        }
        else {
        	emailField.set("v.errors", null);
        }
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if (!re.test(String(emailAddress).toLowerCase())) {
        	component.set("v.hasErrors", true);
        	component.set("v.message", "The email address must be in a valid format to create a new account. For example: xyz123@mail.com.");
        	return;
        }
        else {
        	component.set("v.hasErrors", false);
        	component.set("v.message", "");
        }
        
        
        var action = component.get("c.createAccount");
        action.setParams({"email" : emailAddress});
        action.setCallback(this, function(response) {
            helper.showSpinner(component, event, helper);
        	var state = response.getState();
        	console.log("State: " + state);
            if (state === "SUCCESS") {
            	console.log("response.getReturnValue(): " + response.getReturnValue());
            	var JSONResponse = JSON.parse(response.getReturnValue());

            	if (JSONResponse.message == undefined) {
            		if (JSONResponse.errors[0].code == "email_exists") {
            			component.set("v.hasErrors", true);
            			component.set("v.message", "This email address entered is already in use on a LegalZoom account");
            		}
            		else {
            			component.set("v.hasErrors", true);
            			component.set("v.message", "Could not submit the request at this time.");
            		}
            	}
            	else {
            		component.set("v.success", true);
            		component.set("v.message", "Login Account was sucessfully created. Custumer Id is " + JSONResponse.customerId + "."); 
            	}
            
            
            	
                    //component.set("v.reasonForTransferValues", );
            }
            else {
            	console.log("Failed with state: " + state);
            	var errors = response.getError();            	
            	var message = 'Unknown error';
				if (errors && Array.isArray(errors) && errors.length > 0) {
					console.log("errors: " + errors);
					message = errors[0].message;
                    component.set("v.hasErrors", true);
                    component.set("v.message", message);
				}
                
             }
            helper.hideSpinner(component, event, helper);
         });
         $A.enqueueAction(action);     
        
    	

    	
    	
    }
})