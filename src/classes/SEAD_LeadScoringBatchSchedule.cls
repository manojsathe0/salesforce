/*Author: Padma S
 Date : 7/13/2017
 Story:  B-18708
 */
 
 
global class  SEAD_LeadScoringBatchSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        SEAD_LeadScoringBatch leadBatch = new SEAD_LeadScoringBatch();
        Database.executebatch(leadBatch, 25);
        
        SEAD_OppScoringBatch oppBatch = new SEAD_OppScoringBatch();
        Database.executebatch(oppBatch, 25);
    }
}