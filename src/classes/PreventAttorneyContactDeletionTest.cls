@isTest
public class PreventAttorneyContactDeletionTest
{
	final static String GENERIC_ATTORENY_ACCOUNT_NAME = 'Generic Attorney Account';
	final static String SYS_ADMIN_PROFILE_NAME = 'System Administrator';
	final static String LAST_NAME = 'Daemon';
	static User testUser;
	static Account testAccount;
	static List<Contact> testAttorenyContacts;
	
	static void setupData()
	{
		Generic_Attorney_Account_Name__c genericAttorenyAccountName = new Generic_Attorney_Account_Name__c();
		genericAttorenyAccountName.Name = GENERIC_ATTORENY_ACCOUNT_NAME;
		
		Attoreny_Account_Contact_Delete_Profile__c deletionALlowedProfileName = new Attoreny_Account_Contact_Delete_Profile__c();
		deletionALlowedProfileName.Name = SYS_ADMIN_PROFILE_NAME;
		
		System.runAs(TestUtils.ADMIN_USER)
		{
			insert genericAttorenyAccountName;
			insert deletionALlowedProfileName;
		}
		
		testUser = TestUtils.createUser(LAST_NAME, TestUtils.STANDARD_PROFILE_ID , false);
		testAccount = TestUtils.createAccounts(1 , GENERIC_ATTORENY_ACCOUNT_NAME , false)[0];
		testAccount.Name = GENERIC_ATTORENY_ACCOUNT_NAME;
		insert testAccount;
		
		System.runAs(testUser)
		{
			testAttorenyContacts = TestUtils.createContacts(10 , LAST_NAME, testAccount.Id, true);	
		}
	}
	
	static testMethod void testAttorneyContactDelete_Prevent()
	{
		setupData();
		
		System.runAs(testUser)
		{
			Test.startTest();
			try
			{
				delete testAttorenyContacts;
			}
			catch(DMlException dmlEx)
			{
				for (Integer i = 0; i < dmlEx.getNumDml(); i++) 
				{
			         System.assert( dmlEX.getDmlMessage(i).contains(PreventAttorneyContactDeletionService.DELETE_PREVENT_MESSAGE), 
		                dmlEX.getDmlMessage(i) ); 
			    }
			}
			Test.stopTest();
		}
		
		List<Contact> contacts = [SELECT Id FROM Contact WHERE Id IN :testAttorenyContacts];
		System.assertEquals(10 , contacts.size() , 'Contacts shouldn\'t have been deleted');
				
	}
	
	static testMethod void testAttorenyContactDelete_Allow()
	{
		setupData();
		
		System.runAs(TestUtils.ADMIN_USER)
		{
			Test.startTest();
				delete testAttorenyContacts;
			Test.stopTest();
		}
		
		List<Contact> contacts = [SELECT Id FROM Contact WHERE Id IN :testAttorenyContacts];
		System.assertEquals(0 , contacts.size() , 'Contacts should have been deleted');
				
	}
	
}