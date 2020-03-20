global class AbandonerCampaignMemberBatch implements Database.Batchable<sObject> ,  Database.Stateful{
    
    //Batch job to remove abandoner campaign member
    String query;
    Set<String> campaignNames = new Set<String>();
    //only for Post-Purchase
    DateTime theDateTime;
    global AbandonerCampaignMemberBatch()
    {
            
        Decimal numberOfDays; 
        for(Campaign theCampaign : [SELECT Id , Name , (SELECT Id , Rule_Id__c, Number_of_Days__c , RecordType.DeveloperName  FROM Campaign_Rules__r  WHERE Entry_Exit__c = 'Exit' 
                                        AND RecordType.DeveloperName = 'Days_Rule' limit 1) FROM Campaign  WHERE Category__c = :CampaignConstants.PRE_PURCHASE])
        {
                
            campaignNames.add(theCampaign.Name);
            if(!theCampaign.Campaign_Rules__r.isEmpty())
            {
                    numberOfDays = theCampaign.Campaign_Rules__r[0].Number_of_Days__c;
                
            }
        }
        theDateTime = Datetime.now().addDays(numberOfDays.intValue()*(-1));
        if(theDateTime != null)
            query = 'SELECT Id  , LeadId , Status , DateTime_Added_to_Campaign__c FROM CampaignMember WHERE Campaign.Category__c = \'+CampaignConstants.PRE_PURCHASE+\' AND Campaign.Postfix_Expression_Exit__c != null AND Status = \'Sent\' AND CreatedDate <= :theDateTime';
    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        processCampaigns(scope);
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
    global void processCampaigns(List<CampaignMember> campaignMembers)
    {
        
        for(CampaignMember theMember : campaignMembers)
        {
            theMember.Status = 'Removed';
        }
        upsert campaignMembers;
    }
}