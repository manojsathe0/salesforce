@isTest
public class NextPadControllerTest
{
    
    static Order__c testOrder;
    static Order_Item__c testOrderItem;
    static Contact testContact;
    static Account testAccount;
    static List<Case> testCases;
    static List<Task> noteTasks;
    static List<CaseComment> caseComments; 
    final static Integer SIZE_ONE = 1;
    final static Integer SIZE_THREE = 3;
    final static String TEST_ACCOUNT = 'Test Account';
    final static String TEST_CONTACT = 'Test Contact';
    final static String ORDER_NUMBER = '3456789';
    final static String USER_ORDER_ID = '54321675';
    final static String DESCRIPTION = 'This is description';
    static void setup()
    {
        SEAD_Configuration__c config = new SEAD_Configuration__c();
        config.Name = 'Default';
        config.Lead_New_Stage_Activity_Limit__c = 1;
        config.Lead_Qualified_Stage_Activity_Limit__c = 2;
        config.Lead_Validated_Stage_Activity_Minimum__c = 3;
        config.Lead_Abandoner_Score__c = 1;
        config.Lead_Chat_Score__c = 1;
        config.Lead_Days_from_Ownership__c = 2;
        config.Lead_Email_Score__c = 1;
        config.Lead_Inbound_Score__c = 2;
        config.Lead_Mobile_Score__c = 3;
        config.Lead_Score_Initial__c = 3;
        config.Lead_Social_Media_Score__c = 1;


        insert config;
    }
    static void setupData()
    {
        setup();
        testAccount = TestUtils.createAccounts(SIZE_ONE , TEST_ACCOUNT, true)[0];
        testContact = TestUtils.createContacts(SIZE_ONE , TEST_CONTACT , testAccount.Id , true)[0];
        
        
        testCases = TestUtils.createCases( SIZE_THREE , false);
        for(Case theCase : testCases)
        {
            theCase.Order_Number__c = ORDER_NUMBER;
            theCase.Processing_Number__c = USER_ORDER_ID;
        }
        
        
        
        testOrder = TestUtils.createOrders(SIZE_ONE, null , false)[0];
        testOrder.OrderID__c = ORDER_NUMBER;
        insert testOrder;
        noteTasks = TestUtils.createTasks(SIZE_THREE , testOrder.Id , false); 
        testOrderItem = TestUtils.createOrderItems(SIZE_ONE , testOrder.Id ,  false)[0];
        testOrderItem.User_Order_ID__c = USER_ORDER_ID;
        insert testOrderItem;

    }

    static testMethod void testSave_Case()
    {   
        setupData();
        ApexPages.StandardController sc = new ApexPages.standardController(testOrderItem);
        NextPadController theController = new NextPadController(sc);
        theController.description = DESCRIPTION;
        theController.theNextPadService.orderNumber = USER_ORDER_ID;
        theController.theNextPadService.orderId = testOrder.Id;
        theController.selectedNoteType = NextPadService.PROBLEM_ORDER;
        Test.startTest();
            theController.SaveNote();
        Test.stopTest();

        List<Case> createdCases = [SELECT Id , Description FROM Case];
        System.assertEquals(SIZE_ONE , createdCases.size() , SIZE_ONE+' record should have been created');
        System.assertEquals(DESCRIPTION , createdCases[0].Description , 'Right description should have been populated');
    }

    static testMethod void testSave_Task()
    {   
        setupData();
        ApexPages.StandardController sc = new ApexPages.standardController(testOrderItem);
        NextPadController theController = new NextPadController(sc);
        theController.description = DESCRIPTION;
        theController.theNextPadService.orderNumber = USER_ORDER_ID;
        theController.theNextPadService.orderId = testOrder.Id;
        theController.selectedNoteType = NextPadService.ORDER_NOTE;
        Test.startTest();
            theController.SaveNote();
        Test.stopTest();

        List<Task> createdTasks = [SELECT Id , Description FROM Task];
        System.assertEquals(SIZE_ONE , createdTasks.size() , SIZE_ONE+' record should have been created');
        System.assertEquals(DESCRIPTION , createdTasks[0].Description , 'Right description should have been populated');
    }


    static testMethod void testPopulateProcessingNumber()
    {
        setupData();
        PageReference pageRef = Page.NextPad;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('processingNumber', USER_ORDER_ID);
      
        Test.startTest();
              ApexPages.StandardController sc = new ApexPages.standardController(testOrderItem);
              NextPadController theController = new NextPadController(sc);
        Test.stopTest();

        System.assertEquals(USER_ORDER_ID , theController.processingNumber , 'Right processing number should have been populated'); 

    }

    static testMethod void testCancel()
    {
        setupData();
        PageReference pageRef = Page.NextPad;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('processingNumber', USER_ORDER_ID);
        
        ApexPages.StandardController sc = new ApexPages.standardController(testOrderItem);
        NextPadController theController = new NextPadController(sc);

        theController.description = 'Test Description';
        Test.startTest();
              theController.clear();
        Test.stopTest();

        System.assertEquals('' , theController.description , 'Description should have been cleared out');   

    }

    static testMethod void testPopulateAllNotes()
    {
        setupData();
        insert testCases;
        caseComments = new List<CaseComment>();
        for(Case theCase : testCases)
        {
            CaseComment theComment = new CaseComment();
            theComment.commentBody = 'Test Comment';
            theComment.ParentId = theCase.Id;
            caseComments.add(theComment);
        }

        insert caseComments;
        insert noteTasks;
        ApexPages.StandardController sc = new ApexPages.standardController(testOrderItem);
        NextPadController theController = new NextPadController(sc);
        theController.processingNumber = USER_ORDER_ID;
        Test.startTest();
            theController.populateAllNotes();
        Test.stopTest();

        System.assertEquals(6 , theController.allNotes.size() ,'6 records hsould have been populated');
    }


    static testMethod void testFilterNotes()
    {
        setupData();
        insert testCases;
        caseComments = new List<CaseComment>();
        for(Case theCase : testCases)
        {
            CaseComment theComment = new CaseComment();
            theComment.commentBody = 'Test Comment';
            theComment.ParentId = theCase.Id;
            caseComments.add(theComment);
        }

        insert caseComments;
        insert noteTasks;
        ApexPages.StandardController sc = new ApexPages.standardController(testOrderItem);
        NextPadController theController = new NextPadController(sc);

        theController.processingNumber = USER_ORDER_ID;
        update testCases;
        theController.filterNoteType = NextPadService.THE_CASE;
        Test.startTest();
            theController.filterNotes();
        Test.stopTest();
        System.assertEquals(SIZE_THREE ,theController.allNotes.size() ,SIZE_THREE + ' record should have been populated');
    }

    static testMethod void testSortNotesByUser()
    {
        setupData();
        insert testCases;
        caseComments = new List<CaseComment>();
        for(Case theCase : testCases)
        {
            CaseComment theComment = new CaseComment();
            theComment.commentBody = 'Test Comment';
            theComment.ParentId = theCase.Id;
            caseComments.add(theComment);
        }

        insert caseComments;
        insert noteTasks;
        ApexPages.StandardController sc = new ApexPages.standardController(testOrderItem);
        NextPadController theController = new NextPadController(sc);

        theController.processingNumber = USER_ORDER_ID;
        update testCases;
        Test.startTest();
            theController.sortNotesByUser();
        Test.stopTest();
        
    }



}