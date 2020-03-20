({
    doInit : function(component, event, helper) {
        console.log('inside CM component');
        window.setTimeout(
            $A.getCallback(
                function(){
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.getFocusedTabInfo().then(function(response) {
                        console.log('tab info: '+response);
                        console.log('subtab id: '+response.tabId);
                        workspaceAPI.getTabURL({
                            tabId: response.tabId
                        }).then(function(response) {
                            console.log('subTabUrl: '+ response);
                            var subTabUrl = response;
                            
                            var sURLAndParams = response.split('?');
                            console.log('sURLAndParams: '+sURLAndParams);
                            var sParams = sURLAndParams[1].split('&');
                            console.log('sParams: '+sParams);
                            var sParameterName;
                            var fkUser;
                            var recordId;
                            var CustomerLoginId = "";
                            var isNewAuthContact = false;
                            for (var i = 0; i < sParams.length; i++) {
                                sParameterName = sParams[i].split('='); //to split the key from the value.
                                
                                if (sParameterName[0] === 'id') { 
                                    recordId = sParameterName[1];
                                }else if (sParameterName[0] === 'fkUser'){
                                    fkUser=sParameterName[1];
                                    
                                }else if(sParameterName[0] === 'CustomerLoginId'){
                                    CustomerLoginId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }else if(sParameterName[0] === 'isNew'){
                                    isNewAuthContact = true; 
                                }
                            }
                            
                            component.set("v.fkuser",fkUser);
                            component.set("v.recordId", recordId);  	
                            helper.getCtrlRef(component, event, helper,recordId);
                            
                        });
                    })
                    .catch(function(error) {
                        console.log(error);
                    });    
                }
            ),
            1000
        );
    },
    
    update: function(component, event, helper) {
        var action = component.get("c.updateContact");
        var childCmp = component.find("cComp");
        
        action.setParams({
            "nContact": childCmp.get("v.record")
        });
        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") { 
                var returnValue = response.getReturnValue();
                
                component.set(childCmp.get("v.record"), returnValue.newContact);
                
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
    
    saveContact : function(component, event, helper) {
        var emailflag=true;
         if(component.get("v.newContact.Email")!=''&& component.get("v.newContact.Email")!=null){
            var email=component.get("v.newContact.Email"); //Anvesh @B-33787
            var atpos = email.indexOf("@");
            var dotpos = email.lastIndexOf(".");
            if (atpos<1 || dotpos<atpos+2 || dotpos+2>=email.length) {                
                emailflag=false;
                helper.showToast(component , event, helper, '', 'ERROR', 'You have entered an invalid email address!'); 
            }
        }
        var allValid = component.find('editcont').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid&&emailflag===true) {
            var str =component.get("v.newContact.Email").trim();
               component.set("v.newContact.Email",str);
            
            helper.showSpinner(component, event, helper) ;
            var action = component.get("c.updateContact");
            action.setParams({
                "con1": component.get("v.newContact"),
                "lzcId" : component.get("v.lzContactId"),
                "custId":component.get("v.customerId"),
                "lifeplan":component.get("v.lifeplan")
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
            
        } else {
            
        }
    },
    
    passwordReset : function(component, event, helper) {
        helper.showSpinner(component, event, helper) ;
        //alert(component.get("v.isLifePlanUser"));
        var action = component.get("c.resetPassword");
        var orderType; // anvesh
        if(component.get("v.isLifePlanUser")){
           orderType="lifePlan"; 
        }else{
            orderType="legalZoom";
        }
        action.setParams({
            
            "custEmail":component.get("v.newContact").Customer_Login_Email__c,
            "orderType":orderType
            
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
    
    createContact : function(component, event, helper) {
        var emailflag=true;
         if(component.get("v.newContact.Email")!=''&& component.get("v.newContact.Email")!=null){
            var email=component.get("v.newContact.Email"); //Anvesh @B-33787
            var atpos = email.indexOf("@");
            var dotpos = email.lastIndexOf(".");
            if (atpos<1 || dotpos<atpos+2 || dotpos+2>=email.length) {                
                emailflag=false;
                helper.showToast(component , event, helper, '', 'ERROR', 'You have entered an invalid email address!'); 
            }
        }
        var allValid = component.find('editcont').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid&&emailflag===true) {
            helper.showSpinner(component, event, helper) ;
            component.set("v.newContact.Contact_Type__c","Authorized Contact");
            var action = component.get("c.createNewcontact");
            action.setParams({
                "fkUserId":component.get("v.fkuser"),
                "nc":component.get("v.newContact")
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
        }
        else
        {
            
        }
    },
    
    closeFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    //STORY B-38226 - Starts Here
    sucessUpdateCLEmail : function(component, event, helper){
         helper.sucessUpdateCLEmailHelper(component,event);
    },
    //STORY B-38226 - Ends Here
})