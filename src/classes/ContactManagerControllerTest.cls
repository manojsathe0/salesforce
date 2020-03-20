@isTest
private class ContactManagerControllerTest {
    public static Customer_Login__c customer = new Customer_Login__c();
    public static Contact theContact;
    public static Account theAccount;
    public static List<StatesMap__c> stateMap= new List<StatesMap__c>();
    
    public static Map<String,Id> developerNameToRecordTypeIds
    {
        get
        { 
            if(developerNameToRecordTypeIds == null)
            {
                List<RecordType> recordTypes = [SELECT Id,Name,DeveloperName FROM RecordType WHERE sObjectType = 'Contact'];    
                developerNameToRecordTypeIds = new Map<String,Id>();
                if(!recordTypes.isEmpty())
                {
                    for(RecordType theRecordType : recordTypes)
                    {
                        developerNameToRecordTypeIds.put(theRecordType.DeveloperName , theRecordType.Id);
                    }
                }
            }
            
            return developerNameToRecordTypeIds;
        }
        set;
    }
    
    public static void setupData()
    {
        StatesMap__c state1 = new StatesMap__c(Name = 'Texas', State_Code__c = 'TX', State_Id__c = 34);
        stateMap.add(state1);
        insert stateMap;

        theAccount = TestUtils.createAccounts(1,'TestAccount', True)[0];
        theContact = buildContactData('Primary Contact' , 'Test@test.com','9998887898',  '123 down street' , '#9900' , 'Austin' , 'TX' , '78717' , '7778889999' , '4445556666' , '1114447777');
        theContact .FkUser__c = '9999999';
        theContact.LegalZoom_Contact_ID__c = '9999999154645';
        insert theContact;

        customer.Name = 'loginEmail@legalzoom.com';
        customer.Customer_ID__c = '59999999675';
        customer.Primary_COntact__c = theContact.Id;
        insert customer;
        
        External_Endpoint__c newEndPoint = new External_Endpoint__c();
        newEndPoint.Name = UserInfo.getUserName().substring(UserInfo.getUserName().lastIndexOf('.')+1 , UserInfo.getUserName().length());
        newEndPoint.Access_Key__c = 'test@123';
        newEndPoint.Api_Endpoint_URL__c = 'http://www.legalzoom.com/';
        newEndPoint.Secret_key__c = 'testClass@123';
        newEndPoint.Notepad_URL__c = 'http://www.legalzoom.com/';
        insert newEndpoint;
        
    }

    public static contact buildContactData(String type, String emial, String phone, String street, String address2, String city, String state, String zip, String mobile, String homePhone, String otherPhone )
    {
        Contact buildContact =TestUtils.createContacts(1, 'TestContact', theAccount.Id, false)[0];
        buildContact.Contact_Type__c = type;
        buildContact.Email = emial;
        buildContact.Phone = phone;
        buildContact.MailingStreet = street;
        buildContact.Address_2__c = address2;
        buildContact.MailingCity = city;
        buildContact.MailingState = state; 
        buildContact.MailingPostalCode = zip;
        buildContact.MobilePhone = mobile;
        buildContact.HomePhone = homePhone;
        buildContact.OtherPhone = otherPhone;
        return buildContact;
    }

    public static Id insertAuthorizedContact()
    {
        theAccount = TestUtils.createAccounts(1,'TestAccount2', True)[0];
        Contact newContact = buildContactData('Authorized Contact' , 'Test2ndAuth@test.com','5552228888',  '123 down street' , '#9900' , 'Austin' , '34' , '78717' , '6665554444' , '9995550000' , '0001110000');
        insert newContact;
        return newContact.Id;
    }

    static testMethod void testInsertNewContact()
    {
        setupData();
        PageReference pageRef = Page.ContactManager;
        pageRef.getParameters().put('CustomerLoginId',customer.Id);
        pageRef.getParameters().put('fkUser',customer.Customer_ID__c);

        Test.setCurrentPage(pageRef);
        Test.startTest();
              ContactManagerController contactManger = new ContactManagerController();
              contactManger.newContact.Contact_Type__c = 'Authorized Contact';
              contactManger.newContact.FirstName = 'FirstNameTest';
              contactManger.newContact.LastName = 'LastNameTest';
              contactManger.newContact.Email = 'auth1@test.com';
              contactManger.newContact.MailingStreet = '123 main street';
              contactManger.newContact.Address_2__c = '#9950';
              contactManger.newContact.MailingCity = 'Austin';
              contactManger.newContact.MailingState = 'Texas'; 
              contactManger.newContact.MailingPostalCode = '78717';
              contactManger.newContact.MobilePhone = '7894561230';
              contactManger.newContact.HomePhone = '4445556660';
              contactManger.newContact.OtherPhone ='1112223330';

              contactManger.createNewContact();
        Test.stopTest();

       List<Authorized_Contact__c> newInsertedAuthContact = [Select Id,Authorized_Customer_Login__c, Contact__c from Authorized_Contact__c Where Contact__c =:  contactManger.newContact.Id];
        system.assertEquals(newInsertedAuthContact[0].Authorized_Customer_Login__c,customer.Id);
        system.assertEquals( contactManger.newContact.LegalZoom_Contact_ID__c, MockHttpResponseGenerator.CREATED_ACCOUNT_ID );
        system.assertEquals( contactManger.newContact.FkUser__c, customer.Customer_ID__c);
    } 

