global class TMSCampaignExitBatch implements Database.Batchable<sObject> ,  Database.Stateful{
      
    String query;
    global TMSCampaignExitBatch()
    {
            
        query = 'SELECT Id  , LeadId , ContactId , Status , DateTime_Added_to_Campaign__c FROM CampaignMember WHERE Campaign.Name = \'TMS\' AND Status = \'Added\'';
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        CampaignBatchHelper.processCampaigns(scope);
    }
    
    global void finish(Database.BatchableContext BC) {
         
    }
        
}