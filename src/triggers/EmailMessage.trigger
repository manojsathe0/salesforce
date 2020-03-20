trigger EmailMessage on EmailMessage (before insert , after insert) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        EmailAttachmentCaseCls.emailMessageAttachmentCaseBeforeInsert(Trigger.new);
        EmailIncomingCreateTask.createTask(Trigger.new);
    }
    else if(Trigger.isAfter && Trigger.isInsert)
    {
       ProblemOrderRoutingService.countNumberOfOutboundEmails(Trigger.new);
       Map<Id,EmailMessage> nonAutoResponseEmailMessages = USPTOHandler.getNonAutoResponseEmailMessages(Trigger.new);
       if(!nonAutoResponseEmailMessages.isEmpty())
       {
            if(!USPTOHandler.hasUSPTOTriggerRun)
            {
                USPTOHandler theHandler = new USPTOHandler();
                theHandler.processEmails(nonAutoResponseEmailMessages);
            }
       }
    }
         
}