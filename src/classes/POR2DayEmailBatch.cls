global class POR2DayEmailBatch implements Database.Batchable<sObject> {

    String query;
    String STATUS_NEW = 'New';
    String CLOSED = 'Closed';
    String UPDATED_BY_CUST = 'Updated by Customer';
    String RESEARCHING = 'Researching';
    String WAIT_FOR_CUST = 'Waiting on Customer';
    String FIRST_EMAIL = '1st Email Sent';
    String SECOND_EMAIL = '2nd Email Sent';
    final String PROBLEM_CASE_RECORD_TYPE = 'Problem_Case';
    Integer hoursFor2ndEmail = Integer.ValueOf(POR_case_routing_queues__c.getInstance('Power of Attorney').X2nd_Email_hours__c);

    global POR2DayEmailBatch()
    {
        query = 'SELECT Id , Product2__c FROM Case WHERE (Status =: STATUS_NEW) AND'; 
        query = query + ' POR_Email_Status__c = :FIRST_EMAIL AND POR_Email_Status__c != :SECOND_EMAIL AND '; 
        query = query + ' Hours_Since_Creation__C >= :hoursFor2ndEmail AND RecordType.DeveloperName = :PROBLEM_CASE_RECORD_TYPE';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Case> scope)
    {
        List<Case> casesToUpdate = new List<Case>();
        for(Case theCase : scope)
        {
            theCase.POR_Email_Status__c = SECOND_EMAIL;
            casesToUpdate.add(theCase);
        }
        try
        {
            POREmailSender emailSender = new POREmailSender();
            emailSender.sendEmailsToCustomer(scope);
            system.debug(casesToUpdate);
            Update casesToUpdate;
        }
        catch(DMLException exp)
        {
            SendExceptionEmail.sendDMLExceptionEmail(exp, ProblemOrderConstants.PROBLEM_CASE_ERROR_MESSAGE);
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }

}