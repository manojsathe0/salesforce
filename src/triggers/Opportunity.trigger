/*
Opportunity Trigger. Created on 10/20/2017
Author: Artyom M.
Story: B-22376
*/
trigger Opportunity on Opportunity (before insert, before update, after insert) {
	if (Trigger.isBefore) {
		if (Trigger.isUpdate || Trigger.isInsert) {
			if (!OpportunityService.isAdminProfileRunningNow()) {
				OpportunityService.ensureNoDuplicateOppsUnderSameContact(Trigger.oldMap , Trigger.New, Trigger.isInsert);
			}
			
		}
		if (Trigger.isInsert) {
			OpportunityService.populateOppScore(Trigger.new, false);
			//OpportunityService.populateCloseDate(null, Trigger.New); 
		}
		
		if (Trigger.isUpdate) {
			OpportunityService.checkForOwnershipChange(Trigger.oldMap , Trigger.newMap);
			OpportunityService.markReassignedOpportunities(Trigger.oldMap , Trigger.newMap);
			OpportunityService.populateTealiumChanges(Trigger.oldMap , Trigger.newMap);
			//OpportunityService.populateCloseDate(Trigger.oldMap, Trigger.New);
			OpportunityService.populateOppSourceFields(Trigger.oldMap, Trigger.New);
		}
		
		
	}
	
	if (Trigger.isAfter && Trigger.isInsert) {
		OpportunityService.stampContactOnNewOppCreation(Trigger.new);
		
	}

    
}