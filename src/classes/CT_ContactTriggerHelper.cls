public with sharing class CT_ContactTriggerHelper
{
    private final String CLASSNAME = '\n\n**** CT_ContactTriggerHelper.METHODNAME()';
    public String UserProfileName{get; private set;}

	//	@author : CloudTrigger Inc.
	//	@date : 11/17/2011
	//	@description : static method that instantiates a new instance of the class & sets the user's profile name member variable
	//	@paramaters : a string - the profile name for the current user
	//	@returns : a new instance of the CT_ContactTriggerHelper class
    public static CT_ContactTriggerHelper NewTriggerHelper(String pUserProfileName)
    {
        CT_ContactTriggerHelper newHelper = new CT_ContactTriggerHelper(pUserProfileName);
        return newHelper;
    }
    
	//	@author : CloudTrigger Inc.
	//	@date : 11/17/2011
	//	@description : static method that instantiates a new instance of the class
	//	@paramaters : nothing
	//	@returns : a new instance of the CT_ContactTriggerHelper class
    public static CT_ContactTriggerHelper NewTriggerHelper()
    {
        CT_ContactTriggerHelper newHelper = new CT_ContactTriggerHelper('');
        return newHelper;
    }

	//	@author : CloudTrigger, Inc.
	//	@date : 11/17/2011
	//	@description :  this method is the class constructor; it also sets the record type ID variables 
	//	@paramaters : a String - the name of the current User's profile
	//	@returns : a new instance of the CT_ContactTriggerHelper class
    private CT_ContactTriggerHelper(String pUserProfileName)
    {
    	String METHODNAME = CLASSNAME.replace('METHODNAME', 'CT_ContactTriggerHelper') + ' - constructor';
    	system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + '\n\n');
    	UserProfileName = pUserProfileName;

    }

	//@author : CloudTrigger, Inc.
	//@date : 11/17/2011
	//@description :  this method _____ 
	//@paramaters : an array of Accounts that were created
	//@returns : a collection of Contact records
    public list<Contact> GetContactsToUpdateByAccountId(String pAccountId, String pContactId)
    {
    	String METHODNAME = CLASSNAME.replace('METHODNAME', 'GetContactsToUpdateByAccountId');
    	list<Contact> conts = new list<Contact>();
    	conts = [SELECT Id, Contact_Type__c FROM Contact WHERE AccountId = :pAccountId and Id != :pContactId and Contact_Type__c = 'Primary Contact'];
    	return conts;
    }

	//@author : CloudTrigger, Inc.
	//@date : 11/17/2011
	//@description :  this method _____ 
	//@paramaters : a list of Contacts that ...
	//@returns : a collection of Contact records
    public void UpdateContacts(list<Contact> pContacts)
    {
    	String METHODNAME = CLASSNAME.replace('METHODNAME', 'UpdateContacts');
    	system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' with '+ pContacts.size() +' Contact objects in the list to update.\n\n');
    	list<Database.SaveResult> sr = new list<Database.SaveResult>();
    	try{
    		sr = Database.update(pContacts);
    	}
    	catch(Exception ex)
    	{
    		// TO DO
    		system.debug(LoggingLevel.INFO, METHODNAME + ' :: EXCEPTION: '+ ex.getMessage() +'\n\n');
    	}
    }

/* =============================================  TEST METHODS  ============================================= */

    private static testMethod void testTriggerHelper_New_1()
    {
        CT_ContactTriggerHelper helper = CT_ContactTriggerHelper.NewTriggerHelper();
        System.assert(helper != null);
    }
    private static testMethod void testTriggerHelper_New_2()
    {
        CT_ContactTriggerHelper helper = CT_ContactTriggerHelper.NewTriggerHelper();
        System.assert(helper.UserProfileName.equals(''));
    }
    private static testMethod void testTriggerHelper_New_3()
    {
        CT_ContactTriggerHelper helper = CT_ContactTriggerHelper.NewTriggerHelper('TEST');
        System.assert(helper.UserProfileName.equals('TEST'));
    }


}