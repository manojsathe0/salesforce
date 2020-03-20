public with sharing class StatePicklistValues {
    @AuraEnabled(cacheable=true)
    public static List<StatesMap__c> getStateNames(){
        return [SELECT Name, Is_State__c, State_code__c, State_Id__c FROM StatesMap__c ORDER BY Is_State__c DESC, Name ASC LIMIT 1000];
    }
}