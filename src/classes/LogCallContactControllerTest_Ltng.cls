/*
Log a Call for Opps and Lead, Ltng version.
Created by Artyom M.
Per Story: B-25879

*/
@isTest
public with sharing class LogCallContactControllerTest_Ltng {
	static testMethod void testCreateTask_ContactStatus()
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
   

                Test.startTest(); 
                //createTask(Id contactId, String reasonForContact, String reasonForTransfer, String otherReason, String description)
                try {
                	LogCallContactController_Ltng.createTask(testContact.Id, 'Transfer', 'reasonForTransfer', 'otherReason', 'description');
                	LogCallContactController_Ltng.createTask(testContact.Id, 'Other', 'reasonForTransfer', 'otherReason', 'description');
                }
                catch (Exception e){
                	
                }
                
				LogCallContactController_Ltng.getReasonForContactValues();
				LogCallContactController_Ltng.getReasonForTransferValues();
                Test.stopTest();

                
            
            
    }
    
}