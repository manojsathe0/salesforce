global class SEAD_OpportunityExitBatch implements Database.Batchable<sObject>, Database.Stateful
{
    String errorMessage = '';
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        SEAD_Configuration__c config = SEADUtilityLibrary.getConfig();
        Integer negDays = Integer.valueOf(config.Opp_Days_from_Ownership__c*-1);
        Datetime dateToCompare = Datetime.now().addDays(negDays);
        Datetime yesterday = Datetime.now().addDays(-1);

        String query = 'SELECT Id, OwnerId, Owner.Profile.Name, Ownership_Date__c from Opportunity ' +
                'where Owner.Profile.Name != \'Integration User\' and ' +
                '(Ownership_Date__c <:dateToCompare or Owner.Profile.Name != \'Sales Specialist\' or Owner.isActive = false) and ' +
                'StageName not in (\'Closed Won\', \'Closed Lost\') and LastModifiedDate >: yesterday';

        system.debug('Opp Exit Query ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Opportunity> scope)
    {
        try
        {
            Set<Id> ownerIds = new Set<Id>();
            Set<Id> managerIds = new Set<Id>();
            Map<String, String> oppOwnerToOppManager = new Map<String, String>();
            Map<String, List<Team_Management__c>> managerIdToTeamMember = new Map<String, List<Team_Management__c>>();
            List<Team_Management__c> allManagerTeams = new List<Team_Management__c>();
            List<Opportunity> oppsToUpdate = new List<Opportunity>();
            Set<Id> oppIdsToUpdate = new Set<Id>();

            for (Opportunity o : scope)
            {
                ownerIds.add(o.ownerId);
            }
            List<Team_Management__c> owners = [select Id, User__c, Manager__c from Team_Management__c where User__c in:ownerIds and User__c != ''];
            system.debug('owners ' + owners);
            for(Team_Management__c owner : owners)
            {
                oppOwnerToOppManager.put(owner.User__c, owner.Manager__c);
                managerIds.add(owner.Manager__c);
            }
            system.debug('oppOwnerToOppManager ' + oppOwnerToOppManager);
            allManagerTeams = [select Id, User__c, User__r.Name, Manager__c from Team_Management__c where Manager__c in:managerIds and User__c not in: ownerIds and User__c != ''];
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

                for (Opportunity o : scope)
                {
                    if(!oppIdsToUpdate.contains(o.id))
                    {
                        String oppManagerId = oppOwnerToOppManager.get(o.ownerId);
                        if(oppManagerId == managerId)
                        {
                            if(UtilityLibrary.isNotNullOrBlank(newOwnerId))
                            {
                                o.ownerId = newOwnerId;
                                oppsToUpdate.add(o);
                                oppIdsToUpdate.add(o.id);
                            }
                        }
                    }

                }
            }
            Database.SaveResult[] srList = Database.Update(oppsToUpdate, false);

            String errorMessage = '';
            for (Database.SaveResult sr : srList)
            {

                if (sr.isSuccess())
                {
                    System.debug('Successfully updated Opportunity. Opportunity ID: ' + sr.getId());
                }
                else
                {
                    for(Database.Error err : sr.getErrors())
                    {
                        errorMessage+='\n' + err.getStatusCode() + ': ' + err.getMessage();
                        errorMessage+='Opportunity fields that affected this error: ' + err.getFields();
                    }
                }
            }
        }
        catch(Exception e )
        {
            system.debug('Exception ' + e.getMessage());

            SendExceptionEmail.sendBatchExceptionEmail(e , 'SEAD_OpportunityExitBatch');
        }

    }
    global void finish(Database.BatchableContext bc)
    {
        System.debug('done');
        if(errorMessage!= '')
        {
            SendExceptionEmail.sendDatabaseBatchExceptionEmail(errorMessage , 'SEAD_OpportunityExitBatch');
        }
    }

}