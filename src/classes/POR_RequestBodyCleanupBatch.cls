/*
Author		: Padma S
Story 		: D-07334,B-37176
Description	: This is a bach job to delete all the records older than 3 months from the POR Request object
*/
global class POR_RequestBodyCleanupBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator Start (Database.BatchableContext BC) {
        
        return Database.getQueryLocator ([SELECT ID from POR_Request__c Where createdDate >=: System.TODAY().adddays(-90)]);
    }
    
    global void Execute (Database.BatchableContext BC, List<POR_Request__c> Scope) {
        
        try{
            delete Scope;
        }
        catch(Exception e){ SendExceptionEmail_ltng.createErrorLog(e.getMessage(), null, null, null, null, null,null, null, UserInfo.getUserId()); }
        
    }
    
    global void Finish(Database.BatchableContext BC) {
        
    }
    
    
    
    
}