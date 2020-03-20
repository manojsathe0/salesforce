global class SubSave30DayScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        SubSave30DayBatch theBatch = new SubSave30DayBatch();
        Database.executebatch(theBatch, 50);
    }
}