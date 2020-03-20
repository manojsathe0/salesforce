/*
    Batch class to populate Opp score, based on Custom Settings data.
    Created By: Artyom M.
    Per Stories: B-18405, B-18411
*/
global class SEAD_OppScoringBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator Start (Database.BatchableContext BC) {
        Integer hours = 49;
        DateTime cutOffTime = DateTime.Now().addHours(hours * -1);
        return Database.getQueryLocator ([SELECT Id, Name, Questionnaire_End_Time__c, Website_End_Time__c, My_Account_End_Time__c, Base_Score__c, LeadSource, Questionnaire_Percent_Complete__c, HasOptedOutOfEmail__c,
                                          
                                          (SELECT Id FROM Tasks WHERE Contact_Status__c IN ('VM - Left Voicemail Message','NM - No Voicemail Message Left'))
                                          FROM Opportunity  
                                          WHERE (Questionnaire_End_Time__c >= :cutOffTime
                                             OR Website_End_Time__c >=:cutOffTime
                                             OR My_Account_End_Time__c >=:cutOffTime 
                                             OR LastActivityDate >=: System.TODAY().adddays(-2)) AND    OnBoarding__c = false                                            
                                            ]);
    }
    
    global void Execute (Database.BatchableContext BC, List<Opportunity> Scope){
        OpportunityService.populateOppScore(Scope, true);
    }
    
    global void Finish (Database.BatchableContext BC ){
    
    }
    //(SELECT Id, Createddate, TimesOpened FROM EmailStatuses WHERE createddate <:datetime.now().addHours(-48) AND TimesOpened =0 ),
}