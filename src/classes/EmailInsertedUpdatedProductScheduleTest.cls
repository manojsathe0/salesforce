@isTest
private class EmailInsertedUpdatedProductScheduleTest {
    static testmethod void test() {
        Test.startTest();
            Datetime sysTime = System.now().addMinutes(10);      
            String cronExpression = '0 0 1 * * ?';
            String jobId = System.schedule('Email Alert Product', cronExpression,new EmailInsertedUpdatedProductSchedule());
            
            // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,
            NextFireTime
            FROM CronTrigger WHERE id = :jobId];
            // Verify the expressions are the same
            System.assertEquals(cronExpression, ct.CronExpression);
            // Verify the job has not run
            System.assertEquals(0, ct.TimesTriggered);
            
        Test.stopTest();
        
    }

}