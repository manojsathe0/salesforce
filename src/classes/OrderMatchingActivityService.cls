public with sharing class OrderMatchingActivityService {
    public static Boolean hasCountByCampaignRun = false;
    public OrderMatchingActivityService() {
        
    }

    public static void processForActivityCountByCampaign(List<Order_Matching_Activity__c> oMAs)
    {
        List<Order_Matching_Activity__c> leadOMAs = new List<Order_Matching_Activity__c>();
        List<Order_Matching_Activity__c> contactOMAs = new List<Order_Matching_Activity__c>();

        for(Order_Matching_Activity__c theOMA : oMAs)
        {
            if(theOMA.Lead__c != null)
            {
                leadOMAs.add(theOMA);
            }
            else if(theOMA.Contact__c != null)
            {
                contactOMAs.add(theOMA);
            }
        }
        if(!leadOMAs.isEmpty())
            countActivitiesByCampaignForLeads(leadOMAs);
        if(!contactOMAs.isEmpty())
            countActivitiesByCampaignForContacts(contactOMAs);
    }

    
    public static void countActivitiesByCampaignForContacts(List<Order_Matching_Activity__c> matchingActivities)
    {

        Map<String,List<Task>> campaignNamesToTasks = new Map<String,List<Task>>();
        Set<Id> contactIds = new Set<Id>();
        for(Order_Matching_Activity__c theOMA : matchingActivities)
        {
            contactIds.add(theOMA.Contact__c);
        }
        List<Contact> contacts = [SELECT Id , (SELECT Id , Order_Date_Time_Created__c FROM Orders__r order by Order_Date_Time_Created__c desc limit 1),(SELECT Id , createdDate , Last_Campaign__c  FROM Tasks WHERE Last_Campaign__c != null) FROM Contact WHERE Id IN :contactIds];
        Map<Id,Map<String ,List<Task>>> contactIdToTasksToConsider = new Map<Id,Map<String,List<Task>>>();
        for(Contact theContact : contacts)
        {
            
            if(!theContact.Orders__r.isEmpty())
            {
                DateTime lastOrderPlaced = theContact.Orders__r[0].Order_Date_Time_Created__c;
                if(lastOrderPlaced != null)
                {
                    for(Task theTask : theContact.Tasks)
                    {
                        if(theTask.createdDate >= lastOrderPlaced && theTask.Last_Campaign__c != null)
                        {
                            
                            if(!contactIdToTasksToConsider.containsKey(theContact.Id))
                                contactIdToTasksToConsider.put(theContact.Id , new Map<String,List<Task>>());
                            if(!contactIdToTasksToConsider.get(theContact.Id).containsKey(theTask.Last_Campaign__c))
                                contactIdToTasksToConsider.get(theContact.Id).put(theTask.Last_Campaign__c , new List<Task>());
                            contactIdToTasksToConsider.get(theContact.Id).get(theTask.Last_Campaign__c).add(theTask);
                        }
                    }
                }
               
            }
            else
            {
                    for(Task theTask : theContact.Tasks)
                    {
                        if(theTask.Last_Campaign__c != null)
                        {
                            
                            if(!contactIdToTasksToConsider.containsKey(theContact.Id))
                                contactIdToTasksToConsider.put(theContact.Id , new Map<String,List<Task>>());
                            if(!contactIdToTasksToConsider.get(theContact.Id).containsKey(theTask.Last_Campaign__c))
                                contactIdToTasksToConsider.get(theContact.Id).put(theTask.Last_Campaign__c , new List<Task>());
                            contactIdToTasksToConsider.get(theContact.Id).get(theTask.Last_Campaign__c).add(theTask);
                        }
                    }   
             }
            
        }
        System.debug('Myan '+contactIdToTasksToConsider);
        List<Order_Matching_Activity__c> omasToUpdate = new List<Order_Matching_Activity__c>();
        for(Order_Matching_Activity__c theOMA : matchingActivities)
        {
            System.debug('What UP '+theOMA);
            if(contactIdToTasksToConsider.containsKey(theOMA.Contact__c))
            {   
                List<Task> tasks = contactIdToTasksToConsider.get(theOMA.Contact__c).get(theOMA.Matched_Campaign__c); 
        
                if(tasks != null)
                {
                    theOMA.Activity_Count_By_Campaign__c = tasks.size();
                }
            }
        }
        
    }

    public static void countActivitiesByCampaignForLeads(List<Order_Matching_Activity__c> matchingActivities)
    {

        Map<String,List<Task>> campaignNamesToTasks = new Map<String,List<Task>>();
        Set<Id> leadIds = new Set<Id>();
        for(Order_Matching_Activity__c theOMA : matchingActivities)
        {
            leadIds.add(theOMA.Lead__c);
        }
        List<Lead> leads = [SELECT Id , (SELECT Id , createdDate , Last_Campaign__c  FROM Tasks WHERE Last_Campaign__c != null) FROM Lead WHERE Id IN :leadIds];
            

        Map<Id,Map<String ,List<Task>>> leadIdToTasksToConsider = new Map<Id,Map<String,List<Task>>>();
        for(Lead theLead : leads)
        {
            for(Task theTask : theLead.Tasks)
            {
                
                if(theTask.Last_Campaign__c != null)
                {
                    
                    if(!leadIdToTasksToConsider.containsKey(theLead.Id))
                        leadIdToTasksToConsider.put(theLead.Id , new Map<String,List<Task>>());
                    if(!leadIdToTasksToConsider.get(theLead.Id).containsKey(theTask.Last_Campaign__c))
                        leadIdToTasksToConsider.get(theLead.Id).put(theTask.Last_Campaign__c , new List<Task>());
                    leadIdToTasksToConsider.get(theLead.Id).get(theTask.Last_Campaign__c).add(theTask);
                }
            }
        }
        List<Order_Matching_Activity__c> omasToUpdate = new List<Order_Matching_Activity__c>();
        for(Order_Matching_Activity__c theOMA : matchingActivities)
        {
            if(leadIdToTasksToConsider.containsKey(theOMA.Lead__c))
            {   
                List<Task> tasks = leadIdToTasksToConsider.get(theOMA.Lead__c).get(theOMA.Matched_Campaign__c); 
        
                
                if(tasks != null)
                    theOMA.Activity_Count_By_Campaign__c = tasks.size();
            }
        }
       
    }
    
    public static void populateMatchedCampaign(List<Order_Matching_Activity__c> newOMAs)
    {
        Map<Id,Contact> contactMap = new Map<Id,Contact>();
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
    
    
        Set<Id> theLeadIds = new Set<Id>();
        Set<Id> theContactIds = new Set<Id>();
        
        for(Order_Matching_Activity__c theOMA : newOMAs)
        {

            if(theOMA.Lead__c != null)
               theLeadIds.add(theOMA.Lead__c);
            else if(theOMA.Contact__c != null)
                theContactIds.add(theOMA.Contact__c);

        }

        if(!theContactIds.isEmpty())
            contactMap = new Map<Id,Contact>([SELECT Id , Sales_opportunity_latest_campaign__c FROM Contact WHERE Id IN :theContactIds]);

        for(Order_Matching_Activity__c theOMA : newOMAs)
        {
            if(theOMA.Contact__c != null && contactMap.containsKey(theOMA.Contact__c))
                theOMA.Matched_Campaign__c = contactMap.get(theOMA.Contact__c).Sales_opportunity_latest_campaign__c;
        }
        
    }
}