trigger ComplianceReview on Compliance_Review__c (before insert, before update, after update){
    
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            ComplianceReviewService.setSalesRepManagerField(Trigger.new);  
            ComplianceReviewService.lastCorrectivePlan(Trigger.new);
        }
        if(Trigger.isUpdate)
        {
            CompliancePreventUpdateViolationFields.PreventUpdateViolationFields_CompliantStatus(Trigger.new);
        }
    } 
    
    if(Trigger.isAfter && (Trigger.isUpdate))
    {
        ComplianceReviewService.ExtendCorrectiveDate(Trigger.new, Trigger.oldmap);
        ComplianceReviewManualSharing.complianceReviewManualSharingSalesRep(Trigger.new);
    }
}