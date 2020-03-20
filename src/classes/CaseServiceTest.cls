@isTest
public class CaseServiceTest{
    static       List<Case>    testCases;
    static       List<Account> testAccounts;
    static final Integer       CASE_SIZE = 10;
    static final String        ORIGIN = 'Tester@testy.com';
    static final String        CASEOBJECT = 'Case';
    static final String        BAD_ORIGIN = 'test5646@test.tst';
    static final String        WRONG_ORIGIN = 'testWrong1234@test.tst';
    static       Group         firstGroup;
    static       Group         secondGroup;
    static final String        QUEUE = 'Queue';
    static final String        FIRST_QUEUE = 'First Queue';
    static final String        SECOND_QUEUE = 'Second Queue';
    static final String        FIRST_QUEUE_DEV_NAME = 'First_Queue';
    static final String        SECOND_QUEUE_DEV_NAME = 'Second_Queue';
    static final String        WRONG_QUEUE_DEV_NAME = 'Wrong_Queue';

    static void setupData(){
        testCases = TestUtils.createCases(CASE_SIZE, false);
        
        // A Queue is a Group of Type 'Queue'. These are two Queues
        firstGroup  = new Group(Name = FIRST_QUEUE,  DeveloperName = FIRST_QUEUE_DEV_NAME,  Type = QUEUE);
        secondGroup = new Group(Name = SECOND_QUEUE, DeveloperName = SECOND_QUEUE_DEV_NAME, Type = QUEUE);
        
        insert new List<Group>{ firstGroup , secondGroup};
        
        QueueSobject firstMappingObject  = new QueueSobject(QueueId = firstGroup.Id,  SobjectType = CASEOBJECT);
        QueueSobject secondMappingObject = new QueueSobject(QueueId = secondGroup.Id, SobjectType = CASEOBJECT);
        
        System.runAs(TestUtils.ADMIN_USER){
            insert new List<QueueSobject>{firstMappingObject , secondMappingObject};
            QueueMap__c theMapping = new QueueMap__c(Name = ORIGIN, Origin__c = ORIGIN, 
                Queue_Name__c = FIRST_QUEUE_DEV_NAME);
            QueueMap__c theWrongMapping = new QueueMap__c(Name = WRONG_ORIGIN, Origin__c = WRONG_ORIGIN, 
                Queue_Name__c = WRONG_QUEUE_DEV_NAME);    
            insert new QueueMap__c[]{theMapping, theWrongMapping};
            
        }
        
    }
    
    static testMethod void testPopulateOwnerWithMissspellQueueName(){
        setupData();
        
        for(Case theCase : testCases){
            theCase.Origin = WRONG_ORIGIN;
        }
        
        QueueMap_Default__c defaultqueue = new QueueMap_Default__c();
        defaultqueue.name = 'QueueMap';
        defaultqueue.Default_Queue_Name__c = FIRST_QUEUE;
        insert defaultqueue;
        
        Test.startTest();
        insert testCases;
        Test.stopTest();
        List<Case> updatedCases = [SELECT Id, OwnerId , Queue__c FROM Case WHERE Id IN :testCases];
        for(Case theCase : updatedCases){
            System.assertEquals(firstGroup.Id,   theCase.OwnerId,  'Owner should have been updated to Queue');
            System.assertEquals(firstGroup.Name, theCase.Queue__c, 'Queue field should have been updated to right queue value');
        }
    }
    
    
    static testMethod void testPopulateOwnerWithQueueForOriginInCustomSetting(){
        setupData();
        
        for(Case theCase : testCases){
            theCase.Origin = ORIGIN;
        }
        
        Test.startTest();
        insert testCases;
        Test.stopTest();
        List<Case> updatedCases = [SELECT Id, OwnerId , Queue__c FROM Case WHERE Id IN :testCases];
        for(Case theCase : updatedCases){
            System.assertEquals(firstGroup.Id,   theCase.OwnerId,  'Owner should have been updated to Queue');
            System.assertEquals(firstGroup.Name, theCase.Queue__c, 'Queue field should have been updated to right queue value');
        }
    }
    
