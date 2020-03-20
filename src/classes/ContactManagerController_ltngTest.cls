@isTest
public class ContactManagerController_ltngTest {
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
        theContact.LegalZoom_Contact_ID__c = '99999991';
        insert theContact;

        customer.Name = 'loginEmail@legalzoom.com';
        customer.Customer_ID__c = '9999999';
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
    
    static testMethod void testOnload()
    {
        setupData(); 
        String contactId = [Select Id , FirstName , LastName , Inactive__c , Contact_type__c , Email ,FkUser__c ,DoNotCall,HasOptedOutOfEmail, HomePhone , MobilePhone , 
                                   OtherPhone , MailingStreet , Address_2__c ,Preferred_Contact_Method__c, MailingCity , MailingState , MailingPostalCode , LZ_Order_Contact_ID__c ,
                                   	LegalZoom_Contact_ID__c, Duplicate__c From Contact limit 1].Id;
        Test.startTest();
            ContactManagerController_ltng contactManger = new ContactManagerController_ltng();
        	ContactManagerController_ltng.onload(contactId);
        Test.stopTest();
	}

    static testMethod void testUpdateExistingContact()
    {
        setupData(); 
        Contact newContact = [Select Id , FirstName , LastName , Inactive__c , Contact_type__c , Email ,FkUser__c ,DoNotCall,HasOptedOutOfEmail, HomePhone , MobilePhone , 
                                   OtherPhone , MailingStreet , Address_2__c ,Preferred_Contact_Method__c, MailingCity , MailingState , MailingPostalCode , LZ_Order_Contact_ID__c ,
                                   	LegalZoom_Contact_ID__c, Duplicate__c From Contact limit 1];
        Test.startTest();
            ContactManagerController_ltng contactManger = new ContactManagerController_ltng();
            newContact.MailingStreet = '1234 main street';
            ContactManagerController_ltng.updateContact(newContact.Id, newContact, '');
        Test.stopTest();

        List<Contact> updatedContact = [Select Id,MailingStreet From Contact Where Id =: theContact.Id];
        system.assertEquals(updatedContact[0].MailingStreet,'1234 main street');

    }
    
    static testMethod void testUpdateAuthToPrimaryContact()
    {
        setupData(); 
        Contact newContact = [Select Id , FirstName , LastName , Inactive__c , Contact_type__c , Email ,FkUser__c ,DoNotCall,HasOptedOutOfEmail, HomePhone , MobilePhone , 
                                   OtherPhone , MailingStreet , Address_2__c ,Preferred_Contact_Method__c, MailingCity , MailingState , MailingPostalCode , LZ_Order_Contact_ID__c ,
                                   	LegalZoom_Contact_ID__c, Duplicate__c From Contact limit 1];
        Test.startTest();
            ContactManagerController_ltng contactManger = new ContactManagerController_ltng();
            newContact.MailingStreet = '1234 main street';
            ContactManagerController_ltng.updateContact(newContact.Id, newContact, 'Authorized Contact');
        	LZApiService_ltng.callLzAPIContactService(newContact,'Insert', ''); 
        Test.stopTest();

        List<Contact> updatedContact = [Select Id,MailingStreet From Contact Where Id =: theContact.Id];
        system.assertEquals(updatedContact[0].MailingStreet,'1234 main street');

    }
}