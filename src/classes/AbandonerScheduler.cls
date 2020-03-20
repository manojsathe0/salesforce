global class AbandonerScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        AbandonerCampaignMemberBatch theBatch = new AbandonerCampaignMemberBatch();
        Database.executebatch(theBatch, 50);
    }
}