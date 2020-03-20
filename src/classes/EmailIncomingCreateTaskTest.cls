@isTest
private class EmailIncomingCreateTaskTest {

    public static Case createCase;

	static void setupData()
	{
		//Create Account
		Account acct = TestUtils.createAccounts(1, 'test@test.com', true)[0];
		
		//Create Contact
		Contact contact = TestUtils.createContacts(1, 'testContact', acct.Id, false)[0];
		contact.Email = 'test@test.com';
		insert contact;
		
		//Create Case
		createCase = TestUtils.createCases(1, true)[0];

		EmailMessage email = new EmailMessage();
		email.status='3';
		email.subject = 'Test Email to Case';
		email.HtmlBody = 'Test Email to Case';
		email.toaddress = contact.Email;
		email.fromname = 'LegalZoom Support';
		email.MessageDate = Datetime.now();
		email.ParentId = createCase.Id;
		email.fromaddress='support@legalzoom.com';

		insert email;
	}
	
	static testMethod void testEmailMessageIncomingCreateTask()
	{
		setupData();
	}
}