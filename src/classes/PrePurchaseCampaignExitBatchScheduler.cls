global class PrePurchaseCampaignExitBatchScheduler implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
        PrePurchaseCampaignExitBatch theBatch = new PrePurchaseCampaignExitBatch();
        Database.executeBatch(theBatch , 100);
    }
}