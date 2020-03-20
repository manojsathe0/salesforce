global class SEAD_LeadExitBatch implements Database.Batchable<sObject>, Database.Stateful
{
    public String errorMessage = '';
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        SEAD_Configuration__c config = SEADUtilityLibrary.getConfig();
        Integer negDays = Integer.valueOf(config.Lead_Days_from_Ownership__c*-1);
        Datetime dateToCompare = Datetime.now().addDays(negDays);
        Datetime sixtydays = Datetime.now().addDays(-60); //Padma @B-18481
        Date thirtydays = System.Today().addDays(-30); // Padma @B-18481
        
        String query = 'SELECT Id, OwnerId, Owner.Profile.Name, Ownership_Date__c from Lead ' +
                'where Owner.Name != \'Integration User\' and Owner.Name != \'LZPKB Site Guest User\' and isConverted = false and Ownership_Date__c != null and ' +
                '( ( (NOT Owner.Profile.Name Like \'%Sales Specialist%\') and (NOT Owner.Profile.Name LIKE \'%Sales Manager%\'))or ' +
                'Owner.isActive = false  or ( Ownership_Date__c <:dateToCompare and LastActivityDate <=:thirtydays) or (Ownership_Date__c <:dateToCompare and LastActivityDate =null) ) and ' +
                'Status not in (\'Closed Won\', \'Closed Lost\') and  LastModifiedDate >=:sixtydays';
                
               
        system.debug('Lead Exit Query ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Lead> scope)
    {
        try
        {
            Set<Id> ownerIds = new Set<Id>();
            Set<Id> managerIds = new Set<Id>();
            Map<String, String> leadOwnerToLeadManager = new Map<String, String>();
            Map<String, List<Team_Management__c>> managerIdToTeamMember = new Map<String, List<Team_Management__c>>();
            List<Team_Management__c> allManagerTeams = new List<Team_Management__c>();
            List<Lead> leadsToUpdate = new List<Lead>();
            Set<ID> leadIdsToUpdate = new Set<ID>();

            for (Lead l : scope)
            {
                ownerIds.add(l.ownerId);
            }
            List<Team_Management__c> owners = [select Id, User__c, Manager__c from Team_Management__c where User__c in:ownerIds and User__c != ''];
            
            // Padma @B-18481
            if( ownerIds.size() != owners.size()){
            	
	             List<User> userOwner= [Select Id, Manager_Text__c from user where id IN :ownerIds ];
	            
	             Map<String, List<String>> managertoowner = new Map<String,List<String>>();
	             for(User us: userOwner){
	             
	             	if(!managertoowner.containsKey(us.Manager_Text__c)){
	             		
	             		managertoowner.put(us.Manager_Text__c, new list<String>{us.Id});
	             	}
	             	else {
	             		managertoowner.get(us.Manager_Text__c).add(us.Id);
	             	}
	             	
	             }
	             	
	            Map<Id, User> Mangermap = new Map<Id, User>([Select Name, Id from User Where Name IN :managertoowner.keySet()]);
	  			//Map<String, String> userIdtoManagerId = new Map<String, String>();
	             
	             for(User um: Mangermap.values()){
	             	
	             	for(string st:managertoowner.get(um.name)){
	             		 //userIdtoManagerId.put(st.Id, um.Id);
	             		 
	             		 leadOwnerToLeadManager.put(st, um.Id);
	             		 
	             	}
	             	managerIds.add(um.Id);
	             }
	            system.debug('leadOwnerToLeadManager is : '+leadOwnerToLeadManager); 
            }
            else{
	             //EOC Padma @B-18481
	            system.debug('owners ' + owners);
	            for(Team_Management__c owner : owners)
	            {
	                leadOwnerToLeadManager.put(owner.User__c, owner.Manager__c);
	                managerIds.add(owner.Manager__c);
	            }
            
            }
            system.debug('leadOwnerToLeadManager ' + leadOwnerToLeadManager);
            allManagerTeams = [select Id, User__c, User__r.Name, Manager__c from Team_Management__c
                where Manager__c in:managerIds and User__c not in: ownerIds and User__c != '' and User__r.IsActive=true and
                (User__r.Profile.Name = 'Sales Specialist (SEAD Pilot)' or User__r.Profile.Name = 'Sales Specialist')];
            system.debug('allManagerTeams ' + allManagerTeams);
            for(Team_Management__c teamMember : allManagerTeams)
            {
                List<Team_Management__c> teamMembers = managerIdToTeamMember.get(teamMember.Manager__c);
                if(teamMembers!= null && teamMembers.size()>0)
                {
                    teamMembers.add(teamMember);
                    managerIdToTeamMember.put(teamMember.Manager__c, teamMembers);
                }
                else
                {
                    teamMembers = new List<Team_Management__c>();
                    teamMembers.add(teamMember);
                    managerIdToTeamMember.put(teamMember.Manager__c, teamMembers);
                }
            }
            for(String managerId : managerIdToTeamMember.keySet())
            {
                List<Team_Management__c> teamMembers = managerIdToTeamMember.get(managerId);
                Integer count = teamMembers.size();
                Integer rand = Math.floor(Math.random() * count).intValue();
                Team_Management__c teamMember = teamMembers.get(rand);
                system.debug('teamMember.User__c ' + teamMember.User__c + ' name : ' +  teamMember.User__r.Name);
                String newOwnerId =  teamMember.User__c;

                for (Lead l : scope)
                {
                    if(!leadIdsToUpdate.contains(l.id))
                    {
                        String leadManagerId = leadOwnerToLeadManager.get(l.ownerId);
                        if(leadManagerId == managerId)
                        {
                            if(UtilityLibrary.isNotNullOrBlank(newOwnerId))
                            {
                                l.ownerId = newOwnerId;
                                leadIdsToUpdate.add(l.id);
                                leadsToUpdate.add(l);
                            }
                        }
                    }

                }
            }
            Database.SaveResult[] srList = Database.Update(leadsToUpdate, false);

            for (Database.SaveResult sr : srList)
            {

                if (sr.isSuccess())
                {
                    System.debug('Successfully updated Lead. Lead ID: ' + sr.getId());
                }
                else {
                    for(Database.Error err : sr.getErrors())
                    {
                        errorMessage+='\n' + err.getStatusCode() + ': ' + err.getMessage();
                        errorMessage+='Lead fields that affected this error: ' + err.getFields();
                    }
                }
            }
        }
        catch(Exception e )
        {
            system.debug('Exception ' + e.getMessage());

            SendExceptionEmail.sendBatchExceptionEmail(e , 'SEAD_LeadExitBatch');
        }

    }

    global void finish(Database.BatchableContext bc)
    {
        System.debug('done');
        if(errorMessage!= '')
        {
            SendExceptionEmail.sendDatabaseBatchExceptionEmail(errorMessage , 'SEAD_LeadExitBatch');
        }
    }

}