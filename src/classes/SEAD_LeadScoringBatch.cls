/*
Author   : Padma S
Story    : B-18708
Description : This is a  batch job to update the Lead scoring based on custom settings 'SEAD Scoring Time' and  'SEAD Scoring Percent'
*/
global class SEAD_LeadScoringBatch implements Database.Batchable<sObject>{

    
    
    global Database.QueryLocator Start (Database.BatchableContext BC){
        
        return Database.getQueryLocator ([SELECT Id, Name,Questionnaire_End_Time__c,Website_End_Time__c,My_Account_End_Time__c,Lead_Score2__c ,LeadSource, Questionnaire_Percent_Complete__c,HasOptedOutOfEmail,
                                          (SELECT Id,Createddate,TimesOpened FROM EmailStatuses WHERE createddate <:datetime.now().addHours(-48) AND TimesOpened =0 ),
                                          (SELECT Id FROM Tasks WHERE Contact_Status__c IN ('VM - Left Voicemail Message','NM - No Voicemail Message Left'))
                                          FROM Lead 
                                          WHERE (Questionnaire_End_Time__c >= :datetime.now().addHours(-49)
                                             OR Website_End_Time__c >=:datetime.now().addHours(-49)
                                             OR My_Account_End_Time__c >=:datetime.now().addHours(-49) 
                                             OR LastActivityDate >=: System.TODAY().adddays(-2))                                            
                                            ]);
    }
    
    global void Execute (Database.BatchableContext BC, List<Lead> Scope){
        
       
       
            
            LeadService.populateLeadScore( Scope, true);
       
        
        
    }
    
    global void Finish (Database.BatchableContext BC ){
    
        
    }
}