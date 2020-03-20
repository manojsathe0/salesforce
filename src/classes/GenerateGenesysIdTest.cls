@isTest
public class GenerateGenesysIdTest
{

    static testMethod void testGenerateIdLead()
    {
        Lead theLead = TestUtils.createLeads(1 , 'My Lead' , true)[0];
        PageReference pageRef = Page.GenerateGenesysId;
        pageRef.getParameters().put('id', theLead.id);
        Test.setCurrentPage(pageref);
       Test.startTest();
           GenerateGenesysIdController theController = new GenerateGenesysIdController();
           theController.generateId();
       Test.stopTest();
       
       List<Task> tasks = [SELECT Id , CallObject FROM Task];
       System.assertEquals(1 , tasks.size() , 'Size should be 1');
       System.assertEquals(tasks[0].Id , tasks[0].CallObject , 'Right Call Object should be populated');
       List<Lead> leads = [SELECT Id , Genesys_Interaction_Id__c FROM Lead WHERE Id = :theLead.Id];
       System.assertEquals(1 , leads.size() , 'SIZE should be 1');
       System.assertEquals(tasks[0].Id , leads[0].Genesys_Interaction_Id__c , 'Interaction Id should have been populated'); 
    }
    
    static testMethod void testGenerateIdContact()
    {
        Account theAccount = TestUtils.createAccounts(1 , 'My Account' , true)[0];
        Contact theContact = TestUtils.createContacts(1 , 'My Last Name' , theAccount.Id , true)[0];
        PageReference pageRef = Page.GenerateGenesysId;
        pageRef.getParameters().put('id', theContact.id);
        Test.setCurrentPage(pageref);
        Test.startTest();
           GenerateGenesysIdController theController = new GenerateGenesysIdController();
           theController.generateId();
       Test.stopTest();
       List<Task> tasks = [SELECT Id , CallObject FROM Task];
       System.assertEquals(1 , tasks.size() , 'Size should be 1');
       System.assertEquals(tasks[0].Id , tasks[0].CallObject , 'Right Call Object should be populated');
       List<Contact> contacts = [SELECT Id , Genesys_Interaction_Id__c FROM Contact WHERE Id = :theContact.Id];
       System.assertEquals(1 , contacts.size() , 'SIZE should be 1');
       System.assertEquals(tasks[0].Id , contacts[0].Genesys_Interaction_Id__c , 'Interaction Id should have been populated'); 
    }

}