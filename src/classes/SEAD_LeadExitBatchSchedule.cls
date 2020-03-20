global class SEAD_LeadExitBatchSchedule implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        database.executebatch(new SEAD_LeadExitBatch(), 200);
    }
}