({
	 doInit : function(cmp, event, helper) {
        console.log('ready to invoke getOrder');
        helper.getorder(cmp,event,helper);
    },
    
    openOrderDetails : function(component, event, helper){
        var customerId = component.get("v.customerId");
        var orderNumber = event.currentTarget.dataset.orderidfromsub;
        var orderid= event.currentTarget.dataset.orderrecordid;   
       
        
        var subtaburl = '/lightning/n/Order_Details?orderId=' + orderNumber + '&customerId=' + customerId;
        var tabLabel = orderNumber;
        var tabIcon = 'custom17';
		  var subString = '/lightning/r/Order__c/' + orderid + '/view';
        
        console.log('sub: '+subString);
        console.log('subtaburl: '+subtaburl);
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.openTab({
            url: subString,
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                  tabId: response
            }).then(function(tabInfo) {
            
            });
        })
        .catch(function(error) {
               console.log(error);
        });
    }
})