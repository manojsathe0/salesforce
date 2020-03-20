@isTest
public with sharing class IADUpdateCaseControllerTest {
    
    final static String RESERACHING = 'Researching';
    final static String DESCRIPTION = 'Test Description';
    final static String OPEN = 'Open';
    final static String PROBLEM = 'Problem';
    final static String BBB = 'BBB';
    final static String ASSIGNED_FOR_CUSTOMER_OUTREACH = 'Assigned for Customer Outreach';

    static testMethod void testUpdateCase()
    {
            Account testAccount = TestUtils.createAccounts(1, 'accName', true)[0];

            Contact testContact = TestUtils.createContacts(1, 'lname', testAccount.Id, true)[0];
            
            Order__c testOrder = TestUtils.createOrders(1, null , false)[0];
            testOrder.OrderID__c = '43534534';
            testOrder.Contact_Name__c = 'Joe Montana';
            testOrder.Contact_State__c = 'CA';
            testOrder.Contact__c = testContact.Id;
            insert testOrder;

            Id relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
            
            Product2 testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
            testProduct.Relationship_Type__c = relationshipTypeId;
            insert testProduct;

            Order_Item__c testOrderItem = TestUtils.createOrderItems(1 , testOrder.Id ,  false)[0];
            testOrderItem.User_Order_ID__c = '123456789';
            testOrderItem.Product__c = testProduct.Id;
            insert testOrderItem;

            List<Case> testCases = TestUtils.createCases(2, true);

            Case testCase1 = testCases[0];
            testCase1.ContactId = testContact.Id;

            Case testCase2 = testCases[1];
            testCase2.ContactId = testContact.Id;

            update new List<Case>{testCase1,testCase2};

            ApexPages.StandardController sc = new ApexPages.StandardController(testCase1);
            IADUpdateCaseController theController = new IADUpdateCaseController(sc);
            //theController.hideModal();
            //theController.setMsg();
            PageReference pageRef = Page.IADUpdateCasePage;
            pageRef.getParameters().put('id', String.valueOf(testCase1.Id));
            Test.setCurrentPage(pageRef);

            Test.startTest(); 
                theController.theCase.Processing_Number__c = '123456789';
                theController.description = DESCRIPTION;
                theController.theCase.Subject = 'Test create Case';
                theController.selectedtype = PROBLEM;
                theController.selectedStatus = OPEN;
                theController.selectedStatusReason = BBB;
                theController.selectedProduct = 'Business Services';
                theController.updateCase();
            Test.stopTest();

            List<Case> updatedCases  = [SELECT Id , Status , Description  FROM Case WHERE Id =:testCase1.Id];
            System.assertEquals(OPEN , updatedCases[0].Status , 'Right status should have been populated');
           
           
    }
    
    static testMethod void testStatusReasons()
    {
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
        Contact testContact = TestUtils.createContacts(1 , 'Test Contact' , testAccount.Id , true)[0];
        List<Case> testCases = TestUtils.createCases(2, true);
        Case testCase1 = testCases[0];
        
        IAD_Case_Status_Reasons__c newStatusReason = new IAD_Case_Status_Reasons__c();
        newStatusReason.Product__c = 'Business Services';
        newStatusReason.Record_Type__c = PROBLEM;
        newStatusReason.Status__c = 'LZ Working on Case';
        newStatusReason.Status_Reason__c = ASSIGNED_FOR_CUSTOMER_OUTREACH;
        insert newStatusReason;

        ApexPages.StandardController sc = new ApexPages.StandardController(testCase1);
        IADUpdateCaseController theController = new IADUpdateCaseController(sc);
        PageReference pageRef = Page.IADUpdateCasePage;
        pageRef.getParameters().put('id', String.valueOf(testContact.Id));
        Test.setCurrentPage(pageRef);

        Test.startTest(); 
            theController.getproducts();
            theController.getTypes();
            theController.getStatus();
            theController.selectedtype = PROBLEM;
            theController.selectedStatus = 'LZ Working on Case';
            theController.selectedProduct = 'Business Services';
        Test.stopTest();
theController.dismiss();
theController.closePopup();
        
        System.assertEquals(ASSIGNED_FOR_CUSTOMER_OUTREACH, theController.getStatusReasons()[0].getValue(), 'Right status reason should have been populated');
    }
}