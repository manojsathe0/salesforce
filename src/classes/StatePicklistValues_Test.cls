@isTest
private class StatePicklistValues_Test {
    @testSetup
    private static void setupTestData() {
        // Create Admin User
        TestUtils.createUser('adminuser' + DateTime.now().getTime(), [SELECT Id FROM Profile WHERE Name ='SYStem Administrator' LIMIT 1].Id,true);
        
        List<StatesMap__c> stateMapList = new List<StatesMap__c>();
        stateMapList.add(new StatesMap__c (Name='NewYork',Is_State__c=true, State_code__c='ny', State_Id__c=78));
        stateMapList.add(new StatesMap__c (Name='Texas',Is_State__c=true, State_code__c='tx', State_Id__c=10));
        insert stateMapList;
    }
    
    @isTest private static void getStateNames1() {
        User u =[SELECT Id, Name FROM User WHERE profile.Name = 'SYStem Administrator' And IsActive=true LIMIT 1];
        List<StatesMap__c> stateMapL;
        system.runAs(u){
            Test.startTest();  
            	stateMapL = new List<StatesMap__c>();
            	stateMapL = StatePicklistValues.getStateNames();
            Test.stopTest();
            system.assert(stateMapL!=null);
        }
    }
}