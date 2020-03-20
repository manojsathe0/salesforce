@isTest
public class DuplicateCheckerTest
{   
    static List<Lead> testLeads;
    static List<Contact> testContacts;
    static List<Account> testAccounts;

    static Integer SIZE = 1;
    final static String PRIMARY_CONTACT = 'Primary Contact';
    
    static void setupData()
    {
        testAccounts = new List<Account>();
        testContacts = new List<Contact>();
        testLeads = new List<Lead>();

        testAccounts = TestUtils.createAccounts(SIZE , 'Test Account', true);
        Integer i = 0; 
        for(Account theAccount : testAccounts)
        {
            Contact theContact = TestUtils.createContacts(1 , 'Test LastName', theAccount.Id , false)[0];
            theContact.HomePhone = (444444444+i)+'';
            theContact.FKUser__c = i+'';
            theContact.Email = 'TestEmail@TestEmail.Test'+i;
            theContact.Contact_Type__c = PRIMARY_CONTACT;
            ++i;
            testContacts.add(theContact);
        }
        for(i = 0 ; i < SIZE ; ++i)
        {
            Lead theLead = TestUtils.createLeads(1 , 'Test LastName' , false)[0];
            theLead.Email = 'TestEmail@TestEmail.Test'+i;
            theLead.Phone = (444444444+i)+'';
            theLead.FKUser__c = i+'';
            theLead.Company =  theLead.Email;
            testLeads.add(theLead);

        }
        
    }
    
    static testMethod void testDuplicateLeadForContact()
    {
        setupData();
        
        insert testLeads;

        Test.startTest();
            insert testContacts;
        Test.stopTest();
        System.assertEquals(SIZE , [SELECT Id FROM Lead WHERE IsConverted = true].size() , SIZE+ 'leads should have been converted');
        
    }
    
    static testMethod void testGetLeadOrContact_With_PrimaryContact()
    {
        SIZE = 1;
        setupData();

        insert testLeads;
        Lead incomingLead = new Lead();
        incomingLead.FKUser__c = '0';
        incomingLead.Tealium_Id__c = '123456789012345';
        incomingLead.Email = 'TestEmail@TestEmail.Test0';
        incomingLead.Phone = '4444444444';
        insert testContacts;

        DuplicateChecker.MessageInfo theMessage = new DuplicateChecker.MessageInfo();
        Id theId;
        Test.startTest();
            theId = DuplicateChecker.getLeadOrContact(incomingLead , theMessage);
        Test.stopTest();

        System.assertEquals(testContacts[0].Id , theId , 'Right Contact Id should have been returned');
        System.assertEquals('Email' , theMessage.matchedField , 'Right field should have been matched.');
    }

    static testMethod void testGetLeadOrContact_With_ExistingLeadWithSameTeliaumId()
    {
        SIZE = 1;
        setupData();
        testLeads[0].Tealium_Id__c = '123456789012345';  
        insert testLeads;

        Lead incomingLead = new Lead();
        incomingLead.FKUser__c = '0';
        incomingLead.Tealium_Id__c = '123456789012345';
        incomingLead.Email = 'TestEmail@TestEmail.Test0';
        incomingLead.Phone = '4444444444';
        
        Id theId;
        DuplicateChecker.MessageInfo theMessage = new DuplicateChecker.MessageInfo();
        Test.startTest();
            theId = DuplicateChecker.getLeadOrContact(incomingLead , theMessage);
        Test.stopTest();
        System.assertEquals(testLeads[0].Id , theId , 'Right Lead Id should have been returned');
        System.assertEquals('TealiumId' , theMessage.matchedField , 'Right field should have been matched.');
    }
        
    static testMethod void testGetLeadOrContactId_With_MatchingEmailOnLead()
    {
        SIZE = 1;
        setupData();
        insert testLeads;

        Lead incomingLead = new Lead();
        incomingLead.LastName = 'Test LastName';
        incomingLead.Email = 'TestEmail@TestEmail.Test0';
        incomingLead.Company = incomingLead.Email;
                
        Id theId;
        DuplicateChecker.MessageInfo theMessage = new DuplicateChecker.MessageInfo();
        Test.startTest();
            theId = DuplicateChecker.getLeadOrContact(incomingLead , theMessage);
        Test.stopTest();
        System.assertEquals(testLeads[0].Id , theId , 'Right Lead Id should have been returned');
        System.assertEquals('Email' , theMessage.matchedField , 'Right field should have been matched.');

    }
    
    static testMethod void testGetLeadOrContactId_With_MatchingEmailOnContact()
    {
        SIZE = 1;
        setupData();
        insert testContacts;

        Lead incomingLead = new Lead();
        incomingLead.LastName = 'Test LastName';
        incomingLead.Email = 'TestEmail@TestEmail.Test0';
        incomingLead.Company = incomingLead.Email;

        Id theId;
        DuplicateChecker.MessageInfo theMessage = new DuplicateChecker.MessageInfo();
        Test.startTest();
            theId = DuplicateChecker.getLeadOrContact(incomingLead , theMessage);
        Test.stopTest();
        System.assertEquals(testContacts[0].Id , theId , 'Right Contact Id should have been returned');
        System.assertEquals('Email' , theMessage.matchedField , 'Right field should have been matched.');

    }

    static testMethod void testGetLeadOrContactId_With_MatchingPhoneOnLead()
    {
        SIZE = 1;
        setupData();
        insert testLeads;

        Lead incomingLead = new Lead();
        incomingLead.LastName = 'Test LastName';
        incomingLead.Phone = testLeads[0].Phone;
        incomingLead.Company = TestLeads[0].Email;
                
        Id theId;
        DuplicateChecker.MessageInfo theMessage = new DuplicateChecker.MessageInfo();
        Test.startTest();
            theId = DuplicateChecker.getLeadOrContact(incomingLead , theMessage);
        Test.stopTest();
        System.assertEquals(testLeads[0].Id , theId , 'Right Contact Id should have been returned');
        System.assertEquals('Phone' , theMessage.matchedField , 'Right field should have been matched.');

    }
    
    static testMethod void testGetLeadOrContactId_With_MatchingPhoneOnContact()
    {
        SIZE = 1;
        setupData();
        insert testContacts;

        Lead incomingLead = new Lead();
        incomingLead.LastName = 'Test LastName';
        incomingLead.Phone = testLeads[0].Phone;
        incomingLead.Company = TestLeads[0].Email;
                
        Id theId;
        DuplicateChecker.MessageInfo theMessage = new DuplicateChecker.MessageInfo();
        Test.startTest();
            theId = DuplicateChecker.getLeadOrContact(incomingLead , theMessage);
        Test.stopTest();
        System.assertEquals(testContacts[0].Id , theId , 'Right Contact Id should have been returned');
        System.assertEquals('Phone' , theMessage.matchedField , 'Right field should have been matched.');
    }


    
}