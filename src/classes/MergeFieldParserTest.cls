@isTest 
public with sharing class MergeFieldParserTest 
{
	static Case testCase;
	static Contact testContact;
	static Account testAccount;
	static final Integer SIZE = 1;
	static final String ID = 'id';
	static final String CUSTOM_EMAIL_ID = 'customemailid';
	static final String OBJECT_NAME = 'objectName';
	static final String OPTION = 'option';
	
	static void setupData()
	{
		testAccount = TestUtils.createAccounts(SIZE , 'Test Account', true)[0];
		testContact = TestUtils.createContacts( SIZE ,  'Buffet ', testAccount.Id , true)[0];
		testCase = TestUtils.createCases( SIZE, false)[0];
		testCase.ContactId = testContact.Id;
		testCase.Email_Subject__c  = 'Test Subject';
		insert testCase;
	}
	
	static testMEthod void testParseMergeFields()
	{
		setupData();
		String emailBody = 'Thsi is test email template';
		Test.startTest();
			String parsedValue = MergeFieldParser.parseMergeFields(emailBody, testCase.Id);
		Test.stopTest();
		
		System.assertEquals(emailBody , parsedValue , 'Same value should have been returned');
	}
}