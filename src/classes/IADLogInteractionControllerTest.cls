@isTest
public with sharing class IADLogInteractionControllerTest {
    
    final static String STATUS_INQUIRY = 'Status Inquiry';
    static Contact testContact; 
    static void setupData()
    {
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
        testContact = TestUtils.createContacts(1 , 'Test Contact' , testAccount.Id , false)[0];
        testContact.Genesys_Interaction_Id__c = '998899';
        insert testContact;

        Task theTask = new Task();
        theTask.WhoId = testContact.Id;
        theTask.Description = 'Test Description';
        theTask.CallObject = '998899';
        insert theTask;    
    } 
    
    static testMethod void  testLogInteraction()
    {
        
        setupData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        IADLogInteractionController theController = new IADLogInteractionController(sc);
        PageReference pageRef = Page.IADLogInteractionPage;
        pageRef.getParameters().put('id', String.valueOf(testContact.Id));
        Test.setCurrentPage(pageRef);
    
        Test.startTest(); 
            theController.theTask.Reason_For_Contact__c = 'Other';
            theController.logInteraction();
            theController.theTask.Reason_For_Contact__c = 'Other';
            theController.theTask.Description = 'notes';
            theController.logInteraction();
            theController.theTask.Reason_For_Contact__c = STATUS_INQUIRY;
            theController.logInteraction();
        Test.stopTest();
            
        List<Task> createdTasks = [SELECT Id , Subject , Reason_For_Contact__c FROM Task WHERE WhoId =:testContact.Id];
        System.assertEquals(1 , createdTasks.size() , '1 task should have been created');
       
        System.assertEquals(STATUS_INQUIRY , createdTasks[0].Reason_For_Contact__c , 'Right Reason For Contact should have been populated');
       
    }
    static testMethod void testCheckIsTransfer()
    {
        setupData(); 
        
        PageReference pageRef = Page.IADLogInteractionPage;
        pageRef.getParameters().put('id', String.valueOf(testContact.Id));
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        IADLogInteractionController theController = new IADLogInteractionController(sc);


        Test.startTest(); 
          theController.theTask.Reason_For_Contact__c = 'Transfer';
          PageReference theReference = theController.checIsTransfer();
        Test.stopTest();
              
        System.assertEquals(true , theController.isTransfer  , 'Is Transfer flag should have been set');
  
    }
}