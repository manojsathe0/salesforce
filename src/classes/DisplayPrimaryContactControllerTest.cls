@isTest
public class DisplayPrimaryContactControllerTest {
	
	static Contact primaryContact;
	static Contact authorizedContact;
	static Customer_Login__c testCustomerLogin;
	static Task theTask;

	static void setupData()
	{
		Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
        authorizedContact = TestUtils.createContacts(1 , 'Auhtorized Contact' , testAccount.Id , false)[0];
        authorizedContact.FKUser__c = '987654';
        authorizedContact.Genesys_Interaction_Id__c = '998899';
        primaryContact = TestUtils.createContacts(1 , 'Primary Contact' , testAccount.Id , false)[0];
        primaryContact.FKUser__c = '987654';
        insert new List<Contact>{authorizedContact,primaryContact};
        
        testCustomerLogin = new Customer_Login__c();
        testCustomerLogin.Customer_ID__c = '987654';
        testCustomerLogin.Primary_Contact__c = primaryContact.Id;
        insert testCustomerLogin;

        theTask = new Task();
        theTask.WhoId = authorizedContact.Id;
        theTask.Description = 'Test Description';
        theTask.CallObject = '998899';
        insert theTask;
             
	}


	static testMethod void testDisplayPrimaryContactController_Success()
	{
		setupData();
		PageReference pageRef = Page.DisplayPrimaryContact;
        pageRef.getParameters().put('id', String.valueOf(authorizedContact.Id));
        Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc = new ApexPages.StandardController(authorizedContact);
        DisplayPrimaryContactController theController = new DisplayPrimaryContactController(sc);  
        Test.startTest(); 
        	 theController.openPrimaryContact();
        Test.stopTest();
        List<Task> tasks = [SELECt Id FROM Task WHERE whoId = : primaryContact.Id];
        System.assertEquals(1 , tasks.size() , 'Task should have been tied to primary Contact');
        List<Contact> contacts = [SELECt Id , Genesys_Interaction_Id__c FROM Contact WHERE Id = : primaryContact.Id];
        System.assertEquals('998899' , contacts[0].Genesys_Interaction_Id__c , 'Right interaction Id should have been populated');

	}


	static testMethod void testDisplayPrimaryContactController_Fail_NoInteractionId()
	{
		setupData();
		theTask.CallObject = '1111';
		update theTask;

		authorizedContact.Genesys_Interaction_Id__c = null;
		update authorizedContact;
		
		PageReference pageRef = Page.DisplayPrimaryContact;
        pageRef.getParameters().put('id', String.valueOf(authorizedContact.Id));
        Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc = new ApexPages.StandardController(authorizedContact);
        DisplayPrimaryContactController theController = new DisplayPrimaryContactController(sc);  
        Test.startTest(); 
        	 theController.openPrimaryContact();
        Test.stopTest();
        System.assertEquals(1 , theController.iadMessages.size() , '1 error message should have been populated');

	}

	static testMethod void testDisplayPrimaryContactController_Fail_NoPrimaryContact()
	{
		setupData();
		delete testCustomerLogin; 
		
		PageReference pageRef = Page.DisplayPrimaryContact;
        pageRef.getParameters().put('id', String.valueOf(authorizedContact.Id));
        Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc = new ApexPages.StandardController(authorizedContact);
        DisplayPrimaryContactController theController = new DisplayPrimaryContactController(sc);  
        Test.startTest(); 
        	 theController.openPrimaryContact();
        Test.stopTest();
        System.assertEquals(1 , theController.iadMessages.size() , '1 error message should have been populated');

	}

	static testMethod void testDisplayPrimaryContactController_Fail_NoCustomerLogin()
	{
		setupData();
		authorizedContact.FkUser__c = null;
		update authorizedContact;
		
		PageReference pageRef = Page.DisplayPrimaryContact;
        pageRef.getParameters().put('id', String.valueOf(authorizedContact.Id));
        Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc = new ApexPages.StandardController(authorizedContact);
        DisplayPrimaryContactController theController = new DisplayPrimaryContactController(sc);  
        Test.startTest(); 
        	 theController.openPrimaryContact();
        Test.stopTest();
        System.assertEquals(1 , theController.iadMessages.size() , '1 error message should have been populated');

	}
}