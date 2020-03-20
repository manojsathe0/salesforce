global class SEAD_TaskDeletionSchedule implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        database.executebatch(new SEAD_TaskDeletion(), 200);
    }
}