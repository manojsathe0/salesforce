({
    getInstallmentDetail : function(component,event,helper,installmentid,orderidcustomer) {
        component.set("v.installmentdetailid",installmentid);
        component.set("v.orderrecordid",orderidcustomer);
        helper.showspinner(component, event);
        var action =component.get("c.populateInstallment" );
        action.setParams({ 
            installment: installmentid, 
            orderid:orderidcustomer 
        });
        action.setCallback(this ,function(response){    
            var title;
            var type;
            var message;
            var state = response.getState();
            
            if (state === "SUCCESS")
            {
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
                component.set("v.installmentdetail",response.getReturnValue().installmentresponse);
                component.set("v.customerId", response.getReturnValue().customerId);
                component.set("v.ordernum",response.getReturnValue().orderIdNum);
                
                component.set("v.profilelabel",response.getReturnValue().installmentresponse.installment.paymentProfileId);
                component.set("v.status",response.getReturnValue().installmentresponse.installment.status)
                if(component.get("v.status")=='Past Due - Will Not Reharvest')
                    component.set("v.status","PastDue");
                var currentdate = new Date();
                currentdate=$A.localizationService.formatDate(currentdate, "yyyy-MM-ddTHH:mm:ss");
                component.set("v.currentdate",currentdate);
                
                var formattedDate = $A.localizationService.formatDate(response.getReturnValue().duedateformat, "yyyy-MM-ddTHH:mm:ss");
                component.set("v.duedate",formattedDate);
                // helper.comparedates(component,event ,helper);
                
                helper.firelabel(component ,event ,component.get("v.profilelabel"))
                helper.toggle(component,event);
            }
            else if(state === 'ERROR'){
                
                title = "Error";
                type = "error";
                message = "An error occured when trying to Load Installment Detail try again ";
                helper.showToast(component , event, helper, title, type, message);
                helper.toggle(component,event);
                
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    firelabel:function(component ,event,myValue){
        var appEvent = $A.get("e.c:IADPaymentProfileLabel");
        appEvent.setParams({ "payProfileId" : myValue });
        appEvent.fire();
    },
    
    populatePaymentMethods : function(component, event, helper){
        console.log('ready to populate payment methods');
        var action = component.get("c.populateProfiles");
        action.setParams({
            "customerId" : component.get("v.customerId"),
            "pageType" : "Installment"
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("state inside populatePaymentMethods: "+state);
            if(state ==="SUCCESS"){
                var returnValue = response.getReturnValue();
                console.log('returnValue: '+JSON.stringify(returnValue));
                var paymentOptions = [];
                var paymentOptionsMap = response.getReturnValue().paymentOptions;
                for ( var key in paymentOptionsMap ) {
                    paymentOptions.push({value:paymentOptionsMap[key], key:key});
                }
                component.set("v.paymentOptions", paymentOptions);
                if(paymentOptions.length > 0){
                    console.log('paymentOptions[0].key: '+paymentOptions[0].key);
                    component.set("v.currentPaymentOptionId", paymentOptions[0].key);
                }else{
                    component.set("v.currentPaymentOptionId", "none");
                }
                helper.toggle(component,event); 
            }
            else
            {
                helper.toggle(component,event);  
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
    
    setFocusedTabLabel : function(component, event, helper) {
        var res;
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            
            var taburl =response.url;
           
            var transactionid;
            var transactiontype;
              if(taburl.includes("?")){
                var sParameterName;
                var sURLAndParams = taburl.split('?');
                console.log('sURLAndParams: '+sURLAndParams);
                var sParams = sURLAndParams[1].split('&');
                console.log('sParams: '+sParams);  
                var customerId;
                for (var i = 0; i < sParams.length; i++) {
                    sParameterName = sParams[i].split('='); //to split the key from the value.
                    console.log('sParameterName: '+sParameterName); 
                    if(sParameterName[0] === 'installmentid'){
                        transactionid = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                    }else if(sParameterName[0] === 'orderid'){
                    	transactiontype = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                	}
                }
              }
           
            helper.getInstallmentDetail(component,event,helper,transactionid,transactiontype);
            
        })
        .catch(function(error) {
            console.log(error);
        });
        
    },
    
    comparedates : function(component, event, helper){
        component.set("v.showproceed",false);
        component.set("v.showupdate",false);
        
        var currentdate = new Date();
        currentdate=$A.localizationService.formatDate(currentdate, "yyyy-MM-dd"); 
        console.log('the due date'+component.get("v.duedate"));
        console.log('the current date date'+currentdate);
        if(component.get("v.duedate"))
        {
            var duedatejs = $A.localizationService.formatDate(component.get("v.duedate"), "yyyy-MM-dd");
            console.log('the due date js'+duedatejs);
            var proceed = component.find("proceedpayment");
            var update =component.find("updatebutton");
            
            if(currentdate>=duedatejs && component.get("v.status")!='Paid')
            {   
                component.set("v.showproceed",true);
            }
            else if (duedatejs> currentdate)
            {  
                component.set("v.showupdate",true);
            }
        }
    },
    
    opennewpayment : function(component,event,helper ,storecredit,storecode){
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '/lightning/r/Order__c/'+component.get("v.orderrecordid")+'/view',
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: '/lightning/n/AddNewPayment?customerid='+component.get("v.customerId")+'&orderid='+component.get("v.ordernum")+'&orderRecordId='+component.get("v.orderrecordid"),
                focus: true
            }).then(function(response){
                console.log('focused tab id: '+response);
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: 'AddNewPayment'
                }).then(function(response){
                    console.log('the tab Id to set label'+response.tabId);
                    
                }).catch(function(error) {
                    console.log('Error: '+error);
                });
            }).catch(function(error) {
                console.log('Error: '+error);
            });
        })
        .catch(function(error) {
            console.log('Error: '+error);
        });
    },
    
    openSubTab : function(component, event, helper, subtaburl, tabLabel, tabIcon){
        
        console.log('subtaburl: '+subtaburl);
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.openTab({
            url: '/lightning/r/Order__c/'+component.get("v.orderrecordid")+'/view',
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: subtaburl,
                focus: true
            }).then(function(response){
                console.log('focused tab id: '+response);
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: tabLabel
                }).then(function(response){
                    console.log('the tab Id to set label'+response.tabId);
                    workspaceAPI.setTabIcon({
                        tabId: response.tabId,
                        icon: tabIcon,
                        iconAlt: tabIcon
                    });
                }).catch(function(error) {
                    console.log('Error: '+error);
                });
            }).catch(function(error) {
                console.log('Error: '+error);
            });
        })
        .catch(function(error) {
            console.log('Error: '+error);
        });
    },    
    
})