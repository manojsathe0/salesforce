@isTest
public class SendToCustomEmailControllerTest 
{ 
   static testMethod void testCreateCaseAndForwardSuccess_WithAccountContact()
   {
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account', true)[0];
        Contact testContact = TestUtils.createContacts(1 , 'Test Contact', testAccount.id, false)[0];
        testContact.AccountId = testAccount.Id;
        insert testContact;

        PageReference pageRef = Page.SendToCustomEmail;
        pageRef.getParameters().put('recordId' , testContact.Id);
       
        Test.setCurrentPage(pageRef);
        Test.startTest();
              SendToCustomEmailController theController = new SendToCustomEmailController();
              theController.createCaseAndForward();
        Test.stopTest(); 
        
        List<Contact> queriedContacts = [SELECT Id , Contact_Case__c FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals( 1 , queriedContacts.size() , '1 contact should have been returned');
        System.assertNotEquals( null , queriedContacts[0].Contact_Case__c);
    }

   static testMethod void testAlreadyHasCase_WithAccountContact()
   {
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account', true)[0];
        Contact testContact = TestUtils.createContacts(1 , 'Test Contact', testAccount.id, false)[0];
        Case theCase = TestUtils.createCases(1, true)[0];
        testContact.AccountId = testAccount.Id;
        testContact.Contact_Case__c = theCase.Id;
        insert testContact;

        PageReference pageRef = Page.SendToCustomEmail;
        pageRef.getParameters().put('recordId' , testContact.Id);
       
        Test.setCurrentPage(pageRef);
        Test.startTest();
              SendToCustomEmailController theController = new SendToCustomEmailController();
              theController.createCaseAndForward();
        Test.stopTest();
        
        List<Contact> queriedContacts = [SELECT Id , Contact_Case__c FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals( 1 , queriedContacts.size());
        System.assertEquals( theCase.Id , queriedContacts[0].Contact_Case__c);
    }

   static testMethod void testCreateCaseAndForwardSuccess_WithLead()
   {
        Lead theLead = TestUtils.createLeads(1 , 'Test Lead', true)[0];
        PageReference pageRef = Page.SendToCustomEmail;
        pageRef.getParameters().put('recordId' , theLead.Id);
       
        Test.setCurrentPage(pageRef);
        Test.startTest();
              SendToCustomEmailController theController = new SendToCustomEmailController();
              theController.createCaseAndForward();
        Test.stopTest();

        List<Lead> queriedLeads = [SELECT Id, Lead_Case__c FROM Lead WHERE Id =: theLead.Id];
        System.assertNotEquals( null , queriedLeads[0].Lead_Case__c);
    }

    static testMethod void testCreateCaseAndForward_WithConvertedLead()
    {
      Lead theLead = TestUtils.createLeads(1 , 'Test Lead', true)[0];
      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(theLead.Id);
      LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
      lc.setConvertedStatus(convertStatus.MasterLabel);
      Database.LeadConvertResult lcr = Database.convertLead(lc);
      PageReference pageRef = Page.SendToCustomEmail;
      pageRef.getParameters().put('recordId' , theLead.Id);

      Test.setCurrentPage(pageRef);
        Test.startTest();
              SendToCustomEmailController theController = new SendToCustomEmailController();
              theController.createCaseAndForward();
        Test.stopTest();

        List<Lead> queriedLeads = [SELECT Id, Lead_Case__c FROM Lead WHERE Id =: theLead.Id];
        System.assertEquals( null , queriedLeads[0].Lead_Case__c);



    }
}