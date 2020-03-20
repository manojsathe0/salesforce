global class TMSCampaignExitScheduler implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
        TMSCampaignExitBatch theBatch = new TMSCampaignExitBatch();
        Database.executeBatch(theBatch , 50);
    }
}