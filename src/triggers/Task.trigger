trigger Task on Task (after insert , after update , before insert , before update)
{

    if(Trigger.isBefore && Trigger.isInsert)
    {
        TaskService.populateTaskFields(Trigger.new);
        TaskService.populateFieldsForMessageBusActivity(Trigger.New);
        TaskService.populateFieldsForOrderNoteActivity(Trigger.new);
        TaskService.populateLeadScoreOnTask(Trigger.new);
        TaskService.updateLeadOrContactFlag(Trigger.new);
        //Below are new ones
        TaskService.populateDateTimeFieldsOnActivity(Trigger.new); //only applicable to Case Activity for Sales.Type=Email
        TaskService.mergeGenesysTaskToSalesInteraction(Trigger.new);
    }
    else if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            //Keep in same order as some function may be dependent on previous function
            TaskService.countNumberOfCalls(Trigger.new);
            TaskService.checkForProblemOrderTasks(Trigger.new);
            TaskService.updateCampaignMemberStatus(Trigger.new);
            TaskService.processForCampaigns(Trigger.newMap);
            TaskService.populateLastCampaignOnActivity(Trigger.new);
            TaskService.createOrderMatchingActivities(Trigger.new);
            TaskService.updateLeadOrOpportunityStatus(Trigger.new);
        }
        if(Trigger.isUpdate)
        {
            List<Task> tasksWithChangedWhoIds = TaskService.getTasksWithChangedWhoIds(Trigger.newMap , Trigger.old);
            if(!tasksWithChangedWhoIds.isEmpty())
            {
                TaskService.countNumberOfCalls(tasksWithChangedWhoIds);
                TaskService.updateCampaignMemberStatus(tasksWithChangedWhoIds);
                if(UserInfo.getName() != 'Integration User')
                {
                    TaskService.processForCampaigns(new Map<Id,Task>(tasksWithChangedWhoIds));
                    TaskService.populateLastCampaignOnActivity(tasksWithChangedWhoIds);
                }
            }
            if(!OrderService.hasLeadConvertStarted)
            {
                OrderService.hasLeadConvertStarted = false;
                TaskService.createOrderMatchingActivities(Trigger.new);

            }
        }

    }


    if(Trigger.isBefore && Trigger.isUpdate)
    {

        List<Task> tasksWithChangedWhoIds = TaskService.getTasksWithChangedWhoIds(Trigger.newMap , Trigger.old);
        if(!tasksWithChangedWhoIds.isEmpty())
        {
            TaskService.updateLeadOrContactFlag(Trigger.new);
            TaskService.populateLeadScoreOnTask(tasksWithChangedWhoIds);

        }

        Set<Id> profileIds = TaskService.getIdsToEdit();
        system.debug(profileIds);
        system.debug(UserInfo.getProfileId());
        If(!profileIds.contains(UserInfo.getProfileId()))
            TaskService.preventOrderNoteEdit(Trigger.oldMap, Trigger.newMap);
    }
}