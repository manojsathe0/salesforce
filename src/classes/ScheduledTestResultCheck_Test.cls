@isTest
public class ScheduledTestResultCheck_Test{
    public static testmethod void coverIt(){
        ScheduledTestResultCheck cls = new ScheduledTestResultCheck();
        DateTime dt = DateTime.now().addDays(1);
        String cronString = ScheduleHelper.cronStringFromDatetime(dt);
        
        Test.startTest();
        
        System.schedule('ScheduledTestResultCheck'+String.valueOf(DateTime.now().getTime()),cronString,cls);
        
        Test.stopTest();
    }
}