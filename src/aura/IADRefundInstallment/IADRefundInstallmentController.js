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
    
    PostRefund : function(component, event, helper) {
        var title;
            var type;
            var message;
            var processTotal = component.get("v.amounttorefund");
            console.log('processTotal: '+processTotal);
            var dueAmount = component.get("v.amount");
            console.log('amount due: '+dueAmount);
           
           
            if(processTotal <= 0 && processTotal < dueAmount){
                title = "Error!";
                type = "error";
                message = 'Not a valid amount.';
                helper.showToast(component, event, helper, title, type, message);
            }
            else if(parseFloat(processTotal) > parseFloat(dueAmount)){
                title = "Error!";
                type = "error";
                message = 'Process amount is greater than amount due.';
                helper.showToast(component, event, helper, title, type, message);
            }
        else
        {
            helper.showSpinner(component, event, helper);
            helper.processrefund(component, event, helper);
            
        }
        
        
        
    }
})