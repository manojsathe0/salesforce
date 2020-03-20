public without sharing class DuplicateChecker
{
    static Map<String,List<Contact>> phoneNumberToListOfContacts;
    static Map<String,List<Contact>> emailToListOfContacts;
    static Map<String,List<Contact>> fkUserToListOfContacts;
    static Map<String,List<Lead>> phoneNumberToListOfLeads;
    static Map<String,List<Lead>> emailToListOfLeads;
    static Map<String,List<Lead>> fkUserToListOfLeads;
    static Map<Id, Lead> leadIdToLeadMap; 
    static Map<Id, Id> contactIdToAccountIdMap;
    static Map<Id, Account> accountIdToAccountMap;
    public static Set<Id> convertedContactIds = new Set<Id>();
    public static Boolean NoDuplicateCheck = false;
    public final static String PRIMARY_CONTACT = 'Primary Contact';
    public final static String WEB = 'Web';

    
    public DuplicateChecker() 
    {
        
    }

    public static void findMatchingLeadsByContacts(List<Contact> newContacts)
    {
    	System.Debug('Invoked DuplicateChecker');
        Map<Id,Contact> queriedContacts = new Map<Id,Contact>([SELECT Id, HomePhone ,FKUser__c , Email , AccountId FROM Contact WHERE Id IN :newContacts AND Contact_Type__c = :PRIMARY_CONTACT]);
        if(!queriedContacts.isEmpty())
        {
        	/*
               Per Story: B-24112	
               By Artyom M.
               Updating the Contact Owner
            */
        	contactIdToAccountIdMap = new Map<Id, Id>();
        	for (Contact cnt : queriedContacts.values()) {
        		contactIdToAccountIdMap.put(cnt.Id, cnt.AccountId);
        	}
        	accountIdToAccountMap = new Map<Id, Account>([SELECT Id, OwnerId FROM Account WHERE Id IN: contactIdToAccountIdMap.values()]);
        	
        	System.Debug('queriedContacts.size() = ' + queriedContacts.size());
            populateContactMaps(queriedContacts.values());
            Map<Id,List<Id>> contactIdToMatchingLeads = getContactIdTomatchingLeads();
            convertLeads(contactIdToMatchingLeads , queriedContacts);
        }
        
    }

    
    public static void populateContactMaps(List<Contact> incomingContacts)
    {
        phoneNumberToListOfContacts = new Map<String,List<Contact>>();
        emailToListOfContacts = new Map<String,List<Contact>>();
        fkUserToListOfContacts = new Map<String,List<Contact>>();
        
        for(Contact theContact :incomingContacts)
        {
            if(theContact.FkUser__c != null)
            {
                if(!fkUserToListOfContacts.containsKey(theContact.FkUser__c))
                {
                    fkUserToListOfContacts.put(theContact.FkUser__c , new List<Contact>());
                }
                fkUserToListOfContacts.get(theContact.FkUser__c).add(theContact);
            }
            if(theContact.Email != null)
            {
                String lowerCaseEmail = theContact.Email.toLowerCase();
                if(!emailToListOfContacts.containsKey(lowerCaseEmail))
                {
                    emailToListOfContacts.put(lowerCaseEmail , new List<Contact>());
                }
                emailToListOfContacts.get(lowerCaseEmail).add(theContact);
            }

            if(theContact.HomePhone != null)
            {
                if(!phoneNumberToListOfContacts.containsKey(theContact.HomePhone))
                {
                    phoneNumberToListOfContacts.put(theContact.HomePhone , new List<Contact>());
                }
                phoneNumberToListOfContacts.get(theContact.HomePhone).add(theContact);
            }
        }
    }

    public static Map<Id,List<Id>> getContactIdTomatchingLeads()
    {
        Map<Id,List<Id>> contactIdToMatchingLeads = new Map<Id,List<Id>>();
        Set<Id> leadIdsToConvert = new Set<Id>();
        List<Lead> queriedLeads = [SELECT Id , Phone , Email ,FkUser__c , OwnerId FROM Lead WHERE (Phone IN : phoneNumberToListOfContacts.keySet() OR Email IN :emailToListOfContacts.keySet() OR 
                                  FKUser__c IN :fkUserToListOfContacts.keySet()) AND IsConverted = false AND LastModifiedDate >= :dateRange ORDER BY LastModifiedDate Desc];
        leadIdToLeadMap = new Map<Id, Lead>();

        
        for(Lead theLead : queriedLeads)
        {
        	leadIdToLeadMap.put(theLead.id, theLead);//per story: B-24112
        	
            if(theLead.FKUser__c != null && fkUserToListOfContacts.containsKey(theLead.FKUser__c))
            {
                for(Contact theContact : fkUserToListOfContacts.get(theLead.FKUser__c))
                {
                    if(!contactIdToMatchingLeads.containsKey(theContact.Id))
                    {
                        contactIdToMatchingLeads.put(theContact.Id , new List<Id>());
                    }
                    if(!leadIdsToConvert.contains(theLead.Id))
                    {
                        contactIdToMatchingLeads.get(theContact.Id).add(theLead.Id);
                        leadIdsToConvert.add(theLead.Id);
                        break;
                    }
                    
                }
            }

            if(theLead.Email != null)
            {

                String lowerCaseEmail = theLead.Email.toLowerCase();
                if(emailToListOfContacts.containsKey(lowerCaseEmail))
                {
                                      
                    for(Contact theContact : emailToListOfContacts.get(lowerCaseEmail))
                    {
                        if(!contactIdToMatchingLeads.containsKey(theContact.Id))
                        {
                            contactIdToMatchingLeads.put(theContact.Id , new List<Id>());
                        }
                        if(!leadIdsToConvert.contains(theLead.Id))
                        {
                            contactIdToMatchingLeads.get(theContact.Id).add(theLead.Id);
                            leadIdsToConvert.add(theLead.Id);
                            break;
                        }

                    }
                }
            }    
            if(theLead.Phone != null && phoneNumberToListOfContacts.containsKey(theLead.Phone))
            {
                for(Contact theContact : phoneNumberToListOfContacts.get(theLead.Phone))
                {
                    if(!contactIdToMatchingLeads.containsKey(theContact.Id))
                    {
                        contactIdToMatchingLeads.put(theContact.Id , new List<Id>());
                    }
                    if(!leadIdsToConvert.contains(theLead.Id))
                    {
                        contactIdToMatchingLeads.get(theContact.Id).add(theLead.Id);
                        leadIdsToConvert.add(theLead.Id);
                        break;
                    }

                }
            }
        
        }
        return contactIdToMatchingLeads;
    }

    public static void convertLeads(Map<Id,List<Id>> contactIdToMatchingLeads , Map<Id,Contact> queriedContacts)
    {
    	Map<Id, Contact> idToContactMap = new Map<Id, Contact>();
    	Map<Id, Account> idToAccountMap = new Map<Id, Account>();
    	
    	Set<Contact> contactsToUpdate = new Set<Contact>();
    	Set<Account> accountsToUpdate = new Set<Account>(); 
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        List<id> leadidsfordnc = new List<id>();
        for(Id contactId :contactIdToMatchingLeads.keySet())
        {
            for(Id leadId : contactIdToMatchingLeads.get(contactId))
            {
                Id accountId = queriedContacts.get(contactId).AccountId;
                if(accountId != null)
                {
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.setLeadId(leadId);
                    leadidsfordnc.add(leadId);
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    lc.setDoNotCreateOpportunity(true);
                    lc.setContactId(contactId);
                    lc.setAccountId(accountId);
                    leadConverts.add(lc);
                    
                    /*
                    Per Story: B-24112	
                    By Artyom M.
                    Updating the Contact Owner
                    */
                    if (leadIdToLeadMap.get(leadId) != null) {
                    	Contact cnt = queriedContacts.get(contactId);
	                    cnt.ownerId = leadIdToLeadMap.get(leadId).ownerId;
	                    System.Debug('New owner ID: ' + leadIdToLeadMap.get(leadId).ownerId);
	                    /*
	                    if(idToContactMap.get(cnt.Id) == null) {
	                    	
	                    }
	                    */
	                    idToContactMap.put(cnt.Id, cnt);
						//contactsToUpdate.add(cnt);
						
						Account acnt = accountIdToAccountMap.get(cnt.AccountId);
						acnt.OwnerId = leadIdToLeadMap.get(leadId).ownerId;
						/*
						if (idToAccountMap.get(acnt.Id) == null) {
							
						}
						*/
						idToAccountMap.put(acnt.Id, acnt);
						
						//accountsToUpdate.add(acnt);	
                    }
                    
                }
            }
        }
        if(!leadConverts.isEmpty())
        {
            try
            {
                List<Database.LeadConvertResult> lcr = Database.convertLead(leadConverts , false);
                System.debug('Converted '+lcr);
                String emailBody = '';
                for(Database.LeadConvertResult theResult : lcr)
                {
                    if(!theResult.isSuccess())
                    {
                        List<Database.Error> theErrors = theResult.getErrors();
                        for(Database.Error theError : theErrors)
                        {
                            emailBody += theError.getMessage();
                        }
                    }
                }
                
                  List<lead> leadsinternal =[select Internal_List__c, ConvertedContactId  from lead where Internal_List__c=true AND IsConverted=true AND id IN :leadidsfordnc ];
                  
                //@Sai
                List<id> contactids = new List<id>();
                for (lead leadinternal : leadsinternal) {
                    contactids.add(leadinternal.ConvertedContactId);
                    // DNCController_ltng.PostDncIntetnal(leadinternal.ConvertedContactId, null, null);
                }
                if (!contactids.isEmpty())
                    DNCController_ltng.PostDNCNumberBulk(contactids, true);
                //END -- Sai

                if(emailBody != '')
                    SendExceptionEmail.sendGenericErrorEmal(emailBody , 'Lead Conversion Fail');
            }
            catch(DMLException  dmlEx)
            {
                SendExceptionEmail.sendDMLExceptionEmail(dmlEx , 'LeadConversion Error-DuplicateChecker');
            }
        }
        /*
                    Per Story: B-24112	
                    By Artyom M.
                    Updating the Contact Owner
         */
         //START
        if(!idToContactMap.isEmpty()) {
        	try {
        		update idToContactMap.values();
        	}
        	catch(DMLException  dmlEx)
            {
            	System.Debug('Error happened: ' + dmlEx.getMessage());
            }
        	
        }
        
        if(!idToAccountMap.isEmpty()) {
        	try {
        		update idToAccountMap.values();
        	}
        	catch(DMLException  dmlEx)
            {
            	System.Debug('Error happened: ' + dmlEx.getMessage());
            }
        	
        }
        //END
    }
    
    public static Id getLeadOrContact(Lead incomingLead , MessageInfo theMessage)
    {
        Id theId;
        List<Lead> leads = new List<Lead>();
        List<Contact> contacts = new List<Contact>();
        //Ignore matching on the FKUser_c until Tealium stops sending the request with wrong user id
        /*
        if(incomingLead.FKUser__c != null)
        {
            
            contacts = [SELECT Id , AccountId FROM Contact WHERE FKUser__c =:incomingLead.FKUser__c AND Contact_Type__c = :PRIMARY_CONTACT];
            
        }
        Set<Id> leadIdsToConvert = new Set<Id>();

        if(!contacts.isEmpty())
        {
            theId = contacts[0].Id;
            theMessage.matchedField = 'FKUser';
            callContactCampaignAssign(contacts[0] , theMessage.userOrderId);
            if(contacts[0].AccountId != null)
            {
                leads = [SELECT Id FROM Lead WHERE IsConverted = false AND Tealium_Id__c = :incomingLead.Tealium_Id__c];
                if(!leads.isEmpty())
                {
                    for(Lead theLead : leads)
                        leadIdsToConvert.add(theLead.Id);
                    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1]; 
                    List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
                    if(!leadIdsToConvert.isEmpty())
                    {
                        for(Id theLeadId : leadIdsToConvert)
                        {
                            Database.LeadConvert lc = new Database.LeadConvert();
                            lc.setLeadId(theLeadId);
                            lc.setConvertedStatus(convertStatus.MasterLabel);
                            lc.setDoNotCreateOpportunity(true);
                            lc.setContactId(contacts[0].Id);
                            lc.setAccountId(contacts[0].AccountId);
                            leadConverts.add(lc);
                        }
                        if(!leadConverts.isEmpty())
                        {
                            List<Database.LeadConvertResult> lcr = Database.convertLead(leadConverts);
                        }
                    }
                }
            }
        }
        */
        if(theId == null)
        {
            if(incomingLead.Tealium_Id__c != null)
            {
                leads = [SELECT Id , FKUser__c , Email , Phone FROM Lead WHERE  IsConverted = false AND Tealium_Id__c = :incomingLead.Tealium_Id__c limit 1];
                if(!leads.isEmpty())
                {
                    theId = leads[0].Id;
                    theMessage.matchedField = 'TealiumId';
                    callLeadCampaignAssign(leads[0]);
                }
            }
           
        }
        Set<String> emails = new Set<String>();
        Set<String> phoneNumbers = new Set<String>();
        String searchString = '';
        if(theId == null)
        {
            
            if(incomingLead.Email != null && incomingLead.Email.length() > 5)
            {
                emails.add(incomingLead.Email);
                searchString += incomingLead.Email+ ' OR ';
            }
            if(incomingLead.Phone != null && incomingLead.Phone.length() > 8)
            {
                incomingLead.Phone = PhoneFormatter.formatPhone(incomingLead.Phone);
                phoneNumbers.add(incomingLead.Phone);
                searchString += incomingLead.Phone+ ' OR ';
            }
            if(Test.isRunningTest())
            {
                contacts = [SELECT Id , Email , HomePhone FROM Contact WHERE (Email IN :emails OR HomePhone IN :phoneNumbers) AND Contact_Type__c = :PRIMARY_CONTACT];
            }
            else
            {           
                if(searchString != '')
                {
                    searchString = searchString.subString(0 , searchString.length()-3);
                    String searchquery='FIND \''+searchString+'\' IN ALL FIELDS RETURNING Contact(id,Email,HomePhone WHERE Contact_Type__c = \'Primary Contact\')'; 
                    List<List<SObject>> searchList=search.query(searchquery);
                    contacts = (List<Contact>)searchList[0];
                }
                
            }
            
            if(!contacts.isEmpty())
            {
                for(Contact theContact : contacts)
                {
                    if(theContact.Email == incomingLead.Email)
                    {
                        theId = theContact.Id;
                        theMessage.matchedField = 'Email';
                        callContactCampaignAssign(theContact , theMessage.userOrderId);
                        break;
                    }   
                }
                if(theId == null)
                {
                    if(incomingLead.Phone != null)
                    {
                        for(Contact theContact : contacts)
                        {
                            if(theContact.HomePhone == incomingLead.Phone)
                            {   
                                theId = theContact.Id;
                                theMessage.matchedField = 'Phone';
                                callContactCampaignAssign(theContact , theMessage.userOrderId);
                                break;
                            }
                        }
                    }
                }
            }
            if(theId == null)
            {   
                leads = [SELECT Id , Email , Phone , FkUser__c FROM Lead WHERE  IsConverted = false AND (Email IN :emails OR Phone IN :phoneNumbers) ORDER By LastModifiedDate Desc];
                for(Lead theLead : leads)
                {
                    if(theLead.Email == incomingLead.Email)
                    {
                        theId = theLead.Id;
                        theMessage.matchedField = 'Email';
                        callLeadCampaignAssign(theLead);
                        break;
                    }   
                }
                if(theId == null)
                {
                    if(incomingLead.Phone != null)
                    {
                        for(Lead theLead : leads)
                        {
                            if(theLead.Phone == incomingLead.Phone)
                            {   
                                theId = theLead.Id;
                                theMessage.matchedField = 'Phone';
                                callLeadCampaignAssign(theLead);
                                break;
                            }
                        }
                    }
                }
            }
        }
        
        if(theId == null)
        {
           
            incomingLead.Company = 'UNKNOWN';
            upsert incomingLead;
            callLeadCampaignAssign(incomingLead);
            theId = incomingLead.Id;
        }
       
        return theId;
    }

    public static void callContactCampaignAssign(Contact theContact , String userOrderId)
    {
        
        if(userOrderId != null && userOrderId != '')
        {
            Boolean isOrderAlreadyPlaced = false;
            isOrderAlreadyPlaced = checkIfOrderIsAlreadyPlaced(userOrderId);
            if(!isOrderAlreadyPlaced)
            {
                putContactInCampaign(theContact);
            }
        }
        else
        {
            putContactInCampaign(theContact);   
        }
    }
    
    public static void putContactInCampaign(Contact theContact)
    {
        theContact.LeadSource = WEB;      
        update theContact; ////updating to set the LastModifiedBy  before calling the campaign for Abandoner,which is one of the criteria
        ContactService.processForCampaignsEntry(new List<Contact>{theContact});
        
    }

    public static void callLeadCampaignAssign(Lead  theLead)
    {
        theLead.LeadSource = WEB;
        update theLead;//updating to set the LastModifiedBy  before calling the campaign for Abandoner,which is one of the criteria
        LeadService.processForCampaigns(new List<Lead>{theLead});
    }

    public static DateTime dateRange
    {
        get
        {
            if(dateRange == null)
            {
                if(System.isBatch())
                {
                    List<Rematching_Days__c> rematchingDays = Rematching_Days__c.getall().values();
                    if(!rematchingDays.isEmpty())
                        dateRange = DateTime.now().addDays(Integer.valueOf((rematchingDays[0].Number_of_Days__c)*(-1)));
                }
                else
                    dateRange = DateTime.now().addDays(-91);
            }
            return dateRange;
        }
        set;
    }
    
    public class messageInfo
    {
        public String matchedField{get;set;}
        public String userOrderId{get;set;}
    }
    
    public static Boolean checkIfOrderIsAlreadyPlaced(String userOrderId)
    {
        List<Order_Item__c> orderItems = [SELECT Id FROM Order_Item__c WHERE User_Order_ID__c = :userOrderId];
        return !orderItems.isEmpty();
    }

}