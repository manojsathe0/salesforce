@isTest
private class USPTOHandlerHelperTest
{
	static List<Case> testCases;
	static List<Order__c> testOrders;
	static final Integer SIZE = 5;
	static List<Account> testAccounts;
	static List<Contact> testContacts;
	
	static
	{
		testContacts = new List<Contact>();
	}

	static void setupData()
	{
		testCases = TestUtils.createCases(5 , true);
		testOrders = TestUtils.createOrders(SIZE , null , false);
		
		testAccounts = TestUtils.createAccounts(SIZE , 'Test Account', true);
		for(Account acc : testAccounts)
		{

			Contact theContact = TestUtils.createContacts(1, 'Test Contact', acc.Id , false)[0];
			testContacts.add(theContact);
		}
		insert testContacts;
		for(Integer i = 0 ; i<SIZE ; ++i)
		{

			testOrders[i].OrderID__c = i+'';
			testOrders[i].User_Order_ID__c = i+'';
			testOrders[i].Contact__c = testContacts[i].Id;
			testOrders[i].Contact_Email__c = 'testxxftfd@testsd212s.dtd';
			testOrders[i].Contact_Name__c = 'Jimmy Buffet';
		}

		insert testOrders;
	}

	static testMethod void test_getUserOrderNumberToContact()
	{
		setupData();
		Set<String> userOrderNumbers = new Set<String>();
		Map<String,Order__c> userOrderNumberToOrder = new Map<String,Order__c>();
		for(Order__c theOrder : testOrders)
		{
			userOrderNumbers.add(theOrder.User_Order_ID__c);
			userOrderNumberToOrder.put(theOrder.User_Order_ID__c , theOrder);
		}
		Map<String,Id> expectedUserOrderNumberToContactId = new Map<String,Id>();
		for(Integer i = 0 ; i<SIZE ;++i)
		{
			expectedUserOrderNumberToContactId.put(testOrders[i].User_Order_ID__c , testContacts[i].Id);
		}

		USPTOHandlerHelper theHandlerHelper = new USPTOHandlerHelper();

		Test.startTest();
			Map<String,Id> userOrderNumberToContact = theHandlerHelper.getUserOrderNumberToContact(userOrderNumbers, userOrderNumberToOrder);
		Test.stopTest();

		System.assertEquals(SIZE , userOrderNumberToContact.size() ,'Map should have 5 elements');
		System.assert(userOrderNumberToContact.keySet().containsAll(userOrderNumbers) , 'All User Order numbers should have been present in Map');

		for(String userOrderNumber : userOrderNumberToContact.keySet())
		{
			Id actualContactId = userOrderNumberToContact.get(userOrderNumber);
			Id expectedContactId = expectedUserOrderNumberToContactId.get(userOrderNumber);

			System.assertEquals(expectedContactId , actualContactId , 'Contact Id should match');
			
		}

		
	}

	
	static testMethod void test_SendEmailToCustomer()
	{
		setupData();
		Map<String,Order__c> userOrderNumberToOrder = new Map<String,Order__c>();
		
		userOrderNumberToOrder.put(testOrders[0].User_Order_ID__c , testOrders[0]);
		

		USPTOHandlerHelper theHandlerHelper = new USPTOHandlerHelper();

		USPTOEmailWrapper theEmailWrapper = new USPTOEmailWrapper();
		theEmailWrapper.USPTOUniqueId = '2433434343xcxcxcxcx';

		Map<String,USPTOEmailWrapper> userOrderNumberToFirstUSPTOEmailWrappers = new Map<String,USPTOEmailWrapper>();
		userOrderNumberToFirstUSPTOEmailWrappers.put(testOrders[0].User_Order_ID__c , theEmailWrapper);

		Test.startTest();
			Map<String,Boolean> userOrderNumberToDeliveryStatus = theHandlerHelper.sendEmailToCustomer(userOrderNumberToOrder, userOrderNumberToFirstUSPTOEmailWrappers);
		Test.stopTest();

		System.assertEquals(1 , userOrderNumberToDeliveryStatus.size() , '1 element should have been there in Map');

	}

	static testMethod void test_getUSPTOEmailMessages()
	{
		setupData();
		testCases[0].Queue__c = USPTOHandlerHelper.TM_FILING;
		testCases[0].Origin = 'tmfiling@legalzoom.com';

		update testCases[0];
	
		List<EmailMessage> testUSPTOEmailMessages = TestUtils.createEmailMessages(SIZE , testCases[0].Id , true);
		List<EmailMessage> testNonUSPTOEmailMessages = TestUtils.createEmailMessages(SIZE , testCases[1].Id , true);

		USPTOHandlerHelper theHandlerHelper = new USPTOHandlerHelper();
		List<EmailMessage> allEmailMessages = new List<EmailMessage>();

		allEmailMessages.addAll(testUSPTOEmailMessages);
		allEmailMessages.addAll(testNonUSPTOEmailMessages);

		Test.startTest();
			List<EmailMessage> emailMessagesToConsider = theHandlerHelper.getUSPTOEmailMessages(new Map<Id,EmailMessage>(allEmailMessages));
		Test.stopTest();

		System.assertEquals(SIZE , emailMessagesToConsider.size() , '5 Emails should have been returned');
	}

	static testMethod void test_getExistingUSPTOUniqueIdToCase()
	{
		setupData();
		Set<String> usptoUniqueIds = new Set<String>();
		for(Integer i = 0 ; i< SIZE ; ++i)
		{
			testCases[i].USPTO_Id__c = i+'';
			usptoUniqueIds.add(i+'');
		}

		update testCases;

		USPTOHandlerHelper theHandlerHelper = new USPTOHandlerHelper();
		Test.startTest();
			Map<String,Case> usptoIdToOneCase = theHandlerHelper.getExistingUSPTOUniqueIdToCase(usptoUniqueIds);
		Test.stopTest();

		System.assertEquals(SIZE , usptoIdToOneCase.size() , 'Map should have 5 elements');
	}

	static testMethod void test_getExistingTrademarkNameToCase()
	{
		setupData();
		Set<String> usptoUniqueIds = new Set<String>();
		Set<String> trademarkNames = new Set<String>();
		for(Integer i = 0 ; i< SIZE ; ++i)
		{
			testCases[i].USPTO_Id__c = i+'';
			testCases[i].Trademark_Name__c = 'My Trademark'+i;
			trademarkNames.add('My Trademark'+i);
		}

		update testCases;

		USPTOHandlerHelper theHandlerHelper = new USPTOHandlerHelper();
		Test.startTest();
			Map<String,Case> trademarkNameToOneCase = theHandlerHelper.getExistingTrademarkNameToCase(trademarkNames);
		Test.stopTest();

		System.assertEquals(SIZE , trademarkNameToOneCase.size() , 'Map should have 5 elements');
	}

	
}