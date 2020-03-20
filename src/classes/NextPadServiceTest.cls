@isTest
public class NextPadServiceTest
{
    
    static Order__c testOrder;
    static Order_Item__c testOrderItem;
    static Contact testContact;
    static Account testAccount;
    static List<Case> testCases;
    final static Integer SIZE_ONE = 1;
    final static Integer SIZE_THREE = 3;
    final static String TEST_ACCOUNT = 'Test Account';
    final static String TEST_CONTACT = 'Test Contact';
    final static String ORDER_NUMBER = '3456789';
    final static String USER_ORDER_ID = '54321675';
    static Product2 testProduct;
    static void setupData()
    {
        testAccount = TestUtils.createAccounts(SIZE_ONE , TEST_ACCOUNT, true)[0];
        testContact = TestUtils.createContacts(SIZE_ONE , TEST_CONTACT , testAccount.Id , true)[0];
        testCases = TestUtils.createCases( SIZE_THREE , false);
        for(Case theCase : testCases)
        {
            theCase.Order_Number__c = ORDER_NUMBER;
            theCase.Processing_Number__c = USER_ORDER_ID;
        }
        insert testCases;
        
        testOrder = TestUtils.createOrders(SIZE_ONE, null , false)[0];
        testOrder.OrderID__c = ORDER_NUMBER;
        testOrder.Contact_Name__c = 'Joe Montana';
        testOrder.Contact_State__c = 'CA';
        insert testOrder;

        Id relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        
        testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
        testProduct.Relationship_Type__c = relationshipTypeId;
        insert testProduct;

        testOrderItem = TestUtils.createOrderItems(SIZE_ONE , testOrder.Id ,  false)[0];
        testOrderItem.User_Order_ID__c = USER_ORDER_ID;
        testOrderItem.Product__c = testProduct.Id;
        insert testOrderItem;

    }

    
    static testMethod void testPopulateAllInformationByProcessingNumber()
    {
        setupData();

        NextPadService theNextPadService = new NextPadService();
        Test.startTest();
            theNextPadService.populateAllInformationByProcessingNumber(USER_ORDER_ID , null);
        Test.stopTest();

        System.assertEquals(SIZE_THREE,  theNextPadService.noteWrappers.size() , SIZE_THREE +' Note Wrappers should have been returned');
        Set<Id> expectedIds = new Set<Id>{testCases[0].Id , testCases[1].Id , testCases[2].Id};
        Set<Id> actualObjectIds = new Set<Id>();
        for(NoteWrapper theWrapper : theNextPadService.noteWrappers)
        {
            actualObjectIds.add(theWrapper.id);
        }
        System.assert(expectedIds.containsAll(actualObjectIds) , 'All right Ids should have been present');
        System.assert(actualObjectIds.containsAll(expectedIds) , 'All right Ids should have been present');

    }
    
    static testMethod void testPopulateAllInformationByOrderItemId()
    {
        setupData();
        List<Task> orderNotes = TestUtils.createTasks(5 , testOrder.Id , true);//Gives 5 Order level Notes
        List<Case> orderLevelCases = TestUtils.createCases( SIZE_THREE , false); //Gives 3 Order level Case
        for(Case theCase : orderLevelCases)
        {
            theCase.Order_Number__c = ORDER_NUMBER;
        }
        insert orderLevelCases;

        //Since the Items inserted above for Order has the 3 Cases with Processing Number it will pull up those records - 3
        Set<Id> expectedIds = new Set<Id>();
        for(Case theCase : testCases)
        {
            expectedIds.add(theCase.Id);
        }
        for(Task theTask : orderNotes)
        {
            expectedIds.add(theTask.Id);
        }
        for(Case theCase : orderLevelCases)
        {
            expectedIds.add(theCase.Id);
        }
        NextPadService theNextPadService = new NextPadService();
        Test.startTest();
            theNextPadService.populateAllInformationByProcessingNumber(null , testOrderItem.Id);//This is for when the page gets called from inline VF page which don't provide processingNumber
        Test.stopTest();
        
        System.assertEquals(11 ,  theNextPadService.noteWrappers.size() , 11 +' Note Wrappers should have been returned');
        Set<Id> actualIds = new Set<Id>();
        for(NoteWrapper theWrapper : theNextPadService.noteWrappers)
        {
            actualIds.add(theWrapper.Id);
        }

        System.assert(actualIds.containsAll(expectedIds) , 'All Ids should be present');
        System.assert(expectedIds.containsAll(actualIds) , 'All Ids should be present');
    }
    
    static testMethod void testGetAllCaseIds()
    {
        setupData();
        NextPadService theNextPadService = new NextPadService();
        Set<Id> orderIds = new Set<Id>();
        orderIds.add(testOrder.Id);
        theNextPadService.orderIds = orderIds;
        theNextPadService.processingNumber = USER_ORDER_ID;
        theNextPadService.orderNumber = ORDER_NUMBER;
        Set<Id> allCaseIds;
        Test.startTest();
            allCaseIds = theNextPadService.getAllCasesIds();
        Test.stopTest();
        System.assertEquals(SIZE_THREE , allCaseIds.size() , SIZE_THREE+' Cases should have been returned');
    }

    static testMethod void testGetUserIds()
    {
        setupData();
        NextPadService theNextPadService = new NextPadService();
        List<Case> queriedCases = [SELECT Id , CreatedById FROM Case WHERE Id IN :testCases];
        Set<Id> userIds;

        Test.startTest();
            userIds = theNextPadService.getUserIds(queriedCases , new List<Task>());
        Test.stopTest();

        System.assertEquals(SIZE_ONE , userIds.size() , SIZE_ONE+' Id should have been returned');
        System.assert(userIds.contains(UserInfo.getUserId()) , 'Current user must have been present');
    }
    

