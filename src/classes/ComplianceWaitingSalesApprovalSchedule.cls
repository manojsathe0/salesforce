global class ComplianceWaitingSalesApprovalSchedule implements Schedulable 
{
	global void execute(SchedulableContext sc)
    {
    	ComplianceUpdateWaitingSalesApproval.doScheduling();
    }
}