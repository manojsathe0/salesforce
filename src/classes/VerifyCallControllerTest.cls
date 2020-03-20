@isTest
public with sharing class VerifyCallControllerTest {
    public VerifyCallControllerTest() {
        
    }

    public static testMethod void testVerifyCustomer()
    {
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
        Contact testContact = TestUtils.createContacts(1 , 'Test Contact' , testAccount.Id , false)[0];
        testContact.Genesys_Interaction_Id__c = '998899';
        insert testContact;

        Task theTask = new Task();
        theTask.WhoId = testContact.Id;
        theTask.Description = 'Test Description';
        theTask.CallObject = '998899';
        insert theTask;
        
       
        User theUser = TestUtils.createUser('TestUser', TestUtils.salesAgentProfileId , true);
       

        System.runAs(theUser)
        {
                ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
                VerifyCallController theController = new VerifyCallController(sc);
                PageReference pageRef = Page.VerifyCall;
                pageRef.getParameters().put('id', String.valueOf(testContact.Id));
                Test.setCurrentPage(pageRef);
                Test.startTest(); 
                    theController.verifyCustomer();
                Test.stopTest();
        }
        List<Task> createdTasks = [SELECT Id , Is_Customer_Verified__c , Date_Time_Customer_Verification__c FROM Task WHERE WhoId =:testContact.Id];
        System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
        System.assertEquals(true , createdTasks[0].Is_Customer_Verified__c , 'Customer Verified should be true');
       
        
    }
}