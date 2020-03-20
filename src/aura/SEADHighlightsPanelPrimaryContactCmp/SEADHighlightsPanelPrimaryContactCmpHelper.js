({
	loadData : function(component, event, helper) {
		var action = component.get("c.init");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") { 
                var returnValue = response.getReturnValue();
                console.log('returnvalue is '+JSON.stringify(returnValue));
                component.set("v.iadContactWrapper", returnValue );
               	component.set("v.customerId", returnValue.customerId);
                component.set("v.custLogin",returnValue.customerLogin); 
                component.set("v.boxId", returnValue.contactService.boxId);
                component.set("v.oauthToken", returnValue.contactService.oauthToken);
                component.set("v.appURL", returnValue.contactService.appURL);
                component.set("v.userId", returnValue.contactService.userId);
                component.set("v.appId", returnValue.contactService.appId);
                component.set("v.hasBoxAccount", returnValue.contactService.hasBoxAccount);
                var appURL = returnValue.contactService.appURL ;
                var appId =  returnValue.contactService.appId;
                var userId = returnValue.contactService.userId;
                var boxId =  returnValue.contactService.boxId;
                var oauthId = returnValue.contactService.oauthToken;
            console.log("hasboxAccount"+returnValue.contactService.hasBoxAccount );
                var URL = appURL+"/#/root?aid="+appId+"&st=active&imp=false&cid="+userId+"&bid="+boxId+"&at="+oauthId;
                
                component.set("v.boxURL", URL);
                
                //console.log('Email: '+returnValue.contacts[0].Email);
                console.log('customerId: '+returnValue.customerId);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	}
})