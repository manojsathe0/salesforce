/*
Batch class to collect Opps and reassign them to new owners as well as the Contacts to which they belong.
Created by: Artyom M.
Story: B-18815
*/

global class SEAD_ContactOpportunityExitBatch implements Database.Batchable<sObject>, Database.Stateful {
	public String errorMessage = '';
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
        SEAD_Configuration__c config = SEADUtilityLibrary.getConfig();
        Integer negDays = Integer.valueOf(config.Opp_Days_from_Ownership__c*-1);
        Datetime dateToCompare = Datetime.now().addDays(negDays);
        Datetime sixtyDays = Datetime.now().addDays(-60);
        Date thirtyDays = System.Today().addDays(-30);
        Id myId = '005G0000001qnZr';
        
        //The query string has been updated. Look at the uncommented query string below for more info.
        /*
        String query = 'SELECT Id, Contact__c, OwnerId, Owner.Profile.Name, Ownership_Date__c FROM Opportunity ' +
                'WHERE Owner.Name != \'Integration User\' and Owner.Name != \'LZPKB Site Guest User\' AND Ownership_Date__c != null AND ' +
                '( ( (NOT Owner.Profile.Name Like \'%Sales Specialist%\') and (NOT Owner.Profile.Name LIKE \'%Sales Manager%\')) OR ' +
                'Owner.isActive = false  OR ( Ownership_Date__c < :dateToCompare AND LastActivityDate <= :thirtydays) OR (Ownership_Date__c < :dateToCompare AND LastActivityDate = null) ) AND ' +
                'StageName NOT IN (\'Closed Won\', \'Closed Lost\') AND LastModifiedDate >= :sixtydays';
        */
        
        //Multiple Integrations user ids have been created to perform data load jobs and hence updating the query string to exclude all integration users and not just the one user. B-38758
        String query = 'SELECT Id, Contact__c, OwnerId, Owner.Profile.Name, Ownership_Date__c FROM Opportunity ' +
                'WHERE ( NOT Owner.Name LIKE \'%Integration User%\' ) and Owner.Name != \'LZPKB Site Guest User\' AND Ownership_Date__c != null AND ' +
                '( ( (NOT Owner.Profile.Name Like \'%Sales Specialist%\') and (NOT Owner.Profile.Name LIKE \'%Sales Manager%\')) OR ' +
                'Owner.isActive = false  OR ( Ownership_Date__c < :dateToCompare AND LastActivityDate <= :thirtydays) OR (Ownership_Date__c < :dateToCompare AND LastActivityDate = null) ) AND ' +
                'StageName NOT IN (\'Closed Won\', \'Closed Lost\') AND LastModifiedDate >= :sixtydays';
        
        String qureryAll = 'SELECT Id, Contact__c, OwnerId, Owner.Profile.Name, Ownership_Date__c FROM Opportunity WHERE OwnerId = :myId';
               
        System.Debug('Lead Exit Query ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> scope) {
    	System.Debug('Scope size: ' + scope.size());
        Set<Id> ownerIds = new Set<Id>();
    	Set<Id> managerIds = new Set<Id>();
        Set<Id> parentContactIds = new Set<Id>();
       
        List<Team_Management__c> tmRecordsOfCurrentOwners = new List<Team_Management__c>();
    	List<Team_Management__c> tmRecordsOfOtherOwners = new List<Team_Management__c>();
        List<Team_Management__c> finalList = new List<Team_Management__c>();

        Map<Id, Id> currentOwnerIdToManagerId = new Map<Id, Id>();
        Map<Id, List<Id>> managerIdsToExitingUsersMap = new Map<Id, List<Id>>();
        Map<Id, Contact> idToContactMap;


    	for (Opportunity opp : scope) {
    		ownerIds.add(opp.ownerId);
            parentContactIds.add(opp.Contact__c);
		}
		System.Debug('ownerIds = ' + ownerIds);
		System.Debug('parentContactIds = ' + parentContactIds);
		
		try {

			
            tmRecordsOfCurrentOwners = [SELECT Id, User__c, Manager__c FROM Team_Management__c WHERE User__c IN :ownerIds]; //owners of current Opps
            for (Team_Management__c tm : tmRecordsOfCurrentOwners) {
                managerIds.add(tm.Manager__c);
                currentOwnerIdToManagerId.put(tm.User__c, tm.Manager__c);
            }
            System.debug('managerIds = ' + managerIds);
            
            tmRecordsOfOtherOwners = [SELECT Id, User__c, Manager__c FROM Team_Management__c WHERE Manager__c IN :managerIds  AND User__r.Profile.Name LIKE '%Sales%'];
            Set<Id> otherUserIds = new Set<Id>();
            for (Team_Management__c tmOther : tmRecordsOfOtherOwners) {
                Boolean found = false;
                for (Team_Management__c tmCur : tmRecordsOfCurrentOwners) {
                    if (tmOther.User__c.equals(tmCur.User__c)) {
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    finalList.add(tmOther);
                }
            }
            
            System.Debug('finalList = ' + finalList);
            
            for (Team_Management__c tm : finalList) {
                if (!managerIdsToExitingUsersMap.containsKey(tm.Manager__c) ) {
                    managerIdsToExitingUsersMap.put(tm.Manager__c, new List<Id>());
                }
                managerIdsToExitingUsersMap.get(tm.Manager__c).add(tm.User__c);
            }
            System.Debug(managerIdsToExitingUsersMap);
            
            if (parentContactIds != null && !parentContactIds.isEmpty()) {
                idToContactMap  = new Map<Id, Contact>([SELECT Id, OwnerId FROM Contact WHERE Id IN :parentContactIds]);
                System.Debug(idToContactMap);
            }
            List<Contact> cntToUpdate = new List<Contact>();
            for (Opportunity opp : scope) {
                Id newOwnerId = managerIdsToExitingUsersMap.get(currentOwnerIdToManagerId.get(opp.ownerId))[0];
                System.debug('newOwnerId' + newOwnerId);
                opp.ownerId = newOwnerId;
                if (idToContactMap.get(opp.Contact__c) != null) {
                	Contact thisCnt = idToContactMap.get(opp.Contact__c);
	                System.debug('thisCnt = ' + thisCnt);
	                thisCnt.OwnerId = newOwnerId;
                }
            }
            
 			update idToContactMap.values();
            update scope;
            
            
			
			
		}
		catch(Exception e) {
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