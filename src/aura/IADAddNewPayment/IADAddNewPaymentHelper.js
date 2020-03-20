({
    getintial : function(component,event,helper) {
        console.log('Entered getintial');
        var action =component.get("c.onload" );
        
        action.setCallback(this ,function(response){
            
            var state = response.getState();
            if (state === "SUCCESS")
            {
                component.set("v.newpayment",response.getReturnValue().profilerequest);
                //Padma B-36790,B-36791,B-37516
                var vURL =response.getReturnValue().sfBaseURL;
                 // for Sandbox
                //var vfHostURL = vURL.replace('.','--c.');  
               
                // for Production
                //hard coded .na63 as the getSalesforceBaseUrl is not returning the instance name in the production.
                var vfHostURL = vURL.replace('.','--c.na63.');  
                component.set("v.vfHost", vfHostURL);
                console.log("vfURL -->"+vfHostURL);
                //Padma EOC
                var myMap ={};
                myMap=response.getReturnValue().months;
                var monthexp =[];
                for (var key in myMap){
                    var month ={}
                    month.label=key ;
                    month.value=myMap[key];
                    monthexp.push(month);
                    
                }
                monthexp.sort(function(a, b){return a.value - b.value});
                component.set("v.newpayment.month",monthexp[0].value);
                component.set("v.expmonths", monthexp);
                var myMap ={};
                myMap=response.getReturnValue().years;
                var monthexp =[];
                for (var key in myMap){
                    var month ={}
                    month.label=key ;
                    month.value=myMap[key];
                    monthexp.push(month);    
                }
                monthexp.sort(function(a, b){return a.value - b.value});
                component.set("v.newpayment.year",monthexp[0].value);
                component.set("v.years", monthexp);
                var myMap ={};
                myMap=response.getReturnValue().cardtypes;
                var monthexp =[];
                for (var key in myMap){
                    var month ={}
                    month.label=key ;
                    month.value=myMap[key];
                    monthexp.push(month);
                    
                }
                monthexp.sort(function(a, b){return a.label - b.label});
                component.set("v.newpayment.accountType",monthexp[0].value);
                component.set("v.cardtypes", monthexp);
                
                var myMap ={};
                myMap=response.getReturnValue().states;
                
                var monthexp =[];
                for (var key in myMap){
                    var month ={}
                    month.label=key ;
                    month.value=myMap[key];
                    monthexp.push(month);
                    
                }
                
                component.set("v.newpayment.State",monthexp[0].value);
                component.set("v.states", monthexp);
                helper.toggle(component,event);
                               
                
            }
            
            else
            {
                helper.toggle(component,event);  
            }
        });
        
        $A.enqueueAction(action);
    },
    
    saveNewProfile :function(component,event,helper) {
        helper.showspinner(component, event);
        var action =component.get("c.addNewPayment" );
        
        var payload=JSON.stringify(component.get("v.newpayment"));
        // component.set("v.newpayment.accountNumber",component.get("v.creditcard"));
        action.setParams({profiletocreate:payload,customerId:component.get("v.customerId")});
        
        action.setCallback(this ,function(response){
            
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var title;
                var type;
                var message;
                var state = response.getState();
                component.set("v.createdProfile",response.getReturnValue().responseData);
                var  exceptionMessages =response.getReturnValue().exceptions;  
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                        helper.showToast(component , event, helper, title, type, message);
                    }
                }     helper.toggle(component,event);
                
                if(response.getReturnValue().responseData!=null)
                {
                    helper.getinstallments(component , event, helper);
                }
                
                
            }
            else
            {
                helper.toggle(component,event);   
            }
        });
        
        $A.enqueueAction(action);
    },
    toggle: function (cmp, event) {
        var spinner = cmp.find("mySpinner1");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
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
    
    setFocusedTabLabel : function(component, event, helper) {
        
        var res;
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            var taburl =response.url;
            res = taburl.split("?");
            var sParams =res[1].split("&");
            var custid;
            var orderidtopass;
            var ordernumber;
            var sParameterName;
            
            console.log('Entered params');
            for (var i = 0; i < sParams.length; i++) {
                sParameterName = sParams[i].split('='); //to split the key from the value.
                console.log('sParameterName: '+sParameterName);
                if(sParameterName[0] === 'orderRecordId'){
                    orderidtopass = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                }else if(sParameterName[0] === 'orderid'){
                    ordernumber = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                }else if(sParameterName[0] === 'customerid'){
                    custid = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                }
            }
            
            component.set("v.customerId", custid);
            component.set("v.orderid",orderidtopass);
            component.set("v.ordernum",ordernumber);
            
            helper.getintial(component,event,helper);
            
            
            
        })
        .catch(function(error) {
            console.log(error);
        });
        
    },
    showspinner: function (component, event) {
        var spinner = component.find("mySpinner1");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    getpaymentprofiles :function(component,event,helper) {
        
        var action =component.get("c.populateProfiles" );
        
        var payload=JSON.stringify(component.get("v.newpayment"));
        // component.set("v.creditcard",component.get("v.newpayment.accountNumber"));
        action.setParams({profiletocreate:payload,customerId:component.get("v.customerId")});
        
        action.setCallback(this ,function(response){
            var state = response.getState();
            if (state === "SUCCESS")
            {
                component.set("v.profilesformap",response.getReturnValue().profiles);
                if(response.getReturnValue().dupeProfiles.length>0)
                {
                    component.set("v.hasdupeprofiles",true);
                    component.set("v.dupeprofiles",response.getReturnValue().dupeProfiles);
                } 
                else
                {
                    helper.saveNewProfile(component,event,helper);
                }
            }
            
            else
            {
                var title;
                var type;
                var message;
                var  exceptionMessages =response.getReturnValue().exceptions;
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                    }
                    helper.showToast(component , event, helper, title, type, message);
                    helper.toggle(component,event);            
                }   
            }
        });
        
        $A.enqueueAction(action);
    },
    getinstallments:function(component,event,helper) {
        helper.showspinner(component, event);
        var action =component.get("c.populateInstallments" );
        
        var payload=JSON.stringify(component.get("v.newpayment"));
        action.setParams({orderRecordId:component.get("v.orderid"),ordername:component.get("v.ordernum")});
        
        action.setCallback(this ,function(response){
            
            
            if(JSON.stringify(response.getReturnValue()).length>0)
            {
                //component.set("v.hasdupeprofiles",true);
                //component.set("v.dupeprofiles",response.getReturnValue());
                
                
            }
            
            var state = response.getState();
            if (state === "SUCCESS")
            {
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
                    
                    helper.toggle(component,event);            
                }      
                component.set("v.installmentsforwrapper",response.getReturnValue().installments);
                helper.getsubscriptionslist(component,event,helper)
            }
            else
            {
                
            }
        });
        
        $A.enqueueAction(action);
    },
    getsubscriptionslist:function(component,event,helper) {
        
        var action =component.get("c.populateSubscriptions" );
        
        var payload=JSON.stringify(component.get("v.newpayment"));
        action.setParams({orderRecordId:component.get("v.orderid"),ordername:component.get("v.ordernum")});
        
        action.setCallback(this ,function(response){
            
            if(JSON.stringify(response.getReturnValue()).length>0)
            {
                //component.set("v.hasdupeprofiles",true);
                //component.set("v.dupeprofiles",response.getReturnValue());
                
                
            }
            
            var state = response.getState();
            if (state === "SUCCESS")
            {  
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
                    
                    helper.toggle(component,event);            
                }      
                
                component.set("v.subscriptionsforwrapper" , response.getReturnValue().subscriptions);
                if(response.getReturnValue().subscriptions.length>0 || component.get("v.installmentsforwrapper").length>0 )
                    helper.getwrappers(component,event,helper)
                    }
            else{
                
                var title;
                var type;
                var message;
                var  exceptionMessages =response.getReturnValue().exceptions;
                if(exceptionMessages){                
                    for (var i = 0; i < exceptionMessages.length; i++) {
                        title = exceptionMessages[i].msgType; 
                        type = exceptionMessages[i].msgType;
                        message = exceptionMessages[i].message;
                    }
                    helper.showToast(component , event, helper, title, type, message);
                    helper.toggle(component,event);            
                }     
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getwrappers:function(component,event,helper) {
        
        var action =component.get("c.populateWrappers" );
        
        var payload=JSON.stringify(component.get("v.newpayment"));
        action.setParams({orderRecordId:component.get("v.orderid"),insts:JSON.stringify(component.get("v.installmentsforwrapper")),subs:JSON.stringify(component.get("v.subscriptionsforwrapper")),profileidmap:JSON.stringify(component.get("v.profilesformap")),ordername:component.get("v.ordernum")});
        
        action.setCallback(this ,function(response){
            
            
            
            var state = response.getState();
            if (state === "SUCCESS")
            {
                
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
                    
                    helper.toggle(component,event);            
                }      
                component.set("v.gridWrapperstoupdate",response.getReturnValue().gridWrappers);
                if(response.getReturnValue().gridWrappers.length>0)
                {
                    component.set("v.hasinstsubscriptions",true);
                    
                    helper.toggle(component,event);
                }
                else
                {
                    
                }
                
            }
            else
            {
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
                    
                    helper.toggle(component,event);            
                }   
            }
        });
        
        $A.enqueueAction(action);
    },
    doupdateofselected:function(component,event,helper,installmentid) {
        
        var action =component.get("c.updateinstallment");
        
        var payload=JSON.stringify(component.get("v.newpayment"));
        action.setParams({instid:installmentid ,profileidupdate:component.get("v.createdProfile.profileId"),insts:JSON.stringify(component.get("v.installmentsforwrapper"))});
        
        action.setCallback(this ,function(response){
            
            
            
            var state = response.getState();
            if (state === "SUCCESS")
            {
                
            }
            else
            {
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
                    
                    helper.toggle(component,event);            
                }      
            }
        });
        
        $A.enqueueAction(action);
    },
    updateselectedsub:function(component,event,helper,subsid) {
        
        
        var action =component.get("c.updatesubscription");
        
        var payload=JSON.stringify(component.get("v.newpayment"));
        action.setParams({subId:subsid ,profileidupdate:component.get("v.createdProfile.profileId")});
        
        action.setCallback(this ,function(response){
            var state = response.getState();
            if (state === "SUCCESS")
            {
                
            }
            else
            {
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
                    
                    helper.toggle(component,event);            
                }   
            }
        });
        
        $A.enqueueAction(action);
    },
    
    closesubinstpanel : function(component, event, helper)
    {
        component.set("v.hasinstsubscriptions",false); 
    },
    //Padma B-36790,B-36791,B-37516
     resumeRecording : function(component, event, helper) {
        //window.open(component.get("v.resumeRecordingUrl"), "", "top=100, left=400, width=600, height=600");
        var vfOrigin = "https://"+component.get("v.vfHost");
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        var message = {
            name: "Resume",
            payload: component.get("V.ltngURL")
        };
        vfWindow.postMessage(message,vfOrigin);
    }
    
    
})