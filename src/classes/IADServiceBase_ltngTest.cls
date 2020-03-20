@isTest
public with sharing class IADServiceBase_ltngTest{
	
	static testMethod void testPopulateErrorMessage()
	{
		IADServiceBase_ltng theBase = new IADServiceBase_ltng();
		Test.startTest();
			IADServiceBase_ltng.populateErrorMessage(new APIRequestResponseWrapper_ltng());
		Test.stopTest();
	}

	static testMethod void testPopulateNullErrorMessage()
	{
		IADServiceBase_ltng theBase = new IADServiceBase_ltng();
		Test.startTest();
			IADServiceBase_ltng.populateErrorMessage(new APIRequestResponseWrapper_ltng());
	    Test.stopTest();
	}

	static testMethod void testGetAPIToWrapper()
	{
		IADServiceBase_ltng theBase = new IADServiceBase_ltng();
		Test.startTest();
			Map<String, APIRequestResponseWrapper_ltng> theMap = theBase.getAPItoWrapper();
			//System.assert(theMap != null , 'Should not be null');
		Test.stopTest();
	} 

	static testMethod void testgetAPIToEndPoint()
	{
		IADServiceBase_ltng theBase = new IADServiceBase_ltng();
		Test.startTest();
			Map<String,IADApiGeeEndPoint__mdt> theMap = theBase.getAPItoEndpoint();
			//System.assert(theMap != null , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testAPIToAsync()
	{
		IADServiceBase_ltng theBase = new IADServiceBase_ltng();
		Test.startTest();
			Map<String,Boolean> theMap = theBase.getAPItoAsync();
			//System.assert(theMap != null , 'Should not be null');
		Test.stopTest();
	}

	static testMethod void testgetIAdMessages()
	{
		IADServiceBase_ltng theBase = new IADServiceBase_ltng();
		Test.startTest();
			List<IADMessage_ltng> theList = theBase.getIadMessages();
			//System.assert(theList != null , 'Should not be null');
		Test.stopTest();
	}
}