({
    doInit : function(component, event, helper){
        helper.loadStoreCredits(component, event, helper);
    },
    
    openStoreCredit : function(component ,event,helper)
    {  
        var ctarget = event.currentTarget;
        var storecreditid = ctarget.dataset.storecredit;
        var storecode = ctarget.dataset.storecreditcode;
        helper.openStoreCreditDetail(component ,event,helper ,storecreditid,storecode);
    }
})