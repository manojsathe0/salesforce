global class MagicTimeCampaignScheduler implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
        scheduleAnotherJob();
        MagicTimeCampaignBatch theBatch = new MagicTimeCampaignBatch();
        Database.executeBatch(theBatch , 25);
        System.abortJob(sc.getTriggerId());
    }
    
    static void scheduleAnotherJob()
    {
       
      Datetime nextScheduleTime = system.now().addMinutes(5);
      String minute = string.valueof(nextScheduleTime.minute());
      String second = string.valueof(nextScheduleTime.second ());
      String cronvalue = second+' '+minute+' * * * ?' ;
      String jobName = 'MagicTimeCampaignBatch - ' +
      nextScheduleTime.format('MMM d yyyy  hh:mm');
 
      MagicTimeCampaignScheduler  theScheduler  = new MagicTimeCampaignScheduler  ();
      System.schedule(jobName, cronvalue , theScheduler);
      
    }
}