({
    getAccountStatus : function(component, event, helper){
        helper.showspinner(component, event);
        // helper.showspinner(component, event);
        var action = component.get("c.AccountStatus");
        action.setParams({
            "recordid" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var title;
            var type;
            var message;
            
            if(state ==="SUCCESS"){
                
                var  exceptionMessages =response.getReturnValue().iadServiceMessages; 
                
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component , event, helper, title, type, message);
                    }
                    
                    helper.toggle(component,event);            
                }   
                component.set("v.Accounttype",response.getReturnValue().Accounttype);
                component.set("v.primarycontactName",response.getReturnValue().primarycontactName);
                component.set("v.currentLoginUserName",response.getReturnValue().currentLoginUserName);              
                if(response.getReturnValue().deSerializedpayment!=null)
                {
                    
                    component.set("v.status",response.getReturnValue().deSerializedpayment.subscriberData.webActive);
                    component.set("v.statusdescription",response.getReturnValue().deSerializedpayment.subscriberData.cbStatus);
                    component.set("v.subscribernumber",response.getReturnValue().deSerializedpayment.subscriberNumber);
                    console.log('the number'+response.getReturnValue().deSerializedpayment.subscriberNumber);
                    
                }
                
                helper.toggle(component,event);
                helper.getInvitationDetails(component, event,helper);
                
                
            }
        });
        $A.enqueueAction(action);
    },
    
    toggle: function (component, event) {
        var spinner = component.find("mySpinner1");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    showspinner: function (component, event) {
        var spinner = component.find("mySpinner1");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    
    callDeactivateAccount : function(component, event, helper){
        console.log('the number'+component.get("v.subscribernumber"));
        var action = component.get("c.DeActivateAccount");
        action.setParams({
            "recordid" : component.get("v.recordId"),
            "subscribernumber" : component.get("v.subscribernumber"),
            "reason" : component.get("v.deactivatereason")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            var title;
            var type;
            var message;
            if(state ==="SUCCESS"){
                var  exceptionMessages =response.getReturnValue().iadServiceMessages; 
                
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component , event, helper, title, type, message);
                    }
                    
                    helper.toggle(component,event);
                    helper.hidedeactivatemodalaftersuccess(component, event, helper);
                }   
            }
            else
            {
                helper.toggle(component,event);  
                helper.hidedeactivatemodalaftersuccess(component, event, helper);
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
    getInvitationDetails : function(component, event, helper){
        helper.showspinner(component, event);
        // helper.showspinner(component, event);
        var action = component.get("c.InvitationDetails");
        action.setParams({
            "recordid" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var title;
            var type;
            var message;
            
            if(state ==="SUCCESS"){
                
                var  exceptionMessages =response.getReturnValue().iadServiceMessages; 
                
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component , event, helper, title, type, message);
                    }
                    
                    helper.toggle(component,event);            
                }   
                if(response.getReturnValue().eligibility!=null)
                {
                    if(response.getReturnValue().eligibility=='Yes')
                    {
                        component.set("v.eligibility",'No' );
                        //component.set("v.Accounttype",'PlusOne');
                    }
                    else
                    {
                        
                        component.set("v.eligibility",'Yes');   
                    }
                    
                }
                if(response.getReturnValue().deSerializedpayments!=null)
                {
                    
                    component.set("v.Email",response.getReturnValue().deSerializedpayments.productInvitations[0].sentToEmail);
                    component.set("v.productInvitationId",response.getReturnValue().deSerializedpayments.productInvitations[0].productInvitationId);
                    component.set("v.customerId",response.getReturnValue().deSerializedpayments.productInvitations[0].customerId);
                   
                    if(response.getReturnValue().deSerializedpayments.productInvitations[0].sentToName!=null)
                    {  
                        
                        var names=[];
                        var sentname =response.getReturnValue().deSerializedpayments.productInvitations[0].sentToName;
                        names= sentname.split(" ");
                        component.set("v.firstname",names[0]); 
                        component.set("v.lastname",names[1]);
                        
                    }
                    if(response.getReturnValue().deSerializedpayments.productInvitations[0].sentToEmail!=null)
                    {  component.set("v.eligibility",'Yes' );
                     component.set("v.Inivitationsentdate",response.getReturnValue().deSerializedpayments.productInvitations[0].sentDate);
                     if(response.getReturnValue().deSerializedpayments.productInvitations[0].acceptedEmail!=null)  
                     {
                     	component.set("v.eligibility",'No' );
                         component.set("v.Inivitationstatus",'Accepted')  ; 
                         component.set("v.Inivitationaccepteddate",response.getReturnValue().deSerializedpayments.productInvitations[0].acceptedDate);
                         
                     }else
                         
                     {
                         
                         var expirydate =  $A.localizationService.formatDate(response.getReturnValue().deSerializedpayments.productInvitations[0].expiryDate, "yyyy-MM-dd");  
                         console.log('the expire date'+expirydate);
                         var today = new Date();
                         var todaydate =$A.localizationService.formatDate( today, "yyyy-MM-dd"); 
                         console.log('the adte '+todaydate);
                         component.set("v.Inivitationexpirydate",response.getReturnValue().deSerializedpayments.productInvitations[0].expiryDate);
                         if(expirydate<todaydate) 
                         {
                             component.set("v.Inivitationstatus",'Expired')  ;
                             //component.set("v.Inivitationexpirydate",response.getReturnValue().deSerializedpayments.productInvitations[0].expiryDate);
                             component.set("v.eligibility",'Yes' );
                         }
                         else
                         {
                             component.set("v.Inivitationstatus",'Sent')  ;
                             component.set("v.Inivitationsentdate",response.getReturnValue().deSerializedpayments.productInvitations[0].sentDate);
                         }
                     }
                     
                     
                     
                    }
                    
                    
                }
                helper.toggle(component,event);
            }
        });
        $A.enqueueAction(action);
    },
    
    hidedeactivatemodalaftersuccess : function(component, event, helper) {
        var miscItemPanel = component.find('miscItemPanel1234');
        miscItemPanel.getElement().style.display = 'none';
        
    },
    sendInvitations : function(component, event, helper) {
          helper.showspinner(component, event);
          var sendOrResendInvitationaction = component.get("c.sendInvitation"); //Anvesh @B-33787
         var payloadData='{'
         +'"customerId":'+component.get("v.customerId")+','
         +'"productInvitation":'+'{'
             +'"productInvitationId":'+ component.get("v.productInvitationId")+','
             +'"sentToEmail":"'+component.get("v.itpEmail")+'",' 
             +'"sentToName":"'+component.get("v.itpfirstname")+' '+component.get("v.itplastname")+  '",'
         +'"updatedBy":"'+component.get("v.currentLoginUserName")+'",'+'"description":"'+component.get("v.customerId")+'"'+ '}'
             +'}'; 
                             
             //alert(payloadData);                
        sendOrResendInvitationaction.setParams({
            "payload" : payloadData,
            "recId":component.get("v.recordId")
        });
                  sendOrResendInvitationaction.setCallback(this, function(response){
               var state = response.getState();
              if(state ==="SUCCESS"){
               
                   helper.cancel(component, event, helper);
              }else{
                    var  exceptionMessages =response.getReturnValue().iadServiceMessages; 
                
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component , event, helper, title, type, message);
                    }
                }
              }
               //component.set("v.spinner",false);
               helper.toggle(component,event);
          });
          $A.enqueueAction(sendOrResendInvitationaction);
     },
      cancel  : function(component, event, helper) {
        component.set("v.showSendCancelButtonFlag",false); 
        component.set("v.invitationFlag",false);
         component.set("v.itpfirstname",null); 
         component.set("v.itplastname",null);
         component.set("v.itpEmail",null);
        helper.getInvitationDetails(component, event, helper);
    },
})