({
	doInit : function(component, event, helper){
        window.setTimeout(
            $A.getCallback(
                function(){
                    helper.getOrderDetails(component, event, helper);
                }
            ),
            500
        );
    },
    
    openOrderDetails : function(component, event, helper){
        helper.loadOrderDetails(component, event, helper);
    },
    
    openPromoCodes : function(component, event, helper){
        window.open("https://qa-lzsuite/portal/PromotionCode.aspx", "Promo Codes", "");
    }
})