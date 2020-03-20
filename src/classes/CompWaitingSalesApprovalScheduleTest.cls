@isTest
private class CompWaitingSalesApprovalScheduleTest 
{

    static testmethod void test() 
    {
		Test.startTest();
			Datetime sysTime = System.now().addMinutes(10);      
        	String chronExpression = '0 0 0 * * ?';
        	
			// Schedule the test job
			String jobId = System.schedule('Test job', chronExpression, new ComplianceWaitingSalesApprovalSchedule());
			
			// Get the information from the CronTrigger API object
			CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
			// Verify the expressions are the same
			System.assertEquals(chronExpression, ct.CronExpression);
			// Verify the job has not run
			System.assertEquals(0, ct.TimesTriggered);
			
		Test.stopTest();
		
    }
}