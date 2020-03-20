global class CustomerCompleteScheduler implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
          
        Time theTime = Time.newInstance(23 , 59 , 59 , 0);
        DateTime startDateTime = (DateTime.newInstance(Date.today(), theTime )).addDays(-181);
        DateTime endDateTime = (DateTime.newInstance(Date.today(), theTime )).addDays(-180);       
        PostPurchaseCampaignsBatch theBatch = new PostPurchaseCampaignsBatch(startDateTime , endDateTime);
        Database.executeBatch(theBatch , 25);
        
    }
}