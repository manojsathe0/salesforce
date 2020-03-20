({
    doInit : function(component, event, helper) {
        console.log('inside shipping component');
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
                            var orderNumber;
                            var orderContactId = "";
                            var isNewOrderSpecificContact = false;
                            var isDeletable = false;
                            for (var i = 0; i < sParams.length; i++) {
                                sParameterName = sParams[i].split('='); //to split the key from the value.
                                console.log('sParameterName: '+sParameterName);
                                if (sParameterName[0] === 'id') { 
                                    orderNumber = sParameterName[1];
                                }else if(sParameterName[0] === 'orderContactId'){
                                    orderContactId = (sParameterName[1] != null || sParameterName[1] != '' || sParameterName[1] != undefined) ? sParameterName[1] : '';
                                }else if(sParameterName[0] === 'isNew'){
                                    isNewOrderSpecificContact = true; 
                                }else if(sParameterName[0] === 'isDeletable'){
                                    isDeletable = sParameterName[1]; 
                                    console.log('isDeletable--->'+isDeletable);
                                }else if(sParameterName[0] ==='authorizedcontactid'){
                                    component.set("v.authorizedid",sParameterName[1]);
                                }
                            }
                            component.set("v.orderNumber", orderNumber);
                            component.set("v.orderContactId", orderContactId);
                            component.set("v.isNewOrderSpecificContact", isNewOrderSpecificContact);
                            component.set("v.isDeletable", isDeletable);
                            
                            console.log('orderContactId: '+orderContactId);
                            console.log('orderNumber: '+orderNumber);
                            console.log('isNewOrderSpecificContact: '+isNewOrderSpecificContact);
                            if(!isNewOrderSpecificContact){
                                console.log('im ready to get the shipping address');
                                component.set("v.title", "Edit Shipping Address");
                                helper.getShippingAddress(component, event, helper, orderNumber, orderContactId, isNewOrderSpecificContact);
                            }else{
                                component.set("v.title", "Add Order Specific Contact");
                                helper.getCtrlRef(component, event, helper, orderNumber, orderContactId, isNewOrderSpecificContact);
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
    
    createOrderSpecificContact : function(component, event, helper){
        console.log('inside create call');
        var validContact = component.find('shippingAddressform').reduce(function (validSoFar, inputCmp) { 
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validContact){
            console.log('ready to make create call');
            helper.showSpinner(component, event, helper);
            helper.createOsContact(component, event, helper);
        }
    },
    
    updateOrderSpecificContact : function(component, event, helper) {
		console.log('inside update call');
        var validContact = component.find('shippingAddressform').reduce(function (validSoFar, inputCmp) { 
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validContact){
            console.log('ready to make update call');
            helper.showSpinner(component, event, helper);
            helper.updateOsContact(component, event, helper);
        }
	},
    
    deleteOrderSpecificContact : function(component, event, helper) {
		console.log('inside delete call');
        helper.showSpinner(component, event, helper);
        helper.deleteOsContact(component, event, helper);
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