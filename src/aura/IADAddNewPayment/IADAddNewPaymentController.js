({
    doInit : function(component, event, helper) {
        console.log("ltng URL value is -->"+ window.location.hostname);
        var ltURL ="https://"+window.location.hostname;
        component.set("V.ltngURL", ltURL);
        console.log('V.ltngURL-->'+component.get("V.ltngURL"));
        var vfOrigin = "https://" + component.get("v.vfHost");
        window.setTimeout(
            $A.getCallback(
                function(){
                    helper.setFocusedTabLabel(component,event,helper);
                    // helper.getintial(component,event,helper);
                }
            ),
            1000
        );
        //Padma B-36790,B-36791,B-37516
        var vfOrigin = "https://" + component.get("v.vfHost");
        console.log('vfOrigin 123 -->'+vfOrigin);
        //listening to the VF event to capture the pause recording response 
        window.addEventListener("message", function(event) {            
            console.log('event.origin -->'+event.origin);            
            console.log('vfOrigin 123 -->'+vfOrigin);
            /*if (event.origin !== vfOrigin) {
                // Not the expected origin: reject message
                console.log('not a expected Origin');
                return;
            }*/
            
            if(event.data !==null && event.data !==''){
                if(event.data.name === "Pause"){
                    var myObj = JSON.stringify(event.data);
                    console.log('result is  ' +myObj);
                    for (var prop in event.data) {                        
                        if(prop=="payload"){
                            var result= event.data[prop];
                            var obj = JSON.parse(result);  
                            console.log('obj is -->'+obj);
                            console.log('obj.result is-->'+obj.result);
                           //No error when pause recording is successful or there is no workspace interaction or agent is not on the call or there is already and existing recording.
                           if(obj.result =="True" ||  obj.message=="The recording is already paused." || obj.message=="No current interaction" || status==0){
                               
                               
                            }
                           else {   
                                var msg='We cannot collect payment information at this time. Please try again in a moment.\n';
                                //msg+='Additional info:\n Because we want to protect our customer’s sensitive information, we automatically pause our recording of our phone call while we collect payment details.\n In this case, the call was not successfully paused, which means we cannot collect payment details via phone. You will be able to enter payment info normally once the call is successfully paused.';
                                helper.showToast(component , event, helper, 'Call Recording Error', 'Error', msg);
                                component.set("v.disableOnBlur", true);
                            }
                            
                        }
                    }
                    console.log("recording paused after is "+component.get("v.recordingPaused"));
                    
                }
                
            }
            
        }, false);
        
    },
    checkall : function(component, event, helper)
    {
        if(component.find("selectallcheck").get("v.checked")===true)  
        {
            var checkboxes = component.find("wrappersid");
            
            for (var i=0; i<checkboxes.length; i++) {
                // And stick the checked ones onto an array...
                checkboxes[i].set("v.checked",true)
            }  
        }
        else
        {
            var checkboxes = component.find("wrappersid");
            
            for (var i=0; i<checkboxes.length; i++) {
                // And stick the checked ones onto an array...
                checkboxes[i].set("v.checked",false)
            }
        }
        
        
    },
    
    savecard:function(component, event, helper){
        //component.set("v.newpayment.accountNumber", component.get("v.cardnum"));
        component.set("v.newpayment.accountNumber", component.get("v.cardNumberBeforeMasking"));
       /* if(component.get("v.cardnum") =='' ||component.get("v.cardnum") ==null) {
            helper.showToast(component , event, helper, 'Card number not found', 'Error', 'Please enter a card number');
        }*/
        var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            helper.getpaymentprofiles (component, event, helper);
        }
        
        /*
        var accnum = component.get("v.cardnum");
        var maskedCC = 'XXX-XXXX-XXXX'+accnum.substring((accnum.length)-4, accnum.length);
        
        component.set("v.cardnum",maskedCC); //padma added 
        */
    },
    
    closesubinstpanel : function(component, event, helper)
    {
        component.set("v.hasinstsubscriptions",false); 
        
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
    
    saveanyway:function(component, event, helper){
        component.set("v.hasdupeprofiles",false);
        helper.saveNewProfile(component, event, helper);       
    },
    
    openEditpayment:function(component, event, helper){
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '/lightning/r/Order__c/'+component.get("v.orderid")+'/view',
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: '/lightning/n/EditPayment?profileid='+component.get("v.profileid"),
                focus: true
            }).then(function(response){
                console.log('focused tab id: '+response);
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: EditPaymentPage
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
    
    updateselectedinstsubs:function(component, event, helper){
        
        var selectedlist=[];
        var option1 =component.get("v.selectall");
        var option2 =component.get("v.selectonly");
        selectedlist=component.get("v.gridWrapperstoupdate");
        for(var i=0; i<selectedlist.length;i++)
        {
            if((selectedlist[i].wrapType=='installment'&& selectedlist[i].show===true&&option1===true)|| option2===true){
                helper.doupdateofselected(component, event, helper,selectedlist[i].wrapId);       
            }
            else if((selectedlist[i].wrapType=='subscription'&& selectedlist[i].show===true&&option1===true)|| option2===true)
            {
                helper.updateselectedsub(component, event, helper,selectedlist[i].wrapId);
            }
        }
        helper.showToast(component , event, helper, "Success!", "success", "New payment method has been successfully added to the selected subscriptions or installments.");
        helper.closesubinstpanel(component , event, helper) ;
        
    },
    
    getprofileid :function(component,event,helper)
    {
        component.set("v.profileid",event.getSource().get('v.value'));
    },
    
    closedupemodal:function(component,event,helper)
    {
        component.set("v.hasdupeprofiles",false);
    },
    
    	
     onblur: function(component, event, helper) {
        // find the current element (column source) by event 
        var getSource = event.getSource();
        console.log("getSource value before-->"+getSource.get("v.value"));
        var cardNumber = getSource.get("v.value");
        
        if(cardNumber && !cardNumber.includes('xxxxxxxxxxxx')){
            //alert(cardNumber.substring(cardNumber.length - 4, cardNumber.length));
            component.set("v.cardNumberBeforeMasking", cardNumber);
            //mask or hide data again on mouse out with ****..
            getSource.set("v.value", 'xxxxxxxxxxxx'+cardNumber.substring(cardNumber.length - 4, cardNumber.length));
        }
        helper.resumeRecording(component, event, helper);        
       	component.set("v.disableOnBlur", false);
        console.log("getSource value after-->"+getSource.get("v.value"));
    },

    
   
    
    // //Padma B-36790,B-36791,B-37516
    pauseRecording : function(component,evernt,helper){
       console.log('pause recording called');
        var vfOrigin = "https://"+component.get("v.vfHost");
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        var message = {
            name: "Pause",
            payload:component.get("V.ltngURL")
        };
        console.log('vfOrigin -->'+vfOrigin);
        vfWindow.postMessage(message,vfOrigin);
        //component.set("v.disableOnBlur", false);
    },
    
   
    //EOC // //Padma B-36790,B-36791,B-37516
})