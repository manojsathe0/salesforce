/*
Subscription Save application.
Created by Artyom M.
Per Story: B-24904
*/


@isTest
public with sharing class SubscriptionSaveControllerTest_Ltng {
    public static Contact firstContact;
    final static String PRODUCT_LINE = 'Test ProductLine';
    static Id relationshipTypeId;
    public static void dataSetup() {
        Account anotherAccount = TestUtils.createAccounts(1 , 'Test Account', true)[0];
        
        List<Contact> testContacts = new List<Contact>();
        firstContact = TestUtils.createContacts(1 , 'Test Contact', anotherAccount.Id, false)[0];
        firstContact.Genesys_Interaction_Id__c = 'testID';
        insert firstContact;
        System.Debug('Contact ID: ' + firstContact.Id);
        
        Product2 testProduct = TestUtils.createProducts( 1 , '', false)[0];
        testProduct.Name = 'Business Advantage Pro Attorney Consultation';
        Product_Line__c testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;
        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        insert testProduct;
        
        
        List<Order__c> testOrders = TestUtils.createOrders(2 , testProduct.Id ,  false);
       
       
        for(Order__c theOrder : testOrders) {
            theOrder.Contact__c = firstContact.Id;
        }
        try {
            insert testOrders;
        }
        catch(DMLException e) {
            System.Debug('Inserting Orders: ' + e.getMessage());    
        } 
        
        System.Debug('testOrders ID: ' + testOrders[0].Id);
        List<Order_Item__c> orderItemsToCreate = new List<Order_Item__c>();
        for(Order__c theOrder : testOrders)
        {
            Order_Item__c theItem = TestUtils.createOrderItems(1 , theOrder.Id , false)[0];
            theItem.Product__c = testProduct.Id;
            theItem.Subscription_Status__c = 'Active';
            theItem.Subscription_Start_Date__c = System.Now().addDays(-10);
            theItem.Subscription_End_Date__c = System.Now().addDays(10);
            //theItem.Relationship_Type__c = packageRelationshipType.Id;
            orderItemsToCreate.add(theItem);
        }
        try {
            insert orderItemsToCreate;
        }
        catch(DMLException e) {
            System.Debug('Inserting order Items: ' + e.getMessage());   
        } 
        System.Debug('testOrders itemsID: ' + orderItemsToCreate[0].Id);
        
        Task theTsk = new Task();
        theTsk.Subject = 'test';
        theTsk.CallObject = 'testID';
        try {
            insert theTsk;
        }
        catch (DMLException e) {
            System.Debug('Inserting Task: ' + e.getMessage());  
        }
        
        
        
    }
    static testMethod void getCancellationReasonsTest() {
        SubscriptionSaveController_Ltng.getCancellationReasons();
        
    }
    static testMethod void getRelatetOrderItemsTest() {
        dataSetup();
        
        SubscriptionSaveController_Ltng.getRelatetOrderItems(firstContact.Id);
        
    }
    
    static testMethod void checkForCallTest() {
        dataSetup();
        
        SubscriptionSaveController_Ltng.checkForCall(firstContact.Id);
        
    }
    static testMethod void doSubmitTest() {
        dataSetup();
        
        String selected = '[{"isSelected":true,"itemId":"a0n3B000000gS0ZQAU","lzOrderItemId":"54321","orderId":"a0p3B000000UwjNQAS","parentOrderNumber":"12345","productName":"2-Day Trial - Business Advantage Pro Renewal","susbcriptionStatus":"Active","cancellationReason":"(Paid) No longer needed"}]';
        SubscriptionSaveController_Ltng.doSubmit(firstContact.Id, selected);
        
    }
    
    
}