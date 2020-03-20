@isTest
private class DeleteErrorLogSchedulerTest{
	static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *'; 
        
        // Create your test data
        Error_Log__c errorLog = new Error_Log__c();
        errorLog.User__c= UserInfo.getUserId();
        insert errorLog;
        
        Test.startTest();

            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new DeleteErrorLogScheduler());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        Test.stopTest();
        // Add assert here to validate result
    }
}