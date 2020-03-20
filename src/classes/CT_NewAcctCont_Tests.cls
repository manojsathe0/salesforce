@isTest
private class CT_NewAcctCont_Tests {

    private static void init()
    {    }
    
    static testMethod void test_Model_SaveAll_Negative() {
    	String profileName = 'System Administrator';
	   	Profile p = [select id from profile where name = :profileName];
	   	
	   	User testUser = new User(alias = 'u1',
    	emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
    	localesidkey='en_US', profileid = p.Id, country='United States',
    	timezonesidkey='America/Los_Angeles'
    	, email='testuseremail'+String.valueof(Datetime.now()).replace(' ','_').replace('-','_').replace(':','_')+'@cloudtrigger.net'
    	, username='testuser'+String.valueof(Datetime.now()).replace(' ','_').replace('-','_').replace(':','_')+'@cloudtrigger.com');
    	insert testUser;
	   	
    	CT_NewAcctCont_Model model  = CT_NewAcctCont_Model.NewModel(testUser.Id);
        
        list<Account> existingAccounts = [SELECT Id FROM Account WHERE Name = 'testuser2@cloudtrigger.net'];
        system.assert(CT_Utility.ValidateList(existingAccounts) == false);
        
        model.NewCont.MailingStreet    	= 'Test Street';
        model.NewCont.MailingCity       = 'Test City';
        
        // line below is commented out because Contact's email is supposed to come from Account Name
        // model.NewCont.Email             = 'unamefortesting@cloudtrigger.net';
        
        model.NewCont.FirstName         = 'Test_FirstName1';
        model.NewCont.LastName          = 'Test_Lastname1';
        model.NewCont.Phone             = '2234567890';
        model.NewCont.OtherPhone        = '2234567890';
        model.NewCont.MailingState      = 'FL';
        model.NewCont.MailingPostalCode = '12345';

        try{
        	model.SaveAll();
        }catch(Exception ex){
        	system.assert(true);	
        }

        existingAccounts = [SELECT Id FROM Account WHERE Name = 'testuser2@cloudtrigger.net'];
        system.assert(CT_Utility.ValidateList(existingAccounts) == false);
    }

    static testMethod void test_Model_SaveAll_Positive() {
    	String profileName = 'System Administrator';
	   	Profile p = [select id from profile where name = :profileName];
	   	
	   	User testUser = new User(alias = 'u1',
    	emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
    	localesidkey='en_US', profileid = p.Id, country='United States',
    	timezonesidkey='America/Los_Angeles'
    	, email='testuseremail'+String.valueof(Datetime.now()).replace(' ','_').replace('-','_').replace(':','_')+'@cloudtrigger.net'
    	, username='testuser'+String.valueof(Datetime.now()).replace(' ','_').replace('-','_').replace(':','_')+'@cloudtrigger.com');
    	insert testUser;
	   	
	   	Account testAccount = new Account(Name='testing_Account');
    	CT_NewAcctCont_Model model  = CT_NewAcctCont_Model.NewModel(testUser.Id);
        
        list<Account> existingAccounts = [SELECT Id FROM Account WHERE Name = :testUser.email];
        system.assert(CT_Utility.ValidateList(existingAccounts) == false);
        list<Contact> existingContacts = [SELECT Id FROM Contact WHERE Email = :testUser.email];
        system.assert(CT_Utility.ValidateList(existingContacts) == false);
        
        model.NewAcct.Name				= testUser.email;//'testuser2@cloudtrigger.net';
        model.NewCont.MailingStreet    	= 'Test Street';
        model.NewCont.MailingCity       = 'Test City';
        
        // line below is commented out because Contact's email is supposed to come from Account Name
        // model.NewCont.Email             = 'unamefortesting@cloudtrigger.net';
        
        model.NewCont.FirstName         = 'Test_FirstName1';
        model.NewCont.LastName          = 'Test_Lastname1';
        model.NewCont.Phone             = '2234567890';
        model.NewCont.OtherPhone        = '2234567890';
        model.NewCont.MailingState      = 'FL';
        model.NewCont.MailingPostalCode = '12345';

        model.SaveAll();        

        existingAccounts = [SELECT Id FROM Account WHERE Name = :testUser.email];
        system.assert(CT_Utility.ValidateList(existingAccounts) == true);
        existingContacts = [SELECT Id FROM Contact WHERE Email = :model.NewAcct.Name];
        system.assert(CT_Utility.ValidateList(existingContacts) == true);
    }

