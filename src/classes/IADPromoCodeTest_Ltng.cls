/*
 * Created by Artyom M.
 * Story: B-25189
 */

@isTest
public class IADPromoCodeTest_Ltng {
	public static String orderId{get;set;}
	public static String promoCode{get;set;}
	public static String comments{get;set;}
	public static String responseBody{get;set;}
	public static void setup() {
        responseBody = '{"orderDiscount": { "orderDiscountId": 0, "orderItemId": 0, "orderId": 0, "discountType": "unset", "valueAmount": 0, "memberGroupCode": 0, "customDiscountId": 0, "userDiscountLogId": 0, "comments": "string", "cancelled": false, "discountId": 0, "dateCreated": "2016-12-06T05:22:13.676Z", "createdBy": "string", "dateLastModified": "2016-12-06T05:22:13.676Z", "lastModifiedBy": "string"}}';
		orderId = '32564085';
		promoCode = '100';
		comments = 'Test Comment';


				
	}
	
	static testMethod void testApplyPromoCode() {
		setup();
		Test.setMock(HttpCalloutMock.class, new IADTestMockGenerator());
		HttpResponse response = new HttpResponse();
		response.setBody(responseBody);
        response.setStatusCode(200);
        
        IADPromoCodeController_Ltng.applyPromoCode(orderId, promoCode, comments);
	}
    static testMethod void testApplyPromoCodeFail() {
        
		setup();
        IADOrderWithOrderItemsController_ltng ctrlref = new IADOrderWithOrderItemsController_ltng();
        IADPromoCodeController_Ltng.ctrlRef=ctrlref;
		Test.setMock(HttpCalloutMock.class, new IADTestMockGenerator());
		HttpResponse response = new HttpResponse();
        //response.setBody('null');
        response.setStatusCode(4000);
        
        IADPromoCodeController_Ltng.applyPromoCode(null, null, null);
	}
	
	static testMethod void testCancelPromoCode() {
		setup();
		Test.setMock(HttpCalloutMock.class, new IADTestMockGenerator());
		HttpResponse response = new HttpResponse();
		responseBody = '{"isValid": true, "promoCode": "string", "discountAmount": 0}';//'{"orderDiscount": { "orderDiscountId": 0, "orderItemId": 0, "orderId": 0, "discountType": "unset", "valueAmount": 0, "memberGroupCode": 0, "customDiscountId": 0, "userDiscountLogId": 0, "comments": "string", "cancelled": true, "discountId": 0, "dateCreated": "2016-12-06T05:22:13.676Z", "createdBy": "string", "dateLastModified": "2016-12-06T05:22:13.676Z", "lastModifiedBy": "string"}';
		response.setBody(responseBody);
        response.setStatusCode(200);
        
        IADPromoCodeController_Ltng.cancelPromoCode(orderId, promoCode);
	}
	static testMethod void testCancelPromoCodeFail() {
		setup();
		Test.setMock(HttpCalloutMock.class, new IADTestMockGenerator());
		HttpResponse response = new HttpResponse();
		responseBody = '{"isValid": true, "promoCode": "string", "discountAmount": 0}';//'{"orderDiscount": { "orderDiscountId": 0, "orderItemId": 0, "orderId": 0, "discountType": "unset", "valueAmount": 0, "memberGroupCode": 0, "customDiscountId": 0, "userDiscountLogId": 0, "comments": "string", "cancelled": true, "discountId": 0, "dateCreated": "2016-12-06T05:22:13.676Z", "createdBy": "string", "dateLastModified": "2016-12-06T05:22:13.676Z", "lastModifiedBy": "string"}';
		response.setBody(responseBody);
        response.setStatusCode(200);
        
        IADPromoCodeController_Ltng.cancelPromoCode(null, null);
	}
    
	static testMethod void testCheckPromoCode() {
		setup();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{"isValid": true, "promoCode": "string", "discountAmount": 0}';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        
        IADPromoCodeController_Ltng.checkPromoCode(orderId, promoCode);
	}
    
    static testMethod void testCheckPromoCodeFail() {
		setup();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '!{"isValid": true, "promoCode": "string", "discountAmount": 0}';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        
        IADPromoCodeController_Ltng.checkPromoCode(orderId, promoCode);
	}
    static testMethod void testCheckPromoCodeFail2() {
		setup();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '!{"isValid": true, "promoCode": "string", "discountAmount": 0}';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);
        
        IADPromoCodeController_Ltng.checkPromoCode(null, null);
	}
	static testMethod void testDisplayPromoCode() {
		setup();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{	"orderId": "orderId",	"orderPromoCodes": [{		"code": "code",		"amount": 0,	  	"isCancelled": false	}]}';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);

        
        IADPromoCodeController_Ltng.displayPromoCode(orderId);
	}
    static testMethod void testDisplayPromoCodeFail() {
		setup();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '!{	"orderId": "orderId",	"orderPromoCodes": [{		"code": "code",		"amount": 0,	  	"isCancelled": false	}]}';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);

        
        IADPromoCodeController_Ltng.displayPromoCode(orderId);
	}
    static testMethod void testDisplayPromoCodeFail2() {
		setup();
        IADTestMockGenerator mock = new IADTestMockGenerator();
        mock.testBody = '{	"orderId": "orderId",	"orderPromoCodes": [{		"code": "code",		"amount": 0,	  	"isCancelled": false	}]}';
        mock.statusCode=200;
        Test.setMock(HttpCalloutMock.class, mock);

        
        IADPromoCodeController_Ltng.displayPromoCode(null);
	}
    
}