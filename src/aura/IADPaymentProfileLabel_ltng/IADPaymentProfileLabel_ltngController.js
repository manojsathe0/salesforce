({
	populatePaymentLabel : function(component, event, helper) {
        console.log('ready to load payment profile label');
        var ppId = event.getParams("payProfileId");
        console.log('paymentProfileId: '+JSON.stringify(ppId.payProfileId));
		var action = component.get("c.populatePaymentProfile");
        action.setParams({
            "paymentProfileId" : ppId.payProfileId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state inside populatePaymentLabel: '+state);
            if(state === "SUCCESS")
            {
                console.log('profileLabel: '+response.getReturnValue());
                var profileLabel = response.getReturnValue();
                component.set("v.profileLabel", profileLabel);
            }
        });
        $A.enqueueAction(action);
	}
})