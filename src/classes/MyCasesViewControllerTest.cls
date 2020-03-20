@isTest
public class MyCasesViewControllerTest
{
	static List<Case> testCases;
	static User testAssignedUser;
	final static String LASTNAME = 'Gronzalez';
	final static Integer SIZE = 10;
	static Id standardRecordTypeId;
	static Id customeCareSpecialistId;
	static void setupData()
	{
		customeCareSpecialistId = [SELECT Id FROM UserRole WHERE DeveloperName = 'CC_AS_Lead'].Id;
		testCases = TestUtils.createCases(SIZE , false);
		testAssignedUser = TestUtils.createUser(LASTNAME , TestUtils.STANDARD_PROFILE_ID , false);
		testAssignedUser.UserRoleId = customeCareSpecialistId;
		System.runAs(TestUtils.ADMIN_USER)
		{
			insert testAssignedUser;
		}
		standardRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Standard_Case' limit 1].Id;
	}
	
	static testMethod void testMyCasesView_GetOpenCase()
	{
		setupData();
		for(Integer i =0 ;i <SIZE/2 ;++i)
		{
			testCases[i].Status = 'Open';
			testCases[i].Assigned_User__c = testAssignedUser.Id;
			testCases[i].RecordTypeId = standardRecordTypeId;			
		}
		insert testCases;
		
		List<Case> theCases = [SELECT Id , OwnerId , RecordTypeId FROM Case WHERE Id = :testCases];
	
		MyCasesViewController theController;
		System.runAs(testAssignedUser)
		{
			List<User> theUser = [SELECT Id , UserRoleId FROM User WHERE Id = :testAssignedUser.Id];
			
			PageReference pageRef = Page.MyCasesView;
			Test.setCurrentPage(pageRef);
			
			Test.startTest();
				theController = new MyCasesViewController();
			Test.stopTest();
		}
		System.assertEquals(SIZE/2 , theController.allCases.size() , SIZE/2 + ' open cases should have been returned');
	}
	
	static testMethod void testMyCasesView_GetClosedCase()
	{
		setupData();
		for(Case theCase : testCases)
		{
			theCase.Status = 'Closed';
			theCase.Assigned_User__c = testAssignedUser.Id;
			theCase.RecordTypeId = standardRecordTypeId;
		}
		insert testCases;
		
		MyCasesViewController theController;
		System.runAs(testAssignedUser)
		{
			PageReference pageRef = Page.MyCasesView;
			Test.setCurrentPage(pageRef);
			theController = new MyCasesViewController();
			Test.startTest();
				theController.selectedValue = 'My Closed Cases';
				theController.initialize();
			Test.stopTest();
		}
		System.assertEquals(SIZE , theController.allCases.size() , SIZE + ' open cases should have been returned');
	}
	
	static testMethod void testMyCasesView_GetAllCase()
	{
		setupData();
		for(Case theCase : testCases)
		{
			theCase.Assigned_User__c = testAssignedUser.Id;
			theCase.RecordTypeId = standardRecordTypeId;
		}
		insert testCases;
		
		MyCasesViewController theController;
		System.runAs(testAssignedUser)
		{
			PageReference pageRef = Page.MyCasesView;
			Test.setCurrentPage(pageRef);
			theController = new MyCasesViewController();
			Test.startTest();
				theController.selectedValue = 'My All Cases';
				theController.initialize();
			Test.stopTest();
		}
		System.assertEquals(SIZE , theController.allCases.size() , SIZE + ' open cases should have been returned');
	}
	
	static testMethod void testGetOptions()
	{
		PageReference pageRef = Page.MyCasesView;
		Test.setCurrentPage(pageRef);
		MyCasesViewController theController = new MyCasesViewController();
		
		Test.startTest();
			List<SelectOption> theOptions = theController.getOptions();	
		Test.stopTest();
		
		System.assertEquals(3  , theOptions.size() , 'Three options should have been retrned');
		
	}
	
	static testMethod void testWrapperProperties()
	{
		PageReference pageRef = Page.MyCasesView;
		Test.setCurrentPage(pageRef);
		MyCasesViewController theController = new MyCasesViewController();
		//These are all the wrapper for salesforce standard methods/properties of StandardSetController
		Test.startTest();
			Boolean hasNext = theController.hasNext;
			Boolean hasPrevious = theController.hasPrevious;
			theController.next();
			theController.previous();
			Integer pageNumber = theController.pageNumber;	
		Test.stopTest();
		
	}
}