public with sharing class CampaignEngine 
{
    
    public static Boolean isOrderPlaced = false;
    public Map<Id,Lead> queriedLeads;
    public Map<Id,Order__c> queriedOrders;
    public Map<Id,Contact> queriedContacts;
    public Map<Id,Task> queriedActivities;
    public Map<Id,CampaignMember> queriedCampaignMembers;
    public Map<Id,Map<Id,CampaignMember>> campaignIdToMapOfCampaignmemberByLeadId;
    public Map<Id,Map<Id,CampaignMember>> campaignIdToMapOfCampaignmemberByContactId;
    public Map<Id,List<Order__c>> contactIdToListOfOrders;
    public Map<Id,Set<String>> contactIdToAllProductNames;
    public Map<Id,List<Task>> contactIdToListOfActivities;
    public Map<Id,List<Task>> leadIdToListOfActivities;

    public final static String GENERAL_RULE = 'General_Rule';
    public final static String PRODUCT_RULE = 'Product_Rule';
    public final static String STATUS_RULE = 'Status_Rule';
    public final static String DAYS_RULE = 'Days_Rule';
    public final static String THE_ENTRY = 'Entry';
    public final static String THE_EXIT = 'Exit';
    public final static String T = 't';
    public final static String F = 'f';
    final static String REMOVED = 'Removed';
    final static String SENT = 'Sent';
    final static String PROCESSING_STATUS = 'Processing_Status__c';
    final static String PRIOR_PROCESSING_STATUS = 'Prior_Processing_Status__c';
    final static String BASE_PRODUCT_LINE = 'Base_Product_Line__c';
    final static String BASE_PROCESS = 'Base_Process__c';
    final static String BASE_PRODUCT_NAME = 'Base_Product_Name__c';
    final static String CHILD_PRODUCT_NAME = 'Child_Product_Name__c';
    final static String PRODUCT_LINE = 'Product_Line__c';
    final static String PROCESS = 'Process__c';
    final static String PRODUCT_NAME = 'Product_Name__c';
    final static String LZ_PRODUCT_NAME = 'LZ_Product_Name__c';
    final static String PROCESSING_STATUS_DATETIME = 'Processing_Status_Date_Time__c';
    final static String PRE_PURCHASE = 'Pre-Purchase';
    final static String THE_LEAD = 'Lead';
    final static String THE_CONTACT = 'Contact';
    final static String THE_ORDER = 'Order__c';
    final static String THE_TASK = 'Task';
    final static String UPDATED = 'Updated';
    public final static String SEPERATOR = '\\|\\|';
    public Map<Id,String> objectIdToRuleType;
    final static String ADDED = 'Added';
    final static String ORDER_PLACED = 'Order Placed';
    public Map<Id,Map<Id,String>> campaignIdToObjectIdToRuleType;
    
    public CampaignEngine()
    {
        campaignIdToMapOfCampaignmemberByLeadId = new Map<Id,Map<Id,CampaignMember>>();
        campaignIdToMapOfCampaignmemberByContactId = new Map<Id,Map<Id,CampaignMember>>();
        contactIdToListOfOrders = new Map<Id,List<Order__c>>();
        contactIdToAllProductNames = new Map<Id,Set<String>>();     
        objectIdToRuleType = new Map<Id,String>();
        campaignIdToObjectIdToRuleType = new Map<Id,Map<Id,String>>();
        contactIdToListOfActivities = new Map<Id,List<Task>>();
        leadIdToListOfActivities = new Map<Id,List<Task>>();
    }
    public List<CampaignMember> exitCampaignsForLead(List<Lead> newLeads , Set<String> campaignNames)
    {
        Map<Id,Campaign> campaigns = getCampaignsWithCriteria(THE_EXIT , campaignNames);
        System.debug('Exit Campaign For Lead');
        return processLeadsForCampaigns(newLeads , campaigns , false);
    }

    public List<CampaignMember> assignCampaignsForLead(List<Lead> newLeads , Set<String> campaignNames)
    {
        Map<Id,Campaign> campaigns = getCampaignsWithCriteria(THE_ENTRY , campaignNames);
        return processLeadsForCampaigns(newLeads , campaigns , true);
    }

    public List<CampaignMember> exitCampaignsForContact(List<Contact> contacts , Set<String> campaignNames)
    {
        populateContactIdIdToAllProductNames(contacts);
        Map<Id,Campaign> campaigns = getCampaignsWithCriteria(THE_EXIT , campaignNames);
        return processContactsForCampaigns(contacts , campaigns , false);
    }

    public List<CampaignMember> assignCampaignsForContact(List<Contact> contacts , Set<String> campaignNames)
    {
        populateContactIdIdToAllProductNames(contacts);
        Map<Id,Campaign> campaigns = getCampaignsWithCriteria(THE_ENTRY , campaignNames);
        return processContactsForCampaigns(contacts , campaigns , true);
    }
    public List<CampaignMember> exitCampaignsForOrders(List<Order__c> orders , Set<String> campaignNames)
    {
        
        Map<Id,Campaign> campaigns = getCampaignsWithCriteria(THE_EXIT , campaignNames);
        return processOrderForCampaigns(orders , campaigns , false);

    }

    public List<CampaignMember> assignCampaignsForOrders(List<Order__c> orders , Set<String> campaignNames)
    {
        
        Map<Id,Campaign> campaigns =getCampaignsWithCriteria(THE_ENTRY , campaignNames);
        System.debug('THECAMPAIGNS '+campaigns);
        return processOrderForCampaigns(orders , campaigns , true);

    }
    
    public List<CampaignMember> assignCampaignsForActivities(List<Task> activities , Set<String> campaignNames)
    {
        Map<Id,Campaign> campaigns =getCampaignsWithCriteria(THE_ENTRY , campaignNames);
        System.debug('THECAMPAIGNS '+campaigns);
        return processActivityForCampaigns(activities , campaigns , true);
        
    }
    
    public List<CampaignMember> processActivityForCampaigns(List<Task> activities , Map<Id,Campaign> campaigns , Boolean isEntry)
    {
      
        queriedActivities = CampaignEngineHelper.getQueriedActivities(activities);
        Map<Id,Contact> contacts = new Map<Id,Contact>();
        Map<Id,Lead> leads = new Map<Id,Lead>();
                
        for(Task theActivity : queriedActivities.values())
        {
            if(theActivity.WhoId != null)
            {
                String theWhoId = theActivity.whoId;
                if(theWhoId.startsWith('003'))
                {
                    if(!contactIdToListOfActivities.containsKey(theActivity.WhoId))
                        contactIdToListOfActivities.put(theActivity.whoId , new List<Task>());
                    contactIdToListOfActivities.get(theActivity.whoId).add(theActivity);
                    
                    contacts.put(theActivity.whoId , new Contact(Id = theActivity.whoId));
                        
                }
                else if(theWhoId.startsWith('00Q'))
                {
                    if(!leadIdToListOfActivities.containsKey(theActivity.WhoId))
                        leadIdToListOfActivities.put(theActivity.whoId , new List<Task>());
                    leadIdToListOfActivities.get(theActivity.whoId).add(theActivity);
                    
                    leads.put(theActivity.whoId , new Lead(Id = theActivity.whoId));
                    
                }
                
                               
            
            }
        }
        System.debug('ContactIdToListOfActivities '+contactIdToListOfActivities);
        Map<String,CampaignMember> uniqueCampaignContactToCampaignMember = new Map<String,CampaignMember>();
       
        List<CampaignMember> allCampaignMembers = new List<CampaignMember>();
        if(!contacts.isEmpty())
        {
                
            for(CampaignMember theMember : [SELECT Id , ContactId , CampaignId , CreatedDate , Status , DateTime_Added_to_Campaign__c FROM CampaignMember WHERE CampaignId IN :campaigns.KeySet() AND ContactId IN :contacts.keySet()])
            {
                uniqueCampaignContactToCampaignMember.put(theMember.CampaignId+'-'+theMember.ContactId , theMember);
                        
            }
            queriedContacts = CampaignEngineHelper.getQueriedContacts(contacts.values());
            List<CampaignMember> contactCampaignMembers = getCampaignMembersToUpsert(campaigns , isEntry , uniqueCampaignContactToCampaignMember);
            allCampaignMembers.addAll(contactCampaignMembers);
        }
        if(!leads.isEmpty())
        {
                         
            List<CampaignMember> leadCampaignMembers = processLeadsForCampaigns(leads.values() , campaigns , isEntry );
            allCampaignMembers.addAll(leadCampaignMembers);
        }
        return allCampaignMembers;
    }
    
    public void populateContactIdIdToAllProductNames(List<Contact> contacts)
    {
        for(Order__c theOrder : [SELECT Id , Product_Name__c , Contact__c FROM Order__c WHERE Contact__c IN : contacts])
        {
            if(!contactIdToAllProductNames.containsKey(theOrder.Contact__c))
                contactIdToAllProductNames.put(theOrder.Contact__c , new Set<String>());
            contactIdToAllProductNames.get(theOrder.Contact__c).add(theOrder.Product_Name__c);  
        }
    }
    
    
    public List<CampaignMember> processLeadsForCampaigns(List<Lead> newLeads , Map<Id,Campaign> campaigns , Boolean isEntry)
    {
        Map<Id,Set<Id>> leadIdToCampaignIds = new Map<Id,Set<Id>>();
        queriedLeads  = CampaignEngineHelper.getQueriedLeads(newLeads);
        Map<String,CampaignMember> uniqueCampaignLeadToCampaignMember = new Map<String,CampaignMember>();
        for(CampaignMember theMember : [SELECT Id , LeadId , CampaignId , CreatedDate , Status , DateTime_Added_to_Campaign__c FROM CampaignMember WHERE CampaignId IN :campaigns.KeySet() AND LeadId IN :newLeads])
        {
            uniqueCampaignLeadToCampaignMember.put(theMember.CampaignId+'-'+theMember.LeadId , theMember);
                    
        }
    
        for(Lead theLead : queriedLeads.values())
        {
            //for every lead evaluate against every campaigns that is provided
            for(Campaign theCampaign : campaigns.values())
            {
                String expressionToEvaluate = '';
                if(isEntry)
                    expressionToEvaluate = theCampaign.Postfix_Expression_Entry__c;
                else
                    expressionToEvaluate = theCampaign.Postfix_Expression_Exit__c;

                if(!theCampaign.Campaign_Rules__r.isEmpty())
                {   
                    CampaignMember theCampaignMember;
                    
                    String theKey = theCampaign.Id+'-'+theLead.Id;
                    if(uniqueCampaignLeadToCampaignMember.containsKey(theKey))
                        theCampaignMember = uniqueCampaignLeadToCampaignMember.get(theKey);
                    
                    if(leadIdToListOfActivities.containsKey(theLead.Id))
                    {
                        for(Task theTask : leadIdToListOfActivities.get(theLead.Id))
                        {
                            if(expressionToEvaluate != null && expressionToEvaluate != '')
                            {
                                Boolean theResult = evaluateLead(theLead , theCampaign ,theCampaign.Campaign_Rules__r, expressionToEvaluate , theCampaignMember ,theTask);
                                if(theResult)
                                {
                                    if(!leadIdToCampaignIds.containsKey(theLead.Id))
                                        leadIdToCampaignIds.put(theLead.Id , new Set<Id>());
                                    leadIdToCampaignIds.get(theLead.Id).add(theCampaign.Id);
                                }
                            }
                        }   
                    }
                    else
                    {
                        if(expressionToEvaluate != null && expressionToEvaluate != '')
                        {               
                            Boolean theResult = evaluateLead(theLead , theCampaign , theCampaign.Campaign_Rules__r , expressionToEvaluate , theCampaignMember , null);
                            if(theResult)
                            {
                                if(!leadIdToCampaignIds.containsKey(theLead.Id))
                                    leadIdToCampaignIds.put(theLead.Id , new Set<Id>());
                                leadIdToCampaignIds.get(theLead.Id).add(theCampaign.Id);
                            }
                        }
                    }
                }
            }
        }
        List<CampaignMember> campaignMembersToUpsert = getCampaignMembersToUpsertForLead(isEntry , leadIdToCampaignIds , uniqueCampaignLeadToCampaignMember);
        return campaignMembersToUpsert;
    }
    
    

    public List<CampaignMember> getCampaignMembersToUpsertForLead(Boolean isEntry , Map<Id,Set<Id>> leadIdToCampaignIds , Map<String,CampaignMember> uniqueCampaignLeadToCampaignMember)
    {
        List<CampaignMember> campaignMembersToUpsert = new List<CampaignMember>();
        for(Id theLeadId : leadIdToCampaignIds.keySet())
        {
        
            for(Id theCampaignId : leadIdToCampaignIds.get(theLeadId))
            {
                String theKey = theCampaignId+'-'+theLeadId;
                if(isEntry)
                {
                    if(!uniqueCampaignLeadToCampaignMember.containsKey(theKey))
                    {
                        CampaignMember theMember = new CampaignMember();
                        theMember.LeadId = theLeadId;
                        theMember.CampaignId = theCampaignId;
                        theMember.Status = ADDED;
                        campaignMembersToUpsert.add(theMember);
                    }
                    else
                    {
                        CampaignMember theMember = uniqueCampaignLeadToCampaignMember.get(theKey);
                        theMember.Status = ADDED;
                        campaignMembersToUpsert.add(theMember);
                    }
                }
                else
                {
                    if(uniqueCampaignLeadToCampaignMember.containsKey(theKey))
                    {
                        CampaignMember theMember = uniqueCampaignLeadToCampaignMember.get(theKey);
                        Map<Id,String> productRuleMap = campaignIdToObjectIdToRuleType.get(theCampaignId);
                        if(productRuleMap != null && productRuleMap.containsKey(theLeadId))
                            theMember.Status = ORDER_PLACED;
                        else
                            theMember.Status = REMOVED;
                        campaignMembersToUpsert.add(theMember);
                    }   
                }
            }
        }
        return campaignMembersToUpsert;
    }


    public List<CampaignMember> processContactsForCampaigns(List<Contact> contacts , Map<Id,Campaign> campaigns , Boolean isEntry)
    {
        
        queriedContacts = CampaignEngineHelper.getQueriedContacts(contacts);
        
        Map<String,CampaignMember> uniqueCampaignContactToCampaignMember = new Map<String,CampaignMember>();
        for(CampaignMember theMember : [SELECT Id , ContactId , CampaignId , CreatedDate , Status , DateTime_Added_to_Campaign__c FROM CampaignMember WHERE CampaignId IN :campaigns.KeySet() AND ContactId IN :contacts])
        {
            uniqueCampaignContactToCampaignMember.put(theMember.CampaignId+'-'+theMember.ContactId , theMember);
                    
        }
        return getCampaignMembersToUpsert(campaigns , isEntry , uniqueCampaignContactToCampaignMember);
    }


    public List<CampaignMember> getCampaignMembersToUpsert(Map<Id,Campaign> campaigns , Boolean isEntry , Map<String ,CampaignMember> uniqueCampaignContactToCampaignMember)
    {
        Map<Id,Set<Id>> contactIdToCampaignIds = new Map<Id,Set<Id>>();
        System.debug('HOHO '+campaigns);
        if(queriedContacts != null)
        {
            for(Contact theContact : queriedContacts.values())
            {
                for(Campaign theCampaign : campaigns.values())
                {
                    String expressionToEvaluate = '';
                    if(isEntry)
                        expressionToEvaluate = theCampaign.Postfix_Expression_Entry__c;
                    else
                        expressionToEvaluate = theCampaign.Postfix_Expression_Exit__c;
                    contactIdToCampaignIds  = getContactIdToCampaignIds(theCampaign , contactIdToCampaignIds , expressionToEvaluate , theContact , uniqueCampaignContactToCampaignMember);
                }
            }
        }
        return getCampaignMembers(isEntry, contactIdToCampaignIds ,  uniqueCampaignContactToCampaignMember);
    }


    public Map<Id,Set<Id>> getContactIdToCampaignIds(Campaign theCampaign , Map<Id,Set<Id>> contactIdToCampaignIds , String expressionToEvaluate , Contact theContact ,  Map<String,CampaignMember> uniqueCampaignContactToCampaignMember)
    {
        
        if(!theCampaign.Campaign_Rules__r.isEmpty())
        {   
            CampaignMember theCampaignMember;
            String theKey = theCampaign.Id+'-'+theContact.Id;
            if(uniqueCampaignContactToCampaignMember.containsKey(theKey))
                theCampaignMember = uniqueCampaignContactToCampaignMember.get(theKey);

            //if the call is initiated from Order need to look at all orders for that contact in the given batch
            if(contactIdToListOfOrders.containsKey(theContact.Id))
            {
                
                for(Order__c theOrder : contactIdToListOfOrders.get(theContact.Id))
                {
                    if(expressionToEvaluate != null && expressionToEvaluate != '')
                    {
                        Boolean theResult = evaluateContact(theContact , theCampaign , expressionToEvaluate , theCampaignMember , theOrder , null);
                        if(theResult)
                        {
                            if(!contactIdToCampaignIds.containsKey(theContact.Id))
                                contactIdToCampaignIds.put(theContact.Id , new Set<Id>());
                            contactIdToCampaignIds.get(theContact.Id).add(theCampaign.Id);
                        }
                    }
                }
            }
            else //it is Pre-Purchase campaign
            {
                
                if(contactIdToListOfActivities.containsKey(theContact.Id))
                {
                    for(Task theTask : contactIdToListOfActivities.get(theContact.Id))
                    {
                        if(expressionToEvaluate != null && expressionToEvaluate != '')
                        {
                            Boolean theResult = evaluateContact(theContact , theCampaign , expressionToEvaluate , theCampaignMember , null , theTask);
                            if(theResult)
                            {
                                if(!contactIdToCampaignIds.containsKey(theContact.Id))
                                    contactIdToCampaignIds.put(theContact.Id , new Set<Id>());
                                contactIdToCampaignIds.get(theContact.Id).add(theCampaign.Id);
                            }
                        }
                    }   
                }
                else
                {
                    if(expressionToEvaluate != null && expressionToEvaluate != '')
                    {
                        Boolean theResult = evaluateContact(theContact , theCampaign , expressionToEvaluate , theCampaignMember , null , null);
                        if(theResult)
                        {
                            if(!contactIdToCampaignIds.containsKey(theContact.Id))
                                contactIdToCampaignIds.put(theContact.Id , new Set<Id>());
                            contactIdToCampaignIds.get(theContact.Id).add(theCampaign.Id);
                        }
                    }
                }
            }
        }
        return contactIdToCampaignIds;
    }


    public List<CampaignMember> getCampaignMembers(Boolean isEntry , Map<Id,Set<Id>> contactIdToCampaignIds , Map<String,CampaignMember> uniqueCampaignContactToCampaignMember )
    {
        List<CampaignMember> campaignMembersToUpsert = new List<CampaignMember>();
        System.debug('Unique '+uniqueCampaignContactToCampaignMember);
        System.debug('ContactIdToCampaignIds '+contactIdToCampaignIds);
            
        for(Id theContactId : contactIdToCampaignIds.keySet())
        {
        
            for(Id theCampaignId : contactIdToCampaignIds.get(theContactId))
            {
                String theKey = theCampaignId+'-'+theContactId;
                if(isEntry)
                {
                    
                    if(!uniqueCampaignContactToCampaignMember.containsKey(theKey))
                    {
                        CampaignMember theMember = new CampaignMember();
                        theMember.ContactId = theContactId;
                        theMember.CampaignId = theCampaignId;
                        campaignMembersToUpsert.add(theMember);
                    }
                    else
                    {
                        CampaignMember theMember = uniqueCampaignContactToCampaignMember.get(theKey);
                        theMember.Status = ADDED;
                        campaignMembersToUpsert.add(theMember);
                    }
                }
                else
                {
                    if(uniqueCampaignContactToCampaignMember.containsKey(theKey))
                    {
                        Map<Id,String> productRuleMap = campaignIdToObjectIdToRuleType.get(theCampaignId);
                        CampaignMember theMember = uniqueCampaignContactToCampaignMember.get(theKey);
                        if(productRuleMap != null && productRuleMap.containsKey(theContactId))
                            theMember.Status = ORDER_PLACED;
                        else
                            theMember.Status = REMOVED;
                        campaignMembersToUpsert.add(theMember);
                    }   
                }
                
            }
        }
        System.debug('MAMA '+campaignIdToObjectIdToRuleType);
        System.debug('OHOH '+uniqueCampaignContactToCampaignMember);
        System.debug('CAMPAIGN MEMBERS '+campaignMembersToUpsert);
        return campaignMembersToUpsert;
    }
        
    
    public Boolean evaluateLead(Lead theLead , Campaign theCampaign , List<Campaign_Rule__c> theRulesForCampaign, String postfixExpression , CampaignMember theMember , Task theTask)
    {
        
        System.debug('THERULES '+theRulesForCampaign);
        Map<String,String> ruleIdToStatus = initializeRuleIdToStatus(postfixExpression);
        Map<String,String> ruleIdToRecordType = new Map<String,String>();
        for(Campaign_Rule__c theRule : theRulesForCampaign)
        {
            
            ruleIdToRecordType.put(theRule.Rule_Id__c , theRule.RecordType.DeveloperName);
            if(theRule.RecordType.DeveloperName == GENERAL_RULE)
            {
                if(theRule.Object__c == THE_LEAD)
                    processGeneralRule(ruleIdToStatus , theRule , theLead);
                else if(theRule.Object__c == THE_TASK && theTask != null)
                    processGeneralRule(ruleIdToStatus , theRule , theTask);
                
            }
            else if(theRule.RecordType.DeveloperName == DAYS_RULE)
            {
                if(theRule.Days_To_Look__c == 'Member Since')
                {
                    processDaysRuleForCampaignMember(ruleIdToStatus , theRule , theMember);
                }
                else if(theRule.Days_To_Look__c == 'Lead/Contact Modified' || theRule.Days_To_Look__c == 'Last Sales Activity')
                {
                   processDaysRuleForLeadOrContact(ruleIdToStatus , theRule , theLead); 
                }
            }

        }
        System.debug('THE EXPRESSION :'+postfixExpression);
        System.debug('Final Rule Id To Status :'+ruleIdToStatus);

        for(String theKey : ruleIdToStatus.keySet())
        {
            postfixExpression = postfixExpression.replaceAll(theKey, ruleIdToStatus.get(theKey));
        }
        System.debug('Final Postfix Expression '+postfixExpression);

        Boolean result = ExpressionEvaluator.computePostfix(postfixExpression);
        if(result)
        {
            for(String theKey : ruleIdToStatus.keySet())
            {
                if(ruleIdToStatus.get(theKey) == T && ruleIdToRecordType.get(theKey) == PRODUCT_RULE)
                {
                    if(!campaignIdToObjectIdToRuleType.containsKey(theCampaign.Id))
                        campaignIdToObjectIdToRuleType.put(theCampaign.Id , new Map<Id,String>());
                    campaignIdToObjectIdToRuleType.get(theCampaign.Id).put(theLead.Id , PRODUCT_RULE);
                }
               
            }   
        }
        System.debug('Final Result '+result);

        return result;

    }

    public Boolean evaluateContact(Contact theContact , Campaign theCampaign, String postfixExpression , CampaignMember theMember , Order__c theOrder , Task theTask)
    {
        System.debug('THERULES '+theCampaign.Campaign_Rules__r);
        Map<String,String> ruleIdToStatus = initializeRuleIdToStatus(postfixExpression);
        Map<String,String> ruleIdToRecordType = new Map<String,String>();
        
        for(Campaign_Rule__c theRule : theCampaign.Campaign_Rules__r)
        {
           
            if(theRule.RecordType.DeveloperName == GENERAL_RULE)
            {
                if(theRule.Object__c == THE_CONTACT)
                    processGeneralRule(ruleIdToStatus , theRule , theContact);
                else if(theRule.Object__c == THE_ORDER && theOrder != null)
                    processGeneralRule(ruleIdToStatus , theRule , theOrder);
                else if(theRule.Object__c == THE_TASK && theTask != null)
                    processGeneralRule(ruleIdToStatus , theRule , theTask);
                
            }
            else if(theRule.RecordType.DeveloperName == DAYS_RULE)
            {
                if(theRule.Days_To_Look__c == 'Member Since')
                {
                    processDaysRuleForCampaignMember(ruleIdToStatus , theRule , theMember);
                }
                else if(theRule.Days_To_Look__c == 'Lead/Contact Modified' || theRule.Days_To_Look__c == 'Last Sales Activity')
                {
                   processDaysRuleForLeadOrContact(ruleIdToStatus , theRule , theContact); 
                }
            }
            
            else if(theRule.RecordType.DeveloperName == PRODUCT_RULE)
            {
                ruleIdToRecordType.put(theRule.Rule_Id__c , theRule.RecordType.DeveloperName);
                processProductRule(ruleIdToStatus , theRule , theOrder);
            }
            else if(theRule.RecordType.DeveloperName == STATUS_RULE && theCampaign.Category__c != PRE_PURCHASE)
            {
                processStatusRule(ruleIdToStatus , theRule , theOrder);
            }
            
        }
        System.debug('THE EXPRESSION :'+postfixExpression);
        System.debug('Final Rule Id To Status :'+ruleIdToStatus);

        for(String theKey : ruleIdToStatus.keySet())
        {
            postfixExpression = postfixExpression.replaceAll(theKey, ruleIdToStatus.get(theKey));
        }
        System.debug('Final Postfix Expression '+postfixExpression);
        Boolean result = ExpressionEvaluator.computePostfix(postfixExpression);
        if(result)
        {
            for(String theKey : ruleIdToStatus.keySet())
            {
                if(ruleIdToStatus.get(theKey) == T && ruleIdToRecordType.get(theKey) == PRODUCT_RULE)
                {
                    if(!campaignIdToObjectIdToRuleType.containsKey(theCampaign.Id))
                        campaignIdToObjectIdToRuleType.put(theCampaign.Id , new Map<Id,String>());
                    campaignIdToObjectIdToRuleType.get(theCampaign.Id).put(theContact.Id , PRODUCT_RULE);
                }
               
            }   
        }
        System.debug('OI OI '+objectIdToRuleType);
        System.debug('Final Result '+result);
        return result;

    }

    

    public void processGeneralRule(Map<String,String> ruleIdToStatus , Campaign_Rule__c theRule , Sobject theObject)
    {
        System.debug('THE RULE '+theRule);
        System.debug('Picklist Fields '+CampaignEngineHelper.multiPicklistFields);
                
        if(theRule.Field_To_Evaluate__c != null)
        {
            
            if(theRule.Field_Value__c == null)
            {
                System.debug('Field To Evaluate '+theRule.Field_To_Evaluate__c);
                System.debug('Object Field Value '+String.valueOf(theObject.get(theRule.Field_To_Evaluate__c.trim())));             
                if(String.valueOf(theObject.get(theRule.Field_To_Evaluate__c.trim())) != null)
                {
                    ruleIdToStatus.put(theRule.Rule_Id__c , T);
                }
            }
            else if(theRule.Field_Value__c != null) // Supports Comma Seperated value
            {
                List<String> allFieldValues = new List<String>();
                if(CampaignEngineHelper.multiPicklistFields.contains(theRule.Field_To_Evaluate__c.trim().toLowerCase())) //Sets are case sensitive.So need to put in lower case
                {
                    String multiPicklistValues = getValueFromSObjectField(theObject , theRule.Field_To_Evaluate__c);
                    for(String theValue : multiPicklistValues.split(';'))
                    {
                        allFieldValues.add(theValue);
                    }   
                }
                else
                {
                    String fieldValue = getValueFromSObjectField(theObject , theRule.Field_To_Evaluate__c);
                    System.debug('FieldValue '+fieldValue);
                    allFieldValues.add(fieldValue); 
                }
                List<String> allValues = theRule.Field_Value__c.split(SEPERATOR);
                Boolean isExit = false;
                for(String theValue : allValues)
                { 
                    System.debug('THEVALUE '+theValue);
                    for(String fieldValue : allFieldValues)
                    {
                        if(theValue == fieldValue)
                        {
                            ruleIdToStatus.put(theRule.Rule_Id__c , T);
                            isExit = true;
                            break;
                        }

                    }
                    if(isExit)
                        break;
                    
                }
        
            }
        }
    }

    public String getValueFromSObjectField(SObject theObject , String fieldName)
    {
        String theFieldValue = '';
        try
        {
            theFieldValue = String.valueOf(theObject.get(fieldName.trim()));    //Sobject get Method is case insensitive
        }
        catch(Exception theException)
        {
            //if there is bad field names.Just ignore.
        }
        return theFieldValue;
    }   

    public Map<String,String> initializeRuleIdToStatus(String postfixExpression)
    {
        Map<String,String> ruleIdToStatus = new Map<String,String>();
        if(postfixExpression != null)
        {
            List<String> allCharacters = postfixExpression.split('');
            for(String theCharacter : allCharacters)
            {
                if(theCharacter != '&' && theCharacter != '|' && theCharacter != '')
                {
                    ruleIdToStatus.put(theCharacter , F);
                }
            }
        }
        System.debug('Initial '+ruleIdToStatus);
        return ruleIdToStatus;
    }


    public void processDaysRuleForCampaignMember(Map<String,String> ruleIdToStatus , Campaign_Rule__c theRule , CampaignMember theMember)
    {
        if(theMember != null && theRule.Number_of_Days__c != null && theMember.Status != REMOVED)
        {
            DateTime lookBackDays;
            if(Test.isRunningTest())
                lookBackDays = DateTime.now().addDays(theRule.Number_of_Days__c.intValue()+1);
            else 
                lookBackDays = DateTime.now().addDays(theRule.Number_of_Days__c.intValue()*(-1));
            
            if(theMember.DateTime_Added_to_Campaign__c <= lookBackDays)
            {
                ruleIdToStatus.put(theRule.Rule_Id__c , T);
            }
            
        }
        
    }

    public void processDaysRuleForLeadOrContact(Map<String,String> ruleIdToStatus , Campaign_Rule__c theRule , Sobject theObject)
    {
        if(theObject != null && theRule.Number_of_Days__c != null)
        {
            DateTime lookBackDays;
            if(Test.isRunningTest())
                lookBackDays = DateTime.now().addDays(theRule.Number_of_Days__c.intValue()+1);
            else 
                lookBackDays = DateTime.now().addDays(theRule.Number_of_Days__c.intValue()*(-1));
            
            if(theRule.Days_To_Look__c == 'Lead/Contact Modified')
            {
                if((DateTime)theObject.get('LastModifiedDate') <= lookBackDays)
                {
                    ruleIdToStatus.put(theRule.Rule_Id__c , T);
                }
            }
            else if(theRule.Days_To_Look__c == 'Last Sales Activity')
            {
                if(theObject.get('Last_Sales_Activity__c') != null)
                {
                    if((DateTime)theObject.get('Last_Sales_Activity__c') <= lookBackDays)
                    {
                        ruleIdToStatus.put(theRule.Rule_Id__c , T);
                    }
                }
                else //use LastModifiedDate
                {
                    if((DateTime)theObject.get('LastModifiedDate') <= lookBackDays)
                    {
                        ruleIdToStatus.put(theRule.Rule_Id__c , T);
                    }
                
                }
            }
            
        } 
    }

    public void processProductRule(Map<String,String> ruleIdToStatus , Campaign_Rule__c theRule , Order__c theOrder)
    {

        if(theOrder != null)
        {
            if(theRule.Base_Product_Line__c != null)
            {
                
                processRuleByProductFieldsForBaseProduct(theRule , BASE_PRODUCT_LINE , PRODUCT_LINE, ruleIdToStatus , theOrder);
                
            }
            else if(theRule.Base_Process__c != null)
            {
                processRuleByProductFieldsForBaseProduct(theRule , BASE_PROCESS , PROCESS, ruleIdToStatus , theOrder);
            }

            else if(theRule.Base_Product_Name__c != null)
            {
                
                processRuleByProductFieldsForBaseProduct(theRule , BASE_PRODUCT_NAME , PRODUCT_NAME, ruleIdToStatus , theOrder);

            }
            else if(theRule.Child_Product_Name__c != null)
            {
                processRuleByProductFieldsForChildProduct(theRule , CHILD_PRODUCT_NAME , LZ_PRODUCT_NAME , ruleIdToStatus , theOrder);
            }
        }

        else if(theRule.Has_Purchased__c == true && theRule.Base_Process__c == null && theRule.Base_Product_Line__c == null && theRule.Base_Product_Name__c == null && theRule.Child_Product_Name__c == null)
        {
            
            //purchased any product
            if(isOrderPlaced)
            {
                System.debug('In here Purchased Something');
                ruleIdToStatus.put(theRule.Rule_Id__c , T);
                
            }
        }

    }

    
    public void processRuleByProductFieldsForBaseProduct(Campaign_Rule__c theRule , String ruleProductField  , String orderProductField , Map<String,String> ruleIdToStatus , Order__c theOrder)
    {
            
        if (!theRule.Has_Purchased__c)
                ruleIdToStatus.put(theRule.Rule_Id__c , T);
        if(theRule.Across_Orders__c)
        {
            
            if(contactIdToAllProductNames.containsKey(theOrder.Contact__c))
            {
                Set<String> allProductNames = contactIdToAllProductNames.get(theOrder.Contact__c);
                for(String theProduct : ((String)theRule.get(ruleProductField)).split(SEPERATOR))
                {
                    if(allProductNames.contains(theProduct))
                    {
                        if(theRule.Has_Purchased__c)
                        {
                            ruleIdToStatus.put(theRule.Rule_Id__c , T);
                        }
                        else if(!theRule.Has_Purchased__c)
                        {
                            ruleIdToStatus.put(theRule.Rule_Id__c , F); 
                        }
                        break;
                    }
                }
                
            }
        }
        else
        {
            for(String theProduct : ((String)theRule.get(ruleProductField)).split(SEPERATOR))
            {
                if(theProduct == theOrder.get(orderProductField))
                {
                    if(theRule.Has_Purchased__c)
                        ruleIdToStatus.put(theRule.Rule_Id__c , T);
                    else if (!theRule.Has_Purchased__c)
                        ruleIdToStatus.put(theRule.Rule_Id__c , F);
                    break;
                }
            }
        }
    }

    

    public void processRuleByProductFieldsForChildProduct(Campaign_Rule__c theRule , String ruleProductField  , String orderItemProductField , Map<String,String> ruleIdToStatus , Order__c theOrder)
    {
        
        Boolean isExit = false;
        if(!theRule.Has_Purchased__c)
            ruleIdToStatus.put(theRule.Rule_Id__c , T);
        for(String theProduct : ((String)theRule.get(ruleProductField)).split(SEPERATOR))
        {
            for(SObject theItem : theOrder.getSObjects('Order_Items__r'))
            {
                if(theProduct == theItem.get(orderItemProductField))
                {
                    System.debug('THEPRODUCT : '+theProduct);
                    if(theRule.Has_Purchased__c)
                        ruleIdToStatus.put(theRule.Rule_Id__c , T);
                    else if(!theRule.Has_Purchased__c)
                        ruleIdToStatus.put(theRule.Rule_Id__c , F);
                    isExit = true;
                    break;
                }

            }
            if(isExit)
                break;
        }
    
    }


    public void processStatusRule(Map<String,String> ruleIdToStatus , Campaign_Rule__c theRule , Order__c theOrder)
    {
        if(theRule.Status__c != null && theOrder.get(PROCESSING_STATUS) == theRule.Status__c)
        {
            if(theRule.Number_of_Days__c != null)
            {
                DateTime numberOfDaysBack = DateTime.now().addDays(-1*theRule.Number_of_Days__c.intValue());
                
                if(theOrder.get(PROCESSING_STATUS_DATETIME) != null)
                {
                    if((DateTime)theOrder.get(PROCESSING_STATUS_DATETIME) <= numberOfDaysBack)
                    {
                        ruleIdToStatus.put(theRule.Rule_Id__c , T);
                    }
                    else
                    {
                        ruleIdToStatus.put(theRule.Rule_Id__c , F);
                    }
                }
            }
            else if(theOrder.get(PROCESSING_STATUS) == theRule.Status__c || theOrder.get(PRIOR_PROCESSING_STATUS) == theRule.Status__c)
            {
                ruleIdToStatus.put(theRule.Rule_Id__c , T);
            }
        }
    }
  
  
    public List<CampaignMember> processOrderForCampaigns(List<Order__c> orders , Map<Id,Campaign> campaigns , Boolean isEntry)
    {
        queriedOrders = CampaignEngineHelper.getQueriedOrders(orders);
        Map<Id,Contact> contacts = new Map<Id,Contact>();
        for(Order__c theOrder : queriedOrders.values())
        {
            if(theOrder.Contact__c != null)
            {
                if(!contactIdToListOfOrders.containsKey(theOrder.Contact__c))
                    contactIdToListOfOrders.put(theOrder.Contact__c , new List<Order__c>());
                contactIdToListOfOrders.get(theOrder.Contact__c ).add(theOrder);
                
                contacts.put(theOrder.Contact__c , new Contact(Id = theOrder.Contact__c));
            }
        }
        System.debug('ContactIdToListOfOrders '+contactIdToListOfOrders);
        Map<String,CampaignMember> uniqueCampaignContactToCampaignMember = new Map<String,CampaignMember>();
        if(!contacts.isEmpty())
        {
                
            for(CampaignMember theMember : [SELECT Id , ContactId , CampaignId , CreatedDate , Status , DateTime_Added_to_Campaign__c FROM CampaignMember WHERE CampaignId IN :campaigns.KeySet() AND ContactId IN :contacts.keySet()])
            {
                uniqueCampaignContactToCampaignMember.put(theMember.CampaignId+'-'+theMember.ContactId , theMember);
                        
            }
            populateContactIdIdToAllProductNames(contacts.values());
            queriedContacts = CampaignEngineHelper.getQueriedContacts(contacts.values());
        }
        return getCampaignMembersToUpsert(campaigns , isEntry , uniqueCampaignContactToCampaignMember);
    
    }

    
    public static Map<String,Id> developerNameToRecordTypeId
    {
        get
        {
            if(developerNameToRecordTypeId == null)
            {
                developerNameToRecordTypeId = new Map<String,Id>();
                for(RecordType theRecordType : [SELECT Id , DeveloperName FROM RecordType WHERE SobjectType = 'Campaign_Rule__c'])
                {
                    developerNameToRecordTypeId.put(theRecordType.DeveloperName , theRecordType.Id);
                }
            }
            return developerNameToRecordTypeId;
        }
        set;
    }

    public Map<Id,Campaign> getCampaignsWithCriteria(String entryOrExit , Set<String> campaignNames)
    {
        System.debug('Had bho '+campaignNames);
        return new Map<Id,Campaign>([SELECT Id, Postfix_Expression_Entry__c , Postfix_Expression_Exit__c ,Category__c,  (SELECT Id , Rule_Id__c, Field_To_Evaluate__c , Field_Value__c , Base_Product_Line__c , Base_Process__c,
                                      Child_Product_Name__c , RecordType.DeveloperName  , Has_Purchased__c , Base_Product_Name__c , Number_of_Days__c , Status__c , Object__c , Across_Orders__c ,Days_To_Look__c FROM Campaign_Rules__r  WHERE Entry_Exit__c = :entryOrExit ORDER BY Rule_Id__c ASC) FROM 
                                      Campaign WHERE Name IN : campaignNames]);
    }

    
    
}