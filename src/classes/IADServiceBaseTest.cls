@isTest
public with sharing class IADServiceBaseTest {
	
	static testMethod void testPopulateErrorMessage()
	{
		IADServiceBase theBase = new IADServiceBase();
		Test.startTest();
			theBase.populateErrorMessage(new APIRequestResponseWrapper());
		Test.stopTest();
	}

	static testMethod void testPopulateNullErrorMessage()
	{
		IADServiceBase theBase = new IADServiceBase();
		Test.startTest();
			theBase.populateErrorMessage(new APIRequestResponseWrapper());
	    Test.stopTest();
	}

	static testMethod void testGetAPIToWrapper()
	{
		IADServiceBase theBase = new IADServiceBase();
		Test.startTest();
			Map<String, APIRequestResponseWrapper> theMap = theBase.getAPItoWrapper();
			System.assert(theMap != null , 'Should not be null');
		Test.stopTest();
	} 

	static testMethod void testgetAPIToEndPoint()
	{
		IADServiceBase theBase = new IADServiceBase();
		Test.startTest();
			Map<String,IADApiGeeEndPoint__mdt> theMap = theBase.getAPItoEndpoint();
			System.assert(theMap != null , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testAPIToAsync()
	{
		IADServiceBase theBase = new IADServiceBase();
		Test.startTest();
			Map<String,Boolean> theMap = theBase.getAPItoAsync();
			System.assert(theMap != null , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testgetIAdMessages()
	{
		IADServiceBase theBase = new IADServiceBase();
		Test.startTest();
			List<IADMessage> theList = theBase.getIadMessages();
			System.assert(theList != null , 'Should not be null');
		Test.stopTest();
	}
}