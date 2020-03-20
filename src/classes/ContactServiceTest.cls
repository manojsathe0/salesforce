@isTest
public class ContactServiceTest
{
	static List<Account> testAccounts;
	static List<Contact> testContacts;
	final static Integer SIZE = 100;
	final static String LAST_NAME = 'Test Last';
	// Added for Story - B39269 - Starts Here
    private static List<Customer_Login__c> custLoginList;
	private static user u1; 
    // Added for Story - B39269 - Ends Here

	static void setupData()
	{
		testContacts = TestUtils.createContacts(SIZE , LAST_NAME , null , false);
		for(Integer i = 0 ; i< SIZE ; ++i)
		{
			testContacts[i].FKUser__c = i+'';
		}
		
        // Added for Story - B39269 - Starts Here
        custLoginList = new List<Customer_Login__c>();
        u1 = TestUtils.createUser('adminuser' + DateTime.now().getTime(), [SELECT Id FROM Profile WHERE Name ='SYStem Administrator' LIMIT 1].Id,true);
        List<Account> accL = TestUtils.createAccounts(1,'doInsert',false);
        // Added for Story - B39269 - Ends Here
	}

	static testMethod void testCreateAccounts_For_PrimaryContacts()
	{
		setupData();
		Test.startTest();
			insert testContacts;
		Test.stopTest();

		List<Account> createdAccounts = [SELECT Id FROM Account];
		System.assertEquals(SIZE  , createdAccounts.size() , SIZE+ 'accounts should have been created');
		List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId IN :createdAccounts];
		SYstem.assertEquals(SIZE , contacts.size() , SIZE+ ' contacts should hav been populated with Account Ids');
	}

	static testMethod void testCreateAccounts_For_PrimaryAndAuthorizedContacts()
	{
		setupData();
		List<Contact> moreContacts = TestUtils.createContacts(SIZE , LAST_NAME , null , false);
		for(Integer i = 0 ; i< SIZE ; ++i)
		{
			moreContacts[i].FKUser__c = i+'';
		}	
		testContacts.addAll(moreContacts);

		Test.startTest();
			insert testContacts;
		Test.stopTest();

		List<Account> createdAccounts = [SELECT Id FROM Account];
		System.assertEquals(SIZE  , createdAccounts.size() , SIZE+ 'accounts should have been created');
		List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId IN :createdAccounts];
		SYstem.assertEquals(SIZE*2 , contacts.size() , SIZE*2 + ' contacts should hav been populated with Account Ids');
	}

	static testMethod void testCreateAccounts_For_PrimaryAndAuthorizedContacts_MoreContacts()
	{
		setupData();
		List<Contact> moreContacts = TestUtils.createContacts(SIZE , LAST_NAME , null , false);
		for(Integer i = 0 ; i< SIZE ; ++i)
		{
			moreContacts[i].FKUser__c = i+'';
		}	
		testContacts.addAll(moreContacts);

		List<Contact> someMoreContacts = TestUtils.createContacts(SIZE , LAST_NAME , null , false);
		for(Integer i = 0 ; i< SIZE ; ++i)
		{
			someMoreContacts[i].FKUser__c = i+'';
		}	
		testContacts.addAll(someMoreContacts);


		Test.startTest();
			insert testContacts;
		Test.stopTest();

		List<Account> createdAccounts = [SELECT Id FROM Account];
		System.assertEquals(SIZE  , createdAccounts.size() , SIZE+ 'accounts should have been created');
		List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId IN :createdAccounts];
		SYstem.assertEquals(SIZE*3 , contacts.size() , SIZE*3 + ' contacts should hav been populated with Account Ids');
	}

	static testMethod void testPopulateCustomerLoginEmail()
	{
		setupData();
		insert testContacts;
		List<Customer_Login__c> testCustomerLogins = TestUtils.createCustomerLogins(SIZE , 'TestCustomer@yahoo.com' , false);
		Set<String> expectedCustomerLogins = new Set<String>();
		for(Customer_Login__c theLogin : testCustomerLogins)
		{
			expectedCustomerLogins.add(theLogin.Name);
		}
		Test.startTest();
			insert testCustomerLogins;
		Test.stopTest();
		List<Contact> updatedContacts = [SELECT Id , Customer_Login_Email__c FROM Contact WHERE Id IN : testContacts];
		Set<String> actualCustomerLoginEmails = new Set<String>();
		for(Contact theContact : updatedContacts)
		{
			System.assertNotEquals(null , theContact.Customer_Login_Email__c , 'Customer Login should not have been null');
			actualCustomerLoginEmails.add(theContact.Customer_Login_Email__c);
		}
		System.assertEquals(SIZE , actualCustomerLoginEmails.size() , SIZE+' Customer Login Email should have been there');
		System.assert(actualCustomerLoginEmails.containsAll(expectedCustomerLogins));
		System.assert(expectedCustomerLogins.containsAll(actualCustomerLoginEmails));

	}
	@isTest
	static void testNumberToInternalList() {
		setupData();
		for (Contact cnt : testContacts) {
			cnt.Internal_List__c = true;
			cnt.Phone = '1234567712';
			cnt.HomePhone = '1234567712';
			cnt.MobilePhone = '1234567712';
			cnt.OtherPhone = '1234567712';
		}
		Test.startTest();
		insert testContacts;
		
		
		IADTestMockGenerator mock = new IADTestMockGenerator();
    	mock.testBody = '{}';
    	mock.statusCode = 200;
		
		Test.setMock(HttpCalloutMock.class, mock);
	
		
		
		List<Contact> updatedContacts = [SELECT Id, Phone, HomePhone, MobilePhone, OtherPhone FROM Contact WHERE Id IN : testContacts LIMIT 1];
		for (Contact cnt : updatedContacts) {
			cnt.Phone = '1234567715';
			cnt.HomePhone = '1234567715';
			cnt.MobilePhone = '1234567715';
			cnt.OtherPhone = '1234567715';
		}
		update updatedContacts;
		Test.stopTest();
	}

	static testMethod void testUpdateCustomerLoginFromContact()
	{
		setupData();
		List<Customer_Login__c> testCustomerLogins = TestUtils.createCustomerLogins(SIZE , 'TestCustomer@yahoo.com' , true);
		Set<String> expectedCustomerLogins = new Set<String>();
		for(Customer_Login__c theLogin : testCustomerLogins)
		{
			expectedCustomerLogins.add(theLogin.Name);
		}
		
		Test.startTest();
			insert testContacts;
		Test.stopTest();

		List<Contact> updatedContacts = [SELECT Id , Customer_Login_Email__c FROM Contact WHERE Id IN : testContacts];
		Set<String> actualCustomerLoginEmails = new Set<String>();
		for(Contact theContact : updatedContacts)
		{
			System.assertNotEquals(null , theContact.Customer_Login_Email__c , 'Customer Login should not have been null');
			actualCustomerLoginEmails.add(theContact.Customer_Login_Email__c);
		}
		System.assertEquals(SIZE , actualCustomerLoginEmails.size() , SIZE+' Customer Login Email should have been there');
		System.assert(actualCustomerLoginEmails.containsAll(expectedCustomerLogins));
		System.assert(expectedCustomerLogins.containsAll(actualCustomerLoginEmails));

	}
	@isTest
	
	static void extraTests() {
		setupData();
		
		Test.startTest();
			insert testContacts;
		Test.stopTest();
		ContactService.processForCampaignsEntry(testContacts);
		ContactService.processForCampaignsExit(testContacts);
	}
	
    //// Added for Story - B39269 - Starts Here
    @isTest
    private static void ContactCustomerLoginAssociation_Test1(){
        setupData();
        system.runAs(u1){
            Test.startTest();
                insert testContacts;
            	
                for(Integer i =0; i< 5; i++){
                	Customer_Login__c theLogin = new Customer_Login__c();
            		theLogin.Name = 'newloginId'+i;
            		theLogin.Customer_ID__c = i+'';
                    theLogin.Primary_Contact__c = testContacts[i].Id;
            		custLoginList.add(theLogin);
                }
            
            	for(Integer i =10; i< 15; i++){
                	Customer_Login__c theLogin = new Customer_Login__c();
            		theLogin.Name = 'newloginId'+i;
            		theLogin.Customer_ID__c = i+'';
                    theLogin.Primary_Contact__c = testContacts[i+10].Id;
            		custLoginList.add(theLogin);
                }
            
                insert custLoginList;
                
            	for(contact c: testContacts){
                    c.Contact_Type__c ='Primary Contact';
                }
            	update testContacts;
            	
            Test.stopTest();
            List<Contact> conList = [SELECT Id FROM Contact LIMIT 100];
			System.assert(conList.size()>0);
        }
    }
    
    @isTest
    private static void ContactCustomerLoginAssociation_Test2(){
        Test.startTest();
			ContactService.ContactCustomerLoginAssociation(null,null);
        Test.stopTest();
        List<Contact> conList =new List<Contact>();
         conList = [SELECT Id FROM Contact LIMIT 100];
		System.assert(conList.size()==0);
    }
    
    @isTest
    private static void ContactCustomerLoginAssociation_Test3(){
        setupData();
        system.runAs(u1){
            Test.startTest();
            	for(contact c: testContacts){
                    c.Contact_Type__c ='Primary Contact';
                }
            	insert testContacts;
            Test.stopTest();
            List<Contact> conList = [SELECT Id FROM Contact LIMIT 100];
			System.assert(conList.size()>0);
        }
    }
    //// Added for Story - B39269 - Ends Here

}