/*Author: Padma S
Date : 3/03/2019
Story:  D-07334,B-37176
*/

@isTest

public class POR_RequestBodyCleanupBatchScheduleTest {   
    
    
    static testMethod void executeTest() {  
        POR_Request__c ddsreq = new POR_Request__c();
        ddsreq.POR_Request_Body__c='';
        ddsreq.CreatedDate = System.today().adddays(-91);
        insert ddsreq;  
        List<POR_Request__c> porrequest = [Select Id from POR_Request__c LIMIT 200];
        
        Test.startTest();
        //Testing the POR_RequestBodyCleanupBatch
        Database.BatchableContext	BC;
        POR_RequestBodyCleanupBatch PORbatch= new POR_RequestBodyCleanupBatch();
        PORbatch.execute(BC,porrequest);
        //Executing one more time to cover the code on the catch exception block
        PORbatch.execute(BC,porrequest);
        
        //Testing the POR_RequestBodyCleanupBatchSchedule
        POR_RequestBodyCleanupBatchSchedule obj= new POR_RequestBodyCleanupBatchSchedule();
        String cron = ' 0 0 23 ? * 7'; 
        
        String jobId= System.schedule('POR_RequestBodyCleanupBatchSchedule', cron, obj);
        
        
        
        Test.stopTest();
        
        // 2) query for cron trigger
        List<CronTrigger> cronTriggerList = [
            SELECT
            Id,
            CronExpression,
            TimesTriggered, 
            NextFireTime
            FROM
            CronTrigger
            WHERE Id  =:jobId
        ];
        
        // 4) assert that times triggered is 0
        System.assertEquals(
            0,
            cronTriggerList[0].TimesTriggered
        );
    }
    
    
}