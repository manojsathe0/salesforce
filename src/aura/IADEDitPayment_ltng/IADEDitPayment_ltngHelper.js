({
    getintial : function(component,event,helper) {
        
        var action =component.get("c.onload" );
        action.setParams({"profileid":component.get("v.profileid")});
        action.setCallback(this ,function(response){
            
            var state = response.getState();
            if (state === "SUCCESS")
            {
                component.set("v.newpayment",response.getReturnValue().profilerequest);
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
                component.set("v.newpayment.month",component.get("v.newpayment.month")) ;
                component.set("v.expmonths", monthexp);
                
                var myMap ={};
                myMap=response.getReturnValue().years;
                var monthexp =[];
                for (var key in myMap){
                    var setkey;
                    var month ={}
                    month.label=key ;
                    month.value=myMap[key];
                    monthexp.push(month);
                    
                }
                monthexp.sort(function(a, b){return a.value - b.value});
                component.set("v.newpayment.year" ,component.get("v.newpayment.year") );
                
                
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
                component.set("v.newpayment.accountType",component.get("v.newpayment.accountType"));
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
                
                
                component.set("v.newpayment.state",component.get("v.newpayment.state"));
                component.set("v.states", monthexp);
                
                helper.toggle(component,event);
                
            }
            
            else
            {
                
            }
        });
        
        $A.enqueueAction(action);
    },
    
    updateProfile :function(component,event,helper) {
        helper.showspinner(component, event);
        var action =component.get("c.updatePaymentProfile" );
        
        var payload=JSON.stringify(component.get("v.newpayment"));
        action.setParams({profiletoupdate:payload,profileid:component.get("v.profileid"),customerid:component.get("v.customerId" ),deletecheck:component.get("v.checkdelete")});
        
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
            }
            else
            {
                helper.toggle(component,event);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    setFocusedTabLabel : function(component, event, helper) {
        var res;
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            
            var taburl =response.url;
            res = taburl.split("?");
            var sParams =res[1].split("&");
            var sParameterName;
            var profileidtopass;
            var custid;
            
            for (var i = 0; i < sParams.length; i++) {
                sParameterName = sParams[i].split('='); //to split the key from the value.
                console.log('sParameterName: '+sParameterName);
                if(sParameterName[0] === 'profileid'){
                    profileidtopass = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                }else if(sParameterName[0] === 'CustomerId'){
                    custid = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                }
            }
            component.set("v.profileid",profileidtopass);
            component.set("v.customerId",custid );
            helper.getintial(component,event,helper);
            
            
        })
        .catch(function(error) {
            console.log(error);
        });
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
    
    showspinner: function (component, event) {
        var spinner = component.find("mySpinner1");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    deleteProfile :function(component,event,helper) {
        helper.showspinner(component, event);
        var action =component.get("c.deletePaymentProfile" );
        
        var payload=JSON.stringify(component.get("v.newpayment"));
        action.setParams({profiletoupdate:payload,profileid:component.get("v.profileid"),customerid:component.get("v.customerId" ),deletecheck:component.get("v.checkdelete")});
        
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
            }
            else
            {
                helper.toggle(component,event);
            }
        });
        
        $A.enqueueAction(action);
    },
})