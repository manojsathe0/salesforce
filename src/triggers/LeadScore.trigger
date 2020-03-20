trigger LeadScore on Lead_Attribute__c (after insert, after update, before insert, before update) {

    if(Trigger.isBefore && Trigger.isInsert) 
    {
        ScoringService.scoringServiceMain(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isInsert)
    {
        ScoringServiceHelper.deleteDuplicateAttributs(Trigger.new);
    }
}