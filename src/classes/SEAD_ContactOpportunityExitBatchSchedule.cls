global class SEAD_ContactOpportunityExitBatchSchedule implements schedulable {
    global void execute(SchedulableContext sc)
    {
        database.executebatch(new SEAD_ContactOpportunityExitBatch(), 200);
    }
}