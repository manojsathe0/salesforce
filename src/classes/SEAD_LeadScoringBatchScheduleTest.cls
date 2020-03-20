/*Author: Padma S
 Date : 7/13/2017
 Story:  B-18708
 */

@isTest
private class SEAD_LeadScoringBatchScheduleTest {

     static testMethod void executeTest() {   
       
      Test.startTest();
      SEAD_LeadScoringBatchSchedule obj= new SEAD_LeadScoringBatchSchedule();
        String cron = '0 0 9-17 ? * MON-FRI';
        //System.schedule('SEAD_LeadScoringBatchSchedule', cron, obj);
        String jobId= System.schedule('SEAD_LeadScoringBatchSchedule', cron, obj);

        
        
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