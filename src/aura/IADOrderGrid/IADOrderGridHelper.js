({
    getorder : function(cmp,event,helper,custid) {
        
        var action =cmp.get("c.populateOrders");
        action.setParams({ recid : custid });
        action.setCallback(this ,function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            var  exceptionMessages =response.getReturnValue().exceptions;     
            if (state === "SUCCESS"&&$A.util.isEmpty(exceptionMessages)) {  
                cmp.set("v.numberoforders",response.getReturnValue().theOrders.length )
                cmp.set("v.theOrders",response.getReturnValue().theOrders );
                cmp.set("v.orderidordermap",response.getReturnValue().orderIdToOrderMap);
                helper.toggle(cmp,event);
                
            }else if(state === 'ERROR'){
                
                title = "Error";
                type = "error";
                message = "An error occured when trying to load old  orders";
                helper.showToast(cmp, event, helper, title, type, message);
                helper.toggle(cmp,event);
                
            }
            if(exceptionMessages){                
                for (var i = 0; i < exceptionMessages.length; i++) {
                    title = exceptionMessages[i].msgType; 
                    type = exceptionMessages[i].msgType;
                    message = exceptionMessages[i].message;
                    helper.showToast(cmp, event, helper, title, type, message);
                }
                
                helper.toggle(cmp,event);
                // helper.toggle(cmp,event);
            }       
        });
        
        $A.enqueueAction(action);
        
    },
    
    setFocusedTabLabel : function(component, event, helper) {
        var res;
        var workspaceAPI = component.find("workspace");
        console.log('ready to parse the url');
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            
             workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Old Orders"
            });
            var taburl =response.url;
            
            if(taburl.includes("?")){
                var sParameterName;
                var sURLAndParams = taburl.split('?');
                console.log('sURLAndParams: '+sURLAndParams);
                var sParams = sURLAndParams[1].split('&');
                var customerId;
                for (var i = 0; i < sParams.length; i++) {
                    sParameterName = sParams[i].split('='); //to split the key from the value.
                    if(sParameterName[0] === 'custid'){
                        customerId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                    }
                }
                component.set("v.customerId", customerId); 
                helper.getorder(component,event,helper,customerId);
            }            
        })
        .catch(function(error) {
            console.log(error);
        });
        
    },
    
    createorder : function(component,event,helper,orderid)
    { 
        helper.showspinner(component,event);
        
        var ordermap={};
        ordermap=component.get("v.orderidordermap") ;
        
        
        var action = component.get("c.createOrder") ;
        action.setParams({ "ordernum" : orderid , "orderidmap" :JSON.stringify(component.get("v.orderidordermap")),customerid :component.get("v.customerid")});
        action.setCallback(this, function(response) {
            var title;
            var type;
            var message;
            var state = response.getState();
            var  exceptionMessages =response.getReturnValue().exceptions;
            if (state === "SUCCESS"&&$A.util.isEmpty(exceptionMessages)) {
                //alert(response.getReturnValue());
                helper.toggle(component,event);
                helper.openTab(component,event,helper ,response.getReturnValue().oldOrderId);
                
                
                
            }else if(state === 'ERROR'){
                
                title = "Error";
                type = "error";
                message = "An error occured when trying to create  order";
                helper.showToast(component, event, helper, title, type, message);
                helper.toggle(component,event);
                
            }
            if(exceptionMessages){                
                for (var i = 0; i < exceptionMessages.length; i++) {
                    title = exceptionMessages[i].msgType; 
                    type = exceptionMessages[i].msgType;
                    message = exceptionMessages[i].message;
                    helper.showToast(component, event, helper, title, type, message);
                }
                
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
    showspinner: function (cmp, event) {
        var spinner = cmp.find("mySpinner1");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    
    openTab : function(component, event, helper,orderid) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            recordId: orderid,
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
                //helper.toggle(component,event);
            }).then(function(tabInfo) {
                helper.toggle(component,event);
                // console.log(“The url for this tab is: “ + tabInfo.url);
            });
        })
        .catch(function(error) {
            console.log(error);
        });
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
    }
    
})