    static testMEthod void testGetCasesByCaseIdFilterByOrderAndProcessingNumber()
    {
        setupData();
        NextPadService theNextPadService = new NextPadService();
        theNextPadService.processingNumber = USER_ORDER_ID;
        theNextPadService.orderNumber = ORDER_NUMBER;
        
        Case differentProcessingNumberCase = TestUtils.createCases(1 , false)[0];
        differentProcessingNumberCase.Order_Number__c = ORDER_NUMBER;
        differentProcessingNumberCase.Processing_Number__c = '5741234'; //different processing number but same order.Should not show up
        insert differentProcessingNumberCase;

        Set<Id> caseIds = new Set<Id>{testCases[0].Id , testCases[1].Id , testCases[2].Id , differentProcessingNumberCase.Id};
        theNextPadService.orderNumber = ORDER_NUMBER;
        theNextPadService.processingNumber = USER_ORDER_ID;

        Set<Id> expectedCaseIds = new Set<Id>{testCases[0].Id , testCases[1].Id , testCases[2].Id};
        List<Case> casesToConsider;

        Test.startTest();
            casesToConsider = theNextPadService.getCasesByCaseIdFilterByOrderAndProcessingNumber(caseIds);
        Test.stopTest();
        System.assertEquals(SIZE_THREE , casesToConsider.size() , SIZE_THREE+' Cases should have been returned');
        Set<Id> actualCaseIds = new Set<Id>();
        for(Case theCase : casesToConsider)
        {
            actualCaseIds.add(theCase.Id);
        }

        System.assert(expectedCaseIds.containsAll(actualCaseIds) , 'All Right cases should have been returned');
        System.assert(actualCaseIds.containsAll(expectedCaseIds) , 'All Right cases should have been returned');
    }
    
    static testMethod void testPopulateOrderInformation_ByProcessingNumber()
    {
        setupData();

        NextPadService theService = new NextPadService();

        Test.startTest();
            theService.populateOrderInformation(USER_ORDER_ID , null);
        Test.stopTest();

        System.assertEquals(testOrder.Id , theService.orderId , 'Right order Id should have been populated');
        System.assertEquals(ORDER_NUMBER , theService.orderNumber , 'Right Order Number should have been populated');
    }

    static testMethod void testPopulateOrderInformation_ByOrderItemId()
    {
        setupData();

        NextPadService theService = new NextPadService();

        Test.startTest();
            theService.populateOrderInformation(null , testOrderItem.Id);
        Test.stopTest();

        System.assertEquals(testOrder.Id , theService.orderId , 'Right order Id should have been populated');
        System.assertEquals(ORDER_NUMBER , theService.orderNumber , 'Right Order Number should have been populated');
    }

    static testMethod void testNoteTypesPopulated()
    {
        NextPadService theService = new NextPadService();
        Test.startTest();
            System.assertEquals(2 , theService.noteTypes.size() , '2 entries should have been there');
        Test.stopTest();

    } 
    
    static testMethod void testPopulateAllInformationBySameProcessingNumberMultipleOrders()
    {
        setupData();

        //second Order with Same Processing Number.Revisions has different Customer Order With Same Processing Number
        Order__c anotherOrder = TestUtils.createOrders(SIZE_ONE, null , false)[0];
        anotherOrder.OrderID__c = '666777888';
        anotherOrder.Contact_Name__c = 'Joe Montana';
        anotherOrder.Contact_State__c = 'CA';
        insert anotherOrder;
        

        OrdeR_Item__c anotherOrderItem = TestUtils.createOrderItems(SIZE_ONE , testOrder.Id ,  false)[0];
        anotherOrderItem.User_Order_ID__c = USER_ORDER_ID;
        anotherOrderItem.Product__c = testProduct.Id;
        insert anotherOrderItem;

        List<Task> orderNotes = TestUtils.createTasks(5 , anotherOrder.Id , true); // Create 5 Order Note for anotherOrder
        List<Case> casesWithProcessingNumbers = TestUtils.createCases( SIZE_THREE , false);
        for(Case theCase : casesWithProcessingNumbers) //Create Some Case for the Processing Number
        {
            theCase.Processing_Number__c = USER_ORDER_ID;
        }
        insert casesWithProcessingNumbers;
        Set<Id> expectedIds = new Set<Id>();
        for(Case theCase : testCases)
        {
            expectedIds.add(theCase.Id);
        }
        for(Case theCase : casesWithProcessingNumbers)
        {
            expectedIds.add(theCase.Id);
        }



        NextPadService theNextPadService = new NextPadService();
        Test.startTest();
            theNextPadService.populateAllInformationByProcessingNumber(USER_ORDER_ID , null);
        Test.stopTest();

        System.assertEquals(SIZE_THREE*2 ,  theNextPadService.noteWrappers.size() , SIZE_THREE*2 +' 6 cases from first Order and 3 Case from anotherOrder');
        
        Set<Id> actualObjectIds = new Set<Id>();
        for(NoteWrapper theWrapper : theNextPadService.noteWrappers)
        {
            actualObjectIds.add(theWrapper.id);
        }
        System.assert(expectedIds.containsAll(actualObjectIds) , 'All right Ids should have been present');
        System.assert(actualObjectIds.containsAll(expectedIds) , 'All right Ids should have been present');

    }
}