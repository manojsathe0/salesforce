@isTest
public class POREmailSenderTest
{
    final static Integer SIZE = 50;
       
    static testMethod void testSendEmailtoCustomer()
    {
        POR_case_routing_queues__c porQueue = new POR_case_routing_queues__c();
        porQueue.Name = 'Power of Attorney'; //process name
        porQueue.Template_DeveloperName__c = 'PSD_Prod_Hold';
        insert porQueue;      
  
        List<Case> casesToInsert = new List<Case>();
        List<Case> testCases = TestUtils.createCases(SIZE, false);
        Account testAccount = TestUtils.createAccounts(1 , 'Test Account' , true)[0];
        Contact testContact = TestUtils.createContacts(1, 'Test LastName' , testAccount.Id , false )[0];
        testContact.Email = 'testContact65@test.tt';
        insert testContact;
        
        for(Case testCase : testCases)
        {
        testCase.Product2__c = 'Power of Attorney';
        testCase.Status = 'New';
        testCase.Subject = 'Test Case';
        
        testCase.ContactId = testContact.Id;
        testCase.RecordTypeId = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);
        casestoInsert.add(testCase);
        }
        insert casesToInsert;
        system.debug(casesToInsert[0].Hours_Since_Creation__C);
        Test.startTest();
            POREmailSender theEmailSender = new POREmailSender();
            theEmailSender.sendEmailsToCustomer(testCases);
        Test.stopTest();
        
        List<EmailMessage> emailMessages = [SELECT Id FROM EmailMessage];
        System.assertEquals(SIZE , emailMessages.size() , 'Right number of email messages should have been created');
        
        List<Task> tasks = [SELECT Id FROM Task];
        System.assertEquals(SIZE , tasks.size() , 'Right number of activities should have been created');
            
        
    }
    }