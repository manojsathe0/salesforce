public with sharing class CreateOrderNoteController 
{
    public Task theTask {get; set;}
    public String lastError {get; set;}
    ApexPages.StandardController theController;
    Id orderId;
    public String selectedUserOrderId{get;set;}
    public final static String SELECT_PROCESSING = 'Select Processing #'; 

    public CreateOrderNoteController(ApexPages.StandardController controller) 
    {
        theController = controller;
        theTask = new Task();
        orderId = theController.getRecord().Id;     
        lastError = '';

    }
     public List<SelectOption> availableProcessingNumbers
     {
        get
        {
            if(availableProcessingNumbers == null)
            {
                availableProcessingNumbers = new List<SelectOption>();
                availableProcessingNumbers.add(new SelectOption(SELECT_PROCESSING , SELECT_PROCESSING));
                for(Order_Item__c theItem : [SELECT Id , User_Order_ID__c , LZ_Product_Name__c FROM Order_Item__c WHERE Order__c = :orderId])
                {
                    if(theItem.User_Order_ID__c != null)
                        availableProcessingNumbers.add(new SelectOption(theItem.User_Order_ID__c , theItem.User_Order_ID__c +' - '+theItem.LZ_Product_Name__c)); //value and label
                }
            }
            
            return availableProcessingNumbers;
        }
        private set;
     }
     public PageReference createTask()
     {
       try 
       {
            theTask.Status = 'Completed';
            theTask.ActivityDate = Date.today();
            theTask.Subject = 'Order Note';
            theTask.WhatId = orderId;
            theTask.Priority = 'Normal';
            theTask.Type = 'Note';
            if(selectedUserOrderId != SELECT_PROCESSING)
                theTask.User_Order_ID__c = selectedUserOrderId;
            insert theTask;
            
            theTask = new Task();
            selectedUserOrderId = null;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Order Note Created.'));
            
        } catch(System.Exception ex){
           lastError = ex.getMessage();
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, lastError));
        }
        return null;
     }    

}