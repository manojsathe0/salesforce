@isTest
public class POR2dayEmailTest {
    final static Integer SIZE = 1;
    final static String POR_2ND_EMAIL_TEST = 'POR 2nd Emial Test';
    static testMethod void POR2ndEmail_TrueTest()
    {
        POR_case_routing_queues__c porQueue = new POR_case_routing_queues__c();
        porQueue.Name = 'Power of Attorney';
        porQueue.X2nd_Email_hours__c = 0;
        insert porQueue;      
  
        List<Case> casesToInsert = new List<Case>();
        List<Case> testCases = TestUtils.createCases(SIZE, false);
        for(Case testCase : testCases)
        {
        testCase.Status = 'New';
        testCase.Subject = POR_2ND_EMAIL_TEST;
        testCase.POR_Email_Status__c = ProblemOrderConstants.FIRST_EMAIL;
        testCase.CreatedDate = System.now();
        testCase.RecordTypeId = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);
        casestoInsert.add(testCase);
        }
        insert casesToInsert;
        system.debug(casesToInsert[0].Hours_Since_Creation__C);
        Test.startTest();
            Database.executeBatch(new POR2DayEmailBatch(),5);
        Test.stopTest();
        
        List<Case> insertedCases = [Select Id, POR_Email_Status__C,Hours_Since_Creation__C from Case where Subject = : POR_2ND_EMAIL_TEST];
        for(Case theCase : insertedCases)
        {
            system.debug(theCase);
            System.assertEquals(ProblemOrderConstants.SECOND_EMAIL, theCase.POR_Email_Status__c, 'Right Status should have been populated');
        }
            
        
    }
    
    static testMethod void POR2ndEmail_FalseTest()
    {
        POR_case_routing_queues__c porQueue = new POR_case_routing_queues__c();
        porQueue.Name = 'Power of Attorney';
        porQueue.X2nd_Email_hours__c = 43;
        insert porQueue; 
        
        List<Case> casestoInsert = new List<Case>();
        List<Case> testCases = TestUtils.createCases(SIZE, false);
        for(Case testCase : testCases)
        {
        testCase.Status = 'New';
        testCase.Subject = POR_2ND_EMAIL_TEST;
        testCase.POR_Email_Status__c = ProblemOrderConstants.FIRST_EMAIL;
        testCase.CreatedDate = System.now().addHours(-42);
        testCase.RecordTypeId = ProblemOrderRoutingService.developerNameToRecordTypeIds.get(ProblemOrderConstants.PROBLEM_CASE_RECORD_TYPE);
        casestoInsert.add(testCase);
        }
        insert casestoInsert;
        system.debug(casesToInsert[0].Hours_Since_Creation__C);
        Test.startTest();
            Database.executeBatch(new POR2DayEmailBatch(),5);
        Test.stopTest();
        
        List<Case> insertedCases = [Select Id, POR_Email_Status__C from Case where Subject = : POR_2ND_EMAIL_TEST];
        for(Case theCase : insertedCases)
        {
            System.assertNotEquals(ProblemOrderConstants.SECOND_EMAIL, theCase.POR_Email_Status__c, 'Right Status should have been populated');
        }
            
        
    }
}