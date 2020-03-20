global class PostPurchaseCampaignScheduler implements Schedulable 
{
            
    global void execute(SchedulableContext sc)
    {
          
        Time theTime = Time.newInstance(23 , 59 , 59 , 0);
        DateTime startDateTime = (DateTime.newInstance(Date.today(), theTime )).addDays(-15);
        DateTime endDateTime = (DateTime.newInstance(Date.today(), theTime )).addDays(-14);       
        PostPurchaseCampaignsBatch theBatch = new PostPurchaseCampaignsBatch(startDateTime , endDateTime);
        Database.executeBatch(theBatch , 25);
        
    }
    
}