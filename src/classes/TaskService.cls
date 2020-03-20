public without sharing class TaskService
{
    public final static String LEAD = 'lead';
    public final static String EMAIL_TO_CASE_USER = 'Email to Case User';
    public final static String THE_CONTACT = 'contact';
    public final static String THE_CASE = 'case';
    public final static Set<String> POR_ACTION_TYPES = new Set<String>{'Automatic Problem Order', 'Manual Problem Order'};

    public static List<Order_Matching_Activity__c> orderMatchingActivities;
    public static Set<Id> leadIds;
    public static Set<Id> contactIds;
    public static final String ORDER_NOTE = 'Note';
    public final static List<String> SALES_PROFILE = new List<String>{'Sales Manager','Sales Specialist'};

    public static User emailToCaseUser
    {
        get
        {
            if(emailToCaseUser == null)
            {
                List<User> emailToCaseUsers = [SELECT Id FROM User WHERE Name = :EMAIL_TO_CASE_USER];
                if(!emailToCaseUsers.isEmpty())
                {
                    emailToCaseUser = emailToCaseUsers[0];
                }
            }

            return emailToCaseUser;
        }
        private set;
    }



    public static void createOrderMatchingActivities(List<Task> activities)
    {


        orderMatchingActivities = new List<Order_Matching_Activity__c>();

        Set<Id> activityIds = new Set<Id>();

        for(Task theTask : activities)
        {
            if(theTask.Commission_Eligible__c)
            {
                activityIds.add(theTask.Id);

            }

        }

        List<Order_Matching_Activity__c> queriedMatchingActivities = [SELECT Id , Activity_SFDC_Id__c FROM Order_Matching_Activity__c WHERE Activity_SFDC_Id__c = :activityIds];
        Map<String,List<Order_Matching_Activity__c>> activityIdToListOfOrderMatchingActivities = new Map<String,List<Order_Matching_Activity__c>>();
        for(Order_Matching_Activity__c theOMAActivity : queriedMatchingActivities)
        {
            if(!activityIdToListOfOrderMatchingActivities.containsKey(theOMAActivity.Activity_SFDC_Id__c))
            {
                activityIdToListOfOrderMatchingActivities.put(theOMAActivity.Activity_SFDC_Id__c , new List<Order_Matching_Activity__c>());
            }
            activityIdToListOfOrderMatchingActivities.get(theOMAActivity.Activity_SFDC_Id__c).add(theOMAActivity);
        }

        for(Task theTask : activities)
        {


            if(theTask.Commission_Eligible__c)
            {
                List<Order_Matching_Activity__c> existingOrderMatchingActivities = activityIdToListOfOrderMatchingActivities.get(theTask.Id);
                if(existingOrderMatchingActivities != null)
                {
                    for(Order_Matching_Activity__c orderMatchingActivity : existingOrderMatchingActivities)
                    {
                       setParentObjectIdsOnOMA(orderMatchingActivity , theTask);
                    }
                }
                else
                {
                   Order_Matching_Activity__c orderMatchingActivity = new Order_Matching_Activity__c();
                   setParentObjectIdsOnOMA(orderMatchingActivity , theTask);
                }
            }
        }

        if(!orderMatchingActivities.isEmpty())
        {
            try
            {
                upsert orderMatchingActivities;
            }
            catch(DMLException dmlEx)
            {
                 Map<Id, Task> taskIdToTask = new Map<Id,Task>(activities);
                 for(Integer i =0;i<dmlEx.getNumDml();++i)
                 {
                    Task theTask = taskIdToTask.get(orderMatchingActivities[i].Activity_SFDC_Id__c);
                    if(theTask != null)
                    {
                        theTask.addError('Error creating Order Matching Activity Records. '+dmlEx.getDmlMessage(i));
                    }
                 }
            }
        }

    }


    public static void setParentObjectIdsOnOMA(Order_Matching_Activity__c orderMatchingActivity , Task theTask)
    {


        if(theTask.WhoId != null)
        {
            String whoId = theTask.WhoId;
            if(whoId.startsWith('00Q')) //Lead
            {

                orderMatchingActivity.Lead__c = theTask.WhoId;
                orderMatchingActivity.Parent_Object_Id__c = theTask.WhoId;
                orderMatchingActivity.Contact__c = null;
                populateOrderMatchingActivity(orderMatchingActivity , theTask);
                orderMatchingActivities.add(orderMatchingActivity);

            }
            else if(whoId.startsWith('003')) //Contact
            {

                orderMatchingActivity.Contact__c = theTask.WhoId;
                orderMatchingActivity.Parent_Object_Id__c = theTask.WhoId;
                orderMatchingActivity.Lead__c = null;
                populateOrderMatchingActivity(orderMatchingActivity , theTask);
                orderMatchingActivities.add(orderMatchingActivity);
            }

        }




    }

    public static void populateOrderMatchingActivity(Order_Matching_Activity__c orderMatchingActivity , Task theTask)
    {
        orderMatchingActivity.Activity_Created_DateTime__c = theTask.CreatedDate;
        orderMatchingActivity.Activity_Created_By__c = theTask.CreatedById;
        orderMatchingActivity.Activity_Type__c = theTask.Type;
        orderMatchingActivity.Activity_SFDC_Id__c = theTask.Id;
        orderMatchingActivity.Activity_Contacted__c = theTask.Contacted__c;
        orderMatchingActivity.Activity_Owner__c = theTask.OwnerId;
        orderMatchingActivity.Activity_Commission_Eligible__c = theTask.Commission_Eligible__c;
        orderMatchingActivity.Call_Type__c = theTask.Call_Type__c;
        orderMatchingActivity.Queue__c = theTask.Queue__c;
        orderMatchingActivity.Assistant_Manager__c = theTask.Assistant_Manager__c;
        orderMatchingActivity.Manager__c = theTask.Manager__c;
        orderMatchingActivity.Lead_Supervisor__c = theTask.Lead_Supervisor__c;
        orderMatchingActivity.Inbound_Outbound__c = theTask.Inbound_Outbound__c;
        orderMatchingActivity.Is_Created_By_Agent__c = true;
        orderMatchingActivity.Pilot_Group_Contact__c = theTask.Pilot_Group_Contact__c;
        orderMatchingActivity.Lead_Score__c = theTask.Lead_Score__c;
        orderMatchingActivity.Lead_Status__c = theTask.Lead_Status__c;
        orderMatchingActivity.Contact_Status__c = theTask.Contact_Status__c;
        orderMatchingActivity.Is_Subscription_Activity__c = theTask.Is_Subscription_Activity__c;
        orderMatchingActivity.Call_Duration__c = theTask.CallDurationInSeconds;

    }

    public static void populateTaskFields(List<Task> newTasks)
    {
    system.debug(newTasks);
        Set<Id> userIds = new Set<Id>();
        for(Task theTask : newTasks)
        {
            userIds.add(theTask.ownerId);
        }
        Map<Id,User> userIdToUser = new Map<Id,User>([SELECT Id, Assistant_Manager_Text__c, Manager_Text__c, Lead_Supervisor_Text__c, Sales_Team__c FROM User WHERE Id IN :userIds]);
        for(Task theTask : newTasks)
        {
            theTask.Assistant_Manager__c = userIdToUser.get(theTask.ownerId).Assistant_Manager_Text__c;
            theTask.Manager__c = userIdToUser.get(theTask.ownerId).Manager_Text__c;
            theTask.Lead_Supervisor__c = userIdToUser.get(theTask.ownerId).Lead_Supervisor_Text__c;
        }
    }


    public static Map<String,String> KeyPrefixToObjectMap
    {
        get
        {
            if(KeyPrefixToObjectMap == null)
            {
                KeyPrefixToObjectMap = new Map<String,String>();
                for (Schema.SObjectType so : Schema.getGlobalDescribe().values())
                {
                    Schema.DescribeSObjectResult od = so.getDescribe();
                    if (od.getKeyPrefix() != null)
                    {
                        KeyPrefixToObjectMap.put(od.getKeyPrefix(), od.getName().toLowerCase());
                    }
                }
            }
            return KeyPrefixToObjectMap;
        }
        set;
    }

    public static void populateFieldsForMessageBusActivity(List<Task> newTasks)
    {
        for(Task theTask : newTasks)
        {
            if(theTask.Type == 'SMS')
            {
                theTask.Status = 'Completed';
                theTask.ActivityDate = Date.today();
                if(theTask.Description != null)
                {
                    if(theTask.Description.length() > 70)
                    {
                        theTask.Subject = 'Text Message: '+theTask.Description.substring(0,69)+'...';
                    }
                    else theTask.Subject = 'Text Message: '+theTask.Description;
                }
            }
        }
    }

    public static void populateFieldsForOrderNoteActivity(List<Task> newTasks)
    {
        for(Task theTask : newTasks)
        {
            if(theTask.Type == 'Note')
            {
                theTask.Status = 'Completed';
                theTask.ActivityDate = Date.today();
                theTask.RecordTypeId = noteRecordTypeId;
                theTask.Subject = NextPadService.ORDER_NOTE;
            }
        }
    }

    public static Id noteRecordTypeId
    {
        get
        {
            if(noteRecordTypeId == null)
            {
                List<RecordType> recordTypes = [SELECT Id , DeveloperName FROM RecordType WHERE sObjectType = 'Task' AND DeveloperName = 'Note'];
                if(!recordTypes.isEmpty())
                    noteRecordTypeId = recordTypes[0].Id;
            }

            return noteRecordTypeId;
        }
        set;
    }

    public static Set<Id> getIdsToEdit()
    {
        list<String> profileNames = new List<String>{'System administrator', 'System Admin- Password Does Not Expire'};
        List<Profile> profiles = [Select Id From Profile Where Name In: profileNames];
        Set<Id> profileIds = new Set<Id>();

        for(Profile theProfile : profiles)
            profileIds.add(theProfile.Id);

        return profileIds;
    }

    public static void preventOrderNoteEdit(Map<Id,Task> oldTasks, Map<Id,Task> editedTasks)
    {
        for(Task theTask : editedTasks.values())
        {
            if((theTask.Type == ORDER_NOTE || oldTasks.get(theTask.Id).Type == ORDER_NOTE) &&
                (oldTasks.get(theTask.Id).Description != theTask.Description))
                theTask.addError('Tasks with type Note cannot be edited');
        }
    }

    public static void populateLeadScoreOnTask(List<Task> incomingTasks)
    {
        List<Task> tasksToConsider = new List<Task>();
        Set<Id> incomingTaskLeadIds = new Set<Id>();
        Set<Id> incomingTaskContactIds = new Set<Id>();
        for(Task theTask : incomingTasks)
        {
            if(theTask.WhoId != null)
            {
                tasksToConsider.add(theTask);
                String whoId = theTask.WhoId;
                if(whoId.startsWith('003'))
                {
                    incomingTaskContactIds.add(whoId);
                }
                else if(whoId.startsWith('00Q'))
                {
                    incomingTaskLeadIds.add(whoId);
                }
            }
        }
        if(!incomingTaskLeadIds.isEmpty())
        {
            Map<Id,Lead> leads = new Map<Id,Lead>([SELECT Id , Lead_Score__c FROM Lead WHERE Id IN :incomingTaskLeadIds]);
            for(Task theTask : tasksToConsider)
            {
                if(leads.containsKey(theTask.whoId))
                {
                    theTask.Lead_Score__c = leads.get(theTask.whoId).Lead_Score__c;

                }
            }
        }

        if(!incomingTaskContactIds.isEmpty())
        {
            Map<Id,Contact> contacts = new Map<Id,Contact>([SELECT Id , Contact_Score__c FROM Contact WHERE Id IN :incomingTaskContactIds]);
            for(Task theTask : tasksToConsider)
            {
                if(contacts.containsKey(theTask.whoId))
                {

                   theTask.Lead_Score__c = contacts.get(theTask.whoId).Contact_Score__c;

                }
            }
        }
    }

    public static void updateCampaignMemberStatus(List<Task> tasks)
    {
        if(salesProfileIds.contains(UserInfo.getProfileId()))
        {
            Set<Id> memberContactIds = new Set<Id>();
            Set<Id> memberLeadIds = new Set<Id>();

            for(Task theTask : tasks)
            {
                if(theTask.whoId != null)
                {
                    String whoId = theTask.WhoId;
                    if(whoId.startsWith('003'))
                    {
                        memberContactIds.add(whoId);
                    }
                    else if(whoId.startsWith('00Q'))
                    {
                        memberLeadIds.add(whoId);
                    }

                }
            }
            List<CampaignMember> campaignMembersToUpdate = new List<CampaignMember>();
            if(!memberContactIds.isEmpty())
            {
                List<CampaignMember> campaignMembers = [SELECT Id , Status FROM CampaignMember WHERE contactId IN :memberContactIds];

                for(CampaignMember theMember : campaignMembers)
                {
                    if(theMember.Status == CampaignConstants.ADDED || theMember.Status == CampaignConstants.SENT)
                    {
                        theMember.Status = CampaignConstants.SALES_ACTIVITY;
                        campaignMembersToUpdate.add(theMember);
                    }
                }
            }
            if(!memberLeadIds.isEmpty())
            {
                List<CampaignMember> campaignMembers = [SELECT Id , Status FROM CampaignMember WHERE leadId IN :memberLeadIds];

                for(CampaignMember theMember : campaignMembers)
                {
                    if(theMember.Status == CampaignConstants.ADDED || theMember.Status == CampaignConstants.SENT)
                    {
                        theMember.Status = CampaignConstants.SALES_ACTIVITY;
                        campaignMembersToUpdate.add(theMember);
                    }
                }
            }

            if(!campaignMembersToUpdate.isEmpty())
            {
                try
                {
                    update campaignMembersToUpdate;
                }
                catch(DMLException dmlEx)
                {

                }
            }
        }

    }


    public static Set<Id> salesProfileIds
    {
        get
        {
            if(salesProfileIds == null)
            {
                salesProfileIds = new Set<Id>();
                for(Profile theProfile : [SELECT Id FROM Profile WHERE Name IN :SALES_PROFILE])
                {
                    salesProfileIds.add(theProfile.Id);
                }
            }
            return salesProfileIds;
        }
        set;
    }

    public static void checkForProblemOrderTasks(List<Task> incomingTasks)
    {
        List<Task> tasksForPOR = new List<Task>();
        for(Task theTask : incomingTasks)
        {
            if(POR_ACTION_TYPES.contains(theTask.Action_Type__c))
            {
                tasksForPOR.add(theTask);
            }
        }
        if(!tasksForPOR.isEmpty())
            ProblemOrderRoutingService.createCaseForProblemOrder(tasksForPOR);
    }


   public static void processForCampaigns(Map<Id,Task> tasks)
   {
         List<Task> queriedTasks = [SELECT Id , RecordType.DeveloperName FROM Task WHERE Id IN :tasks.keySet()];
         List<Task> salesTasks = new List<Task>();
         for(Task theTask : queriedTasks)
         {
             if(theTask.RecordType.DeveloperName == 'Sales_Task')
             {
                 salesTasks.add(tasks.get(theTask.Id));
             }
         }
         if(!salesTasks.isEmpty())
         {
             CampaignEngine theEngine = new CampaignEngine();
             List<CampaignMember> campaignMembers = theEngine.assignCampaignsForActivities(salesTasks , new Set<String>{'Inbound'});
             try
             {
                 upsert campaignMembers;
             }
             catch(DMLException dmlEx)
             {

             }
         }
   }

    public static void countNumberOfCalls(List<Task> incomingTasks)
    {
        leadIds = new Set<Id>();
        contactIds = new Set<Id>();
        List<Case> casesToUpdate = new List<Case>();
        List<Lead> leadsToUpdate = new List<Lead>();
        List<Contact> contactsToUpdate = new List<Contact>();
        Set<Id> caseIdsCount = new Set<Id>();
        Set<Id> contactIdsforCount = new Set<Id>();
        Set<Id> leadIdsforCount = new Set<Id>();
        Map<Id,Integer> idToNoOfCallsForCases = new Map<Id,Integer>();
        Map<Id,Integer> idToNoOfCallsForLeadsAndContacts = new Map<Id,Integer>();
        system.debug(incomingTasks);
        for(Task theTask : incomingTasks)
        {
           if(theTask.Type == 'Call')
           {
             if(theTask.WhatId != null)
                 if(String.valueOf(theTask.WhatId).startsWith('500'))
                    caseIdsCount.add(theTask.WhatId);
            if(theTask.whoId != null && theTask.RecordTypeId == salesTaskRecordTypeId)
            {
                system.debug(theTask.WhoId);
                 if(String.valueOf(theTask.WhoId).startsWith('00Q'))
                    leadIds.add(theTask.WhoId);
                 if(String.valueOf(theTask.WhoId).startsWith('003'))
                    contactIds.add(theTask.WhoId);
            }

             //for cases
             if(idToNoOfCallsForCases.containsKey(theTask.WhatId))
             {
                 idToNoOfCallsForCases.put(theTask.WhatId, idToNoOfCallsForCases.get(theTask.WhatId)+1);
             }
             else
             {
                 idToNoOfCallsForCases.put(theTask.WhatId,1);
             }

             //for leads and contacts
             if(idToNoOfCallsForLeadsAndContacts.containsKey(theTask.WhoId))
             {
                 idToNoOfCallsForLeadsAndContacts.put(theTask.WhoId, idToNoOfCallsForLeadsAndContacts.get(theTask.WhoId)+1);
             }
             else
             {
                 idToNoOfCallsForLeadsAndContacts.put(theTask.WhoId,1);
             }
           }
        }
        system.debug(idToNoOfCallsForLeadsAndContacts);
        Map<Id,Case> caseIdToCase = new Map<Id,Case>();
        if(!caseIdsCount.isEmpty())
            caseIdToCase = new Map<Id,Case>([Select Id, Total_Phone_Contacts__c From Case Where Id IN :caseIdsCount]);

        Map<Id,Contact> contactIdToContact = new Map<Id,Contact>();
        if(!contactIds.isEmpty())
            contactIdToContact = new Map<Id,Contact>([Select Id, Total_Phone_Contacts__c From Contact Where Id IN :contactIds]);

        Map<Id,Lead> leadIdToLead = new Map<Id,Lead>();
        if(!leadIds.isEmpty())
            leadIdToLead = new Map<Id,Lead>([Select Id, Total_Phone_Contacts__c From Lead Where Id IN :leadIds]);

        for(Case theCase : caseIdToCase.values())
        {
            if(idToNoOfCallsForCases.containsKey(theCase.Id))
            {
                if(theCase.Total_Phone_Contacts__c != null)
                    theCase.Total_Phone_Contacts__c = theCase.Total_Phone_Contacts__c + idToNoOfCallsForCases.get(theCase.Id);
                else
                    theCase.Total_Phone_Contacts__c = idToNoOfCallsForCases.get(theCase.Id);
            }
            casesToUpdate.add(theCase);
        }

        for(Contact theContact : contactIdToContact.values())
        {
            if(idToNoOfCallsForLeadsAndContacts.containsKey(theContact.Id))
            {
                if(theContact.Total_Phone_Contacts__c != null)
                    theContact.Total_Phone_Contacts__c = theContact.Total_Phone_Contacts__c + idToNoOfCallsForLeadsAndContacts.get(theContact.Id);
                else
                    theContact.Total_Phone_Contacts__c = idToNoOfCallsForLeadsAndContacts.get(theContact.Id);
            }
           contactsToUpdate.add(theContact);
        }

        for(Lead theLead : leadIdToLead.values())
        {
            if(idToNoOfCallsForLeadsAndContacts.containsKey(theLead.Id))
            {
                if(theLead.Total_Phone_Contacts__c != null)
                    theLead.Total_Phone_Contacts__c = theLead.Total_Phone_Contacts__c + idToNoOfCallsForLeadsAndContacts.get(theLead.Id);
                else
                    theLead.Total_Phone_Contacts__c = idToNoOfCallsForLeadsAndContacts.get(theLead.Id);
            }
           leadsToUpdate.add(theLead);
        }

        try
        {
            if(!casesToUpdate.isEmpty())
                Update casesToUpdate;
            if(!contactsToUpdate.isEmpty())
                Update contactsToUpdate;
            if(!leadsToUpdate.isEmpty())
                Update leadsToUpdate;
        }
        catch(DmlException exp)
        {
            SendExceptionEmail.sendDMLExceptionEmail(exp, 'Unable to Calculate total no of calls on case.');
        }
    }

    public static void populateDateTimeFieldsOnActivity(List<Task> tasks)
    {
        String casePrefix = Case.sObjectType.getDescribe().getKeyPrefix();
        Map<Id,DateTime> caseIdToLastInboundEmailDateTime = new Map<Id,DateTime>();
        Map<Id,DateTime> caseIdToDateTimeLastQueueAssigned = new Map<Id,DateTime>();
        List<Id> caseIds = new List<Id>();
        for(Task theTask : tasks)
        {

            if(theTask.WhatId != null)
            {
                String whatId = theTask.WhatId;
                String objectPrefix = whatId.subString(0,3);

                if(objectPrefix == casePrefix)
                {
                    caseIds.add(theTask.whatId);
                }
            }
        }


        if(!caseIds.isEmpty())
        {
            List<Case> casesWithEmailMessage = [SELECT Id , Date_Time_Last_Queue_Assigned__c ,  (SELECT Id , Incoming , createdDate FROM EmailMessages WHERE Incoming = true order by createdDate desc limit 1) FROM Case WHERE Id IN : caseIds];
            for(Case theCase : casesWithEmailMessage)
            {

                caseIdToDateTimeLastQueueAssigned.put(theCase.Id , theCase.Date_Time_Last_Queue_Assigned__c);
                for(EmailMessage theEmailMessage : theCase.EmailMessages)
                {
                    caseIdToLastInboundEmailDateTime.put(theCase.Id , theEmailMessage.createdDate);
                }
            }
        }


        for(Task theTask : tasks)
        {
          if(theTask.WhatId != null)
          {
              theTask.Date_Time_Last_Queue_Assigned__c = caseIdToDateTimeLastQueueAssigned.get(theTask.WhatId);
              theTask.Date_Time_Last_Inbound_Email__c = caseIdToLastInboundEmailDateTime.get(theTask.WhatId);
          }

        }


    }

    public static List<Task> getTasksWithChangedWhoIds(Map<Id,Task> newTasks , List<Task> oldTasks)
    {

        List<Task> tasksWithChangedWhoId = new List<Task>();
        for(Task theOldTask : oldTasks)
        {
            Task theNewTask = newTasks.get(theOldTask.Id);
            if(theNewTask.WhoId != null && (theOldTask.WhoId != theNewTask.WhoId))
            {
                tasksWithChangedWhoId.add(theNewTask);
            }
        }

        return tasksWithChangedWhoId;
    }

    public static void populateLastCampaignOnActivity(List<Task> tasks)
    {
        Set<Id> theLeadIds = new Set<Id>();
        Set<Id> theContactIds = new Set<Id>();
        for(Task theTask : tasks)
        {
            if(theTask.WhoId != null)
            {
                String whoId = theTask.whoId;
                if(whoId.startsWith('00Q'))
                {
                    theLeadIds.add(theTask.whoId);
                }
                else if (whoId.startsWith('003'))
                {
                    theContactIds.add(theTask.whoId);
                }
            }
        }
        List<Task> tasksToUpdate = new List<Task>();
        if(!theContactIds.isEmpty())
        {
            Map<Id,Contact> contacts = new Map<Id,Contact>([SELECT Id , Sales_opportunity_latest_campaign__c FROM Contact WHERE Id IN :theContactIds]);
            for(Task theTask : tasks)
            {
                if(theTask.whoId != null)
                {
                    if(contacts.containsKey(theTask.whoId))
                    {
                        Task taskToUpdate = new Task(Id = theTask.Id);
                        taskToUpdate.Last_Campaign__c = contacts.get(theTask.whoId).Sales_opportunity_latest_campaign__c;
                        tasksToUpdate.add(taskToUpdate);
                    }
                }
            }
        }
        if(!theLeadIds.isEmpty())
        {
            Map<Id,Lead> leads = new Map<Id,Lead>([SELECT Id, Sales_opportunity_latest_campaign__c FROM Lead WHERE Id IN :theLeadIds]);
            for(Task theTask : tasks)
            {
                if(theTask.whoId != null)
                {
                    if(leads.containsKey(theTask.whoId))
                    {
                        Task taskToUpdate = new Task(Id = theTask.Id);
                        taskToUpdate.Last_Campaign__c = leads.get(theTask.whoId).Sales_opportunity_latest_campaign__c;
                        tasksToUpdate.add(taskToUpdate);
                    }
                }
            }
        }
        if(!tasksToUpdate.isEmpty())
        {
            update tasksToUpdate;
        }
    }



    public static Id salesTaskRecordTypeId
    {
        get
        {
            if(salesTaskRecordTypeId == null)
            {
                List<RecordType> recordTypes = [SELECT Id , DeveloperName FROM RecordType WHERE sObjectType = 'Task' AND DeveloperName = 'Sales_Task'];
                if(!recordTypes.isEmpty())
                    salesTaskRecordTypeId = recordTypes[0].Id;
            }

            return salesTaskRecordTypeId;
        }
        set;
    }
    public static void updateLeadOrContactFlag(List<Task> tasks)
    {
        Map<Id,Contact> contactsToUpdate = new Map<Id,Contact>();
        Map<Id,Lead> leadsToUpdate = new Map<Id,Lead>();
        Map<Id, Opportunity> oppsToUpdate = new Map<Id, Opportunity>();
        List<Opportunity> oppsToQuery = new List<Opportunity>();
        
        for(Task theTask : tasks)
        {
            if(theTask.WhoId != null && theTask.RecordTypeId == salesTaskRecordTypeId)
            {
                String whoId = theTask.whoId;
                if(whoId.startsWith('00Q'))
                {
                    leadsToUpdate.put(theTask.whoId , new Lead(Id = theTask.whoId , Updated_By_Tealium__c = false ));
                }
                else if (whoId.startsWith('003'))
                {
                    contactsToUpdate.put(theTask.whoId , new Contact(Id = theTask.whoId , Updated_By_Tealium__c = false , Last_Sales_Activity__c = DateTime.now()));
                }
            }
            else
            if (theTask.WhatId != null && theTask.RecordTypeId == salesTaskRecordTypeId) {
                String whatId = theTask.WhatId;
                if (whatId.startsWith('006')) {
                    oppsToUpdate.put(theTask.WhatId, new Opportunity(Id = theTask.WhatId, Updated_By_Tealium__c = false ));
                }
            }
        }
        if (!oppsToUpdate.isEmpty()) {
            oppsToQuery = [SELECT Id, Contact__c FROM Opportunity WHERE Id IN :oppsToUpdate.keySet()];
            for (Opportunity opp : oppsToQuery) {
                
                contactsToUpdate.put(opp.Contact__c, new Contact(Id = opp.Contact__c, Updated_By_Tealium__c = false, Last_Sales_Activity__c = DateTime.now()));
            }
            update oppsToUpdate.values();
        }
        
        if(!leadsToUpdate.isEmpty())
           update leadsToUpdate.values();

        if(!contactsToUpdate.isEmpty())
            update contactsToUpdate.values();


    }

    public static void updateLeadOrOpportunityStatus(List<Task> tasks)
    {
        Map<Id,Opportunity> opportunitiesToUpdate = new Map<Id,Opportunity>();
        Map<Id,Lead> leadsToUpdate = new Map<Id,Lead>();
        Set<Id> nleadIds = new Set<Id>();
        Set<Id> opportunityIds = new Set<Id>();
        SEAD_Configuration__c theConfig = SEADUtilityLibrary.getConfig();
        if(theConfig != null)
        {
            for(Task theTask : tasks)
            {
                if((theTask.WhoId != null || theTask.WhatId != null) && theTask.RecordTypeId == salesTaskRecordTypeId)
                {
                    String whoId = theTask.whoId;
                    String whatId = theTask.whatId;

                    if(whoId != null && whoId.startsWith('00Q'))
                    {
                        nleadIds.add(whoId);

                    }
                    else if (whatId != null && whatId.startsWith('006'))
                    {
                        opportunityIds.add(whatId);

                    }
                }
            }
            List<Lead> queriedLeads = [SELECT Id , status, (SELECt Id FROM Tasks) FROM Lead WHERE Id IN :nleadIds];
            for(Lead theLead : queriedLeads)
            {
                if (theLead.status == null || theLead.status == 'Closed Lost'){
                if(theLead.tasks.size() <= theConfig.Lead_New_Stage_Activity_Limit__c)
                {
                    leadsToUpdate.put(theLead.Id , new Lead(Id = theLead.Id , Status = 'New', Closed_Lost_Reason__c =''));
                }
                else if(theLead.tasks.size() == theConfig.Lead_Qualified_Stage_Activity_Limit__c)
                {
                    leadsToUpdate.put(theLead.Id , new Lead(Id = theLead.Id , Status = 'Qualified', Closed_Lost_Reason__c =''));
                }
                else if(theLead.tasks.size() >= theConfig.Lead_Validated_Stage_Activity_Minimum__c)
                {
                        leadsToUpdate.put(theLead.Id , new Lead(Id = theLead.Id , Status = 'Validated', Closed_Lost_Reason__c =''));
                }
                }
                else if (theLead.status == 'New'){
                    if(theLead.tasks.size() == theConfig.Lead_Qualified_Stage_Activity_Limit__c)
                    {
                        leadsToUpdate.put(theLead.Id , new Lead(Id = theLead.Id , Status = 'Qualified'));
                    }
                    else if(theLead.tasks.size() >= theConfig.Lead_Validated_Stage_Activity_Minimum__c)
                    {
                        leadsToUpdate.put(theLead.Id , new Lead(Id = theLead.Id , Status = 'Validated'));
                    }
                }
                else if (theLead.status == 'Qualified'){
                    if(theLead.tasks.size() >= theConfig.Lead_Validated_Stage_Activity_Minimum__c)
                    {
                        leadsToUpdate.put(theLead.Id , new Lead(Id = theLead.Id , Status = 'Validated'));
                    }
                }
            }

            List<Opportunity> queriedOpportunities = [SELECT Id , (SELECT Id FROM Tasks) FROM Opportunity WHERE Id IN :opportunityIds AND OnBoarding__c =false];
            for(Opportunity theOpportunity : queriedOpportunities)
            {
                if(theOpportunity.tasks.size() <= theConfig.Opp_New_Stage_Activity_Limit__c)
                {
                    opportunitiesToUpdate.put(theOpportunity.Id , new Opportunity(Id = theOpportunity.Id , StageName = 'New'));
                }
                else if(theOpportunity.tasks.size() == theConfig.Opp_Qualified_Stage_Activity_Limit__c)
                {
                    opportunitiesToUpdate.put(theOpportunity.Id , new Opportunity(Id = theOpportunity.Id , StageName = 'Qualified'));
                }
                else if(theOpportunity.tasks.size() >= theConfig.Opp_Validated_Stage_Activity_Minimum__c)
                {
                    opportunitiesToUpdate.put(theOpportunity.Id , new Opportunity(Id = theOpportunity.Id , StageName = 'Validated'));
                }
            }

            if(!leadsToUpdate.isEmpty())
               update leadsToUpdate.values();

            if(!opportunitiesToUpdate.isEmpty())
                update opportunitiesToUpdate.values();
        }
    }
    public static void mergeGenesysTaskToSalesInteraction(List<Task> tasks)
    {
        Integer logInteractionDays = Integer.valueOf(UtilityLibrary.getConfig().Log_Interaction_Days_Threshold__c);
        Datetime startTime = system.now().addDays(logInteractionDays);
        Datetime endTime = system.now();
        List<String> allFieldNames = new List<String>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.Task.FieldSets.Merge_Task_Fields.getFields();
        List<Task> genTasksToUpdate= new List<Task>();

        for(Schema.FieldSetMember field : fieldSet)
        {
            allFieldNames.add(field.getFieldPath());
        }

        for(Task theTask : tasks)
        {
            if(theTask.RecordTypeId == salesTaskRecordTypeId && theTask.Start_Order_Decline_Flow__c == true)
            {
                String query= 'SELECT ' + String.join(allFieldNames,',') + ', whoId, whatId FROM Task WHERE ' +
                        '(CreatedDate >=: startTime and CreatedDate <=: endTime) order by createdDate desc LIMIT 1';
                system.debug('theQuery ' + query);
                List<Task> genTasks = Database.query(query);
                system.debug('genTasks ' + genTasks);
                if(genTasks != null && genTasks.size()>0)
                {
                    Task genTask = genTasks[0];
                    for(Schema.FieldSetMember fieldSetMember : SObjectType.Task.FieldSets.Merge_Task_Fields.getFields())
                    {
                        String fieldName = fieldSetMember.getFieldPath();
                        genTask.put(fieldName, theTask.get(fieldName));
                    }
                    theTask.Marked_for_Delete__c = true;
                    genTasksToUpdate.add(genTask);
                }
            }
        }
        if(!genTasksToUpdate.isEmpty())
        {
            update genTasksToUpdate;
        }
    }
}