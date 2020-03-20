({
	doInit : function(component, event, helper){
        helper.loadPayments(component, event, helper);
    },
    
    openPayment :function(Component ,event ,helper)
    {
        var ctarget = event.currentTarget;
        var transactionid = ctarget.dataset.paymenttransactionid;
        var transactiontype =ctarget.dataset.transactiontype;
        helper.openPaymentDetail(Component ,event ,helper,transactionid,transactiontype);
    }
})