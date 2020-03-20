trigger SalesAdjustment on Sales_Adjustment__c (after insert) 
{
	SalesAdjustmentService.createManualSharing(Trigger.new);
}