({
    doInit : function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(
                function(){
                    helper.setFocusedTabLabel(component,event,helper);
                }
            ),
            1000
        );
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
    
    openinstallmentmode : function(component, event, helper) {
        component.set("v.detailmode",false);
        component.set("v.editmode",true);
        helper.showspinner(component, event);
        helper.populatePaymentMethods(component, event, helper);
        
        // this.datecomparisons(component, event, helper);
        helper.comparedates(component,event ,helper);
    },
    
    UpdateInstallment : function(component, event, helper) {
        helper.showspinner(component, event);
        var action =component.get("c.updateInstallment" );
        action.setParams({ 
            installmentId: component.get("v.installmentdetailid"), 
            installmenttoupdate:JSON.stringify(component.get("v.installmentdetail")),
            profileId:component.get("v.currentPaymentOptionId"),
            dueDate:component.get("v.duedate") 
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
                
            }
            else
            {
                title = "Error";
                type = "error";
                message = "An error occured when trying to update Installment  try again ";
                helper.showToast(component , event, helper, title, type, message);
                helper.toggle(component,event);   
                
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    getprofileid :function(component, event, helper)
    {
        if(component.get("v.currentPaymentOptionId")=='newPayment'){
            helper.opennewpayment(component, event, helper);
        }
    },
    
    openpaymentedit:function(component,event ,helper)
    {
        var profilecurrent= component.get("v.currentPaymentOptionId");
        var profileidtoedit =profilecurrent.substring(2);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '/lightning/r/Order__c/'+component.get("v.orderrecordid")+'/view',
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: '/lightning/n/EditPayment?profileid='+profileidtoedit+'&CustomerId='+component.get('v.customerId'),
                focus: true
            }).then(function(response){
                console.log('focused tab id: '+response);
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: "EditPaymentPage"
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
    
    populatePaymentMethods : function(component, event, helper){
        console.log('ready to populate payment methods');
        var action = component.get("c.populateProfiles");
        action.setParams({
            "customerId" : component.get("v.customerId"),
            "pageType" : "MakePayment"
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
                helper.retrieveOrderBalanceByOrderId(component, event, helper, true);
            }
        });
        $A.enqueueAction(action);
    },
    
    RedirecttoDetail :function(component,event ,helper)
    {
        component.set("v.editmode",false); 
        component.set("v.detailmode",true);
        helper.firelabel(component ,event ,component.get("v.profilelabel"));
        
    },
    /*
    setFocusedTabLabel : function(component, event, helper) {
        var res;
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            
            var taburl =response.url;
            res = taburl.split("?");
            var params =res[1].split("&");
            
            var transactionid =params[0].split("=")[1];
            var transactiontype=params[1].split("=")[1];
            helper.getInstallmentDetail(component,event,helper,transactionid,transactiontype);
        })
        .catch(function(error) {
            console.log(error);
        });
        
    },
    */
    datecomparisons : function(component,event ,helper)
    {
        helper.comparedates(component,event ,helper);
    },
    
    openPaymentsPage : function(component, event, helper){
        
        var amount = component.get("v.installmentdetail.installment.totalDueAmount");
        console.log('amount: '+amount);
        
        var orderNumber = component.get("v.ordernum");
        var customerId;
        if(component.get("v.customerId")){
            customerId = component.get("v.customerId");
        }
        var subtaburl = '/lightning/n/Make_a_Payment?amountdue=1&amount=' + amount + '&orderId=' + orderNumber + '&customerId=' + customerId + '&invokingPage=Installment&invokingPageId=' + component.get("v.orderrecordid") + '&installmentId=' + component.get("v.installmentdetailid");
        var tabLabel = 'Payment';
        var tabIcon = 'custom17';
        helper.openSubTab(component, event, helper, subtaburl, tabLabel, tabIcon);
    }
})