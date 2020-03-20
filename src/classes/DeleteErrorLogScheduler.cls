/*Story: B-36114*/
global class DeleteErrorLogScheduler implements Schedulable {
    global String deleteErrorLogBeforeDate;
    global String query;     
    global void execute(SchedulableContext ctx) {
        List<Date_Reference__mdt> errorLogConstant = [SELECT Id, Days__c FROM Date_Reference__mdt WHERE DeveloperName = 'Error_Log_Constant'];    
        
        if(errorLogConstant.size() > 0){
            deleteErrorLogBeforeDate = System.now().addDays(-Integer.valueOf(errorLogConstant[0].Days__c)).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        }
        
        query = 'SELECT Id FROM Error_Log__c WHERE CreatedDate < ' + deleteErrorLogBeforeDate;
        
        DeleteErrorLog errorLogBatch = new DeleteErrorLog(query);
        Id errorLogBatchId = Database.executeBatch(errorLogBatch, 2000);
    }
}