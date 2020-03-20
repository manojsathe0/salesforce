/*
	Created by: Artyom M.
	Per story: B-28448
*/
@isTest
public class OrderExceptionOwnerChangeBatchTest {
	static Order_Exception__c newExc;
	static Product2 testProduct;
	final static String PRODUCT_LINE = 'Intellectual Property';
	static Id relationshipTypeId;
	static Product_Line__c testProductLine;
	static void setup() {
		Group grp = new Group(Name = 'Order Due 3',  DeveloperName = 'Dev',  Type = 'Queue');
		insert grp;
		QueueSobject mappingObject  = new QueueSobject(QueueId = grp.Id,  SobjectType = 'Order_Exception__c');
		System.runAs(TestUtils.ADMIN_USER) {
			insert mappingObject;
		}
		
		Process__c testProcess = TestUtils.createProcesses(1, 'Test', true)[0];
		
		testProduct = TestUtils.createProducts(1 , 'Test Product', false)[0];
        testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
        testProductLine.Name = PRODUCT_LINE;
        insert testProductLine;
        
        relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
        testProduct.Product_Line__c = testProductLine.Id;
        testProduct.Relationship_Type__c = relationshipTypeId;
        testProduct.Process__c = testProcess.Id;
        insert testProduct; 
		
		
		
		Order__c testOrder = TestUtils.createOrders(1 , testProduct.Id , true)[0];
        newExc = new Order_Exception__c();
        newExc.Order_Number__c = testOrder.Id;
        newExc.Due_Date__c = System.now().addDays(3);
        newExc.OwnerId = grp.Id;
        insert newExc;
        
	}
	static testMethod void testBatch() {
		OrderExceptionOwnerChangeBatchSchedule bch = new OrderExceptionOwnerChangeBatchSchedule();
	    String cron = '0 0 9-17 ? * MON-FRI';
	    String jobId = System.schedule('OrderExceptionOwnerChangeBatchSchedule', cron, bch);
	}
	static testMethod void testBatch2() {
		setup();
		OrderExceptionOwnerChangeBatch bch = new OrderExceptionOwnerChangeBatch();
		Id batchId = Database.executeBatch(bch);
	}
	
	static testMethod void orderExceptionQueueAssignmentByIdTest() {
		setup();
		Id id = newExc.Id;
		List<Id> lst = new List<Id>();
		lst.add(id);
		OrderExceptionOwnerChangeBatch.orderExceptionQueueAssignmentById(lst);
	}
	
    
}