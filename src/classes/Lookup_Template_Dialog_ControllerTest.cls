@isTest
private class Lookup_Template_Dialog_ControllerTest {

    static Case testCase;
    //TODO:
    //some of these test methods needs improvement.Better assertion.Adding now for code coverage.
    static void setupData()
    {
    	testCase = TestUtils.createCases(1 , true)[0];
    }
    static testMethod void testClearResult() 
    {
    	setupData();
    	PageReference pageRef = Page.Lookup_Template_Dialog;
        ApexPages.Standardcontroller theStandardController = New ApexPages.StandardController(testCase);
		Lookup_Template_Dialog_Controller   theControllerExtension = new Lookup_Template_Dialog_Controller(theStandardController );
    	Lookup_Template_Dialog_Controller.TemplateDetail theDetail = new Lookup_Template_Dialog_Controller.TemplateDetail();
    	theControllerExtension.searchT = new List<Lookup_Template_Dialog_Controller.TemplateDetail>{theDetail};
    	Test.startTest();
    		theControllerExtension.ClearResult();
    	Test.stopTest();
    	
    	System.assertEquals(0 , theControllerExtension.searchT.size() , 'Searched results should have been cleared');
    }
    
    static testMethod void testGetFolders()
    {
    	setupData();
    	PageReference pageRef = Page.Lookup_Template_Dialog;
        ApexPages.Standardcontroller theStandardController = New ApexPages.StandardController(testCase);
		Lookup_Template_Dialog_Controller   theControllerExtension = new Lookup_Template_Dialog_Controller(theStandardController );
		
		Test.startTest();
			List<SelectOption>  theOptions = theControllerExtension.getFolders();
		Test.stopTest();
		
		System.assert(!theOptions.isEmpty() , 'Folders name should have been populated');
    }
    
    static testMethod void testSearchContact()
    {
    	setupData();
    	PageReference pageRef = Page.Lookup_Template_Dialog;
        ApexPages.Standardcontroller theStandardController = New ApexPages.StandardController(testCase);
		Lookup_Template_Dialog_Controller   theControllerExtension = new Lookup_Template_Dialog_Controller(theStandardController );
		
		Test.startTest();
			PageReference thePageReference = theControllerExtension.searchContact();
		Test.stopTest();
		
		System.assertNotEquals(null , thePageReference , 'Page Reference should not have been null');
    }
    
}