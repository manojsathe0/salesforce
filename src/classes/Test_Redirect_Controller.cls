public with sharing class Test_Redirect_Controller {
    public PageReference go() {
        PageReference send = new PageReference('https://qa-lzsuite.legalzoom.com/PartnerSales/Sale/Product/NewLead');
        send.setRedirect(true);
        return send;
    }
}