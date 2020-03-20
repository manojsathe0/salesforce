global class PrePurchaseCampaignExitBatch implements Database.Batchable<sObject> ,  Database.Stateful{
      
    String query;
    global PREPurchaseCampaignExitBatch ()
    {
            
        query = 'SELECT Id  , LeadId , ContactId , Status , DateTime_Added_to_Campaign__c FROM CampaignMember WHERE ';
        query = query + '(Campaign.Name = \'Mobile\' OR Campaign.Name = \'Abandoner/Drip\' OR Campaign.Name = \'Inbound\' OR Campaign.Name = \'Abandoner/Drip - Contacts\' OR Campaign.Name = \'EP Upsell Campaign\') AND (Status = \'Sent\' OR Status = \'Added\')';
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
    system.debug(scope);
        CampaignBatchHelper.processCampaigns(scope);
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
        
}