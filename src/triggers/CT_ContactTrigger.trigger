trigger CT_ContactTrigger on Contact (after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
    CT_ITriggerHandler.IContactTriggerHandler handler;
    if(Trigger.isInsert && Trigger.isBefore)
    {
        // Currently unsupported by IContactTriggerHandler
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        try
        {
            handler = new CT_ContactTriggerHandler(Trigger.isExecuting, Trigger.size);
            handler.OnAfterInsert(Trigger.new);
        }
        catch(CT_BaseApplicationException bae)
        {
            for(Integer iLoop=0;iLoop<Trigger.size;iLoop++)
            Trigger.new[iLoop].addError(bae.UserFriendlyMessage);
        }
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        // Currently unsupported by IContactTriggerHandler
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        try
        {
            handler = new CT_ContactTriggerHandler(Trigger.isExecuting, Trigger.size);
            handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
        }
        catch(CT_BaseApplicationException bae)
        {
            for(Integer iLoop=0;iLoop<Trigger.size;iLoop++)
            Trigger.new[iLoop].addError(bae.UserFriendlyMessage);
        }
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        // Currently unsupported by IContactTriggerHandler
    }
    else if(Trigger.isDelete && Trigger.isAfter){
        // Currently unsupported by IContactTriggerHandler
    }
    else if(Trigger.isUnDelete){
        // Currently unsupported by IContactTriggerHandler
    }

}