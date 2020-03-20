global class MobileCampaignExitScheduler implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
        MobileCampaignExitBatch theBatch = new MobileCampaignExitBatch();
        Database.executeBatch(theBatch , 200);
    }
}