public with sharing class CreateOrderNoteFromOrderItemController
{
    public Task theTask {get; set;}
    public String lastError {get; set;}
    ApexPages.StandardController theController;
    Id orderItemId;
    public String processingNumber{get;set;}
    Id orderId;
    public CreateOrderNoteFromOrderItemController(ApexPages.StandardController controller) 
    {
        theController = controller;
        theTask = new Task();
        orderItemId = theController.getRecord().Id;     
        for(Order_Item__c theItem : [SELECT Id , Order__c ,  User_Order_ID__c FROM Order_Item__c WHERE Id = :orderItemId])
        {
            orderId = theItem.Order__c;
            processingNumber = theItem.User_Order_ID__c;
        }
        lastError = '';

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
            theTask.User_Order_ID__c = processingNumber;
            insert theTask;
            
            theTask = new Task();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Order Note Created.'));
            
        } catch(System.Exception ex){
           lastError = ex.getMessage();
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, lastError));
        }
        return null;
     }    
}