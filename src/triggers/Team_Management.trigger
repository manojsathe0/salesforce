trigger Team_Management on Team_Management__c (before insert, before update, after insert, after update) 
{	
	if(Trigger.isBefore)
	{
		if(Trigger.isInsert)
		{
			TeamManagementService.checkTeamManagementUserDuplicateRecord_Insert(Trigger.new);
		}
		
		if(Trigger.isUpdate)
		{
			TeamManagementService.checkTeamManagementUserDuplicateRecord_Update(Trigger.new, Trigger.oldMap);
		}
	}
}