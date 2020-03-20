@isTest
public with sharing class CreateLoginAccountControllerTest_Ltng {
	@isTest
	static void testCreateAccount() {
		String testEmail = 'test@test.com';
		IADTestMockGenerator mock = new IADTestMockGenerator();
		mock.statusCode=200;
		mock.testBody = '{    "message": "Success",    "customerId": 11631589,    "uuid": "33d08ebc-b285-4a94-b4de-2de604042e23"}';
		Test.setMock(HttpCalloutMock.class, mock);
		CreateLoginAccountController_Ltng.createAccount(testEmail);	
	}
	 
}