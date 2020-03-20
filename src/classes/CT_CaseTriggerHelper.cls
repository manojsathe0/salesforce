public without sharing class CT_CaseTriggerHelper{
    private final String CLASSNAME = '\n\n**** CT_CaseTriggerHelper.METHODNAME()';
    public String UserProfileName{get; private set;}

	//	@author : CloudTrigger Inc.
	//	@date : 11/29/2011
	//	@description : static method that instantiates a new instance of the class & sets the user's profile name member variable
	//	@paramaters : a string - the profile name for the current user
	//	@returns : a new instance of the CT_CaseTriggerHelper class
    public static CT_CaseTriggerHelper NewTriggerHelper(String pUserProfileName){
        return new CT_CaseTriggerHelper(pUserProfileName);
    }
    
	//	@author : CloudTrigger Inc.
	//	@date : 11/29/2011
	//	@description : static method that instantiates a new instance of the class
	//	@paramaters : nothing
	//	@returns : a new instance of the CT_CaseTriggerHelper class
    public static CT_CaseTriggerHelper NewTriggerHelper(){
        return new CT_CaseTriggerHelper('');
    }

	//	@author : CloudTrigger, Inc.
	//	@date : 11/29/2011
	//	@description :  this method is the class constructor; it also sets the record type ID variables 
	//	@paramaters : a String - the name of the current User's profile
	//	@returns : a new instance of the CT_CaseTriggerHelper class
    private CT_CaseTriggerHelper(String pUserProfileName){
    	//String METHODNAME = CLASSNAME.replace('METHODNAME', 'CT_CaseTriggerHelper') + ' - constructor';
    	//system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + '\n\n');
    	UserProfileName = pUserProfileName;
    }

	//@author : CloudTrigger, Inc.
	//@date : 11/29/2011
	//@description :  this method creates a 'parent' Account and Contact for each Case depending upon the Case's Contact ID
	//@paramaters : a list of Cases that are new
	//@returns : nothing
	//@called by : CT_CaseTriggerHandler.OnBeforeInsert()
    public void CreateParentAccountAndContact(List<Case> pCases){
    	String METHODNAME = CLASSNAME.replace('METHODNAME', 'CreateParentAccountAndContact');
    	System.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' with '+ pCases.size() +' Case objects in the list.\n\n');
    	
    	List<Account> AccountsToBeCreated = new List<Account>();
    	Map<String, Contact> ContactsToBeCreatedMap = new Map<String, Contact>();

    	try{
            
	    	for(Case objCase : pCases){
	    		if(CT_Utility.StringIsNullOrEmpty(objCase.SuppliedEmail)==false){
		    		Account acct = new Account(Name=objCase.SuppliedEmail);
		    		AccountsToBeCreated.add(acct);
                    
		    		String first_Name;
		    		String last_Name;
		    		if(CT_Utility.StringIsNullOrEmpty(objCase.SuppliedName)==false){
                        String trimmedName = objCase.SuppliedName.trim();
		    			Integer firstSpace = trimmedName.indexOf(' ');
						if(firstSpace > 0 )
						{
							first_Name = trimmedName.subString(0,firstSpace);
						}
						else 
							last_Name = trimmedName;
						if(firstSpace > 0)
						{	
							last_Name = trimmedName.subString(firstSpace , trimmedName.length());
						} 
		    		}else{
                        first_Name = 'NOT';
                        last_Name = 'PROVIDED';
		    		}
		    		Contact cont = new Contact(FirstName=first_Name, LastName=last_Name, Email=objCase.SuppliedEmail);
		    		ContactsToBeCreatedMap.put(objCase.SuppliedEmail, cont);
		    		
		    		objCase.Debug_Info__c = (objCase.Debug_Info__c + '; Creating a new Account and Contact now! [Acct Name = '+ acct.Name +', and Contact FN, LN Email = '+ first_Name +', '+ last_Name +', '+ objCase.SuppliedEmail +']');
	    		}
	    	}
            if(CT_Utility.ValidateList(AccountsToBeCreated)){
	    		System.debug(LoggingLevel.INFO, METHODNAME + ' :: inserting '+ AccountsToBeCreated.size() +' Account objects now.\n\n');
	    		insert AccountsToBeCreated;
	    		
	    		System.debug(LoggingLevel.INFO, METHODNAME + ' :: setting the AccountId of each Contact now.\n\n');
	    		for(Account accnt:AccountsToBeCreated){
	    			// set the AccountId of each Contact in the map of Contacts 
	    			ContactsToBeCreatedMap.get(accnt.Name).AccountId = accnt.Id;
	    		}
	    		
	    		System.debug(LoggingLevel.INFO, METHODNAME + ' :: inserting '+ ContactsToBeCreatedMap.values().size() +' Contact objects now.\n\n');
	    		insert ContactsToBeCreatedMap.values();
	    		
	    		System.debug(LoggingLevel.INFO, METHODNAME + ' :: setting the ContactId and AccountId of each Case now.\n\n');
	    		// set the ContactId of each Case now
	    		for(Case obCase:pCases){
	    			Contact parentContact = ContactsToBeCreatedMap.get(obCase.SuppliedEmail);
	    			obCase.ContactId = parentContact.Id;
	    			obCase.AccountId = parentContact.AccountId;
	    		}
	    	}
    	}catch(Exception ex){
    		system.debug(LoggingLevel.INFO, METHODNAME + ' :: EXCEPTION: '+ ex.getMessage() +'\n\n');
    		throw ex;
    	}
    }

    public map<String, Contact> GetEmailAddressToContactMap(Set<String> pEmailAddresses){
        String METHODNAME = CLASSNAME.replace('METHODNAME', 'GetEmailAddressToContactMap');
    	System.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' with '+ pEmailAddresses.size() +' Email Addresses in the list.\n\n');
		Map<String, Contact> EmailToContactMap = new Map<String, Contact>();
		List<Contact> contacts = new List<Contact>([SELECT Id, Email FROM Contact WHERE (Email IN :pEmailAddresses)]);
        if(CT_Utility.ValidateList(contacts)){
			System.debug(LoggingLevel.INFO, METHODNAME + ' :: found '+ contacts.size() +' Contacts with email match.\n\n');
			for(Contact cont:contacts)
				EmailToContactMap.put(cont.Email.toLowerCase(), cont);
		}
		
		return EmailToContactMap;
	}

    public map<String, Account> GetEmailAddressToAccountMap(Set<String> pEmailAddresses){
        String METHODNAME = CLASSNAME.replace('METHODNAME', 'GetEmailAddressToAccountMap');
        System.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' with '+ pEmailAddresses.size() +' Email Addresses in the list.\n\n');
        Map<String, Account> EmailToAccountMap = new Map<String, Account>();
        List<Account> accounts = new List<Account>([SELECT Id, Name FROM Account WHERE (Name IN :pEmailAddresses)]);
        if(CT_Utility.ValidateList(accounts)){
			System.debug(LoggingLevel.INFO, METHODNAME + ' :: found '+ accounts.size() +' Accounts with email match for Name.\n\n');
			for(Account acct:accounts)
                EmailToAccountMap.put(acct.Name.toLowerCase(), acct);
		}
        return EmailToAccountMap;
    }
	
/* =============================================  TEST METHODS  ============================================= */

    private static testMethod void test_TriggerHelper_New_1(){
        CT_CaseTriggerHelper helper = CT_CaseTriggerHelper.NewTriggerHelper();
        System.assert(helper != null);
    }
    private static testMethod void test_TriggerHelper_New_2(){
        CT_CaseTriggerHelper helper = CT_CaseTriggerHelper.NewTriggerHelper();
        System.assert(helper.UserProfileName.equals(''));
    }
    private static testMethod void test_TriggerHelper_New_3(){
        CT_CaseTriggerHelper helper = CT_CaseTriggerHelper.NewTriggerHelper('TEST');
        System.assert(helper.UserProfileName.equals('TEST'));
    }

}