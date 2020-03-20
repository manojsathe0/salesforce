@isTest
private class ExternalEndpointServiceTest
{
	final static String CONTACT_API_PROD = 'http://www.legalzoom.com/lzweb/api/1.0/';
	final static String CONTACT_API_QA = 'http://wwwqa.legalzoom.com/lzweb/api/1.0/';
	final static String NOTEPAD_URL_PROD = 'http://lzsuite/OrderManager/Dialog/DialogNotepadControl.asp';
	final static String NOTEPAD_URL_QA = 'http://qa-lzsuite/OrderManager/Dialog/DialogNotepadControl.asp';
	
	static void setupData()
	{
		External_Endpoint__c prodEndPoint = new External_Endpoint__c();
		prodEndPoint.Name = 'com';
		prodEndPoint.Api_Endpoint_URL__c = CONTACT_API_PROD;
		prodEndPoint.Notepad_URL__c = NOTEPAD_URL_PROD;

		External_Endpoint__c qaEndPoint = new External_Endpoint__c();
		qaEndPoint.Name = 'review';
		qaEndPoint.Api_Endpoint_URL__c = CONTACT_API_QA;
		qaEndPoint.Notepad_URL__c = NOTEPAD_URL_QA;

		insert new List<External_Endpoint__c>{prodEndPoint , qaEndPoint};

	}

	static testMethod void testGetEndpointURLForProd()
	{
		setupData();
		User prodUser = TestUtils.createUser('Buffet' ,  TestUtils.STANDARD_PROFILE_ID , false);
		prodUser.Username = 'jason@legalzoom.com';
		External_Endpoint__c theEndPoint;
		System.runAs(prodUser)
		{
			Test.startTest();
				theEndPoint = ExternalEndpointService.getEndpointCustomSetting();
			Test.stopTest();
		}
		System.assertEquals('com' , theEndPoint.Name , 'Right environment value should have been returned');
	}


	static testMethod void testGetEndpointURLForReview()
	{
		setupData();
		User reviewUser = TestUtils.createUser('Buffet' ,  TestUtils.STANDARD_PROFILE_ID , false);
		reviewUser.Username = 'jason@legalzoom.com.review';
		External_Endpoint__c theEndPoint;
		System.runAs(reviewUser)
		{
			Test.startTest();
				theEndPoint = ExternalEndpointService.getEndpointCustomSetting();
			Test.stopTest();
		}

		System.assertEquals('review' , theEndPoint.Name , 'Right environment value should have been returned');
	}
}