public with sharing class ContactService {
    public static String LZPKBName = 'LZPKB Site Guest User';
    public ContactService() 
    {
        
        
    }
    /*
    public static void processForCampaignsEntryForMobileContacts(List<Contact> newContacts)
    {
        Set<String> campaignNames = new Set<String>();
        campaignNames.add('Mobile'); 
        
        CampaignEngine theEngine = new CampaignEngine();
        List<CampaignMember> campaignMembers = theEngine.assignCampaignsForContact(newContacts, campaignNames);
        if(!campaignMembers.isEmpty())
        {
            String errorMessage = '';
            List<Database.UpsertResult> upsertResults = Database.upsert(campaignMembers , CampaignMember.Id , false);
            for(Database.UpsertResult theResult : upsertResults)
            {
                for(Database.Error theError : theResult.getErrors())
                {
                    errorMessage += theResult.getId() +'--'+theError.getMessage()+'-------';
                }
            }
            if(errorMessage != '')
            {
                SendExceptionEmail.sendGenericErrorEmal(errorMessage , 'Contact Campaign Entry Fail');
            }
        }
    }
    */

    //Realtime Call
    public static void processForCampaignsEntry(List<Contact> newContacts)
    {
        Set<String> campaignNames = new Set<String>();
        for(Campaign theCampaign : [SELECT Id , Name FROM Campaign  WHERE Category__c = :CampaignConstants.PRE_PURCHASE])
        {
               
           campaignNames.add(theCampaign.Name); 
        }
        CampaignEngine theEngine = new CampaignEngine();
        List<CampaignMember> campaignMembers = theEngine.assignCampaignsForContact(newContacts, campaignNames);
        if(!campaignMembers.isEmpty())
        {
            String errorMessage = '';
            List<Database.UpsertResult> upsertResults = Database.upsert(campaignMembers , CampaignMember.Id , false);
            for(Database.UpsertResult theResult : upsertResults)
            {
                for(Database.Error theError : theResult.getErrors())
                {
                    errorMessage += theResult.getId() +'--'+theError.getMessage()+'-------';
                }
            }
            if(errorMessage != '')
            {
                SendExceptionEmail.sendGenericErrorEmal(errorMessage , 'Contact Campaign Entry Fail');
            }
        }
    }

    public static void processForCampaignsExit(List<Contact> newContacts)
    {
        Set<String> campaignNames = new Set<String>();
        for(Campaign theCampaign : [SELECT Id , Name FROM Campaign  WHERE IsActive = true AND (Category__c = :CampaignConstants.PRE_PURCHASE OR Category__c = :CampaignConstants.POST_PURCHASE) ])
        {
            campaignNames.add(theCampaign.Name);
        }
        CampaignEngine theEngine = new CampaignEngine();
        List<CampaignMember> campaignMembers = theEngine.exitCampaignsForContact(newContacts, campaignNames);
        if(!campaignMembers.isEmpty())
        {
            String errorMessage = '';
            List<Database.UpsertResult> upsertResults = Database.upsert(campaignMembers , CampaignMember.Id , false);
            for(Database.UpsertResult theResult : upsertResults)
            {
                for(Database.Error theError : theResult.getErrors())
                {
                    errorMessage += theResult.getId() +'--'+theError.getMessage()+'-------';
                }
            }
            if(errorMessage != '')
            {
                SendExceptionEmail.sendGenericErrorEmal(errorMessage , 'Contact Campaign Exit Fail');
            }
        }
    }
 

    public static void createAccounts(List<Contact> newContacts)
    {
        Map<String,List<Account>> fkUserToListOfAccounts = new Map<String,List<Account>>();
        Map<String, Account > fkusertoAccount = new Map<String, Account>();
        Map<String,List<Contact>> fkUserToListOfContacts = new Map<String,List<Contact>>();
        for(Contact theContact : newContacts)
        {
            if(theContact.AccountId == null && theContact.FKUser__c != null)
            {
                if(!fkUserToListOfContacts.containsKey(theContact.FKUser__c))
                    fkUserToListOfContacts.put(theContact.FKUser__c , new List<Contact>());
                else{
                    fkUserToListOfContacts.get(theContact.FKUser__c).add(theContact);
                }
                
            }
        }
        List<Account> accountsToCreate = new List<Account>();
        set<Account>accountsToCreateSet = new set<Account>();
        //for(String theFKUser : fkUserToListOfContacts.keySet())
        //{
            //for(Contact theContact : fkUserToListOfContacts.get(theFKUser))
            for(Contact theContact : newContacts)
            {
               /* if(!fkUserToListOfAccounts.containsKey(theFKUser))
                    fkUserToListOfAccounts.put(theFKUser , new List<Account>());
                Account theAccount = new Account();
                //theAccount.Name = theContact.FKUser__c; // padma @D-04281
                theAccount.Name = theContact.Customer_Login_Email__c!=null?theContact.Customer_Login_Email__c :theContact.FKUser__c;
                theAccount.Customer_ID__c = theContact.FKUser__c;
                fkUserToListOfAccounts.get(theFKUser).add(theAccount);
                accountsToCreateSET.add(theAccount);*/
                
                if(fkusertoAccount.containsKey(theContact.FKUser__c)){
                   fkusertoAccount.put(theContact.FKUser__c,fkusertoAccount.get(theContact.FKUser__c));
                }
                else if(!fkusertoAccount.containsKey(theContact.FKUser__c)){
                    Account tempacc = new Account();
                	//theAccount.Name = theContact.FKUser__c; // padma @D-04281
                	tempacc.Name = theContact.Customer_Login_Email__c!=null?theContact.Customer_Login_Email__c :theContact.FKUser__c;
                	tempacc.Customer_ID__c = theContact.FKUser__c;
                    fkusertoAccount.put(theContact.FKUser__c, tempacc);
                }
                
            }
            accountsToCreate.addall(fkusertoAccount.values());
        //}
        //insert accountsToCreate;
        
        upsert accountsToCreate Customer_ID__c;
        Set<Id> usedUpAccountIds = new Set<Id>();
        //for(String theFKUser : fkUserToListOfContacts.keySet())
        //{
            for(Contact theContact : newContacts)
            {
                
                if(fkusertoAccount.containsKey(theContact.FkUser__c))
                {
                    theContact.AccountId = fkusertoAccount.get(theContact.FkUser__c).Id;
                    
                   // for(Account theAccount : fkusertoAccount.get(theFKUser))
                    //{
                       /* if(!usedUpAccountIds.contains(fkusertoAccount.get(theFKUser).Id))
                        {
                            theContact.AccountId = fkusertoAccount.get(theFKUser).Id;
                            usedUpAccountIds.add(fkusertoAccount.get(theFKUser).Id);
                            break;
                        }*/
                    //}
                }
            }
        //}
    }

    public static void  populateCustomerLoginEmail(List<Customer_Login__c> customerLogins)
    {
        Map<String,String> customerNumberToCustomerLoginEmail = new Map<String,String>();
        for(Customer_Login__c theLogin : customerLogins)
        {
            if(theLogin.Customer_ID__c != null && theLogin.Name != null)
            {
                customerNumberToCustomerLoginEmail.put(theLogin.Customer_ID__c , theLogin.Name);
            }
        }
        List<Contact> contactsToUpdate = new List<Contact>();
        if(!customerNumberToCustomerLoginEmail.isEmpty())
        {
            for(Contact theContact : [SELECT Id , FKUser__c , Customer_Login_Email__c FROM Contact WHERE FKUser__c = :customerNumberToCustomerLoginEmail.keySet()])
            {
                if(theContact.Customer_Login_Email__c == null)
                {
                    theContact.Customer_Login_Email__c = customerNumberToCustomerLoginEmail.get(theContact.FKUser__c);
                    contactsToUpdate.add(theContact);
                }
            }
            
        }
        if(!contactsToUpdate.isEmpty())
        {
            try
            {
                update contactsToUpdate;
            }
            catch(DmlException dmlEx)
            {
                SendExceptionEmail.sendDMLExceptionEmail(dmlEx , 'Failed updating Contact With Customer Login Email');
            }
        }
    }

    public static void updateCustomerLoginFromContact(List<Contact> contacts)
    {
        Set<String> customerNumbers = new Set<String>();
        for(Contact theContact : contacts)
        {
            if(theContact.FKUser__c != null)
            {
                customerNumbers.add(theContact.FKUser__c);
            }
        }
        Map<String,String> customerNumberToCustomerLoginEmail = new Map<String,String>();
        for(Customer_Login__c theLogin : [SELECT Id, Customer_ID__c , Name FROM Customer_Login__c WHERE Customer_ID__c IN :customerNumbers])
        {
           customerNumberToCustomerLoginEmail.put(theLogin.Customer_ID__c , theLogin.Name);
        }
        for(Contact theContact : contacts)
        {
            if(string.isBlank(theContact.Customer_Login_Email__c)){ // Added for Story - B39269
                theContact.Customer_Login_Email__c = customerNumberToCustomerLoginEmail.get(theContact.FKUser__c);
            }
        }
    }

    public static void processContactByContactStatus(Map<Id,Contact> oldContacts , Map<Id,Contact> newContacts)
    {
        List<Contact> contactStatusChanged = new List<Contact>();
        for(Contact newContact : newContacts.values())
        {
            
            Contact oldContact = oldContacts.get(newContact.Id);
            if(oldContact.Contact_Status__c != newContact.Contact_Status__c)
            {
                contactStatusChanged.add(newContact);
            }
            
        }
        if(!contactStatusChanged.isEmpty())
        {
            processForCampaignsExit(contactStatusChanged);
        }
    }
    
    public static void populateInitialProduct(List<Contact> contacts)
    {
        for(Contact theContact : contacts)
        {
            if(theContact.Initial_Product__c == null)
                theContact.Initial_Product__c = theContact.Product2__c;
                
        }
    }       
    public static void populateTealiumChanges(Map<Id,Contact> oldContacts , Map<Id,Contact> newContacts)
    {
        for(Contact newContact : newContacts.values())
        {
            Map<String, Map<String, String>> changes = new Map<String, Map<String, String>>();
            if(newContact.Updated_By_Tealium__c)
            {
                Contact oldContact = oldContacts.get(newContact.Id);
                
                for(Schema.FieldSetMember fsm : UtilityLibrary.getContactTealiumUpdateFields())
                {
                    Object oldVal = oldContact.get(fsm.fieldPath);
                    Object newVal = newContact.get(fsm.fieldPath);
                    
                    if(oldVal != newVal)
                    {
                        Map<String, String> fieldMap = new Map<String, String>();
                        fieldMap.put(String.valueOf(oldVal), String.valueOf(newVal));
                        changes.put(fsm.label, fieldMap);
                    }
                }
                String jsonStr = JSON.serialize(changes);
                if(jsonStr.length()<=255)
                    newContact.Tealium_Updates__c = jsonStr;
            } 
        }
    }
    
    //@B-35598 Artyom
    public static void checkIfPhoneNumberChanged(Map<Id,Contact> oldContactsMap , List<Contact> newContactsList) {
        System.Debug('Inside checkIfPhoneNumberChanged');
        for (Contact cnt : newContactsList) {
            if (cnt.Internal_List__c == true) {
                if (cnt.Phone != null && cnt.Phone != oldContactsMap.get(cnt.Id).Phone) {
                    System.Debug('Phone Changed');
                    String formattedPhoneNumber = PhoneFormatter.formatPhone(cnt.Phone);
                    DNCService_ltng.numberToInternalList(formattedPhoneNumber);
                }
                if (cnt.HomePhone != null && cnt.HomePhone != oldContactsMap.get(cnt.Id).HomePhone) {
                    System.Debug('HomePhone Changed');
                    String formattedPhoneNumber = PhoneFormatter.formatPhone(cnt.HomePhone);
                    DNCService_ltng.numberToInternalList(formattedPhoneNumber);
                }
                if (cnt.MobilePhone != null && cnt.MobilePhone != oldContactsMap.get(cnt.Id).MobilePhone) {
                    System.Debug('MobilePhone Changed');
                    String formattedPhoneNumber = PhoneFormatter.formatPhone(cnt.MobilePhone);
                    DNCService_ltng.numberToInternalList(formattedPhoneNumber);
                }
                if (cnt.OtherPhone != null && cnt.OtherPhone != oldContactsMap.get(cnt.Id).OtherPhone) {
                    System.Debug('OtherPhone Changed');
                    String formattedPhoneNumber = PhoneFormatter.formatPhone(cnt.OtherPhone);
                    DNCService_ltng.numberToInternalList(formattedPhoneNumber);
                }
            }
            
        }
    }

    // Added for Story - B39269 - Starts Here
    public static void ContactCustomerLoginAssociation(Map < Id, Contact > newContsMap, Map< Id, Contact > oldContsMap) {
 	 try {
 	  Map < string, Contact > fkUserContactMap = new Map < String, Contact > ();
 	  Map < String, Customer_Login__c > custLoginFKuserMap = new Map < String, Customer_Login__c > ();
 	  List < Customer_Login__c > updateCustLoginList = new List < Customer_Login__c > ();
 	  List < Customer_Login__c > insertCustLoginList = new List < Customer_Login__c > ();
 	  Customer_Login__c custLogin;
 	  boolean containsFlag;

 	  if (newContsMap != null && !newContsMap.isEmpty() && newContsMap.size() > 0) {
 	   for (Contact con: newContsMap.values()) {
       	if((Trigger.isInsert && String.isNotBlank(con.FKUser__c) && con.Contact_Type__c.equalsIgnoreCase('Primary Contact') )){
         fkUserContactMap.put(con.FKUser__c,con);
        } else if (Trigger.isUpdate && String.isNotBlank(con.FKUser__c) && con.Contact_Type__c.equalsIgnoreCase('Primary Contact') && (con.FKUser__c != oldContsMap.get(con.Id).FKUser__c || con.Contact_Type__c != oldContsMap.get(con.Id).Contact_Type__c)){
         fkUserContactMap.put(con.FKUser__c,con);  
        }
 	   }

 	   if (!fkUserContactMap.isEmpty() && fkUserContactMap != null && fkUserContactMap.size() > 0) {
 	    for (Customer_Login__c cl: [SELECT Id, Primary_Contact__c, Customer_ID__c FROM Customer_Login__c WHERE Customer_ID__c IN: fkUserContactMap.keySet() LIMIT 1000]) {
 	     custLoginFKuserMap.put(cl.Customer_ID__c, cl);
 	    }

 	    for (contact con: fkUserContactMap.values()) {

 	     if (custLoginFKuserMap.size() > 0 && custLoginFKuserMap != null && !custLoginFKuserMap.isEmpty()) {
 	      containsFlag = false;
          containsFlag = custLoginFKuserMap.containsKey(con.FKUser__c);
 	      if (containsFlag) {
 	       custLogin = new Customer_Login__c();
 	       custLogin = custLoginFKuserMap.get(con.FKUser__c);
 	       if (custLogin.Primary_Contact__c != con.Id) {
 	        custLogin.Primary_Contact__c = con.Id;
 	        updateCustLoginList.add(custLogin);
 	       }
 	      }
 	     }

 	     if (custLoginFKuserMap.isEmpty() || custLoginFKuserMap == null || (!containsFlag)) {
 	      insertCustLoginList.add(new Customer_Login__c(Customer_ID__c = con.FkUser__c, Primary_Contact__c = con.Id, Name = con.Customer_Login_Email__c));
 	     }
 	    }
 	   }
 	  }

 	  if (updateCustLoginList.size() > 0 && updateCustLoginList != null && !updateCustLoginList.isEmpty()) {
 	   Database.update(updateCustLoginList, false);
 	  }
 	  if (insertCustLoginList.size() > 0 && insertCustLoginList != null && !insertCustLoginList.isEmpty()) {
 	   Database.insert(insertCustLoginList, false);
 	  }

 	 } catch (Exception e) {
 	  SendExceptionEmail_ltng.createErrorLog(e.getMessage(), e.getLineNumber(), e.getStackTraceString(), null, null, null, null, null, UserInfo.getUserId());
 	 }
 	}
    // Added for Story - B39269 - Ends Here  
}