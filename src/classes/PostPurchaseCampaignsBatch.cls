global class PostPurchaseCampaignsBatch implements Database.Batchable<sObject> {
    
    String query;
    Set<String> uniqueCampaignNames;
    DateTime startDateRange;
    DateTime endDateRange;
    
    global PostPurchaseCampaignsBatch(DateTime theBegin , DateTime theEnd) 
    {
         
        startDateRange = theBegin;
        endDateRange = theEnd;
        
        uniqueCampaignNames = new Set<String>();
        for(Campaign theCampaign : [SELECT Id , Name FROM Campaign  WHERE Category__c = :CampaignConstants.POST_PURCHASE])
        {
            uniqueCampaignNames.add(theCampaign.Name);
        }
      
        String theQuery;
        if(Test.isRunningTest())
            query= 'Select Id FROM Order__c';
        else
            query= 'SELECT Id FROM Order__c WHERE User_Order_Extension__r.LastModifiedDate >= :startDateRange AND User_Order_Extension__r.LastModifiedDate <= :endDateRange ';
    }
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        System.debug(query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        List<Order__c> orders = (List<Order__c>)scope;
        CampaignEngine theEngine = new CampaignEngine();
        List<CampaignMember> campaignMembers = theEngine.assignCampaignsForOrders(orders, uniqueCampaignNames);
        System.debug('Inside Execute');
        upsert campaignMembers;
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
}