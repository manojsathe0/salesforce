/*
Author		: Padma S
Story 		: D-07334,B-37176
Description	: This is a schedule job for the batch  POR_RequestBodyCleanupBatch to delete all the records older than 3 months from the POR Request object
*/
global class POR_RequestBodyCleanupBatchSchedule implements Schedulable {
    
    global void execute  ( SchedulableContext SC){
        POR_RequestBodyCleanupBatch PORbatch= new POR_RequestBodyCleanupBatch();
        Database.executeBatch(PORbatch, 200);
    }
}