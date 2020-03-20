trigger CT_CaseTrigger on Case (after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
/*
    CT_ITriggerHandler.ICaseTriggerHandler handler;
    if(Trigger.isInsert && Trigger.isBefore)
    {
        try
        {
            handler = new CT_CaseTriggerHandler(Trigger.isExecuting, Trigger.size);
            handler.OnBeforeInsert(Trigger.new);
        }
        catch(CT_BaseApplicationException bae)
        {
            for(Integer iLoop=0;iLoop<Trigger.size;iLoop++)
            Trigger.new[iLoop].addError(bae.UserFriendlyMessage);
        }
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        // Currently Not In Use
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        // Currently unsupported by ICaseTriggerHandler
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        // Currently Not In Use
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        // Currently unsupported by ICaseTriggerHandler
    }
    else if(Trigger.isDelete && Trigger.isAfter){
        // Currently unsupported by ICaseTriggerHandler
    }
    else if(Trigger.isUnDelete){
        // Currently unsupported by ICaseTriggerHandler
    }
*/
}