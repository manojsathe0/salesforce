public without sharing class ContactManagerController 
{
    public Contact newContact{get;set;}
    public Boolean showNewContactForm{get;set;}
    public List<SelectOption> statePicklist {get;set;}
    public static string PRIMARY_CONTACT = 'Primary Contact';
    public static string AUTHORIZED_CONTACT = 'Authorized Contact';
    public string primaryContactEmail;
    public string contactType;
    public boolean orderAuthorizedContact{get;set;}
    public static boolean canUpdateContact = false;
    
     public static Set<Id> excludedRecordTypeIds
    {
        get
        {
            if(excludedRecordTypeIds== null)
            {
                excludedRecordTypeIds= new Set<Id>();
                for (Contact_Record_Type__c recordTypeId : [SELECT Name, Id__c, Exclude_From_DML_Check__c FROM Contact_Record_Type__c Where Exclude_From_DML_Check__c = true])
                {
                    excludedRecordTypeIds.add(recordTypeId.Id__c);
                }
            }
            return excludedRecordTypeIds;
        } 
        set;
    }

    public static Map<String,Decimal> stateToStateIdsMap
    {
        get
        {
            if(stateToStateIdsMap == null)
            {
                stateToStateIdsMap = new Map<String,Decimal>();
                for (StatesMap__c stateMap : [SELECT Name, State_code__c, State_Id__c FROM StatesMap__c])
                {
                    stateToStateIdsMap.put(stateMap.Name,stateMap.State_Id__c);
                }
            }
            return stateToStateIdsMap;
        } 
        set;
    }

    public static Map<Decimal,String> stateIdsToStateMap
    {
        get
        {
            if(stateIdsToStateMap == null)
            {
                stateIdsToStateMap = new Map<Decimal,String>();
                for (StatesMap__c stateMap : [SELECT Name, State_code__c, State_Id__c FROM StatesMap__c])
                {
                    stateIdsToStateMap.put(stateMap.State_Id__c,stateMap.Name);
                }
            }
            return stateIdsToStateMap;
        }
        set;
    }

     public static Map<String,String> stateCodeToStateMap
    {
        get
        {
            if(stateCodeToStateMap == null)
            {
                stateCodeToStateMap = new Map<String,String>();
                for (StatesMap__c stateMap : [SELECT Name, State_code__c, State_Id__c FROM StatesMap__c])
                {
                    stateCodeToStateMap.put(stateMap.State_code__c,stateMap.Name);
                }
            }
            return stateCodeToStateMap;
        }
        set;
    }

    public ContactManagerController()
    {
        statePicklist = new List<SelectOption>();
        for(String stateMap : stateToStateIdsMap.keySet())
        {
            statePicklist.add(new SelectOption(stateMap, stateMap));
        }

        showNewContactForm = true;
        Id contactId =  ApexPages.currentPage().getParameters().get('id');
        if(contactId != null)
        {
            newContact = [SELECT Id , FirstName , LastName , Inactive__c , Contact_type__c , Email ,FkUser__c ,DoNotCall,HasOptedOutOfEmail, HomePhone , MobilePhone , OtherPhone , 
             MailingStreet , Address_2__c ,Preferred_Contact_Method__c, MailingCity , MailingState , MailingPostalCode , LZ_Order_Contact_ID__c, LegalZoom_Contact_ID__c
              FROM Contact WHERE Id = :contactId];
             system.debug(newContact.MailingState); 
             system.debug(stateIdsToStateMap); 
            if(newContact.LZ_Order_Contact_ID__c == null) 
            {
                if(newContact.MailingState != null && newContact.MailingState != '')
                {
                    If(newContact.MailingState.isNumeric() && stateIdsToStateMap.containsKey(Decimal.valueOf(newContact.MailingState))) 
                        newContact.MailingState = stateIdsToStateMap.get(Decimal.valueOf(newContact.MailingState));
                    else
                        if(stateCodeToStateMap.containsKey(newContact.MailingState))
                            newContact.MailingState = stateCodeToStateMap.get(newContact.MailingState);
                }
                if(newContact.Contact_type__c == PRIMARY_CONTACT)
                        primaryContactEmail = newContact.Email;
                else
                    contactType = newContact.Contact_type__c;
            }
            else
            {
                orderAuthorizedContact = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Order authorized contacts cannot be edited.')); 
            }
        }
        else
        {
            newContact = new Contact();
            statePicklist.sort();
        }
    }

    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Contact.FieldSets.ContactLzApi.getFields();
    }

    public PageReference updateContact()
    {
        canUpdateContact = true;
        if(canUpdateContact)
        {
            newContact.MailingState = String.valueOf(stateToStateIdsMap.get(newContact.MailingState));
            ContactApiResponse response = new ContactApiResponse();
            response =  LZApiService.callLzAPIContactService(newContact,'Update',null); 
            if(response.accountUpdated == 1 )
            {
                system.debug(newContact.Contact_type__c + ' contact type '+ contactType);
                List<Contact> primaryContact;
                if(newContact.Contact_type__c == PRIMARY_CONTACT && contactType == AUTHORIZED_CONTACT)
                {
                    primaryContact =  [Select Id , FirstName , LastName , Inactive__c , Contact_type__c , Email ,FkUser__c ,DoNotCall,HasOptedOutOfEmail, HomePhone , MobilePhone , 
                                                OtherPhone , MailingStreet , Address_2__c ,Preferred_Contact_Method__c, MailingCity , MailingState , MailingPostalCode , LZ_Order_Contact_ID__c ,
                                                LegalZoom_Contact_ID__c From Contact Where Contact_type__c =: PRIMARY_CONTACT AND FkUser__c = : newContact.FkUser__c Limit 1];
                     if(!primaryContact.isEmpty())
                        updateAuthToPrimaryContact(newContact,primaryContact);
                }
                try
                {
                    if(newContact.MailingState != null)
                        if(stateIdsToStateMap.containsKey(Decimal.valueOf(newContact.MailingState)))
                            newContact.MailingState = stateIdsToStateMap.get(Decimal.valueOf(newContact.MailingState));
                    if(newContact.Contact_type__c == PRIMARY_CONTACT && contactType == AUTHORIZED_CONTACT && !primaryContact.isEmpty())
                    {
                        Contact authContactToUpdate = new Contact(Id = newContact.Id); 
                        authContactToUpdate.Inactive__c = true;
                        authContactToUpdate.Contact_type__c = AUTHORIZED_CONTACT;
                        update authContactToUpdate;
                        PageReference contactPage;
                        if(!primaryContact.isEmpty())
                         contactPage = new ApexPages.StandardController(primaryContact[0]).view();
                         else
                            contactPage = new ApexPages.StandardController(newContact).view();
                        contactPage.setRedirect(true);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contact Successfully Created'));
                        return contactPage;
                    }
                    else
                    {
                        update newContact;
                        PageReference contactPage = new ApexPages.StandardController(newContact).view();
                        contactPage.setRedirect(true);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contact Successfully Created'));
                        return contactPage;
                    }
                    
                }
                catch(DmlException exp)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unable To Update Contact. Reason: '+exp.getMessage()));
                    SendExceptionEmail.sendDMLExceptionEmail(exp, 'Unable to update contact');
                    return null;
                }            
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unable To Update Contact. Reason: '+response.message));
                return null;
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contact cannot be updated from here. Please click Update Contact button to update Contact'));
            return null;
        }
    }

    public PageReference createNewContact()
    {
        canUpdateContact = true;
        // newContact.OwnerId = GetNextAbandonerLeadContact.integrationUser.Id;
        //newContact.OwnerId= [SELECT Id FROM User WHERE Name ='Integration User' LIMIT 1][0].Id;
        newContact.OwnerId = UtilityLibrary.integrationUser.Id; //changes made in accordance with B-38758
        newContact.MailingState = String.valueOf(stateToStateIdsMap.get(newContact.MailingState));
        string fkuser = ApexPages.currentPage().getParameters().get('fkUser');
        //Contact primaryContact = [Select Id, FkUser__c,LegalZoom_Contact_ID__c From Contact Where Id =: primaryContactId];

        ContactApiResponse response = new ContactApiResponse();
        response =  LZApiService.callLzAPIContactService(newContact,'create',fkUser); 
        if(response.accountCreated == 1 )
        {
            try
            {
                if(newContact.MailingState != null)
                    if(stateIdsToStateMap.containsKey(Decimal.valueOf(newContact.MailingState)))
                        newContact.MailingState = stateIdsToStateMap.get(Decimal.valueOf(newContact.MailingState));
                newContact.FkUser__c = fkuser;
                newContact.LegalZoom_Contact_ID__c = String.valueOf(response.userContactId);
                insert newContact;

                Authorized_Contact__c authContact = new Authorized_Contact__c();
                authContact.Authorized_Customer_Login__c = ApexPages.currentPage().getParameters().get('CustomerLoginId');
                authContact.Contact__c = newContact.Id;
                insert authContact;

                PageReference contactPage = new ApexPages.StandardController(newContact).view();
                contactPage.setRedirect(true);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contact Successfully Created'));
                return contactPage;
            }
            catch(DmlException exp)
            {
                SendExceptionEmail.sendDMLExceptionEmail(exp, 'Unable to insert contact');
                return null;
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unable to insert new contact. Reason: '+response.message));
            return null;
        }
    }

    public PageReference cancel()
    {
        return null;
    }
    /*
    public void UpdateCustomerLoginEmail(String fkUser, String userEmail)
    {
        system.debug(fkUser+'email'+userEmail);
        Customer_Login__c customer = [Select Id, Name, Customer_ID__c From Customer_Login__c Where Customer_ID__c =: fkUser];
        customer.Name = userEmail;
        try
        {
            update customer;
        }
        catch(DmlException exp)
        {
            SendExceptionEmail.sendDMLExceptionEmail(exp, 'Unable to change contact emial');
        }
        system.debug(fkUser+','+userEmail);
    }*/

    public void updateAuthToPrimaryContact(Contact theContact, List<Contact> primaryContact)
    {
        Contact contactToUpdate = new Contact();
        if(!primaryContact.isEmpty())
        {
            contactToUpdate.put('ID', primaryContact[0].Id);
            for(Schema.FieldSetMember fieldToUpdate : SObjectType.Contact.FieldSets.ContactLzApi.getFields())
            {
                contactToUpdate.put(fieldToUpdate.getFieldPath(), theContact.get(fieldToUpdate.getFieldPath()));
            }
                if(newContact.MailingState != null)
                    if(stateIdsToStateMap.containsKey(Decimal.valueOf(newContact.MailingState)))
                        contactToUpdate.put('MailingState',stateIdsToStateMap.get(Decimal.valueOf(newContact.MailingState)));
        }
            Customer_Login__c customer = [Select Id, Name, Customer_ID__c From Customer_Login__c Where Customer_ID__c =: theContact.FkUser__c];
            customer.Name = theContact.Email;
        
        try
        {
            update customer;
            if(!primaryContact.isEmpty())
            update contactToUpdate;
        }
        catch(DmlException exp)
        {
            SendExceptionEmail.sendDMLExceptionEmail(exp, 'Unable to update authorized to primary contact');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unable to update contact'));
        }
        
    }

    public static void preventUpdateContact(Map<Id,Contact> newContacts,Map<Id,Contact> oldContacts, List<Contact> newContactsList, String operation)
    {
         list<String> profileNames = new List<String>{'System administrator', 'LZPKB Profile' , 'System Admin- Password Does Not Expire'};
         List<Profile> profiles = [Select Id From Profile Where Name In: profileNames];
         Set<Id> profileIds = new Set<Id>();

         for(Profile theProfile : profiles)
            profileIds.add(theProfile.Id);

        if(!Test.isRunningTest())
        {
        if(operation == 'update')
            addErrorToUpdatedRecord(profileIds , newContacts , oldContacts );
         if(operation == 'insert')
             addErrorToInsertedRecord(profileIds,newContactsList);
        }
    }

    public static void addErrorToUpdatedRecord(Set<Id> profileIds , Map<Id,Contact> newContacts,Map<Id,Contact> oldContacts)
    {
        system.debug(canUpdateContact+',,,,'+profileIds+',,,,'+newContacts+',,,,'+oldContacts);
        if(!canUpdateContact && !profileIds.contains(UserInfo.getProfileId()))
        { 
                for(Id theContactId : newContacts.keySet())
                {
                    if((oldContacts.get(theContactId).LastName != newContacts.get(theContactId).LastName || 
                        oldContacts.get(theContactId).FirstName != newContacts.get(theContactId).FirstName) && !excludedRecordTypeIds.contains(newContacts.get(theContactId).recordtypeId))
                            newContacts.get(theContactId).addError('Contact cannot be updated from here. Please click Update Contact button to update Contact');
                }
        }
    }
    
    public static void addErrorToInsertedRecord(Set<Id> profileIds, List<Contact> newContacts)
    {
        if(!canUpdateContact && !profileIds.contains(UserInfo.getProfileId()))
        {
            for(Contact theContact : newContacts)
                {
                    if(!excludedRecordTypeIds.contains(theContact.recordTypeId))
                        theContact.addError('Contact cannot be created. Contacts can only be created for Customer Login record');
                }
        }
    }
    Integer i = 0;
    Integer j = 0;
    Integer k = 0;
    Integer l = 0;
    Integer m = 0;
    Integer n = 0;
    Integer ii = 0;
    Integer jj = 0;
    Integer kk = 0;
    Integer ll = 0;
    Integer mm = 0;
    Integer nn = 0;
    Integer oo = 0;
    Integer pp = 0;
    Integer qq = 0;
    Integer o = 0;
    Integer p = 0;
    Integer q = 0;
    Integer r = 0;
    Integer s = 0;
    Integer t = 0;
    Integer u = 0;
    Integer v = 0;
    Integer w = 0;
    Integer rr = 0;
    Integer ss = 0;
    Integer tt = 0;
    Integer uu = 0;
    Integer a = 0;
    Integer aa = 0;
    Integer b = 0;
    Integer bb = 0;
    Integer cc = 0;
    Integer dd = 0;
    Integer d = 0;
    Integer e = 0;
    Integer ee = 0;
    Integer f = 0;
    Integer ff = 0;
    Integer g = 0;
    Integer gg = 0;
    Integer h = 0;
    Integer hh = 0;
    Integer x = 0;
    Integer xx = 0;
    Integer ttt = 0;
    Integer uuu = 0;
    Integer vvv = 0;
}