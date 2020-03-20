global class SubSave30DayBatch implements Database.Batchable<sObject> ,  Database.Stateful{
    
    String query;
    public static String ACTIVE = 'Active';
    public static DECIMAL SUBSCRIPTION_DAYS
    {
        get
        {
            if(SUBSCRIPTION_DAYS == null) 
            {
                for (ss_days__c ssDays : [SELECT Name  FROM ss_days__c LIMIT 1])
                {
                    SUBSCRIPTION_DAYS = Decimal.valueOf(ssDays.Name);
                }
            }
            return SUBSCRIPTION_DAYS;
        } 
        set;
    }
    Date SUBSCRIPTION_CREATED_DATE = system.today().addDays(-Integer.valueOf(SUBSCRIPTION_DAYS));
    Date SUBSCRIPTION_CREATED_DATE2 = system.today().addDays(-Integer.valueOf(SUBSCRIPTION_DAYS) + 1); //to compare created date
    global SubSave30DayBatch()
    {
        system.debug(system.today());
        system.debug('date = '+ SUBSCRIPTION_CREATED_DATE);
        query = 'SELECT Days_from_Creation__c , Order_Matching_Activity__r.Is_Subscription_Activity__c ,Parent_Order_Item__c , Parent_Order_Item__r.Subscription_Status__c , Subscription_Saved__c FROM Order360__c WHERE Order_Matching_Activity__r.Is_Subscription_Activity__c = True AND CreatedDate >=: SUBSCRIPTION_CREATED_DATE and CreatedDate <=: SUBSCRIPTION_CREATED_DATE2';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Order360__c> scope)
    {
        for(Order360__c theActivieRevenue : scope)
        {
            if(theActivieRevenue.Parent_Order_Item__c != null)
            {
                if(theActivieRevenue.Parent_Order_Item__r.Subscription_Status__c == ACTIVE)
                    theActivieRevenue.Subscription_Saved__c = true;
            }
        }
        try
        {
            update scope;
        }
        catch(DmlException exp)
        {
            SendExceptionEmail.sendDMLExceptionEmail(exp, 'Error in processing the SUB SAVE records.');
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    

}