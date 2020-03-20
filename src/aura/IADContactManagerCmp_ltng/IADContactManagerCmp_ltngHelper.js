({
	getCtrlRef : function(component, event, helper, recordId){
        var action = component.get("c.init");
         action.setParams({
            "recordId": recordId
        });
        
        
        
            action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") { 
                var returnValue = response.getReturnValue();
                var stpicklist = response.getReturnValue().statePicklist;
                var state = response.getReturnValue().newContact.MailingState;
                var lzconId = response.getReturnValue().newContact.LegalZoom_Contact_ID__c;
                var custId =response.getReturnValue().newContact.FkUser__c;
                var lifeplan=response.getReturnValue().newContact.Life_Plan_Company_c__c;
               
                var contype= response.getReturnValue().contactType;
                var isauthc;
                if(contype == "Authorized Contact"){
                    isauthc=true;
                }
                
                
                component.set("v.newContact", returnValue.newContact);
                component.set("v.selectOptions", stpicklist);
                component.set("v.lifeplan", lifeplan);
                if(component.get("v.recordId")==null)
                component.set("v.newContact.MailingState",stpicklist[0]);
                component.set("v.lzContactId", lzconId);
                component.set("v.customerId", custId);
                component.set("v.oac",isauthc );
                component.set("v.isLifePlanUser", response.getReturnValue().newContact.Life_Plan__c);
                
                //component.find("mlstate").set("v.value", component.get("v.newContact.MailingState"));
                
               
                
                
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
    },
   
     hideSpinner : function(component, event, helper) {
        console.log('inside hide spinner method');
        var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-show");
    },
    showSpinner : function(component, event, helper) {
        console.log('inside hide spinner method');
        var spinner = component.find('mySpinner');
        $A.util.addClass(spinner, "slds-show");
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
    //STORY B-38226 - Starts Here
    sucessUpdateCLEmailHelper : function(component,event){
        var msg = event.getParam('updatedValue') || '';
        component.set("{!v.newContact.Customer_Login_Email__c}",$A.util.isEmpty(msg)?null:msg);
        if(!$A.util.isEmpty(msg) && component.get("v.newContact.Contact_Type__c") == 'Primary Contact'){
            component.set("{!v.newContact.Email}",msg);
        }
    },
    // STORY B-38226 - Ends Here
})