@isTest
public class Prevent_Delete_Task_Test 
{
	static List<Task> testTasks;
	static User sysAdminUser;
	static User otherUser;
	static final Integer SIZE = 100;
	static final String LAST_NAME = 'Johnson';
	static final String ADMIN_LAST_NAME = 'Hansen';
	
	static final String ERROR_MSG = 'User can not delete this task record';
	static void setupData()
	{
			
			otherUser = TestUtils.createUser(LAST_NAME , TestUtils.STANDARD_PROFILE_ID , true);			
			sysAdminUser = TestUtils.createUser( ADMIN_LAST_NAME , TestUtils.SYSADMIN_PROFILE_ID , true);
			
			Prevent_Delete_Task__c customSettingEntry = new Prevent_Delete_Task__c();
			customSettingEntry.Name = 'System Administrator';
			
			insert customSettingEntry;
			
			testTasks = TestUtils.createTasks(SIZE , null , false);
			System.runAs(otherUser)
			{
				insert testTasks;
			}
	}
	
	static testMethod void testTaskDeletion_SystemAdmin()
	{
		setupData();
		Test.startTest();
			System.runAs(sysAdminUser)
			{
				try
				{
					delete testTasks;
				}
				catch(DMLException dmlEx)
				{
					System.assert(false , 'This should not have been executed as no exception should have occured');	
				}
			}
		Test.stopTest();
		System.assert(!ApexPages.hasMessages() , 'Error message should not be there.');
		
	}
	
	static testMethod void testTaskDeletion_OtherUser()
	{
		setupData();
		Test.startTest();
			System.runAs(otherUser)
			{
				try
				{
					delete testTasks;
					System.assert(false , 'This should not have been executed as exception should have occured');	
				}
				catch(DMLException dmlEx)
				{
					for (Integer i = 0; i < dmlEx.getNumDml(); i++) 
					{
        				String theMessage = dmlEx.getDmlMessage(i);
    					System.assert(theMessage.contains(ERROR_MSG) , 'Specified error message should have been there');
    				}
				}
			}
		Test.stopTest();
		
		System.assert(ApexPages.hasMessages() , 'Error message should have been there.');
		
	}
}