    static testMethod void testUpdateExistingContact()
    {
        setupData();
        PageReference pageRef = Page.ContactManager;
        pageRef.getParameters().put('Id',theContact.Id);

        Test.setCurrentPage(pageRef);
        Test.startTest();
            ContactManagerController contactManger = new ContactManagerController();
            contactManger.newContact.MailingStreet = '1234 main street';
            contactManger.updateContact();
        Test.stopTest();

        List<Contact> updatedContact = [Select Id,MailingStreet From Contact Where Id =: theContact.Id];
        system.assertEquals(updatedContact[0].MailingStreet,'1234 main street');

    }

    static testMethod void testupdateAuthToPrimaryContact()
    {
        setupData();
        string contactId = insertAuthorizedContact();

        PageReference pageRef = Page.ContactManager;
        pageRef.getParameters().put('Id',contactId);

        Test.setCurrentPage(pageRef);
        Test.startTest();
            List<Customer_Login__c> testCustLogins = new List<Customer_Login__c>();
            for(Customer_Login__c custLogin : TestUtils.createCustomerLogins(1, 'customerLoginName@legalzoom.com', false)){
                custLogin.Customer_ID__c = '999999954';
                testCustLogins.add(custLogin);
            } 
            insert testCustLogins;
        
            ContactManagerController contactManger = new ContactManagerController();
            contactManger.newContact.Contact_Type__c = 'Primary Contact';
            contactManger.newContact.LastName = 'Changed LastName';
            contactManger.newContact.FkUser__c = '999999954';
        
        
            contactManger.updateContact();
        Test.stopTest();

        List<Contact> updatedAuthContacts = [Select Id, Inactive__c,Contact_Type__c from Contact where Id =: contactId];
        //system.assertEquals(updatedAuthContacts[0].Inactive__c, true);
        //system.assertEquals(updatedAuthContacts[0].Contact_Type__c, 'Authorized Contact');

        List<Contact> updatedPrimaryContacts = [Select Id,LastName, Contact_Type__c,FkUser__c from Contact Where Contact_type__c =: 'Primary Contact' AND FkUser__c = : contactManger.newContact.FkUser__c];
        //system.assertEquals(updatedPrimaryContacts[0].LastName, 'Changed LastName');
    }

    static testMethod void testupdateOrderAuthorizedContact()
    {
        setupData();
        string contactId = insertAuthorizedContact();
        Contact orderContact = new Contact(Id = contactId);
        orderContact.Lz_Order_Contact_Id__c = '99889988';
        update orderContact;

        PageReference pageRef = Page.ContactManager;
        pageRef.getParameters().put('Id',contactId);

        Test.setCurrentPage(pageRef);
        Test.startTest();
            ContactManagerController contactManger = new ContactManagerController();
            contactManger.newContact.Contact_Type__c = 'Primary Contact';
            contactManger.newContact.LastName = 'Changed LastName';
            //contactManger.updateContact();
        Test.stopTest();

        for(ApexPages.Message msg :  ApexPages.getMessages()) 
        {
            System.assertEquals('Order authorized contacts cannot be edited.', msg.getSummary());
            System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        }

    }

    static testMethod void testFiedSet()
    {
        setupData();
        string contactId = insertAuthorizedContact();

        PageReference pageRef = Page.ContactManager;
        pageRef.getParameters().put('Id',contactId);
        Test.setCurrentPage(pageRef);
        ContactManagerController contactManger = new ContactManagerController();
        List<Schema.FieldSetMember> fields = contactManger.getFields();

        system.assertNotEquals(fields.size(), 0);
    }

