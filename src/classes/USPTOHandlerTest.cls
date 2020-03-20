@isTest
private class USPTOHandlerTest
{
	
	static Case testCase;
	static Order__c testOrder;

	static final Integer SIZE = 1;
	static Account testAccount;
	static Contact testContact;
	static void setupData()
	{
		testCase = TestUtils.createCases(SIZE , false)[0];
		testCase.Queue__c = USPTOHandlerHelper.TM_FILING;
		insert testCase;

		testAccount = TestUtils.createAccounts(SIZE, 'Test Account', true)[0];
		testContact = TestUtils.createContacts(SIZE , 'Buffet', testAccount.Id , false)[0];
		testContact.Contact_Type__c = 'Primary Contact';

		insert testContact;

		testOrder = TestUtils.createOrders(SIZE , null , false)[0];
		testOrder.Account__c = testAccount.Id;

		testOrder.OrderID__c = '1';
		testOrder.User_Order_ID__c = USPTOEmailParserTest.USER_ORDER_ID; 
		testOrder.Contact_Name__c = 'Jimmy Buffet';
		testOrder.Contact_Email__c = 'testxx123@textd.tt';
		testOrder.Contact__c = testContact.Id;
		insert testOrder;
	}
	
	static testMethod void test_processFirstUSPTOEmail()
	{
		setupData();
		EmailMessage firstEmailMessage = TestUtils.createEmailMessages(SIZE, testCase.Id , false)[0];
		firstEmailMessage.textBody = USPTOEmailParserTest.firstEmailBody;
		firstEmailMessage.subject = USPTOEmailParserTest.firstEmailSubject;
		firstEmailMessage.FromAddress = 'TEAS@uspto.gov';

		Test.startTest();
			insert firstEmailMessage;
		Test.stopTest();
		
		List<Case> updatedCase = [SELECT Id , AccountId , ContactId , Processing_Number__c, App_Stage__c , Status , USPTO_Id__c , Is_Updated_By_USPTO__c , Trademark_Name__c    FROM Case WHERE Id = :testCase.Id];
		System.assertEquals(SIZE , updatedCase.size() , '1 case should have been returned');
		System.assertEquals(USPTOEmailParserTest.USER_ORDER_ID , updatedCase[0].Processing_Number__c , 'User order number should have been '+USPTOEmailParserTest.USER_ORDER_ID);
		System.assertEquals(USPTOHandler.SENT_TO_CUSTOMER , updatedCase[0].App_Stage__c , 'App Stage should have been '+USPTOHandler.SENT_TO_CUSTOMER);
		System.assertEquals(USPTOHandler.OPEN , updatedCase[0].Status , 'Status should have been '+USPTOHandler.OPEN);
		System.assertEquals(USPTOEmailParserTest.USPTOId , updatedCase[0].USPTO_Id__c , 'USPTO Id Should have been '+USPTOEmailParserTest.USPTOId);
		System.assertEquals(true , updatedCase[0].Is_Updated_By_USPTO__c , 'Is Updated by USPTO should have been True');
		System.assertEquals(USPTOEmailParserTest.TRADEMARK_NAME , updatedCase[0].Trademark_Name__c , 'Trademarkname should have been '+USPTOEmailParserTest.TRADEMARK_NAME);
		System.assertEquals(testContact.Id , updatedCase[0].ContactId , 'Correct Contact Id should have been populated '+testContact.Id );


	}
	
	static testMethod void test_processSecondUSPTOEmail()
	{
		setupData();
		testCase.USPTO_Id__c = USPTOEmailParserTest.USPTOId;
		update testCase;

		Case newCase = TestUtils.createCases(SIZE , false)[0];
		newCase.Queue__c = USPTOHandlerHelper.TM_FILING;
		insert newCase;

		EmailMessage secondEmailMessage = TestUtils.createEmailMessages(SIZE, newCase.Id , false)[0];
		secondEmailMessage.textBody = USPTOEmailParserTest.secondEmailBody;
		secondEmailMessage.subject = USPTOEmailParserTest.secondEmailSubject;
		secondEmailMessage.FromAddress = 'TEAS@uspto.gov';

		Test.startTest();
			insert secondEmailMessage;
		Test.stopTest();
		
		List<Case> deletedCase = [SELECT Id FROM Case WHERE Id = :newCase.Id];
		System.assert(deletedCase.isEmpty() , 'New case should have been deleted');

		List<Case> updatedCase = [SELECT Id , App_Stage__c , Is_Updated_By_USPTO__c FROM Case WHERE Id = :testCase.Id];
		System.assertEquals(SIZE , updatedCase.size() , '1 case should have been returned');
		
		System.assertEquals(USPTOHandler.SIG_RECEIVED , updatedCase[0].App_Stage__c , 'App Stage should have been '+USPTOHandler.SENT_TO_CUSTOMER);
		System.assertEquals(true , updatedCase[0].Is_Updated_By_USPTO__c , 'Is Updated by USPTO should have been True');

		List<EmailMessage> theEmailMessage =  [SELECT Id , ParentId FROM EMailMessage];
		System.assertEquals(1 , theEmailMessage.size() , 'There should be only 1 Email Message');
		System.assertEquals(testCase.Id , theEmailMessage[0].ParentId , 'Email Message should have been tied to Old case with Correct USPTOId as new Case is deleted.');
	}
	
	static testMethod void test_processThirdUSPTOEmail()
	{
		setupData();
		testCase.USPTO_Id__c = USPTOEmailParserTest.USPTOId;
		testCase.Trademark_Name__c = USPTOEmailParserTest.TRADEMARK_NAME;
		update testCase;

		Case newCase = TestUtils.createCases(SIZE , false)[0];
		newCase.Queue__c = USPTOHandlerHelper.TM_FILING;
		insert newCase;

		EmailMessage thirdEmailMessage = TestUtils.createEmailMessages(SIZE, newCase.Id , false)[0];
		thirdEmailMessage.textBody = USPTOEmailParserTest.thirdEmailBody;
		thirdEmailMessage.subject = USPTOEmailParserTest.thirdEmailSubject;
		thirdEmailMessage.FromAddress = 'TEAS@uspto.gov';

		Test.startTest();
			insert thirdEmailMessage;
		Test.stopTest();
		
		List<Case> deletedCase = [SELECT Id FROM Case WHERE Id = :newCase.Id];
		System.assert(deletedCase.isEmpty() , 'New case should have been deleted');

		List<Case> updatedCase = [SELECT Id ,USPTO_Serial_Number__c , App_Stage__c , Is_Updated_By_USPTO__c  FROM Case WHERE Id = :testCase.Id];
		System.assertEquals(SIZE , updatedCase.size() , '1 case should have been returned');
		
		System.assertEquals(USPTOEmailParserTest.SERIAL_NUMBER , updatedCase[0].USPTO_Serial_Number__c , 'Serial number should have been populated '+USPTOEmailParserTest.SERIAL_NUMBER);
		System.assertEquals(USPTOHandler.USPTO_PAID , updatedCase[0].App_Stage__c , 'App Stage should have been '+USPTOHandler.USPTO_PAID);
		System.assertEquals(true , updatedCase[0].Is_Updated_By_USPTO__c , 'Is Updated by USPTO should have been True');

		List<EmailMessage> theEmailMessage =  [SELECT Id , ParentId FROM EMailMessage];
		System.assertEquals(1 , theEmailMessage.size() , 'There should be only 1 Email Message');
		System.assertEquals(testCase.Id , theEmailMessage[0].ParentId , 'Email Message should have been tied to Old case with Correct USPTOId as new Case is deleted.');
	
	}
	
	

}