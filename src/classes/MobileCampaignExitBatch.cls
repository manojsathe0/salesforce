global class MobileCampaignExitBatch implements Database.Batchable<sObject> ,  Database.Stateful{
      
    String query;
    global MobileCampaignExitBatch()
    {
            
        query = 'SELECT Id  , LeadId , ContactId , Status FROM CampaignMember WHERE Campaign.Name = \'Mobile\' AND Status = \'Sent\'';
    
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