@isTest
public class PreventAttorenyAccountDeletionTest 
{
	final static String GENERIC_ATTORENY_ACCOUNT_NAME = 'Generic Attorney Account';
	final static String SYS_ADMIN_PROFILE_NAME = 'System Administrator';
	final static String LAST_NAME = 'Daemon';
	static User testUser;
	static Account testAccount;
	
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
		System.runAs(testUser)
		{
			testAccount = TestUtils.createAccounts(1 , GENERIC_ATTORENY_ACCOUNT_NAME , false)[0];
			testAccount.Name = GENERIC_ATTORENY_ACCOUNT_NAME;
			insert testAccount;
		}
	}
	
	static testMethod void testAttorneyAccountDelete_Prevent()
	{
		setupData();
		System.runAs(testUser)
		{
			Test.startTest();
				try
				{
					delete testAccount;
				}
				catch(DMLException dmlEX)
				{
					 System.assert( dmlEX.getMessage().contains(PreventAttorenyAccountDeletionService.DELETE_PREVENT_MESSAGE), 
		                dmlEX.getMessage() );
				}
			Test.stopTest();
		}
		
		List<Account> accounts = [SELECT Id , Name FROm Account WHERE Id = :testAccount.Id];
		System.assertEquals( 1 , accounts.size() , 'The Account shouldn\'t have been deleted');
		
	}
	
	static testMethod void testAttorneyAccountDelete_Allow()
	{
		setupData();
		System.runAs(TestUtils.ADMIN_USER)
		{
		Test.startTest();
			delete testAccount;
		Test.stopTest();
		}
		List<Account> accounts = [SELECT Id , Name FROm Account WHERE Id = :testAccount.Id];
		System.assertEquals( 0 , accounts.size() , 'The Account should have been deleted');
	}
	
	
	
}