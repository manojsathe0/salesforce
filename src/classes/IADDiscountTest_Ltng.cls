/*
 * Created by Artyom M.
 * Story: B-25190	
 */

@isTest
public class IADDiscountTest_Ltng {
	public static String orderId{get;set;}
	public static String discountAmount{get;set;}
	public static String comments{get;set;}
	public static String discountReasonStr{get;set;}
	public static String responseBody{get;set;}
    private static user u; // STORY B-41395
	
	public static void setup() {
		responseBody = '{ "orderDiscount": { "orderDiscountId": 0, "orderItemId": 0, "orderId": 0, "discountType": "unset", "valueAmount": 0, "memberGroupCode": 0, "customDiscountId": 0, "userDiscountLogId": 0, "comments": "string", "cancelled": true, "discountId": 0, "dateCreated": "2016-12-06T05:22:13.615Z", "createdBy": "string", "dateLastModified": "2016-12-06T05:22:13.615Z", "lastModifiedBy": "string" } }';
		orderId = '32564085';
		discountAmount = '10.5';
		comments = 'Test Comment';
		discountReasonStr = IADDiscountController_Ltng.discountReasonMap.get(1);
        // STORY B-41395 - Starts Here
        u = TestUtils.createUser('adminuser' + DateTime.now().getTime(), [SELECT Id FROM Profile WHERE Name ='SYStem Administrator' LIMIT 1].Id,true);
        // STORY B-41395 - Ends Here
	}
	
	static testMethod void testApplyOrderDiscount() {
		setup();
		IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = responseBody;
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        
        IADDiscountController_Ltng.applyOrderDiscount(orderId, discountAmount, comments, 1,'test');
		
	}
    
    static testMethod void testApplyOrderDiscountFail() {
		setup();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = responseBody;
        mock.statusCode=600;
        Test.setMock(HttpCalloutMock.class, mock);
	
        IADDiscountController_Ltng.applyOrderDiscount(orderId, discountAmount, comments, 1, 'test');
		
	}
    static testMethod void testApplyOrderDiscountFail2() {
		setup();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = responseBody;
        mock.statusCode=600;
        Test.setMock(HttpCalloutMock.class, mock);
	
        IADDiscountController_Ltng.applyOrderDiscount(null, null, comments, 1, 'test');
		
	}
	 static testMethod void testCancelDiscount() {
	 	setup();
	 	IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = responseBody;
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
         
        IADDiscountController_Ltng.cancelDiscount(orderId, '100');
	 }
	 
    
    static testMethod void testCancelDiscountFail() {
	 	setup();
	 	IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = responseBody;
        mock.statusCode=600;
        Test.setMock(HttpCalloutMock.class, mock);
        
        IADDiscountController_Ltng.cancelDiscount(orderId, '100');
	 }
    static testMethod void testCancelDiscountFail2() {
	 	setup();
	 	IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = responseBody;
        mock.statusCode=600;
        Test.setMock(HttpCalloutMock.class, mock);
        
        IADDiscountController_Ltng.cancelDiscount(null, '100');
	 }
	 static testMethod void testGetExistingDiscounts() {
	 	setup();
         
	 	IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = responseBody;
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
         
        IADDiscountController_Ltng.getExistingDiscounts(orderId);
	 } 
    static testMethod void testGetExistingDiscountsFail() {
	 	setup();
         
	 	IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = responseBody;
        mock.statusCode=600;
        Test.setMock(HttpCalloutMock.class, mock);
         
        IADDiscountController_Ltng.getExistingDiscounts(orderId);
	 } 
    static testMethod void testGetExistingDiscountsFail2() {
	 	setup();
         
	 	IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = responseBody;
        mock.statusCode=600;
        Test.setMock(HttpCalloutMock.class, mock);
         
        IADDiscountController_Ltng.getExistingDiscounts(null);
	 } 
	 
    // STORY B-41395 -Coommented
    /*
	 static testMethod void testManagerCredentials() {
        IADDiscountController_Ltng.isValidateManagerCredential('test', 'test');
     } 
    */
    // STORY B-41395 - Starts Here
    static testMethod void testManagerCredentials1() {
        setup();
        boolean response = false;
        system.runAs(u){
            Test.startTest();
            	// Insert Test Record on Manager_Credential__c Obj.
            	insert new Manager_Credential__c(User__c = UserInfo.getUserId(), Password__c ='test');
            	response = IADDiscountController_Ltng.isValidateManagerCredential(UserInfo.getUserEmail().substring(0,UserInfo.getUserEmail().indexOf('@')), 'test');
            Test.stopTest();
            system.assert(response);
        }
    } 
    static testMethod void testManagerCredentials2() {
        setup();
        boolean response = false;
        system.runAs(u){
            Test.startTest();
            	response = IADDiscountController_Ltng.isValidateManagerCredential(UserInfo.getUserEmail().substring(0,UserInfo.getUserEmail().indexOf('@')), 'test');
            Test.stopTest();
            system.assert(!response);
        }
    }
    static testMethod void testManagerCredentials3() {
        setup();
        boolean response = false;
        system.runAs(u){
            Test.startTest();
            	response = IADDiscountController_Ltng.isValidateManagerCredential('', '');
            Test.stopTest();
            system.assert(!response);
        }
    }
    // STORY B-41395 - Ends Here
}