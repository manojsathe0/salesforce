/*Story: B-36114*/
global class DeleteErrorLog implements Database.Batchable<sObject> {
    global final String Query; 
    
    global DeleteErrorLog(String q){
        query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Error_Log__c> scope){
        delete scope;   
        Database.emptyRecycleBin(scope);            
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}