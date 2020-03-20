({
	postlogin : function(component, event, helper) {
         var action = component.get("c.LoginUser");
        action.setParams({
            "leadid" : component.get("v.recordId"),
           
        });
        action.setCallback(this, function(response){
          var state = response.getState();
            var returnValue = response.getReturnValue();
              
            if (state === "SUCCESS") { 
                
                console.log('inside success '+JSON.stringify(returnValue));               
                if(returnValue !=null&&returnValue.includes("Does"))  {
                 var title = "Error";
                 var type = "error";
                 var message = returnValue;
                helper.showToast(component , event, helper, title, type, message);  
                }     
                else if(returnValue !=null && returnValue!=''){
                    window.open(returnValue,"mywindow",'height='+screen.height+', width='+screen.width);
                }
                else{
                   
                }
                 
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
    passwordReset : function(component, event, helper) {
        helper.showSpinner(component, event, helper) ;
        
        var action = component.get("c.ResetPassword");
        action.setParams({
            
            "leadid" : component.get("v.recordId"),
        }); 
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") { 
                
                var title;
                var type;
                var message;
                var  exceptionMessages =response.getReturnValue().exceptions;
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component , event, helper, title, type, message);
                    }
                    
                    helper.hideSpinner(component,event,helper); 
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
    }
})