    static testMethod void testPopulateOwnerWithCreatedUserForOriginNotInCustomSetting(){
        setupData();
        
        for(Case theCase : testCases){
            theCase.Origin = BAD_ORIGIN;
        }
        
        Test.startTest();
        insert testCases;
        Test.stopTest();
        List<Case> updatedCases = [SELECT Id, OwnerId FROM Case WHERE Id IN :testCases];
        for(Case theCase : updatedCases){
            System.assertEquals(UserInfo.getUserId() , theCase.OwnerId , 'Owner should have been Created Owner as there is no custom setting defined.');
        }
    }
    
    static testMethod void testOwnerPopulatedWithSelectedQueue(){
        setupData();
        insert testCases;
        testCases = [SELECT Id, OwnerId , Origin FROM Case WHERE Id IN :testCases];
        for(Case theCase : testCases){
            theCase.Queue__c = SECOND_QUEUE;
        }
        
        Test.startTest();
          update testCases;   
        Test.stopTest();
        List<Case> updatedCases = [SELECT Id, OwnerId FROM Case WHERE Id IN :testCases];
        for(Case theCase : updatedCases){
            System.assertEquals(secondGroup.id , theCase.OwnerId , 'Owner should have been updated to Queue');
        }
    }
    /*
    static testmethod void testAMoverride(){
        User am = TestUtils.ACCOUNT_MANAGER_USER;
        System.runAs(TestUtils.ADMIN_USER){
            insert am;
        }
        
        Group nonAmGroup  = new Group(Name = FIRST_QUEUE,  DeveloperName = FIRST_QUEUE_DEV_NAME,  Type = QUEUE);
        Group amGroup = new Group(Name = SECOND_QUEUE, DeveloperName = SECOND_QUEUE_DEV_NAME, Type = QUEUE);
        
        insert new List<Group>{ nonAmGroup , amGroup};
        
        QueueSobject nonAmQueue  = new QueueSobject(QueueId = nonAmGroup.Id,  SobjectType = CASEOBJECT);
        QueueSobject amQueue = new QueueSobject(QueueId = amGroup.Id, SobjectType = CASEOBJECT);
        
        System.runAs(TestUtils.ADMIN_USER){
            insert new List<QueueSobject>{nonAmQueue , amQueue};
            QueueMap__c theMapping = new QueueMap__c(Name = ORIGIN, Origin__c = ORIGIN, 
                Queue_Name__c = FIRST_QUEUE_DEV_NAME, AM_Queue_Name__c = SECOND_QUEUE_DEV_NAME);
            insert theMapping;
        }
        Account amAcct = new Account(Name='AM Account', Business_Account_Manager__c=am.Id);
        Account nonAmAcct = new Account(Name='Non AM Account');
        insert new Account[]{amAcct, nonAmAcct};
        Contact amContact = new Contact(LastName='AM Contact', AccountId=amAcct.Id);
        Contact nonAmContact = new Contact(LastName='Non AM Contact', AccountId=nonAmAcct.Id);
        insert new Contact[]{amContact, nonAmContact};
        Case amCase = new Case(Subject='AM Case Subject', ContactId=amContact.Id, Origin=ORIGIN, Assigned_User__c=null);
        Case nonAmCase = new Case(Subject='Non AM Case Subject', ContactId=nonAmContact.Id, Origin=ORIGIN, Assigned_User__c=null);
        
        Test.startTest();
        
        System.assertEquals(amAcct.Business_Account_Manager__c, am.Id, 
            'amAcct.Business_Account_Manager__c should be equal to am.Id but it is ' + amAcct.Business_Account_Manager__c);
        insert new Case[]{amCase, nonAmCase};
        
        amCase = [SELECT Id, OwnerId, Subject, Assigned_User__c FROM Case WHERE Id = :amCase.Id LIMIT 1];
        nonAmCase = [SELECT Id, OwnerId, Subject, Assigned_User__c FROM Case WHERE Id = :nonAmCase.Id LIMIT 1];
        // amCase should have Assigned User set, nonAmCase should not
        System.assertEquals(amCase.Assigned_User__c, am.Id);
        System.assertNotEquals(nonAmCase.Assigned_User__c, am.Id);
        
        // amCase should be owned by amQueue, nonAmCase by nonAmQueue
        System.assertEquals( amCase.OwnerId, amGroup.Id);
        System.assertEquals( nonAmCase.OwnerId, nonAmGroup.Id);
        Test.stopTest();
    }
    */
     static testmethod void testCloseExceptionsAndCases() {
       IADTestMockGenerator mock = new IADTestMockGenerator();
       Map<String,Map<String,Object>> mapMap = new Map<String,Map<String,Object>>();
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('overallRuleStatus',(Object)'passed');
        mapMap.put('overallOrderRuleStatus',orderItemIdToPdtCnfgId);
        String JSONresponse = JSON.serialize(mapMap);
        
        mock.testBody = JSONresponse;
        mock.statusCode = 200;
       
        Test.setMock(HttpCalloutMock.class, mock);
    Product2 testProduct;
    String PRODUCT_LINE = 'Intellectual Property';
    Product_Line__c testProductLine;
    testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;
        
        Id relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        
        testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
    testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        insert testProduct; 
    
    Order__c testOrder = TestUtils.createOrders(1 , testProduct.Id , true)[0];

    Order_Exception__c newExc = new Order_Exception__c();
        newExc.Order_Number__c = testOrder.Id;
        newexc.Processing_Number__c='1234567';
        newexc.Status__c='resolved';
        insert newExc;
    
    Case testCase = TestUtils.createCases(1, false)[0];
    testCase.Order_Exception__c = newExc.Id;
    testcase.Processing_Number__c='1234567';
        insert testCase;
        Set<Id> orderIds = new Set<Id>();
        orderIds.add(testOrder.Id);
        List<id> caseid = new list<id>();
        caseid.add(testcase.id);
        test.starttest();
        
        caseservice.problemCaseCloseUpdates(caseid);
        
        test.stoptest();
        
        }
        static testmethod void testCloseExceptionsAndCasesorders() {
       IADTestMockGenerator mock = new IADTestMockGenerator();
       Map<String,Map<String,Object>> mapMap = new Map<String,Map<String,Object>>();
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('overallRuleStatus',(Object)'passed');
        mapMap.put('overallOrderRuleStatus',orderItemIdToPdtCnfgId);
        String JSONresponse = JSON.serialize(mapMap);
        
        mock.testBody = JSONresponse;
        mock.statusCode = 200;
       
        Test.setMock(HttpCalloutMock.class, mock);
    Product2 testProduct;
    String PRODUCT_LINE = 'Intellectual Property';
    Product_Line__c testProductLine;
    testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;
        
        Id relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        
        testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
    testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        insert testProduct; 
    
    Order__c testOrder = TestUtils.createOrders(1 , testProduct.Id , true)[0];

    Order_Exception__c newExc = new Order_Exception__c();
        newExc.Order_Number__c = testOrder.Id;
        newexc.Processing_Number__c='1234567';
        newexc.Status__c='resolved';
        insert newExc;
     
    Case testCase = TestUtils.createCases(1, false)[0];
    testCase.Order_Exception__c = newExc.Id;
    testcase.Processing_Number__c='1234567';
        insert testCase;
        Set<Id> orderIds = new Set<Id>();
        orderIds.add(testOrder.Id);
         Id rtId_Biz = Schema.SObjectType.Failed_Rules__c.getRecordTypeInfosByName().get('Manual').getRecordTypeId();
        Failed_Rules__c rl = new Failed_Rules__c();
                rl.Parent_Exception__c = newExc.id;
                rl.Rule_Type__c = 'Manual';
                
                
                rl.RecordTypeId = rtId_Biz;
                   rl.Description__c = 'test';
                rl.Status__c = 'Active';
                insert rl;
        List<id> caseid = new list<id>();
        caseid.add(newExc.id);
        test.starttest();
        
        caseservice.problemCaseCloseUpdates(caseid);
        
        test.stoptest();
        
        }
        static testmethod void testCloseExceptionsccclosure() {
       IADTestMockGenerator mock = new IADTestMockGenerator();
       Map<String,Map<String,Object>> mapMap = new Map<String,Map<String,Object>>();
        Map<String, Object> orderItemIdToPdtCnfgId = new Map<String, Object>();
        orderItemIdToPdtCnfgId.put('overallRuleStatus',(Object)'passed');
        mapMap.put('overallOrderRuleStatus',orderItemIdToPdtCnfgId);
        String JSONresponse = JSON.serialize(mapMap);
        
        mock.testBody = JSONresponse;
        mock.statusCode = 200;
       
        Test.setMock(HttpCalloutMock.class, mock);
    Product2 testProduct;
    String PRODUCT_LINE = 'Intellectual Property';
    Product_Line__c testProductLine;
    testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;
        
        Id relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        
        testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
    testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        insert testProduct; 
    
    Order__c testOrder = TestUtils.createOrders(1 , testProduct.Id , true)[0];

    Order_Exception__c newExc = new Order_Exception__c();
        newExc.Order_Number__c = testOrder.Id;
        newexc.Processing_Number__c='1234567';
        newexc.Status__c='resolved';
        insert newExc;
     
    Case testCase = TestUtils.createCases(1, false)[0];
    testCase.Order_Exception__c = newExc.Id;
    testcase.Processing_Number__c='1234567';
        insert testCase;
        Set<Id> orderIds = new Set<Id>();
        orderIds.add(testOrder.Id);
         Id rtId_Biz = Schema.SObjectType.Failed_Rules__c.getRecordTypeInfosByName().get('Manual').getRecordTypeId();
        Failed_Rules__c rl = new Failed_Rules__c();
                rl.Parent_Exception__c = newExc.id;
                rl.Rule_Type__c = 'Manual';
                
                
                rl.RecordTypeId = rtId_Biz;
                   rl.Description__c = 'test';
                rl.Status__c = 'Active';
                insert rl;
        List<id> caseid = new list<id>();
        caseid.add(newExc.id);
        test.starttest();
        
        caseservice.ccCaseClosure(testcase.id,'1234567');
        
        test.stoptest();
        
        }
        
    //@Sai
    @isTest
    static void updateContactOnCase_Test() {

        Product2 testProduct;
        String PRODUCT_LINE = 'Intellectual Property';
        Product_Line__c testProductLine;
        testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;

        Id relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;

        testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
        testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        insert testProduct;

        Order__c testOrder = TestUtils.createOrders(1 , testProduct.Id , true)[0];

        Order_Exception__c newExc = new Order_Exception__c();
        newExc.Order_Number__c = testOrder.Id;
        newexc.Processing_Number__c = '1234567';
        newexc.Status__c = 'resolved';
        insert newExc;

        Case theCase = new Case();
        theCase.Order_Exception__c = newExc.Id;
        theCase.Processing_Number__c = '1234567';
        theCase.Order__c = testOrder.Id;
        theCase.recordTypeId = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);
        theCase.Total_outbound_emails__c = 100;
        //theCase.ManualruleStatus__c = 'Problem';
        insert theCase;

        update theCase; //==> to call updateContactOnCase()

        system.assert([select Total__c from Order_Exception__c].Total__c == 100);
    }
}