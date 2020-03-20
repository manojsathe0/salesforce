public with sharing class EmailIncomingCreateTask 
{
    public static final String SOBJECT_TYPE = 'Task';
    public static final String RECORDTYPE_DEVNAME = 'CC_Task';
    
    public static void createTask(List<EmailMessage> newEmail)
    {
        List<Task> createNewTaskList = new List<Task>();
        List<case> casesToUpdate = new List<Case>();
        Set<Id> caseId = new Set<Id>();
        try
        {
            for(EmailMessage email : newEmail)
            {
                caseId.add(email.ParentId);
            }
            
            Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, Queue__c, Number_Inbound_Emails__c FROM Case WHERE Id =: caseId]);
            String emailBody = '';
            for(EmailMessage email : newEmail)
            {
                if(email.Incoming == true)
                {
                    if(email.HtmlBody != null)
                    {
                        emailBody = email.HtmlBody;
                    }
                    else if(email.TextBody != null)
                    {
                        emailBody = email.TextBody;
                    }
                    createNewTaskList = EmailFunction.createTask(email.Subject, emailBody, null, null, null, null, null, null, 'Incoming', null, 
                                         caseMap.get(email.ParentId).Queue__c, 'New', email.ParentId, null, false);

                    Case caseToUpdate = new Case(Id = email.ParentId);
                    caseToUpdate.Number_Inbound_Emails__c = caseMap.get(email.ParentId).Number_Inbound_Emails__c + 1;
                    casesToUpdate.add(caseToUpdate);
                }
                
            }
            insert createNewTaskList;
            update casesToUpdate;
        }
        catch(Exception ex)
        {
            System.debug('>>>>> EmailIncomingCreateTask Error Message : '+ex.getMessage());
        }
    }
}