global class MagicTimeCampaignBatch implements Database.Batchable<sObject> 
{
    
    String query;
    Set<String> uniqueCampaignNames;
    DateTime startDateRange;
    DateTime endDateRange;
    
    global MagicTimeCampaignBatch()
    {
        uniqueCampaignNames = new Set<String>();
        for(Campaign theCampaign : [SELECT Id , Name FROM Campaign  WHERE Category__c = :CampaignConstants.MAGIC_TIME])
        {
            uniqueCampaignNames.add(theCampaign.Name);
        }
        startDateRange = DateTime.now().addMinutes(-10);
        endDateRange = DateTime.now().addMinutes(-5);
                          
        if(Test.isRunningTest())
            query = 'Select Id FROM Order__c';
        else
        {                
           query = 'Select Id FROM Order__c WHERE Order_Date_Time_Created__c>= :startDateRange AND Order_Date_Time_Created__c<= :endDateRange';
           
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        List<Order__c> orders = (List<Order__c>)scope;
        CampaignEngine theEngine = new CampaignEngine();
        List<CampaignMember> campaignMembers = theEngine.assignCampaignsForOrders(orders, uniqueCampaignNames);
        System.debug('Inside Execute');
        upsert campaignMembers;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}