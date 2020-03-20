@isTest
public with sharing class IADCreateCaseControllerTest {


    final static String OPEN = 'Open';
    final static String PROBLEM = 'Problem';
    final static String BBB = 'BBB';
    final static String ASSIGNED_FOR_CUSTOMER_OUTREACH = 'Assigned for Customer Outreach';
    public static Account testAccount = new Account();
    public static Contact testContact = new Contact();
    public static ApexPages.StandardController sc;
    public static IADCreateCaseController theController;
    public static PageReference pageRef;
    public static final String NONE = '--None--';

    static void createTestData()
    {
        ProblemOrderRoutingServiceTest.setupData();
        testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
        testContact = TestUtils.createContacts(1 , 'Test Contact' , testAccount.Id , true)[0];
        sc = new ApexPages.StandardController(testContact);
        theController = new IADCreateCaseController(sc);
        pageRef = Page.IADCreateCase;
        pageRef.getParameters().put('id', String.valueOf(testContact.Id));
    }

    static testMethod void testCreateCase()
    {
        createTestData();

        Test.setCurrentPage(pageRef);

        Test.startTest();
        theController.theCase.Processing_Number__c = '123456789';
        theController.theCase.Subject = 'Test create Case';
        theController.selectedtype = PROBLEM;
        theController.selectedStatus = OPEN;
        theController.selectedStatusReason = BBB;
        theController.selectedProduct = 'Business Services';
        theController.createCase();
        Test.stopTest();

        List<Case> createdCases = [SELECT Id , Status , Status_Reasons__c ,Assigned_User__c FROM Case WHERE ContactId = :testContact.Id];
        System.assertEquals(1 , createdCases.size() , 'Size must be 1');
        System.assertEquals(OPEN , createdCases[0].Status , 'Right Status must have been populated');
        System.assertEquals(UserInfo.getUserId() , createdCases[0].Assigned_User__c , 'Right user should have been assigned');

        List<Task> createdTasks = [SELECT Id , Case_Status__c , Status_Reasons__c FROM Task WHERE whoId = :testContact.Id];
        System.assertEquals(1 , createdTasks.size() , '1 Task should have been created');

        System.assertEquals(OPEN , createdTasks[0].Case_Status__c , 'Right Case Status should have been populated');
        System.assertEquals(BBB , createdTasks[0].Status_Reasons__c , 'Right Status Reason should have been populated');

    }

    static testMethod void testCreateCase_processingNumberFail()
    {
        createTestData();

        Test.setCurrentPage(pageRef);

        Test.startTest();
        theController.theCase.Processing_Number__c = '12456';
        theController.theCase.Subject = 'Test create Case';
        theController.selectedtype = PROBLEM;
        theController.selectedStatus = OPEN;
        theController.selectedStatusReason = BBB;
        theController.selectedProduct = 'Business Services';
        theController.createCase();
        Test.stopTest();

        List<Case> createdCases = [SELECT Id , Status , Status_Reasons__c ,Assigned_User__c FROM Case WHERE ContactId = :testContact.Id];
        System.assertEquals(0 , createdCases.size() , 'Size must be 1');

    }
    static testMethod void testCreateCase_SubjectFail()
    {
        createTestData();
        Test.setCurrentPage(pageRef);

        Test.startTest();
        theController.theCase.Processing_Number__c = '123456789';
        theController.selectedtype = PROBLEM;
        theController.selectedStatus = OPEN;
        theController.selectedStatusReason = BBB;
        theController.selectedProduct = 'Business Services';
        theController.createCase();
        Test.stopTest();

        List<Case> createdCases = [SELECT Id , Status , Status_Reasons__c ,Assigned_User__c FROM Case WHERE ContactId = :testContact.Id];
        System.assertEquals(0 , createdCases.size() , 'Size must be 1');
    }

    static testMethod void testCreateCase_selectedProductFail()
    {
        createTestData();
        Test.setCurrentPage(pageRef);

        Test.startTest();
        theController.theCase.Processing_Number__c = '123456789';
        theController.theCase.Subject = 'Test create Case';
        theController.selectedProduct = NONE;
        theController.selectedtype = PROBLEM;
        theController.selectedStatus = OPEN;
        theController.selectedStatusReason = BBB;
        theController.createCase();
        Test.stopTest();

        List<Case> createdCases = [SELECT Id , Status , Status_Reasons__c ,Assigned_User__c FROM Case WHERE ContactId = :testContact.Id];
        System.assertEquals(0 , createdCases.size() , 'Size must be 1');
    }


    static testMethod void testCreateCase_selectedStatusFail()
    {
        createTestData();
        Test.setCurrentPage(pageRef);

        Test.startTest();
        theController.theCase.Processing_Number__c = '123456789';
        theController.theCase.Subject = 'Test create Case';
        theController.selectedtype = PROBLEM;
        theController.selectedStatusReason = BBB;
        theController.selectedProduct = 'Business Services';
        theController.selectedStatus = NONE;
        theController.createCase();
        Test.stopTest();

        List<Case> createdCases = [SELECT Id , Status , Status_Reasons__c ,Assigned_User__c FROM Case WHERE ContactId = :testContact.Id];
        System.assertEquals(0 , createdCases.size() , 'Size must be 1');
    }

    static testMethod void testCreateCase_queueFail()
    {
        createTestData();
        Test.setCurrentPage(pageRef);

        Test.startTest();
        theController.theCase.Processing_Number__c = '123456789';
        theController.theCase.Subject = 'Test create Case';
        theController.theCase.Queue__c = NONE;
        theController.selectedtype = PROBLEM;
        theController.selectedStatusReason = BBB;
        theController.selectedProduct = 'Business Services';
        theController.selectedStatus = OPEN;
        theController.createCase();
        Test.stopTest();

        List<Case> createdCases = [SELECT Id , Status , Status_Reasons__c ,Assigned_User__c FROM Case WHERE ContactId = :testContact.Id];
        System.assertEquals(0 , createdCases.size() , 'Size must be 1');
    }

    static testMethod void testCreateCase_DescriptionFail()
    {
        createTestData();
        Test.setCurrentPage(pageRef);

        Test.startTest();
        theController.theCase.Processing_Number__c = '1234567';
        theController.theCase.Subject = 'Test create Case';
        theController.theCase.Description = '';
        theController.selectedtype = PROBLEM;
        theController.selectedStatusReason = BBB;
        theController.selectedProduct = 'Business Services';
        theController.selectedStatus = OPEN;
        theController.createCase();
        Test.stopTest();

        List<Case> createdCases = [SELECT Id , Status , Status_Reasons__c ,Assigned_User__c FROM Case WHERE ContactId = :testContact.Id];
        System.assertEquals(0 , createdCases.size() , 'Size must be 1');
    }


    static testMethod void testStatusReasons()
    {
        Account testAccount2 = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
        Contact testContact2 = TestUtils.createContacts(1 , 'Test Contact' , testAccount2.Id , true)[0];

        IAD_Case_Status_Reasons__c newStatusReason = new IAD_Case_Status_Reasons__c();
        newStatusReason.Product__c = 'Business Services';
        newStatusReason.Record_Type__c = PROBLEM;
        newStatusReason.Status__c = 'LZ Working on Case';
        newStatusReason.Status_Reason__c = ASSIGNED_FOR_CUSTOMER_OUTREACH;
        insert newStatusReason;

        ApexPages.StandardController sc2 = new ApexPages.StandardController(testContact2);
        IADCreateCaseController theController2 = new IADCreateCaseController(sc2);
        PageReference pageRef2 = Page.IADCreateCase;
        pageRef2.getParameters().put('id', String.valueOf(testContact2.Id));
        Test.setCurrentPage(pageRef2);

        Test.startTest();
        theController2.getproducts();
        theController2.getTypes();
        theController2.getStatus();
        theController2.selectedtype = PROBLEM;
        theController2.selectedStatus = 'LZ Working on Case';
        theController2.selectedProduct = 'Business Services';
        Test.stopTest();
        //First Option 0th Element is --None--.Hence 1.
        System.assertEquals(ASSIGNED_FOR_CUSTOMER_OUTREACH, theController2.getStatusReasons()[1].getValue(), 'Right status reason should have been populated');
    }


}