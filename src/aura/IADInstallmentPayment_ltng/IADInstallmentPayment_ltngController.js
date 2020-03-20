({
	doInit : function(component, event, helper) {
        console.log('inside payment component init method');
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
                            var amountdue;
                            var amount;
                            var orderId;
                            var customerId;
                            var invokingPage;
                            var invokingPageId;
                            var installmentId;
                            
                            for (var i = 0; i < sParams.length; i++) {
                                sParameterName = sParams[i].split('='); //to split the key from the value.
                                console.log('sParameterName: '+sParameterName);
                                if (sParameterName[0] === 'amountdue') { 
                                    amountdue = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }else if(sParameterName[0] === 'amount'){
                                    amount = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }else if(sParameterName[0] === 'orderId'){
                                    orderId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }else if(sParameterName[0] === 'customerId'){
                                    customerId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }else if(sParameterName[0] === 'invokingPage'){
                                    invokingPage = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }else if(sParameterName[0] === 'invokingPageId'){
                                    invokingPageId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }else if(sParameterName[0] === 'installmentId'){
                                    installmentId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }
                            }
                            console.log('im ready to invoke populate default value method');
                            component.set("v.orderId", orderId);
                            component.set("v.customerId", customerId);
                            component.set("v.installmentAmount", amount)
                            component.set("v.invokingPage", invokingPage);
                            component.set("v.invokingPageId", invokingPageId);
                            component.set("v.installmentId", installmentId);
                            
                            console.log('invokingPage-->'+invokingPage);
                            console.log('invokingPageId-->'+invokingPageId);
                            console.log('installmentId-->'+installmentId);
                            
                            if(invokingPage && invokingPage == 'Installment')
                            {
                                var addOthrAmt = component.find("addOtherAmount");
                                $A.util.addClass(addOthrAmt, "slds-hide");
                                
                                component.set("v.processTotal", amount);
                                component.set("v.amount", amount);
                                component.set("v.amountDue", amount);
                                component.set("v.amtCheckbox", true);
                            }
                            
                            helper.populateDefaultValues(component, event, helper);
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
    
    setOrUnsetProcessTotalToAmount : function(component, event, helper){
        var amount = component.get("v.amount");
        console.log('checkbox: '+component.get("v.amtCheckbox"));
        if(component.get("v.amtCheckbox")){
            component.set("v.processTotal", amount);
            component.set("v.othrAmtCheckbox", false);
        }else{
            component.set("v.processTotal", 0.00);
        }
    },
    
    setOrUnsetProcessTotalToOtherAmount : function(component, event, helper){
        var otherAmount = component.get("v.otherAmount");
        console.log('other amt: '+component.get("v.otherAmount"));
        if(component.get("v.othrAmtCheckbox")){
            console.log('im setting process total to other amount');
            component.set("v.processTotal", otherAmount);
            component.set("v.amtCheckbox", false);
        }else{
            console.log('im setting process total to zero');
            component.set("v.processTotal", 0.00);
        }
    },
    
    hideAddOtherAmtLinkAndShowOthrAmt : function(component, event, helper) {
        console.log('inside hideAddOtherAmtLinkAndShowOthrAmt method');
        var addOthrAmt = component.find("addOtherAmount");
        $A.util.addClass(addOthrAmt, "slds-hide");
        
        var otherAmount = component.find("otherAmount");
        $A.util.removeClass(otherAmount, "slds-hide");
        
        component.set("v.amtCheckbox", false);
        component.set("v.othrAmtCheckbox", true);
        component.set("v.processTotal", 0.00);
    },
    
    hideOrUnhideReasonAndEmail : function(component, event, helper){
        var payreason;
        var emailnotification;
        var editbutton;
		var profileId = component.get("v.currentPaymentOptionId");
        console.log('profileId: '+profileId);
        console.log(profileId.includes("sc"));
        if(profileId.includes("sc")){
            payreason = component.find("payreason");
            $A.util.addClass(payreason, "slds-hide");
            editbutton = component.find("editbutton");
            $A.util.addClass(editbutton, "slds-hide");
            emailnotification = component.find("emailnotification");
            $A.util.addClass(emailnotification, "slds-hide");
        }else{
            payreason = component.find("payreason");
            $A.util.removeClass(payreason, "slds-hide");
            editbutton = component.find("editbutton");
            $A.util.removeClass(editbutton, "slds-hide");
            emailnotification = component.find("emailnotification");
            $A.util.removeClass(emailnotification, "slds-hide");
        }
        
        if(profileId == 'newPayment')
        {
            editbutton = component.find("editbutton");
            $A.util.addClass(editbutton, "slds-hide");
            var subtaburl = '/lightning/n/AddNewPayment?customerid=' + component.get("v.customerId") + '&orderid=' + component.get("v.orderId") + '&orderRecordId=' + component.get("v.invokingPageId");
            var tabLabel = 'AddNewPayment';
            var tabIcon = 'custom17';
            helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
        }
              if(profileId == 'manualCheck')
        {   var editbutton = component.find("editbutton");
            $A.util.addClass(editbutton, "slds-hide");
           component.set('v.manualsection' ,true); 
        }
        if(profileId != 'manualCheck')
        {
           component.set('v.manualsection' ,false); 
        }
    },
    
    validateFormAndPostPayment: function(component, event, helper) {
        console.log('inside validateFormAndPostPayment');
        var validPaymentForm = component.find('paymentForm').reduce(function (validSoFar, inputCmp) { 
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validPaymentForm){
            console.log('ready to post payment');
            var title;
            var type;
            var message;
            var processTotal = component.get("v.processTotal"); 
            console.log('processTotal: '+processTotal);
            var dueAmount = component.get("v.amountDue");
            console.log('amount due: '+dueAmount);
            var profileId = component.get("v.currentPaymentOptionId");
            console.log('profileId: '+profileId);
            console.log(profileId.includes("sc"));
            var notificationemail = component.get("v.notificationEmail");
            if(processTotal <= 0 && processTotal < dueAmount){
                title = "Error!";
                type = "error";
                message = 'Not a valid amount.';
                helper.showToast(component, event, helper, title, type, message);
            }
            else if(processTotal > dueAmount){
                title = "Error!";
                type = "error";
                message = 'Process amount is greater than amount due.';
                helper.showToast(component, event, helper, title, type, message);
            }
            else if(!profileId.includes("sc") && !notificationemail){
                title = "Error!";
                type = "error";
                message = 'Please provide a valid email.';
                helper.showToast(component, event, helper, title, type, message);    
            }
            else{
                helper.showSpinner(component, event, helper);
                helper.postPaymentForOrder(component, event, helper);
            }
        }
    },    
    
    openEditPayment : function(component, event, helper){
        var profileId = component.get("v.currentPaymentOptionId");
        console.log('profileId: '+profileId);
        var subtaburl = '/lightning/n/EditPayment?profileid=' + profileId.substring(2);
        var tabLabel = 'EditPaymentPage';
        var tabIcon = 'custom17';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
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
    }
})