    static testMethod void test_Controller_Save_Negative() {
        
        String profileName = 'System Administrator';
	   	Profile p = [select id from profile where name = :profileName];
	   	
	   	User testUser = new User(alias = 'u1',
    	emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
    	localesidkey='en_US', profileid = p.Id, country='United States',
    	timezonesidkey='America/Los_Angeles'
    	, email='testuseremail'+String.valueof(Datetime.now()).replace(' ','_').replace('-','_').replace(':','_')+'@cloudtrigger.net'
    	, username='testuser'+String.valueof(Datetime.now()).replace(' ','_').replace('-','_').replace(':','_')+'@cloudtrigger.com');
    	insert testUser;
	   	
    	ApexPages.StandardController StdController = new ApexPages.StandardController(new Account());
    	CT_NewAcctCont_Controller controller  = new CT_NewAcctCont_Controller(StdController);

        
        list<Account> existingAccounts = [SELECT Id FROM Account WHERE Name = 'testuser2@cloudtrigger.net'];
        system.assert(CT_Utility.ValidateList(existingAccounts) == false);
        
        // line below is commented out because Contact's email is supposed to come from Account Name
        // controller.model.NewCont.Email             = 'unamefortesting@cloudtrigger.net';
        
        controller.model.NewCont.FirstName         = 'Test_FirstName1';
        controller.model.NewCont.LastName          = 'Test_Lastname1';

        
        try{
        	controller.EventButtonClickSave();
        }
        catch(Exception ex)
        {
        	system.assert(true);	
        }
        system.assert(controller.saveSuccessful == false);

        existingAccounts = [SELECT Id FROM Account WHERE Name = 'testuser2@cloudtrigger.net'];
        system.assert(CT_Utility.ValidateList(existingAccounts) == false);
    }

    static testMethod void test_Controller_Save_Positive() {
    	String profileName = 'System Administrator';
	   	Profile p = [select id from profile where name = :profileName];
	   	
	   	User testUser = new User(alias = 'u1',
    	emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
    	localesidkey='en_US', profileid = p.Id, country='United States',
    	timezonesidkey='America/Los_Angeles'
    	, email='testuseremail'+String.valueof(Datetime.now()).replace(' ','_').replace('-','_').replace(':','_')+'@cloudtrigger.net'
    	, username='testuser'+String.valueof(Datetime.now()).replace(' ','_').replace('-','_').replace(':','_')+'@cloudtrigger.com');
    	insert testUser;
    	
    	ApexPages.StandardController StdController = new ApexPages.StandardController(new Account());
    	CT_NewAcctCont_Controller controller  = new CT_NewAcctCont_Controller(StdController);

        
        list<Account> existingAccounts = [SELECT Id FROM Account WHERE Name = :testUser.email];
        system.assert(CT_Utility.ValidateList(existingAccounts) == false);
        list<Contact> existingContacts = [SELECT Id FROM Contact WHERE Email = :testUser.email];
        system.assert(CT_Utility.ValidateList(existingContacts) == false);
        
        controller.model.NewAcct.Name				= testUser.email;
        
        // line below is commented out because Contact's email is supposed to come from Account Name
        // controller.model.NewCont.Email             = 'unamefortesting@cloudtrigger.net';
        
        controller.model.NewCont.FirstName         = 'Test_FirstName1';
        controller.model.NewCont.LastName          = 'Test_Lastname1';

        controller.EventButtonClickSave();

        existingAccounts = [SELECT Id FROM Account WHERE Name = :testUser.email];
        system.assert(CT_Utility.ValidateList(existingAccounts) == true);
        existingContacts = [SELECT Id FROM Contact WHERE Email = :testUser.email];
        system.assert(CT_Utility.ValidateList(existingContacts) == true);
    }
    
    
}