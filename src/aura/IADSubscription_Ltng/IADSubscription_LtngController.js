({
    doInitSubscription : function(component, event, helper) {
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
                            var orderId;
                            var orderItemId;
                            var customerId;
                            var subscriptionId;
                            var orderRecordId;
                            
                            for (var i = 0; i < sParams.length; i++) {
                                sParameterName = sParams[i].split('='); //to split the key from the value.
                                console.log('sParameterName: '+sParameterName);
                                if(sParameterName[0] === 'orderId'){
                                    orderId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }else if(sParameterName[0] === 'orderItemId'){
                                    orderItemId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }else if(sParameterName[0] === 'customerId'){
                                    customerId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }else if(sParameterName[0] === 'subscriptionId'){
                                    subscriptionId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }else if(sParameterName[0] === 'orderRecordId'){
                                    orderRecordId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }
                            }
                            console.log('im ready to invoke populate default value method');
                            console.log(orderId);
                            console.log(orderItemId);
                            console.log(customerId);
                            console.log(subscriptionId);
                            component.set("v.orderId", orderId);
                            component.set("v.customerId", customerId);
                            component.set("v.orderItemId", orderItemId);
                            component.set("v.subscriptionId", subscriptionId);
                            component.set("v.orderRecordId", orderRecordId);
                            if(subscriptionId){
                                helper.populateDefaultValues(component, event, helper);
                            }else{
                                helper.hideSpinner(component, event, helper);
                            }
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
    
    openOrderDetail : function (component, event, helper) {
        var title;
        var type;
        var message;
        var orderrecordid = event.currentTarget.dataset.orderrecordid;
        console.log('orderrecordid: '+orderrecordid);
        if(orderrecordid && orderrecordid != 'null')
        {    
            console.log('im ready to open the order tab');
            var taburl = "/lightning/r/Order__c/" + orderrecordid + "/view";
            helper.openTab(component, event, helper, taburl);
        }
        else
        {
            title = "Error!";
            type = "error";
            message = 'Could not find the order record in salesforce. Please try again later.';
            console.log('im ready to open the toast message');
            helper.showToast(component, event, helper, title, type, message);
        }
    },    
    
    validateFormAndUpdateSubscription: function(component, event, helper) {
        console.log('inside validateFormAndPostPayment');
        var validSubscriptionForm = component.find('subscriptionForm').reduce(function (validSoFar, inputCmp) { 
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validSubscriptionForm){
            console.log('ready to post payment');
            var title;
            var type;
            var message;
            var profileId = component.get("v.currentPaymentOptionId");
            console.log('profileId: '+profileId);
            if(profileId && profileId != 'newPayment' && profileId != 'None')
            {
                var isAutoRenewable = component.get("v.isAutoRenewable");
                console.log('isAutoRenewable: '+isAutoRenewable);
                if(isAutoRenewable)
                {
                    helper.showSpinner(component, event, helper);
                    helper.subscriptionUpdate(component, event, helper);
                }
                else
                {
                    title = "Error!";
                    type = "error";
                    message = 'Please select an Auto Renew option.';
                    helper.showToast(component, event, helper, title, type, message);
                }
            }
            else
            {
                title = "Error!";
                type = "error";
                message = 'Please select a payment method.';
                helper.showToast(component, event, helper, title, type, message);
            }
        }
    },  
    
    setPdtComponentIdAndPdtConfigId : function(component, event, helper){
		var renewalTermPdtIdPdtCnfgId = component.get("v.renewalTerm");
        console.log('renewalTermPdtIdPdtCnfgId--->'+renewalTermPdtIdPdtCnfgId);
        
        var params = renewalTermPdtIdPdtCnfgId.split('-');
        console.log('params: '+params); 
        var productComponentId;
        var productConfigId;
        var extendedPrice;
        for (var i = 0; i < params.length; i++) {
            if(i == 0){
                productComponentId = (params[i] != null || params[i] != '' || params[i] != undefined) ? params[i] : null;
            	component.set("v.productComponentId", productComponentId);
                console.log('productComponentId-->'+productComponentId);
            }else if(i == 1){
        		productConfigId = (params[i] != null || params[i] != '' || params[i] != undefined) ? params[i] : null;
                component.set("v.productConfigId", productConfigId);
                console.log('productConfigId-->'+productConfigId);
            }else if(i == 2){
        		extendedPrice = (params[i] != null || params[i] != '' || params[i] != undefined) ? params[i] : null;
                component.set("v.extendedPrice", extendedPrice);
                component.set("v.subscriptionService.subscriptionSingleItem.subscription.renewalPrice", extendedPrice);
                console.log('extendedPrice-->'+extendedPrice);
            }
		}
        console.log('component.get("v.productComponentId")--->'+component.get("v.productComponentId"));
        console.log('component.get("v.productConfigId")--->'+component.get("v.productConfigId"));
        
    },

    enableSupscriptionUpdate : function(component, event, helper){
        component.set("v.isNotUpdatable", false);
        var editSubscription = component.find("editSubscription");
        $A.util.addClass(editSubscription, "slds-hide");
    },
    
    toggleIconsAndTable : function(component, evnet, helper){
        var downIcon = component.find("downIcon");
        var rightIcon = component.find("rightIcon");
        var currentTermTable = component.find("currentTermTable");
        
        $A.util.toggleClass(downIcon, "slds-hide");
        $A.util.toggleClass(rightIcon, "slds-hide");
        $A.util.toggleClass(currentTermTable, "slds-hide");
    },
    
    toggleIconsAndTermsTable : function(component, evnet, helper){
        var downIcon = component.find("downIcon_Terms");
        var rightIcon = component.find("rightIcon_Terms");
        var currentTermTable = component.find("termsTable");
        
        $A.util.toggleClass(downIcon, "slds-hide");
        $A.util.toggleClass(rightIcon, "slds-hide");
        $A.util.toggleClass(currentTermTable, "slds-hide");
    },
    
    cancelSupscriptionUpdate : function(component, event, helper) {
        component.set("v.isNotUpdatable", true);
        var editSubscription = component.find("editSubscription");
        $A.util.removeClass(editSubscription, "slds-hide");
    },
    
    partialCancellation : function(component, event, helper) {
        helper.showSpinner(component, event, helper);
        component.set("v.isCancellationSectionHidden", false);
        if(event.currentTarget.dataset.ispartialcancel == 'true'){
            component.set("v.isPartialCancel", true);
        }else{
            component.set("v.isPartialCancel", false);
        }
        component.set("v.currentOrderItemId",event.currentTarget.dataset.orderitemid);
        var ssdate = event.currentTarget.dataset.substartdate;
        console.log('ssdate: '+ssdate);
        if(ssdate){
            var dateParams = ssdate.split('/');
            var ssDateMonth;
            var ssDateDay;
            var ssDateYear;
            var startDate;
            
            if(dateParams.length > 0)
            {    
                ssDateMonth = dateParams[0];
                ssDateDay = dateParams[1];
                ssDateYear = dateParams[2];
                startDate = ssDateYear + '-' + ssDateMonth + '-' + ssDateDay;
                console.log('startDate: '+startDate);
                component.set("v.subStartDate", startDate);
            }
            
            var minDate = new Date();
            var month = minDate.getMonth();
            if(month < 8){
                month = '0' + (month+1);
            }else{
                month = month+1;
            }
            minDate = minDate.getFullYear() + '-' + month + '-' + minDate.getDate();
            console.log('minDate: '+minDate);
            if(minDate < startDate){
                minDate = startDate;
            }
            component.set("v.minDate", minDate);            
        }
        
        var sEdate = event.currentTarget.dataset.subenddate;
        if(sEdate){
            var edateParams = sEdate.split('/');
            var seDateMonth;
            var seDateDay;
            var seDateYear;
            var endDate; //2018-05-04
            var maxDate;
            
            if(edateParams.length > 0)
            {    
                seDateMonth = edateParams[0];
                seDateDay = edateParams[1];
                seDateYear = edateParams[2];
                endDate = seDateYear + '-' + seDateMonth + '-' + seDateDay;
                console.log('endDate: '+endDate);
                component.set("v.subEndDate", endDate);
                
                seDateDay = seDateDay-1;
                if(seDateDay < 10){
                    seDateDay = '0' + seDateDay;
                }
                maxDate = seDateYear + '-' + seDateMonth + '-' + seDateDay;
                console.log('maxDate: '+maxDate);
                component.set("v.maxDate", maxDate);
            }
        }
        component.set("v.currentSubOrderItemId", event.currentTarget.dataset.orderitemsubid);
        component.set("v.isCancelSuccess", false);
        console.log(event.currentTarget.dataset.orderitemsubid);
        console.log(event.currentTarget.dataset.orderitemid);
        console.log(event.currentTarget.dataset.ispartialcancel);
        console.log(event.currentTarget.dataset.substartdate);
        console.log(event.currentTarget.dataset.subenddate);
        helper.populateProratedRefundAmount(component, event, helper);
    },
    
    fullCancellation : function(component, event, helper) {
        component.set("v.isCancellationSectionHidden", false);
        if(event.currentTarget.dataset.ispartialcancel == 'true'){
            component.set("v.isPartialCancel", true);
        }else{
            component.set("v.isPartialCancel", false);
        }
        component.set("v.isCancelSuccess", false);
        component.set("v.refundAmount", "0.0");
        component.set("v.currentOrderItemId",event.currentTarget.dataset.orderitemid);
        console.log(event.currentTarget.dataset.orderitemsubid);
        console.log(event.currentTarget.dataset.orderitemid);
        console.log(event.currentTarget.dataset.ispartialcancel);
        console.log(event.currentTarget.dataset.substartdate);
        console.log(event.currentTarget.dataset.subenddate);
        console.log(component.get("v.refundAmount"));
        
        var sEdate = event.currentTarget.dataset.subenddate;
        if(sEdate){
            var edateParams = sEdate.split('/');
            var seDateMonth;
            var seDateDay;
            var seDateYear;
            var endDate; //2018-05-04
            
            if(edateParams.length > 0)
            {    
                seDateMonth = edateParams[0];
                seDateDay = edateParams[1];
                seDateYear = edateParams[2];
                endDate = seDateYear + '-' + seDateMonth + '-' + seDateDay;
                console.log('endDate: '+endDate);
                component.set("v.subEndDate", endDate);
            }
        }
        
    },
    
    validateFormAndCancelTerm : function(component, event, helper) {
        console.log('inside validateFormAndPostPayment');
        var validSubRefundForm = component.find('subRefundForm').reduce(function (validSoFar, inputCmp) { 
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validSubRefundForm){
            console.log('ready to post payment');
            var title;
            var type;
            var message;
            var isPartialCancel = component.get("v.isPartialCancel");
            
            if(isPartialCancel)
            {
                var refundAmount = component.get("v.refundAmount");
                console.log('refundAmount: '+refundAmount);
                if(refundAmount)
                {
                    helper.showSpinner(component, event, helper);
                    helper.cancelSubRenewal(component, event, helper);                
                }
                else
                {
                    title = "Error!";
                    type = "error";
                    message = 'Please Provide Refund Amount.';
                    helper.showToast(component, event, helper, title, type, message);
                }
            }
            else
            {
                helper.showSpinner(component, event, helper);
                helper.cancelSubRenewal(component, event, helper);
            }
        }
    },
    
    closeTermsSection : function(component, event, helper) {
        component.set("v.isCancellationSectionHidden", true);
    },
    
    calculateProratedRefundAmount : function(component, event, helper) {
        console.log('calculate prorated amount');
        console.log(component.get("v.subEndDate"));
        var endDate = event.currentTarget.value;
        var proratedDateAmountMap = component.get("v.proratedDateAmountMap");
        var refundAmount;
        if(proratedDateAmountMap)
        {    
            refundAmount = proratedDateAmountMap[endDate];
            console.log('refundAmount: '+refundAmount);
            console.log('endDate: '+endDate);
            component.set("v.subEndDate", endDate);
            component.set("v.refundAmount", refundAmount);
        }
    },
    
    openRefundsPage : function(component, event, helper){
        var amount = component.get("v.refundAmount");
        console.log('amount: '+amount);
        
        var orderId = component.get("v.renewalOrderId");
        var customerId = component.get("v.customerId");        
        var subtaburl = '/lightning/n/Make_a_Refund?amount=' + amount + '&orderId=' + orderId + '&customerId=' + customerId + '&invokingPage=Subscription&invokingPageId=' + orderId;
        var tabLabel = 'Refund';
        var tabIcon = 'custom17';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    },
    
    hideEditButtonOrOpenNewPaymentPage : function(component, event, helper){
        var editbutton;
        var profileId = component.get("v.currentPaymentOptionId");
        console.log('profileId: '+profileId);
        if(profileId == 'newPayment')
        {
            editbutton = component.find("editbutton");
            $A.util.addClass(editbutton, "slds-hide");
            var subtaburl = '/lightning/n/AddNewPayment?customerid=' + component.get("v.customerId") + '&orderid=' + component.get("v.orderId") + '&orderRecordId=' + component.get("v.orderRecordId");
            var tabLabel = 'AddNewPayment';
            var tabIcon = 'custom17';
            helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
        }
        else
        {
            editbutton = component.find("editbutton");
            $A.util.removeClass(editbutton, "slds-hide");            
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
    
    cancelUpgrade : function(component, event, helper){
        console.log('ready to cancelUpgrade');
        var action = component.get("c.cancelSubscriptionUpgrade");
        action.setParams({
            "subscriptionId"  : component.get("v.subscriptionId"),
            "scheduleId"  : component.get("v.scheduleId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("state inside cancelUpgrade: "+state);
            if(state === 'SUCCESS'){
                var title;
                var type;
                var message;
                var returnValue = response.getReturnValue();
				var subscriptionUpgradeCancelResponse = response.getReturnValue().subscriptionUpgradeCancelResponse;                
                console.log('returnValue-->'+JSON.stringify(returnValue));
                console.log('subscriptionUpgradeCancelResponse-->'+JSON.stringify(subscriptionUpgradeCancelResponse));
                if(subscriptionUpgradeCancelResponse){
                    if(subscriptionUpgradeCancelResponse.cancelledUpgrade)
                    {    
                        helper.showSpinner(component, event, helper);
                    
                        title = "Success!";
                        type = "success";
                            
                        if(subscriptionUpgradeCancelResponse.cancelledUpgrade.status == -2){    
                            message = 'Scheduled Upgrade Cancelled!';                        
                        }else if(subscriptionUpgradeCancelResponse.cancelledUpgrade.status == -3){
                            message = 'Cancelled Staging Order!';
                        }else if(subscriptionUpgradeCancelResponse.cancelledUpgrade.status == 0){
                            message = 'Cancellation Pending!';
                        }else if(subscriptionUpgradeCancelResponse.cancelledUpgrade.status == 1){
                            message = 'Cancellation Processed!';
                        }else if(subscriptionUpgradeCancelResponse.cancelledUpgrade.status == -1){
                            message = 'Error Occured. Please try again!';
                        }
                        helper.showToast(component, event, helper, title, type, message);
                        helper.populateDefaultValues(component, event, helper);
                    }
                }
                
                if(returnValue.iadServiceMessages)
                {
                    var iadMessages = returnValue.iadServiceMessages;
                    for (var i = 0; i < iadMessages.length; i++) {
                        title = iadMessages[i].msgType; 
                        type = iadMessages[i].msgType;
                        message = iadMessages[i].message;
                        helper.showToast(component, event, helper, title, type, message);
                    }
                }
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate previous term: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            }            
        });
        $A.enqueueAction(action);
    },
    
    openCancelSubscriptionPanel : function(component, event, helper) {
        console.log('openCancelSubscriptionPanel-->');
        var subscriptionPanel = component.find("cancelSubscriptionPanel");
        $A.util.removeClass(subscriptionPanel, "slds-hide");
        $A.util.addClass(subscriptionPanel, "slds-show");
    },
    
    hideCancelSubscriptionPanel : function(component, event, helper) {
        var subscriptionPanel = component.find("cancelSubscriptionPanel");
        $A.util.addClass(subscriptionPanel, "slds-hide");
        $A.util.removeClass(subscriptionPanel, "slds-show");
    },
    
    cancelSupscriptionWORefund : function(component, event, helper){ 
        console.log('cancelSupscriptionWORefund--->');
        helper.showSpinner(component, event, helper);
        var action = component.get("c.cancelSubscriptionWithoutRefund");
        action.setParams({
            "subscriptionId" : component.get("v.subscriptionId") 
        });
        action.setCallback(this, function(response){
            var title;
            var type;
            var message;
            var state = response.getState();
            if(state === 'SUCCESS'){
                var returnValue = response.getReturnValue();   
                console.log('returnValue-->');
                console.log(JSON.stringify(returnValue));
                helper.populateDefaultValues(component, event, helper);
                
                var subscriptionPanel = component.find("cancelSubscriptionPanel");
                $A.util.addClass(subscriptionPanel, "slds-hide");
                $A.util.removeClass(subscriptionPanel, "slds-show");
                
                component.set("v.isNotUpdatable", true);
                var editSubscription = component.find("editSubscription");
                $A.util.removeClass(editSubscription, "slds-hide");
            }
            else 
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to populate previous term: Please try again!";
                helper.showToast(component, event, helper, title, type, message);
                helper.hideSpinner(component, event, helper);
            } 
        });
        $A.enqueueAction(action);
    },
      // Added two methods to seperate callouts
    renewalterms :function(component, event, helper){
        if(component.get("v.renewalcall")===true)
        {
        helper.subscriptionRenewalTerms(component, event, helper, false);
        }
    },
    
    nextsubmodification :function(component, event, helper){
         if(component.get("v.nextsubmod")===true)
        {
       helper.nextSubscriptionModification(component, event, helper);  
        }
    }
})