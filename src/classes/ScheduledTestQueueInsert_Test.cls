@isTest
public class ScheduledTestQueueInsert_Test{
    public static testmethod void coverIt(){
        ScheduledTestQueueInsert cls = new ScheduledTestQueueInsert();
        DateTime dt = DateTime.now().addDays(1);
        String cronString = ScheduleHelper.cronStringFromDatetime(dt);
        
        Test.startTest();
        
        System.schedule('ScheduledTestQInsert'+String.valueOf(DateTime.now().getTime()),cronString,cls);
        
        Test.stopTest();
        
        
    }
}