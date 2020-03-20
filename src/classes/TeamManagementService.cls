public with sharing class TeamManagementService
{   
	public static Boolean isDuplicate = false;
    public static void checkTeamManagementUserDuplicateRecord_Insert(List<Team_Management__c> newTeamManagement)
    {
    	Map<ID, Team_Management__c> tmNoDupInTheSameBatchMap = checkDuplicateInListTeamManagement(newTeamManagement);
    	   	
    	if(tmNoDupInTheSameBatchMap.size() > 0)
    	{
    		for(Team_Management__c tmCheckOldDupList : [SELECT ID, Team_Management__c.User__c, Team_Management__c.User__r.Name FROM Team_Management__c WHERE Team_Management__c.User__c IN: tmNoDupInTheSameBatchMap.KeySet()])
	    	{
	    		if(tmCheckOldDupList.Id != tmNoDupInTheSameBatchMap.get(tmCheckOldDupList.User__C).Id && tmCheckOldDupList.User__c == tmNoDupInTheSameBatchMap.get(tmCheckOldDupList.User__C).User__c)
	    		{
	    			isDuplicate = true;
	    			for(Team_Management__c tmError : newTeamManagement)
    				{
    					tmError.addError('This user \''+tmCheckOldDupList.User__r.Name+'\' already has a Team Management Record. Please update that record.');
    				}
	    		}
	    	}
	    	if(isDuplicate != true)
	    	{
	    		populateUserManagerFields(tmNoDupInTheSameBatchMap);
	    	}
    	}   	
    	
    }
    
    public static void checkTeamManagementUserDuplicateRecord_Update(List<Team_Management__c> newTeamManagement, Map<ID, Team_Management__c> oldTeamManagementMap)
    {
    	Map<ID, Team_Management__c> tmNoDupInTheSameBatchMap = checkDuplicateInListTeamManagement(newTeamManagement);
    	if(tmNoDupInTheSameBatchMap.size() > 0)
    	{
    		Map<Id,Team_Management__c> tmOldMap = new Map<Id,Team_Management__c>();
    		Map<Id,Team_Management__c> tmUpdateMap = new Map<Id,Team_Management__c>();
    		for(Team_Management__c tmNewCheckOldDupList : [ SELECT ID, Team_Management__c.User__c, Team_Management__c.User__r.Name, ADP_ID__c, Approval_Manager__c, Assistant_Manager__c, Lead_Supervisor__c, Manager__c, Compliance_Round_Robin__c, Pulled__c 
												    		FROM Team_Management__c 
												    		WHERE Team_Management__c.User__c IN: tmNoDupInTheSameBatchMap.KeySet()]
	    	   )
    		{
    			tmOldMap.put(tmNewCheckOldDupList.User__c, tmNewCheckOldDupList);
    		}
    		
    		if(tmOldMap.size() != 0)
    		{
    			for(Team_Management__c newTMUpdate : newTeamManagement)
	    		{
	    			if(newTMUpdate.User__c != null && tmOldMap.get(newTMUpdate.User__c).User__c != null )
	    			{
		    			if(newTMUpdate.Id != tmOldMap.get(newTMUpdate.User__c).Id)
		    			{
		    				isDuplicate = true;
		    				for(Team_Management__c tmError : newTeamManagement)
		    				{
		    					tmError.addError('This user \''+tmOldMap.get(newTMUpdate.User__c).User__r.Name+'\' already has a Team Management Record. Please update that record.');
		    				}
		    			}
		    			else if(newTMUpdate.Id == tmOldMap.get(newTMUpdate.User__c).Id)
		    			{
		    				if(
		    					newTMUpdate.ADP_ID__c != tmOldMap.get(newTMUpdate.User__c).ADP_ID__c || 
		    					newTMUpdate.Approval_Manager__c != tmOldMap.get(newTMUpdate.User__c).Approval_Manager__c ||
		    					newTMUpdate.Assistant_Manager__c != tmOldMap.get(newTMUpdate.User__c).Assistant_Manager__c ||
		    					newTMUpdate.Lead_Supervisor__c != tmOldMap.get(newTMUpdate.User__c).Lead_Supervisor__c ||
		    					newTMUpdate.Manager__c != tmOldMap.get(newTMUpdate.User__c).Manager__c ||
		    					newTMUpdate.User__c != tmOldMap.get(newTMUpdate.User__c).User__c
		    				  )
		    				{
		    					tmUpdateMap.put(newTMUpdate.Id, newTMUpdate);
		    				}
		    			}
	    			}
	    		}
	    		if(isDuplicate != true && tmUpdateMap.size() > 0)
		    	{
		    		populateUserManagerFields(tmUpdateMap);
		    	}
    		}
    	}   	
    }
    
    public static void populateUserManagerFields(Map<Id, Team_Management__c> tmMap)
    {
    	String managerTEXT;
    	String assistantManagerTEXT;
    	String leadSupervisorTEXT;
    	
    	List<User> usersToUpdateManagerFieldsList = new List<User>();
    	if(tmMap.size() > 0)
    	{
			Set<Id> userIds = new Set<Id>();
			for(Team_Management__c theTeamManagement : tmMap.values())
			{
				if(!userIds.contains(theTeamManagement.Manager__c) || !userIds.contains(theTeamManagement.Assistant_Manager__c) || !userIds.contains(theTeamManagement.Lead_Supervisor__c) || !userIds.contains(theTeamManagement.Approval_Manager__c))
				{
					userIds.add(theTeamManagement.Manager__c);
					userIds.add(theTeamManagement.Assistant_Manager__c);
					userIds.add(theTeamManagement.Lead_Supervisor__c);
					userIds.add(theTeamManagement.Approval_Manager__c);
				}
			}
    		Map<Id,User> userMap = new Map<Id,User>([SELECT Id, Name, ManagerId, Manager_Text__c, Assistant_Manager_Text__c, Lead_Supervisor_Text__c FROM User WHERE User.Id IN: userIds]);
    		if(userMap.size() > 0)
    		{
    			for(Team_Management__c tm : tmMap.values())
	    		{
	    			if(tm.Manager__c == null)
	    			{
	    				managerTEXT = null;
	    			}
	    			else
	    			{
	    				managerTEXT = userMap.get(tm.Manager__c).Name;
	    			}
	    			if(tm.Assistant_Manager__c == null)
	    			{
	    				assistantManagerTEXT = null;
	    			}
	    			else
	    			{
	    				assistantManagerTEXT = userMap.get(tm.Assistant_Manager__c).Name;
	    			}
	    			if(tm.Lead_Supervisor__c == null)
	    			{
	    				leadSupervisorTEXT = null;
	    			}
	    			else
	    			{
	    				leadSupervisorTEXT = userMap.get(tm.Lead_Supervisor__c).Name;
	    			}

	    			if(tm.User__c != null)
	    			{
	    				usersToUpdateManagerFieldsList.add(new User( Id = tm.User__c, ManagerId = tm.Approval_Manager__c, Manager_Text__c = managerTEXT,
	    											             Assistant_Manager_Text__c = assistantManagerTEXT, Lead_Supervisor_Text__c = leadSupervisorTEXT , ADP_ID__c = tm.ADP_ID__c ));
	    			}
	    		}
    		}
    		else
    		{
    			for(Team_Management__c tm : tmMap.values())
	    		{
    				usersToUpdateManagerFieldsList.add(new User( Id = tm.User__c, ManagerId = null, Manager_Text__c = null, Assistant_Manager_Text__c = null, Lead_Supervisor_Text__c = null , ADP_ID__c = tm.ADP_ID__c));
	    		}
    		}    		
    	}
    	
	    update usersToUpdateManagerFieldsList;
    }
    
    public static Map<Id, Team_Management__c> checkDuplicateInListTeamManagement(List<Team_Management__c> newTeamManagement)
    {
    	Map<ID, Team_Management__c> tmNoDupMap = new Map<ID, Team_Management__c>();
    	//Check user field in the Team Management object list is duplicate user or not
    	for(Team_Management__c tm : newTeamManagement)
    	{
    		if(tm.User__c != null)
    		{
    			if(tmNoDupMap.containsKey(tm.User__c))
	    		{
	    			//if in the list has any records duplicated it make entire records cannot insert
    				for(Team_Management__c tmError : newTeamManagement)
    				{
    					tmError.addError('Another new Team Management record has the same user.');
    				}
    				tmNoDupMap.clear();
	    		}
	    		else
	    		{
	    			tmNoDupMap.put(tm.User__c, tm);
	    		}
    		}
    	}
    	return tmNoDupMap;
    }   
}