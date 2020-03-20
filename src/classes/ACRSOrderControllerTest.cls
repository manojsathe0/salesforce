@isTest
public class ACRSOrderControllerTest {
	
	static Account testAccount;
	static List<Order__c> testOrders;
	final static String PRODUCT_LINE = 'Test ProductLine';
	static Id relationshipTypeId;
	
	static void setupData()
	{
		Product2 testProduct = TestUtils.createProducts( 1 , '', false)[0];
		testProduct.Name = 'Business Advantage Pro Attorney Consultation';
		Product_Line__c testProductLine = TestUtils.createProductLines(1 , PRODUCT_LINE , false)[0];
		testProductLine.Name = PRODUCT_LINE;
		insert testProductLine;
		relationshipTypeId = TestUtils.createRelationshipTypesTypes(1 , 'Process', true)[0].Id;
		testProduct.Product_Line__c = testProductLine.Id;
		testProduct.Relationship_Type__c = relationshipTypeId;
		insert testProduct;
		
		testAccount = TestUtils.createAccounts( 1 , 'Test Account ', true)[0];
		testOrders = TestUtils.createOrders( 2 , testProduct.Id, false);
		testOrders[0].Account__c = testAccount.Id;
		testOrders[1].Account__c = testAccount.Id;
		
		insert testOrders;
	
	}
	static testMethod void testAcrsOrdersPopulated()
	{
		setupData();
		PageReference pageRef = Page.ACRSOrder;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        Test.startTest();
        	  ACRSOrderController theController = new ACRSOrderController(sc);
        Test.stopTest();
		System.assertEquals(2 , theController.acrsOrders.size() , '2 orders should have been populated on acrsOrder list');
	}
}