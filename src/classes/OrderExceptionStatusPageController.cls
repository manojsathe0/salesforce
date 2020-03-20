public  class OrderExceptionStatusPageController {
    public Order_Exception__c thisException{get;set;}
    private final Id recordId;
    public OrderExceptionStatusPageController(ApexPages.StandardController stdController) {
        recordId = stdController.getId();
        
        //thisException = (Order_Exception__c)stdController.getRecord();
        System.Debug('Inside loadHoldStatusField with ' + recordId);
        thisException = POR_OrderExceptionStatusController_Ltng.loadHoldStatusField(recordId);
        
    }
      public Boolean getOnHold() {
        if (thisException.Exception_Type__c  != null && ( thisException.Exception_Type__c.contains('Hold') ) ) {
            return true;
        }
        else {
            return false;
            
        }
    }
    public Boolean getThereAreOpenCases() {
        return POR_OrderExceptionStatusController_Ltng.checkExistingCases(recordId);
    }
    public PageReference putOnHold() {
      POR_OrderExceptionStatusController_Ltng.putOnHold(recordId);
      /*  PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage; */
        return null;
    }
    public PageReference removeFromHold() {
        POR_OrderExceptionStatusController_Ltng.removeFromHold(recordId);
       /* PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        */
        return null;
    }
}