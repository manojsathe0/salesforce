public with sharing class CampaignFutureHandler 
{
    //public final static String INTEGRATION_USER = 'Integration User';//commented as it is not required anymore: B-38758
    public final static String MAGIC_TIME = 'Magic Time';
    public final static String POST_PURCHASE = 'Post-Purchase';
    public final static String CUSTOMER_COMPLETE = 'Customer Complete';
    public final static String PRE_PURCHASE = 'Pre-Purchase';
    public final static String REMOVED = 'Removed';

    public CampaignFutureHandler() 
    {
        
    }
    public static void removeCampaignMemberForPostPurchase(Set<Id> orderItemIds)
    {
        Set<String> campaignNames = getCampaignNames(new List<String>{MAGIC_TIME , POST_PURCHASE , CUSTOMER_COMPLETE});
        List<Order__c> orders = getOrdersFromOrderItems(orderItemIds);
        CampaignEngine theEngine = new CampaignEngine();
        List<CampaignMember> campaignMembers = theEngine.exitCampaignsForOrders(orders , campaignNames);
        performDML(campaignMembers);
        
    }
    
    public static void removeCampaignMemberForPostPurchaseByOrders(List<Order__c> orders)
    {
        Set<String> campaignNames = getCampaignNames(new List<String>{POST_PURCHASE});
        CampaignEngine theEngine = new CampaignEngine();
        List<CampaignMember> campaignMembers = theEngine.exitCampaignsForOrders(orders , campaignNames);
        performDML(campaignMembers);
        
    }
    
    
    //Only for EP Bundle Upsell Campaign
    public static void addCampaignMemberForPostPurchase(Set<Id> orderItemIds)
    {
        Set<String> campaignNames = new Set<String>{'EP Upsell Campaign'}; //Only for EP Bundle Upsell
        List<Order__c> orders = getOrdersFromOrderItems(orderItemIds);
        List<Order__c> ordersToConsider = new List<Order__c>();
        //Filtering these orders here as dont want process all orders through Campaign Engine to evaluate criteria
        for(Order__c theOrder : orders)
        {
            
            if(theOrder.Contact_State__c != 'MI' && theOrder.Contact_State__c != 'TN' && 
               (theOrder.Process__c  == 'Living Trust' || theOrder.Process__c == 'Last Will and Testament') && !theOrder.Is_Sales_Order__c && theOrder.Order_Payment_Status_Text__c == 'Approved')
            {
               ordersToConsider.add(theOrder);
            }    
        }
        if(!ordersToConsider.isEmpty())
        {
            CampaignEngine theEngine = new CampaignEngine();
            List<CampaignMember> campaignMembers = theEngine.assignCampaignsForOrders(ordersToConsider , campaignNames);
            performDML(campaignMembers);
        }
    }
    
    
    public static void removeCampaignMembersForPrePurchase(Set<Id> orderIds)
    {
        List<Order__c> orders = [SELECT Id , Contact__c , Contact_Email__c FROM Order__c WHERE Id IN :orderIds];

        Set<String> campaignNames = getCampaignNames(new List<String>{PRE_PURCHASE});
                
        Set<Id> contactIds = new Set<Id>(); 
        for(Order__c theOrder : orders)
        {
            if(theOrder.Contact__c != null)
                contactIds.add(theOrder.Contact__c);
        }
        
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Id IN :contactIds];
        List<CampaignMember> contactCampaignMembers = new List<CampaignMember>();
        CampaignEngine theEngine = new CampaignEngine();
        Map<Id,Contact> contactsToUpdate = new Map<Id,Contact>();
        
        if(!contacts.isEmpty())
        {
            CampaignEngine.isOrderPlaced = true;
            contactCampaignMembers = theEngine.exitCampaignsForContact(contacts , campaignNames);
            CampaignEngine.isOrderPlaced = false;
            System.debug('Contact Campaign Members '+contactCampaignMembers);
        }
        performDML(contactCampaignMembers);
        
    }
    
    public static void performDML(List<CampaignMember> campaignMembers)
    {
        
        try
        {
            if(!campaignMembers.isEmpty())
                upsert campaignMembers;
            
        }
        catch(DMlException dmlEx)
        {
            SendExceptionEmail.sendDMLExceptionEmail(dmlEx , 'Failed Updating CampaignMembers');
        }
    }

    
    public static Set<String> getCampaignNames(List<String> campaignTypes)
    {
        Set<String> campaignNames = new Set<String>();
        for(Campaign theCampaign : [SELECT Id , Name FROM Campaign  WHERE Category__c IN :campaignTypes AND IsActive = True])
        {
            campaignNames.add(theCampaign.Name);
        }
        return campaignNames;
    }


    public static List<Order__c> getOrdersFromOrderItems(Set<Id> orderItemIds)
    {
        List<Order_Item__c> orderItems = [SELECT Id , Order__c  FROM Order_Item__c WHERE Id IN :orderItemIds];
        Set<Id> orderIds = new Set<Id>();
        for(Order_Item__c theItem : orderItems)
        {
            orderIds.add(theItem.Order__c);
        }
        return [SELECT Id , Contact_State__c , Process__c , Is_Sales_Order__c ,Order_Payment_Status_Text__c FROM Order__c WHERE Id IN :orderIds];
    }

	//commented the below piece of code as it is not required anymore: B-38758
	/*
    public static User integrationUser
    {
        get
        {
            if(integrationUser == null)
            {
                List<User> integrationUsers = [SELECT Id FROM User WHERE Name = :INTEGRATION_USER];
                if(!integrationUsers.isEmpty())
                {
                    integrationUser = integrationUsers[0];
                }
            }
            
            return integrationUser;
        }
        private set;
    }
    */

}