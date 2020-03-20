({
    doInit : function(component, event, helper){
        helper.loadInstallments(component, event, helper);
    },
    
    openinstallmentdetail : function(component,event ,helper){
        var installmentdetailid = event.currentTarget.dataset.installmentdetail;
        helper.Openinstallmenttab(component, event, helper,installmentdetailid);
    }
})