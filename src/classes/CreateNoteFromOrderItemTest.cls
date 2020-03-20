@isTest
public with sharing class CreateNoteFromOrderItemTest
{

	static void setupData()
	{

	}
	
	static testMethod void testCreateTask()
	{
		
		Order__c testOrder = TestUtils.createOrders(1 , null , true)[0];
		List<Order_Item__c> theItems = TestUtils.createOrderItems(1 , testOrder.Id , false);
		theItems[0].User_Order_ID__c = '12345';
		insert theItems;

		ApexPages.StandardController sc = new ApexPages.StandardController(theItems[0]);
        CreateOrderNoteFromOrderItemController theController = new CreateOrderNoteFromOrderItemController(sc);
        PageReference pageRef = Page.CreateOrderNoteFromOrderItem;
        pageRef.getParameters().put('id', String.valueOf(theItems[0].Id));
        Test.setCurrentPage(pageRef);

        Test.startTest();
        	theController.createTask();
        Test.stopTest();

        List<Task> createdTasks = [SELECT Id , Subject , User_Order_ID__c FROM Task WHERE WhatId =:testOrder.Id];
        System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
        System.assertEquals('Order Note' , createdTasks[0].Subject , 'Right subject should have been populated');
        System.assertEquals('12345' , createdTasks[0].User_Order_ID__c , 'Right Processing Number should have been populated');
     }  
	 	
}