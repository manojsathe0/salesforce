@isTest
public with sharing class NextPadControllerTest_Ltng {
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
     static void setup() {
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
    static void setupData() {
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
        NextPadController_Ltng cont = new NextPadController_Ltng();
        cont.processingNumber = 'test';
        cont.customerOrderNumber = 'test';
        cont.description = 'test';
        cont.productName = 'test';
        cont.productLine = 'test';
        cont.contactState = 'test';
        NextPadController_Ltng.orderId='test';
        //cont.orderId = 'test';
        //cont.orderId = 'test';
        cont.sortOrder = 'test';
        cont.filterNoteType = 'test';
        cont.orderItemId = 'test';

    }
    @isTest
  static void testGetContactName() {
    NextPadController_Ltng.getContactName(USER_ORDER_ID, 'test', ORDER_NUMBER);
  }
  @isTest
  static void testGetDataSortedBy() {
    NextPadController_Ltng.getDataSortedBy(USER_ORDER_ID, 'test', ORDER_NUMBER, 'date', 'ascending', 'all');
    NextPadController_Ltng.getDataSortedBy(USER_ORDER_ID, 'test', ORDER_NUMBER, 'date', 'ascending', 'cases');
    NextPadController_Ltng.getDataSortedBy(USER_ORDER_ID, 'test', ORDER_NUMBER, '!date', 'DESCENDING', 'notes');
  }
  @isTest
  static void testSubmitRecord() {
    NextPadController_Ltng.submitRecord(USER_ORDER_ID, 'test', ORDER_NUMBER, 'Test', 'case','');
    NextPadController_Ltng.submitRecord(USER_ORDER_ID, 'test', ORDER_NUMBER, 'Test', 'note','');
    NextPadController_Ltng.submitRecord(USER_ORDER_ID, 'test', ORDER_NUMBER, 'Test', 'case',userInfo.getUserId());
    NextPadController_Ltng.submitRecord(USER_ORDER_ID, 'test', ORDER_NUMBER, 'Test', 'note',userInfo.getUserId());  
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
        NextPadService_Ltng serv = new NextPadService_Ltng();
        serv.processingNumber = USER_ORDER_ID;
        Test.startTest();
            serv.populateAllInformationByProcessingNumber(USER_ORDER_ID, 'test', ORDER_NUMBER);
        Test.stopTest();

        //System.assertEquals(6 , theController.allNotes.size() ,'6 records hsould have been populated');
    }
    static testMethod void testNoteWrapper_Ltng() {
        DateTime dt = System.now();
        NoteWrapper_Ltng t = new NoteWrapper_Ltng('Test', dt, 'Test', 'Test', 'Test', 'Test', 'Test', 'Test', 'Test', 'Test', true);
        //t.SORT_FIELD = NoteWrapper_Ltng.SortField.DateTimeCreated;
        NoteWrapper_Ltng b = new NoteWrapper_Ltng('Test', dt, 'Test', 'Test', 'Test', 'Test', 'Test', 'Test', 'Test', 'Test', true);
        t.compareTo(b);
        NoteWrapper_Ltng.SORT_FIELD = NoteWrapper_Ltng.SortField.Name;
        b.compareTo(t);
    }

}