@isTest
public with sharing class CreateOrderNoteControllerTest
{

	static void setupData()
	{

	}
	
	static testMethod void testCreateTask()
	{
		
		Order__c testOrder = TestUtils.createOrders(1 , null , true)[0];
		ApexPages.StandardController sc = new ApexPages.StandardController(testOrder);
        CreateOrderNoteController theController = new CreateOrderNoteController(sc);
        PageReference pageRef = Page.CreateOrderNote;
        pageRef.getParameters().put('id', String.valueOf(testOrder.Id));
        Test.setCurrentPage(pageRef);

        Test.startTest();
        	theController.selectedUserOrderId = '12345';
        	theController.createTask();
        Test.stopTest();

        List<Task> createdTasks = [SELECT Id , Subject , User_Order_ID__c FROM Task WHERE WhatId =:testOrder.Id];
        System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
        System.assertEquals('Order Note' , createdTasks[0].Subject , 'Right subject should have been populated');
        System.assertEquals('12345' , createdTasks[0].User_Order_ID__c , 'Right Processing Number should have been populated');
     }  


	static testMethod void testAvailableProcessingNumber()
	{
		Order__c testOrder = TestUtils.createOrders(1 , null , true)[0];
		List<Order_Item__c> theItems = TestUtils.createOrderItems(5 , testOrder.Id , false);
		for(Integer i = 0 ; i<5 ;++i)
		{
			theItems[i].User_Order_ID__c = i+'';
		}
		insert theItems;

		ApexPages.StandardController sc = new ApexPages.StandardController(testOrder);
        CreateOrderNoteController theController = new CreateOrderNoteController(sc);
        PageReference pageRef = Page.CreateOrderNote;
        pageRef.getParameters().put('id', String.valueOf(testOrder.Id));
        Test.setCurrentPage(pageRef);

        Test.startTest();
        	System.assertEquals(6 , theController.availableProcessingNumbers.size() , '6 processing number including select processing #');
        Test.stopTest();
	} 	
}