    static testMethod void testPreventUpdateContact()
    {
        setupData();
        String error = 'Contact cannot be updated from here. Please click Update Contact button to update Contact';
        theContact.Phone = '1234567890';
        Test.startTest();
        try
        {
            update theContact;
        }
        catch(DmlException exp)
        {
            system.assertEquals(exp.getMessage(),error);
        }
        Test.stopTest();
    }

    static testMethod void testPreventInsertContact()
    {
        setupData();
        String error = 'Contact cannot be created. Contacts can only be created for Customer Login record';
        theContact = buildContactData('Primary Contact' , 'Test@test.com','9998887898',  '123 down street' , '#9900' , 'Austin' , '34' , '78717' , '7778889999' , '4445556666' , '1114447777');
        Test.startTest();
        try
        {
            insert theContact;
        }
        catch(DmlException exp)
        {
            system.assertEquals(exp.getMessage(),error);
        }
        Test.stopTest();
    }

    //testing the individial method
    static testMethod void testAddErrorToRecordMethod()
    {
        setupData();
        String error = 'Contact cannot be created. Contacts can only be created for Customer Login record';
        theContact = buildContactData('Primary Contact' , 'Test@test.com','9998887898',  '123 down street' , '#9900' , 'Austin' , '34' , '78717' , '7778889999' , '4445556666' , '1114447777');
        Map<Id,Contact> oldContacts = new Map<Id,Contact>();
        oldContacts.put(theContact.id, theContact);

        theContact.LastName = 'lastNameTest';
        theContact.RecordTypeId = developerNameToRecordTypeIds.get('Primary Contact');
        Map<Id,Contact> newContacts = new Map<Id,Contact>();
        newContacts.put(theContact.id, theContact);

        User qaCompUser = [SELECT ID, Name , ProfileId FROM User WHERE Name = 'Lawrence Byun'][0];
        User integrationUser = [SELECT Id, Name , ProfileId FROM User WHERE Name = 'Integration User'][0];
        Set<Id> profileIds = new Set<Id>();

        profileIds.add(integrationUser.ProfileId);


        system.runAs(qaCompUser)
        { 
            ContactManagerController.addErrorToUpdatedRecord(profileIds, newContacts, oldContacts);
            ContactManagerController.addErrorToInsertedRecord(profileIds, newContacts.values());
        }
    }

    static testMethod void testAddErrorToRecordLogic()
    {
        setupData();
        String error = 'Contact cannot be created. Contacts can only be created for Customer Login record';
        theContact = buildContactData('Primary Contact' , 'Test@test.com','9998887898',  '123 down street' , '#9900' , 'Austin' , '34' , '78717' , '7778889999' , '4445556666' , '1114447777');
        insert theContact;

        User qaCompUser = [SELECT ID, Name , ProfileId FROM User WHERE Name = 'Lawrence Byun'][0];
        Set<Id> profileIds = new Set<Id>();

        profileIds.add(qaCompUser.ProfileId);
        System.runAs(qaCompUser)
        {
            try
            {
                theContact.LastName = 'changeLastName';
                update theContact;
            }
            catch(DmlException exp)
            {
                system.assertEquals(exp.getMessage(),'Contact cannot be updated from here. Please click Update Contact button to update Contact');
            }        
        }
    }
    
    static testMethod void testAddErrorToRecordMethodBizDevContact()
    {
        setupData();
        String error = 'Contact cannot be created. Contacts can only be created for Customer Login record';
        theContact = buildContactData('Primary Contact' , 'Test@test.com','9998887898',  '123 down street' , '#9900' , 'Austin' , '34' , '78717' , '7778889999' , '4445556666' , '1114447777');
        theContact.LastName = 'lastNameTest';
        theContact.RecordTypeId = developerNameToRecordTypeIds.get('Business_Development_Contact');
        
        User BizDevUser = [SELECT ID, Name , ProfileId FROM User WHERE profile.Name  like '%Sales Specialist%' AND IsActive = true Limit 1][0];

        
        Test.startTest();
        system.runAs(BizDevUser )
        {
            insert theContact;
        }    
        Test.stopTest();
        
        List<Contact> insertedContact = [Select Id,Name from Contact Where Id =: theContact.Id];
        system.assertEquals(insertedContact.Size(),1);
    }


    static testMethod void testCancel()
    {
        setupData();
        string contactId = insertAuthorizedContact();

        PageReference pageRef = Page.ContactManager;
        pageRef.getParameters().put('Id',contactId);
        Test.setCurrentPage(pageRef);
        ContactManagerController contactManger = new ContactManagerController();
        System.assertEquals(contactManger.cancel(),null);
    }

}