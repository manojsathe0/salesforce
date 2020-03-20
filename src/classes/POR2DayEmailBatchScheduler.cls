global class POR2DayEmailBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        POR2DayEmailBatch theBatch = new POR2DayEmailBatch();
        Database.executebatch(theBatch, 50);
    }
}